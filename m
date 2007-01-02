From: akpm@osdl.org
Subject: + char-moxa-devids-cleanup.patch added to -mm tree
Date: Tue, 02 Jan 2007 13:53:05 -0800
Message-ID: <200701022153.l02Lr78k031018@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35917 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754984AbXABVxO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 16:53:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: moxa, devids cleanup
has been added to the -mm tree.  Its filename is
     char-moxa-devids-cleanup.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: moxa, devids cleanup
From: Jiri Slaby <jirislaby@gmail.com>

Move them to pci_ids.h

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
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
@@ -1809,6 +1809,9 @@
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

git-input.patch
char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch
char-isicom-remove-tty_hangwakeup-bottomhalves.patch
mxser-remove-ambiguous-redefinition-of-init_work.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
char-isicom-fix-locking-in-isr.patch
char-isicom-augment-card_reset.patch
char-isicom-check-card-state-in-isr.patch
char-isicom-support-higher-rates.patch
char-isicom-correct-probing-removing.patch
char-tty_wakeup-cleanup.patch
char-mxser_new-mark-init-functions.patch
char-mxser_new-remove-useless-spinlock.patch
char-serial167-cleanup.patch
char-n_r3964-cleanup.patch
char-mxser_new-remove-unused-stuff.patch
char-mxser-obsolete-old-nonexperimental-new.patch
char-mxser_new-remove-tty_wakeup-bottomhalf.patch
char-mxser_new-clean-request_irq-call.patch
doc-isicom-remove-reserved-ioctl-number.patch
char-mxser_new-alter-locking-in-isr.patch
char-mxser_new-header-file-cleanup.patch
char-mxser_new-less-loops-in-isr.patch
char-mxser_new-fix-twice-resource-releasing.patch
char-mxser_new-do-not-put-pdev.patch
char-moxa-remove-unused-allocated-page.patch
char-moxa-do-not-initialize-global-static.patch
char-moxa-timers-cleanup.patch
char-moxa-remove-hangup-bottomhalf.patch
char-moxa-remove-unused-functions.patch
char-moxa-devids-cleanup.patch
char-moxa-use-pci_device.patch
char-moxa-eliminate-typedefs.patch
shrink_slab-handle-bad-shrinkers.patch
