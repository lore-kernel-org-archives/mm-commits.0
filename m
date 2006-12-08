From: akpm@osdl.org
Subject: - char-sx-remove-duplicite-code.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:09:16 -0800
Message-ID: <200612082009.kB8K9GKk002683@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58540 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946134AbWLHUJV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:09:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: sx, remove duplicite code
has been removed from the -mm tree.  Its filename was
     char-sx-remove-duplicite-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: sx, remove duplicite code
From: Jiri Slaby <jirislaby@gmail.com>

sx_remove_code contents were used twice.  Call this function instead.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/sx.c |   20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff -puN drivers/char/sx.c~char-sx-remove-duplicite-code drivers/char/sx.c
--- a/drivers/char/sx.c~char-sx-remove-duplicite-code
+++ a/drivers/char/sx.c
@@ -2680,28 +2680,16 @@ static int __init sx_init(void) 
 static void __exit sx_exit (void)
 {
 	int i; 
-	struct sx_board *board;
 
 	func_enter();
 #ifdef CONFIG_EISA
 	eisa_driver_unregister(&sx_eisadriver);
 #endif
 	pci_unregister_driver(&sx_pcidriver);
-	for (i = 0; i < SX_NBOARDS; i++) {
-		board = &boards[i];
-		if (board->flags & SX_BOARD_INITIALIZED) {
-			sx_dprintk (SX_DEBUG_CLEANUP, "Cleaning up board at %p\n", board->base);
-			/* The board should stop messing with us.
-			   (actually I mean the interrupt) */
-			sx_reset (board);
-			if ((board->irq) && (board->flags & SX_IRQ_ALLOCATED))
-				free_irq (board->irq, board);
-
-			/* It is safe/allowed to del_timer a non-active timer */
-			del_timer (& board->timer);
-			iounmap(board->base);
-		}
-	}
+
+	for (i = 0; i < SX_NBOARDS; i++)
+		sx_remove_card(&boards[i]);
+
 	if (misc_deregister(&sx_fw_device) < 0) {
 		printk (KERN_INFO "sx: couldn't deregister firmware loader device\n");
 	}
_

Patches currently in -mm which might be from jirislaby@gmail.com are

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

