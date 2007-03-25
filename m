From: akpm@linux-foundation.org
Subject: + pata_hpt3x2n-add-hpt371n-support-and-other-bits.patch added to -mm tree
Date: Sun, 25 Mar 2007 00:53:35 -0800
Message-ID: <200703250853.l2P8rZka024149@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36738 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503AbXCYIxq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 04:53:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     pata_hpt3x2n: Add HPT371N support and other bits
has been added to the -mm tree.  Its filename is
     pata_hpt3x2n-add-hpt371n-support-and-other-bits.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pata_hpt3x2n: Add HPT371N support and other bits
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Yes its no longer 3x2n but 3xxn, I can rename it if you want Jeff

- Don't reset both ports each time (Sergei)
- If we can't get a DPLL then abort entirely
- Use ioport access for clock (from drivers/ide)
- Add HPT371N support (from drivers/ide)

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_hpt3x2n.c |   45 +++++++++++++++++++++++++++++------
 1 file changed, 38 insertions(+), 7 deletions(-)

diff -puN drivers/ata/pata_hpt3x2n.c~pata_hpt3x2n-add-hpt371n-support-and-other-bits drivers/ata/pata_hpt3x2n.c
--- a/drivers/ata/pata_hpt3x2n.c~pata_hpt3x2n-add-hpt371n-support-and-other-bits
+++ a/drivers/ata/pata_hpt3x2n.c
@@ -8,10 +8,10 @@
  * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
  * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
  * Portions Copyright (C) 2003		Red Hat Inc
+ * Portions Copyright (C) 2005-2006	MontaVista Software, Inc.
  *
  *
  * TODO
- *	371N
  *	Work out best PLL policy
  */
 
