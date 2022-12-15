FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

### Install Dependencies
RUN apt-get -qq update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y -qq install --no-install-recommends wget dirmngr software-properties-common libgdal-dev libudunits2-dev

### Install R
RUN wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc \
    && add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/" \
    && apt install -y r-base

### Install Quarto
RUN wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.2.269/quarto-1.2.269-linux-amd64.deb \
    && dpkg -i quarto-1.2.269-linux-amd64.deb

### Install R packages
RUN Rscript -e "install.packages(c('tidyverse', 'purrr', 'sf', 'tmap'), clean=T, quiet=T)"

ENTRYPOINT [ "quarto", "render" ]
