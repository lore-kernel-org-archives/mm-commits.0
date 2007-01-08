From: akpm@osdl.org
Subject: + ide-generic-jmicron-has-its-own-drivers-now.patch added to -mm tree
Date: Mon, 08 Jan 2007 15:08:07 -0800
Message-ID: <200701082308.l08N88se022067@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52028 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161111AbXAHXIu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 18:08:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorgukCox, alan@redhat.com, bzolnier@gmail.com


The patch titled
     ide/generic: Jmicron has its own drivers now
has been added to the -mm tree.  Its filename is
     ide-generic-jmicron-has-its-own-drivers-now.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ide/generic: Jmicron has its own drivers now
From: Alan <alan@lxorgukCox .ukuu.org.uk>

Drop ide-generic support for Jmicron identifiers as we now trust Jmicron.c for
this with drivers/ide.  The code check remains for the all-generic-ide case.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ide/pci/generic.c |   35 -----------------------------------
 1 files changed, 35 deletions(-)

diff -puN drivers/ide/pci/generic.c~ide-generic-jmicron-has-its-own-drivers-now drivers/ide/pci/generic.c
--- a/drivers/ide/pci/generic.c~ide-generic-jmicron-has-its-own-drivers-now
+++ a/drivers/ide/pci/generic.c
@@ -185,36 +185,6 @@ static ide_pci_device_t generic_chipsets
 		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
-	},{	/* 15 */
-		.name		= "JMB361",
-		.init_hwif	= init_hwif_generic,
-		.channels	= 2,
-		.autodma	= AUTODMA,
-		.bootable	= OFF_BOARD,
-	},{	/* 16 */
-		.name		= "JMB363",
-		.init_hwif	= init_hwif_generic,
-		.channels	= 2,
-		.autodma	= AUTODMA,
-		.bootable	= OFF_BOARD,
-	},{	/* 17 */
-		.name		= "JMB365",
-		.init_hwif	= init_hwif_generic,
-		.channels	= 2,
-		.autodma	= AUTODMA,
-		.bootable	= OFF_BOARD,
-	},{	/* 18 */
-		.name		= "JMB366",
-		.init_hwif	= init_hwif_generic,
-		.channels	= 2,
-		.autodma	= AUTODMA,
-		.bootable	= OFF_BOARD,
-	},{	/* 19 */
-		.name		= "JMB368",
-		.init_hwif	= init_hwif_generic,
-		.channels	= 2,
-		.autodma	= AUTODMA,
-		.bootable	= OFF_BOARD,
 	}
 };
 
@@ -281,11 +251,6 @@ static struct pci_device_id generic_pci_
 	{ PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_1,   PCI_ANY_ID, PCI_ANY_ID, 0, 0, 12},
 	{ PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_2,   PCI_ANY_ID, PCI_ANY_ID, 0, 0, 13},
 	{ PCI_VENDOR_ID_NETCELL,PCI_DEVICE_ID_REVOLUTION,          PCI_ANY_ID, PCI_ANY_ID, 0, 0, 14},
-	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB361,	   PCI_ANY_ID, PCI_ANY_ID, 0, 0, 15},
-	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB363,	   PCI_ANY_ID, PCI_ANY_ID, 0, 0, 16},
-	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB365,	   PCI_ANY_ID, PCI_ANY_ID, 0, 0, 17},
-	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB366,	   PCI_ANY_ID, PCI_ANY_ID, 0, 0, 18},
-	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB368,	   PCI_ANY_ID, PCI_ANY_ID, 0, 0, 19},
 	/* Must come last. If you add entries adjust this table appropriately and the init_one code */
 	{ PCI_ANY_ID,		PCI_ANY_ID,			   PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_STORAGE_IDE << 8, 0xFFFFFF00UL, 0},
 	{ 0, },
_

Patches currently in -mm which might be from alan@lxorgukCox are

libata-sff-dont-try-and-activate-channels-which-are-not.patch
ide-generic-jmicron-has-its-own-drivers-now.patch
