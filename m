From: akpm@linux-foundation.org
Subject: + char-riscom8-remove-wakeup-anf-hangup-bottomhalves.patch added to -mm tree
Date: Mon, 12 Nov 2007 13:52:44 -0800
Message-ID: <200711122152.lACLqiHw010720@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44528 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753543AbXKLVx4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 16:53:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@redhat.com


The patch titled
     Char: riscom8, remove wakeup anf hangup bottomhalves
has been added to the -mm tree.  Its filename is
     char-riscom8-remove-wakeup-anf-hangup-bottomhalves.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: riscom8, remove wakeup anf hangup bottomhalves
From: Jiri Slaby <jirislaby@gmail.com>

Both of them may be called directly from the code, don't add special code
and variables and schedule a work for them.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/riscom8.c |   51 +++------------------------------------
 drivers/char/riscom8.h |    3 --
 2 files changed, 4 insertions(+), 50 deletions(-)

diff -puN drivers/char/riscom8.c~char-riscom8-remove-wakeup-anf-hangup-bottomhalves drivers/char/riscom8.c
--- a/drivers/char/riscom8.c~char-riscom8-remove-wakeup-anf-hangup-bottomhalves
+++ a/drivers/char/riscom8.c
@@ -78,8 +78,6 @@
 	 ASYNC_SPD_HI       | ASYNC_SPEED_VHI    | ASYNC_SESSION_LOCKOUT | \
 	 ASYNC_PGRP_LOCKOUT | ASYNC_CALLOUT_NOHUP)
 
-#define RS_EVENT_WRITE_WAKEUP	0
-
 static struct tty_driver *riscom_driver;
 
 static DEFINE_SPINLOCK(riscom_lock);
@@ -314,12 +312,6 @@ out_release:
  * 
  */
 
-static inline void rc_mark_event(struct riscom_port * port, int event)
-{
-	set_bit(event, &port->event);
-	schedule_work(&port->tqueue);
-}
-
 static inline struct riscom_port * rc_get_port(struct riscom_board const * bp,
 					       unsigned char const * what)
 {
@@ -486,7 +478,7 @@ static inline void rc_transmit(struct ri
 		rc_out(bp, CD180_IER, port->IER);
 	}
 	if (port->xmit_cnt <= port->wakeup_chars)
-		rc_mark_event(port, RS_EVENT_WRITE_WAKEUP);
+		tty_wakeup(tty);
 }
 
 static inline void rc_check_modem(struct riscom_board const * bp)
@@ -505,7 +497,7 @@ static inline void rc_check_modem(struct
 		if (rc_in(bp, CD180_MSVR) & MSVR_CD) 
 			wake_up_interruptible(&port->open_wait);
 		else
-			schedule_work(&port->tqueue_hangup);
+			tty_hangup(tty);
 	}
 	
 #ifdef RISCOM_BRAIN_DAMAGED_CTS
