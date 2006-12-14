From: akpm@osdl.org
Subject: - ide-hpt3xxn-clocking-fixes.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:18:18 -0800
Message-ID: <200612140618.kBE6IH5g002329@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52956 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977AbWLNGVy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:21:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sshtylyov@ru.mvista.com, B.Zolnierkiewicz@elka.pw.edu.pl, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     ide: HPT3xxN clocking fixes
has been removed from the -mm tree.  Its filename was
     ide-hpt3xxn-clocking-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ide: HPT3xxN clocking fixes
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

Fix serious problems with the HPT372N clock turnaround code:

- the wrong ports were written to when called for the secondary channel;

- it didn't serialize access to the channels;

- turnaround shou;dn't be done on 66 MHz PCI;

- caching the clock mode per-channel caused it to get out of sync with the
  actual register value.


Additionally, avoid calibrating PLL twice (for each channel) as the second try
results in a wrong PCI frequency and thus in the wrong timings.

Make the driver deal with HPT302N and HPT371N correctly -- the clocking and
(seemingly) a need for clock tunaround is the same as for HPT372N.  HPT371/N
chips have only one, secondary channel, so avoid touching their "pure virtual"
primary channel, and disable it if the BIOS haven't done this already.

Also, while at it, disable UltraATA/133 for HPT372 by default -- 50 MHz DPLL
clock don't allow for this speed anyway.  And remove the traces of the former
bad patch that wasn't even applicable to this version of driver.

Has been tested on HPT370/371N, unfortunately I don't have an instant access
to the other chips...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ide/pci/hpt366.c |  223 +++++++++++++++++++++++--------------
 1 file changed, 139 insertions(+), 84 deletions(-)

diff -puN drivers/ide/pci/hpt366.c~ide-hpt3xxn-clocking-fixes drivers/ide/pci/hpt366.c
--- a/drivers/ide/pci/hpt366.c~ide-hpt3xxn-clocking-fixes
+++ a/drivers/ide/pci/hpt366.c
@@ -4,6 +4,7 @@
  * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
  * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
  * Portions Copyright (C) 2003		Red Hat Inc
+ * Portions Copyright (C) 2005-2006	MontaVista Software, Inc.
  *
  * Thanks to HighPoint Technologies for their assistance, and hardware.
  * Special Thanks to Jon Burchmore in SanDiego for the deep pockets, his
@@ -11,9 +12,11 @@
  * development and support.
  *
  *
- * Highpoint have their own driver (source except for the raid part)
- * available from http://www.highpoint-tech.com/hpt3xx-opensource-v131.tgz
- * This may be useful to anyone wanting to work on the mainstream hpt IDE.
+ * HighPoint has its own drivers (open source except for the RAID part)
+ * available from http://www.highpoint-tech.com/BIOS%20+%20Driver/.
+ * This may be useful to anyone wanting to work on this driver, however  do not
+ * trust  them too much since the code tends to become less and less meaningful
+ * as the time passes... :-/
  *
  * Note that final HPT370 support was done by force extraction of GPL.
  *
@@ -52,6 +55,20 @@
  * keeping me sane. 
  *		Alan Cox <alan@redhat.com>
  *
