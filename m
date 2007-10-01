From: akpm@linux-foundation.org
Subject: - pata_hpt3x2n-clean-up-dpll-stuff.patch removed from -mm tree
Date: Mon, 01 Oct 2007 00:14:08 -0700
Message-ID: <200710010714.l917E86B004509@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46502 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752397AbXJAHO0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2007 03:14:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pata_hpt3x2n: Clean up DPLL stuff
has been removed from the -mm tree.  Its filename was
     pata_hpt3x2n-clean-up-dpll-stuff.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pata_hpt3x2n: Clean up DPLL stuff
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/ata/pata_hpt37x.c~pata_hpt3x2n-clean-up-dpll-stuff drivers/ata/pata_hpt37x.c
--- a/drivers/ata/pata_hpt37x.c~pata_hpt3x2n-clean-up-dpll-stuff
+++ a/drivers/ata/pata_hpt37x.c
@@ -1,5 +1,5 @@
 /*
- * Libata driver for the highpoint 37x and 30x UDMA66 ATA controllers.
+ * Libata driver for the highpoint 37x and 30x UDMA ATA controllers.
  *
  * This driver is heavily based upon:
  *
@@ -844,6 +844,46 @@ static int hpt37x_calibrate_dpll(struct 
 	/* Never went stable */
 	return 0;
 }
+
+static void *hpt_tune_function(struct pci_dev *dev, int dpll, int clock_slot)
+{
+	static const int MHz[4] = { 33, 40, 50, 66 };
+	/*
+	 *	For non UDMA133 capable devices we should
+	 *	use a 50MHz DPLL by choice
+	 */
+	unsigned int f_low, f_high;
+	int adjust;
+
+	f_low = (MHz[clock_slot] * 48) / MHz[dpll];
+	f_high = f_low + 2;
+	if (clock_slot > 1)
+		f_high += 2;
+	/* Select the DPLL clock. */
+	pci_write_config_byte(dev, 0x5b, 0x21);
+	pci_write_config_dword(dev, 0x5C, (f_high << 16) | f_low | 0x100);
+
+	for(adjust = 0; adjust < 8; adjust++) {
+		if (hpt37x_calibrate_dpll(dev))
+			break;
+		/* See if it'll settle at a fractionally different clock */
+		if (adjust & 1)
+			f_low -= adjust >> 1;
+		else
+			f_high += adjust >> 1;
+		pci_write_config_dword(dev, 0x5C, (f_high << 16) | f_low | 0x100);
+	}
+	if (adjust == 8) {
+		printk(KERN_WARNING "hpt37x: DPLL did not stabilize.\n");
+		return NULL;
+	}
+	printk(KERN_INFO "hpt37x: Bus clock %dMHz, using DPLL.\n", MHz[dpll]);
+	if (dpll == 3)
+		return hpt37x_timings_66;
+	else
+		return hpt37x_timings_50;
+}
+
 /**
  *	hpt37x_init_one		-	Initialise an HPT37X/302
  *	@dev: PCI device
@@ -944,7 +984,7 @@ static int hpt37x_init_one(struct pci_de
 	u8 mcr1;
 	u32 freq;
 	int prefer_dpll = 1;
-
+	int hpt374alt = 0;
 	unsigned long iobase = pci_resource_start(dev, 4);
 
 	const struct hpt_chip *chip_table;
@@ -1046,9 +1086,18 @@ static int hpt37x_init_one(struct pci_de
 	if (chip_table == &hpt372a)
 		outb(0x0e, iobase + 0x9c);
 
+	/*
+	 * PLL must be done once
+	 */
+
+	if (chip_table == &hpt374 && PCI_FUNC(dev->devfn) & 1) {
+		/* The HPT374 secondary devfn is tuned to 50MHz when we find
+		   the primary */
+		port_info = *port;
+		port_info.private_data = hpt37x_timings_50;
+	}
 	/* Some devices do not let this value be accessed via PCI space
 	   according to the old driver */
