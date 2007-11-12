From: akpm@linux-foundation.org
Subject: + ata_generic-unindent-loop-in-generic_set_mode.patch added to -mm tree
Date: Mon, 12 Nov 2007 13:16:36 -0800
Message-ID: <200711122116.lACLGa6V009301@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36958 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758214AbXKLVRJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 16:17:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: htejun@gmail.com


The patch titled
     ata_generic: unindent loop in generic_set_mode()
has been added to the -mm tree.  Its filename is
     ata_generic-unindent-loop-in-generic_set_mode.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
ata_generic-unindent-loop-in-generic_set_mode.patch
libata-export-xfermode--pata-timing-related-functions.patch
libata-clean-up-xfermode--pata-timing-related-stuff.patch
libata-kill-ata_id_to_dma_mode.patch
libata-xfer_mask-is-unsigned-int-not-unsigned-long.patch
libata-separate-out-ata_acpi_gtm_xfermask-from-pacpi_discover_modes.patch
libata-fix-ata_acpi_gtm_xfermask.patch
libata-implement-ata_timing_cycle2mode-and-use-it-in-libata-acpi-and-pata_acpi.patch
libata-implement-ata_acpi_init_gtm.patch
libata-reimplement-ata_acpi_cbl_80wire-using-ata_acpi_gtm_xfermask.patch
libata-add-ata_cbl_pata_ign.patch
pata_amd-update-mode-selection-for-nv-patas.patch
scsi-early-detection-of-medium-not-present-updated.patch
