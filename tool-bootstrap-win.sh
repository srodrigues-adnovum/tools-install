#!/usr/bin/env bash
set -euo pipefail
install() {
    echo "   _____ _ _     ____            _"
    echo "  / ____(_) |   |  _ \\          | |"
    echo " | |  __ _| |_  | |_) | __ _ ___| |__"
    echo " | | |_ | | __| |  _ < / _\` / __| '_ \\"
    echo " | |__| | | |_  | |_) | (_| \\__ \\ | | |"
    echo "  \\_____|_|\\__| |____/ \\__,_|___/_| |_|"
    echo ""
    echo "[uninstall] [remove plugins]"
    echo "  - jq" && asdf plugin-remove jq || true
    echo "  - java" && asdf plugin-remove java || true
    echo "  - nodejs" && asdf plugin-remove nodejs || true
    echo "  - kustomize" && asdf plugin-remove kustomize || true
    echo "  - helm" && asdf plugin-remove helm || true
    echo "  - kubectl" && asdf plugin-remove kubectl || true
    echo "  - terraform" && asdf plugin-remove terraform || true
    echo "  - kubectx" && asdf plugin-remove kubectx || true
    echo "  - k9s" && asdf plugin-remove k9s || true
    echo "  - kops" && asdf plugin-remove kops || true
    echo "  - python" && asdf plugin-remove python || true
    echo "  - ruby" && asdf plugin-remove ruby || true
    echo "  - docker-compose" && asdf plugin-remove docker-compose || true
    echo "[install] [add plugins]"
    echo "  - jq" && asdf plugin-add jq git@github.com:srodrigues-adnovum/asdf-jq || true
    echo "  - java" && asdf plugin-add java git@github.com:srodrigues-adnovum/asdf-java || true
    echo "  - nodejs" && asdf plugin-add nodejs git@github.com:srodrigues-adnovum/asdf-nodejs || true
    echo "  - kustomize" && asdf plugin-add kustomize git@github.com:srodrigues-adnovum/asdf-kustomize || true
    echo "  - helm" && asdf plugin-add helm git@github.com:srodrigues-adnovum/asdf-helm || true
    echo "  - kubectl" && asdf plugin-add kubectl git@github.com:srodrigues-adnovum/asdf-kubectl || true
    echo "  - terraform" && asdf plugin-add terraform git@github.com:srodrigues-adnovum/asdf-hashicorp || true
    echo "  - kubectx" && asdf plugin-add kubectx git@github.com:srodrigues-adnovum/asdf-kubectx || true
    echo "  - k9s" && asdf plugin-add k9s git@github.com:srodrigues-adnovum/asdf-k9s || true
    echo "  - kops" && asdf plugin-add kops git@github.com:srodrigues-adnovum/asdf-kops || true
    echo "  - python" && asdf plugin-add python git@github.com:srodrigues-adnovum/asdf-python || true
    echo "  - ruby" && asdf plugin-add ruby git@github.com:srodrigues-adnovum/asdf-ruby || true
    echo "  - docker-compose" && asdf plugin-add docker-compose git@github.com:srodrigues-adnovum/asdf-docker-compose || true
    echo "[install] [update plugins]" && asdf plugin update --all
    echo "[install] [invoke asdf install]" && asdf install

    echo "[post-install] [process tool-bootstrap.sh]"
    #execute all that is on tool-bootstrap.sh after the asdf install line
    sed '/^#!/,/^asdf install/d' tool-bootstrap.sh | bash -

    #on the tool-bootstrap.sh we are installing aws cli, we need to add the Scripts folder to path
    echo "[post-install] [Remove pip Scripts folder from Path]"
    sed -i '/# pip_path/,/# \/pip_path/d' ~/.bash_profile

    echo "[post-install] [Add pip Scripts folder to Path]"
    # Extract the installation location from the pip show output
    pip_path=$(pip show awscli | awk '/^Location:/ {print $2}' | sed -e 's/\\/\//g; s/^C:/\/c/; s/site-packages$/Scripts/')
    if [ -n "${pip_path}" ]; then
    echo "  - pip package directory : ${pip_path}"
    cat <<EOF >> ~/.bash_profile

# pip_path
export PATH=\${PATH}:${pip_path}
# /pip_path
EOF
    fi
    echo "[done]"
}

install
