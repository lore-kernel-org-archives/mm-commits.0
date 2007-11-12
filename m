From: akpm@linux-foundation.org
Subject: + char-serial167-remove-bottomhalf.patch added to -mm tree
Date: Mon, 12 Nov 2007 13:52:42 -0800
Message-ID: <200711122152.lACLqgSG010717@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34708 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753543AbXKLVx1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 16:53:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@redhat.com


The patch titled
     Char: serial167, remove bottomhalf
has been added to the -mm tree.  Its filename is
     char-serial167-remove-bottomhalf.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: serial167, remove bottomhalf
From: Jiri Slaby <jirislaby@gmail.com>

- Cy_EVENT_OPEN_WAKEUP is simple wake_up
- Cy_EVENT_HANGUP is wake_up + tty_hangup, which schedules its own work
- Cy_EVENT_WRITE_WAKEUP is tty_wakeup which may be called directly too

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/serial167.c  |   76 +++---------------------------------
 include/linux/serial167.h |   14 ------
 2 files changed, 8 insertions(+), 82 deletions(-)

diff -puN drivers/char/serial167.c~char-serial167-remove-bottomhalf drivers/char/serial167.c
--- a/drivers/char/serial167.c~char-serial167-remove-bottomhalf
+++ a/drivers/char/serial167.c
@@ -357,18 +357,6 @@ static void cy_start(struct tty_struct *
 	local_irq_restore(flags);
 }				/* cy_start */
 
-/*
- * This routine is used by the interrupt handler to schedule
- * processing in the software interrupt portion of the driver
- * (also known as the "bottom half").  This can be called any
- * number of times for any channel without harm.
- */
-static inline void cy_sched_event(struct cyclades_port *info, int event)
-{
-	info->event |= 1 << event;	/* remember what kind of event and who */
-	schedule_work(&info->tqueue);
-}				/* cy_sched_event */
-
 /* The real interrupt service routines are called
    whenever the card wants its hand held--chars
    received, out buffer empty, modem change, etc.
@@ -483,10 +471,12 @@ static irqreturn_t cd2401_modem_interrup
 		    && (info->flags & ASYNC_CHECK_CD)) {
 			if (mdm_status & CyDCD) {
 /* CP('!'); */
