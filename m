From: akpm@osdl.org
Subject: + jmicron-40-80pin-primary-detection.patch added to -mm tree
Date: Tue, 30 Jan 2007 10:18:45 -0800
Message-ID: <200701301818.l0UIIjMJ024886@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41421 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965678AbXA3SVP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 13:21:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ethanhsiao@jmicron.com, alan@lxorguk.ukuu.org.uk, bzolnier@gmail.com, jeff@garzik.org, sshtylyov@ru.mvista.com


The patch titled
     jmicron: 40/80pin primary detection
has been added to the -mm tree.  Its filename is
     jmicron-40-80pin-primary-detection.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: jmicron: 40/80pin primary detection
From: <ethanhsiao@jmicron.com>

jmicron module detects all JMB36x as JMB361 and PATA0 has wrong pin status
of XICBLID.

Cc: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ide/pci/jmicron.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/ide/pci/jmicron.c~jmicron-40-80pin-primary-detection drivers/ide/pci/jmicron.c
--- a/drivers/ide/pci/jmicron.c~jmicron-40-80pin-primary-detection
+++ a/drivers/ide/pci/jmicron.c
@@ -86,8 +86,8 @@ static int __devinit ata66_jmicron(ide_h
 	{
 	case PORT_PATA0:
 		if (control & (1 << 3))	/* 40/80 pin primary */
-			return 1;
-		return 0;
+			return 0;
+		return 1;
 	case PORT_PATA1:
 		if (control5 & (1 << 19))	/* 40/80 pin secondary */
 			return 0;
@@ -240,11 +240,11 @@ static int __devinit jmicron_init_one(st
 }
 
 static struct pci_device_id jmicron_pci_tbl[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB361), 0},
-	{ PCI_DEVICE(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB363), 1},
-	{ PCI_DEVICE(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB365), 2},
-	{ PCI_DEVICE(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB366), 3},
-	{ PCI_DEVICE(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB368), 4},
+	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB361, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB363, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1},
+	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB365, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 2},
+	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB366, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 3},
+	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB368, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 4},
 	{ 0, },
 };
 
_

Patches currently in -mm which might be from ethanhsiao@jmicron.com are

jmicron-40-80pin-primary-detection.patch
