From: akpm@osdl.org
Subject: - via82cxxx-fix-cable-detection.patch removed from -mm tree
Date: Sat, 06 Jan 2007 23:58:06 -0800
Message-ID: <200701070758.l077w6SQ012933@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41142 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932504AbXAGIB2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 03:01:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: B.Zolnierkiewicz@elka.pw.edu.pl, alan@lxorguk.ukuu.org.uk, bzolnier@gmail.com, htejun@gmail.com, mm-commits@vger.kernel.org


The patch titled
     via82cxxx: fix cable detection
has been removed from the -mm tree.  Its filename was
     via82cxxx-fix-cable-detection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: via82cxxx: fix cable detection
From: Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>

This patch fixes 2.6.15 regression, is straightforward and tested.

Cable detection got broken probably while converting the driver to support
multiple controllers.  Cable detection is done by examining how BIOS
configured the attached devices.  The current code is broken in that it
examines the status *after* modifying Clk66 configuration ending up
detecting 40c cables as 80c.  This patch fixes it.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ide/pci/via82cxxx.c |  138 ++++++++++++++++------------------
 1 file changed, 65 insertions(+), 73 deletions(-)

diff -puN drivers/ide/pci/via82cxxx.c~via82cxxx-fix-cable-detection drivers/ide/pci/via82cxxx.c
--- a/drivers/ide/pci/via82cxxx.c~via82cxxx-fix-cable-detection
+++ a/drivers/ide/pci/via82cxxx.c
@@ -123,7 +123,7 @@ struct via82cxxx_dev
 static void via_set_speed(ide_hwif_t *hwif, u8 dn, struct ide_timing *timing)
 {
 	struct pci_dev *dev = hwif->pci_dev;
-	struct via82cxxx_dev *vdev = ide_get_hwifdata(hwif);
+	struct via82cxxx_dev *vdev = pci_get_drvdata(hwif->pci_dev);
 	u8 t;
 
 	if (~vdev->via_config->flags & VIA_BAD_AST) {
@@ -162,7 +162,7 @@ static void via_set_speed(ide_hwif_t *hw
 static int via_set_drive(ide_drive_t *drive, u8 speed)
 {
 	ide_drive_t *peer = HWIF(drive)->drives + (~drive->dn & 1);
-	struct via82cxxx_dev *vdev = ide_get_hwifdata(drive->hwif);
+	struct via82cxxx_dev *vdev = pci_get_drvdata(drive->hwif->pci_dev);
 	struct ide_timing t, p;
 	unsigned int T, UT;
 
@@ -225,7 +225,7 @@ static void via82cxxx_tune_drive(ide_dri
 static int via82cxxx_ide_dma_check (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = HWIF(drive);
-	struct via82cxxx_dev *vdev = ide_get_hwifdata(hwif);
+	struct via82cxxx_dev *vdev = pci_get_drvdata(hwif->pci_dev);
 	u16 w80 = hwif->udma_four;
 
 	u16 speed = ide_find_best_mode(drive,
@@ -262,6 +262,53 @@ static struct via_isa_bridge *via_config
 	return via_config;
 }
 
+/*
+ * Check and handle 80-wire cable presence
+ */
+static void __devinit via_cable_detect(struct via82cxxx_dev *vdev, u32 u)
+{
+	int i;
+
+	switch (vdev->via_config->flags & VIA_UDMA) {
+		case VIA_UDMA_66:
+			for (i = 24; i >= 0; i -= 8)
+				if (((u >> (i & 16)) & 8) &&
+				    ((u >> i) & 0x20) &&
+				     (((u >> i) & 7) < 2)) {
+					/*
+					 * 2x PCI clock and
+					 * UDMA w/ < 3T/cycle
+					 */
+					vdev->via_80w |= (1 << (1 - (i >> 4)));
+				}
+			break;
+
+		case VIA_UDMA_100:
+			for (i = 24; i >= 0; i -= 8)
+				if (((u >> i) & 0x10) ||
+				    (((u >> i) & 0x20) &&
+				     (((u >> i) & 7) < 4))) {
+					/* BIOS 80-wire bit or
+					 * UDMA w/ < 60ns/cycle
+					 */
+					vdev->via_80w |= (1 << (1 - (i >> 4)));
+				}
+			break;
+
+		case VIA_UDMA_133:
+			for (i = 24; i >= 0; i -= 8)
+				if (((u >> i) & 0x10) ||
+				    (((u >> i) & 0x20) &&
+				     (((u >> i) & 7) < 6))) {
+					/* BIOS 80-wire bit or
+					 * UDMA w/ < 60ns/cycle
+					 */
+					vdev->via_80w |= (1 << (1 - (i >> 4)));
+				}
+			break;
+	}
+}
+
 /**
  *	init_chipset_via82cxxx	-	initialization handler
  *	@dev: PCI device
@@ -274,14 +321,22 @@ static struct via_isa_bridge *via_config
 static unsigned int __devinit init_chipset_via82cxxx(struct pci_dev *dev, const char *name)
 {
 	struct pci_dev *isa = NULL;
+	struct via82cxxx_dev *vdev;
 	struct via_isa_bridge *via_config;
 	u8 t, v;
-	unsigned int u;
+	u32 u;
+
+	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
+	if (!vdev) {
+		printk(KERN_ERR "VP_IDE: out of memory :(\n");
+		return -ENOMEM;
+	}
+	pci_set_drvdata(dev, vdev);
 
 	/*
 	 * Find the ISA bridge to see how good the IDE is.
 	 */
-	via_config = via_config_find(&isa);
+	vdev->via_config = via_config = via_config_find(&isa);
 
 	/* We checked this earlier so if it fails here deeep badness
 	   is involved */
@@ -289,16 +344,17 @@ static unsigned int __devinit init_chips
 	BUG_ON(!via_config->id);
 
 	/*
-	 * Setup or disable Clk66 if appropriate
+	 * Detect cable and configure Clk66
 	 */
+	pci_read_config_dword(dev, VIA_UDMA_TIMING, &u);
+
+	via_cable_detect(vdev, u);
 
 	if ((via_config->flags & VIA_UDMA) == VIA_UDMA_66) {
 		/* Enable Clk66 */
-		pci_read_config_dword(dev, VIA_UDMA_TIMING, &u);
 		pci_write_config_dword(dev, VIA_UDMA_TIMING, u|0x80008);
 	} else if (via_config->flags & VIA_BAD_CLK66) {
 		/* Would cause trouble on 596a and 686 */
-		pci_read_config_dword(dev, VIA_UDMA_TIMING, &u);
 		pci_write_config_dword(dev, VIA_UDMA_TIMING, u & ~0x80008);
 	}
 
@@ -367,75 +423,11 @@ static unsigned int __devinit init_chips
 	return 0;
 }
 
-/*
- * Check and handle 80-wire cable presence
- */
-static void __devinit via_cable_detect(struct pci_dev *dev, struct via82cxxx_dev *vdev)
-{
-	unsigned int u;
-	int i;
-	pci_read_config_dword(dev, VIA_UDMA_TIMING, &u);
-
-	switch (vdev->via_config->flags & VIA_UDMA) {
-
-		case VIA_UDMA_66:
-			for (i = 24; i >= 0; i -= 8)
-				if (((u >> (i & 16)) & 8) &&
-				    ((u >> i) & 0x20) &&
-				     (((u >> i) & 7) < 2)) {
-					/*
-					 * 2x PCI clock and
-					 * UDMA w/ < 3T/cycle
-					 */
-					vdev->via_80w |= (1 << (1 - (i >> 4)));
-				}
-			break;
-
-		case VIA_UDMA_100:
-			for (i = 24; i >= 0; i -= 8)
-				if (((u >> i) & 0x10) ||
-				    (((u >> i) & 0x20) &&
-				     (((u >> i) & 7) < 4))) {
-					/* BIOS 80-wire bit or
-					 * UDMA w/ < 60ns/cycle
-					 */
-					vdev->via_80w |= (1 << (1 - (i >> 4)));
-				}
-			break;
-
-		case VIA_UDMA_133:
-			for (i = 24; i >= 0; i -= 8)
-				if (((u >> i) & 0x10) ||
-				    (((u >> i) & 0x20) &&
-				     (((u >> i) & 7) < 6))) {
-					/* BIOS 80-wire bit or
-					 * UDMA w/ < 60ns/cycle
-					 */
-					vdev->via_80w |= (1 << (1 - (i >> 4)));
-				}
-			break;
-
-	}
-}
-
 static void __devinit init_hwif_via82cxxx(ide_hwif_t *hwif)
 {
-	struct via82cxxx_dev *vdev = kmalloc(sizeof(struct via82cxxx_dev),
-		GFP_KERNEL);
-	struct pci_dev *isa = NULL;
+	struct via82cxxx_dev *vdev = pci_get_drvdata(hwif->pci_dev);
 	int i;
 
-	if (vdev == NULL) {
-		printk(KERN_ERR "VP_IDE: out of memory :(\n");
-		return;
-	}
-
-	memset(vdev, 0, sizeof(struct via82cxxx_dev));
-	ide_set_hwifdata(hwif, vdev);
-
-	vdev->via_config = via_config_find(&isa);
-	via_cable_detect(hwif->pci_dev, vdev);
-
 	hwif->autodma = 0;
 
 	hwif->tuneproc = &via82cxxx_tune_drive;
_

Patches currently in -mm which might be from B.Zolnierkiewicz@elka.pw.edu.pl are

toshiba-tc86c001-ide-driver-take-2.patch
hpt3xx-rework-rate-filtering.patch
hpt3xx-rework-rate-filtering-tidy.patch
hpt3xx-print-the-real-chip-name-at-startup.patch
hpt3xx-switch-to-using-pci_get_slot.patch
hpt3xx-cache-channels-mcr-address.patch
hpt3x7-merge-speedproc-handlers.patch
hpt370-clean-up-dma-timeout-handling.patch
hpt3xx-init-code-rewrite.patch
piix-fix-82371mx-enablebits.patch
