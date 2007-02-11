From: akpm@linux-foundation.org
Subject: - char-moxa-use-pci_device.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:52:31 -0800
Message-ID: <200702112252.l1BMqVnC016023@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60267 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932809AbXBKWwd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:52:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: moxa, use PCI_DEVICE
has been removed from the -mm tree.  Its filename was
     char-moxa-use-pci_device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: moxa, use PCI_DEVICE
From: Jiri Slaby <jirislaby@gmail.com>

Use PCI_DEVICE macro in pci_device_id list.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/char/moxa.c~char-moxa-use-pci_device drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-use-pci_device
+++ a/drivers/char/moxa.c
@@ -83,12 +83,12 @@ static char *moxa_brdname[] =
 
 #ifdef CONFIG_PCI
 static struct pci_device_id moxa_pcibrds[] = {
-	{ PCI_VENDOR_ID_MOXA, PCI_DEVICE_ID_MOXA_C218, PCI_ANY_ID, PCI_ANY_ID,
-	  0, 0, MOXA_BOARD_C218_PCI },
-	{ PCI_VENDOR_ID_MOXA, PCI_DEVICE_ID_MOXA_C320, PCI_ANY_ID, PCI_ANY_ID,
-	  0, 0, MOXA_BOARD_C320_PCI },
-	{ PCI_VENDOR_ID_MOXA, PCI_DEVICE_ID_MOXA_CP204J, PCI_ANY_ID, PCI_ANY_ID,
-	  0, 0, MOXA_BOARD_CP204J },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MOXA, PCI_DEVICE_ID_MOXA_C218),
+		.driver_data = MOXA_BOARD_C218_PCI },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MOXA, PCI_DEVICE_ID_MOXA_C320),
+		.driver_data = MOXA_BOARD_C320_PCI },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MOXA, PCI_DEVICE_ID_MOXA_CP204J),
+		.driver_data = MOXA_BOARD_CP204J },
 	{ 0 }
 };
 MODULE_DEVICE_TABLE(pci, moxa_pcibrds);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
char-use-more-pci_device-macro.patch
char-cyclades-use-pci_device_id.patch
maintainers-remove-two-dead-e-mail.patch
char-specialix-isr-have-2-params.patch
char-timers-cleanup.patch
fbdev-driver-for-s3-trio-virge-update-2-fix.patch
video-fb-add-true-ref_count-atomicity.patch
video-fb-kzalloc-changes.patch
shrink_slab-handle-bad-shrinkers.patch
