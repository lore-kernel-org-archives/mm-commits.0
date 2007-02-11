From: akpm@linux-foundation.org
Subject: - char-moxa-remove-moxa_pci_devinfo.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:52:39 -0800
Message-ID: <200702112252.l1BMqd6l016037@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60282 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932823AbXBKWwm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:52:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: moxa, remove moxa_pci_devinfo
has been removed from the -mm tree.  Its filename was
     char-moxa-remove-moxa_pci_devinfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: moxa, remove moxa_pci_devinfo
From: Jiri Slaby <jirislaby@gmail.com>

Nothing is used from this struct but *pdev. Remove it and store only pdev.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

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
