From: akpm@linux-foundation.org
Subject: - char-cyclades-use-pci_device_id.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:43:14 -0800
Message-ID: <200702122243.l1CMhEfU013483@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44817 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030233AbXBLWnQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:43:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: cyclades, use pci_device_id
has been removed from the -mm tree.  Its filename was
     char-cyclades-use-pci_device_id.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: cyclades, use pci_device_id
From: Jiri Slaby <jirislaby@gmail.com>

Use pci_device_id struct instead of ushort array. Add MODULE_DEVICE_TABLE.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-use-pci_device_id drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-use-pci_device_id
+++ a/drivers/char/cyclades.c
@@ -829,17 +829,18 @@ static unsigned short cy_pci_nboard;
 static unsigned short cy_isa_nboard;
 static unsigned short cy_nboard;
 #ifdef CONFIG_PCI
-static unsigned short cy_pci_dev_id[] = {
-	PCI_DEVICE_ID_CYCLOM_Y_Lo,	/* PCI < 1Mb */
-	PCI_DEVICE_ID_CYCLOM_Y_Hi,	/* PCI > 1Mb */
-	PCI_DEVICE_ID_CYCLOM_4Y_Lo,	/* 4Y PCI < 1Mb */
-	PCI_DEVICE_ID_CYCLOM_4Y_Hi,	/* 4Y PCI > 1Mb */
-	PCI_DEVICE_ID_CYCLOM_8Y_Lo,	/* 8Y PCI < 1Mb */
-	PCI_DEVICE_ID_CYCLOM_8Y_Hi,	/* 8Y PCI > 1Mb */
-	PCI_DEVICE_ID_CYCLOM_Z_Lo,	/* Z PCI < 1Mb */
-	PCI_DEVICE_ID_CYCLOM_Z_Hi,	/* Z PCI > 1Mb */
-	0			/* end of table */
+static struct pci_device_id cy_pci_dev_id[] __devinitdata = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_CYCLADES, PCI_DEVICE_ID_CYCLOM_Y_Lo) },	/* PCI < 1Mb */
+	{ PCI_DEVICE(PCI_VENDOR_ID_CYCLADES, PCI_DEVICE_ID_CYCLOM_Y_Hi) },	/* PCI > 1Mb */
+	{ PCI_DEVICE(PCI_VENDOR_ID_CYCLADES, PCI_DEVICE_ID_CYCLOM_4Y_Lo) },	/* 4Y PCI < 1Mb */
+	{ PCI_DEVICE(PCI_VENDOR_ID_CYCLADES, PCI_DEVICE_ID_CYCLOM_4Y_Hi) },	/* 4Y PCI > 1Mb */
+	{ PCI_DEVICE(PCI_VENDOR_ID_CYCLADES, PCI_DEVICE_ID_CYCLOM_8Y_Lo) },	/* 8Y PCI < 1Mb */
+	{ PCI_DEVICE(PCI_VENDOR_ID_CYCLADES, PCI_DEVICE_ID_CYCLOM_8Y_Hi) },	/* 8Y PCI > 1Mb */
+	{ PCI_DEVICE(PCI_VENDOR_ID_CYCLADES, PCI_DEVICE_ID_CYCLOM_Z_Lo) },	/* Z PCI < 1Mb */
+	{ PCI_DEVICE(PCI_VENDOR_ID_CYCLADES, PCI_DEVICE_ID_CYCLOM_Z_Hi) },	/* Z PCI > 1Mb */
+	{ }			/* end of table */
 };
+MODULE_DEVICE_TABLE(pci, cy_pci_dev_id);
 #endif
 
 static void cy_start(struct tty_struct *);
@@ -4758,7 +4759,7 @@ static int __init cy_detect_pci(void)
 
 	for (i = 0; i < NR_CARDS; i++) {
 		/* look for a Cyclades card by vendor and device id */
-		while ((device_id = cy_pci_dev_id[dev_index]) != 0) {
+		while ((device_id = cy_pci_dev_id[dev_index].device) != 0) {
 			if ((pdev = pci_get_device(PCI_VENDOR_ID_CYCLADES,
 						   device_id, pdev)) == NULL) {
 				dev_index++;	/* try next device id */
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-watchdog.patch
shrink_slab-handle-bad-shrinkers.patch