+ * - fix the clock turnaround code: it was writing to the wrong ports when
+ *   called for the secondary channel, caching the current clock mode per-
+ *   channel caused the cached register value to get out of sync with the
+ *   actual one, the channels weren't serialized, the turnaround shouldn't
+ *   be done on 66 MHz PCI bus
+ * - avoid calibrating PLL twice as the second time results in a wrong PCI
+ *   frequency and thus in the wrong timings for the secondary channel
+ * - disable UltraATA/133 for HPT372 by default (50 MHz DPLL clock do not
+ *   allow for this speed anyway)
+ * - add support for HPT302N and HPT371N clocking (the same as for HPT372N)
+ * - HPT371/N are single channel chips, so avoid touching the primary channel
+ *   which exists only virtually (there's no pins for it)
+ *		<source@mvista.com>
+ *
  */
 
 
@@ -76,8 +93,8 @@
 
 /* various tuning parameters */
 #define HPT_RESET_STATE_ENGINE
-#undef HPT_DELAY_INTERRUPT
-#undef HPT_SERIALIZE_IO
+#undef	HPT_DELAY_INTERRUPT
+#define HPT_SERIALIZE_IO	0
 
 static const char *quirk_drives[] = {
 	"QUANTUM FIREBALLlct08 08",
@@ -439,7 +456,7 @@ static struct chipset_bus_clock_list_ent
 #define HPT374_ALLOW_ATA133_6		0
 #define HPT371_ALLOW_ATA133_6		0
 #define HPT302_ALLOW_ATA133_6		0
-#define HPT372_ALLOW_ATA133_6		1
+#define HPT372_ALLOW_ATA133_6		0
 #define HPT370_ALLOW_ATA100_5		1
 #define HPT366_ALLOW_ATA66_4		1
 #define HPT366_ALLOW_ATA66_3		1
@@ -461,7 +478,8 @@ struct hpt_info
 	int revision;		/* Chipset revision */
 	int flags;		/* Chipset properties */
 #define PLL_MODE	1
-#define IS_372N		2
+#define IS_3xxN 	2
+#define PCI_66MHZ	4
 				/* Speed table */
 	struct chipset_bus_clock_list_entry *speed;
 };
@@ -956,59 +974,63 @@ static int hpt374_ide_dma_end (ide_drive
 }
 
 /**
- *	hpt372n_set_clock	-	perform clock switching dance
- *	@drive: Drive to switch
- *	@mode: Switching mode (0x21 for write, 0x23 otherwise)
+ *	hpt3xxn_set_clock	-	perform clock switching dance
+ *	@hwif: hwif to switch
+ *	@mode: clocking mode (0x21 for write, 0x23 otherwise)
  *
- *	Switch the DPLL clock on the HPT372N devices. This is a
- *	right mess.
+ *	Switch the DPLL clock on the HPT3xxN devices. This is a	right mess.
+ *	NOTE: avoid touching the disabled primary channel on HPT371N -- it
+ *	doesn't physically exist anyway...
  */
- 
-static void hpt372n_set_clock(ide_drive_t *drive, int mode)
+
+static void hpt3xxn_set_clock(ide_hwif_t *hwif, u8 mode)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
-	
-	/* FIXME: should we check for DMA active and BUG() */
+	u8 mcr1, scr2 = hwif->INB(hwif->dma_master + 0x7b);
+
+	if ((scr2 & 0x7f) == mode)
+		return;
+
+	/* MISC. control register 1 has the channel enable bit... */
+	mcr1 = hwif->INB(hwif->dma_master + 0x70);
+
 	/* Tristate the bus */
-	outb(0x80, hwif->dma_base+0x73);
-	outb(0x80, hwif->dma_base+0x77);
-	
+	if (mcr1 & 0x04)
+		hwif->OUTB(0x80, hwif->dma_master + 0x73);
+	hwif->OUTB(0x80, hwif->dma_master + 0x77);
+
 	/* Switch clock and reset channels */
-	outb(mode, hwif->dma_base+0x7B);
-	outb(0xC0, hwif->dma_base+0x79);
-	
+	hwif->OUTB(mode, hwif->dma_master + 0x7b);
+	hwif->OUTB(0xc0, hwif->dma_master + 0x79);
+
 	/* Reset state machines */
-	outb(0x37, hwif->dma_base+0x70);
-	outb(0x37, hwif->dma_base+0x74);
-	
+	if (mcr1 & 0x04)
+		hwif->OUTB(0x37, hwif->dma_master + 0x70);
+	hwif->OUTB(0x37, hwif->dma_master + 0x74);
+
 	/* Complete reset */
-	outb(0x00, hwif->dma_base+0x79);
-	
+	hwif->OUTB(0x00, hwif->dma_master + 0x79);
+
 	/* Reconnect channels to bus */
-	outb(0x00, hwif->dma_base+0x73);
-	outb(0x00, hwif->dma_base+0x77);
+	if (mcr1 & 0x04)
+		hwif->OUTB(0x00, hwif->dma_master + 0x73);
+	hwif->OUTB(0x00, hwif->dma_master + 0x77);
 }
 
 /**
- *	hpt372n_rw_disk		-	prepare for I/O
+ *	hpt3xxn_rw_disk		-	prepare for I/O
  *	@drive: drive for command
  *	@rq: block request structure
  *
- *	This is called when a disk I/O is issued to the 372N.
+ *	This is called when a disk I/O is issued to HPT3xxN.
  *	We need it because of the clock switching.
  */
 
-static void hpt372n_rw_disk(ide_drive_t *drive, struct request *rq)
+static void hpt3xxn_rw_disk(ide_drive_t *drive, struct request *rq)
 {
-	ide_hwif_t *hwif = drive->hwif;
-	int wantclock;
-
-	wantclock = rq_data_dir(rq) ? 0x23 : 0x21;
+	ide_hwif_t *hwif	= HWIF(drive);
+	u8 wantclock		= rq_data_dir(rq) ? 0x23 : 0x21;
 
-	if (hwif->config_data != wantclock) {
-		hpt372n_set_clock(drive, wantclock);
-		hwif->config_data = wantclock;
-	}
+	hpt3xxn_set_clock(hwif, wantclock);
 }
 
 /*
@@ -1138,7 +1160,7 @@ static void __devinit hpt37x_clocking(id
 	int adjust, i;
 	u16 freq;
 	u32 pll;
-	u8 reg5bh;
+	u8 reg5bh = 0, mcr1 = 0;
 	
 	/*
 	 * default to pci clock. make sure MA15/16 are set to output
@@ -1161,17 +1183,11 @@ static void __devinit hpt37x_clocking(id
 	freq &= 0x1FF;
 	
 	/*
-	 * The 372N uses different PCI clock information and has
-	 * some other complications
-	 *	On PCI33 timing we must clock switch
-	 *	On PCI66 timing we must NOT use the PCI clock
-	 *
-	 * Currently we always set up the PLL for the 372N
+	 * HPT3xxN chips use different PCI clock information.
+	 * Currently we always set up the PLL for them.
 	 */
