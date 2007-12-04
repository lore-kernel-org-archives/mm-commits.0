From: akpm@linux-foundation.org
Subject: - ata_generic-unindent-loop-in-generic_set_mode.patch removed from -mm tree
Date: Mon, 03 Dec 2007 23:37:49 -0800
Message-ID: <200712040737.lB47bnMO006845@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38389 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751698AbXLDHi2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 02:38:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: htejun@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ata_generic: unindent loop in generic_set_mode()
has been removed from the -mm tree.  Its filename was
     ata_generic-unindent-loop-in-generic_set_mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ata_generic: unindent loop in generic_set_mode()
From: Tejun Heo <htejun@gmail.com>

Unindent loop body in generic_set_mode().  This is to ease future change.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ata_generic.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff -puN drivers/ata/ata_generic.c~ata_generic-unindent-loop-in-generic_set_mode drivers/ata/ata_generic.c
--- a/drivers/ata/ata_generic.c~ata_generic-unindent-loop-in-generic_set_mode
+++ a/drivers/ata/ata_generic.c
@@ -54,21 +54,22 @@ static int generic_set_mode(struct ata_l
 		dma_enabled = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_STATUS);
 
 	ata_link_for_each_dev(dev, link) {
-		if (ata_dev_enabled(dev)) {
-			/* We don't really care */
-			dev->pio_mode = XFER_PIO_0;
-			dev->dma_mode = XFER_MW_DMA_0;
-			/* We do need the right mode information for DMA or PIO
-			   and this comes from the current configuration flags */
-			if (dma_enabled & (1 << (5 + dev->devno))) {
-				ata_id_to_dma_mode(dev, XFER_MW_DMA_0);
-				dev->flags &= ~ATA_DFLAG_PIO;
-			} else {
-				ata_dev_printk(dev, KERN_INFO, "configured for PIO\n");
-				dev->xfer_mode = XFER_PIO_0;
-				dev->xfer_shift = ATA_SHIFT_PIO;
-				dev->flags |= ATA_DFLAG_PIO;
-			}
+		if (!ata_dev_enabled(dev))
+			continue;
+
+		/* We don't really care */
+		dev->pio_mode = XFER_PIO_0;
+		dev->dma_mode = XFER_MW_DMA_0;
+		/* We do need the right mode information for DMA or PIO
+		   and this comes from the current configuration flags */
+		if (dma_enabled & (1 << (5 + dev->devno))) {
+			ata_id_to_dma_mode(dev, XFER_MW_DMA_0);
+			dev->flags &= ~ATA_DFLAG_PIO;
+		} else {
+			ata_dev_printk(dev, KERN_INFO, "configured for PIO\n");
+			dev->xfer_mode = XFER_PIO_0;
+			dev->xfer_shift = ATA_SHIFT_PIO;
+			dev->flags |= ATA_DFLAG_PIO;
 		}
 	}
 	return 0;
_

Patches currently in -mm which might be from htejun@gmail.com are

git-libata-all.patch
libata-xfer_mask-is-unsigned-int-not-unsigned-long.patch
libata-add-toshiba-mk1637gsx-to-spurious-command-completion-list.patch
sata_nv-dont-use-legacy-dma-in-adma-mode-v3.patch
libata-set-proper-ata-udma-mode-for-bf548-according-to-system-clock-checkpatch-fixes.patch
ata-ahci-enclosure-management-via-led.patch
libata-fix-early-use-of-port-printk-checkpatch-fixes.patch
pata_amd-pata_via-de-couple-programming-of-pio-mwdma-and-udma-timings.patch
scsi-early-detection-of-medium-not-present-updated.patch