@@ -142,6 +142,7 @@ static int hpt3x2n_cable_detect(struct a
 /**
  *	hpt3x2n_pre_reset	-	reset the hpt3x2n bus
  *	@ap: ATA port to reset
+ *	@deadline: deadline jiffies for the operation
  *
  *	Perform the initial reset handling for the 3x2n series controllers.
  *	Reset the hardware and state machine,
@@ -151,8 +152,7 @@ static int hpt3xn_pre_reset(struct ata_p
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	/* Reset the state machine */
-	pci_write_config_byte(pdev, 0x50, 0x37);
-	pci_write_config_byte(pdev, 0x54, 0x37);
+	pci_write_config_byte(pdev, 0x50 + 4 * ap->port_no, 0x37);
 	udelay(100);
 
 	return ata_std_prereset(ap, deadline);
@@ -434,8 +434,9 @@ static int hpt3x2n_pci_clock(struct pci_
 {
 	unsigned long freq;
 	u32 fcnt;
+	unsigned long iobase = pci_resource_start(pdev, 4);
 
-	pci_read_config_dword(pdev, 0x70/*CHECKME*/, &fcnt);
+	fcnt = inl(iobase + 0x90);	/* Not PCI readable for some chips */
 	if ((fcnt >> 12) != 0xABCDE) {
 		printk(KERN_WARNING "hpt3xn: BIOS clock data not set.\n");
 		return 33;	/* Not BIOS set */
@@ -504,6 +505,7 @@ static int hpt3x2n_init_one(struct pci_d
 	unsigned int pci_mhz;
 	unsigned int f_low, f_high;
 	int adjust;
+	unsigned long iobase = pci_resource_start(dev, 4);
 
 	pci_read_config_dword(dev, PCI_CLASS_REVISION, &class_rev);
 	class_rev &= 0xFF;
@@ -513,6 +515,11 @@ static int hpt3x2n_init_one(struct pci_d
 			if (class_rev < 6)
 				return -ENODEV;
 			break;
+		case PCI_DEVICE_ID_TTI_HPT371:
+			if (class_rev < 2)
+				return -ENODEV;
+			/* 371N if rev > 1 */
+			break;
 		case PCI_DEVICE_ID_TTI_HPT372:
 			/* 372N if rev >= 1*/
 			if (class_rev == 0)
@@ -540,6 +547,19 @@ static int hpt3x2n_init_one(struct pci_d
 	irqmask &= ~0x10;
 	pci_write_config_byte(dev, 0x5a, irqmask);
 
+	/*
+	 * HPT371 chips physically have only one channel, the secondary one,
+	 * but the primary channel registers do exist!  Go figure...
+	 * So,  we manually disable the non-existing channel here
+	 * (if the BIOS hasn't done this already).
+	 */
+	if (dev->device == PCI_DEVICE_ID_TTI_HPT371) {
+		u8 mcr1;
+		pci_read_config_byte(dev, 0x50, &mcr1);
+		mcr1 &= ~0x04;
+		pci_write_config_byte(dev, 0x50, mcr1);
+	}
+
 	/* Tune the PLL. HPT recommend using 75 for SATA, 66 for UDMA133 or
 	   50 for UDMA100. Right now we always use 66 */
 
@@ -558,14 +578,24 @@ static int hpt3x2n_init_one(struct pci_d
 			break;
 		pci_write_config_dword(dev, 0x5C, (f_high << 16) | f_low);
 	}
-	if (adjust == 8)
-		printk(KERN_WARNING "hpt3xn: DPLL did not stabilize.\n");
+	if (adjust == 8) {
+		printk(KERN_WARNING "hpt3x2n: DPLL did not stabilize.\n");
+		return -ENODEV;
+	}
 
 	/* Set our private data up. We only need a few flags so we use
 	   it directly */
 	port->private_data = NULL;
-	if (pci_mhz > 60)
+	if (pci_mhz > 60) {
 		port->private_data = (void *)PCI66;
+		/*
+		 * On  HPT371N, if ATA clock is 66 MHz we must set bit 2 in
+		 * the MISC. register to stretch the UltraDMA Tss timing.
+		 * NOTE: This register is only writeable via I/O space.
+		 */
+		if (dev->device == PCI_DEVICE_ID_TTI_HPT371)
+			outb(inb(iobase + 0x9c) | 0x04, iobase + 0x9c);
+	}
 
 	/* Now kick off ATA set up */
 	port_info[0] = port_info[1] = port;
@@ -574,6 +604,7 @@ static int hpt3x2n_init_one(struct pci_d
 
 static const struct pci_device_id hpt3x2n[] = {
 	{ PCI_VDEVICE(TTI, PCI_DEVICE_ID_TTI_HPT366), },
+	{ PCI_VDEVICE(TTI, PCI_DEVICE_ID_TTI_HPT371), },
 	{ PCI_VDEVICE(TTI, PCI_DEVICE_ID_TTI_HPT372), },
 	{ PCI_VDEVICE(TTI, PCI_DEVICE_ID_TTI_HPT302), },
 	{ PCI_VDEVICE(TTI, PCI_DEVICE_ID_TTI_HPT372N), },
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

generic_serial-fix-decoding-of-baud-rate.patch
git-libata-all.patch
pcmcia-spot-slave-decode-flaws-for-testing.patch
libata-misc-minor-merge-fixups.patch
tty-minor-merge-correction.patch
pata_pdc202xx_old-lba48-bug.patch
pata_hpt37x-further-small-fixes.patch
pata_hpt3x2n-add-hpt371n-support-and-other-bits.patch
pata_pdc2027x-bring-into-line-with-changes-add-the-mode.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
baycom_ser_fdx-also-allow-i-o-ports-=-0x1000-and-enhanced.patch
resend-iphase-64bit-cleanup.patch
serial-suppress-rts-assertion-with-disabled-crtscts.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
tty-clarify-documentation-of-write.patch
tty-i386-x86_64-arbitary-speed-support.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
tty-remove-unnecessary-export-of-proc_clear_tty.patch
tty-simplify-calling-of-put_pid.patch
tty-introduce-no_tty-and-use-it-in-selinux.patch
tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up.patch
protect-tty-drivers-list-with-tty_mutex.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
