From: akpm@linux-foundation.org
Subject: + pata_amd-pata_via-de-couple-programming-of-pio-mwdma-and-udma-timings.patch added to -mm tree
Date: Mon, 12 Nov 2007 17:12:47 -0800
Message-ID: <200711130112.lAD1Clj8019359@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60999 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755262AbXKMBNm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 20:13:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk, htejun@gmail.com, jeff@garzik.org, thomas.lindroth@gmail.com


The patch titled
     pata_amd/pata_via: de-couple programming of PIO/MWDMA and UDMA timings
has been added to the -mm tree.  Its filename is
     pata_amd-pata_via-de-couple-programming-of-pio-mwdma-and-udma-timings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pata_amd/pata_via: de-couple programming of PIO/MWDMA and UDMA timings
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

* Don't program UDMA timings when programming PIO or MWDMA modes.

  This has also a nice side-effect of fixing regression added by commit
  681c80b5d96076f447e8101ac4325c82d8dce508 ("libata: correct handling of
  SRST reset sequences") (->set_piomode method for PIO0 is called before
  ->cable_detect method which checks UDMA timings to get the cable type).

* Bump driver version.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: "Thomas Lindroth" <thomas.lindroth@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_amd.c |    5 +++--
 drivers/ata/pata_via.c |    4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/ata/pata_amd.c~pata_amd-pata_via-de-couple-programming-of-pio-mwdma-and-udma-timings drivers/ata/pata_amd.c
--- a/drivers/ata/pata_amd.c~pata_amd-pata_via-de-couple-programming-of-pio-mwdma-and-udma-timings
+++ a/drivers/ata/pata_amd.c
@@ -25,7 +25,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_amd"
-#define DRV_VERSION "0.3.9"
+#define DRV_VERSION "0.3.10"
 
 /**
  *	timing_setup		-	shared timing computation and load
@@ -115,7 +115,8 @@ static void timing_setup(struct ata_port
 	}
 
 	/* UDMA timing */
-	pci_write_config_byte(pdev, offset + 0x10 + (3 - dn), t);
+	if (at.udma)
+		pci_write_config_byte(pdev, offset + 0x10 + (3 - dn), t);
 }
 
 /**
diff -puN drivers/ata/pata_via.c~pata_amd-pata_via-de-couple-programming-of-pio-mwdma-and-udma-timings drivers/ata/pata_via.c
--- a/drivers/ata/pata_via.c~pata_amd-pata_via-de-couple-programming-of-pio-mwdma-and-udma-timings
+++ a/drivers/ata/pata_via.c
@@ -63,7 +63,7 @@
 #include <linux/dmi.h>
 
 #define DRV_NAME "pata_via"
-#define DRV_VERSION "0.3.2"
+#define DRV_VERSION "0.3.3"
 
 /*
  *	The following comes directly from Vojtech Pavlik's ide/pci/via82cxxx
@@ -297,7 +297,7 @@ static void via_do_set_mode(struct ata_p
 	}
 
 	/* Set UDMA unless device is not UDMA capable */
-	if (udma_type) {
+	if (udma_type && t.udma) {
 		u8 cable80_status;
 
 		/* Get 80-wire cable detection bit */
_

Patches currently in -mm which might be from bzolnier@gmail.com are

pata_amd-pata_via-de-couple-programming-of-pio-mwdma-and-udma-timings.patch
ide-arm-hack.patch
ide-add-helper-__ide_setup_pci_device.patch
blk_dev_idecd-help-remove-outdated-note.patch
cleanup-after-apus-removal.patch