-	 
-	if(info->flags & IS_372N)
-	{
-		printk(KERN_INFO "hpt: HPT372N detected, using 372N timing.\n");
+
+	if (info->flags & IS_3xxN) {
 		if(freq < 0x55)
 			pll = F_LOW_PCI_33;
 		else if(freq < 0x70)
@@ -1180,10 +1196,8 @@ static void __devinit hpt37x_clocking(id
 			pll = F_LOW_PCI_50;
 		else
 			pll = F_LOW_PCI_66;
-			
-		printk(KERN_INFO "FREQ: %d PLL: %d\n", freq, pll);
-			
-		/* We always use the pll not the PCI clock on 372N */
+
+		printk(KERN_INFO "HPT3xxN detected, FREQ: %d, PLL: %d\n", freq, pll);
 	}
 	else
 	{
@@ -1231,7 +1245,10 @@ static void __devinit hpt37x_clocking(id
 			printk(KERN_DEBUG "HPT37X: using 66MHz PCI clock\n");
 		}
 	}
-	
+
+	if (pll == F_LOW_PCI_66)
+		info->flags |= PCI_66MHZ;
+
 	/*
 	 * only try the pll if we don't have a table for the clock
 	 * speed that we're running at. NOTE: the internal PLL will
@@ -1287,10 +1304,6 @@ static void __devinit hpt37x_clocking(id
 				goto init_hpt37X_done;
 			}
 		}
-		if (!pci_get_drvdata(dev)) {
-			printk("No Clock Stabilization!!!\n");
-			return;
-		}
 pll_recal:
 		if (adjust & 1)
 			pll -= (adjust >> 1);
@@ -1300,11 +1313,16 @@ pll_recal:
 
 init_hpt37X_done:
 	if (!info->speed)
-		printk(KERN_ERR "HPT37X%s: unknown bus timing [%d %d].\n",
-			(info->flags & IS_372N)?"N":"", pll, freq);
-	/* reset state engine */
-	pci_write_config_byte(dev, 0x50, 0x37); 
-	pci_write_config_byte(dev, 0x54, 0x37); 
+		printk(KERN_ERR "HPT37x%s: unknown bus timing [%d %d].\n",
+		       (info->flags & IS_3xxN) ? "N" : "", pll, freq);
+	/*
+	 * Reset the state engines.
+	 * NOTE: avoid accidentally enabling the primary channel on HPT371N.
+	 */
+	pci_read_config_byte(dev, 0x50, &mcr1);
+	if (mcr1 & 0x04)
+		pci_write_config_byte(dev, 0x50, 0x37);
+	pci_write_config_byte(dev, 0x54, 0x37);
 	udelay(100);
 }
 
@@ -1367,6 +1385,7 @@ static void __devinit init_hwif_hpt366(i
 	struct pci_dev *dev		= hwif->pci_dev;
 	struct hpt_info *info		= ide_get_hwifdata(hwif);
 	u8 ata66 = 0, regmask		= (hwif->channel) ? 0x01 : 0x02;
+	int serialize			= HPT_SERIALIZE_IO;
 	
 	hwif->tuneproc			= &hpt3xx_tune_drive;
 	hwif->speedproc			= &hpt3xx_tune_chipset;
@@ -1374,8 +1393,20 @@ static void __devinit init_hwif_hpt366(i
 	hwif->intrproc			= &hpt3xx_intrproc;
 	hwif->maskproc			= &hpt3xx_maskproc;
 	
-	if(info->flags & IS_372N)
-		hwif->rw_disk = &hpt372n_rw_disk;
+	/*
+	 * HPT3xxN chips have some complications:
+	 *
+	 * - on 33 MHz PCI we must clock switch
+	 * - on 66 MHz PCI we must NOT use the PCI clock
+	 */
+	if ((info->flags & (IS_3xxN | PCI_66MHZ)) == IS_3xxN) {
+		/*
+		 * Clock is shared between the channels,
+		 * so we'll have to serialize them... :-(
+		 */
+		serialize = 1;
+		hwif->rw_disk = &hpt3xxn_rw_disk;
+	}
 
 	/*
 	 * The HPT37x uses the CBLID pins as outputs for MA15/MA16
@@ -1418,11 +1449,9 @@ static void __devinit init_hwif_hpt366(i
 		PCI_FUNC(hwif->pci_dev->devfn));
 #endif /* DEBUG */
 
-#ifdef HPT_SERIALIZE_IO
-	/* serialize access to this device */
-	if (hwif->mate)
+	/* Serialize access to this device */
+	if (serialize && hwif->mate)
 		hwif->serialized = hwif->mate->serialized = 1;
-#endif
 
 	if (info->revision >= 3) {
 		u8 reg5ah = 0;
@@ -1490,7 +1519,7 @@ static void __devinit init_dma_hpt366(id
 		return;
 		
 	if(info->speed == NULL) {
-		printk(KERN_WARNING "hpt: no known IDE timings, disabling DMA.\n");
+		printk(KERN_WARNING "hpt366: no known IDE timings, disabling DMA.\n");
 		return;
 	}
 
@@ -1519,9 +1548,10 @@ static void __devinit init_dma_hpt366(id
 
 static void __devinit init_iops_hpt366(ide_hwif_t *hwif)
 {
-	struct hpt_info *info = kzalloc(sizeof(struct hpt_info), GFP_KERNEL);
-	unsigned long dmabase = pci_resource_start(hwif->pci_dev, 4);
-	u8 did, rid;
+	struct hpt_info *info	= kzalloc(sizeof(struct hpt_info), GFP_KERNEL);
+	struct pci_dev  *dev	= hwif->pci_dev;
+	u16 did			= dev->device;
+	u8  rid			= 0;
 
 	if(info == NULL) {
 		printk(KERN_WARNING "hpt366: out of memory.\n");
@@ -1529,15 +1559,22 @@ static void __devinit init_iops_hpt366(i
 	}
 	ide_set_hwifdata(hwif, info);
 
-	if(dmabase) {
-		did = inb(dmabase + 0x22);
-		rid = inb(dmabase + 0x28);
-
-		if((did == 4 && rid == 6) || (did == 5 && rid > 1))
-			info->flags |= IS_372N;
+	/* Avoid doing the same thing twice. */
+	if (hwif->channel && hwif->mate) {
+		memcpy(info, ide_get_hwifdata(hwif->mate), sizeof(struct hpt_info));
+		return;
 	}
 
-	info->revision = hpt_revision(hwif->pci_dev);
+	pci_read_config_byte(dev, PCI_CLASS_REVISION, &rid);
+
+	if (( did == PCI_DEVICE_ID_TTI_HPT366  && rid == 6) ||
+	    ((did == PCI_DEVICE_ID_TTI_HPT372  ||
+	      did == PCI_DEVICE_ID_TTI_HPT302  ||
+	      did == PCI_DEVICE_ID_TTI_HPT371) && rid > 1) ||
+	      did == PCI_DEVICE_ID_TTI_HPT372N)
+		info->flags |= IS_3xxN;
+
+	info->revision = hpt_revision(dev);
 
 	if (info->revision >= 3)
 		hpt37x_clocking(hwif);
@@ -1574,6 +1611,23 @@ static int __devinit init_setup_hpt37x(s
 	return ide_setup_pci_device(dev, d);
 }
 
+static int __devinit init_setup_hpt371(struct pci_dev *dev, ide_pci_device_t *d)
+{
+	u8 mcr1 = 0;
+
+	/*
+	 * HPT371 chips physically have only one channel, the secondary one,
+	 * but the primary channel registers do exist!  Go figure...
+	 * So,  we manually disable the non-existing channel here
+	 * (if the BIOS hasn't done this already).
+	 */
+	pci_read_config_byte(dev, 0x50, &mcr1);
+	if (mcr1 & 0x04)
+		pci_write_config_byte(dev, 0x50, (mcr1 & ~0x04));
+
+	return ide_setup_pci_device(dev, d);
+}
+
 static int __devinit init_setup_hpt366(struct pci_dev *dev, ide_pci_device_t *d)
 {
 	struct pci_dev *findev = NULL;
@@ -1661,13 +1715,14 @@ static ide_pci_device_t hpt366_chipsets[
 		.bootable	= OFF_BOARD,
 	},{	/* 3 */
 		.name		= "HPT371",
-		.init_setup	= init_setup_hpt37x,
+		.init_setup	= init_setup_hpt371,
 		.init_chipset	= init_chipset_hpt366,
 		.init_iops	= init_iops_hpt366,
 		.init_hwif	= init_hwif_hpt366,
 		.init_dma	= init_dma_hpt366,
 		.channels	= 2,
 		.autodma	= AUTODMA,
+		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
 		.bootable	= OFF_BOARD,
 	},{	/* 4 */
 		.name		= "HPT374",
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

