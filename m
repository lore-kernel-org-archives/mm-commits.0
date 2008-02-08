From: akpm@linux-foundation.org
Subject: - char-specialix-remove-bottomhalves.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:09:44 -0800
Message-ID: <200802080809.m1889PjM014827@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51113 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761646AbYBHITn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Char: specialix, remove bottomhalves
has been removed from the -mm tree.  Its filename was
     char-specialix-remove-bottomhalves.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: specialix, remove bottomhalves
From: Jiri Slaby <jirislaby@gmail.com>

- tqueue is used only for tty_wakeup, call it directly from the code
- tqueue_hangup for tty_hangup, it schedules its own work, use it directly
  too

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/specialix.c     |   72 +--------------------------------
 drivers/char/specialix_io8.h |    3 -
 2 files changed, 4 insertions(+), 71 deletions(-)

diff -puN drivers/char/specialix.c~char-specialix-remove-bottomhalves drivers/char/specialix.c
--- a/drivers/char/specialix.c~char-specialix-remove-bottomhalves
+++ a/drivers/char/specialix.c
@@ -178,9 +178,6 @@ static int sx_poll = HZ;
 	 ASYNC_SPD_HI       | ASYNC_SPEED_VHI    | ASYNC_SESSION_LOCKOUT | \
 	 ASYNC_PGRP_LOCKOUT | ASYNC_CALLOUT_NOHUP)
 
