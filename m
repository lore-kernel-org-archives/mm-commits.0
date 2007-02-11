From: akpm@linux-foundation.org
Subject: - cleanup-include-linux-xattrh.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:54:50 -0800
Message-ID: <200702112254.l1BMsosa016272@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60781 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932911AbXBKW6E (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:58:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     cleanup include/linux/xattr.h
has been removed from the -mm tree.  Its filename was
     cleanup-include-linux-xattrh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cleanup include/linux/xattr.h
From: Adrian Bunk <bunk@stusta.de>

- reduce the userspace visible part
- fix the in-kernel compilation

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/Kbuild  |    2 +-
 include/linux/xattr.h |    8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff -puN include/linux/Kbuild~cleanup-include-linux-xattrh include/linux/Kbuild
--- a/include/linux/Kbuild~cleanup-include-linux-xattrh
+++ a/include/linux/Kbuild
@@ -156,7 +156,6 @@ header-y += video_encoder.h
 header-y += videotext.h
 header-y += vt.h
 header-y += wireless.h
-header-y += xattr.h
 header-y += x25.h
 
 unifdef-y += acct.h
@@ -336,6 +335,7 @@ unifdef-y += wait.h
 unifdef-y += wanrouter.h
 unifdef-y += watchdog.h
 unifdef-y += wireless.h
+unifdef-y += xattr.h
 unifdef-y += xfrm.h
 
 objhdr-y += version.h
diff -puN include/linux/xattr.h~cleanup-include-linux-xattrh include/linux/xattr.h
--- a/include/linux/xattr.h~cleanup-include-linux-xattrh
+++ a/include/linux/xattr.h
@@ -13,6 +13,10 @@
 #define XATTR_CREATE	0x1	/* set value, fail if attr already exists */
 #define XATTR_REPLACE	0x2	/* set value, fail if attr does not exist */
 
+#ifdef  __KERNEL__
+
+#include <linux/types.h>
+
 /* Namespaces */
 #define XATTR_OS2_PREFIX "os2."
 #define XATTR_OS2_PREFIX_LEN (sizeof (XATTR_OS2_PREFIX) - 1)
@@ -29,6 +33,8 @@
 #define XATTR_USER_PREFIX "user."
 #define XATTR_USER_PREFIX_LEN (sizeof (XATTR_USER_PREFIX) - 1)
 
+struct inode;
+struct dentry;
 
 struct xattr_handler {
 	char *prefix;
@@ -50,4 +56,6 @@ ssize_t generic_listxattr(struct dentry 
 int generic_setxattr(struct dentry *dentry, const char *name, const void *value, size_t size, int flags);
 int generic_removexattr(struct dentry *dentry, const char *name);
 
+#endif  /*  __KERNEL__  */
+
 #endif	/* _LINUX_XATTR_H */
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
