Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A912CCA47E
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:59:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233127AbiFQC7q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379893AbiFQC7R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:59:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D0665D20
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:59:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 278CF61CFB
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:59:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 803C1C3411A;
        Fri, 17 Jun 2022 02:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655434752;
        bh=s8X8Y/gAyeFCCZjWgIoVNSPIdKo/m8+Vus7mPbEpNfE=;
        h=Date:To:From:Subject:From;
        b=oPS0eZKi7B2ikMk4xYEEcHkYtMHZGvzHDoO5lO6C902IdX763fcK9+qxwoD97vROi
         QWVsgQVcyX6qUpRgjhtMZ2lgNhLBh9zCcIWPuQowzr83KU3F2TtLAcjPWNmjh/thp8
         s7mmWvvEZPbwh8ySpRYwpwq/qFqf5vL78HTS2jYE=
Date:   Thu, 16 Jun 2022 19:59:11 -0700
To:     mm-commits@vger.kernel.org, walters@verbum.org,
        usama.anjum@collabora.com, pjones@redhat.com,
        lennart@poettering.net, hirofumi@mail.parknet.co.jp,
        ckellner@redhat.com, cccheng@synology.com, alexl@redhat.com,
        javierm@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] selftests-filesystems-add-a-vfat-rename_exchange-test.patch removed from -mm tree
Message-Id: <20220617025912.803C1C3411A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/filesystems: add a vfat RENAME_EXCHANGE test
has been removed from the -mm tree.  Its filename was
     selftests-filesystems-add-a-vfat-rename_exchange-test.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Javier Martinez Canillas <javierm@redhat.com>
Subject: selftests/filesystems: add a vfat RENAME_EXCHANGE test
Date: Fri, 10 Jun 2022 09:57:21 +0200

Add a test for the renameat2 RENAME_EXCHANGE support in vfat, but split it
in a tool that just does the rename exchange and a script that is run by
the kselftests framework on `make TARGETS="filesystems/fat" kselftest`.

That way the script can be easily extended to test other file operations.

The script creates a 1 MiB disk image, that is then formated with a vfat
filesystem and mounted using a loop device.  That way all file operations
are done on an ephemeral filesystem.

Link: https://lkml.kernel.org/r/20220610075721.1182745-5-javierm@redhat.com
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Acked-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Alexander Larsson <alexl@redhat.com>
Cc: Christian Kellner <ckellner@redhat.com>
Cc: Chung-Chiang Cheng <cccheng@synology.com>
Cc: Colin Walters <walters@verbum.org>
Cc: Lennart Poettering <lennart@poettering.net>
Cc: Peter Jones <pjones@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                                               |    1 
 tools/testing/selftests/Makefile                          |    1 
 tools/testing/selftests/filesystems/fat/.gitignore        |    2 
 tools/testing/selftests/filesystems/fat/Makefile          |    7 
 tools/testing/selftests/filesystems/fat/config            |    2 
 tools/testing/selftests/filesystems/fat/rename_exchange.c |   37 ++++
 tools/testing/selftests/filesystems/fat/run_fat_tests.sh  |   82 ++++++++++
 7 files changed, 132 insertions(+)

--- a/MAINTAINERS~selftests-filesystems-add-a-vfat-rename_exchange-test
+++ a/MAINTAINERS
@@ -20891,6 +20891,7 @@ M:	OGAWA Hirofumi <hirofumi@mail.parknet
 S:	Maintained
 F:	Documentation/filesystems/vfat.rst
 F:	fs/fat/
+F:	tools/testing/selftests/filesystems/fat/
 
 VFIO DRIVER
 M:	Alex Williamson <alex.williamson@redhat.com>