-#undef RS_EVENT_WRITE_WAKEUP
-#define RS_EVENT_WRITE_WAKEUP	0
-
 static struct tty_driver *specialix_driver;
 
 static struct specialix_board sx_board[SX_NBOARD] =  {
@@ -602,17 +599,6 @@ static int sx_probe(struct specialix_boa
  *  Interrupt processing routines.
  * */
 
-static inline void sx_mark_event(struct specialix_port * port, int event)
-{
-	func_enter();
-
-	set_bit(event, &port->event);
-	schedule_work(&port->tqueue);
-
-	func_exit();
-}
-
-
 static inline struct specialix_port * sx_get_port(struct specialix_board * bp,
 					       unsigned char const * what)
 {
@@ -809,7 +795,7 @@ static inline void sx_transmit(struct sp
 		sx_out(bp, CD186x_IER, port->IER);
 	}
 	if (port->xmit_cnt <= port->wakeup_chars)
-		sx_mark_event(port, RS_EVENT_WRITE_WAKEUP);
+ 		tty_wakeup(tty);
 
 	func_exit();
 }
@@ -839,7 +825,7 @@ static inline void sx_check_modem(struct
 			wake_up_interruptible(&port->open_wait);
 		} else {
 			dprintk (SX_DEBUG_SIGNALS, "Sending HUP.\n");
-			schedule_work(&port->tqueue_hangup);
+			tty_hangup(tty);
 		}
 	}
 
@@ -849,7 +835,7 @@ static inline void sx_check_modem(struct
 			tty->hw_stopped = 0;
 			port->IER |= IER_TXRDY;
 			if (port->xmit_cnt <= port->wakeup_chars)
-				sx_mark_event(port, RS_EVENT_WRITE_WAKEUP);
+				tty_wakeup(tty);
 		} else {
 			tty->hw_stopped = 1;
 			port->IER &= ~IER_TXRDY;
@@ -861,7 +847,7 @@ static inline void sx_check_modem(struct
 			tty->hw_stopped = 0;
 			port->IER |= IER_TXRDY;
 			if (port->xmit_cnt <= port->wakeup_chars)
-				sx_mark_event(port, RS_EVENT_WRITE_WAKEUP);
+				tty_wakeup(tty);
 		} else {
 			tty->hw_stopped = 1;
 			port->IER &= ~IER_TXRDY;
@@ -1618,7 +1604,6 @@ static void sx_close(struct tty_struct *
 	tty_ldisc_flush(tty);
 	spin_lock_irqsave(&port->lock, flags);
 	tty->closing = 0;
-	port->event = 0;
 	port->tty = NULL;
 	spin_unlock_irqrestore(&port->lock, flags);
 	if (port->blocked_open) {
@@ -2235,32 +2220,6 @@ static void sx_start(struct tty_struct *
 	func_exit();
 }
 
-
-/*
- * This routine is called from the work-queue when the interrupt
- * routine has signalled that a hangup has occurred.  The path of
- * hangup processing is:
- *
- * 	serial interrupt routine -> (workqueue) ->
- * 	do_sx_hangup() -> tty->hangup() -> sx_hangup()
- *
- */
-static void do_sx_hangup(struct work_struct *work)
-{
-	struct specialix_port	*port =
-		container_of(work, struct specialix_port, tqueue_hangup);
-	struct tty_struct	*tty;
-
-	func_enter();
-
-	tty = port->tty;
-	if (tty)
-		tty_hangup(tty);	/* FIXME: module removal race here */
-
-	func_exit();
-}
-
-
 static void sx_hangup(struct tty_struct * tty)
 {
 	struct specialix_port *port = (struct specialix_port *)tty->driver_data;
@@ -2278,7 +2237,6 @@ static void sx_hangup(struct tty_struct 
 
 	sx_shutdown_port(bp, port);
 	spin_lock_irqsave(&port->lock, flags);
-	port->event = 0;
 	bp->count -= port->count;
 	if (bp->count < 0) {
 		printk(KERN_ERR "sx%d: sx_hangup: bad board count: %d port: %d\n",
@@ -2320,26 +2278,6 @@ static void sx_set_termios(struct tty_st
 	}
 }
 
-
-static void do_softint(struct work_struct *work)
-{
-	struct specialix_port	*port =
-		container_of(work, struct specialix_port, tqueue);
-	struct tty_struct	*tty;
-
-	func_enter();
-
-	if(!(tty = port->tty)) {
-		func_exit();
-		return;
-	}
-
-	if (test_and_clear_bit(RS_EVENT_WRITE_WAKEUP, &port->event))
- 		tty_wakeup(tty);
-
-	func_exit();
-}
-
 static const struct tty_operations sx_ops = {
 	.open  = sx_open,
 	.close = sx_close,
@@ -2397,8 +2335,6 @@ static int sx_init_drivers(void)
 	memset(sx_port, 0, sizeof(sx_port));
 	for (i = 0; i < SX_NPORT * SX_NBOARD; i++) {
 		sx_port[i].magic = SPECIALIX_MAGIC;
-		INIT_WORK(&sx_port[i].tqueue, do_softint);
-		INIT_WORK(&sx_port[i].tqueue_hangup, do_sx_hangup);
 		sx_port[i].close_delay = 50 * HZ/100;
 		sx_port[i].closing_wait = 3000 * HZ/100;
 		init_waitqueue_head(&sx_port[i].open_wait);
diff -puN drivers/char/specialix_io8.h~char-specialix-remove-bottomhalves drivers/char/specialix_io8.h
--- a/drivers/char/specialix_io8.h~char-specialix-remove-bottomhalves
+++ a/drivers/char/specialix_io8.h
@@ -112,7 +112,6 @@ struct specialix_port {
 	struct tty_struct 	* tty;
 	int			count;
 	int			blocked_open;
-	ulong			event;
 	int			timeout;
 	int			close_delay;
 	unsigned char 		* xmit_buf;
@@ -122,8 +121,6 @@ struct specialix_port {
 	int			xmit_cnt;
 	wait_queue_head_t	open_wait;
 	wait_queue_head_t	close_wait;
-	struct work_struct	tqueue;
-	struct work_struct	tqueue_hangup;
 	short			wakeup_chars;
 	short			break_length;
 	unsigned short		closing_wait;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-drm.patch
drm-i915-fix-oops-after-killing-x.patch
git-watchdog.patch
moxa-first-pass-at-termios-reporting.patch
char-applicom-use-pci_resource_start.patch
char-applicom-use-pci_match_id.patch
char-applicom-use-pci_match_id-fix.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
