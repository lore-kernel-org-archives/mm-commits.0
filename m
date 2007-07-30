From: akpm@linux-foundation.org
Subject: + char-cyclades-remove-bottom-half-processing.patch added to -mm tree
Date: Mon, 30 Jul 2007 16:40:07 -0700
Message-ID: <200707302340.l6UNe7pa004445@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33367 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762952AbXG3XkX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 19:40:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, paulkf@microgate.com


The patch titled
     Char: cyclades, remove bottom half processing
has been added to the -mm tree.  Its filename is
     char-cyclades-remove-bottom-half-processing.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: cyclades, remove bottom half processing
From: Jiri Slaby <jirislaby@gmail.com>

The work done in bottom half doesn't cost much cpu time (e.g.  tty_hangup
itself schedules its own bottom half), it's possible to do the work in isr
directly and save hence some .text.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Paul Fulghum <paulkf@microgate.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c  |  111 ++++++-------------------------------
 include/linux/cyclades.h |   15 -----
 2 files changed, 20 insertions(+), 106 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-remove-bottom-half-processing drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-remove-bottom-half-processing
+++ a/drivers/char/cyclades.c
@@ -897,71 +897,6 @@ static inline int serial_paranoia_check(
 	return 0;
 }				/* serial_paranoia_check */
 
-/*
- * This routine is used by the interrupt handler to schedule
- * processing in the software interrupt portion of the driver
- * (also known as the "bottom half").  This can be called any
- * number of times for any channel without harm.
- */
-static inline void cy_sched_event(struct cyclades_port *info, int event)
-{
-	info->event |= 1 << event; /* remember what kind of event and who */
-	schedule_work(&info->tqueue);
-}				/* cy_sched_event */
-
-/*
- * This routine is used to handle the "bottom half" processing for the
- * serial driver, known also the "software interrupt" processing.
- * This processing is done at the kernel interrupt level, after the
- * cy#/_interrupt() has returned, BUT WITH INTERRUPTS TURNED ON.  This
- * is where time-consuming activities which can not be done in the
- * interrupt driver proper are done; the interrupt driver schedules
- * them using cy_sched_event(), and they get done here.
- *
- * This is done through one level of indirection--the task queue.
- * When a hardware interrupt service routine wants service by the
- * driver's bottom half, it enqueues the appropriate tq_struct (one
- * per port) to the keventd work queue and sets a request flag
- * that the work queue be processed.
- *
- * Although this may seem unwieldy, it gives the system a way to
- * pass an argument (in this case the pointer to the cyclades_port
- * structure) to the bottom half of the driver.  Previous kernels
- * had to poll every port to see if that port needed servicing.
- */
-static void
-do_softint(struct work_struct *work)
-{
-	struct cyclades_port *info =
-		container_of(work, struct cyclades_port, tqueue);
-	struct tty_struct    *tty;
-
-	tty = info->tty;
-	if (!tty)
-		return;
-
-	if (test_and_clear_bit(Cy_EVENT_HANGUP, &info->event)) {
-		tty_hangup(info->tty);
-		wake_up_interruptible(&info->open_wait);
-		        info->flags &= ~ASYNC_NORMAL_ACTIVE;
-	}
-	if (test_and_clear_bit(Cy_EVENT_OPEN_WAKEUP, &info->event))
-		wake_up_interruptible(&info->open_wait);
-#ifdef CONFIG_CYZ_INTR
-	if (test_and_clear_bit(Cy_EVENT_Z_RX_FULL, &info->event) &&
-			!timer_pending(&cyz_rx_full_timer[info->line]))
-		mod_timer(&cyz_rx_full_timer[info->line], jiffies + 1);
-#endif
-	if (test_and_clear_bit(Cy_EVENT_DELTA_WAKEUP, &info->event))
-		wake_up_interruptible(&info->delta_msr_wait);
-	tty_wakeup(tty);
-#ifdef Z_WAKE
-	if (test_and_clear_bit(Cy_EVENT_SHUTDOWN_WAKEUP, &info->event))
-		complete(&info->shutdown_wait);
-#endif
-} /* do_softint */
-
-
 /***********************************************************/
 /********* Start of block of Cyclom-Y specific code ********/
 
