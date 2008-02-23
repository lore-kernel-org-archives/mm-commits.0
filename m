From: akpm@linux-foundation.org
Subject: + message-fusion-mptbasec-fix-use-after-frees.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:32:15 -0800
Message-ID: <200802230733.m1N7X4Fp018187@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53728 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753206AbYBWHyG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:54:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org


The patch titled
     message/fusion/mptbase.c: fix use-after-free's
has been added to the -mm tree.  Its filename is
     message-fusion-mptbasec-fix-use-after-frees.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: message/fusion/mptbase.c: fix use-after-free's
From: Adrian Bunk <bunk@kernel.org>

Fix two use-after-free's introduced by commit
e78d5b8f1e73ab82f3fd041d05824cfee7d83a2c and spotted by the Coverity
checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptbase.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/message/fusion/mptbase.c~message-fusion-mptbasec-fix-use-after-frees drivers/message/fusion/mptbase.c
--- a/drivers/message/fusion/mptbase.c~message-fusion-mptbasec-fix-use-after-frees
+++ a/drivers/message/fusion/mptbase.c
@@ -1481,15 +1481,15 @@ mpt_attach(struct pci_dev *pdev, const s
 
 	ioc->bars = pci_select_bars(pdev, IORESOURCE_MEM);
 	if (pci_enable_device_mem(pdev)) {
-		kfree(ioc);
 		printk(MYIOC_s_ERR_FMT "pci_enable_device_mem() "
 		       "failed\n", ioc->name);
+		kfree(ioc);
 		return r;
 	}
 	if (pci_request_selected_regions(pdev, ioc->bars, "mpt")) {
-		kfree(ioc);
 		printk(MYIOC_s_ERR_FMT "pci_request_selected_regions() with "
 		       "MEM failed\n", ioc->name);
+		kfree(ioc);
 		return r;
 	}
 
_

Patches currently in -mm which might be from bunk@kernel.org are

sparc-fix-build.patch
git-acpi.patch
git-dvb.patch
git-gfs2-nmw.patch
proper-extern-for-gfs2-locking-dlm-mountcgdlm_ops.patch
gfs2-ops_filec-should-include-ops_inodeh.patch
git-kbuild.patch
mips-fix-sni_rm-eisa=n-compilation.patch
mips-finish-the-qemu-platform-removal.patch
mtdoopsc-make-struct-oops_cxt-static-again.patch
make-mtd-nand-cs553x_nandcpart_probes-static.patch
make-s2iocinit_tti-static.patch
git-nfsd.patch
git-ocfs2.patch
make-ocfs2_downconvert_thread-static.patch
ocfs-make-dlm_do_assert_master-static.patch
if-0-pci_cleanup_aer_correct_error_status.patch
pci_alloc_child_bus-mustnt-be-__devinit.patch
pci_scan_device-mustnt-be-__devinit.patch
pci_bus_size_cardbus-mustnt-be-__devinit.patch
pci_setup_bridge-mustnt-be-__devinit.patch
scsi-aic94xx-cleanups.patch
scsi-qlogicptic-section-fixes.patch
make-lpfc_disable_node-static.patch
if-0-ses_match_host.patch
scsi_transport_iscsic-make-2-functions-static.patch
remove-ps2esdi.patch
usb-make-usb_storage_onetouch-available-with-pm.patch
make-b43_mac_enablesuspend-static.patch
the-scheduled-bcm43xx-removal.patch
the-scheduled-ieee80211-softmac-removal.patch
the-scheduled-rc80211-simplec-removal.patch
git-xtensa.patch
message-fusion-mptbasec-fix-use-after-frees.patch
ieee80211-fix-broken-error-handling-in-ieee80211_sta_process_addba_request.patch
dm-raid1c-fix-null-dereferences.patch
make-swap_pte_to_pagemap_entry-static.patch
fs-ramfs-extern-cleanup.patch
make-printk_recursion_bug_msg-static.patch
make-udf_error-static.patch
fs-hfsplus-proper-externs.patch
fs-freevxfs-proper-externs.patch
make-__put_super-static.patch
make-vfs_ioctl-static.patch
fs-fs-writeback-make-2-functions-static.patch
fs-drop_cachesc-make-2-functions-static.patch
fs-block_devc-remove-if-0ed-code.patch
fs-aioc-make-3-functions-static.patch
let-log_buf_shift-default-to-17.patch
fs-timerfdc-should-include-linux-syscallsh.patch
make-struct-def_blk_aops-static.patch
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
