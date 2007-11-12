From: akpm@linux-foundation.org
Subject: + libata-separate-out-ata_acpi_gtm_xfermask-from-pacpi_discover_modes.patch added to -mm tree
Date: Mon, 12 Nov 2007 13:16:44 -0800
Message-ID: <200711122116.lACLGihu009320@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54368 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752923AbXKLVR1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 16:17:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: htejun@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     libata: separate out ata_acpi_gtm_xfermask() from pacpi_discover_modes()
has been added to the -mm tree.  Its filename is
     libata-separate-out-ata_acpi_gtm_xfermask-from-pacpi_discover_modes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: separate out ata_acpi_gtm_xfermask() from pacpi_discover_modes()
From: Tejun Heo <htejun@gmail.com>

Finding out matching transfer mode from ACPI GTM values is useful for other
purposes too.  Separate out the function and timing tables from
pata_acpi::pacpi_discover_modes().

Other than checking shared-configuration bit after doing ata_acpi_gtm() in
pacpi_discover_modes() which should be safe, this patch doesn't introduce any
behavior change.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-acpi.c |   78 ++++++++++++++++++++++++++++++++++++
 drivers/ata/pata_acpi.c   |   66 +++++-------------------------
 include/linux/libata.h    |   25 +++++++++++
 3 files changed, 114 insertions(+), 55 deletions(-)

