From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Wed, 21 Jan 2015 13:26:15 -0800
Message-ID: <54c01977.EPVt8s8lstfZE5ne%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37554 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbbAUV0Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Jan 2015 16:26:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ahci_xgene.c       |   11 -----------
 drivers/net/ethernet/ti/cpsw.c |   15 ---------------
 2 files changed, 26 deletions(-)

diff -puN drivers/ata/ahci_xgene.c~linux-next-git-rejects drivers/ata/ahci_xgene.c
--- a/drivers/ata/ahci_xgene.c~linux-next-git-rejects
+++ a/drivers/ata/ahci_xgene.c
@@ -178,13 +178,6 @@ static int xgene_ahci_restart_engine(str
  * xgene_ahci_qc_issue - Issue commands to the device
  * @qc: Command to issue
  *
-<<<<<<< HEAD
- * Due to Hardware errata for IDENTIFY DEVICE command and PACKET
- * command of ATAPI protocol set, the controller cannot clear the BSY bit
- * after receiving the PIO setup FIS. This results in the DMA state machine
- * going into the CMFatalErrorUpdate state and locks up. By restarting the
- * DMA engine, it removes the controller out of lock up state.
-=======
  * Due to Hardware errata for IDENTIFY DEVICE command, the controller cannot
  * clear the BSY bit after receiving the PIO setup FIS. This results in the dma
  * state machine goes into the CMFatalErrorUpdate state and locks up. By
@@ -196,7 +189,6 @@ static int xgene_ahci_restart_engine(str
  * a mismatch and results in command completion failure. The
  * workaround is to write the pmp value to PxFBS.DEV field before issuing
  * any command to PMP.
->>>>>>> linux-next/akpm-base
  */
 static unsigned int xgene_ahci_qc_issue(struct ata_queued_cmd *qc)
 {
@@ -207,8 +199,6 @@ static unsigned int xgene_ahci_qc_issue(
 	u32 port_fbs;
 	void *port_mmio = ahci_port_base(ap);
 
-<<<<<<< HEAD
-=======
 	/*
 	 * Write the pmp value to PxFBS.DEV
 	 * for case of Port Mulitplier.
@@ -220,7 +210,6 @@ static unsigned int xgene_ahci_qc_issue(
 		writel(port_fbs, port_mmio + PORT_FBS);
 	}
 
->>>>>>> linux-next/akpm-base
 	if (unlikely((ctx->last_cmd[ap->port_no] == ATA_CMD_ID_ATA) ||
 	    (ctx->last_cmd[ap->port_no] == ATA_CMD_PACKET)))
 		xgene_ahci_restart_engine(ap);
diff -puN drivers/net/ethernet/ti/cpsw.c~linux-next-git-rejects drivers/net/ethernet/ti/cpsw.c
--- a/drivers/net/ethernet/ti/cpsw.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/ti/cpsw.c
@@ -1648,7 +1648,6 @@ static inline int cpsw_add_vlan_ale_entr
 
 	if (priv->data.dual_emac) {
 		port_mask = (1 << (priv->emac_port + 1)) | ALE_PORT_HOST;
-<<<<<<< HEAD
 
 		if (priv->ndev->flags & IFF_ALLMULTI)
 			unreg_mcast_mask = port_mask;
@@ -1661,20 +1660,6 @@ static inline int cpsw_add_vlan_ale_entr
 			unreg_mcast_mask = ALE_PORT_1 | ALE_PORT_2;
 	}
 
-=======
-
-		if (priv->ndev->flags & IFF_ALLMULTI)
-			unreg_mcast_mask = port_mask;
-	} else {
-		port_mask = ALE_ALL_PORTS;
-
-		if (priv->ndev->flags & IFF_ALLMULTI)
-			unreg_mcast_mask = ALE_ALL_PORTS;
-		else
-			unreg_mcast_mask = ALE_PORT_1 | ALE_PORT_2;
-	}
-
->>>>>>> linux-next/akpm-base
 	ret = cpsw_ale_add_vlan(priv->ale, vid, port_mask, 0, port_mask,
 				unreg_mcast_mask << priv->host_port);
 	if (ret != 0)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
mm.patch
mm-vmstatc-fix-cleanup-ifdefs.patch
mm-vmstatc-fix-cleanup-ifdefs-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
vmscan-force-scan-offline-memory-cgroups-fix.patch
mm-memcontrol-default-hierarchy-interface-for-memory.patch
mm-memcontrol-fold-move_anon-and-move_file-fix.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix.patch
mm-thp-allocate-transparent-hugepages-on-local-node-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix.patch
rtc-rk808-fix-the-rtc-time-reading-issue-fix.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-fix-xip-fault-vs-truncate-race-fix-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix-3.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-3.patch
dax-add-dax_zero_page_range-fix.patch
ext4-add-dax-functionality-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

