From: akpm@linux-foundation.org
Subject: + libata-fix-ata_acpi_gtm_xfermask.patch added to -mm tree
Date: Mon, 12 Nov 2007 13:16:46 -0800
Message-ID: <200711122116.lACLGkof009323@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37556 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753057AbXKLVR2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 16:17:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: htejun@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     libata: fix ata_acpi_gtm_xfermask()
has been added to the -mm tree.  Its filename is
     libata-fix-ata_acpi_gtm_xfermask.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: fix ata_acpi_gtm_xfermask()
From: Tejun Heo <htejun@gmail.com>

ata_acpi_gtm_xfermask() as separated out from pacpi_discover_modes()
has various bugs.  Fix them.

* The wrong comparison operator is used when finding for matching
  cycle resulting totally bogus result.

* With the comparion operator fixed, boundary condtion handling is
  clumsy.

* Setting of any DMA mask bit set all bits in PIO mask.

* MWDMA and UDMA blocks are swapped.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-acpi.c |   42 ++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff -puN drivers/ata/libata-acpi.c~libata-fix-ata_acpi_gtm_xfermask drivers/ata/libata-acpi.c
--- a/drivers/ata/libata-acpi.c~libata-fix-ata_acpi_gtm_xfermask
+++ a/drivers/ata/libata-acpi.c
@@ -453,49 +453,49 @@ EXPORT_SYMBOL_GPL(ata_acpi_udma_cycle);
 unsigned int ata_acpi_gtm_xfermask(struct ata_device *dev,
 				   const struct ata_acpi_gtm *gtm)
 {
+	unsigned int pio_mask = 0, mwdma_mask = 0, udma_mask = 0;
 	int unit, i;
 	u32 t;
-	unsigned long mask = (0x7f << ATA_SHIFT_UDMA) | (0x7 << ATA_SHIFT_MWDMA) | (0x1F << ATA_SHIFT_PIO);
 
 	/* we always use the 0 slot for crap hardware */
 	unit = dev->devno;
 	if (!(gtm->flags & 0x10))
 		unit = 0;
 
+	/* Values larger than the longest cycle results in 0 mask
+	 * while values equal to smaller than the shortest cycle
+	 * results in mask which includes all supported modes.
+	 * Disabled transfer method has the value of 0xffffffff which
+	 * will always result in 0 mask.
+	 */
+
 	/* start by scanning for PIO modes */
-	for (i = 0; i < 7; i++) {
-		t = gtm->drive[unit].pio;
-		if (t <= ata_acpi_pio_cycle[i]) {
-			mask |= (2 << (ATA_SHIFT_PIO + i)) - 1;
+	t = gtm->drive[unit].pio;
+	for (i = 0; i < ARRAY_SIZE(ata_acpi_pio_cycle); i++)
+		if (t > ata_acpi_pio_cycle[i])
 			break;
-		}
-	}
+	pio_mask = (1 << i) - 1;
 
 	/* See if we have MWDMA or UDMA data. We don't bother with
 	 * MWDMA if UDMA is available as this means the BIOS set UDMA
 	 * and our error changedown if it works is UDMA to PIO anyway.
 	 */
-	if (gtm->flags & (1 << (2 * unit))) {
+	t = gtm->drive[unit].dma;
+	if (!(gtm->flags & (1 << (2 * unit)))) {
 		/* MWDMA */
-		for (i = 0; i < 5; i++) {
-			t = gtm->drive[unit].dma;
-			if (t <= ata_acpi_mwdma_cycle[i]) {
-				mask |= (2 << (ATA_SHIFT_MWDMA + i)) - 1;
+		for (i = 0; i < ARRAY_SIZE(ata_acpi_mwdma_cycle); i++)
+			if (t > ata_acpi_mwdma_cycle[i])
 				break;
-			}
-		}
+		mwdma_mask = (1 << i) - 1;
 	} else {
 		/* UDMA */
-		for (i = 0; i < 7; i++) {
-			t = gtm->drive[unit].dma;
-			if (t <= ata_acpi_udma_cycle[i]) {
-				mask |= (2 << (ATA_SHIFT_UDMA + i)) - 1;
+		for (i = 0; i < ARRAY_SIZE(ata_acpi_udma_cycle); i++)
+			if (t > ata_acpi_udma_cycle[i])
 				break;
-			}
-		}
+		udma_mask = (1 << i) - 1;
 	}
 
-	return mask;
+	return ata_pack_xfermask(pio_mask, mwdma_mask, udma_mask);
 }
 EXPORT_SYMBOL_GPL(ata_acpi_gtm_xfermask);
 
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
