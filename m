From: akpm@osdl.org
Subject: - ide-fix-hpt3xx-hotswap-support.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:18:47 -0800
Message-ID: <200612140618.kBE6IkEN002353@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52988 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974AbWLNGWT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:22:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sshtylyov@ru.mvista.com, B.Zolnierkiewicz@elka.pw.edu.pl, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     ide: fix HPT3xx hotswap support
has been removed from the -mm tree.  Its filename was
     ide-fix-hpt3xx-hotswap-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ide: fix HPT3xx hotswap support
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

Fix the broken hotswap code: on HPT37x it caused RESET- to glitch when
tristating the bus (the MISC control 3/6 and soft control 2 need to be written
to in the certain order), and for HPT36x the obsolete HDIO_TRISTATE_HWIF
ioctl() handler was called instead which treated the state argument wrong. 
Also, get rid of the soft control reg.  1 wtite to enable IDE interrupt --
this is done in init_hpt37x() already...

Have been tested on HPT370 and 371N.

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ide/pci/hpt366.c |  115 +++++++++++--------------------------
 1 file changed, 36 insertions(+), 79 deletions(-)

diff -puN drivers/ide/pci/hpt366.c~ide-fix-hpt3xx-hotswap-support drivers/ide/pci/hpt366.c
--- a/drivers/ide/pci/hpt366.c~ide-fix-hpt3xx-hotswap-support
+++ a/drivers/ide/pci/hpt366.c
@@ -70,6 +70,8 @@
  * - fix/remove bad/unused timing tables and use one set of tables for the whole
  *   HPT37x chip family; save space by introducing the separate transfer mode
  *   table in which the mode lookup is done
+ * - fix the hotswap code:  it caused RESET- to glitch when tristating the bus,
+ *   and for HPT36x the obsolete HDIO_TRISTATE_HWIF handler was called instead
  *		<source@mvista.com>
  *
  */
@@ -914,101 +916,68 @@ static void hpt3xxn_rw_disk(ide_drive_t 
 	hpt3xxn_set_clock(hwif, wantclock);
 }
 
-/*
- * Since SUN Cobalt is attempting to do this operation, I should disclose
- * this has been a long time ago Thu Jul 27 16:40:57 2000 was the patch date
- * HOTSWAP ATA Infrastructure.
- */
-
-static void hpt3xx_reset (ide_drive_t *drive)
-{
-}
-
-static int hpt3xx_tristate (ide_drive_t * drive, int state)
-{
-	ide_hwif_t *hwif	= HWIF(drive);
-	struct pci_dev *dev	= hwif->pci_dev;
-	u8 reg59h = 0, reset	= (hwif->channel) ? 0x80 : 0x40;
-	u8 regXXh = 0, state_reg= (hwif->channel) ? 0x57 : 0x53;
-
-	pci_read_config_byte(dev, 0x59, &reg59h);
-	pci_read_config_byte(dev, state_reg, &regXXh);
-
-	if (state) {
-		(void) ide_do_reset(drive);
-		pci_write_config_byte(dev, state_reg, regXXh|0x80);
-		pci_write_config_byte(dev, 0x59, reg59h|reset);
-	} else {
-		pci_write_config_byte(dev, 0x59, reg59h & ~(reset));
-		pci_write_config_byte(dev, state_reg, regXXh & ~(0x80));
-		(void) ide_do_reset(drive);
-	}
-	return 0;
-}
-
 /* 
- * set/get power state for a drive.
- * turning the power off does the following things:
- *   1) soft-reset the drive
- *   2) tri-states the ide bus
+ * Set/get power state for a drive.
  *
- * when we turn things back on, we need to re-initialize things.
+ * When we turn the power back on, we need to re-initialize things.
  */
 #define TRISTATE_BIT  0x8000
