From: akpm@linux-foundation.org
Subject: + pata_artop-fix-udma5-for-aec6280-and-udma6-for-aec6880.patch added to -mm tree
Date: Tue, 14 Aug 2007 12:35:29 -0700
Message-ID: <200708141935.l7EJZTQP017520@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52731 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753763AbXHNTgK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:36:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk, jeff@garzik.org


The patch titled
     pata_artop: fix UDMA5 for AEC6280[R] and UDMA6 for AEC6880[R]
has been added to the -mm tree.  Its filename is
     pata_artop-fix-udma5-for-aec6280-and-udma6-for-aec6880.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pata_artop: fix UDMA5 for AEC6280[R] and UDMA6 for AEC6880[R]
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Maximum supported UDMA mode for AEC6280[R] is UDMA5 (not UDMA4)
and for AEC6880[R] it is UDMA6 (not UDMA5):

* Fix the problem by adding missing struct ata_port_info to artop_init_one().

* Use the right naming (s/626/628/).

* Bump driver version.

Fixes IDE->libata regression, problem was never present in IDE aec62xx
driver.

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_artop.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff -puN drivers/ata/pata_artop.c~pata_artop-fix-udma5-for-aec6280-and-udma6-for-aec6880 drivers/ata/pata_artop.c
--- a/drivers/ata/pata_artop.c~pata_artop-fix-udma5-for-aec6280-and-udma6-for-aec6880
+++ a/drivers/ata/pata_artop.c
@@ -2,6 +2,7 @@
  *    pata_artop.c - ARTOP ATA controller driver
  *
  *	(C) 2006 Red Hat <alan@redhat.com>
+ *	(C) 2007 Bartlomiej Zolnierkiewicz
  *
  *    Based in part on drivers/ide/pci/aec62xx.c
  *	Copyright (C) 1999-2002	Andre Hedrick <andre@linux-ide.org>
@@ -28,7 +29,7 @@
 #include <linux/ata.h>
 
 #define DRV_NAME	"pata_artop"
-#define DRV_VERSION	"0.4.3"
+#define DRV_VERSION	"0.4.4"
 
 /*
  *	The ARTOP has 33 Mhz and "over clocked" timing tables. Until we
@@ -430,7 +431,7 @@ static int artop_init_one (struct pci_de
 		.udma_mask 	= ATA_UDMA4,
 		.port_ops	= &artop6260_ops,
 	};
-	static const struct ata_port_info info_626x_fast = {
+	static const struct ata_port_info info_628x = {
 		.sht		= &artop_sht,
 		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= 0x1f,	/* pio0-4 */
@@ -438,6 +439,14 @@ static int artop_init_one (struct pci_de
 		.udma_mask 	= ATA_UDMA5,
 		.port_ops	= &artop6260_ops,
 	};
+	static const struct ata_port_info info_628x_fast = {
+		.sht		= &artop_sht,
+		.flags		= ATA_FLAG_SLAVE_POSS,
+		.pio_mask	= 0x1f,	/* pio0-4 */
+		.mwdma_mask	= 0x07, /* mwdma0-2 */
+		.udma_mask 	= ATA_UDMA6,
+		.port_ops	= &artop6260_ops,
+	};
 	const struct ata_port_info *ppi[] = { NULL, NULL };
 
 	if (!printed_version++)
@@ -455,13 +464,13 @@ static int artop_init_one (struct pci_de
 	}
 	else if (id->driver_data == 1)	/* 6260 */
 		ppi[0] = &info_626x;
-	else if (id->driver_data == 2)	{ /* 6260 or 6260 + fast */
+	else if (id->driver_data == 2)	{ /* 6280 or 6280 + fast */
 		unsigned long io = pci_resource_start(pdev, 4);
 		u8 reg;
 
-		ppi[0] = &info_626x;
+		ppi[0] = &info_628x;
 		if (inb(io) & 0x10)
-			ppi[0] = &info_626x_fast;
+			ppi[0] = &info_628x_fast;
 		/* Mac systems come up with some registers not set as we
 		   will need them */
 
_

Patches currently in -mm which might be from bzolnier@gmail.com are

pata_artop-fix-udma5-for-aec6280-and-udma6-for-aec6880.patch
ide-arm-hack.patch
pci-align-bar-settings-for-legacy-mode-ide.patch
