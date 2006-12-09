From: akpm@osdl.org
Subject: + pdc202xx_new-fix-pll-timing-issues.patch added to -mm tree
Date: Sat, 09 Dec 2006 14:49:44 -0800
Message-ID: <200612092249.kB9MniXD006484@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56990 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759147AbWLIWzj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 9 Dec 2006 17:55:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sshtylyov@ru.mvista.com, B.Zolnierkiewicz@elka.pw.edu.pl, alan@lxorguk.ukuu.org.uk, albertcc@tw.ibm.com


The patch titled
     pdc202xx_new: fix PLL/timing issues
has been added to the -mm tree.  Its filename is
     pdc202xx_new-fix-pll-timing-issues.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pdc202xx_new: fix PLL/timing issues
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

Fix the CRC errors in the higher UltraDMA modes with the Promise PDC20268
and newer chips that always occur on non-x86 machines and when there are
more than 2 adapters on x86 machines.  Fix the overclocking issue for
PDC20269 and newer chips that occurs when an UltraDMA/133 capable drive is
connected.  Here's the summary of changes:

- add code to detect the PLL input clock detection and setup it output clock,
  remove the PowerMac hacks;

- replace the macros accessing the indexed regiters with functions, switch to
  using them where appropriate, gather the PIO/MWDMA/UDMA timings into tables;

- rewrite the speedproc() handler to set the drive's transfer mode first, and
  then override the timing registers set by hardware on UltraDMA/133 chips;

- use better criterion for determining higher UltraDMA modes, and add comment
  concerning the doubtful value of the code enabling IORDY/prefetch;

- replace the stupid 'pdcnew_new_' prefixes with mere 'pdcnew_';

- get rid of unneded spaces, parens and type casts, clean up some printk's,
  add some new lines here and there...

This work is loosely based on these former patches by Albert Lee:

[1] http://marc.theaimsgroup.com/?l=linux-ide&m=110992442032300
[2] http://marc.theaimsgroup.com/?l=linux-ide&m=110992457729382
[3] http://marc.theaimsgroup.com/?l=linux-ide&m=110992474205555
[4] http://marc.theaimsgroup.com/?l=linux-ide&m=111019224802939

Some PLL clock detection code was backported from his pata_pdc2027x driver...

This code has been successfully tested by me on PDC2026[89] chips.

I tried to keep this rework as several patches but it made no sense: [2] was
largely a modification of the non-working timing override code, [3] by itself
extended the overclocking issue to the case of non-UltraDMA/133 drives, and
finally, the cleanup patch based on [1] ended up rejected...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Albert Lee <albertcc@tw.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ide/pci/pdc202xx_new.c |  485 ++++++++++++++++++++++++-------
 1 file changed, 376 insertions(+), 109 deletions(-)

diff -puN drivers/ide/pci/pdc202xx_new.c~pdc202xx_new-fix-pll-timing-issues drivers/ide/pci/pdc202xx_new.c
--- a/drivers/ide/pci/pdc202xx_new.c~pdc202xx_new-fix-pll-timing-issues
+++ a/drivers/ide/pci/pdc202xx_new.c
@@ -39,6 +39,14 @@
 
 #define PDC202_DEBUG_CABLE	0
 
+#undef DEBUG
+
+#ifdef DEBUG
+#define DBG(fmt, args...) printk("%s: " fmt, __FUNCTION__, ## args)
+#else
+#define DBG(fmt, args...)
+#endif
+
 static const char *pdc_quirk_drives[] = {
 	"QUANTUM FIREBALLlct08 08",
 	"QUANTUM FIREBALLP KA6.4",
@@ -51,37 +59,11 @@ static const char *pdc_quirk_drives[] = 
 	NULL
 };
 