-				cy_sched_event(info, Cy_EVENT_OPEN_WAKEUP);
+				wake_up_interruptible(&info->open_wait);
 			} else {
 /* CP('@'); */
-				cy_sched_event(info, Cy_EVENT_HANGUP);
+				tty_hangup(info->tty);
+				wake_up_interruptible(&info->open_wait);
+				info->flags &= ~ASYNC_NORMAL_ACTIVE;
 			}
 		}
 		if ((mdm_change & CyCTS)
@@ -496,8 +486,7 @@ static irqreturn_t cd2401_modem_interrup
 					/* !!! cy_start isn't used because... */
 					info->tty->stopped = 0;
 					base_addr[CyIER] |= CyTxMpty;
-					cy_sched_event(info,
-						       Cy_EVENT_WRITE_WAKEUP);
+					tty_wakeup(info->tty);
 				}
 			} else {
 				if (!(mdm_status & CyCTS)) {
@@ -543,9 +532,6 @@ static irqreturn_t cd2401_tx_interrupt(i
 	info->last_active = jiffies;
 	if (info->tty == 0) {
 		base_addr[CyIER] &= ~(CyTxMpty | CyTxRdy);
-		if (info->xmit_cnt < WAKEUP_CHARS) {
-			cy_sched_event(info, Cy_EVENT_WRITE_WAKEUP);
-		}
 		base_addr[CyTEOIR] = CyNOTRANS;
 		return IRQ_HANDLED;
 	}
@@ -627,9 +613,9 @@ static irqreturn_t cd2401_tx_interrupt(i
 		}
 	}
 
-	if (info->xmit_cnt < WAKEUP_CHARS) {
-		cy_sched_event(info, Cy_EVENT_WRITE_WAKEUP);
-	}
+	if (info->xmit_cnt < WAKEUP_CHARS)
+		tty_wakeup(info->tty);
+
 	base_addr[CyTEOIR] = (char_count != saved_cnt) ? 0 : CyNOTRANS;
 	return IRQ_HANDLED;
 }				/* cy_tx_interrupt */
@@ -690,49 +676,6 @@ static irqreturn_t cd2401_rx_interrupt(i
 	return IRQ_HANDLED;
 }				/* cy_rx_interrupt */
 
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
-static void do_softint(struct work_struct *ugly_api)
-{
-	struct cyclades_port *info =
-	    container_of(ugly_api, struct cyclades_port, tqueue);
-	struct tty_struct *tty;
-
-	tty = info->tty;
-	if (!tty)
-		return;
-
-	if (test_and_clear_bit(Cy_EVENT_HANGUP, &info->event)) {
-		tty_hangup(info->tty);
-		wake_up_interruptible(&info->open_wait);
-		info->flags &= ~ASYNC_NORMAL_ACTIVE;
-	}
-	if (test_and_clear_bit(Cy_EVENT_OPEN_WAKEUP, &info->event)) {
-		wake_up_interruptible(&info->open_wait);
-	}
-	if (test_and_clear_bit(Cy_EVENT_WRITE_WAKEUP, &info->event)) {
-		tty_wakeup(tty);
-	}
-}				/* do_softint */
-
 /* This is called whenever a port becomes active;
    interrupts are enabled and DTR & RTS are turned on.
  */
@@ -1743,7 +1686,6 @@ static void cy_close(struct tty_struct *
 	if (tty->driver->flush_buffer)
 		tty->driver->flush_buffer(tty);
 	tty_ldisc_flush(tty);
-	info->event = 0;
 	info->tty = NULL;
 	if (info->blocked_open) {
 		if (info->close_delay) {
@@ -2234,7 +2176,6 @@ static int __init serial167_init(void)
 				info->rco = baud_co[DefSpeed] >> 5;	/* Rx CO */
 				info->close_delay = 0;
 				info->x_char = 0;
-				info->event = 0;
 				info->count = 0;
 #ifdef SERIAL_DEBUG_COUNT
 				printk("cyc: %d: setting count to 0\n",
@@ -2243,7 +2184,6 @@ static int __init serial167_init(void)
 				info->blocked_open = 0;
 				info->default_threshold = 0;
 				info->default_timeout = 0;
-				INIT_WORK(&info->tqueue, do_softint);
 				init_waitqueue_head(&info->open_wait);
 				init_waitqueue_head(&info->close_wait);
 				/* info->session */
diff -puN include/linux/serial167.h~char-serial167-remove-bottomhalf include/linux/serial167.h
--- a/include/linux/serial167.h~char-serial167-remove-bottomhalf
+++ a/include/linux/serial167.h
@@ -37,7 +37,6 @@ struct cyclades_port {
 	int			ignore_status_mask;
 	int			close_delay;
 	int			IER; 	/* Interrupt Enable Register */
-	unsigned long		event;
 	unsigned long		last_active;
 	int			count;	/* # of fd on device */
 	int                     x_char; /* to be pushed out ASAP */
@@ -49,7 +48,6 @@ struct cyclades_port {
 	int			xmit_cnt;
         int                     default_threshold;
         int                     default_timeout;
-	struct work_struct	tqueue;
 	wait_queue_head_t	open_wait;
 	wait_queue_head_t	close_wait;
         struct cyclades_monitor mon;
@@ -67,18 +65,6 @@ struct cyclades_port {
 #define CYGETDEFTIMEOUT         0x435908
 #define CYSETDEFTIMEOUT         0x435909
 
-/*
- * Events are used to schedule things to happen at timer-interrupt
- * time, instead of at cy interrupt time.
- */
-#define Cy_EVENT_READ_PROCESS	0
-#define Cy_EVENT_WRITE_WAKEUP	1
-#define Cy_EVENT_HANGUP		2
-#define Cy_EVENT_BREAK		3
-#define Cy_EVENT_OPEN_WAKEUP	4
-
-
-
 #define CyMaxChipsPerCard 1
 
 /**** cd2401 registers ****/
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
