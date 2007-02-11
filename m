From: akpm@linux-foundation.org
Subject: - char-isicom-remove-tty_hangwakeup-bottomhalves.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:50:25 -0800
Message-ID: <200702112250.l1BMoPEk015855@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60015 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932712AbXBKWue (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:50:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Char: isicom, remove tty_{hang,wake}up bottomhalves
has been removed from the -mm tree.  Its filename was
     char-isicom-remove-tty_hangwakeup-bottomhalves.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: isicom, remove tty_{hang,wake}up bottomhalves
From: Jiri Slaby <jirislaby@gmail.com>

- tty_hangup() itself schedules work, so there is no need to schedule hangup
  in the driver

- tty_wakeup(): it's safe to call it while in atomic, so that its
  schedule_work might be also wiped out

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/isicom.c |   36 +++---------------------------------
 1 file changed, 3 insertions(+), 33 deletions(-)

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
@@ -510,7 +508,7 @@ static void isicom_tx(unsigned long _dat
 		if (port->xmit_cnt <= 0)
 			port->status &= ~ISI_TXOK;
 		if (port->xmit_cnt <= WAKEUP_CHARS)
-			schedule_work(&port->bh_tqueue);
+			tty_wakeup(tty);
 		unlock_card(&isi_card[card]);
 	}
 
@@ -524,21 +522,6 @@ sched_again:
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
@@ -609,7 +592,7 @@ static irqreturn_t isicom_interrupt(int 
 						pr_dbg("interrupt: DCD->low.\n"
 							);
 						port->status &= ~ISI_DCD;
-						schedule_work(&port->hangup_tq);
+						tty_hangup(tty);
 					}
 				} else if (header & ISI_DCD) {
 				/* Carrier has been detected */
@@ -631,7 +614,7 @@ static irqreturn_t isicom_interrupt(int 
 						/* start tx ing */
 						port->status |= (ISI_TXOK
 							| ISI_CTS);
-						schedule_work(&port->bh_tqueue);
+						tty_wakeup(tty);
 					}
 				} else if (!(header & ISI_CTS)) {
 					port->tty->hw_stopped = 1;
@@ -1460,17 +1443,6 @@ static void isicom_start(struct tty_stru
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
@@ -1858,8 +1830,6 @@ static int __init isicom_init(void)
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
