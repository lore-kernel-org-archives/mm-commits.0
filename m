From: akpm@osdl.org
Subject: + cleanup-include-linux-xattrh.patch added to -mm tree
Date: Wed, 24 Jan 2007 20:03:45 -0800
Message-ID: <200701250403.l0P43jQI005316@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45234 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933178AbXAYEHG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 23:07:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de


The patch titled
     cleanup include/linux/xattr.h
has been added to the -mm tree.  Its filename is
     cleanup-include-linux-xattrh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cleanup include/linux/xattr.h
From: Adrian Bunk <bunk@stusta.de>

- reduce the userspace visible part
- fix the in-kernel compilation

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/Kbuild  |    2 +-
 include/linux/xattr.h |    8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff -puN include/linux/Kbuild~cleanup-include-linux-xattrh include/linux/Kbuild
--- a/include/linux/Kbuild~cleanup-include-linux-xattrh
+++ a/include/linux/Kbuild
@@ -158,7 +158,6 @@ header-y += video_encoder.h
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
knfsd-replace-some-warning-ins-nfsfhh-with-bug_on-or-warn_on.patch
git-acpi.patch
git-alsa.patch
cpu_freq_table-shouldnt-be-a-def_tristate.patch
drivers-char-drm-drm_mmc-remove-unused-exports.patch
git-dvb.patch
git-gfs2-nmw.patch
ia64-add-pci_get_legacy_ide_irq.patch
git-ieee1394.patch
git-libata-all.patch
mips-remove-smp_tune_scheduling.patch
git-mmc.patch
git-ubi.patch
git-netdev-all.patch
net-irda-proper-prototypes.patch
net-wanrouter-wanmainc-cleanups.patch
net-uninline-skb_put-fix.patch
git-ocfs2.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
usb_rtl8150-must-select-mii.patch
x86_64-re-add-a-newline-to-restore_context.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
lumpy-reclaim-cleanup.patch
remove-include-linux-byteorder-pdp_endianh.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
drivers-char-vc_screenc-proper-prototypes.patch
add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix.patch
schedule-obsolete-oss-drivers-for-removal-3rd-round.patch
more-ftape-removal.patch
cleanup-linux-byteorder-swabbh.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
clockevents-i386-drivers.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
drivers-isdn-pcbit-proper-prototypes.patch
drivers-isdn-hisax-proper-prototypes.patch
drivers-isdn-sc-proper-prototypes.patch
include-linux-nfsd-consth-remove-nfs_super_magic.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
fbdev-driver-for-s3-trio-virge-cleanups.patch
remove-broken-video-drivers-v4.patch
remove-bogus-con_is_present-prototypes.patch
proper-prototype-for-tosh_smm.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
cleanup-include-linux-xattrh.patch
cleanup-include-linux-reiserfs_xattrh.patch
process-include-linux-if_addrlinkh-with-unifdef.patch
remove-one-remaining-define-bcm_tso-1.patch
