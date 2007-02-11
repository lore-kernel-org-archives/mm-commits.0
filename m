From: akpm@linux-foundation.org
Subject: - cleanup-include-linux-reiserfs_xattrh.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:54:52 -0800
Message-ID: <200702112254.l1BMsq7Y016275@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60787 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932910AbXBKW6F (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:58:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     cleanup include/linux/reiserfs_xattr.h
has been removed from the -mm tree.  Its filename was
     cleanup-include-linux-reiserfs_xattrh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cleanup include/linux/reiserfs_xattr.h
From: Adrian Bunk <bunk@stusta.de>

- #ifdef guard this header for multiple inclusion
- adjust the #include's to what is actually required by this header
- remove an unneeded #ifdef
- #endif comments

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/reiserfs_xattr.h |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff -puN include/linux/reiserfs_xattr.h~cleanup-include-linux-reiserfs_xattrh include/linux/reiserfs_xattr.h
--- a/include/linux/reiserfs_xattr.h~cleanup-include-linux-reiserfs_xattrh
+++ a/include/linux/reiserfs_xattr.h
@@ -2,7 +2,10 @@
   File: linux/reiserfs_xattr.h
 */
 
-#include <linux/xattr.h>
+#ifndef _LINUX_REISERFS_XATTR_H
+#define _LINUX_REISERFS_XATTR_H
+
+#include <linux/types.h>
 
 /* Magic value in header */
 #define REISERFS_XATTR_MAGIC 0x52465841	/* "RFXA" */
@@ -13,7 +16,18 @@ struct reiserfs_xattr_header {
 };
 
 #ifdef __KERNEL__
+
 #include <linux/init.h>
+#include <linux/list.h>
+#include <linux/rwsem.h>
+#include <linux/reiserfs_fs_i.h>
+#include <linux/reiserfs_fs.h>
+
+struct inode;
+struct dentry;
+struct iattr;
+struct super_block;
+struct nameidata;
 
 struct reiserfs_xattr_handler {
 	char *prefix;
@@ -49,9 +63,7 @@ int reiserfs_xattr_set(struct inode *, c
 
 extern struct reiserfs_xattr_handler user_handler;
 extern struct reiserfs_xattr_handler trusted_handler;
-#ifdef CONFIG_REISERFS_FS_SECURITY
 extern struct reiserfs_xattr_handler security_handler;
-#endif
 
 int reiserfs_xattr_register_handlers(void) __init;
 void reiserfs_xattr_unregister_handlers(void);
@@ -137,6 +149,8 @@ static inline int reiserfs_xattr_init(st
 static inline void reiserfs_init_xattr_rwsem(struct inode *inode)
 {
 }
-#endif
+#endif  /*  CONFIG_REISERFS_FS_XATTR  */
+
+#endif  /*  __KERNEL__  */
 
-#endif				/* __KERNEL__ */
+#endif  /*  _LINUX_REISERFS_XATTR_H  */
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
ifdef-acpi_future_usage-acpi_os_readable.patch
git-cpufreq.patch
git-drm.patch
git-dvb.patch
git-ieee1394.patch
mips-remove-smp_tune_scheduling.patch
git-mtd.patch
git-ubi.patch
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
usb_rtl8150-must-select-mii.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
lumpy-reclaim-cleanup.patch
debug-shared-irqs-kconfig-fix.patch
gtod-persistent-clock-support.patch
i386-use-gtod-persistent-clock-support.patch
extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
clockevents-i383-drivers.patch
add-debugging-feature-proc-timer_stat-cleanup.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
drivers-isdn-pcbit-proper-prototypes.patch
drivers-isdn-hisax-proper-prototypes.patch
drivers-isdn-sc-proper-prototypes.patch
include-linux-nfsd-consth-remove-nfs_super_magic.patch
ecryptfs-generalize-metadata-read-write-fs-ecryptfs-make-code-static.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
remove-broken-video-drivers-v4.patch
remove-bogus-con_is_present-prototypes.patch
proper-prototype-for-tosh_smm.patch
remove-the-broken-fb_s3trio-driver.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
sysctl-reimplement-the-sysctl-proc-support-fix-3.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
