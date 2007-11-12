From: akpm@linux-foundation.org
Subject: + libata-clean-up-xfermode--pata-timing-related-stuff.patch added to -mm tree
Date: Mon, 12 Nov 2007 13:16:39 -0800
Message-ID: <200711122116.lACLGdnY009310@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51893 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758471AbXKLVRM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 16:17:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: htejun@gmail.com


The patch titled
     libata: clean up xfermode / PATA timing related stuff
has been added to the -mm tree.  Its filename is
     libata-clean-up-xfermode--pata-timing-related-stuff.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: clean up xfermode / PATA timing related stuff
From: Tejun Heo <htejun@gmail.com>

* s/ATA_BITS_(PIO|MWDMA|UDMA)/ATA_NR_\1_MODES/g

* Consistently use 0xff to indicate invalid transfer mode (0x00 is
  valid for PIO_SLOW).

* Make ata_xfer_mode2mask() return proper mode mask instead of just
  the highest bit.

* Sort ata_timing table in increasing xfermode order and update
  ata_timing_find_mode() accordingly.

This patch doesn't introduce any behavior change.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |   82 +++++++++++++++++-------------------
 include/linux/libata.h    |   19 ++++----
 2 files changed, 51 insertions(+), 50 deletions(-)

diff -puN drivers/ata/libata-core.c~libata-clean-up-xfermode--pata-timing-related-stuff drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-clean-up-xfermode--pata-timing-related-stuff
+++ a/drivers/ata/libata-core.c
@@ -478,9 +478,9 @@ static const struct ata_xfer_ent {
 	int shift, bits;
 	u8 base;
 } ata_xfer_tbl[] = {
-	{ ATA_SHIFT_PIO, ATA_BITS_PIO, XFER_PIO_0 },
-	{ ATA_SHIFT_MWDMA, ATA_BITS_MWDMA, XFER_MW_DMA_0 },
-	{ ATA_SHIFT_UDMA, ATA_BITS_UDMA, XFER_UDMA_0 },
+	{ ATA_SHIFT_PIO, ATA_NR_PIO_MODES, XFER_PIO_0 },
+	{ ATA_SHIFT_MWDMA, ATA_NR_MWDMA_MODES, XFER_MW_DMA_0 },
+	{ ATA_SHIFT_UDMA, ATA_NR_UDMA_MODES, XFER_UDMA_0 },
 	{ -1, },
 };
 
