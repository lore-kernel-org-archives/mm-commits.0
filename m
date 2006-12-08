From: akpm@osdl.org
Subject: - char-mxser_new-clean-macros.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:07:49 -0800
Message-ID: <200612082007.kB8K7nYc002538@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57994 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946134AbWLHUHw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:07:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: mxser_new, clean macros
has been removed from the -mm tree.  Its filename was
     char-mxser_new-clean-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: mxser_new, clean macros
From: Jiri Slaby <jirislaby@gmail.com>

Celan redundant macros.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/mxser_new.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff -puN drivers/char/mxser_new.c~char-mxser_new-clean-macros drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~char-mxser_new-clean-macros
+++ a/drivers/char/mxser_new.c
@@ -54,11 +54,10 @@
 #define	MXSERCUMAJOR	 175
 
 #define	MXSER_EVENT_TXLOW	1
-#define	MXSER_EVENT_HANGUP	2
 
 #define MXSER_BOARDS		4	/* Max. boards */
-#define MXSER_PORTS		32	/* Max. ports */
 #define MXSER_PORTS_PER_BOARD	8	/* Max. ports per board */
+#define MXSER_PORTS		(MXSER_BOARDS * MXSER_PORTS_PER_BOARD)
 #define MXSER_ISR_PASS_LIMIT	99999L
 
 #define	MXSER_ERR_IOADDR	-1
@@ -66,9 +65,6 @@
 #define	MXSER_ERR_IRQ_CONFLIT	-3
 #define	MXSER_ERR_VECTOR	-4
 
-#define SERIAL_TYPE_NORMAL	1
-#define SERIAL_TYPE_CALLOUT	2
-
 #define WAKEUP_CHARS		256
 
 #define UART_MCR_AFE		0x20
@@ -365,14 +361,10 @@ static void process_txrx_fifo(struct mxs
 static void mxser_do_softint(void *private_)
 {
 	struct mxser_port *info = private_;
-	struct tty_struct *tty;
-
-	tty = info->tty;
+	struct tty_struct *tty = info->tty;
 
 	if (test_and_clear_bit(MXSER_EVENT_TXLOW, &info->event))
 		tty_wakeup(tty);
-	if (test_and_clear_bit(MXSER_EVENT_HANGUP, &info->event))
-		tty_hangup(tty);
 }
 
 static unsigned char mxser_get_msr(int baseaddr, int mode, int port)
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-mxser_new-clean-macros.patch
maintainers-add-me-to-isicom-mxser.patch
mxser_new-correct-tty-driver-name.patch
mxser-workqueue-fixes.patch
char-stallion-use-pr_debug-macro.patch
char-stallion-remove-unneeded-casts.patch
char-stallion-kill-typedefs.patch
char-stallion-move-init-deinit.patch
char-stallion-uninline-functions.patch
char-stallion-mark-functions-as-init.patch
char-stallion-remove-many-prototypes.patch
char-isicom-expand-function.patch
char-isicom-rename-init-function.patch
char-isicom-remove-isa-code.patch
char-isicom-remove-unneeded-memset.patch
char-isicom-move-to-tty_register_device.patch
char-isicom-use-pci_request_region.patch
char-isicom-check-kmalloc-retval.patch
char-isicom-use-completion.patch
char-isicom-simplify-timer.patch
char-isicom-remove-cvs-stuff.patch
char-isicom-fix-tty-index-check.patch
char-sx-convert-to-pci-probing.patch
char-sx-use-kcalloc.patch
char-sx-mark-functions-as-devinit.patch
char-sx-use-eisa-probing.patch
char-sx-ifdef-isa-code.patch
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