@@ -1243,7 +1178,7 @@ static void cyy_intr_chip(struct cyclade
 			cy_writeb(base_addr + (CySRER << index),
 				  readb(base_addr + (CySRER << index)) &
 				  ~CyTxRdy);
-			goto txdone;
+			goto txend;
 		}
 
 		/* load the on-chip space for outbound data */
@@ -1334,9 +1269,7 @@ static void cyy_intr_chip(struct cyclade
 		}
 
 txdone:
-		if (info->xmit_cnt < WAKEUP_CHARS) {
-			cy_sched_event(info, Cy_EVENT_WRITE_WAKEUP);
-		}
+		tty_wakeup(info->tty);
 txend:
 		/* end of service */
 		cy_writeb(base_addr + (CyTIR << index), (save_xir & 0x3f));
@@ -1369,17 +1302,16 @@ txend:
 				if (mdm_change & CyRI)
 					info->icount.rng++;
 
-				cy_sched_event(info, Cy_EVENT_DELTA_WAKEUP);
+				wake_up_interruptible(&info->delta_msr_wait);
 			}
 
 			if ((mdm_change & CyDCD) &&
 					(info->flags & ASYNC_CHECK_CD)) {
-				if (mdm_status & CyDCD) {
-					cy_sched_event(info,
-							Cy_EVENT_OPEN_WAKEUP);
-				} else {
-					cy_sched_event(info, Cy_EVENT_HANGUP);
+				if (!(mdm_status & CyDCD)) {
+					tty_hangup(info->tty);
+					info->flags &= ~ASYNC_NORMAL_ACTIVE;
 				}
+				wake_up_interruptible(&info->open_wait);
 			}
 			if ((mdm_change & CyCTS) &&
 					(info->flags & ASYNC_CTS_FLOW)) {
@@ -1394,8 +1326,7 @@ txend:
 								(CySRER <<
 									index))|
 							CyTxRdy);
