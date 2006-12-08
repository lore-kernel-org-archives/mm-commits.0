From: akpm@osdl.org
Subject: - char-sx-use-pci_iomap.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:09:28 -0800
Message-ID: <200612082009.kB8K9S4T002707@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58600 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946254AbWLHUJd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:09:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: sx, use pci_iomap
has been removed from the -mm tree.  Its filename was
     char-sx-use-pci_iomap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: sx, use pci_iomap
From: Jiri Slaby <jirislaby@gmail.com>

Use pci_ friends for memory remapping of pci devices.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/sx.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff -puN drivers/char/sx.c~char-sx-use-pci_iomap drivers/char/sx.c
--- a/drivers/char/sx.c~char-sx-use-pci_iomap
+++ a/drivers/char/sx.c
@@ -2485,7 +2485,8 @@ static void __exit sx_release_drivers(vo
 	func_exit();
 }
 
-static void __devexit sx_remove_card(struct sx_board *board)
+static void __devexit sx_remove_card(struct sx_board *board,
+		struct pci_dev *pdev)
 {
 	if (board->flags & SX_BOARD_INITIALIZED) {
 		/* The board should stop messing with us. (actually I mean the
@@ -2496,7 +2497,10 @@ static void __devexit sx_remove_card(str
 
 		/* It is safe/allowed to del_timer a non-active timer */
 		del_timer(&board->timer);
-		iounmap(board->base);
+		if (pdev)
+			pci_iounmap(pdev, board->base);
+		else
+			iounmap(board->base);
 
 		board->flags &= ~(SX_BOARD_INITIALIZED | SX_BOARD_PRESENT);
 	}
@@ -2559,7 +2563,7 @@ static int __devexit sx_eisa_remove(stru
 {
 	struct sx_board *board = dev_get_drvdata(dev);
 
-	sx_remove_card(board);
+	sx_remove_card(board, NULL);
 
 	return 0;
 }
@@ -2618,7 +2622,7 @@ static int __devinit sx_pci_probe(struct
 				  const struct pci_device_id *ent)
 {
 	struct sx_board *board;
-	unsigned int i;
+	unsigned int i, reg;
 	int retval = -EIO;
 
 	mutex_lock(&sx_boards_lock);
@@ -2640,12 +2644,10 @@ static int __devinit sx_pci_probe(struct
 		SX_CFPCI_BOARD;
 
 	/* CF boards use base address 3.... */
-	if (IS_CF_BOARD(board))
-		board->hw_base = pci_resource_start(pdev, 3);
-	else
-		board->hw_base = pci_resource_start(pdev, 2);
+	reg = IS_CF_BOARD(board) ? 3 : 2;
+	board->hw_base = pci_resource_start(pdev, reg);
 	board->base2 =
-	board->base = ioremap(board->hw_base, WINDOW_LEN(board));
+	board->base = pci_iomap(pdev, reg, WINDOW_LEN(board));
 	if (!board->base) {
 		dev_err(&pdev->dev, "ioremap failed\n");
 		goto err_flag;
@@ -2671,7 +2673,7 @@ static int __devinit sx_pci_probe(struct
 
 	return 0;
 err_unmap:
-	iounmap(board->base2);
+	pci_iounmap(pdev, board->base);
 err_flag:
 	board->flags &= ~SX_BOARD_PRESENT;
 err:
@@ -2682,7 +2684,7 @@ static void __devexit sx_pci_remove(stru
 {
 	struct sx_board *board = pci_get_drvdata(pdev);
 
-	sx_remove_card(board);
+	sx_remove_card(board, pdev);
 }
 
 /* Specialix has a whole bunch of cards with 0x2000 as the device ID. They say
@@ -2812,7 +2814,7 @@ static void __exit sx_exit(void)
 	pci_unregister_driver(&sx_pcidriver);
 
 	for (i = 0; i < SX_NBOARDS; i++)
-		sx_remove_card(&boards[i]);
+		sx_remove_card(&boards[i], NULL);
 
 	if (misc_deregister(&sx_fw_device) < 0) {
 		printk(KERN_INFO "sx: couldn't deregister firmware loader "
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-sx-use-pci_iomap.patch
char-sx-request-regions.patch
char-stallion-convert-to-pci-probing.patch
char-stallion-prints-cleanup.patch
char-stallion-implement-fail-paths.patch
char-stallion-correct-__init-macros.patch
char-stallion-functions-cleanup.patch
char-stallion-fix-fail-paths.patch
char-stallion-brd-struct-locking.patch
char-stallion-remove-syntactic-sugar.patch
char-stallion-variables-cleanup.patch
char-stallion-use-dynamic-dev.patch
char-istallion-convert-to-pci-probing.patch
char-istallion-remove-the-mess.patch
char-istallion-eliminate-typedefs.patch
char-istallion-variables-cleanup.patch
char-istallion-ifdef-eisa-code.patch
char-istallion-brdnr-locking.patch
char-istallion-free-only-isa.patch
char-istallion-correct-fail-paths.patch
char-istallion-fix-enabling.patch
char-istallion-move-init-and-exit-code.patch
char-istallion-change-init-sequence.patch
char-istallion-dynamic-tty-device.patch
char-istallion-use-mod_timer.patch
char-cyclades-save-indent-levels.patch
char-cyclades-lindent-the-code.patch
char-cyclades-cleanup.patch
char-cyclades-fix-warnings.patch

