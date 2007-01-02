From: akpm@osdl.org
Subject: + char-mxser_new-alter-locking-in-isr.patch added to -mm tree
Date: Tue, 02 Jan 2007 13:11:14 -0800
Message-ID: <200701022111.l02LBEir029779@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:60862 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957AbXABVLd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 16:11:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, osv@javad.com


The patch titled
     Char: mxser_new, alter locking in isr
has been added to the -mm tree.  Its filename is
     char-mxser_new-alter-locking-in-isr.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: mxser_new, alter locking in isr
From: Jiri Slaby <jirislaby@gmail.com>

Avoid oopsing when stress-testing open/close -- port->tty is NULL sometimes,
but is expected to be non-NULL, since dereferencing.  Receive/transmit chars
iff ASYNC_CLOSING is not set and ASYNC_INITIALIZED is set.  Thanks Sergei for
pointing this out and testing.

Cc: Sergei Organov <osv@javad.com>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/mxser_new.c |   22 +++++++++-------------
 1 files changed, 9 insertions(+), 13 deletions(-)

diff -puN drivers/char/mxser_new.c~char-mxser_new-alter-locking-in-isr drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~char-mxser_new-alter-locking-in-isr
+++ a/drivers/char/mxser_new.c
@@ -2073,9 +2073,6 @@ static void mxser_receive_chars(struct m
 	int cnt = 0;
 	int recv_room;
 	int max = 256;
-	unsigned long flags;
-
-	spin_lock_irqsave(&port->slock, flags);
 
 	recv_room = tty->receive_room;
 	if ((recv_room == 0) && (!port->ldisc_stop_rx))
@@ -2159,7 +2156,6 @@ end_intr:
 	mxvar_log.rxcnt[port->tty->index] += cnt;
 	port->mon_data.rxcnt += cnt;
 	port->mon_data.up_rxcnt += cnt;
-	spin_unlock_irqrestore(&port->slock, flags);
 
 	tty_flip_buffer_push(tty);
 }
@@ -2167,9 +2163,6 @@ end_intr:
 static void mxser_transmit_chars(struct mxser_port *port)
 {
 	int count, cnt;
-	unsigned long flags;
-
-	spin_lock_irqsave(&port->slock, flags);
 
 	if (port->x_char) {
 		outb(port->x_char, port->ioaddr + UART_TX);
@@ -2178,11 +2171,11 @@ static void mxser_transmit_chars(struct 
 		port->mon_data.txcnt++;
 		port->mon_data.up_txcnt++;
 		port->icount.tx++;
-		goto unlock;
+		return;
 	}
 
 	if (port->xmit_buf == 0)
-		goto unlock;
+		return;
 
 	if ((port->xmit_cnt <= 0) || port->tty->stopped ||
 			(port->tty->hw_stopped &&
@@ -2190,7 +2183,7 @@ static void mxser_transmit_chars(struct 
 			(!port->board->chip_flag))) {
 		port->IER &= ~UART_IER_THRI;
 		outb(port->IER, port->ioaddr + UART_IER);
-		goto unlock;
+		return;
 	}
 
 	cnt = port->xmit_cnt;
@@ -2215,8 +2208,6 @@ static void mxser_transmit_chars(struct 
 		port->IER &= ~UART_IER_THRI;
 		outb(port->IER, port->ioaddr + UART_IER);
 	}
-unlock:
-	spin_unlock_irqrestore(&port->slock, flags);
 }
 
 /*
@@ -2257,12 +2248,16 @@ static irqreturn_t mxser_interrupt(int i
 			port = &brd->ports[i];
 
 			int_cnt = 0;
+			spin_lock(&port->slock);
 			do {
 				iir = inb(port->ioaddr + UART_IIR);
 				if (iir & UART_IIR_NO_INT)
 					break;
 				iir &= MOXA_MUST_IIR_MASK;
-				if (!port->tty) {
+				if (!port->tty ||
+						(port->flags & ASYNC_CLOSING) ||
+						!(port->flags &
+							ASYNC_INITIALIZED)) {
 					status = inb(port->ioaddr + UART_LSR);
 					outb(0x27, port->ioaddr + UART_FCR);
 					inb(port->ioaddr + UART_MSR);
@@ -2308,6 +2303,7 @@ static irqreturn_t mxser_interrupt(int i
 						mxser_transmit_chars(port);
 				}
 			} while (int_cnt++ < MXSER_ISR_PASS_LIMIT);
+			spin_unlock(&port->slock);
 		}
 		if (pass_counter++ > MXSER_ISR_PASS_LIMIT)
 			break;	/* Prevent infinite loops */
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
shrink_slab-handle-bad-shrinkers.patch
