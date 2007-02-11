From: akpm@linux-foundation.org
Subject: - char-mxser_new-alter-locking-in-isr.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:51:58 -0800
Message-ID: <200702112251.l1BMpwFY015975@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60199 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932774AbXBKWwC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:52:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, osv@javad.com, mm-commits@vger.kernel.org


The patch titled
     Char: mxser_new, alter locking in isr
has been removed from the -mm tree.  Its filename was
     char-mxser_new-alter-locking-in-isr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: mxser_new, alter locking in isr
From: Jiri Slaby <jirislaby@gmail.com>

Avoid oopsing when stress-testing open/close -- port->tty is NULL sometimes,
but is expected to be non-NULL, since dereferencing.  Receive/transmit chars
iff ASYNC_CLOSING is not set and ASYNC_INITIALIZED is set.  Thanks Sergei for
pointing this out and testing.

Cc: Sergei Organov <osv@javad.com>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser_new.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

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
