From: akpm@linux-foundation.org
Subject: - if-0-pci_cleanup_aer_correct_error_status.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:22:31 -0800
Message-ID: <200802232022.m1NKMVKw013431@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:51635 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761911AbYBWU2p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:28:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, gregkh@suse.de, shemminger@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     #if 0 pci_cleanup_aer_correct_error_status()
has been removed from the -mm tree.  Its filename was
     if-0-pci_cleanup_aer_correct_error_status.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: #if 0 pci_cleanup_aer_correct_error_status()
From: Adrian Bunk <bunk@kernel.org>

#if 0 the no longer used pci_cleanup_aer_correct_error_status().

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pcie/aer/aerdrv_core.c |    3 ++-
 include/linux/aer.h                |    5 -----
 2 files changed, 2 insertions(+), 6 deletions(-)

diff -puN drivers/pci/pcie/aer/aerdrv_core.c~if-0-pci_cleanup_aer_correct_error_status drivers/pci/pcie/aer/aerdrv_core.c
--- a/drivers/pci/pcie/aer/aerdrv_core.c~if-0-pci_cleanup_aer_correct_error_status
+++ a/drivers/pci/pcie/aer/aerdrv_core.c
@@ -117,6 +117,7 @@ int pci_cleanup_aer_uncorrect_error_stat
 	return 0;
 }
 
+#if 0
 int pci_cleanup_aer_correct_error_status(struct pci_dev *dev)
 {
 	int pos;
@@ -131,6 +132,7 @@ int pci_cleanup_aer_correct_error_status
 
 	return 0;
 }
+#endif  /*  0  */
 
 static int find_device_iter(struct device *device, void *data)
 {
@@ -757,5 +759,4 @@ EXPORT_SYMBOL_GPL(pci_find_aer_capabilit
 EXPORT_SYMBOL_GPL(pci_enable_pcie_error_reporting);
 EXPORT_SYMBOL_GPL(pci_disable_pcie_error_reporting);
 EXPORT_SYMBOL_GPL(pci_cleanup_aer_uncorrect_error_status);
-EXPORT_SYMBOL_GPL(pci_cleanup_aer_correct_error_status);
 
diff -puN include/linux/aer.h~if-0-pci_cleanup_aer_correct_error_status include/linux/aer.h
--- a/include/linux/aer.h~if-0-pci_cleanup_aer_correct_error_status
+++ a/include/linux/aer.h
@@ -13,7 +13,6 @@ extern int pci_enable_pcie_error_reporti
 extern int pci_find_aer_capability(struct pci_dev *dev);
 extern int pci_disable_pcie_error_reporting(struct pci_dev *dev);
 extern int pci_cleanup_aer_uncorrect_error_status(struct pci_dev *dev);
-extern int pci_cleanup_aer_correct_error_status(struct pci_dev *dev);
 #else
 static inline int pci_enable_pcie_error_reporting(struct pci_dev *dev)
 {
@@ -31,10 +30,6 @@ static inline int pci_cleanup_aer_uncorr
 {
 	return -EINVAL;
 }
-static inline int pci_cleanup_aer_correct_error_status(struct pci_dev *dev)
-{
-	return -EINVAL;
-}
 #endif
 
 #endif //_AER_H_
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
sparc-fix-build.patch
git-acpi.patch
git-dvb.patch
git-gfs2-nmw.patch
mtdoopsc-make-struct-oops_cxt-static-again.patch
make-mtd-nand-cs553x_nandcpart_probes-static.patch
git-net.patch
make-s2iocinit_tti-static.patch
git-nfsd.patch
git-ocfs2.patch
pci_alloc_child_bus-mustnt-be-__devinit.patch
pci_scan_device-mustnt-be-__devinit.patch
pci_bus_size_cardbus-mustnt-be-__devinit.patch
pci_setup_bridge-mustnt-be-__devinit.patch
git-scsi-rc-fixes.patch
scsi-aic94xx-cleanups.patch
if-0-ses_match_host.patch
remove-ps2esdi.patch
make-b43_mac_enablesuspend-static.patch
the-scheduled-bcm43xx-removal.patch
the-scheduled-ieee80211-softmac-removal.patch
the-scheduled-rc80211-simplec-removal.patch
ieee80211-fix-broken-error-handling-in-ieee80211_sta_process_addba_request.patch
make-swap_pte_to_pagemap_entry-static.patch
fs-ramfs-extern-cleanup.patch
make-udf_error-static.patch
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
remove-ecryptfs_header_cache_0.patch
make-ds1511_rtc_readset_time-static.patch
pnp-skip-dev-protocol-null-checks.patch
make-ext3_xattr_list-static.patch
make-cgroup_enable_task_cg_lists-static.patch
kernel-cpusetc-make-3-functions-static.patch
make-ext4_xattr_list-static.patch
include-linux-sysctlh-remove-empty-else.patch
remove-aoedev_isbusy.patch
make-marker_debug-static.patch
reiser4.patch
