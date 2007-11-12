From: akpm@linux-foundation.org
Subject: + libata-kill-ata_id_to_dma_mode.patch added to -mm tree
Date: Mon, 12 Nov 2007 13:16:41 -0800
Message-ID: <200711122116.lACLGfSA009313@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56375 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759273AbXKLVRV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 16:17:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: htejun@gmail.com


The patch titled
     libata: kill ata_id_to_dma_mode()
has been added to the -mm tree.  Its filename is
     libata-kill-ata_id_to_dma_mode.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: kill ata_id_to_dma_mode()
From: Tejun Heo <htejun@gmail.com>

ata_id_to_dma_mode() isn't quite generic.  The function is basically
privately implemented ata_id_xfermask() combined with hardcoded mode
printing and configuration which are specific to ata_generic.

Kill the function and open code it in generic_set_mode() using generic
xfermode handling functions.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ata_generic.c |   17 +++++++++++++-
 drivers/ata/libata-core.c |   43 ------------------------------------
 include/linux/libata.h    |    1 
 3 files changed, 16 insertions(+), 45 deletions(-)

diff -puN drivers/ata/ata_generic.c~libata-kill-ata_id_to_dma_mode drivers/ata/ata_generic.c
--- a/drivers/ata/ata_generic.c~libata-kill-ata_id_to_dma_mode
+++ a/drivers/ata/ata_generic.c
@@ -63,7 +63,22 @@ static int generic_set_mode(struct ata_l
 		/* We do need the right mode information for DMA or PIO
 		   and this comes from the current configuration flags */
 		if (dma_enabled & (1 << (5 + dev->devno))) {
-			ata_id_to_dma_mode(dev, XFER_MW_DMA_0);
+			unsigned int xfer_mask = ata_id_xfermask(dev->id);
+			const char *name;
+
+			if (xfer_mask & (ATA_MASK_MWDMA | ATA_MASK_UDMA))
+				name = ata_mode_string(xfer_mask);
+			else {
+				/* SWDMA perhaps? */
+				name = "DMA";
+				xfer_mask |= ata_xfer_mode2mask(XFER_MW_DMA_0);
+			}
+
+			ata_dev_printk(dev, KERN_INFO, "configured for %s\n",
+				       name);
+
+			dev->xfer_mode = ata_xfer_mask2mode(xfer_mask);
+			dev->xfer_shift = ata_xfer_mode2shift(dev->xfer_mode);
 			dev->flags &= ~ATA_DFLAG_PIO;
 		} else {
 			ata_dev_printk(dev, KERN_INFO, "configured for PIO\n");
diff -puN drivers/ata/libata-core.c~libata-kill-ata_id_to_dma_mode drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-kill-ata_id_to_dma_mode
+++ a/drivers/ata/libata-core.c
@@ -1278,48 +1278,6 @@ static int ata_hpa_resize(struct ata_dev
 }
 
 /**
- *	ata_id_to_dma_mode	-	Identify DMA mode from id block
- *	@dev: device to identify
- *	@unknown: mode to assume if we cannot tell
- *
- *	Set up the timing values for the device based upon the identify
- *	reported values for the DMA mode. This function is used by drivers
- *	which rely upon firmware configured modes, but wish to report the
- *	mode correctly when possible.
- *
- *	In addition we emit similarly formatted messages to the default
- *	ata_dev_set_mode handler, in order to provide consistency of
- *	presentation.
- */
-
-void ata_id_to_dma_mode(struct ata_device *dev, u8 unknown)
-{
-	unsigned int mask;
-	u8 mode;
-
-	/* Pack the DMA modes */
-	mask = ((dev->id[63] >> 8) << ATA_SHIFT_MWDMA) & ATA_MASK_MWDMA;
-	if (dev->id[53] & 0x04)
-		mask |= ((dev->id[88] >> 8) << ATA_SHIFT_UDMA) & ATA_MASK_UDMA;
-
-	/* Select the mode in use */
-	mode = ata_xfer_mask2mode(mask);
-
-	if (mode != 0xff) {
-		ata_dev_printk(dev, KERN_INFO, "configured for %s\n",
-		       ata_mode_string(mask));
-	} else {
-		/* SWDMA perhaps ? */
-		mode = unknown;
-		ata_dev_printk(dev, KERN_INFO, "configured for DMA\n");
-	}
-
-	/* Configure the device reporting */
-	dev->xfer_mode = mode;
-	dev->xfer_shift = ata_xfer_mode2shift(mode);
-}
-
-/**
  *	ata_noop_dev_select - Select device 0/1 on ATA bus
  *	@ap: ATA channel to manipulate
  *	@device: ATA device (numbered from zero) to select
@@ -7727,7 +7685,6 @@ EXPORT_SYMBOL_GPL(ata_host_resume);
 #endif /* CONFIG_PM */
 EXPORT_SYMBOL_GPL(ata_id_string);
 EXPORT_SYMBOL_GPL(ata_id_c_string);
-EXPORT_SYMBOL_GPL(ata_id_to_dma_mode);
 EXPORT_SYMBOL_GPL(ata_scsi_simulate);
 
 EXPORT_SYMBOL_GPL(ata_pio_need_iordy);
diff -puN include/linux/libata.h~libata-kill-ata_id_to_dma_mode include/linux/libata.h
--- a/include/linux/libata.h~libata-kill-ata_id_to_dma_mode
+++ a/include/linux/libata.h
@@ -885,7 +885,6 @@ extern void ata_id_string(const u16 *id,
 			  unsigned int ofs, unsigned int len);
 extern void ata_id_c_string(const u16 *id, unsigned char *s,
 			    unsigned int ofs, unsigned int len);
-extern void ata_id_to_dma_mode(struct ata_device *dev, u8 unknown);
 extern void ata_bmdma_setup(struct ata_queued_cmd *qc);
 extern void ata_bmdma_start(struct ata_queued_cmd *qc);
 extern void ata_bmdma_stop(struct ata_queued_cmd *qc);
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