-						cy_sched_event(info,
-							Cy_EVENT_WRITE_WAKEUP);
+						tty_wakeup(info->tty);
 					}
 				} else {
 					if (!(mdm_status & CyCTS)) {
@@ -1633,9 +1564,11 @@ cyz_handle_rx(struct cyclades_port *info
 				char_count = rx_put - rx_get;
 			else
 				char_count = rx_put - rx_get + rx_bufsize;
-			if (char_count >= (int)readl(&buf_ctrl->rx_threshold)) {
-				cy_sched_event(info, Cy_EVENT_Z_RX_FULL);
-			}
+			if (char_count >= (int)readl(&buf_ctrl->rx_threshold) &&
+					!timer_pending(&cyz_rx_full_timer[
+							info->line]))
+				mod_timer(&cyz_rx_full_timer[info->line],
+						jiffies + 1);
 #endif
 			info->idle_stats.recv_idle = jiffies;
 			tty_schedule_flip(tty);
@@ -1717,9 +1650,7 @@ cyz_handle_tx(struct cyclades_port *info
 		}
 #endif
 ztxdone:
-		if (info->xmit_cnt < WAKEUP_CHARS) {
-			cy_sched_event(info, Cy_EVENT_WRITE_WAKEUP);
-		}
+		tty_wakeup(tty);
 		/* Update tx_put */
 		cy_writel(&buf_ctrl->tx_put, tx_put);
 	}
@@ -1781,10 +1712,11 @@ static void cyz_handle_cmd(struct cyclad
 				if ((fw_ver > 241 ? ((u_long) param) :
 						readl(&ch_ctrl->rs_status)) &
 						C_RS_DCD) {
-					cy_sched_event(info,
-						 	Cy_EVENT_OPEN_WAKEUP);
+					wake_up_interruptible(&info->open_wait);
 				} else {
-					cy_sched_event(info, Cy_EVENT_HANGUP);
+					tty_hangup(info->tty);
+					wake_up_interruptible(&info->open_wait);
+					info->flags &= ~ASYNC_NORMAL_ACTIVE;
 				}
 			}
 			break;
@@ -1802,7 +1734,7 @@ static void cyz_handle_cmd(struct cyclad
 			break;
 #ifdef Z_WAKE
 		case C_CM_IOCTLW:
-			cy_sched_event(info, Cy_EVENT_SHUTDOWN_WAKEUP);
+			complete(&info->shutdown_wait);
 			break;
 #endif
 #ifdef CONFIG_CYZ_INTR
@@ -1834,7 +1766,7 @@ static void cyz_handle_cmd(struct cyclad
 			break;
 		}
 		if (delta_count)
-			cy_sched_event(info, Cy_EVENT_DELTA_WAKEUP);
+			wake_up_interruptible(&info->delta_msr_wait);
 		if (special_count)
 			tty_schedule_flip(tty);
 	}
@@ -2812,7 +2744,6 @@ static void cy_close(struct tty_struct *
 	spin_lock_irqsave(&card->card_lock, flags);
 
 	tty->closing = 0;
-	info->event = 0;
 	info->tty = NULL;
 	if (info->blocked_open) {
 		spin_unlock_irqrestore(&card->card_lock, flags);
@@ -4444,7 +4375,6 @@ static void cy_hangup(struct tty_struct 
 
 	cy_flush_buffer(tty);
 	shutdown(info);
-	info->event = 0;
 	info->count = 0;
 #ifdef CY_DEBUG_COUNT
 	printk(KERN_DEBUG "cyc:cy_hangup (%d): setting count to 0\n",
@@ -4502,7 +4432,6 @@ static int __devinit cy_init_card(struct
 		info->closing_wait = CLOSING_WAIT_DELAY;
 		info->close_delay = 5 * HZ / 10;
 
-		INIT_WORK(&info->tqueue, do_softint);
 		init_waitqueue_head(&info->open_wait);
 		init_waitqueue_head(&info->close_wait);
 		init_completion(&info->shutdown_wait);
diff -puN include/linux/cyclades.h~char-cyclades-remove-bottom-half-processing include/linux/cyclades.h
--- a/include/linux/cyclades.h~char-cyclades-remove-bottom-half-processing
+++ a/include/linux/cyclades.h
@@ -569,7 +569,6 @@ struct cyclades_port {
 	int                     x_char; /* to be pushed out ASAP */
 	int			close_delay;
 	unsigned short		closing_wait;
-	unsigned long		event;
 	int			count;	/* # of fd on device */
 	int                     breakon;
 	int                     breakoff;
@@ -584,7 +583,6 @@ struct cyclades_port {
 	struct cyclades_monitor	mon;
 	struct cyclades_idle_stats	idle_stats;
 	struct cyclades_icount	icount;
-	struct work_struct	tqueue;
 	wait_queue_head_t       open_wait;
 	wait_queue_head_t       close_wait;
 	struct completion       shutdown_wait;
@@ -592,19 +590,6 @@ struct cyclades_port {
 	int throttle;
 };
 
-/*
- * Events are used to schedule things to happen at timer-interrupt
- * time, instead of at cy interrupt time.
- */
-#define Cy_EVENT_READ_PROCESS		0
-#define Cy_EVENT_WRITE_WAKEUP		1
-#define Cy_EVENT_HANGUP			2
-#define Cy_EVENT_BREAK			3
-#define Cy_EVENT_OPEN_WAKEUP		4
-#define Cy_EVENT_SHUTDOWN_WAKEUP	5
-#define	Cy_EVENT_DELTA_WAKEUP		6
-#define	Cy_EVENT_Z_RX_FULL		7
-
 #define	CLOSING_WAIT_DELAY	30*HZ
 #define CY_CLOSING_WAIT_NONE	65535
 #define CY_CLOSING_WAIT_INF	0
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
epcac-reformat-comments-and-coding-style-improvements.patch
char-moxa-fix-and-optimise-empty-timer.patch
char-cyclades-remove-bottom-half-processing.patch
char-cyclades-make-the-isr-code-readable.patch
char-cyclades-move-spin_lock-to-one-place.patch
char-cyclades-fix-some-w-warnings.patch
shrink_slab-handle-bad-shrinkers.patch
