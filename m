From: akpm@osdl.org
Subject: + char-moxa-remove-moxa_pci_devinfo.patch added to -mm tree
Date: Fri, 05 Jan 2007 12:09:52 -0800
Message-ID: <200701052009.l05K9qtX030999@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56854 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbXAEUJy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 5 Jan 2007 15:09:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: moxa, remove moxa_pci_devinfo
has been added to the -mm tree.  Its filename is
     char-moxa-remove-moxa_pci_devinfo.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: moxa, remove moxa_pci_devinfo
From: Jiri Slaby <jirislaby@gmail.com>

Nothing is used from this struct but *pdev. Remove it and store only pdev.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/moxa.c |   15 +++------------
 1 files changed, 3 insertions(+), 12 deletions(-)

diff -puN drivers/char/moxa.c~char-moxa-remove-moxa_pci_devinfo drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-remove-moxa_pci_devinfo
+++ a/drivers/char/moxa.c
@@ -102,18 +102,12 @@ static struct moxa_isa_board_conf moxa_i
 /*       {MOXA_BOARD_C218_ISA,8,0xDC000}, */
 };
 
-struct moxa_pci_devinfo {
-	ushort busNum;
-	ushort devNum;
-	struct pci_dev *pdev;
-};
-
 struct moxa_board_conf {
 	int boardType;
 	int numPorts;
 	unsigned long baseAddr;
 	int busType;
-	struct moxa_pci_devinfo pciInfo;
+	struct pci_dev *pdev;
 };
 
 static struct moxa_board_conf moxa_boards[MAX_BOARDS];
@@ -284,11 +278,8 @@ static int moxa_get_PCI_conf(struct pci_
 		break;
 	}
 	board->busType = MOXA_BUS_TYPE_PCI;
-	board->pciInfo.busNum = p->bus->number;
-	board->pciInfo.devNum = p->devfn >> 3;
-	board->pciInfo.pdev = p;
 	/* don't lose the reference in the next pci_get_device iteration */
-	pci_dev_get(p);
+	board->pdev = pci_dev_get(p);
 
 	return (0);
 }
@@ -437,7 +428,7 @@ static void __exit moxa_exit(void)
 		if (moxaBaseAddr[i])
 			iounmap(moxaBaseAddr[i]);
 		if (moxa_boards[i].busType == MOXA_BUS_TYPE_PCI)
-			pci_dev_put(moxa_boards[i].pciInfo.pdev);
+			pci_dev_put(moxa_boards[i].pdev);
 	}
 
 	if (verbose)
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
char-mxser_new-upgrade-to-1915.patch
char-moxa-remove-unused-allocated-page.patch
char-moxa-do-not-initialize-global-static.patch
char-moxa-timers-cleanup.patch
char-moxa-remove-hangup-bottomhalf.patch
char-moxa-remove-unused-functions.patch
char-moxa-devids-cleanup.patch
char-moxa-use-pci_device.patch
char-moxa-eliminate-typedefs.patch
char-moxa-macros-cleanup.patch
char-moxa-use-del_timer_sync.patch
char-moxa-remove-moxa_pci_devinfo.patch
char-moxa-variables-cleanup.patch
char-moxa-remove-useless-vairables.patch
char-moxa-pci_probing-prepare.patch
char-moxa-pci-probing.patch
shrink_slab-handle-bad-shrinkers.patch
