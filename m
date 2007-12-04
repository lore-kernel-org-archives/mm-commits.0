From: akpm@linux-foundation.org
Subject: - libata-implement-ata_timing_cycle2mode-and-use-it-in-libata-acpi-and-pata_acpi.patch removed from -mm tree
Date: Mon, 03 Dec 2007 23:38:04 -0800
Message-ID: <200712040738.lB47c4Fs006869@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47865 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751913AbXLDHt3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 02:49:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: htejun@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     libata: implement ata_timing_cycle2mode() and use it in libata-acpi and pata_acpi
has been removed from the -mm tree.  Its filename was
     libata-implement-ata_timing_cycle2mode-and-use-it-in-libata-acpi-and-pata_acpi.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: libata: implement ata_timing_cycle2mode() and use it in libata-acpi and pata_acpi
From: Tejun Heo <htejun@gmail.com>

libata-acpi is using separate timing tables for transfer modes although
libata-core has the complete ata_timing table.  Implement
ata_timing_cycle2mode() to look for matching mode given transfer type and
cycle duration and use it in libata-acpi and pata_acpi to replace private
timing tables.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-acpi.c |   62 ++++++++----------------------------
 drivers/ata/libata-core.c |   52 ++++++++++++++++++++++++++++++
 drivers/ata/pata_acpi.c   |   13 ++++---
 include/linux/libata.h    |    5 --
 4 files changed, 75 insertions(+), 57 deletions(-)

diff -puN drivers/ata/libata-acpi.c~libata-implement-ata_timing_cycle2mode-and-use-it-in-libata-acpi-and-pata_acpi drivers/ata/libata-acpi.c
--- a/drivers/ata/libata-acpi.c~libata-implement-ata_timing_cycle2mode-and-use-it-in-libata-acpi-and-pata_acpi
+++ a/drivers/ata/libata-acpi.c
@@ -421,22 +421,6 @@ int ata_acpi_cbl_80wire(struct ata_port 
 
 EXPORT_SYMBOL_GPL(ata_acpi_cbl_80wire);
 
-/* Welcome to ACPI, bring a bucket */
-const unsigned int ata_acpi_pio_cycle[7] = {
-	600, 383, 240, 180, 120, 100, 80
-};
-EXPORT_SYMBOL_GPL(ata_acpi_pio_cycle);
-
-const unsigned int ata_acpi_mwdma_cycle[5] = {
-	480, 150, 120, 100, 80
-};
-EXPORT_SYMBOL_GPL(ata_acpi_mwdma_cycle);
-
-const unsigned int ata_acpi_udma_cycle[7] = {
-	120, 80, 60, 45, 30, 20, 15
-};
-EXPORT_SYMBOL_GPL(ata_acpi_udma_cycle);
-
 /**
  * ata_acpi_gtm_xfermode - determine xfermode from GTM parameter
  * @dev: target device
@@ -453,49 +437,33 @@ EXPORT_SYMBOL_GPL(ata_acpi_udma_cycle);
 unsigned int ata_acpi_gtm_xfermask(struct ata_device *dev,
 				   const struct ata_acpi_gtm *gtm)
 {
-	unsigned int pio_mask = 0, mwdma_mask = 0, udma_mask = 0;
-	int unit, i;
-	u32 t;
+	unsigned int xfer_mask = 0;
+	unsigned int type;
+	int unit;
+	u8 mode;
 
 	/* we always use the 0 slot for crap hardware */
 	unit = dev->devno;
 	if (!(gtm->flags & 0x10))
 		unit = 0;
 
-	/* Values larger than the longest cycle results in 0 mask
-	 * while values equal to smaller than the shortest cycle
-	 * results in mask which includes all supported modes.
-	 * Disabled transfer method has the value of 0xffffffff which
-	 * will always result in 0 mask.
-	 */
-
-	/* start by scanning for PIO modes */
-	t = gtm->drive[unit].pio;
-	for (i = 0; i < ARRAY_SIZE(ata_acpi_pio_cycle); i++)
-		if (t > ata_acpi_pio_cycle[i])
-			break;
-	pio_mask = (1 << i) - 1;
+	/* PIO */
+	mode = ata_timing_cycle2mode(ATA_SHIFT_PIO, gtm->drive[unit].pio);
+	xfer_mask |= ata_xfer_mode2mask(mode);
 
 	/* See if we have MWDMA or UDMA data. We don't bother with
 	 * MWDMA if UDMA is available as this means the BIOS set UDMA
 	 * and our error changedown if it works is UDMA to PIO anyway.
 	 */
-	t = gtm->drive[unit].dma;
-	if (!(gtm->flags & (1 << (2 * unit)))) {
-		/* MWDMA */
-		for (i = 0; i < ARRAY_SIZE(ata_acpi_mwdma_cycle); i++)
-			if (t > ata_acpi_mwdma_cycle[i])
-				break;
-		mwdma_mask = (1 << i) - 1;
-	} else {
-		/* UDMA */
-		for (i = 0; i < ARRAY_SIZE(ata_acpi_udma_cycle); i++)
-			if (t > ata_acpi_udma_cycle[i])
-				break;
-		udma_mask = (1 << i) - 1;
-	}
+	if (!(gtm->flags & (1 << (2 * unit))))
+		type = ATA_SHIFT_MWDMA;
+	else
+		type = ATA_SHIFT_UDMA;
+
+	mode = ata_timing_cycle2mode(type, gtm->drive[unit].dma);
+	xfer_mask |= ata_xfer_mode2mask(mode);
 
-	return ata_pack_xfermask(pio_mask, mwdma_mask, udma_mask);
+	return xfer_mask;
 }
 EXPORT_SYMBOL_GPL(ata_acpi_gtm_xfermask);
 
