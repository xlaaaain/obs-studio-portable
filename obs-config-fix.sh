#!/usr/bin/bash

home_dir="$(getent passwd $(id -u) | awk '{print $6}' FS=':')"
OBS_CONFIG_DIR="/opt/obs-portable/config"
OBS_USER_CONFIG_DIR="/run/host/${home_dir}/.config/obs-portable"

if ! [ -d "${OBS_USER_CONFIG_DIR}" ]; then
    mkdir "${OBS_USER_CONFIG_DIR}"
fi

if ! [ -d "${OBS_CONFIG_DIR}" ]; then
    sudo mkdir "${OBS_CONFIG_DIR}"
fi

if ! findmnt "${OBS_CONFIG_DIR}"; then
    sudo mount --bind \
        "${OBS_USER_CONFIG_DIR}" \
        "${OBS_CONFIG_DIR}"
fi

# Adding permissions fix to run as rootless
# Get the UID and GID of the current user
USER_UID=$(id -u)
USER_GID=$(id -g)

# Change ownership of the /opt/obs-portable directory to the current user
sudo chown -R ${USER_UID}:${USER_GID} /opt/obs-portable
