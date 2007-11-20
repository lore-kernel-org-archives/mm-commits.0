From: akpm@linux-foundation.org
Subject: + 8250_pci-coding-style.patch added to -mm tree
Date: Mon, 19 Nov 2007 23:23:24 -0800
Message-ID: <200711200723.lAK7NOB5021392@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55472 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754823AbXKTH3J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Nov 2007 02:29:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     8250_pci: coding style
has been added to the -mm tree.  Its filename is
     8250_pci-coding-style.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: 8250_pci: coding style
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pci.c |  109 +++++++++++++++++-------------------
 1 file changed, 54 insertions(+), 55 deletions(-)

diff -puN drivers/serial/8250_pci.c~8250_pci-coding-style drivers/serial/8250_pci.c
--- a/drivers/serial/8250_pci.c~8250_pci-coding-style
+++ a/drivers/serial/8250_pci.c
@@ -114,7 +114,7 @@ afavlab_setup(struct serial_private *pri
 	      struct uart_port *port, int idx)
 {
 	unsigned int bar, offset = board->first_offset;
-	
+
 	bar = FL_GET_BASE(board->flags);
 	if (idx < 4)
 		bar += idx;
@@ -201,8 +201,8 @@ static int pci_inteli960ni_init(struct p
 		return -ENODEV;
 
 	/* is firmware started? */
-	pci_read_config_dword(dev, 0x44, (void*) &oldval); 
-	if (oldval == 0x00001000L) { /* RESET value */ 
+	pci_read_config_dword(dev, 0x44, (void *)&oldval);
+	if (oldval == 0x00001000L) { /* RESET value */
 		printk(KERN_DEBUG "Local i960 firmware missing");
 		return -ENODEV;
 	}
@@ -227,11 +227,11 @@ static int pci_plx9050_init(struct pci_d
 
 	irq_config = 0x41;
 	if (dev->vendor == PCI_VENDOR_ID_PANACOM ||
-	    dev->subsystem_vendor == PCI_SUBVENDOR_ID_EXSYS) {
+	    dev->subsystem_vendor == PCI_SUBVENDOR_ID_EXSYS)
 		irq_config = 0x43;
-	}
+
 	if ((dev->vendor == PCI_VENDOR_ID_PLX) &&
-	    (dev->device == PCI_DEVICE_ID_PLX_ROMULUS)) {
+	    (dev->device == PCI_DEVICE_ID_PLX_ROMULUS))
 		/*
 		 * As the megawolf cards have the int pins active
 		 * high, and have 2 UART chips, both ints must be
@@ -241,8 +241,6 @@ static int pci_plx9050_init(struct pci_d
 		 * deep FIFOs
 		 */
 		irq_config = 0x5b;
-	}
-
 	/*
 	 * enable/disable interrupts
 	 */
@@ -317,14 +315,14 @@ static int sbs_init(struct pci_dev *dev)
 {
 	u8 __iomem *p;
 
-	p = ioremap(pci_resource_start(dev, 0),pci_resource_len(dev,0));
+	p = ioremap(pci_resource_start(dev, 0), pci_resource_len(dev, 0));
 
 	if (p == NULL)
 		return -ENOMEM;
 	/* Set bit-4 Control Register (UART RESET) in to reset the uarts */
-	writeb(0x10,p + OCT_REG_CR_OFF);
+	writeb(0x10, p + OCT_REG_CR_OFF);
 	udelay(50);
-	writeb(0x0,p + OCT_REG_CR_OFF);
+	writeb(0x0, p + OCT_REG_CR_OFF);
 
 	/* Set bit-2 (INTENABLE) of Control Register */
 	writeb(0x4, p + OCT_REG_CR_OFF);
@@ -341,10 +339,10 @@ static void __devexit sbs_exit(struct pc
 {
 	u8 __iomem *p;
 
-	p = ioremap(pci_resource_start(dev, 0),pci_resource_len(dev,0));
-	if (p != NULL) {
+	p = ioremap(pci_resource_start(dev, 0), pci_resource_len(dev, 0));
+	/* FIXME: What if resource_len < OCT_REG_CR_OFF */
+	if (p != NULL)
 		writeb(0, p + OCT_REG_CR_OFF);
-	}
 	iounmap(p);
 }
 
@@ -360,7 +358,7 @@ static void __devexit sbs_exit(struct pc
  * with other OSes (like M$ DOS).
  *
  *  SIIG support added by Andrey Panin <pazke@donpac.ru>, 10/1999
- * 
+ *
  * There is two family of SIIG serial cards with different PCI
  * interface chip and different configuration methods:
  *     - 10x cards have control registers in IO and/or memory space;
@@ -463,21 +461,21 @@ static const unsigned short timedia_sing
 
 static const unsigned short timedia_dual_port[] = {
 	0x0002, 0x4036, 0x4037, 0x4038, 0x4078, 0x4079, 0x4085,
-	0x4088, 0x4089, 0x5037, 0x5078, 0x5079, 0x5085, 0x6079, 
-	0x7079, 0x8079, 0x8137, 0x8138, 0x8237, 0x8238, 0x9079, 
+	0x4088, 0x4089, 0x5037, 0x5078, 0x5079, 0x5085, 0x6079,
+	0x7079, 0x8079, 0x8137, 0x8138, 0x8237, 0x8238, 0x9079,
 	0x9137, 0x9138, 0x9237, 0x9238, 0xA079, 0xB079, 0xC079,
 	0xD079, 0
 };
 
 static const unsigned short timedia_quad_port[] = {
-	0x4055, 0x4056, 0x4095, 0x4096, 0x5056, 0x8156, 0x8157, 
-	0x8256, 0x8257, 0x9056, 0x9156, 0x9157, 0x9158, 0x9159, 
+	0x4055, 0x4056, 0x4095, 0x4096, 0x5056, 0x8156, 0x8157,
+	0x8256, 0x8257, 0x9056, 0x9156, 0x9157, 0x9158, 0x9159,
 	0x9256, 0x9257, 0xA056, 0xA157, 0xA158, 0xA159, 0xB056,
 	0xB157, 0
 };
 
 static const unsigned short timedia_eight_port[] = {
-	0x4065, 0x4066, 0x5065, 0x5066, 0x8166, 0x9066, 0x9166, 
+	0x4065, 0x4066, 0x5065, 0x5066, 0x8166, 0x9066, 0x9166,
 	0x9167, 0x9168, 0xA066, 0xA167, 0xA168, 0
 };
 
@@ -630,7 +628,8 @@ static int pci_ite887x_init(struct pci_d
 				ITE_887x_POSIO_ENABLE | ITE_887x_POSIO_SPEED |
 				ITE_887x_POSIO_IOSIZE_32 | inta_addr[i]);
 			/* write INTCBAR - ioport */
-			pci_write_config_dword(dev, ITE_887x_INTCBAR, inta_addr[i]);
+			pci_write_config_dword(dev, ITE_887x_INTCBAR,
+								inta_addr[i]);
 			ret = inb(inta_addr[i]);
 			if (ret != 0xff) {
 				/* ioport connected */
@@ -729,7 +728,7 @@ pci_default_setup(struct serial_private 
 
 	if (board->flags & FL_REGION_SZ_CAP && idx >= maxnr)
 		return 1;
-			
+
 	return setup_port(priv, port, bar, offset, board->reg_shift);
 }
 
@@ -807,7 +806,7 @@ static struct pci_serial_quirk pci_seria
 		.init		= pci_plx9050_init,
 		.setup		= pci_default_setup,
 		.exit		= __devexit_p(pci_plx9050_exit),
-	},		
+	},
 	{
 		.vendor		= PCI_VENDOR_ID_PANACOM,
 		.device		= PCI_DEVICE_ID_PANACOM_DUALMODEM,
@@ -996,7 +995,7 @@ static struct pci_serial_quirk *find_qui
 		    quirk_id_matches(quirk->device, dev->device) &&
 		    quirk_id_matches(quirk->subvendor, dev->subsystem_vendor) &&
 		    quirk_id_matches(quirk->subdevice, dev->subsystem_device))
-		 	break;
+			break;
 	return quirk;
 }
 
@@ -1669,7 +1668,7 @@ static struct pciserial_board pci_boards
 };
 
 static const struct pci_device_id softmodem_blacklist[] = {
-	{ PCI_VDEVICE ( AL, 0x5457 ), }, /* ALi Corporation M5457 AC'97 Modem */
+	{ PCI_VDEVICE(AL, 0x5457), }, /* ALi Corporation M5457 AC'97 Modem */
 };
 
 /*
@@ -1682,13 +1681,13 @@ serial_pci_guess_board(struct pci_dev *d
 {
 	const struct pci_device_id *blacklist;
 	int num_iomem, num_port, first_port = -1, i;
-	
+
 	/*
 	 * If it is not a communications device or the programming
 	 * interface is greater than 6, give up.
 	 *
 	 * (Should we try to make guesses for multiport serial devices
-	 * later?) 
+	 * later?)
 	 */
 	if ((((dev->class >> 8) != PCI_CLASS_COMMUNICATION_SERIAL) &&
 	     ((dev->class >> 8) != PCI_CLASS_COMMUNICATION_MODEM)) ||
@@ -1821,25 +1820,23 @@ pciserial_init_ports(struct pci_dev *dev
 			break;
 
 #ifdef SERIAL_DEBUG_PCI
-		printk("Setup PCI port: port %x, irq %d, type %d\n",
+		printk(KERN_DEBUG "Setup PCI port: port %x, irq %d, type %d\n",
 		       serial_port.iobase, serial_port.irq, serial_port.iotype);
 #endif
-		
+
 		priv->line[i] = serial8250_register_port(&serial_port);
 		if (priv->line[i] < 0) {
 			printk(KERN_WARNING "Couldn't register serial port %s: %d\n", pci_name(dev), priv->line[i]);
 			break;
 		}
 	}
-
 	priv->nr = i;
-
 	return priv;
 
- err_deinit:
+err_deinit:
 	if (quirk->exit)
 		quirk->exit(dev);
- err_out:
+err_out:
 	return priv;
 }
 EXPORT_SYMBOL_GPL(pciserial_init_ports);
@@ -2129,22 +2126,22 @@ static struct pci_device_id serial_pci_t
 		pbn_b0_8_1843200_200 },
 
 	{	PCI_VENDOR_ID_SEALEVEL, PCI_DEVICE_ID_SEALEVEL_U530,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b2_bt_1_115200 },
 	{	PCI_VENDOR_ID_SEALEVEL, PCI_DEVICE_ID_SEALEVEL_UCOMM2,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b2_bt_2_115200 },
 	{	PCI_VENDOR_ID_SEALEVEL, PCI_DEVICE_ID_SEALEVEL_UCOMM422,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b2_bt_4_115200 },
 	{	PCI_VENDOR_ID_SEALEVEL, PCI_DEVICE_ID_SEALEVEL_UCOMM232,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b2_bt_2_115200 },
 	{	PCI_VENDOR_ID_SEALEVEL, PCI_DEVICE_ID_SEALEVEL_COMM4,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b2_bt_4_115200 },
 	{	PCI_VENDOR_ID_SEALEVEL, PCI_DEVICE_ID_SEALEVEL_COMM8,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b2_8_115200 },
 	{	PCI_VENDOR_ID_SEALEVEL, PCI_DEVICE_ID_SEALEVEL_UCOMM8,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
@@ -2159,11 +2156,11 @@ static struct pci_device_id serial_pci_t
 	/*
 	 * VScom SPCOM800, from sl@s.pl
 	 */
-	{	PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_SPCOM800, 
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 
+	{	PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_SPCOM800,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b2_8_921600 },
 	{	PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_1077,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b2_4_921600 },
 	{	PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050,
 		PCI_SUBVENDOR_ID_KEYSPAN,
@@ -2181,27 +2178,27 @@ static struct pci_device_id serial_pci_t
 		pbn_b2_4_115200 },
 	{	PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050,
 		PCI_SUBVENDOR_ID_CHASE_PCIFAST,
-		PCI_SUBDEVICE_ID_CHASE_PCIFAST4, 0, 0, 
+		PCI_SUBDEVICE_ID_CHASE_PCIFAST4, 0, 0,
 		pbn_b2_4_460800 },
 	{	PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050,
 		PCI_SUBVENDOR_ID_CHASE_PCIFAST,
-		PCI_SUBDEVICE_ID_CHASE_PCIFAST8, 0, 0, 
+		PCI_SUBDEVICE_ID_CHASE_PCIFAST8, 0, 0,
 		pbn_b2_8_460800 },
 	{	PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050,
 		PCI_SUBVENDOR_ID_CHASE_PCIFAST,
-		PCI_SUBDEVICE_ID_CHASE_PCIFAST16, 0, 0, 
+		PCI_SUBDEVICE_ID_CHASE_PCIFAST16, 0, 0,
 		pbn_b2_16_460800 },
 	{	PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050,
 		PCI_SUBVENDOR_ID_CHASE_PCIFAST,
-		PCI_SUBDEVICE_ID_CHASE_PCIFAST16FMC, 0, 0, 
+		PCI_SUBDEVICE_ID_CHASE_PCIFAST16FMC, 0, 0,
 		pbn_b2_16_460800 },
 	{	PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050,
 		PCI_SUBVENDOR_ID_CHASE_PCIRAS,
-		PCI_SUBDEVICE_ID_CHASE_PCIRAS4, 0, 0, 
+		PCI_SUBDEVICE_ID_CHASE_PCIRAS4, 0, 0,
 		pbn_b2_4_460800 },
 	{	PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050,
 		PCI_SUBVENDOR_ID_CHASE_PCIRAS,
-		PCI_SUBDEVICE_ID_CHASE_PCIRAS8, 0, 0, 
+		PCI_SUBDEVICE_ID_CHASE_PCIRAS8, 0, 0,
 		pbn_b2_8_460800 },
 	{	PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050,
 		PCI_SUBVENDOR_ID_EXSYS,
@@ -2227,10 +2224,12 @@ static struct pci_device_id serial_pci_t
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b1_8_115200 },
 	{	PCI_VENDOR_ID_SPECIALIX, PCI_DEVICE_ID_OXSEMI_16PCI954,
-		PCI_VENDOR_ID_SPECIALIX, PCI_SUBDEVICE_ID_SPECIALIX_SPEED4, 0, 0,
+		PCI_VENDOR_ID_SPECIALIX, PCI_SUBDEVICE_ID_SPECIALIX_SPEED4,
+		0, 0,
 		pbn_b0_4_921600 },
 	{	PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_16PCI954,
-		PCI_SUBVENDOR_ID_SIIG, PCI_SUBDEVICE_ID_SIIG_QUARTET_SERIAL, 0, 0,
+		PCI_SUBVENDOR_ID_SIIG, PCI_SUBDEVICE_ID_SIIG_QUARTET_SERIAL,
+		0, 0,
 		pbn_b0_4_1152000 },
 
 		/*
@@ -2270,7 +2269,7 @@ static struct pci_device_id serial_pci_t
 	 * Digitan DS560-558, from jimd@esoft.com
 	 */
 	{	PCI_VENDOR_ID_ATT, PCI_DEVICE_ID_ATT_VENUS_MODEM,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b1_1_115200 },
 
 	/*
@@ -2278,16 +2277,16 @@ static struct pci_device_id serial_pci_t
 	 *  The 400L and 800L have a custom setup quirk.
 	 */
 	{	PCI_VENDOR_ID_TITAN, PCI_DEVICE_ID_TITAN_100,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b0_1_921600 },
 	{	PCI_VENDOR_ID_TITAN, PCI_DEVICE_ID_TITAN_200,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b0_2_921600 },
 	{	PCI_VENDOR_ID_TITAN, PCI_DEVICE_ID_TITAN_400,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b0_4_921600 },
 	{	PCI_VENDOR_ID_TITAN, PCI_DEVICE_ID_TITAN_800B,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b0_4_921600 },
 	{	PCI_VENDOR_ID_TITAN, PCI_DEVICE_ID_TITAN_100L,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

termios-document-callback-more-clearly.patch
revert-keyspan-init-termios-properly.patch
git-arm.patch
git-libata-all.patch
pata_hpt37x-fix-outstanding-bug-reports-on-the-hpt374-and-37x-cable-detect-checkpatch-fixes.patch
libata-separate-out-ata_acpi_gtm_xfermask-from-pacpi_discover_modes.patch
libata-fix-ata_acpi_gtm_xfermask.patch
libata-implement-ata_timing_cycle2mode-and-use-it-in-libata-acpi-and-pata_acpi.patch
libata-reimplement-ata_acpi_cbl_80wire-using-ata_acpi_gtm_xfermask.patch
libata-add-ata_cbl_pata_ign.patch
pata_amd-update-mode-selection-for-nv-patas.patch
ahci-invalid-use-of-writel-readl-with-iomap.patch
libata-core-list-more-documentation-sources-for-reference.patch
libata-iordy-handling.patch
libata-sff-tf_load.patch
pata_ali-add-mitac-8317-and-derivatives.patch
pata_ali-lots-of-problems-still-showing-up-with-small-atapi-dma.patch
pata_hpt37x-fix-cable-detect-bug-spotted-by-sergei.patch
pata_isapnp-polled-devices.patch
pata_pcmcia-minor-cleanups-and-support-for-dual-channel-cards.patch
pata_ninja32-cardbus-ata-initial-support.patch
pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int.patch
pcmcia-replace-kio_addr_t-with-unsigned-int-everywhere.patch
serial-keep-the-dtr-setting-for-serial-console.patch
quirk_vialatency-omit-reading-pci-revision-id.patch
quirk_vialatency-omit-reading-pci-revision-id-checkpatch-fixes.patch
git-scsi-rc-fixes.patch
initio-fix-conflict-when-loading-driver.patch
pata_amd-pata_via-de-couple-programming-of-pio-mwdma-and-udma-timings.patch
geode-lists-are-subscriber-only.patch
tty-kill-tty_flipbuf_size.patch
drivers-edac-turnon-edac-device-error-logging.patch
drivers-edac-use-round_jiffies_relative.patch
drivers-edac-add-cell-xdr-memory-types.patch
drivers-edac-add-cell-mc-driver.patch
drivers-edac-i3000-code-tidying.patch
drivers-edac-i3000-replace-macros-with-functions.patch
drivers-edac-add-freescale-mpc85xx-driver.patch
drivers-edac-add-marvell-mv64x60-driver.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
dz-clean-up-and-improve-the-setup-of-termios-settings.patch
char-rocket-switch-long-delay-to-sleep.patch
char-rocket-printk-cleanup.patch
char-char-serial-remove-serial_type_normal-redefines.patch
char-mxser_new-ioaddresses-are-ulong.patch
char-stallion-fix-compiler-warnings.patch
char-riscom8-change-rc_init_drivers-prototype.patch
tty-add-the-new-termios2-ioctls-to-the-compatible.patch
tty-let-architectures-override-the-user-kernel-macros.patch
tty-s390-support-for-termios2.patch
moxa-first-pass-at-termios-reporting.patch
n_tty-clean-up-old-code-to-follow-coding-style-and-mostly-checkpatch.patch
rocket-first-pass-at-termios-reporting.patch
rocket-dont-let-random-users-reset-the-controller.patch
tty_audit-fix-checkpatch-complaint.patch
tty_io-drag-screaming-into-coding-style-compliance.patch
tty_ioctl-drag-screaming-into-compliance-with-the-coding.patch
8250_early-coding-style.patch
8250_gsc-coding-style.patch
8250_hp300-coding-style.patch
8250_hub6-codding-style.patch
8250_pci-coding-style.patch
serial8250-coding-style.patch
8250-enable-rate-reporting-via-termios.patch
serial_core-bring-mostly-into-line-with-coding-style.patch
