From: akpm@osdl.org
Subject: - char-sx-lock-boards-struct.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:09:14 -0800
Message-ID: <200612082009.kB8K9EDq002679@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58519 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946223AbWLHUJT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:09:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: sx, lock boards struct
has been removed from the -mm tree.  Its filename was
     char-sx-lock-boards-struct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: sx, lock boards struct
From: Jiri Slaby <jirislaby@gmail.com>

Fix race condition which may occurs when multiple cards are probed at the same
time.  Add mutex to critical sections to avoid this situation.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/sx.c |   37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff -puN drivers/char/sx.c~char-sx-lock-boards-struct drivers/char/sx.c
--- a/drivers/char/sx.c~char-sx-lock-boards-struct
+++ a/drivers/char/sx.c
@@ -298,6 +298,7 @@ static int sx_init_drivers(void);
 
 static struct tty_driver *sx_driver;
 
+static DEFINE_MUTEX(sx_boards_lock);
 static struct sx_board boards[SX_NBOARDS];
 static struct sx_port *sx_ports;
 static int sx_initialized;
@@ -1980,7 +1981,6 @@ static int sx_init_board (struct sx_boar
 	}
 
 	if (chans) {
-		/* board->flags |= SX_BOARD_PRESENT; */
 		if(board->irq > 0) {
 			/* fixed irq, probably PCI */
 			if(sx_irqmask & (1 << board->irq)) { /* may we use this irq? */
@@ -2115,8 +2115,6 @@ static int __devinit probe_sx (struct sx
 		return 0;
 	sx_dprintk (SX_DEBUG_INIT, "reset the board...\n");
 
-	board->flags |= SX_BOARD_PRESENT;
-
 	func_exit();
 	return 1;
 }
@@ -2211,8 +2209,6 @@ static int __devinit probe_si (struct sx
 		return 0;
 	sx_dprintk (SX_DEBUG_INIT, "reset the board...\n");
 
-	board->flags |= SX_BOARD_PRESENT;
-
 	func_exit();
 	return 1;
 }
@@ -2396,10 +2392,15 @@ static int __devinit sx_eisa_probe(struc
 	unsigned int i;
 	int retval = -EIO;
 
+	mutex_lock(&sx_boards_lock);
 	i = sx_find_free_board();
-
-	if (i == SX_NBOARDS)
+	if (i == SX_NBOARDS) {
+		mutex_unlock(&sx_boards_lock);
 		goto err;
+	}
+	board = &boards[i];
+	board->flags |= SX_BOARD_PRESENT;
+	mutex_unlock(&sx_boards_lock);
 
 	dev_info(dev, "XIO : Signature found in EISA slot %lu, "
 			"Product %d Rev %d (REPORT THIS TO LKLM)\n",
@@ -2407,7 +2408,6 @@ static int __devinit sx_eisa_probe(struc
 			inb(eisa_slot + EISA_VENDOR_ID_OFFSET + 2),
 			inb(eisa_slot + EISA_VENDOR_ID_OFFSET + 3));
 
-	board = &boards[i];
 	board->eisa_base = eisa_slot;
 	board->flags &= ~SX_BOARD_TYPE;
 	board->flags |= SI_EISA_BOARD;
@@ -2430,6 +2430,7 @@ static int __devinit sx_eisa_probe(struc
 	return 0;
 err_unmap:
 	iounmap(board->base);
+	board->flags &= ~SX_BOARD_PRESENT;
 err:
 	return retval;
 }
@@ -2498,16 +2499,19 @@ static int __devinit sx_pci_probe(struct
 	unsigned int i;
 	int retval = -EIO;
 
+	mutex_lock(&sx_boards_lock);
 	i = sx_find_free_board();
-
-	if (i == SX_NBOARDS)
+	if (i == SX_NBOARDS) {
+		mutex_unlock(&sx_boards_lock);
 		goto err;
+	}
+	board = &boards[i];
+	board->flags |= SX_BOARD_PRESENT;
+	mutex_unlock(&sx_boards_lock);
 
 	retval = pci_enable_device(pdev);
 	if (retval)
-		goto err;
-
-	board = &boards[i];
+		goto err_flag;
 
 	board->flags &= ~SX_BOARD_TYPE;
 	board->flags |= (pdev->subsystem_vendor == 0x200) ? SX_PCI_BOARD :
@@ -2522,7 +2526,7 @@ static int __devinit sx_pci_probe(struct
 	board->base = ioremap(board->hw_base, WINDOW_LEN (board));
 	if (!board->base) {
 		dev_err(&pdev->dev, "ioremap failed\n");
-		goto err;
+		goto err_flag;
 	}
 
 	/* Most of the stuff on the CF board is offset by 0x18000 ....  */
@@ -2546,6 +2550,8 @@ static int __devinit sx_pci_probe(struct
 	return 0;
 err_unmap:
 	iounmap(board->base2);
+err_flag:
+	board->flags &= ~SX_BOARD_PRESENT;
 err:
 	return retval;
 }
@@ -2611,6 +2617,7 @@ static int __init sx_init(void) 
 		board->irq = sx_irqmask?-1:0;
 
 		if (probe_sx (board)) {
+			board->flags |= SX_BOARD_PRESENT;
 			found++;
 		} else {
 			iounmap(board->base);
@@ -2627,6 +2634,7 @@ static int __init sx_init(void) 
 		board->irq = sx_irqmask ?-1:0;
 
 		if (probe_si (board)) {
+			board->flags |= SX_BOARD_PRESENT;
 			found++;
 		} else {
 			iounmap (board->base);
@@ -2642,6 +2650,7 @@ static int __init sx_init(void) 
 		board->irq = sx_irqmask ?-1:0;
 
 		if (probe_si (board)) {
+			board->flags |= SX_BOARD_PRESENT;
 			found++;
 		} else {
 			iounmap (board->base);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-sx-lock-boards-struct.patch
char-sx-remove-duplicite-code.patch
char-sx-whitespace-cleanup.patch
char-sx-simplify-timer-logic.patch
char-sx-fix-return-in-module-init.patch
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

