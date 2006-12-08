From: akpm@osdl.org
Subject: - char-mxser_new-reverse-if-else-paths-patch.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:07:35 -0800
Message-ID: <200612082007.kB8K7ZY3002523@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57974 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946126AbWLHUHr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:07:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, osv@javad.com, mm-commits@vger.kernel.org


The patch titled
     Char: mxser_new, reverse if-else-paths patch
has been removed from the -mm tree.  Its filename was
     char-mxser_new-reverse-if-else-paths-patch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: mxser_new, reverse if-else-paths patch
From: Jiri Slaby <jirislaby@gmail.com>

This patch was intorduced in mxser to 1.9.1 conversion, but causes endless
sleep in tcdrain userspace call.

Thanks to Sergei Organov <osv@javad.com> for testing and pointing this out.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/mxser_new.c |   27 +++++++--------------------
 1 file changed, 7 insertions(+), 20 deletions(-)

diff -puN drivers/char/mxser_new.c~char-mxser_new-reverse-if-else-paths-patch drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~char-mxser_new-reverse-if-else-paths-patch
+++ a/drivers/char/mxser_new.c
@@ -1218,12 +1218,7 @@ static int mxser_write_room(struct tty_s
 static int mxser_chars_in_buffer(struct tty_struct *tty)
 {
 	struct mxser_port *info = tty->driver_data;
-	int len = info->xmit_cnt;
-
-	if (!(inb(info->ioaddr + UART_LSR) & UART_LSR_THRE))
-		len++;
-
-	return len;
+	return info->xmit_cnt;
 }
 
 static void mxser_flush_buffer(struct tty_struct *tty)
@@ -1953,7 +1948,7 @@ static void mxser_stoprx(struct tty_stru
 		if (info->board->chip_flag) {
 			info->IER &= ~MOXA_MUST_RECV_ISR;
 			outb(info->IER, info->ioaddr + UART_IER);
-		} else if (!(info->flags & ASYNC_CLOSING)) {
+		} else {
 			info->x_char = STOP_CHAR(tty);
 			outb(0, info->ioaddr + UART_IER);
 			info->IER |= UART_IER_THRI;
@@ -1990,7 +1985,7 @@ static void mxser_unthrottle(struct tty_
 			if (info->board->chip_flag) {
 				info->IER |= MOXA_MUST_RECV_ISR;
 				outb(info->IER, info->ioaddr + UART_IER);
-			} else if (!(info->flags & ASYNC_CLOSING)) {
+			} else {
 				info->x_char = START_CHAR(tty);
 				outb(0, info->ioaddr + UART_IER);
 				info->IER |= UART_IER_THRI;
@@ -2265,10 +2260,8 @@ static void mxser_receive_chars(struct m
 					flag = TTY_OVERRUN;
 /* added by casper 1/11/2000 */
 					port->icount.overrun++;
-				} else
-					flags = TTY_BREAK;
-			} else
-				flags = 0;
+				}
+			}
 			tty_insert_flip_char(tty, ch, flag);
 			cnt++;
 			if (cnt >= recv_room) {
@@ -2324,14 +2317,8 @@ static void mxser_transmit_chars(struct 
 	if (port->xmit_buf == 0)
 		goto unlock;
 
-	if (port->xmit_cnt == 0) {
-		if (port->xmit_cnt < WAKEUP_CHARS) { /* XXX what's this for?? */
-			set_bit(MXSER_EVENT_TXLOW, &port->event);
-			schedule_work(&port->tqueue);
-		}
-		goto unlock;
-	}
-	if (port->tty->stopped || (port->tty->hw_stopped &&
+	if ((port->xmit_cnt <= 0) || port->tty->stopped ||
+			(port->tty->hw_stopped &&
 			(port->type != PORT_16550A) &&
 			(!port->board->chip_flag))) {
 		port->IER &= ~UART_IER_THRI;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-mxser_new-reverse-if-else-paths-patch.patch
char-mxser_new-comments-cleanup.patch
char-mxser_new-correct-intr-handler-proto.patch
char-mxser_new-delete-ttys-and-termios.patch
char-mxser_new-pci-probing.patch
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