--- /dev/null
+++ a/tools/testing/selftests/filesystems/fat/config
@@ -0,0 +1,2 @@
+CONFIG_BLK_DEV_LOOP=y
+CONFIG_VFAT_FS=y
--- /dev/null
+++ a/tools/testing/selftests/filesystems/fat/.gitignore
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+rename_exchange
--- /dev/null
+++ a/tools/testing/selftests/filesystems/fat/Makefile
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0
+
+TEST_PROGS := run_fat_tests.sh
+TEST_GEN_PROGS_EXTENDED := rename_exchange
+CFLAGS += -O2 -g -Wall $(KHDR_INCLUDES)
+
+include ../../lib.mk
--- /dev/null
+++ a/tools/testing/selftests/filesystems/fat/rename_exchange.c
@@ -0,0 +1,37 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Program that atomically exchanges two paths using
+ * the renameat2() system call RENAME_EXCHANGE flag.
+ *
+ * Copyright 2022 Red Hat Inc.
+ * Author: Javier Martinez Canillas <javierm@redhat.com>
+ */
+
+#define _GNU_SOURCE
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+
+void print_usage(const char *program)
+{
+	printf("Usage: %s [oldpath] [newpath]\n", program);
+	printf("Atomically exchange oldpath and newpath\n");
+}
+
+int main(int argc, char *argv[])
+{
+	int ret;
+
+	if (argc != 3) {
+		print_usage(argv[0]);
+		exit(EXIT_FAILURE);
+	}
+
+	ret = renameat2(AT_FDCWD, argv[1], AT_FDCWD, argv[2], RENAME_EXCHANGE);
+	if (ret) {
+		perror("rename exchange failed");
+		exit(EXIT_FAILURE);
+	}
+
+	exit(EXIT_SUCCESS);
+}
--- /dev/null
+++ a/tools/testing/selftests/filesystems/fat/run_fat_tests.sh
@@ -0,0 +1,82 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Run filesystem operations tests on an 1 MiB disk image that is formatted with
+# a vfat filesystem and mounted in a temporary directory using a loop device.
+#
+# Copyright 2022 Red Hat Inc.
+# Author: Javier Martinez Canillas <javierm@redhat.com>
+
+set -e
+set -u
+set -o pipefail
+
+BASE_DIR="$(dirname $0)"
+TMP_DIR="$(mktemp -d /tmp/fat_tests_tmp.XXXX)"
+IMG_PATH="${TMP_DIR}/fat.img"
+MNT_PATH="${TMP_DIR}/mnt"
+
+cleanup()
+{
+    mountpoint -q "${MNT_PATH}" && unmount_image
+    rm -rf "${TMP_DIR}"
+}
+trap cleanup SIGINT SIGTERM EXIT
+
+create_loopback()
+{
+    touch "${IMG_PATH}"
+    chattr +C "${IMG_PATH}" >/dev/null 2>&1 || true
+
+    truncate -s 1M "${IMG_PATH}"
+    mkfs.vfat "${IMG_PATH}" >/dev/null 2>&1
+}
+
+mount_image()
+{
+    mkdir -p "${MNT_PATH}"
+    sudo mount -o loop "${IMG_PATH}" "${MNT_PATH}"
+}
+
+rename_exchange_test()
+{
+    local rename_exchange="${BASE_DIR}/rename_exchange"
+    local old_path="${MNT_PATH}/old_file"
+    local new_path="${MNT_PATH}/new_file"
+
+    echo old | sudo tee "${old_path}" >/dev/null 2>&1
+    echo new | sudo tee "${new_path}" >/dev/null 2>&1
+    sudo "${rename_exchange}" "${old_path}" "${new_path}" >/dev/null 2>&1
+    sudo sync -f "${MNT_PATH}"
+    grep new "${old_path}" >/dev/null 2>&1
+    grep old "${new_path}" >/dev/null 2>&1
+}
+
+rename_exchange_subdir_test()
+{
+    local rename_exchange="${BASE_DIR}/rename_exchange"
+    local dir_path="${MNT_PATH}/subdir"
+    local old_path="${MNT_PATH}/old_file"
+    local new_path="${dir_path}/new_file"
+
+    sudo mkdir -p "${dir_path}"
+    echo old | sudo tee "${old_path}" >/dev/null 2>&1
+    echo new | sudo tee "${new_path}" >/dev/null 2>&1
+    sudo "${rename_exchange}" "${old_path}" "${new_path}" >/dev/null 2>&1
+    sudo sync -f "${MNT_PATH}"
+    grep new "${old_path}" >/dev/null 2>&1
+    grep old "${new_path}" >/dev/null 2>&1
+}
+
+unmount_image()
+{
+    sudo umount "${MNT_PATH}" &> /dev/null
+}
+
+create_loopback
+mount_image
+rename_exchange_test
+rename_exchange_subdir_test
+unmount_image
+
+exit 0
--- a/tools/testing/selftests/Makefile~selftests-filesystems-add-a-vfat-rename_exchange-test
+++ a/tools/testing/selftests/Makefile
@@ -17,6 +17,7 @@ TARGETS += exec
 TARGETS += filesystems
 TARGETS += filesystems/binderfs
 TARGETS += filesystems/epoll
+TARGETS += filesystems/fat
 TARGETS += firmware
 TARGETS += fpu
 TARGETS += ftrace
_

Patches currently in -mm which might be from javierm@redhat.com are


