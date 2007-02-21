From: akpm@linux-foundation.org
Subject: + remove-fs-jffs2-ioctlc.patch added to -mm tree
Date: Wed, 21 Feb 2007 13:58:33 -0800
Message-ID: <200702212158.l1LLwXBj027650@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51007 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbXBUWB5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 17:01:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, dwmw2@infradead.org


The patch titled
     remove fs/jffs2/ioctl.c
has been added to the -mm tree.  Its filename is
     remove-fs-jffs2-ioctlc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -168,9 +168,6 @@ extern const struct address_space_operat
 int jffs2_fsync(struct file *, struct dentry *, int);
 int jffs2_do_readpage_unlock (struct inode *inode, struct page *pg);
 
-/* ioctl.c */
-int jffs2_ioctl(struct inode *, struct file *, unsigned int, unsigned long);
-
 /* symlink.c */
 extern const struct inode_operations jffs2_symlink_inode_operations;
 
_

Patches currently in -mm which might be from bunk@stusta.de are

git-cpufreq.patch
git-drm.patch
git-dvb.patch
git-ieee1394.patch
mips-remove-smp_tune_scheduling.patch
remove-fs-jffs2-ioctlc.patch
git-ubi.patch
git-net.patch
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
git-unionfs.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
make-struct-vmi_ops-static.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
lumpy-reclaim-cleanup.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
linux-kernel-markers-kconfig-menus-fix.patch
linux-kernel-markers-architecture-independant-code-license-fix.patch
linux-kernel-markers-i386-optimization-export-fix.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