@@ -495,7 +495,7 @@ static const struct ata_xfer_ent {
  *	None.
  *
  *	RETURNS:
- *	Matching XFER_* value, 0 if no match found.
+ *	Matching XFER_* value, 0xff if no match found.
  */
 u8 ata_xfer_mask2mode(unsigned int xfer_mask)
 {
@@ -505,7 +505,7 @@ u8 ata_xfer_mask2mode(unsigned int xfer_
 	for (ent = ata_xfer_tbl; ent->shift >= 0; ent++)
 		if (highbit >= ent->shift && highbit < ent->shift + ent->bits)
 			return ent->base + highbit - ent->shift;
-	return 0;
+	return 0xff;
 }
 
 /**
@@ -526,7 +526,8 @@ unsigned int ata_xfer_mode2mask(u8 xfer_
 
 	for (ent = ata_xfer_tbl; ent->shift >= 0; ent++)
 		if (xfer_mode >= ent->base && xfer_mode < ent->base + ent->bits)
-			return 1 << (ent->shift + xfer_mode - ent->base);
+			return ((2 << (ent->shift + xfer_mode - ent->base)) - 1)
+				& ~((1 << ent->shift) - 1);
 	return 0;
 }
 
@@ -1304,7 +1305,7 @@ void ata_id_to_dma_mode(struct ata_devic
 	/* Select the mode in use */
 	mode = ata_xfer_mask2mode(mask);
 
-	if (mode != 0) {
+	if (mode != 0xff) {
 		ata_dev_printk(dev, KERN_INFO, "configured for %s\n",
 		       ata_mode_string(mask));
 	} else {
@@ -2855,38 +2856,33 @@ int sata_set_spd(struct ata_link *link)
  */
 
 static const struct ata_timing ata_timing[] = {
+/*	{ XFER_PIO_SLOW, 120, 290, 240, 960, 290, 240, 960,   0 }, */
+	{ XFER_PIO_0,     70, 290, 240, 600, 165, 150, 600,   0 },
+	{ XFER_PIO_1,     50, 290,  93, 383, 125, 100, 383,   0 },
+	{ XFER_PIO_2,     30, 290,  40, 330, 100,  90, 240,   0 },
+	{ XFER_PIO_3,     30,  80,  70, 180,  80,  70, 180,   0 },
+	{ XFER_PIO_4,     25,  70,  25, 120,  70,  25, 120,   0 },
+	{ XFER_PIO_5,     15,  65,  25, 100,  65,  25, 100,   0 },
+	{ XFER_PIO_6,     10,  55,  20,  80,  55,  20,  80,   0 },
 
-	{ XFER_UDMA_6,     0,   0,   0,   0,   0,   0,   0,  15 },
-	{ XFER_UDMA_5,     0,   0,   0,   0,   0,   0,   0,  20 },
-	{ XFER_UDMA_4,     0,   0,   0,   0,   0,   0,   0,  30 },
-	{ XFER_UDMA_3,     0,   0,   0,   0,   0,   0,   0,  45 },
+	{ XFER_SW_DMA_0, 120,   0,   0,   0, 480, 480, 960,   0 },
+	{ XFER_SW_DMA_1,  90,   0,   0,   0, 240, 240, 480,   0 },
+	{ XFER_SW_DMA_2,  60,   0,   0,   0, 120, 120, 240,   0 },
 
-	{ XFER_MW_DMA_4,  25,   0,   0,   0,  55,  20,  80,   0 },
+	{ XFER_MW_DMA_0,  60,   0,   0,   0, 215, 215, 480,   0 },
+	{ XFER_MW_DMA_1,  45,   0,   0,   0,  80,  50, 150,   0 },
+	{ XFER_MW_DMA_2,  25,   0,   0,   0,  70,  25, 120,   0 },
 	{ XFER_MW_DMA_3,  25,   0,   0,   0,  65,  25, 100,   0 },
-	{ XFER_UDMA_2,     0,   0,   0,   0,   0,   0,   0,  60 },
-	{ XFER_UDMA_1,     0,   0,   0,   0,   0,   0,   0,  80 },
-	{ XFER_UDMA_0,     0,   0,   0,   0,   0,   0,   0, 120 },
+	{ XFER_MW_DMA_4,  25,   0,   0,   0,  55,  20,  80,   0 },
 
 /*	{ XFER_UDMA_SLOW,  0,   0,   0,   0,   0,   0,   0, 150 }, */
-
-	{ XFER_MW_DMA_2,  25,   0,   0,   0,  70,  25, 120,   0 },
-	{ XFER_MW_DMA_1,  45,   0,   0,   0,  80,  50, 150,   0 },
-	{ XFER_MW_DMA_0,  60,   0,   0,   0, 215, 215, 480,   0 },
-
-	{ XFER_SW_DMA_2,  60,   0,   0,   0, 120, 120, 240,   0 },
-	{ XFER_SW_DMA_1,  90,   0,   0,   0, 240, 240, 480,   0 },
-	{ XFER_SW_DMA_0, 120,   0,   0,   0, 480, 480, 960,   0 },
-
-	{ XFER_PIO_6,     10,  55,  20,  80,  55,  20,  80,   0 },
-	{ XFER_PIO_5,     15,  65,  25, 100,  65,  25, 100,   0 },
-	{ XFER_PIO_4,     25,  70,  25, 120,  70,  25, 120,   0 },
-	{ XFER_PIO_3,     30,  80,  70, 180,  80,  70, 180,   0 },
-
-	{ XFER_PIO_2,     30, 290,  40, 330, 100,  90, 240,   0 },
-	{ XFER_PIO_1,     50, 290,  93, 383, 125, 100, 383,   0 },
-	{ XFER_PIO_0,     70, 290, 240, 600, 165, 150, 600,   0 },
-
-/*	{ XFER_PIO_SLOW, 120, 290, 240, 960, 290, 240, 960,   0 }, */
+	{ XFER_UDMA_0,     0,   0,   0,   0,   0,   0,   0, 120 },
+	{ XFER_UDMA_1,     0,   0,   0,   0,   0,   0,   0,  80 },
+	{ XFER_UDMA_2,     0,   0,   0,   0,   0,   0,   0,  60 },
+	{ XFER_UDMA_3,     0,   0,   0,   0,   0,   0,   0,  45 },
+	{ XFER_UDMA_4,     0,   0,   0,   0,   0,   0,   0,  30 },
+	{ XFER_UDMA_5,     0,   0,   0,   0,   0,   0,   0,  20 },
+	{ XFER_UDMA_6,     0,   0,   0,   0,   0,   0,   0,  15 },
 
 	{ 0xFF }
 };
@@ -2921,12 +2917,14 @@ void ata_timing_merge(const struct ata_t
 
 const struct ata_timing *ata_timing_find_mode(u8 xfer_mode)
 {
-	const struct ata_timing *t;
+	const struct ata_timing *t = ata_timing;
+
+	while (xfer_mode > t->mode)
+		t++;
 
-	for (t = ata_timing; t->mode != xfer_mode; t++)
-		if (t->mode == 0xFF)
-			return NULL;
-	return t;
+	if (xfer_mode == t->mode)
+		return t;
+	return NULL;
 }
 
 int ata_timing_compute(struct ata_device *adev, unsigned short speed,
@@ -3189,7 +3187,7 @@ int ata_do_set_mode(struct ata_link *lin
 		dev->dma_mode = ata_xfer_mask2mode(dma_mask);
 
 		found = 1;
-		if (dev->dma_mode)
+		if (dev->dma_mode != 0xff)
 			used_dma = 1;
 	}
 	if (!found)
@@ -3200,7 +3198,7 @@ int ata_do_set_mode(struct ata_link *lin
 		if (!ata_dev_enabled(dev))
 			continue;
 
-		if (!dev->pio_mode) {
+		if (dev->pio_mode == 0xff) {
 			ata_dev_printk(dev, KERN_WARNING, "no PIO support\n");
 			rc = -EINVAL;
 			goto out;
@@ -3214,7 +3212,7 @@ int ata_do_set_mode(struct ata_link *lin
 
 	/* step 3: set host DMA timings */
 	ata_link_for_each_dev(dev, link) {
-		if (!ata_dev_enabled(dev) || !dev->dma_mode)
+		if (!ata_dev_enabled(dev) || dev->dma_mode == 0xff)
 			continue;
 
 		dev->xfer_mode = dev->dma_mode;
diff -puN include/linux/libata.h~libata-clean-up-xfermode--pata-timing-related-stuff include/linux/libata.h
--- a/include/linux/libata.h~libata-clean-up-xfermode--pata-timing-related-stuff
+++ a/include/linux/libata.h
@@ -266,17 +266,20 @@ enum {
 	/* encoding various smaller bitmaps into a single
 	 * unsigned int bitmap
 	 */
-	ATA_BITS_PIO		= 7,
-	ATA_BITS_MWDMA		= 5,
-	ATA_BITS_UDMA		= 8,
+	ATA_NR_PIO_MODES	= 7,
+	ATA_NR_MWDMA_MODES	= 5,
+	ATA_NR_UDMA_MODES	= 8,
 
 	ATA_SHIFT_PIO		= 0,
-	ATA_SHIFT_MWDMA		= ATA_SHIFT_PIO + ATA_BITS_PIO,
-	ATA_SHIFT_UDMA		= ATA_SHIFT_MWDMA + ATA_BITS_MWDMA,
+	ATA_SHIFT_MWDMA		= ATA_SHIFT_PIO + ATA_NR_PIO_MODES,
+	ATA_SHIFT_UDMA		= ATA_SHIFT_MWDMA + ATA_NR_MWDMA_MODES,
 
-	ATA_MASK_PIO		= ((1 << ATA_BITS_PIO) - 1) << ATA_SHIFT_PIO,
-	ATA_MASK_MWDMA		= ((1 << ATA_BITS_MWDMA) - 1) << ATA_SHIFT_MWDMA,
-	ATA_MASK_UDMA		= ((1 << ATA_BITS_UDMA) - 1) << ATA_SHIFT_UDMA,
+	ATA_MASK_PIO		= ((1 << ATA_NR_PIO_MODES) - 1)
+					<< ATA_SHIFT_PIO,
+	ATA_MASK_MWDMA		= ((1 << ATA_NR_MWDMA_MODES) - 1)
+					<< ATA_SHIFT_MWDMA,
+	ATA_MASK_UDMA		= ((1 << ATA_NR_UDMA_MODES) - 1)
+					<< ATA_SHIFT_UDMA,
 
 	/* size of buffer to pad xfers ending on unaligned boundaries */
 	ATA_DMA_PAD_SZ		= 4,
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