diff -puN drivers/ata/libata-acpi.c~libata-separate-out-ata_acpi_gtm_xfermask-from-pacpi_discover_modes drivers/ata/libata-acpi.c
--- a/drivers/ata/libata-acpi.c~libata-separate-out-ata_acpi_gtm_xfermask-from-pacpi_discover_modes
+++ a/drivers/ata/libata-acpi.c
@@ -421,6 +421,84 @@ int ata_acpi_cbl_80wire(struct ata_port 
 
 EXPORT_SYMBOL_GPL(ata_acpi_cbl_80wire);
 
+/* Welcome to ACPI, bring a bucket */
+const unsigned int ata_acpi_pio_cycle[7] = {
+	600, 383, 240, 180, 120, 100, 80
+};
+EXPORT_SYMBOL_GPL(ata_acpi_pio_cycle);
+
+const unsigned int ata_acpi_mwdma_cycle[5] = {
+	480, 150, 120, 100, 80
+};
+EXPORT_SYMBOL_GPL(ata_acpi_mwdma_cycle);
+
+const unsigned int ata_acpi_udma_cycle[7] = {
+	120, 80, 60, 45, 30, 20, 15
+};
+EXPORT_SYMBOL_GPL(ata_acpi_udma_cycle);
+
+/**
+ * ata_acpi_gtm_xfermode - determine xfermode from GTM parameter
+ * @dev: target device
+ * @gtm: GTM parameter to use
+ *
+ * Determine xfermask for @dev from @gtm.
+ *
+ * LOCKING:
+ * None.
+ *
+ * RETURNS:
+ * Determined xfermask.
+ */
+unsigned int ata_acpi_gtm_xfermask(struct ata_device *dev,
+				   const struct ata_acpi_gtm *gtm)
+{
+	int unit, i;
+	u32 t;
+	unsigned long mask = (0x7f << ATA_SHIFT_UDMA) | (0x7 << ATA_SHIFT_MWDMA) | (0x1F << ATA_SHIFT_PIO);
+
+	/* we always use the 0 slot for crap hardware */
+	unit = dev->devno;
+	if (!(gtm->flags & 0x10))
+		unit = 0;
+
+	/* start by scanning for PIO modes */
+	for (i = 0; i < 7; i++) {
+		t = gtm->drive[unit].pio;
+		if (t <= ata_acpi_pio_cycle[i]) {
+			mask |= (2 << (ATA_SHIFT_PIO + i)) - 1;
+			break;
+		}
+	}
+
+	/* See if we have MWDMA or UDMA data. We don't bother with
+	 * MWDMA if UDMA is available as this means the BIOS set UDMA
+	 * and our error changedown if it works is UDMA to PIO anyway.
+	 */
+	if (gtm->flags & (1 << (2 * unit))) {
+		/* MWDMA */
+		for (i = 0; i < 5; i++) {
+			t = gtm->drive[unit].dma;
+			if (t <= ata_acpi_mwdma_cycle[i]) {
+				mask |= (2 << (ATA_SHIFT_MWDMA + i)) - 1;
+				break;
+			}
+		}
+	} else {
+		/* UDMA */
+		for (i = 0; i < 7; i++) {
+			t = gtm->drive[unit].dma;
+			if (t <= ata_acpi_udma_cycle[i]) {
+				mask |= (2 << (ATA_SHIFT_UDMA + i)) - 1;
+				break;
+			}
+		}
+	}
+
+	return mask;
+}
+EXPORT_SYMBOL_GPL(ata_acpi_gtm_xfermask);
+
 /**
  * taskfile_load_raw - send taskfile registers to host controller
  * @dev: target ATA device
diff -puN drivers/ata/pata_acpi.c~libata-separate-out-ata_acpi_gtm_xfermask-from-pacpi_discover_modes drivers/ata/pata_acpi.c
--- a/drivers/ata/pata_acpi.c~libata-separate-out-ata_acpi_gtm_xfermask-from-pacpi_discover_modes
+++ a/drivers/ata/pata_acpi.c
@@ -81,17 +81,6 @@ static void pacpi_error_handler(struct a
 				  NULL, ata_std_postreset);
 }
 
-/* Welcome to ACPI, bring a bucket */
-static const unsigned int pio_cycle[7] = {
-	600, 383, 240, 180, 120, 100, 80
-};
-static const unsigned int mwdma_cycle[5] = {
-	480, 150, 120, 100, 80
-};
-static const unsigned int udma_cycle[7] = {
-	120, 80, 60, 45, 30, 20, 15
-};
-
 /**
  *	pacpi_discover_modes	-	filter non ACPI modes
  *	@adev: ATA device
@@ -103,56 +92,20 @@ static const unsigned int udma_cycle[7] 
 
 static unsigned long pacpi_discover_modes(struct ata_port *ap, struct ata_device *adev)
 {
-	int unit = adev->devno;
 	struct pata_acpi *acpi = ap->private_data;
-	int i;
-	u32 t;
-	unsigned long mask = (0x7f << ATA_SHIFT_UDMA) | (0x7 << ATA_SHIFT_MWDMA) | (0x1F << ATA_SHIFT_PIO);
-
 	struct ata_acpi_gtm probe;
+	unsigned int xfer_mask;
 
 	probe = acpi->gtm;
 
-	/* We always use the 0 slot for crap hardware */
-	if (!(probe.flags & 0x10))
-		unit = 0;
-
 	ata_acpi_gtm(ap, &probe);
 
-	/* Start by scanning for PIO modes */
-	for (i = 0; i < 7; i++) {
-		t = probe.drive[unit].pio;
-		if (t <= pio_cycle[i]) {
-			mask |= (2 << (ATA_SHIFT_PIO + i)) - 1;
-			break;
-		}
-	}
+	xfer_mask = ata_acpi_gtm_xfermask(adev, &probe);
 
-	/* See if we have MWDMA or UDMA data. We don't bother with MWDMA
-	   if UDMA is availabe as this means the BIOS set UDMA and our
-	   error changedown if it works is UDMA to PIO anyway */
-	if (probe.flags & (1 << (2 * unit))) {
-		/* MWDMA */
-		for (i = 0; i < 5; i++) {
-			t = probe.drive[unit].dma;
-			if (t <= mwdma_cycle[i]) {
-				mask |= (2 << (ATA_SHIFT_MWDMA + i)) - 1;
-				break;
-			}
-		}
-	} else {
-		/* UDMA */
-		for (i = 0; i < 7; i++) {
-			t = probe.drive[unit].dma;
-			if (t <= udma_cycle[i]) {
-				mask |= (2 << (ATA_SHIFT_UDMA + i)) - 1;
-				break;
-			}
-		}
-	}
-	if (mask & (0xF8 << ATA_SHIFT_UDMA))
+	if (xfer_mask & (0xF8 << ATA_SHIFT_UDMA))
 		ap->cbl = ATA_CBL_PATA80;
-	return mask;
+
+	return xfer_mask;
 }
 
 /**
@@ -185,7 +138,8 @@ static void pacpi_set_piomode(struct ata
 		unit = 0;
 
 	/* Now stuff the nS values into the structure */
