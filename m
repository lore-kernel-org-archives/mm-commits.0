From: akpm@linux-foundation.org
Subject: - char-moxa-devids-cleanup.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:52:29 -0800
Message-ID: <200702112252.l1BMqTnD016020@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60264 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932808AbXBKWwb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:52:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: moxa, devids cleanup
has been removed from the -mm tree.  Its filename was
     char-moxa-devids-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: moxa, devids cleanup
From: Jiri Slaby <jirislaby@gmail.com>

Move them to pci_ids.h

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c     |   19 +++----------------
 include/linux/pci_ids.h |    3 +++
 2 files changed, 6 insertions(+), 16 deletions(-)

diff -puN drivers/char/moxa.c~char-moxa-devids-cleanup drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-devids-cleanup
+++ a/drivers/char/moxa.c
@@ -64,19 +64,6 @@
 #define MOXA_BUS_TYPE_ISA		0
 #define MOXA_BUS_TYPE_PCI		1
 
-#ifndef	PCI_VENDOR_ID_MOXA
-#define	PCI_VENDOR_ID_MOXA	0x1393
-#endif
-#ifndef PCI_DEVICE_ID_CP204J
-#define PCI_DEVICE_ID_CP204J	0x2040
-#endif
-#ifndef PCI_DEVICE_ID_C218
-#define PCI_DEVICE_ID_C218	0x2180
-#endif
-#ifndef PCI_DEVICE_ID_C320
-#define PCI_DEVICE_ID_C320	0x3200
-#endif
-
 enum {
 	MOXA_BOARD_C218_PCI = 1,
 	MOXA_BOARD_C218_ISA,
@@ -96,11 +83,11 @@ static char *moxa_brdname[] =
 
 #ifdef CONFIG_PCI
 static struct pci_device_id moxa_pcibrds[] = {
-	{ PCI_VENDOR_ID_MOXA, PCI_DEVICE_ID_C218, PCI_ANY_ID, PCI_ANY_ID, 
+	{ PCI_VENDOR_ID_MOXA, PCI_DEVICE_ID_MOXA_C218, PCI_ANY_ID, PCI_ANY_ID,
 	  0, 0, MOXA_BOARD_C218_PCI },
-	{ PCI_VENDOR_ID_MOXA, PCI_DEVICE_ID_C320, PCI_ANY_ID, PCI_ANY_ID, 
+	{ PCI_VENDOR_ID_MOXA, PCI_DEVICE_ID_MOXA_C320, PCI_ANY_ID, PCI_ANY_ID,
 	  0, 0, MOXA_BOARD_C320_PCI },
-	{ PCI_VENDOR_ID_MOXA, PCI_DEVICE_ID_CP204J, PCI_ANY_ID, PCI_ANY_ID, 
+	{ PCI_VENDOR_ID_MOXA, PCI_DEVICE_ID_MOXA_CP204J, PCI_ANY_ID, PCI_ANY_ID,
 	  0, 0, MOXA_BOARD_CP204J },
 	{ 0 }
 };
diff -puN include/linux/pci_ids.h~char-moxa-devids-cleanup include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~char-moxa-devids-cleanup
+++ a/include/linux/pci_ids.h
@@ -1811,6 +1811,9 @@
 #define PCI_DEVICE_ID_MOXA_C168		0x1680
 #define PCI_DEVICE_ID_MOXA_CP168U	0x1681
 #define PCI_DEVICE_ID_MOXA_CP168EL	0x1682
+#define PCI_DEVICE_ID_MOXA_CP204J	0x2040
+#define PCI_DEVICE_ID_MOXA_C218		0x2180
+#define PCI_DEVICE_ID_MOXA_C320		0x3200
 
 #define PCI_VENDOR_ID_CCD		0x1397
 #define PCI_DEVICE_ID_CCD_2BD0		0x2bd0
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
