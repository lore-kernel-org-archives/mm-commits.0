From: akpm@linux-foundation.org
Subject: - make-udf_error-static.patch removed from -mm tree
Date: Tue, 04 Mar 2008 12:10:27 -0800
Message-ID: <200803042010.m24KARfJ026910@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57233 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932768AbYCDUK4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 15:10:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     make udf_error() static
has been removed from the -mm tree.  Its filename was
     make-udf_error-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: make udf_error() static
From: Adrian Bunk <bunk@kernel.org>

Make the needlessly global udf_error() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/super.c   |    6 ++++--
 fs/udf/udfdecl.h |    1 -
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/udf/super.c~make-udf_error-static fs/udf/super.c
--- a/fs/udf/super.c~make-udf_error-static
+++ a/fs/udf/super.c
@@ -100,6 +100,8 @@ static void udf_close_lvid(struct super_
 static unsigned int udf_count_free(struct super_block *);
 static int udf_statfs(struct dentry *, struct kstatfs *);
 static int udf_show_options(struct seq_file *, struct vfsmount *);
+static void udf_error(struct super_block *sb, const char *function,
+		      const char *fmt, ...);
 
 struct logicalVolIntegrityDescImpUse *udf_sb_lvidiu(struct udf_sb_info *sbi)
 {
@@ -1920,8 +1922,8 @@ error_out:
 	return -EINVAL;
 }
 
-void udf_error(struct super_block *sb, const char *function,
-	       const char *fmt, ...)
+static void udf_error(struct super_block *sb, const char *function,
+		      const char *fmt, ...)
 {
 	va_list args;
 
diff -puN fs/udf/udfdecl.h~make-udf_error-static fs/udf/udfdecl.h
--- a/fs/udf/udfdecl.h~make-udf_error-static
+++ a/fs/udf/udfdecl.h
@@ -83,7 +83,6 @@ struct extent_position {
 };
 
 /* super.c */
-extern void udf_error(struct super_block *, const char *, const char *, ...);
 extern void udf_warning(struct super_block *, const char *, const char *, ...);
 
 /* namei.c */
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-acpi.patch
git-dvb.patch
git-gfs2-nmw.patch
git-dlm.patch
mtdoopsc-make-struct-oops_cxt-static-again.patch
make-mtd-nand-cs553x_nandcpart_probes-static.patch
git-ubi.patch
git-udf.patch
make-s2iocinit_tti-static.patch
git-nfsd.patch
git-ocfs2.patch
git-parisc.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-selinux.patch
pci_alloc_child_bus-mustnt-be-__devinit.patch
pci_scan_device-mustnt-be-__devinit.patch
pci_bus_size_cardbus-mustnt-be-__devinit.patch
pci_setup_bridge-mustnt-be-__devinit.patch
scsi-aic94xx-cleanups.patch
if-0-ses_match_host.patch
remove-ps2esdi.patch
drivers-usb-serial-io_tic-remove-unneeded-null-tty-check.patch
make-b43_mac_enablesuspend-static.patch
the-scheduled-bcm43xx-removal.patch
the-scheduled-ieee80211-softmac-removal.patch
the-scheduled-rc80211-simplec-removal.patch
ndelay-switch-to-c-function-to-avoid-64-bit-division.patch
ndelay-switch-to-c-function-to-avoid-64-bit-division-fix.patch
ipwireless-fix-potential-tty-==-null-dereference.patch
make-swap_pte_to_pagemap_entry-static.patch
fs-ramfs-extern-cleanup.patch
fs-hfsplus-proper-externs.patch
fs-freevxfs-proper-externs.patch
make-__put_super-static.patch
make-vfs_ioctl-static.patch
fs-fs-writeback-make-2-functions-static.patch
fs-drop_cachesc-make-2-functions-static.patch
fs-aioc-make-3-functions-static.patch
let-log_buf_shift-default-to-17.patch
fs-timerfdc-should-include-linux-syscallsh.patch
remove-generic_commit_write.patch
make-fs-bufferccont_expand_zero-static.patch
make-binfmt_flat-a-bool.patch
remove-mca_is_adapter_used.patch
ipwireless-remove-dead-code.patch
proper-__do_softirq-prototype.patch
proper-extern-for-late_time_init.patch
remove-ecryptfs_header_cache_0.patch
make-ds1511_rtc_readset_time-static.patch
pnp-skip-dev-protocol-null-checks.patch
make-ext3_xattr_list-static.patch
make-cgroup_enable_task_cg_lists-static.patch
cgroups-kernel-ns_cgroupc-should-include-linux-nsproxyh.patch
kernel-cpusetc-make-3-functions-static.patch
make-ext4_xattr_list-static.patch
include-linux-sysctlh-remove-empty-else.patch
remove-aoedev_isbusy.patch
make-marker_debug-static.patch
reiser4.patch