-static int hpt370_busproc(ide_drive_t * drive, int state)
+
+static int hpt3xx_busproc(ide_drive_t *drive, int state)
 {
 	ide_hwif_t *hwif	= drive->hwif;
 	struct pci_dev *dev	= hwif->pci_dev;
-	u8 tristate = 0, resetmask = 0, bus_reg = 0;
-	u16 tri_reg;
+	u8  tristate, resetmask, bus_reg = 0;
+	u16 tri_reg = 0;
 
 	hwif->bus_state = state;
 
 	if (hwif->channel) { 
 		/* secondary channel */
-		tristate = 0x56;
-		resetmask = 0x80; 
+		tristate  = 0x56;
+		resetmask = 0x80;
 	} else { 
 		/* primary channel */
-		tristate = 0x52;
+		tristate  = 0x52;
 		resetmask = 0x40;
 	}
 
-	/* grab status */
+	/* Grab the status. */
 	pci_read_config_word(dev, tristate, &tri_reg);
 	pci_read_config_byte(dev, 0x59, &bus_reg);
 
-	/* set the state. we don't set it if we don't need to do so.
-	 * make sure that the drive knows that it has failed if it's off */
+	/*
+	 * Set the state. We don't set it if we don't need to do so.
+	 * Make sure that the drive knows that it has failed if it's off.
+	 */
 	switch (state) {
 	case BUSSTATE_ON:
-		hwif->drives[0].failures = 0;
-		hwif->drives[1].failures = 0;
-		if ((bus_reg & resetmask) == 0)
+		if (!(bus_reg & resetmask))
 			return 0;
-		tri_reg &= ~TRISTATE_BIT;
-		bus_reg &= ~resetmask;
-		break;
+		hwif->drives[0].failures = hwif->drives[1].failures = 0;
+
+		pci_write_config_byte(dev, 0x59, bus_reg & ~resetmask);
+		pci_write_config_word(dev, tristate, tri_reg & ~TRISTATE_BIT);
+		return 0;
 	case BUSSTATE_OFF:
-		hwif->drives[0].failures = hwif->drives[0].max_failures + 1;
-		hwif->drives[1].failures = hwif->drives[1].max_failures + 1;
-		if ((tri_reg & TRISTATE_BIT) == 0 && (bus_reg & resetmask))
+		if ((bus_reg & resetmask) && !(tri_reg & TRISTATE_BIT))
 			return 0;
 		tri_reg &= ~TRISTATE_BIT;
-		bus_reg |= resetmask;
 		break;
 	case BUSSTATE_TRISTATE:
-		hwif->drives[0].failures = hwif->drives[0].max_failures + 1;
-		hwif->drives[1].failures = hwif->drives[1].max_failures + 1;
-		if ((tri_reg & TRISTATE_BIT) && (bus_reg & resetmask))
+		if ((bus_reg & resetmask) &&  (tri_reg & TRISTATE_BIT))
 			return 0;
 		tri_reg |= TRISTATE_BIT;
-		bus_reg |= resetmask;
 		break;
+	default:
+		return -EINVAL;
 	}
-	pci_write_config_byte(dev, 0x59, bus_reg);
-	pci_write_config_word(dev, tristate, tri_reg);
 
+	hwif->drives[0].failures = hwif->drives[0].max_failures + 1;
+	hwif->drives[1].failures = hwif->drives[1].max_failures + 1;
+
+	pci_write_config_word(dev, tristate, tri_reg);
+	pci_write_config_byte(dev, 0x59, bus_reg | resetmask);
 	return 0;
 }
 
@@ -1306,23 +1275,11 @@ static void __devinit init_hwif_hpt366(i
 	if (serialize && hwif->mate)
 		hwif->serialized = hwif->mate->serialized = 1;
 
-	if (info->revision >= 3) {
-		u8 reg5ah = 0;
-			pci_write_config_byte(dev, 0x5a, reg5ah & ~0x10);
-		/*
-		 * set up ioctl for power status.
-		 * note: power affects both
-		 * drives on each channel
-		 */
-		hwif->resetproc	= &hpt3xx_reset;
-		hwif->busproc	= &hpt370_busproc;
-	} else if (info->revision >= 2) {
-		hwif->resetproc	= &hpt3xx_reset;
-		hwif->busproc	= &hpt3xx_tristate;
-	} else {
-		hwif->resetproc = &hpt3xx_reset;
-		hwif->busproc   = &hpt3xx_tristate;
-	}
+	/*
+	 * Set up ioctl for power status.
+	 * NOTE:  power affects both drives on each channel.
+	 */
+	hwif->busproc = &hpt3xx_busproc;
 
 	if (!hwif->dma_base) {
 		hwif->drives[0].autotune = 1;
_

Patches currently in -mm which might be from sshtylyov@ru.mvista.com are

git-mtd.patch
3x59x-fix-pci-resource-management.patch
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
piix-remove-check-for-broken-mw-dma-mode-0.patch
piix-slc90e66-pio-mode-fallback-fix.patch
pdc202xx_new-remove-useless-code.patch
pdc202xx_-remove-check_in_drive_lists-abomination.patch

