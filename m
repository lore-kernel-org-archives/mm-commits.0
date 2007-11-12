From: akpm@linux-foundation.org
Subject: + libata-reimplement-ata_acpi_cbl_80wire-using-ata_acpi_gtm_xfermask.patch added to -mm tree
Date: Mon, 12 Nov 2007 13:16:51 -0800
Message-ID: <200711122116.lACLGp9F009402@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56305 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753057AbXKLV0y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 16:26:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: htejun@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     libata: reimplement ata_acpi_cbl_80wire() using ata_acpi_gtm_xfermask()
has been added to the -mm tree.  Its filename is
     libata-reimplement-ata_acpi_cbl_80wire-using-ata_acpi_gtm_xfermask.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: reimplement ata_acpi_cbl_80wire() using ata_acpi_gtm_xfermask()
From: Tejun Heo <htejun@gmail.com>

Reimplement ata_acpi_cbl_80wire() using ata_acpi_gtm_xfermask() and while at
it relocate the function below ata_acpi_gtm_xfermask().

New ata_acpi_cbl_80wire() implementation takes @gtm, in both pata_via and
pata_amd, use the initial GTM value.  Both are trying to peek initial BIOS
configuration, so using initial caching value makes sense.  This fixes ACPI
part of cable detection in pata_amd which previously always returned 0 because
configuring PIO0 during reset clears DMA configuration.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-acpi.c |   66 +++++++++++++++---------------------
 drivers/ata/pata_amd.c    |    3 +
 drivers/ata/pata_via.c    |    3 +
 include/linux/libata.h    |   10 +++--
 4 files changed, 39 insertions(+), 43 deletions(-)

diff -puN drivers/ata/libata-acpi.c~libata-reimplement-ata_acpi_cbl_80wire-using-ata_acpi_gtm_xfermask drivers/ata/libata-acpi.c
--- a/drivers/ata/libata-acpi.c~libata-reimplement-ata_acpi_cbl_80wire-using-ata_acpi_gtm_xfermask
+++ a/drivers/ata/libata-acpi.c
@@ -387,44 +387,6 @@ static int ata_dev_get_GTF(struct ata_de
 }
 
 /**
- * ata_acpi_cbl_80wire		-	Check for 80 wire cable
- * @ap: Port to check
- *
- * Return 1 if the ACPI mode data for this port indicates the BIOS selected
- * an 80wire mode.
- */
-
-int ata_acpi_cbl_80wire(struct ata_port *ap)
-{
-	struct ata_acpi_gtm gtm;
-	int valid = 0;
-
-	/* No _GTM data, no information */
-	if (ata_acpi_gtm(ap, &gtm) < 0)
-		return 0;
-
-	/* Split timing, DMA enabled */
-	if ((gtm.flags & 0x11) == 0x11 && gtm.drive[0].dma < 55)
-		valid |= 1;
-	if ((gtm.flags & 0x14) == 0x14 && gtm.drive[1].dma < 55)
-		valid |= 2;
-	/* Shared timing, DMA enabled */
-	if ((gtm.flags & 0x11) == 0x01 && gtm.drive[0].dma < 55)
-		valid |= 1;
-	if ((gtm.flags & 0x14) == 0x04 && gtm.drive[0].dma < 55)
-		valid |= 2;
-
-	/* Drive check */
-	if ((valid & 1) && ata_dev_enabled(&ap->link.device[0]))
-		return 1;
-	if ((valid & 2) && ata_dev_enabled(&ap->link.device[1]))
-		return 1;
-	return 0;
-}
-
-EXPORT_SYMBOL_GPL(ata_acpi_cbl_80wire);
-
-/**
  * ata_acpi_gtm_xfermode - determine xfermode from GTM parameter
  * @dev: target device
  * @gtm: GTM parameter to use
@@ -471,6 +433,34 @@ unsigned int ata_acpi_gtm_xfermask(struc
 EXPORT_SYMBOL_GPL(ata_acpi_gtm_xfermask);
 
 /**
+ * ata_acpi_cbl_80wire		-	Check for 80 wire cable
+ * @ap: Port to check
+ * @gtm: GTM data to use
+ *
+ * Return 1 if the @gtm indicates the BIOS selected an 80wire mode.
+ */
+int ata_acpi_cbl_80wire(struct ata_port *ap, const struct ata_acpi_gtm *gtm)
+{
+	struct ata_device *dev;
+
+	ata_link_for_each_dev(dev, &ap->link) {
+		unsigned int xfer_mask, udma_mask;
+
+		if (!ata_dev_enabled(dev))
+			continue;
+
+		xfer_mask = ata_acpi_gtm_xfermask(dev, gtm);
+		ata_unpack_xfermask(xfer_mask, NULL, NULL, &udma_mask);
+
+		if (udma_mask & ~ATA_UDMA_MASK_40C)
+			return 1;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ata_acpi_cbl_80wire);
+
+/**
  * taskfile_load_raw - send taskfile registers to host controller
  * @dev: target ATA device
  * @gtf: raw ATA taskfile register set (0x1f1 - 0x1f7)
diff -puN drivers/ata/pata_amd.c~libata-reimplement-ata_acpi_cbl_80wire-using-ata_acpi_gtm_xfermask drivers/ata/pata_amd.c
--- a/drivers/ata/pata_amd.c~libata-reimplement-ata_acpi_cbl_80wire-using-ata_acpi_gtm_xfermask
+++ a/drivers/ata/pata_amd.c
@@ -271,7 +271,8 @@ static int nv_cable_detect(struct ata_po
  	if ((udma & 0xC4) == 0xC4 || (udma & 0xC400) == 0xC400)
 		cbl = ATA_CBL_PATA80;
 	/* And a triple check across suspend/resume with ACPI around */
-	if (ata_acpi_cbl_80wire(ap))
+	if (ata_acpi_init_gtm(ap) &&
+	    ata_acpi_cbl_80wire(ap, ata_acpi_init_gtm(ap)))
 		cbl = ATA_CBL_PATA80;
 	return cbl;
 }
