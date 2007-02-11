From: akpm@linux-foundation.org
Subject: - char-mxser_new-remove-tty_wakeup-bottomhalf.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:51:50 -0800
Message-ID: <200702112251.l1BMpouC015966@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60173 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932767AbXBKWvw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:51:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: mxser_new, remove tty_wakeup bottomhalf
has been removed from the -mm tree.  Its filename was
     char-mxser_new-remove-tty_wakeup-bottomhalf.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: mxser_new, remove tty_wakeup bottomhalf
From: Jiri Slaby <jirislaby@gmail.com>

It's safe to call tty_wakeup from irq context. Do not schedule it for later
calling.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser_new.c |   26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

diff -puN drivers/char/mxser_new.c~char-mxser_new-remove-tty_wakeup-bottomhalf drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~char-mxser_new-remove-tty_wakeup-bottomhalf
+++ a/drivers/char/mxser_new.c
@@ -269,7 +269,6 @@ struct mxser_port {
 	struct mxser_mon mon_data;
 
 	spinlock_t slock;
-	struct work_struct tqueue;
 	wait_queue_head_t open_wait;
 	wait_queue_head_t delta_msr_wait;
 };
@@ -355,15 +354,6 @@ static void process_txrx_fifo(struct mxs
 			}
 }
 
-static void mxser_do_softint(struct work_struct *work)
-{
-	struct mxser_port *info = container_of(work, struct mxser_port, tqueue);
-	struct tty_struct *tty = info->tty;
-
-	if (test_and_clear_bit(MXSER_EVENT_TXLOW, &info->event))
-		tty_wakeup(tty);
-}
-
 static unsigned char mxser_get_msr(int baseaddr, int mode, int port)
 {
 	unsigned char status = 0;
@@ -607,8 +597,8 @@ static int mxser_change_speed(struct mxs
 						outb(info->IER, info->ioaddr +
 								UART_IER);
 					}
-					set_bit(MXSER_EVENT_TXLOW, &info->event);
-					schedule_work(&info->tqueue);				}
+					tty_wakeup(info->tty);
+				}
 			} else {
 				if (!(status & UART_MSR_CTS)) {
 					info->tty->hw_stopped = 1;
@@ -703,7 +693,6 @@ static void mxser_check_modem_status(str
 	if ((port->flags & ASYNC_CHECK_CD) && (status & UART_MSR_DDCD)) {
 		if (status & UART_MSR_DCD)
 			wake_up_interruptible(&port->open_wait);
-		schedule_work(&port->tqueue);
 	}
 
 	if (port->flags & ASYNC_CTS_FLOW) {
@@ -719,8 +708,7 @@ static void mxser_check_modem_status(str
 					outb(port->IER, port->ioaddr +
 							UART_IER);
 				}
-				set_bit(MXSER_EVENT_TXLOW, &port->event);
-				schedule_work(&port->tqueue);
+				tty_wakeup(port->tty);
 			}
 		} else {
 			if (!(status & UART_MSR_CTS)) {
@@ -2220,10 +2208,9 @@ static void mxser_transmit_chars(struct 
 	port->mon_data.up_txcnt += (cnt - port->xmit_cnt);
 	port->icount.tx += (cnt - port->xmit_cnt);
 
-	if (port->xmit_cnt < WAKEUP_CHARS) {
-		set_bit(MXSER_EVENT_TXLOW, &port->event);
-		schedule_work(&port->tqueue);
-	}
+	if (port->xmit_cnt < WAKEUP_CHARS)
+		tty_wakeup(port->tty);
+
 	if (port->xmit_cnt <= 0) {
 		port->IER &= ~UART_IER_THRI;
 		outb(port->IER, port->ioaddr + UART_IER);
@@ -2400,7 +2387,6 @@ static int __devinit mxser_initbrd(struc
 		info->custom_divisor = info->baud_base * 16;
 		info->close_delay = 5 * HZ / 10;
 		info->closing_wait = 30 * HZ;
-		INIT_WORK(&info->tqueue, mxser_do_softint);
 		info->normal_termios = mxvar_sdriver->init_termios;
 		init_waitqueue_head(&info->open_wait);
 		init_waitqueue_head(&info->delta_msr_wait);
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
