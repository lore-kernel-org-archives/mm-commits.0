From: akpm@osdl.org
Subject: + char-moxa-use-pci_device.patch added to -mm tree
Date: Tue, 02 Jan 2007 13:53:09 -0800
Message-ID: <200701022153.l02Lr9ro031021@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35925 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754982AbXABVxT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 16:53:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: moxa, use PCI_DEVICE
has been added to the -mm tree.  Its filename is
     char-moxa-use-pci_device.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: moxa, use PCI_DEVICE
From: Jiri Slaby <jirislaby@gmail.com>

Use PCI_DEVICE macro in pci_device_id list.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/moxa.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

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