-#define set_2regs(a, b)					\
-	do {						\
-		hwif->OUTB((a + adj), indexreg);	\
-		hwif->OUTB(b, datareg);			\
-	} while(0)
-
-#define set_ultra(a, b, c)				\
-	do {						\
-		set_2regs(0x10,(a));			\
-		set_2regs(0x11,(b));			\
-		set_2regs(0x12,(c));			\
-	} while(0)
-
-#define set_ata2(a, b)					\
-	do {						\
-		set_2regs(0x0e,(a));			\
-		set_2regs(0x0f,(b));			\
-	} while(0)
-
-#define set_pio(a, b, c)				\
-	do { 						\
-		set_2regs(0x0c,(a));			\
-		set_2regs(0x0d,(b));			\
-		set_2regs(0x13,(c));			\
-	} while(0)
-
-static u8 pdcnew_ratemask (ide_drive_t *drive)
+static u8 max_dma_rate(struct pci_dev *pdev)
 {
 	u8 mode;
 
-	switch(HWIF(drive)->pci_dev->device) {
+	switch(pdev->device) {
 		case PCI_DEVICE_ID_PROMISE_20277:
 		case PCI_DEVICE_ID_PROMISE_20276:
 		case PCI_DEVICE_ID_PROMISE_20275:
@@ -96,12 +78,21 @@ static u8 pdcnew_ratemask (ide_drive_t *
 		default:
 			return 0;
 	}
-	if (!eighty_ninty_three(drive))
-		mode = min(mode, (u8)1);
+
 	return mode;
 }
 
-static int check_in_drive_lists (ide_drive_t *drive, const char **list)
+static u8 pdcnew_ratemask(ide_drive_t *drive)
+{
+	u8 mode = max_dma_rate(HWIF(drive)->pci_dev);
+
+	if (!eighty_ninty_three(drive))
+		mode = min_t(u8, mode, 1);
+
+	return	mode;
+}
+
+static int check_in_drive_lists(ide_drive_t *drive, const char **list)
 {
 	struct hd_driveid *id = drive->id;
 
@@ -121,43 +112,141 @@ static int check_in_drive_lists (ide_dri
 	return 0;
 }
 
-static int pdcnew_new_tune_chipset (ide_drive_t *drive, u8 xferspeed)
+/**
+ * get_indexed_reg - Get indexed register
+ * @hwif: for the port address
+ * @index: index of the indexed register
+ */
+static u8 get_indexed_reg(ide_hwif_t *hwif, u8 index)
+{
+	u8 value;
+
+	hwif->OUTB(index, hwif->dma_vendor1);
+	value = hwif->INB(hwif->dma_vendor3);
+
+	DBG("index[%02X] value[%02X]\n", index, value);
+	return value;
+}
+
+/**
+ * set_indexed_reg - Set indexed register
+ * @hwif: for the port address
+ * @index: index of the indexed register
+ */
+static void set_indexed_reg(ide_hwif_t *hwif, u8 index, u8 value)
+{
+	hwif->OUTB(index, hwif->dma_vendor1);
+	hwif->OUTB(value, hwif->dma_vendor3);
+	DBG("index[%02X] value[%02X]\n", index, value);
+}
+
+/*
+ * ATA Timing Tables based on 133 MHz PLL output clock.
+ *
+ * If the PLL outputs 100 MHz clock, the ASIC hardware will set
+ * the timing registers automatically when "set features" command is
+ * issued to the device. However, if the PLL output clock is 133 MHz,
+ * the following tables must be used.
+ */
+static struct pio_timing {
+	u8 reg0c, reg0d, reg13;
+} pio_timings [] = {
+	{ 0xfb, 0x2b, 0xac },	/* PIO mode 0, IORDY off, Prefetch off */
+	{ 0x46, 0x29, 0xa4 },	/* PIO mode 1, IORDY off, Prefetch off */
+	{ 0x23, 0x26, 0x64 },	/* PIO mode 2, IORDY off, Prefetch off */
+	{ 0x27, 0x0d, 0x35 },	/* PIO mode 3, IORDY on,  Prefetch off */
+	{ 0x23, 0x09, 0x25 },	/* PIO mode 4, IORDY on,  Prefetch off */
+};
+
+static struct mwdma_timing {
+	u8 reg0e, reg0f;
+} mwdma_timings [] = {
+	{ 0xdf, 0x5f }, 	/* MWDMA mode 0 */
+	{ 0x6b, 0x27 }, 	/* MWDMA mode 1 */
+	{ 0x69, 0x25 }, 	/* MWDMA mode 2 */
+};
+
+static struct udma_timing {
+	u8 reg10, reg11, reg12;
+} udma_timings [] = {
+	{ 0x4a, 0x0f, 0xd5 },	/* UDMA mode 0 */
+	{ 0x3a, 0x0a, 0xd0 },	/* UDMA mode 1 */
+	{ 0x2a, 0x07, 0xcd },	/* UDMA mode 2 */
+	{ 0x1a, 0x05, 0xcd },	/* UDMA mode 3 */
+	{ 0x1a, 0x03, 0xcd },	/* UDMA mode 4 */
+	{ 0x1a, 0x02, 0xcb },	/* UDMA mode 5 */
+	{ 0x1a, 0x01, 0xcb },	/* UDMA mode 6 */
+};
+
+static int pdcnew_tune_chipset(ide_drive_t *drive, u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	unsigned long indexreg	= hwif->dma_vendor1;
-	unsigned long datareg	= hwif->dma_vendor3;
-	u8 thold		= 0x10;
-	u8 adj			= (drive->dn%2) ? 0x08 : 0x00;
-	u8 speed		= ide_rate_filter(pdcnew_ratemask(drive), xferspeed);
-
-	if (speed == XFER_UDMA_2) {
-		hwif->OUTB((thold + adj), indexreg);
-		hwif->OUTB((hwif->INB(datareg) & 0x7f), datareg);
-	}
-
-	switch (speed) {
-		case XFER_UDMA_7:
-			speed = XFER_UDMA_6;
-		case XFER_UDMA_6:	set_ultra(0x1a, 0x01, 0xcb); break;
-		case XFER_UDMA_5:	set_ultra(0x1a, 0x02, 0xcb); break;
-		case XFER_UDMA_4:	set_ultra(0x1a, 0x03, 0xcd); break;
-		case XFER_UDMA_3:	set_ultra(0x1a, 0x05, 0xcd); break;
-		case XFER_UDMA_2:	set_ultra(0x2a, 0x07, 0xcd); break;
-		case XFER_UDMA_1:	set_ultra(0x3a, 0x0a, 0xd0); break;
-		case XFER_UDMA_0:	set_ultra(0x4a, 0x0f, 0xd5); break;
-		case XFER_MW_DMA_2:	set_ata2(0x69, 0x25); break;
-		case XFER_MW_DMA_1:	set_ata2(0x6b, 0x27); break;
-		case XFER_MW_DMA_0:	set_ata2(0xdf, 0x5f); break;
-		case XFER_PIO_4:	set_pio(0x23, 0x09, 0x25); break;
-		case XFER_PIO_3:	set_pio(0x27, 0x0d, 0x35); break;
-		case XFER_PIO_2:	set_pio(0x23, 0x26, 0x64); break;
-		case XFER_PIO_1:	set_pio(0x46, 0x29, 0xa4); break;
-		case XFER_PIO_0:	set_pio(0xfb, 0x2b, 0xac); break;
-		default:
-			;
-	}
+	u8 adj			= (drive->dn & 1) ? 0x08 : 0x00;
+	int			err;
+
+	speed = ide_rate_filter(pdcnew_ratemask(drive), speed);
+
+	/*
+	 * Issue SETFEATURES_XFER to the drive first. PDC202xx hardware will
+	 * automatically set the timing registers based on 100 MHz PLL output.
+	 */
+ 	err = ide_config_drive_speed(drive, speed);
+
+	/*
+	 * As we set up the PLL to output 133 MHz for UltraDMA/133 capable
+	 * chips, we must override the default register settings...
+	 */
+	if (max_dma_rate(hwif->pci_dev) == 4) {
+		u8 mode = speed & 0x07;
+
+		switch (speed) {
+			case XFER_UDMA_6:
+			case XFER_UDMA_5:
+			case XFER_UDMA_4:
+			case XFER_UDMA_3:
+			case XFER_UDMA_2:
+			case XFER_UDMA_1:
+			case XFER_UDMA_0:
+				set_indexed_reg(hwif, 0x10 + adj,
+						udma_timings[mode].reg10);
+				set_indexed_reg(hwif, 0x11 + adj,
+						udma_timings[mode].reg11);
+				set_indexed_reg(hwif, 0x12 + adj,
+						udma_timings[mode].reg12);
+				break;
+
+			case XFER_MW_DMA_2:
+			case XFER_MW_DMA_1:
+			case XFER_MW_DMA_0:
+				set_indexed_reg(hwif, 0x0e + adj,
+						mwdma_timings[mode].reg0e);
+				set_indexed_reg(hwif, 0x0f + adj,
+						mwdma_timings[mode].reg0f);
+				break;
+			case XFER_PIO_4:
+			case XFER_PIO_3:
+			case XFER_PIO_2:
+			case XFER_PIO_1:
+			case XFER_PIO_0:
+				set_indexed_reg(hwif, 0x0c + adj,
+						pio_timings[mode].reg0c);
+				set_indexed_reg(hwif, 0x0d + adj,
+						pio_timings[mode].reg0d);
+				set_indexed_reg(hwif, 0x13 + adj,
+						pio_timings[mode].reg13);
+				break;
+			default:
+				printk(KERN_ERR "pdc202xx_new: "
+				       "Unknown speed %d ignored\n", speed);
+		}
+	} else if (speed == XFER_UDMA_2) {
+		/* Set tHOLD bit to 0 if using UDMA mode 2 */
+		u8 tmp = get_indexed_reg(hwif, 0x10 + adj);
+
+		set_indexed_reg(hwif, 0x10 + adj, tmp & 0x7f);
+ 	}
 
-	return (ide_config_drive_speed(drive, speed));
+	return err;
 }
 
 /*   0    1    2    3    4    5    6   7   8
@@ -170,36 +259,42 @@ static int pdcnew_new_tune_chipset (ide_
 static void pdcnew_tune_drive(ide_drive_t *drive, u8 pio)
 {
 	pio = ide_get_best_pio_mode(drive, pio, 4, NULL);
-	(void)pdcnew_new_tune_chipset(drive, XFER_PIO_0 + pio);
+	(void)pdcnew_tune_chipset(drive, XFER_PIO_0 + pio);
 }
 
-static u8 pdcnew_new_cable_detect (ide_hwif_t *hwif)
+static u8 pdcnew_cable_detect(ide_hwif_t *hwif)
 {
-	hwif->OUTB(0x0b, hwif->dma_vendor1);
-	return ((u8)((hwif->INB(hwif->dma_vendor3) & 0x04)));
+	return get_indexed_reg(hwif, 0x0b) & 0x04;
 }
-static int config_chipset_for_dma (ide_drive_t *drive)
+
+static int config_chipset_for_dma(ide_drive_t *drive)
 {
 	struct hd_driveid *id	= drive->id;
 	ide_hwif_t *hwif	= HWIF(drive);
-	u8 speed		= -1;
-	u8 cable;
-
-	u8 ultra_66		= ((id->dma_ultra & 0x0010) ||
-				   (id->dma_ultra & 0x0008)) ? 1 : 0;
-
-	cable = pdcnew_new_cable_detect(hwif);
+	u8 ultra_66		= (id->dma_ultra & 0x0078) ? 1 : 0;
+	u8 cable		= pdcnew_cable_detect(hwif);
+	u8 speed;
 
 	if (ultra_66 && cable) {
-		printk(KERN_WARNING "Warning: %s channel requires an 80-pin cable for operation.\n", hwif->channel ? "Secondary":"Primary");
+		printk(KERN_WARNING "Warning: %s channel "
+		       "requires an 80-pin cable for operation.\n",
+		       hwif->channel ? "Secondary" : "Primary");
 		printk(KERN_WARNING "%s reduced to Ultra33 mode.\n", drive->name);
 	}
 
 	if (drive->media != ide_disk)
 		return 0;
-	if (id->capability & 4) {	/* IORDY_EN & PREFETCH_EN */
-		hwif->OUTB((0x13 + ((drive->dn%2) ? 0x08 : 0x00)), hwif->dma_vendor1);
-		hwif->OUTB((hwif->INB(hwif->dma_vendor3)|0x03), hwif->dma_vendor3);
+
+	if (id->capability & 4) {
+		/*
+		 * Set IORDY_EN & PREFETCH_EN (this seems to have
+		 * NO real effect since this register is reloaded
+		 * by hardware when the transfer mode is selected)
+		 */
+		u8 tmp, adj = (drive->dn & 1) ? 0x08 : 0x00;
+
+		tmp = get_indexed_reg(hwif, 0x13 + adj);
+		set_indexed_reg(hwif, 0x13 + adj, tmp | 0x03);
 	}
 
 	speed = ide_dma_speed(drive, pdcnew_ratemask(drive));
@@ -211,7 +306,7 @@ static int config_chipset_for_dma (ide_d
 	return ide_dma_enable(drive);
 }
 
-static int pdcnew_config_drive_xfer_rate (ide_drive_t *drive)
+static int pdcnew_config_drive_xfer_rate(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct hd_driveid *id	= drive->id;
@@ -236,9 +331,9 @@ fast_ata_pio:
 	return 0;
 }
 
-static int pdcnew_quirkproc (ide_drive_t *drive)
+static int pdcnew_quirkproc(ide_drive_t *drive)
 {
-	return ((int) check_in_drive_lists(drive, pdc_quirk_drives));
+	return check_in_drive_lists(drive, pdc_quirk_drives);
 }
 
 static int pdcnew_ide_dma_lostirq(ide_drive_t *drive)
@@ -255,21 +350,100 @@ static int pdcnew_ide_dma_timeout(ide_dr
 	return __ide_dma_timeout(drive);
 }
 
-static void pdcnew_new_reset (ide_drive_t *drive)
+static void pdcnew_reset(ide_drive_t *drive)
 {
 	/*
 	 * Deleted this because it is redundant from the caller.
 	 */
-	printk(KERN_WARNING "PDC202XX: %s channel reset.\n",
+	printk(KERN_WARNING "pdc202xx_new: %s channel reset.\n",
 		HWIF(drive)->channel ? "Secondary" : "Primary");
 }
 
+/**
+ * read_counter - Read the byte count registers
+ * @dma_base: for the port address
+ */
+static long __devinit read_counter(u32 dma_base)
+{
+	u32  pri_dma_base = dma_base, sec_dma_base = dma_base + 0x08;
+	u8   cnt0, cnt1, cnt2, cnt3;
+	long count = 0, last;
+	int  retry = 3;
+
+	do {
+		last = count;
+
+		/* Read the current count */
+		outb(0x20, pri_dma_base + 0x01);
+		cnt0 = inb(pri_dma_base + 0x03);
+		outb(0x21, pri_dma_base + 0x01);
+		cnt1 = inb(pri_dma_base + 0x03);
+		outb(0x20, sec_dma_base + 0x01);
+		cnt2 = inb(sec_dma_base + 0x03);
+		outb(0x21, sec_dma_base + 0x01);
+		cnt3 = inb(sec_dma_base + 0x03);
+
+		count = (cnt3 << 23) | (cnt2 << 15) | (cnt1 << 8) | cnt0;
+
+		/*
+		 * The 30-bit decrementing counter is read in 4 pieces.
+		 * Incorrect value may be read when the most significant bytes
+		 * are changing...
+		 */
+	} while (retry-- && (((last ^ count) & 0x3fff8000) || last < count));
+
+	DBG("cnt0[%02X] cnt1[%02X] cnt2[%02X] cnt3[%02X]\n",
+		  cnt0, cnt1, cnt2, cnt3);
+
+	return count;
+}
+
+/**
+ * detect_pll_input_clock - Detect the PLL input clock in Hz.
+ * @dma_base: for the port address
+ * E.g. 16949000 on 33 MHz PCI bus, i.e. half of the PCI clock.
+ */
+static long __devinit detect_pll_input_clock(unsigned long dma_base)
+{
+	long start_count, end_count;
+	long pll_input;
+	u8 scr1;
+
+	start_count = read_counter(dma_base);
+
+	/* Start the test mode */
+	outb(0x01, dma_base + 0x01);
+	scr1 = inb(dma_base + 0x03);
+	DBG("scr1[%02X]\n", scr1);
+	outb(scr1 | 0x40, dma_base + 0x03);
+
+	/* Let the counter run for 10 ms. */
+	mdelay(10);
+
+	end_count = read_counter(dma_base);
+
+	/* Stop the test mode */
+	outb(0x01, dma_base + 0x01);
+	scr1 = inb(dma_base + 0x03);
+	DBG("scr1[%02X]\n", scr1);
+	outb(scr1 & ~0x40, dma_base + 0x03);
+
+	/*
+	 * Calculate the input clock in Hz
+	 * (the clock counter is 30 bit wide and counts down)
+	 */
+	pll_input = ((start_count - end_count) & 0x3ffffff) * 100;
+
+	DBG("start[%ld] end[%ld]\n", start_count, end_count);
+
+	return pll_input;
+}
+
 #ifdef CONFIG_PPC_PMAC
 static void __devinit apple_kiwi_init(struct pci_dev *pdev)
 {
 	struct device_node *np = pci_device_to_OF_node(pdev);
 	unsigned int class_rev = 0;
-	void __iomem *mmio;
 	u8 conf;
 
 	if (np == NULL || !device_is_compatible(np, "kiwi-root"))
@@ -280,30 +454,20 @@ static void __devinit apple_kiwi_init(st
 
 	if (class_rev >= 0x03) {
 		/* Setup chip magic config stuff (from darwin) */
-		pci_read_config_byte(pdev, 0x40, &conf);
-		pci_write_config_byte(pdev, 0x40, conf | 0x01);
+		pci_read_config_byte (pdev, 0x40, &conf);
+		pci_write_config_byte(pdev, 0x40, (conf | 0x01));
 	}
-	mmio = ioremap(pci_resource_start(pdev, 5),
-				      pci_resource_len(pdev, 5));
-
-	/* Setup some PLL stuffs */
-	switch (pdev->device) {
-	case PCI_DEVICE_ID_PROMISE_20270:
-		writew(0x0d2b, mmio + 0x1202);
-		mdelay(30);
-		break;
-	case PCI_DEVICE_ID_PROMISE_20271:
-		writew(0x0826, mmio + 0x1202);
-		mdelay(30);
-		break;
-	}
-
-	iounmap(mmio);
 }
 #endif /* CONFIG_PPC_PMAC */
 
 static unsigned int __devinit init_chipset_pdcnew(struct pci_dev *dev, const char *name)
 {
+	unsigned long dma_base = pci_resource_start(dev, 4);
+	unsigned long sec_dma_base = dma_base + 0x08;
+	long pll_input, pll_output, ratio;
+	int f, r;
+	u8 pll_ctl0, pll_ctl1;
+
 	if (dev->resource[PCI_ROM_RESOURCE].start) {
 		pci_write_config_dword(dev, PCI_ROM_ADDRESS,
 			dev->resource[PCI_ROM_RESOURCE].start | PCI_ROM_ADDRESS_ENABLE);
@@ -315,6 +479,106 @@ static unsigned int __devinit init_chips
 	apple_kiwi_init(dev);
 #endif
 
+	/* Calculate the required PLL output frequency */
+	switch(max_dma_rate(dev)) {
+		case 4: /* it's 133 MHz for Ultra133 chips */
+			pll_output = 133333333;
+			break;
+		case 3: /* and  100 MHz for Ultra100 chips */
+		default:
+			pll_output = 100000000;
+			break;
+	}
+
+	/*
+	 * Detect PLL input clock.
+	 * On some systems, where PCI bus is running at non-standard clock rate
+	 * (e.g. 25 or 40 MHz), we have to adjust the cycle time.
+	 * PDC20268 and newer chips employ PLL circuit to help correct timing
+	 * registers setting.
+	 */
+	pll_input = detect_pll_input_clock(dma_base);
+	printk("%s: PLL input clock is %ld kHz\n", name, pll_input / 1000);
+
+	/* Sanity check */
+	if (unlikely(pll_input < 5000000L || pll_input > 70000000L)) {
+		printk(KERN_ERR "%s: Bad PLL input clock %ld Hz, giving up!\n",
+		       name, pll_input);
+		goto out;
+	}
+
+#ifdef DEBUG
+	DBG("pll_output is %ld Hz\n", pll_output);
+
+	/* Show the current clock value of PLL control register
+	 * (maybe already configured by the BIOS)
+	 */
+	outb(0x02, sec_dma_base + 0x01);
+	pll_ctl0 = inb(sec_dma_base + 0x03);
+	outb(0x03, sec_dma_base + 0x01);
+	pll_ctl1 = inb(sec_dma_base + 0x03);
+
+	DBG("pll_ctl[%02X][%02X]\n", pll_ctl0, pll_ctl1);
+#endif
+
+	/*
+	 * Calculate the ratio of F, R and NO
+	 * POUT = (F + 2) / (( R + 2) * NO)
+	 */
+	ratio = pll_output / (pll_input / 1000);
+	if (ratio < 8600L) { /* 8.6x */
+		/* Using NO = 0x01, R = 0x0d */
+		r = 0x0d;
+	} else if (ratio < 12900L) { /* 12.9x */
+		/* Using NO = 0x01, R = 0x08 */
+		r = 0x08;
+	} else if (ratio < 16100L) { /* 16.1x */
+		/* Using NO = 0x01, R = 0x06 */
+		r = 0x06;
+	} else if (ratio < 64000L) { /* 64x */
+		r = 0x00;
+	} else {
+		/* Invalid ratio */
+		printk(KERN_ERR "%s: Bad ratio %ld, giving up!\n", name, ratio);
+		goto out;
+	}
+
+	f = (ratio * (r + 2)) / 1000 - 2;
+
+	DBG("F[%d] R[%d] ratio*1000[%ld]\n", f, r, ratio);
+
+	if (unlikely(f < 0 || f > 127)) {
+		/* Invalid F */
+		printk(KERN_ERR "%s: F[%d] invalid!\n", name, f);
+		goto out;
+	}
+
+	pll_ctl0 = (u8) f;
+	pll_ctl1 = (u8) r;
+
+	DBG("Writing pll_ctl[%02X][%02X]\n", pll_ctl0, pll_ctl1);
+
+	outb(0x02,     sec_dma_base + 0x01);
+	outb(pll_ctl0, sec_dma_base + 0x03);
+	outb(0x03,     sec_dma_base + 0x01);
+	outb(pll_ctl1, sec_dma_base + 0x03);
+
+	/* Wait the PLL circuit to be stable */
+	mdelay(30);
+
+#ifdef DEBUG
+	/*
+	 *  Show the current clock value of PLL control register
+	 */
+	outb(0x02, sec_dma_base + 0x01);
+	pll_ctl0 = inb(sec_dma_base + 0x03);
+	outb(0x03, sec_dma_base + 0x01);
+	pll_ctl1 = inb(sec_dma_base + 0x03);
+
+	DBG("pll_ctl[%02X][%02X]\n", pll_ctl0, pll_ctl1);
+#endif
+
+ out:
 	return dev->irq;
 }
 
@@ -324,8 +588,8 @@ static void __devinit init_hwif_pdc202ne
 
 	hwif->tuneproc  = &pdcnew_tune_drive;
 	hwif->quirkproc = &pdcnew_quirkproc;
-	hwif->speedproc = &pdcnew_new_tune_chipset;
-	hwif->resetproc = &pdcnew_new_reset;
+	hwif->speedproc = &pdcnew_tune_chipset;
+	hwif->resetproc = &pdcnew_reset;
 
 	hwif->drives[0].autotune = hwif->drives[1].autotune = 1;
 
@@ -337,11 +601,14 @@ static void __devinit init_hwif_pdc202ne
 	hwif->ide_dma_check = &pdcnew_config_drive_xfer_rate;
 	hwif->ide_dma_lostirq = &pdcnew_ide_dma_lostirq;
 	hwif->ide_dma_timeout = &pdcnew_ide_dma_timeout;
-	if (!(hwif->udma_four))
-		hwif->udma_four = (pdcnew_new_cable_detect(hwif)) ? 0 : 1;
+
+	if (!hwif->udma_four)
+		hwif->udma_four = pdcnew_cable_detect(hwif) ? 0 : 1;
+
 	if (!noautodma)
 		hwif->autodma = 1;
 	hwif->drives[0].autodma = hwif->drives[1].autodma = hwif->autodma;
+
 #if PDC202_DEBUG_CABLE
 	printk(KERN_DEBUG "%s: %s-pin cable\n",
 		hwif->name, hwif->udma_four ? "80" : "40");
_

Patches currently in -mm which might be from sshtylyov@ru.mvista.com are

origin.patch
git-mtd.patch
3x59x-fix-pci-resource-management.patch
ide-hpt3xxn-clocking-fixes.patch
ide-fix-hpt37x-timing-tables.patch
ide-optimize-hpt37x-timing-tables.patch
ide-fix-hpt3xx-hotswap-support.patch
ide-fix-the-case-of-multiple-hpt3xx-chips-present.patch
ide-hpt3xx-fix-pci-clock-detection.patch
ide-hpt3xx-fix-pci-clock-detection-fix-2.patch
piix-fix-82371mx-enablebits.patch
piix-remove-check-for-broken-mw-dma-mode-0.patch
piix-slc90e66-pio-mode-fallback-fix.patch
hpt3xx-rework-rate-filtering.patch
hpt3xx-rework-rate-filtering-tidy.patch
hpt3xx-print-the-real-chip-name-at-startup.patch
hpt3xx-switch-to-using-pci_get_slot.patch
hpt3xx-cache-channels-mcr-address.patch
hpt3x7-merge-speedproc-handlers.patch
hpt370-clean-up-dma-timeout-handling.patch
hpt3xx-init-code-rewrite.patch
pdc202xx_new-fix-pll-timing-issues.patch