diff -puN drivers/ata/pata_via.c~libata-reimplement-ata_acpi_cbl_80wire-using-ata_acpi_gtm_xfermask drivers/ata/pata_via.c
--- a/drivers/ata/pata_via.c~libata-reimplement-ata_acpi_cbl_80wire-using-ata_acpi_gtm_xfermask
+++ a/drivers/ata/pata_via.c
@@ -185,7 +185,8 @@ static int via_cable_detect(struct ata_p
 	if (ata66 & (0x10100000 >> (16 * ap->port_no)))
 		return ATA_CBL_PATA80;
 	/* Check with ACPI so we can spot BIOS reported SATA bridges */
-	if (ata_acpi_cbl_80wire(ap))
+	if (ata_acpi_init_gtm(ap) &&
+	    ata_acpi_cbl_80wire(ap, ata_acpi_init_gtm(ap)))
 		return ATA_CBL_PATA80;
 	return ATA_CBL_PATA40;
 }
diff -puN include/linux/libata.h~libata-reimplement-ata_acpi_cbl_80wire-using-ata_acpi_gtm_xfermask include/linux/libata.h
--- a/include/linux/libata.h~libata-reimplement-ata_acpi_cbl_80wire-using-ata_acpi_gtm_xfermask
+++ a/include/linux/libata.h
@@ -961,19 +961,17 @@ static inline const struct ata_acpi_gtm 
 		return &ap->__acpi_init_gtm;
 	return NULL;
 }
-extern int ata_acpi_cbl_80wire(struct ata_port *ap);
 int ata_acpi_stm(const struct ata_port *ap, struct ata_acpi_gtm *stm);
 int ata_acpi_gtm(const struct ata_port *ap, struct ata_acpi_gtm *stm);
 unsigned int ata_acpi_gtm_xfermask(struct ata_device *dev,
 				   const struct ata_acpi_gtm *gtm);
+int ata_acpi_cbl_80wire(struct ata_port *ap, const struct ata_acpi_gtm *gtm);
 #else
 static inline const struct ata_acpi_gtm *ata_acpi_init_gtm(struct ata_port *ap)
 {
 	return NULL;
 }
 
-static inline int ata_acpi_cbl_80wire(struct ata_port *ap) { return 0; }
-
 static inline int ata_acpi_stm(const struct ata_port *ap,
 			       struct ata_acpi_gtm *stm)
 {
@@ -991,6 +989,12 @@ static inline unsigned int ata_acpi_gtm_
 {
 	return 0;
 }
+
+static inline int ata_acpi_cbl_80wire(struct ata_port *ap,
+				      const struct ata_acpi_gtm *gtm)
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
