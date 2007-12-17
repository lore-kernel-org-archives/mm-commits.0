From: akpm@linux-foundation.org
Subject: - ips-handle-scsi_add_host-failure-and-other-err-cleanups.patch removed from -mm tree
Date: Mon, 17 Dec 2007 15:40:05 -0800
Message-ID: <200712172340.lBHNe5GJ008262@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53265 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932872AbXLQXxA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Dec 2007 18:53:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, James.Bottomley@steeleye.com, jgarzik@redhat.com, mark_salyzyn@adaptec.com, mm-commits@vger.kernel.org


The patch titled
     ips: handle scsi_add_host() failure, and other err cleanups
has been removed from the -mm tree.  Its filename was
     ips-handle-scsi_add_host-failure-and-other-err-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ips: handle scsi_add_host() failure, and other err cleanups
From: Jeff Garzik <jeff@garzik.org>

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Acked-by: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ips.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/ips.c~ips-handle-scsi_add_host-failure-and-other-err-cleanups drivers/scsi/ips.c
--- a/drivers/scsi/ips.c~ips-handle-scsi_add_host-failure-and-other-err-cleanups
+++ a/drivers/scsi/ips.c
@@ -6837,13 +6837,10 @@ ips_register_scsi(int index)
 	if (request_irq(ha->pcidev->irq, do_ipsintr, IRQF_SHARED, ips_name, ha)) {
 		IPS_PRINTK(KERN_WARNING, ha->pcidev,
 			   "Unable to install interrupt handler\n");
-		scsi_host_put(sh);
-		return -1;
+		goto err_out_sh;
 	}
 
 	kfree(oldha);
-	ips_sh[index] = sh;
-	ips_ha[index] = ha;
 
 	/* Store away needed values for later use */
 	sh->unique_id = (ha->io_addr) ? ha->io_addr : ha->mem_addr;
@@ -6859,10 +6856,21 @@ ips_register_scsi(int index)
 	sh->max_channel = ha->nbus - 1;
 	sh->can_queue = ha->max_cmds - 1;
 
-	scsi_add_host(sh, NULL);
+	if (scsi_add_host(sh, &ha->pcidev->dev))
+		goto err_out;
+
+	ips_sh[index] = sh;
+	ips_ha[index] = ha;
+
 	scsi_scan_host(sh);
 
 	return 0;
+
+err_out:
+	free_irq(ha->pcidev->irq, ha);
+err_out_sh:
+	scsi_host_put(sh);
+	return -1;
 }
 
 /*---------------------------------------------------------------------------*/
_

Patches currently in -mm which might be from jeff@garzik.org are

origin.patch
git-arm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
libata-add-toshiba-mk1637gsx-to-spurious-command-completion-list.patch
libata-set-proper-ata-udma-mode-for-bf548-according-to-system-clock-checkpatch-fixes.patch
libata-fix-early-use-of-port-printk-checkpatch-fixes.patch
pata_legacy-restructure-and-revamp.patch
git-netdev-all.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
pcmcia-net-use-roundup_pow_of_two-macro-instead-of-grotesque-loop.patch
bnx2x-depends-on-zlib_inflate.patch
plip-driver-convert-killed_timer_sem-to-completion.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-scsi-misc.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
git-wireless.patch
iommu-sg-merging-add-device_dma_parameters-structure.patch
iommu-sg-merging-pci-add-device_dma_parameters-support.patch
iommu-sg-merging-x86-make-pci-gart-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-ppc-make-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-ia64-make-sba_iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-alpha-make-pci_iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-sparc64-make-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-parisc-make-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-call-blk_queue_segment_boundary-in-__scsi_alloc_queue.patch
iommu-sg-merging-sata_inic162x-use-pci_set_dma_max_seg_size.patch
iommu-sg-merging-aacraid-use-pci_set_dma_max_seg_size.patch
iommu-sg-add-iommu-helper-functions-for-the-free-area-management.patch
iommu-sg-powerpc-convert-iommu-to-use-the-iommu-helper.patch
iommu-sg-powerpc-remove-dma-4gb-boundary-protection.patch
iommu-sg-x86-convert-calgary-iommu-to-use-the-iommu-helper.patch
iommu-sg-x86-convert-gart-iommu-to-use-the-iommu-helper.patch
iommu-sg-kill-__clear_bit_string-and-find_next_zero_string.patch
add-accessors-for-segment_boundary_mask-in.patch
pci-add-dma-segment-boundary-support.patch
swiotlb-respect-the-segment-boundary-limits.patch
call-dma_set_seg_boundary-in-__scsi_alloc_queue.patch
tty-fix-tty-network-driver-interactions-with-tcget-tcset-calls-x86-fix.patch
fix-versus-precedence-in-various-places.patch
riscom8-fix-smp-brokenness.patch
riscom8-fix-smp-brokenness-fix.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
sound-oss-sb_commonc-fix-casting-warning.patch
remove-warnings-for-longstanding-conditions.patch
remove-warnings-for-longstanding-conditions-fix.patch
remove-pointless-casts-from-void-pointers.patch
i8k-allow-i8k-driver-to-be-built-on-x86_64-systems.patch
i8k-adds-i8k-driver-to-the-x86_64-kconfig.patch
i8k-inspiron-e1705-fix.patch
