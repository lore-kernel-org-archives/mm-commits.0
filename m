From: akpm@linux-foundation.org
Subject: - make-lpfc_disable_node-static.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:22:46 -0800
Message-ID: <200802232022.m1NKMkO2013450@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762192AbYBWU3B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:29:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, James.Bottomley@steeleye.com, James.Smart@Emulex.Com, mm-commits@vger.kernel.org


The patch titled
     make lpfc_disable_node() static
has been removed from the -mm tree.  Its filename was
     make-lpfc_disable_node-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: make lpfc_disable_node() static
From: Adrian Bunk <bunk@kernel.org>

Make the needlessly global lpfc_disable_node() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: James Smart <James.Smart@Emulex.Com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/lpfc/lpfc_crtn.h    |    1 -
 drivers/scsi/lpfc/lpfc_hbadisc.c |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/scsi/lpfc/lpfc_crtn.h~make-lpfc_disable_node-static drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h~make-lpfc_disable_node-static
+++ a/drivers/scsi/lpfc/lpfc_crtn.h
@@ -55,7 +55,6 @@ void lpfc_mbx_cmpl_ns_reg_login(struct l
 void lpfc_mbx_cmpl_fdmi_reg_login(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_enqueue_node(struct lpfc_vport *, struct lpfc_nodelist *);
 void lpfc_dequeue_node(struct lpfc_vport *, struct lpfc_nodelist *);
-void lpfc_disable_node(struct lpfc_vport *, struct lpfc_nodelist *);
 struct lpfc_nodelist *lpfc_enable_node(struct lpfc_vport *,
 					struct lpfc_nodelist *, int);
 void lpfc_nlp_set_state(struct lpfc_vport *, struct lpfc_nodelist *, int);
diff -puN drivers/scsi/lpfc/lpfc_hbadisc.c~make-lpfc_disable_node-static drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c~make-lpfc_disable_node-static
+++ a/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1694,7 +1694,7 @@ lpfc_dequeue_node(struct lpfc_vport *vpo
 				NLP_STE_UNUSED_NODE);
 }
 
-void
+static void
 lpfc_disable_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 {
 	if ((ndlp->nlp_flag & NLP_DELAY_TMO) != 0)
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
