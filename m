From: akpm@linux-foundation.org
Subject: - disable-init-initramfsc-updated.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:50:13 -0800
Message-ID: <200702112250.l1BMoD2b015838@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59999 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932713AbXBKWu2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:50:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jean-paul.saman@nxp.com, frederik.deweerdt@gmail.com, linux-arch@vger.kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     disable init/initramfs.c
has been removed from the -mm tree.  Its filename was
     disable-init-initramfsc-updated.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: disable init/initramfs.c
From: Jean-Paul Saman <jean-paul.saman@nxp.com>

The file init/initramfs.c is always compiled and linked in the kernel
vmlinux even when BLK_DEV_RAM and BLK_DEV_INITRD are disabled and the
system isn't using any form of an initramfs or initrd.  In this situation
the code is only used to unpack a (static) default initial rootfilesystem. 
The current init/initramfs.c code.  usr/initramfs_data.o compiles to a size
of ~15 kbytes.  Disabling BLK_DEV_RAM and BLK_DEV_INTRD shrinks the kernel
code size with ~60 Kbytes.

This patch avoids compiling in the code and data for initramfs support if
CONFIG_BLK_DEV_INITRD is not defined.  Instead of the initramfs code and
data it uses a small routine in init/noinitramfs.c to setup an initial
static default environment for mounting a rootfilesystem later on in the
kernel initialisation process.  The new code is: 164 bytes of size.

The patch is separated in two parts:
1) doesn't compile initramfs code when CONFIG_BLK_DEV_INITRD is not set
2) changing all plaforms vmlinux.lds.S files to not reserve an area of
PAGE_SIZE when CONFIG_BLK_DEV_INITRD is not set.

[deweerdt@free.fr: warning fix]
Signed-off-by: Jean-Paul Saman <jean-paul.saman@nxp.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/Kconfig |    4 ++-
 init/Kconfig          |    4 +++
 init/Makefile         |    7 ++++-
 init/noinitramfs.c    |   52 ++++++++++++++++++++++++++++++++++++++++
 usr/Makefile          |    2 -
 5 files changed, 66 insertions(+), 3 deletions(-)

diff -puN drivers/block/Kconfig~disable-init-initramfsc-updated drivers/block/Kconfig
--- a/drivers/block/Kconfig~disable-init-initramfsc-updated
+++ a/drivers/block/Kconfig
@@ -417,8 +417,10 @@ config BLK_DEV_INITRD
 	  etc. See <file:Documentation/initrd.txt> for details.
 
 	  If RAM disk support (BLK_DEV_RAM) is also included, this
-	  also enables initial RAM disk (initrd) support.
+	  also enables initial RAM disk (initrd) support and adds
+	  15 Kbytes (more on some other architectures) to the kernel size.
 
+	  If unsure say Y.
 
 config CDROM_PKTCDVD
 	tristate "Packet writing on CD/DVD media"
diff -puN init/Kconfig~disable-init-initramfsc-updated init/Kconfig
--- a/init/Kconfig~disable-init-initramfsc-updated
+++ a/init/Kconfig
@@ -280,8 +280,12 @@ config RELAY
 
 	  If unsure, say N.
 
+if BLK_DEV_INITRD
+
 source "usr/Kconfig"
 
+endif
+
 config CC_OPTIMIZE_FOR_SIZE
 	bool "Optimize for size (Look out for broken compilers!)"
 	default y
diff -puN init/Makefile~disable-init-initramfsc-updated init/Makefile
--- a/init/Makefile~disable-init-initramfsc-updated
+++ a/init/Makefile
@@ -2,7 +2,12 @@
 # Makefile for the linux kernel.
 #
 
-obj-y				:= main.o version.o mounts.o initramfs.o
+obj-y                          := main.o version.o mounts.o
+ifneq ($(CONFIG_BLK_DEV_INITRD),y)
+obj-y                          += noinitramfs.o
+else
+obj-$(CONFIG_BLK_DEV_INITRD)   += initramfs.o
+endif
 obj-$(CONFIG_GENERIC_CALIBRATE_DELAY) += calibrate.o
 
 mounts-y			:= do_mounts.o
diff -puN /dev/null init/noinitramfs.c
--- /dev/null
+++ a/init/noinitramfs.c
@@ -0,0 +1,52 @@
+/*
+ * init/noinitramfs.c
+ *
+ * Copyright (C) 2006, NXP Semiconductors, All Rights Reserved
+ * Author: Jean-Paul Saman <jean-paul.saman@nxp.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#include <linux/init.h>
+#include <linux/stat.h>
+#include <linux/kdev_t.h>
+#include <linux/syscalls.h>
+
+/*
+ * Create a simple rootfs that is similar to the default initramfs
+ */
+static int __init default_rootfs(void)
+{
+	int err;
+
+	err = sys_mkdir("/dev", 0755);
+	if (err < 0)
+		goto out;
+
+	err = sys_mknod((const char __user *) "/dev/console",
+			S_IFCHR | S_IRUSR | S_IWUSR,
+			new_encode_dev(MKDEV(5, 1)));
+	if (err < 0)
+		goto out;
+
+	err = sys_mkdir("/root", 0700);
+	if (err < 0)
+		goto out;
+
+	return 0;
+
+out:
+	printk(KERN_WARNING "Failed to create a rootfs\n");
+	return err;
+}
+rootfs_initcall(default_rootfs);
diff -puN usr/Makefile~disable-init-initramfsc-updated usr/Makefile
--- a/usr/Makefile~disable-init-initramfsc-updated
+++ a/usr/Makefile
@@ -7,7 +7,7 @@ PHONY += klibcdirs
 
 
 # Generate builtin.o based on initramfs_data.o
-obj-y := initramfs_data.o
+obj-$(CONFIG_BLK_DEV_INITRD) := initramfs_data.o
 
 # initramfs_data.o contains the initramfs_data.cpio.gz image.
 # The image is included using .incbin, a dependency which is not
_

Patches currently in -mm which might be from jean-paul.saman@nxp.com are

origin.patch
