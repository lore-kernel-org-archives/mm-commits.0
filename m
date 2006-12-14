From: akpm@osdl.org
Subject: + disable-init-initramfsc-updated.patch added to -mm tree
Date: Thu, 14 Dec 2006 13:39:33 -0800
Message-ID: <200612142139.kBELdXC4028925@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:60835 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932942AbWLNVji (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 16:39:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jean-paul.saman@nxp.com, linux-arch@vger.kernel.org, viro@zeniv.linux.org.uk


The patch titled
     disable init/initramfs.c
has been added to the -mm tree.  Its filename is
     disable-init-initramfsc-updated.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Jean-Paul Saman <jean-paul.saman@nxp.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/block/Kconfig |    4 ++-
 init/Kconfig          |    4 +++
 init/Makefile         |    8 +++++--
 init/noinitramfs.c    |   42 ++++++++++++++++++++++++++++++++++++++++
 usr/Makefile          |    2 -
 5 files changed, 56 insertions(+), 4 deletions(-)

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
@@ -17,4 +22,3 @@ clean-files := ../include/linux/compile.
 
 $(obj)/main.o: include/linux/compile.h
 $(obj)/version.o: include/linux/compile.h
-
diff -puN /dev/null init/noinitramfs.c
--- /dev/null
+++ a/init/noinitramfs.c
@@ -0,0 +1,42 @@
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
+#include <linux/fs.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/fcntl.h>
+#include <linux/delay.h>
+#include <linux/string.h>
+#include <linux/syscalls.h>
+
+/*
+ * Create a simple rootfs that is similar to the default initramfs
+ */
+static void __init default_rootfs(void)
+{
+	int mkdir_err = sys_mkdir("/dev", 0755);
+	int err = sys_mknod((const char __user *) "/dev/console",
+				S_IFCHR | S_IRUSR | S_IWUSR,
+				new_encode_dev(MKDEV(5, 1)));
+	if (err == -EROFS)
+		printk("Warning: Failed to create a rootfs\n");
+	mkdir_err = sys_mkdir("/root", 0700);
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

disable-init-initramfsc-updated.patch
disable-init-initramfsc-architectures.patch

