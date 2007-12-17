From: akpm@linux-foundation.org
Subject: - scsi-sym53c416-kill-pointless-irq-handler-loop-and-test.patch removed from -mm tree
Date: Mon, 17 Dec 2007 15:40:10 -0800
Message-ID: <200712172340.lBHNeAhc008268@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51869 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964793AbXLQXxZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Dec 2007 18:53:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, James.Bottomley@steeleye.com, jgarzik@redhat.com, willy@debian.org, mm-commits@vger.kernel.org


The patch titled
     SCSI/sym53c416: kill pointless irq handler loop and test
has been removed from the -mm tree.  Its filename was
     scsi-sym53c416-kill-pointless-irq-handler-loop-and-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SCSI/sym53c416: kill pointless irq handler loop and test
From: Jeff Garzik <jeff@garzik.org>

- kill pointless irq handler loop to find base address, it is already
  passed to irq handler via Scsi_Host.

- kill now-pointless !base test.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Matthew Wilcox <willy@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sym53c416.c |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff -puN drivers/scsi/sym53c416.c~scsi-sym53c416-kill-pointless-irq-handler-loop-and-test drivers/scsi/sym53c416.c
--- a/drivers/scsi/sym53c416.c~scsi-sym53c416-kill-pointless-irq-handler-loop-and-test
+++ a/drivers/scsi/sym53c416.c
@@ -328,27 +328,13 @@ static __inline__ unsigned int sym53c416
 static irqreturn_t sym53c416_intr_handle(int irq, void *dev_id)
 {
 	struct Scsi_Host *dev = dev_id;
-	int base = 0;
+	int base = dev->io_port;
 	int i;
 	unsigned long flags = 0;
 	unsigned char status_reg, pio_int_reg, int_reg;
 	struct scatterlist *sg;
 	unsigned int tot_trans = 0;
 
-	/* We search the base address of the host adapter which caused the interrupt */
-	/* FIXME: should pass dev_id sensibly as hosts[i] */
-	for(i = 0; i < host_index && !base; i++)
-		if(irq == hosts[i].irq)
-			base = hosts[i].base;
-	/* If no adapter found, we cannot handle the interrupt. Leave a message */
-	/* and continue. This should never happen...                            */
-	if(!base)
-	{
-		printk(KERN_ERR "sym53c416: No host adapter defined for interrupt %d\n", irq);
-		return IRQ_NONE;
-	}
-	/* Now we have the base address and we can start handling the interrupt */
-
 	spin_lock_irqsave(dev->host_lock,flags);
 	status_reg = inb(base + STATUS_REG);
 	pio_int_reg = inb(base + PIO_INT_REG);
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
