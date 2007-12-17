From: akpm@linux-foundation.org
Subject: + parport_pc-detection-for-superio-it87xx-post.patch added to -mm tree
Date: Sun, 16 Dec 2007 18:46:49 -0800
Message-ID: <200712170246.lBH2knex026581@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59639 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762026AbXLQCrW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Dec 2007 21:47:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: petr.cvek@tul.cz


The patch titled
     parport_pc: detection for SuperIO IT87XX POST
has been added to the -mm tree.  Its filename is
     parport_pc-detection-for-superio-it87xx-post.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: parport_pc: detection for SuperIO IT87XX POST
From: Petr Cvek <petr.cvek@tul.cz>

Add detection for IT87XX SuperIO chip and disabling its POST feature, which
made noise on parallel port's pins.

Signed-off-by: Petr Cvek <petr.cvek@tul.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/parport_pc.c |   45 ++++++++++++++++++++++++++++-----
 1 file changed, 39 insertions(+), 6 deletions(-)

diff -puN drivers/parport/parport_pc.c~parport_pc-detection-for-superio-it87xx-post drivers/parport/parport_pc.c
--- a/drivers/parport/parport_pc.c~parport_pc-detection-for-superio-it87xx-post
+++ a/drivers/parport/parport_pc.c
@@ -1540,6 +1540,38 @@ static void __devinit detect_and_report_
 	smsc_check(0x3f0,0x44);
 	smsc_check(0x370,0x44);
 }
+
+static void __devinit detect_and_report_it87(void)
+{
+	u16 dev;
+	u8 r;
+	if (verbose_probing)
+		printk(KERN_DEBUG "IT8705 Super-IO detection, now testing port 2E ...\n");
+	if (!request_region(0x2e, 1, __FUNCTION__))
+		return;
+	outb(0x87, 0x2e);
+	outb(0x01, 0x2e);
+	outb(0x55, 0x2e);
+	outb(0x55, 0x2e);
+	outb(0x20, 0x2e);
+	dev = inb(0x2f) << 8;
+	outb(0x21, 0x2e);
+	dev |= inb(0x2f);
+	if (dev == 0x8712 || dev == 0x8705 || dev == 0x8715 ||
+	    dev == 0x8716 || dev == 0x8718 || dev == 0x8726) {
+		printk(KERN_INFO "IT%04X SuperIO detected.\n", dev);
+		outb(0x07, 0x2E);	/* Parallel Port */
+		outb(0x03, 0x2F);
+		outb(0xF0, 0x2E);	/* BOOT 0x80 off */
+		r = inb(0x2f);
+		outb(0xF0, 0x2E);
+		outb(r | 8, 0x2F);
+		outb(0x02, 0x2E);	/* Lock */
+		outb(0x02, 0x2F);
+
+		release_region(0x2e, 1);
+	}
+}
 #endif /* CONFIG_PARPORT_PC_SUPERIO */
 
 static int get_superio_dma (struct parport *p)
@@ -3159,24 +3191,25 @@ static void __init parport_pc_find_ports
 	int count = 0, err;
 
 #ifdef CONFIG_PARPORT_PC_SUPERIO
-	detect_and_report_winbond ();
-	detect_and_report_smsc ();
+	detect_and_report_it87();
+	detect_and_report_winbond();
+	detect_and_report_smsc();
 #endif
 
 	/* Onboard SuperIO chipsets that show themselves on the PCI bus. */
-	count += parport_pc_init_superio (autoirq, autodma);
+	count += parport_pc_init_superio(autoirq, autodma);
 
 	/* PnP ports, skip detection if SuperIO already found them */
 	if (!count) {
-		err = pnp_register_driver (&parport_pc_pnp_driver);
+		err = pnp_register_driver(&parport_pc_pnp_driver);
 		if (!err)
 			pnp_registered_parport = 1;
 	}
 
 	/* ISA ports and whatever (see asm/parport.h). */
-	parport_pc_find_nonpci_ports (autoirq, autodma);
+	parport_pc_find_nonpci_ports(autoirq, autodma);
 
-	err = pci_register_driver (&parport_pc_pci_driver);
+	err = pci_register_driver(&parport_pc_pci_driver);
 	if (!err)
 		pci_registered_parport = 1;
 }
_

Patches currently in -mm which might be from petr.cvek@tul.cz are

parport_pc-detection-for-superio-it87xx-post.patch
