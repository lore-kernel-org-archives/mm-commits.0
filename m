From: akpm@linux-foundation.org
Subject: - proper-prototype-for-get_filesystem_list.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:21:56 -0800
Message-ID: <200802070021.m170LbJT006354@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37210 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933901AbYBGAog (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     proper prototype for get_filesystem_list()
has been removed from the -mm tree.  Its filename was
     proper-prototype-for-get_filesystem_list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proper prototype for get_filesystem_list()
From: Adrian Bunk <bunk@kernel.org>

Ad a proper prototype for migration_init() in include/linux/fs.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_misc.c |    1 -
 include/linux/fs.h  |    1 +
 init/do_mounts.c    |    3 +--
 3 files changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/proc/proc_misc.c~proper-prototype-for-get_filesystem_list fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~proper-prototype-for-get_filesystem_list
+++ a/fs/proc/proc_misc.c
@@ -65,7 +65,6 @@
  */
 extern int get_hardware_list(char *);
 extern int get_stram_list(char *);
-extern int get_filesystem_list(char *);
 extern int get_exec_domain_list(char *);
 extern int get_dma_list(char *);
 
diff -puN include/linux/fs.h~proper-prototype-for-get_filesystem_list include/linux/fs.h
--- a/include/linux/fs.h~proper-prototype-for-get_filesystem_list
+++ a/include/linux/fs.h
@@ -2113,6 +2113,7 @@ struct ctl_table;
 int proc_nr_files(struct ctl_table *table, int write, struct file *filp,
 		  void __user *buffer, size_t *lenp, loff_t *ppos);
 
+int get_filesystem_list(char * buf);
 
 #endif /* __KERNEL__ */
 #endif /* _LINUX_FS_H */
diff -puN init/do_mounts.c~proper-prototype-for-get_filesystem_list init/do_mounts.c
--- a/init/do_mounts.c~proper-prototype-for-get_filesystem_list
+++ a/init/do_mounts.c
@@ -11,6 +11,7 @@
 #include <linux/mount.h>
 #include <linux/device.h>
 #include <linux/init.h>
+#include <linux/fs.h>
 
 #include <linux/nfs_fs.h>
 #include <linux/nfs_fs_sb.h>
@@ -18,8 +19,6 @@
 
 #include "do_mounts.h"
 
-extern int get_filesystem_list(char * buf);
-
 int __initdata rd_doload;	/* 1 = load RAM disk, 0 = don't load */
 
 int root_mountflags = MS_RDONLY | MS_SILENT;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-acpi.patch
powerpc-vdso_do_func_patch3264-must-be-__init.patch
powerpc-free_property-mustnt-be-__init.patch
hvc_rtas_init-must-be-__init.patch
git-dvb.patch
git-gfs2-nmw.patch
git-mtd.patch
git-ocfs2.patch
if-0-pci_cleanup_aer_correct_error_status.patch
git-scsi-misc.patch
scsi-aic94xx-cleanups.patch
scsi-qlogicptic-section-fixes.patch
usb-make-usb_storage_onetouch-available-with-pm.patch
make-b43_mac_enablesuspend-static.patch
git-xtensa.patch
move-edactxt-two-levels-up.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
kill-udffs_dateversion.patch
the-scheduled-time-option-removal.patch
reiser4.patch