-
 	freq = inl(iobase + 0x90);
 	if ((freq >> 12) != 0xABCDE) {
 		int i;
@@ -1056,6 +1105,9 @@ static int hpt37x_init_one(struct pci_de
 		u32 total = 0;
 
 		printk(KERN_WARNING "pata_hpt37x: BIOS has not set timing clocks.\n");
+		if (hpt374alt == 1)
+			printk(KERN_ERR "pata_hpt37x: No saved frequency on primary function.\n");
+
 
 		/* This is the process the HPT371 BIOS is reported to use */
 		for(i = 0; i < 128; i++) {
@@ -1074,48 +1126,19 @@ static int hpt37x_init_one(struct pci_de
 
 	clock_slot = hpt37x_clock_slot(freq, chip_table->base);
 	if (chip_table->clocks[clock_slot] == NULL || prefer_dpll) {
-		/*
-		 *	We need to try PLL mode instead
-		 *
-		 *	For non UDMA133 capable devices we should
-		 *	use a 50MHz DPLL by choice
-		 */
-		unsigned int f_low, f_high;
-		int dpll, adjust;
-
 		/* Compute DPLL */
-		dpll = (port->udma_mask & 0xC0) ? 3 : 2;
-
-		f_low = (MHz[clock_slot] * 48) / MHz[dpll];
-		f_high = f_low + 2;
-		if (clock_slot > 1)
-			f_high += 2;
-
-		/* Select the DPLL clock. */
-		pci_write_config_byte(dev, 0x5b, 0x21);
-		pci_write_config_dword(dev, 0x5C, (f_high << 16) | f_low | 0x100);
-
-		for(adjust = 0; adjust < 8; adjust++) {
-			if (hpt37x_calibrate_dpll(dev))
-				break;
-			/* See if it'll settle at a fractionally different clock */
-			if (adjust & 1)
-				f_low -= adjust >> 1;
-			else
-				f_high += adjust >> 1;
-			pci_write_config_dword(dev, 0x5C, (f_high << 16) | f_low | 0x100);
-		}
-		if (adjust == 8) {
-			printk(KERN_ERR "pata_hpt37x: DPLL did not stabilize!\n");
-			return -ENODEV;
+		int dpll = 2;
+		if (port->udma_mask & 0xC0)
+  			dpll = 3;
+		private_data = hpt_tune_function(dev, dpll, clock_slot);
+		/* For the HPT374 tune both channels together from fn 0 */
+		if (chip_table == &hpt374 && !(PCI_FUNC(dev->devfn) & 1)) {
+			struct pci_dev *pair = pci_get_slot(dev->bus, dev->devfn + 1);
+			if (pair != NULL) {
+				hpt_tune_function(pair, dpll, clock_slot);
+				pci_dev_put(pair);
+			}
 		}
-		if (dpll == 3)
-			private_data = (void *)hpt37x_timings_66;
-		else
-			private_data = (void *)hpt37x_timings_50;
-
-		printk(KERN_INFO "pata_hpt37x: bus clock %dMHz, using %dMHz DPLL.\n",
-		       MHz[clock_slot], MHz[dpll]);
 	} else {
 		private_data = (void *)chip_table->clocks[clock_slot];
 		/*
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
pata_acpi-use-ata_sff_port_start.patch
libata-correct-handling-of-srst-reset-sequences.patch
libata-add-a-drivers-ide-style-dma-disable.patch
ata-pata_marvell-use-ioread-for-iomap-ped-memory.patch
drivers-ata-pata_ixp4xx_cfc-ioremap-return-code-check.patch
libata-add-a-horkage-entry-for-drq-mishandling-atapi.patch
libata_scsi-fix-transfer-lengths.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
introduce-dma_mask_none-as-a-signal-for-unable-to-do.patch
pcmcia-use-dma_mask_none-for-the-default-for-all.patch
serial_txx9-cleanup-includes.patch
serial-keep-the-dtr-setting-for-serial-console.patch
8250_pci-autodetect-mainpine-cards.patch
8250_pci-autodetect-mainpine-cards-fix.patch
wake-up-from-a-serial-port.patch
fix-ide-legacy-mode-resources.patch
fix-ide-legacy-mode-resources-fix.patch
git-scsi-misc.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
blackfin-enable-arbitary-speed-serial-setting.patch
tty-bring-the-old-cris-driver-back-somewhere-into-the.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
ttyh-remove-dead-define.patch
codingstyle-relax-the-80-cole-rule.patch
add-config_vt_unicode.patch
keys-missing-word-in-documentation.patch
ide-cd-is-unmaintained.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios-fix.patch
fs-correct-sus-compliance-for-open-of-large-file-without.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
usb_serial-stop-passing-null-to-functions-that-expect-data.patch
ark3116-update-termios-handling.patch
usb-serial-kill-another-case-we-pass-null-and-shouldnt.patch
ch341-fix-termios-handling.patch
digi_acceleport-fix-termios-and-also-readability-a-bit.patch
empeg-clean-up-and-handle-speeds.patch
funsoft-fix-termios.patch
ir_usb-termios-handling.patch
keyspan-termios-tidy.patch
kobil_sct-termios-encoding-fixups.patch
option-termios-handling.patch
sierra-termios.patch
usb-serial-handle-null-termios-methods-as-no-hardware-changing-support.patch
visor-termios-bits.patch
