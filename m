From: akpm@osdl.org
Subject: + char-isicom-remove-tty_hangwakeup-bottomhalves.patch added to -mm tree
Date: Thu, 14 Dec 2006 17:35:47 -0800
Message-ID: <200612150135.kBF1Zlgx003028@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49553 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965014AbWLOBf5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 20:35:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@redhat.com


The patch titled
     Char: isicom, remove tty_{hang,wake}up bottomhalves
has been added to the -mm tree.  Its filename is
     char-isicom-remove-tty_hangwakeup-bottomhalves.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: isicom, remove tty_{hang,wake}up bottomhalves
From: Jiri Slaby <jirislaby@gmail.com>

- tty_hangup() itself schedules work, so there is no need to schedule hangup
  in the driver
- tty_wakeup() its safe to call it while in atomic (IS THIS CORRECT?), so that
  its schedule_work might be also wiped out

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/isicom.c |   36 +++---------------------------------
 1 files changed, 3 insertions(+), 33 deletions(-)

diff -puN drivers/char/isicom.c~char-isicom-remove-tty_hangwakeup-bottomhalves drivers/char/isicom.c
--- a/drivers/char/isicom.c~char-isicom-remove-tty_hangwakeup-bottomhalves
+++ a/drivers/char/isicom.c
@@ -213,8 +213,6 @@ struct	isi_port {
 	struct tty_struct 	* tty;
 	wait_queue_head_t	close_wait;
 	wait_queue_head_t	open_wait;
-	struct work_struct	hangup_tq;
-	struct work_struct	bh_tqueue;
 	unsigned char		* xmit_buf;
 	int			xmit_head;
 	int			xmit_tail;
@@ -509,7 +507,7 @@ static void isicom_tx(unsigned long _dat
 		if (port->xmit_cnt <= 0)
 			port->status &= ~ISI_TXOK;
 		if (port->xmit_cnt <= WAKEUP_CHARS)
-			schedule_work(&port->bh_tqueue);
+			tty_wakeup(tty);
 		unlock_card(&isi_card[card]);
 	}
 
@@ -523,21 +521,6 @@ sched_again:
 	mod_timer(&tx, jiffies + msecs_to_jiffies(10));
 }
 
-/* 	Interrupt handlers 	*/
-
-
-static void isicom_bottomhalf(struct work_struct *work)
-{
-	struct isi_port *port = container_of(work, struct isi_port, bh_tqueue);
-	struct tty_struct *tty = port->tty;
-
-	if (!tty)
-		return;
-
-	tty_wakeup(tty);
-	wake_up_interruptible(&tty->write_wait);
-}
-
 /*
  *	Main interrupt handler routine
  */
@@ -608,7 +591,7 @@ static irqreturn_t isicom_interrupt(int 
 						pr_dbg("interrupt: DCD->low.\n"
 							);
 						port->status &= ~ISI_DCD;
-						schedule_work(&port->hangup_tq);
+						tty_hangup(tty);
 					}
 				} else if (header & ISI_DCD) {
 				/* Carrier has been detected */
@@ -630,7 +613,7 @@ static irqreturn_t isicom_interrupt(int 
 						/* start tx ing */
 						port->status |= (ISI_TXOK
 							| ISI_CTS);
-						schedule_work(&port->bh_tqueue);
+						tty_wakeup(tty);
 					}
 				} else if (!(header & ISI_CTS)) {
 					port->tty->hw_stopped = 1;
@@ -1455,17 +1438,6 @@ static void isicom_start(struct tty_stru
 	port->status |= ISI_TXOK;
 }
 
-/* hangup et all */
-static void do_isicom_hangup(struct work_struct *work)
-{
-	struct isi_port *port = container_of(work, struct isi_port, hangup_tq);
-	struct tty_struct *tty;
-
-	tty = port->tty;
-	if (tty)
-		tty_hangup(tty);
-}
-
 static void isicom_hangup(struct tty_struct *tty)
 {
 	struct isi_port *port = tty->driver_data;
@@ -1859,8 +1831,6 @@ static int __init isicom_init(void)
 			port->channel = channel;
 			port->close_delay = 50 * HZ/100;
 			port->closing_wait = 3000 * HZ/100;
-			INIT_WORK(&port->hangup_tq, do_isicom_hangup);
-			INIT_WORK(&port->bh_tqueue, isicom_bottomhalf);
 			port->status = 0;
 			init_waitqueue_head(&port->open_wait);
 			init_waitqueue_head(&port->close_wait);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch
char-isicom-remove-tty_hangwakeup-bottomhalves.patch

