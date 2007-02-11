From: akpm@linux-foundation.org
Subject: - char-moxa-pci-probing.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:52:47 -0800
Message-ID: <200702112252.l1BMqlIC016053@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60297 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932786AbXBKWwt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:52:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: moxa, pci probing
has been removed from the -mm tree.  Its filename was
     char-moxa-pci-probing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: moxa, pci probing
From: Jiri Slaby <jirislaby@gmail.com>

Alter the driver to use the pci probing.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |   40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

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