-	acpi->gtm.drive[unit].pio = pio_cycle[adev->pio_mode - XFER_PIO_0];
+	acpi->gtm.drive[unit].pio =
+		ata_acpi_pio_cycle[adev->pio_mode - XFER_PIO_0];
 	ata_acpi_stm(ap, &acpi->gtm);
 	/* See what mode we actually got */
 	ata_acpi_gtm(ap, &acpi->gtm);
@@ -207,10 +161,12 @@ static void pacpi_set_dmamode(struct ata
 
 	/* Now stuff the nS values into the structure */
 	if (adev->dma_mode >= XFER_UDMA_0) {
-		acpi->gtm.drive[unit].dma = udma_cycle[adev->dma_mode - XFER_UDMA_0];
+		acpi->gtm.drive[unit].dma =
+			ata_acpi_udma_cycle[adev->dma_mode - XFER_UDMA_0];
 		acpi->gtm.flags |= (1 << (2 * unit));
 	} else {
-		acpi->gtm.drive[unit].dma = mwdma_cycle[adev->dma_mode - XFER_MW_DMA_0];
+		acpi->gtm.drive[unit].dma =
+			ata_acpi_mwdma_cycle[adev->dma_mode - XFER_MW_DMA_0];
 		acpi->gtm.flags &= ~(1 << (2 * unit));
 	}
 	ata_acpi_stm(ap, &acpi->gtm);
diff -puN include/linux/libata.h~libata-separate-out-ata_acpi_gtm_xfermask-from-pacpi_discover_modes include/linux/libata.h
--- a/include/linux/libata.h~libata-separate-out-ata_acpi_gtm_xfermask-from-pacpi_discover_modes
+++ a/include/linux/libata.h
@@ -952,11 +952,36 @@ enum {
 
 /* libata-acpi.c */
 #ifdef CONFIG_ATA_ACPI
+extern const unsigned int ata_acpi_pio_cycle[7];
+extern const unsigned int ata_acpi_mwdma_cycle[5];
+extern const unsigned int ata_acpi_udma_cycle[7];
+
 extern int ata_acpi_cbl_80wire(struct ata_port *ap);
 int ata_acpi_stm(const struct ata_port *ap, struct ata_acpi_gtm *stm);
 int ata_acpi_gtm(const struct ata_port *ap, struct ata_acpi_gtm *stm);
+unsigned int ata_acpi_gtm_xfermask(struct ata_device *dev,
+				   const struct ata_acpi_gtm *gtm);
+
 #else
 static inline int ata_acpi_cbl_80wire(struct ata_port *ap) { return 0; }
+
+static inline int ata_acpi_stm(const struct ata_port *ap,
+			       struct ata_acpi_gtm *stm)
+{
+	return -ENOSYS;
+}
+
+static inline int ata_acpi_gtm(const struct ata_port *ap,
+			       struct ata_acpi_gtm *stm)
+{
+	return -ENOSYS;
+}
+
+static inline unsigned int ata_acpi_gtm_xfermask(struct ata_device *dev,
+					const struct ata_acpi_gtm *gtm)
+{
+	return 0;
+}
 #endif
 
 #ifdef CONFIG_PCI
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