diff -puN drivers/ata/libata-core.c~libata-implement-ata_timing_cycle2mode-and-use-it-in-libata-acpi-and-pata_acpi drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-implement-ata_timing_cycle2mode-and-use-it-in-libata-acpi-and-pata_acpi
+++ a/drivers/ata/libata-core.c
@@ -2882,6 +2882,57 @@ int ata_timing_compute(struct ata_device
 }
 
 /**
+ *	ata_timing_cycle2mode - find xfer mode for the specified cycle duration
+ *	@xfer_shift: ATA_SHIFT_* value for transfer type to examine.
+ *	@cycle: cycle duration in ns
+ *
+ *	Return matching xfer mode for @cycle.  The returned mode is of
+ *	the transfer type specified by @xfer_shift.  If @cycle is too
+ *	slow for @xfer_shift, 0xff is returned.  If @cycle is faster
+ *	than the fastest known mode, the fasted mode is returned.
+ *
+ *	LOCKING:
+ *	None.
+ *
+ *	RETURNS:
+ *	Matching xfer_mode, 0xff if no match found.
+ */
+u8 ata_timing_cycle2mode(unsigned int xfer_shift, int cycle)
+{
+	u8 base_mode = 0xff, last_mode = 0xff;
+	const struct ata_xfer_ent *ent;
+	const struct ata_timing *t;
+
+	for (ent = ata_xfer_tbl; ent->shift >= 0; ent++)
+		if (ent->shift == xfer_shift)
+			base_mode = ent->base;
+
+	for (t = ata_timing_find_mode(base_mode);
+	     t && ata_xfer_mode2shift(t->mode) == xfer_shift; t++) {
+		unsigned short this_cycle;
+
+		switch (xfer_shift) {
+		case ATA_SHIFT_PIO:
+		case ATA_SHIFT_MWDMA:
+			this_cycle = t->cycle;
+			break;
+		case ATA_SHIFT_UDMA:
+			this_cycle = t->udma;
+			break;
+		default:
+			return 0xff;
+		}
+
+		if (cycle > this_cycle)
+			break;
+
+		last_mode = t->mode;
+	}
+
+	return last_mode;
+}
+
+/**
  *	ata_down_xfermask_limit - adjust dev xfer masks downward
  *	@dev: Device to adjust xfer masks
  *	@sel: ATA_DNXFER_* selector
@@ -7614,6 +7665,7 @@ EXPORT_SYMBOL_GPL(ata_pio_need_iordy);
 EXPORT_SYMBOL_GPL(ata_timing_find_mode);
 EXPORT_SYMBOL_GPL(ata_timing_compute);
 EXPORT_SYMBOL_GPL(ata_timing_merge);
+EXPORT_SYMBOL_GPL(ata_timing_cycle2mode);
 
 #ifdef CONFIG_PCI
 EXPORT_SYMBOL_GPL(pci_test_config_bits);
diff -puN drivers/ata/pata_acpi.c~libata-implement-ata_timing_cycle2mode-and-use-it-in-libata-acpi-and-pata_acpi drivers/ata/pata_acpi.c
--- a/drivers/ata/pata_acpi.c~libata-implement-ata_timing_cycle2mode-and-use-it-in-libata-acpi-and-pata_acpi
+++ a/drivers/ata/pata_acpi.c
@@ -133,13 +133,14 @@ static void pacpi_set_piomode(struct ata
 {
 	int unit = adev->devno;
 	struct pata_acpi *acpi = ap->private_data;
+	const struct ata_timing *t;
 
 	if (!(acpi->gtm.flags & 0x10))
 		unit = 0;
 
 	/* Now stuff the nS values into the structure */
