From: akpm@linux-foundation.org
Subject: + add-id_to_dma_mode-function-for-printing-dma-modes.patch added to -mm tree
Date: Wed, 21 Feb 2007 16:31:05 -0800
Message-ID: <200702220031.l1M0V5Ms031320@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59522 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965131AbXBVAb3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 19:31:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, htejun@gmail.com, jeff@garzik.org


The patch titled
     Add id_to_dma_mode function for printing DMA modes
has been added to the -mm tree.  Its filename is
     add-id_to_dma_mode-function-for-printing-dma-modes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add id_to_dma_mode function for printing DMA modes
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Also export dev_disable as this is needed by drivers doing slave decode
filtering, which will follow shortly

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |   44 ++++++++++++++++++++++++++++++++++++
 include/linux/libata.h    |    2 +
 2 files changed, 46 insertions(+)

diff -puN drivers/ata/libata-core.c~add-id_to_dma_mode-function-for-printing-dma-modes drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~add-id_to_dma_mode-function-for-printing-dma-modes
+++ a/drivers/ata/libata-core.c
@@ -824,6 +824,48 @@ static u64 ata_id_n_sectors(const u16 *i
 }
 
 /**
+ *	ata_id_to_dma_mode	-	Identify DMA mode from id block
+ *	@dev: device to identify
+ *	@mode: mode to assume if we cannot tell
+ *
+ *	Set up the timing values for the device based upon the identify
+ *	reported values for the DMA mode. This function is used by drivers
+ *	which rely upon firmware configured modes, but wish to report the
+ *	mode correctly when possible.
+ *
+ *	In addition we emit similarly formatted messages to the default
+ *	ata_dev_set_mode handler, in order to provide consistency of
+ *	presentation.
+ */
+
+void ata_id_to_dma_mode(struct ata_device *dev, u8 unknown)
+{
+	unsigned int mask;
+	u8 mode;
+
+	/* Pack the DMA modes */
+	mask = ((dev->id[63] >> 8) << ATA_SHIFT_MWDMA) & ATA_MASK_MWDMA;
+	if (dev->id[53] & 0x04)
+		mask |= ((dev->id[88] >> 8) << ATA_SHIFT_UDMA) & ATA_MASK_UDMA;
+
+	/* Select the mode in use */
+	mode = ata_xfer_mask2mode(mask);
+
+	if (mode != 0) {
+		ata_dev_printk(dev, KERN_INFO, "configured for %s\n",
+		       ata_mode_string(mask));
+	} else {
+		/* SWDMA perhaps ? */
+		mode = unknown;
+		ata_dev_printk(dev, KERN_INFO, "configured for DMA\n");
+	}
+
+	/* Configure the device reporting */
+	dev->xfer_mode = mode;
+	dev->xfer_shift = ata_xfer_mode2shift(mode);
+}
+
+/**
  *	ata_noop_dev_select - Select device 0/1 on ATA bus
  *	@ap: ATA channel to manipulate
  *	@device: ATA device (numbered from zero) to select
@@ -6283,6 +6325,7 @@ EXPORT_SYMBOL_GPL(ata_bmdma_drive_eh);
 EXPORT_SYMBOL_GPL(ata_bmdma_error_handler);
 EXPORT_SYMBOL_GPL(ata_bmdma_post_internal_cmd);
 EXPORT_SYMBOL_GPL(ata_port_probe);
+EXPORT_SYMBOL_GPL(ata_dev_disable);
 EXPORT_SYMBOL_GPL(sata_set_spd);
 EXPORT_SYMBOL_GPL(sata_phy_debounce);
 EXPORT_SYMBOL_GPL(sata_phy_resume);
@@ -6317,6 +6360,7 @@ EXPORT_SYMBOL_GPL(ata_host_suspend);
 EXPORT_SYMBOL_GPL(ata_host_resume);
 EXPORT_SYMBOL_GPL(ata_id_string);
 EXPORT_SYMBOL_GPL(ata_id_c_string);
+EXPORT_SYMBOL_GPL(ata_id_to_dma_mode);
 EXPORT_SYMBOL_GPL(ata_device_blacklisted);
 EXPORT_SYMBOL_GPL(ata_scsi_simulate);
 
diff -puN include/linux/libata.h~add-id_to_dma_mode-function-for-printing-dma-modes include/linux/libata.h
--- a/include/linux/libata.h~add-id_to_dma_mode-function-for-printing-dma-modes
+++ a/include/linux/libata.h
@@ -788,10 +788,12 @@ extern void ata_sg_init_one(struct ata_q
 extern void ata_sg_init(struct ata_queued_cmd *qc, struct scatterlist *sg,
 		 unsigned int n_elem);
 extern unsigned int ata_dev_classify(const struct ata_taskfile *tf);
+extern void ata_dev_disable(struct ata_device *adev);
 extern void ata_id_string(const u16 *id, unsigned char *s,
 			  unsigned int ofs, unsigned int len);
 extern void ata_id_c_string(const u16 *id, unsigned char *s,
 			    unsigned int ofs, unsigned int len);
+extern void ata_id_to_dma_mode(struct ata_device *dev, u8 unknown);
 extern unsigned long ata_device_blacklisted(const struct ata_device *dev);
 extern void ata_bmdma_setup (struct ata_queued_cmd *qc);
 extern void ata_bmdma_start (struct ata_queued_cmd *qc);
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
libata-warn-if-speed-limited-due-to-40-wire-cable-v2.patch
add-id_to_dma_mode-function-for-printing-dma-modes.patch
expose-set_mode-method-so-it-can-be-wrapped.patch
acpi-driver-support-for-pata.patch
libata-use-new-id_to_dma_mode-function-to-tidy-reporting.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
adjust-legacy-ide-resource-setting-v2.patch
resend-iphase-64bit-cleanup.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
driver_bfin_serial_core.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
