From: akpm@osdl.org
Subject: - char-sx-simplify-timer-logic.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:09:22 -0800
Message-ID: <200612082009.kB8K9M4W002696@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58564 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946221AbWLHUJ0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:09:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: sx, simplify timer logic
has been removed from the -mm tree.  Its filename was
     char-sx-simplify-timer-logic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: sx, simplify timer logic
From: Jiri Slaby <jirislaby@gmail.com>

Use kernel helpers for changing timer internals.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/sx.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff -puN drivers/char/sx.c~char-sx-simplify-timer-logic drivers/char/sx.c
--- a/drivers/char/sx.c~char-sx-simplify-timer-logic
+++ a/drivers/char/sx.c
@@ -1353,10 +1353,7 @@ static void sx_pollfunc(unsigned long da
 
 	sx_interrupt(0, board);
 
-	init_timer(&board->timer);
-
-	board->timer.expires = jiffies + sx_poll;
-	add_timer(&board->timer);
+	mod_timer(&board->timer, jiffies + sx_poll);
 	func_exit();
 }
 
@@ -2134,14 +2131,10 @@ static int sx_init_board(struct sx_board
 
 		/* The timer should be initialized anyway: That way we can
 		   safely del_timer it when the module is unloaded. */
-		init_timer(&board->timer);
+		setup_timer(&board->timer, sx_pollfunc, (unsigned long)board);
 
-		if (board->poll) {
-			board->timer.data = (unsigned long)board;
-			board->timer.function = sx_pollfunc;
-			board->timer.expires = jiffies + board->poll;
-			add_timer(&board->timer);
-		}
+		if (board->poll)
+			mod_timer(&board->timer, jiffies + board->poll);
 	} else {
 		board->irq = 0;
 	}
_

Patches currently in -mm which might be from jirislaby@gmail.com are

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