-	acpi->gtm.drive[unit].pio =
-		ata_acpi_pio_cycle[adev->pio_mode - XFER_PIO_0];
+	t = ata_timing_find_mode(adev->pio_mode);
+	acpi->gtm.drive[unit].pio = t->cycle;
 	ata_acpi_stm(ap, &acpi->gtm);
 	/* See what mode we actually got */
 	ata_acpi_gtm(ap, &acpi->gtm);
@@ -155,18 +156,18 @@ static void pacpi_set_dmamode(struct ata
 {
 	int unit = adev->devno;
 	struct pata_acpi *acpi = ap->private_data;
+	const struct ata_timing *t;
 
 	if (!(acpi->gtm.flags & 0x10))
 		unit = 0;
 
 	/* Now stuff the nS values into the structure */
+	t = ata_timing_find_mode(adev->dma_mode);
 	if (adev->dma_mode >= XFER_UDMA_0) {
-		acpi->gtm.drive[unit].dma =
-			ata_acpi_udma_cycle[adev->dma_mode - XFER_UDMA_0];
+		acpi->gtm.drive[unit].dma = t->udma;
 		acpi->gtm.flags |= (1 << (2 * unit));
 	} else {
-		acpi->gtm.drive[unit].dma =
-			ata_acpi_mwdma_cycle[adev->dma_mode - XFER_MW_DMA_0];
+		acpi->gtm.drive[unit].dma = t->cycle;
 		acpi->gtm.flags &= ~(1 << (2 * unit));
 	}
 	ata_acpi_stm(ap, &acpi->gtm);
diff -puN include/linux/libata.h~libata-implement-ata_timing_cycle2mode-and-use-it-in-libata-acpi-and-pata_acpi include/linux/libata.h
--- a/include/linux/libata.h~libata-implement-ata_timing_cycle2mode-and-use-it-in-libata-acpi-and-pata_acpi
+++ a/include/linux/libata.h
@@ -930,6 +930,7 @@ extern int ata_timing_compute(struct ata
 extern void ata_timing_merge(const struct ata_timing *,
 			     const struct ata_timing *, struct ata_timing *,
 			     unsigned int);
+extern u8 ata_timing_cycle2mode(unsigned int xfer_shift, int cycle);
 
 enum {
 	ATA_TIMING_SETUP	= (1 << 0),
@@ -950,10 +951,6 @@ enum {
 
 /* libata-acpi.c */
 #ifdef CONFIG_ATA_ACPI
-extern const unsigned int ata_acpi_pio_cycle[7];
-extern const unsigned int ata_acpi_mwdma_cycle[5];
-extern const unsigned int ata_acpi_udma_cycle[7];
-
 extern int ata_acpi_cbl_80wire(struct ata_port *ap);
 int ata_acpi_stm(const struct ata_port *ap, struct ata_acpi_gtm *stm);
 int ata_acpi_gtm(const struct ata_port *ap, struct ata_acpi_gtm *stm);
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
