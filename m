From: akpm@linux-foundation.org
Subject: - remove-fs-jffs2-ioctlc.patch removed from -mm tree
Date: Thu, 08 Mar 2007 01:54:35 -0800
Message-ID: <200703080954.l289sZQ3024622@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34817 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030565AbXCHJ6H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Mar 2007 04:58:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     remove fs/jffs2/ioctl.c
has been removed from the -mm tree.  Its filename was
     remove-fs-jffs2-ioctlc.patch

This patch was dropped because it was nacked by the maintainer

------------------------------------------------------
Subject: remove fs/jffs2/ioctl.c
From: Adrian Bunk <bunk@stusta.de>

fs/jffs2/ioctl.c is already for so long in the "might be used later"
state that I doubt it will ever be actually used...

And if it will ever be used, reverting this patch will be trivial.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/Makefile   |    2 +-
 fs/jffs2/dir.c      |    1 -
 fs/jffs2/file.c     |    1 -
 fs/jffs2/ioctl.c    |   23 -----------------------
 fs/jffs2/os-linux.h |    3 ---
 5 files changed, 1 insertion(+), 29 deletions(-)

diff -puN fs/jffs2/Makefile~remove-fs-jffs2-ioctlc fs/jffs2/Makefile
--- a/fs/jffs2/Makefile~remove-fs-jffs2-ioctlc
+++ a/fs/jffs2/Makefile
@@ -6,7 +6,7 @@
 
 obj-$(CONFIG_JFFS2_FS) += jffs2.o
 
-jffs2-y	:= compr.o dir.o file.o ioctl.o nodelist.o malloc.o
+jffs2-y	:= compr.o dir.o file.o nodelist.o malloc.o
 jffs2-y	+= read.o nodemgmt.o readinode.o write.o scan.o gc.o
 jffs2-y	+= symlink.o build.o erase.o background.o fs.o writev.o
 jffs2-y	+= super.o debug.o
diff -puN fs/jffs2/dir.c~remove-fs-jffs2-ioctlc fs/jffs2/dir.c
--- a/fs/jffs2/dir.c~remove-fs-jffs2-ioctlc
+++ a/fs/jffs2/dir.c
@@ -40,7 +40,6 @@ const struct file_operations jffs2_dir_o
 {
 	.read =		generic_read_dir,
 	.readdir =	jffs2_readdir,
-	.ioctl =	jffs2_ioctl,
 	.fsync =	jffs2_fsync
 };
 
diff -puN fs/jffs2/file.c~remove-fs-jffs2-ioctlc fs/jffs2/file.c
--- a/fs/jffs2/file.c~remove-fs-jffs2-ioctlc
+++ a/fs/jffs2/file.c
@@ -46,7 +46,6 @@ const struct file_operations jffs2_file_
  	.aio_read =	generic_file_aio_read,
  	.write =	do_sync_write,
  	.aio_write =	generic_file_aio_write,
-	.ioctl =	jffs2_ioctl,
 	.mmap =		generic_file_readonly_mmap,
 	.fsync =	jffs2_fsync,
 	.sendfile =	generic_file_sendfile
diff -puN fs/jffs2/ioctl.c~remove-fs-jffs2-ioctlc /dev/null
--- a/fs/jffs2/ioctl.c
+++ /dev/null
@@ -1,23 +0,0 @@
-/*
- * JFFS2 -- Journalling Flash File System, Version 2.
- *
- * Copyright (C) 2001-2003 Red Hat, Inc.
- *
- * Created by David Woodhouse <dwmw2@infradead.org>
- *
- * For licensing information, see the file 'LICENCE' in this directory.
- *
- * $Id: ioctl.c,v 1.10 2005/11/07 11:14:40 gleixner Exp $
- *
- */
-
-#include <linux/fs.h>
-
-int jffs2_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
-		unsigned long arg)
-{
-	/* Later, this will provide for lsattr.jffs2 and chattr.jffs2, which
-	   will include compression support etc. */
-	return -ENOTTY;
-}
-
diff -puN fs/jffs2/os-linux.h~remove-fs-jffs2-ioctlc fs/jffs2/os-linux.h
--- a/fs/jffs2/os-linux.h~remove-fs-jffs2-ioctlc
+++ a/fs/jffs2/os-linux.h
@@ -162,9 +162,6 @@ extern const struct address_space_operat
 int jffs2_fsync(struct file *, struct dentry *, int);
 int jffs2_do_readpage_unlock (struct inode *inode, struct page *pg);
 
-/* ioctl.c */
-int jffs2_ioctl(struct inode *, struct file *, unsigned int, unsigned long);
-
 /* symlink.c */
 extern const struct inode_operations jffs2_symlink_inode_operations;
 
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
git-drm.patch
make-drivers-char-drm-drm_vmcdrm_io_prot-static.patch
git-dvb.patch
saa7134-fix-modules=n-compilation.patch
git-gfs2-nmw.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
remove-fs-jffs2-ioctlc.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
git-ubi.patch
git-netdev-all.patch
drivers-net-vioc-possible-cleanups.patch
drivers-net-bonding-bond_maincmake-3-functions-static.patch
net-uninline-skb_put-fix.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-aacraid-cleanups.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
git-unionfs.patch
git-wireless.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
make-struct-vmi_ops-static.patch
i386-asm-offsetsc-workaround-for-a-wmissing-prototypes-warning.patch
i386-x86_64-early_printkc-make-simnow_init-static.patch
make-arch-i386-kernel-vmicvmi_pmd_clear-static.patch
lguest-kconfig-and-headers.patch
revert-ac97-fix-microphone-and-line_in-selection-logic.patch
x86_p4_clockmod-must-select-cpu_freq_table.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
kill-net-rxrpc-rxrpc_symsc.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
the-scheduled-removal-of-obsolete_oss-options.patch
drivers-macintosh-mac_hidc-make-code-static.patch
ext2-reservations.patch
drivers-edac-make-code-static.patch
make-drivers-isdn-capi-capiutilccdebbuf_alloc-static.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
readahead-events-accounting.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
fbdev-display-class-fix.patch
fbdev-mm-deferred-io-support-fix.patch
fbdev-hecuba-framebuffer-driver-fix.patch
slim-main-patch.patch
slim-debug-output.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
