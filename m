From: akpm@osdl.org
Subject: + char-moxa-pci_probing-prepare.patch added to -mm tree
Date: Fri, 05 Jan 2007 12:09:58 -0800
Message-ID: <200701052009.l05K9wTG031008@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56865 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbXAEUKA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 5 Jan 2007 15:10:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: moxa, pci_probing prepare
has been added to the -mm tree.  Its filename is
     char-moxa-pci_probing-prepare.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: moxa, pci_probing prepare
From: Jiri Slaby <jirislaby@gmail.com>

- change pci conf prototype and rename it to moxa_pci_probe
- move some code to moxa_pci_probe
- create moxa_pci_remove

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/moxa.c |   64 ++++++++++++++++++++++++++++++------------
 1 files changed, 46 insertions(+), 18 deletions(-)

diff -puN drivers/char/moxa.c~char-moxa-pci_probing-prepare drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-pci_probing-prepare
+++ a/drivers/char/moxa.c
@@ -275,10 +275,35 @@ static DEFINE_TIMER(moxaTimer, moxa_poll
 static DEFINE_SPINLOCK(moxa_lock);
 
 #ifdef CONFIG_PCI
-static int moxa_get_PCI_conf(struct pci_dev *p, int board_type,
-		struct moxa_board_conf *board)
+static int __devinit moxa_pci_probe(struct pci_dev *pdev,
+		const struct pci_device_id *ent)
 {
-	board->baseAddr = pci_resource_start (p, 2);
+	struct moxa_board_conf *board;
+	unsigned int i;
+	int board_type = ent->driver_data;
+	int retval;
+
+	retval = pci_enable_device(pdev);
+	if (retval)
+		goto err;
+
+	for (i = 0; i < MAX_BOARDS; i++)
+		if (moxa_boards[i].basemem == NULL)
+			break;
+
+	retval = -ENODEV;
+	if (i >= MAX_BOARDS) {
+		if (verbose)
+			printk("More than %d MOXA Intellio family boards "
+				"found. Board is ignored.\n", MAX_BOARDS);
+		goto err;
+	}
+
+	board = &moxa_boards[i];
+	board->basemem = pci_iomap(pdev, 2, 0x4000);
+	if (board->basemem == NULL)
+		goto err;
+
 	board->boardType = board_type;
 	switch (board_type) {
 	case MOXA_BOARD_C218_ISA:
@@ -295,9 +320,21 @@ static int moxa_get_PCI_conf(struct pci_
 	}
 	board->busType = MOXA_BUS_TYPE_PCI;
 	/* don't lose the reference in the next pci_get_device iteration */
-	board->pdev = pci_dev_get(p);
+	board->pdev = pci_dev_get(pdev);
+	pci_set_drvdata(pdev, board);
 
 	return (0);
+err:
+	return retval;
+}
+
+static void __devexit moxa_pci_remove(struct pci_dev *pdev)
+{
+	struct moxa_board_conf *brd = pci_get_drvdata(pdev);
+
+	pci_iounmap(pdev, brd->basemem);
+	brd->basemem = NULL;
+	pci_dev_put(pdev);
 }
 #endif /* CONFIG_PCI */
 
@@ -401,18 +438,7 @@ static int __init moxa_init(void)
 		i = 0;
 		while (i < n) {
 			while ((p = pci_get_device(moxa_pcibrds[i].vendor, moxa_pcibrds[i].device, p))!=NULL)
-			{
-				if (pci_enable_device(p))
-					continue;
-				if (numBoards >= MAX_BOARDS) {
-					if (verbose)
-						printk("More than %d MOXA Intellio family boards found. Board is ignored.", MAX_BOARDS);
-				} else {
-					moxa_get_PCI_conf(p, moxa_pcibrds[i].driver_data,
-						&moxa_boards[numBoards]);
-					numBoards++;
-				}
-			}
+				moxa_pci_probe(p, &moxa_pcibrds[i]);
 			i++;
 		}
 	}
@@ -442,10 +468,12 @@ static void __exit moxa_exit(void)
 	put_tty_driver(moxaDriver);
 
 	for (i = 0; i < MAX_BOARDS; i++) {
+#ifdef CONFIG_PCI
+		if (moxa_boards[i].busType == MOXA_BUS_TYPE_PCI)
+			moxa_pci_remove(moxa_boards[i].pdev);
+#endif
 		if (moxa_boards[i].basemem)
 			iounmap(moxa_boards[i].basemem);
-		if (moxa_boards[i].busType == MOXA_BUS_TYPE_PCI)
-			pci_dev_put(moxa_boards[i].pdev);
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