@@ -514,7 +506,7 @@ static inline void rc_check_modem(struct
 			tty->hw_stopped = 0;
 			port->IER |= IER_TXRDY;
 			if (port->xmit_cnt <= port->wakeup_chars)
-				rc_mark_event(port, RS_EVENT_WRITE_WAKEUP);
+				tty_wakeup(tty);
 		} else  {
 			tty->hw_stopped = 1;
 			port->IER &= ~IER_TXRDY;
@@ -526,7 +518,7 @@ static inline void rc_check_modem(struct
 			tty->hw_stopped = 0;
 			port->IER |= IER_TXRDY;
 			if (port->xmit_cnt <= port->wakeup_chars)
-				rc_mark_event(port, RS_EVENT_WRITE_WAKEUP);
+				tty_wakeup(tty);
 		} else  {
 			tty->hw_stopped = 1;
 			port->IER &= ~IER_TXRDY;
@@ -1091,7 +1083,6 @@ static void rc_close(struct tty_struct *
 	tty_ldisc_flush(tty);
 
 	tty->closing = 0;
-	port->event = 0;
 	port->tty = NULL;
 	if (port->blocked_open) {
 		if (port->close_delay) {
@@ -1526,25 +1517,6 @@ static void rc_start(struct tty_struct *
 	spin_unlock_irqrestore(&riscom_lock, flags);
 }
 
-/*
- * This routine is called from the work queue when the interrupt
- * routine has signalled that a hangup has occurred.  The path of
- * hangup processing is:
- *
- * 	serial interrupt routine -> (workqueue) ->
- * 	do_rc_hangup() -> tty->hangup() -> rc_hangup()
- * 
- */
-static void do_rc_hangup(struct work_struct *ugly_api)
-{
-	struct riscom_port	*port = container_of(ugly_api, struct riscom_port, tqueue_hangup);
-	struct tty_struct	*tty;
-	
-	tty = port->tty;
-	if (tty)
-		tty_hangup(tty);	/* FIXME: module removal race still here */
-}
-
 static void rc_hangup(struct tty_struct * tty)
 {
 	struct riscom_port *port = (struct riscom_port *)tty->driver_data;
@@ -1556,7 +1528,6 @@ static void rc_hangup(struct tty_struct 
 	bp = port_Board(port);
 	
 	rc_shutdown_port(bp, port);
-	port->event = 0;
 	port->count = 0;
 	port->flags &= ~ASYNC_NORMAL_ACTIVE;
 	port->tty = NULL;
@@ -1586,18 +1557,6 @@ static void rc_set_termios(struct tty_st
 	}
 }
 
-static void do_softint(struct work_struct *ugly_api)
-{
-	struct riscom_port	*port = container_of(ugly_api, struct riscom_port, tqueue);
-	struct tty_struct	*tty;
-	
-	if(!(tty = port->tty)) 
-		return;
-
-	if (test_and_clear_bit(RS_EVENT_WRITE_WAKEUP, &port->event))
-		tty_wakeup(tty);
-}
-
 static const struct tty_operations riscom_ops = {
 	.open  = rc_open,
 	.close = rc_close,
@@ -1650,8 +1609,6 @@ static int __init rc_init_drivers(void)
 	memset(rc_port, 0, sizeof(rc_port));
 	for (i = 0; i < RC_NPORT * RC_NBOARD; i++)  {
 		rc_port[i].magic = RISCOM8_MAGIC;
-		INIT_WORK(&rc_port[i].tqueue, do_softint);
-		INIT_WORK(&rc_port[i].tqueue_hangup, do_rc_hangup);
 		rc_port[i].close_delay = 50 * HZ/100;
 		rc_port[i].closing_wait = 3000 * HZ/100;
 		init_waitqueue_head(&rc_port[i].open_wait);
diff -puN drivers/char/riscom8.h~char-riscom8-remove-wakeup-anf-hangup-bottomhalves drivers/char/riscom8.h
--- a/drivers/char/riscom8.h~char-riscom8-remove-wakeup-anf-hangup-bottomhalves
+++ a/drivers/char/riscom8.h
@@ -71,7 +71,6 @@ struct riscom_port {
 	struct tty_struct 	* tty;
 	int			count;
 	int			blocked_open;
-	unsigned long		event; /* long req'd for set_bit --RR */
 	int			timeout;
 	int			close_delay;
 	unsigned char 		* xmit_buf;
@@ -81,8 +80,6 @@ struct riscom_port {
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

fs-sysfs-remove-spin_lock_unlocked.patch
net-sunrpc-remove-spin_lock_unlocked.patch
net-ibm_newemac-remove-spin_lock_unlocked.patch
sbus-cpwatchdog-remove-spin_lock_unlocked.patch
watchdog-bfin_wdt-remove-spin_lock_unlocked.patch
git-wireless.patch
crisv10-serial-driver-rewrite-take-three.patch
dzh-remove-useless-unused-module-junk.patch
dz-always-check-if-it-is-safe-to-console_putchar.patch
dz-dont-panic-when-request_irq-fails.patch
dz-add-and-reorder-inclusions-remove-unneeded-ones.patch
dz-update-kconfig-description.patch
dz-rename-the-serial-console-structure.patch
dz-fix-locking-issues.patch
dz-handle-special-conditions-on-reception-correctly.patch
maintainers-add-self-for-the-dz-serial-driver.patch
char-rocket-switch-long-delay-to-sleep.patch
char-rocket-printk-cleanup.patch
char-rocket-remove-useless-macros.patch
char-char-serial-remove-serial_type_normal-redefines.patch
char-mxser_new-ioaddresses-are-ulong.patch
char-stallion-fix-compiler-warnings.patch
char-riscom8-change-rc_init_drivers-prototype.patch
char-esp-remove-hangup-and-wakeup-bottomhalves.patch
char-istallion-remove-hangup-bottomhalf.patch
char-specialix-remove-bottomhalves.patch
char-stallion-remove-bottomhalf.patch
char-serial167-remove-bottomhalf.patch
char-riscom8-remove-wakeup-anf-hangup-bottomhalves.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
