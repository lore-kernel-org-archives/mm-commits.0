From: akpm@osdl.org
Subject: + char-moxa-pci-probing.patch added to -mm tree
Date: Fri, 05 Jan 2007 12:10:00 -0800
Message-ID: <200701052010.l05KA0k0031011@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56870 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbXAEUKD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 5 Jan 2007 15:10:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: moxa, pci probing
has been added to the -mm tree.  Its filename is
     char-moxa-pci-probing.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: moxa, pci probing
From: Jiri Slaby <jirislaby@gmail.com>

Alter the driver to use the pci probing.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/moxa.c |   40 ++++++++++++++++++++--------------------
 1 files changed, 20 insertions(+), 20 deletions(-)

diff -puN drivers/char/moxa.c~char-moxa-pci-probing drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-pci-probing
+++ a/drivers/char/moxa.c
@@ -107,7 +107,6 @@ static struct moxa_board_conf {
 	int numPorts;
 	unsigned long baseAddr;
 	int busType;
-	struct pci_dev *pdev;
 
 	int loadstat;
 
@@ -319,8 +318,7 @@ static int __devinit moxa_pci_probe(stru
 		break;
 	}
 	board->busType = MOXA_BUS_TYPE_PCI;
-	/* don't lose the reference in the next pci_get_device iteration */
-	board->pdev = pci_dev_get(pdev);
+
 	pci_set_drvdata(pdev, board);
 
 	return (0);
@@ -334,13 +332,19 @@ static void __devexit moxa_pci_remove(st
 
 	pci_iounmap(pdev, brd->basemem);
 	brd->basemem = NULL;
-	pci_dev_put(pdev);
 }
+
+static struct pci_driver moxa_pci_driver = {
+	.name = "moxa",
+	.id_table = moxa_pcibrds,
+	.probe = moxa_pci_probe,
+	.remove = __devexit_p(moxa_pci_remove)
+};
 #endif /* CONFIG_PCI */
 
 static int __init moxa_init(void)
 {
-	int i, numBoards;
+	int i, numBoards, retval = 0;
 	struct moxa_port *ch;
 
 	printk(KERN_INFO "MOXA Intellio family driver version %s\n", MOXA_VERSION);
@@ -430,25 +434,22 @@ static int __init moxa_init(void)
 		}
 	}
 #endif
-	/* Find PCI boards here */
+
 #ifdef CONFIG_PCI
-	{
-		struct pci_dev *p = NULL;
-		int n = ARRAY_SIZE(moxa_pcibrds) - 1;
-		i = 0;
-		while (i < n) {
-			while ((p = pci_get_device(moxa_pcibrds[i].vendor, moxa_pcibrds[i].device, p))!=NULL)
-				moxa_pci_probe(p, &moxa_pcibrds[i]);
-			i++;
-		}
+	retval = pci_register_driver(&moxa_pci_driver);
+	if (retval) {
+		printk(KERN_ERR "Can't register moxa pci driver!\n");
+		if (numBoards)
+			retval = 0;
 	}
 #endif
+
 	for (i = 0; i < numBoards; i++) {
 		moxa_boards[i].basemem = ioremap(moxa_boards[i].baseAddr,
 				0x4000);
 	}
 
-	return (0);
+	return retval;
 }
 
 static void __exit moxa_exit(void)
@@ -467,14 +468,13 @@ static void __exit moxa_exit(void)
 		printk("Couldn't unregister MOXA Intellio family serial driver\n");
 	put_tty_driver(moxaDriver);
 
-	for (i = 0; i < MAX_BOARDS; i++) {
 #ifdef CONFIG_PCI
-		if (moxa_boards[i].busType == MOXA_BUS_TYPE_PCI)
-			moxa_pci_remove(moxa_boards[i].pdev);
+	pci_unregister_driver(&moxa_pci_driver);
 #endif
+
+	for (i = 0; i < MAX_BOARDS; i++)
 		if (moxa_boards[i].basemem)
 			iounmap(moxa_boards[i].basemem);
-	}
 
 	if (verbose)
 		printk("Done\n");
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
