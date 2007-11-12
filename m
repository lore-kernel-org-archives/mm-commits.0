From: akpm@linux-foundation.org
Subject: + char-esp-remove-hangup-and-wakeup-bottomhalves.patch added to -mm tree
Date: Mon, 12 Nov 2007 13:52:36 -0800
Message-ID: <200711122152.lACLqaV3010705@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50528 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753047AbXKLVxV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 16:53:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@redhat.com


The patch titled
     Char: esp, remove hangup and wakeup bottomhalves
has been added to the -mm tree.  Its filename is
     char-esp-remove-hangup-and-wakeup-bottomhalves.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: esp, remove hangup and wakeup bottomhalves
From: Jiri Slaby <jirislaby@gmail.com>

There is no need to schedule a bottomhalf for either of them. One is fast
and the another schedules a bottomhalf itself.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/esp.c       |   58 +++----------------------------------
 include/linux/hayesesp.h |    4 --
 2 files changed, 5 insertions(+), 57 deletions(-)

diff -puN drivers/char/esp.c~char-esp-remove-hangup-and-wakeup-bottomhalves drivers/char/esp.c
--- a/drivers/char/esp.c~char-esp-remove-hangup-and-wakeup-bottomhalves
+++ a/drivers/char/esp.c
@@ -242,17 +242,6 @@ static void rs_start(struct tty_struct *
  * -----------------------------------------------------------------------
  */
 
-/*
- * This routine is used by the interrupt handler to schedule
- * processing in the software interrupt portion of the driver.
- */
-static inline void rs_sched_event(struct esp_struct *info,
-				  int event)
-{
-	info->event |= 1 << event;
-	schedule_work(&info->tqueue);
-}
-
 static DEFINE_SPINLOCK(pio_lock);
 
 static inline struct esp_pio_buffer *get_pio_buffer(void)
@@ -474,7 +463,8 @@ static inline void transmit_chars_pio(st
 	}
 
 	if (info->xmit_cnt < WAKEUP_CHARS) {
-		rs_sched_event(info, ESP_EVENT_WRITE_WAKEUP);
+		if (info->tty)
+			tty_wakeup(info->tty);
 
 #ifdef SERIAL_DEBUG_INTR
 		printk("THRE...");
@@ -512,7 +502,8 @@ static inline void transmit_chars_dma(st
 	info->xmit_tail = (info->xmit_tail + dma_bytes) & (ESP_XMIT_SIZE - 1);
 
 	if (info->xmit_cnt < WAKEUP_CHARS) {
-		rs_sched_event(info, ESP_EVENT_WRITE_WAKEUP);
+		if (info->tty)
+			tty_wakeup(info->tty);
 
 #ifdef SERIAL_DEBUG_INTR
 		printk("THRE...");
@@ -604,7 +595,7 @@ static inline void check_modem_status(st
 #ifdef SERIAL_DEBUG_OPEN
 			printk("scheduling hangup...");
 #endif
-			schedule_work(&info->tqueue_hangup);
+			tty_hangup(info->tty);
 		}
 	}
 }
@@ -720,41 +711,6 @@ static irqreturn_t rs_interrupt_single(i
  * -------------------------------------------------------------------
  */
 
-static void do_softint(struct work_struct *work)
-{
-	struct esp_struct	*info =
-		container_of(work, struct esp_struct, tqueue);
-	struct tty_struct	*tty;
-	
-	tty = info->tty;
-	if (!tty)
-		return;
-
-	if (test_and_clear_bit(ESP_EVENT_WRITE_WAKEUP, &info->event)) {
-		tty_wakeup(tty);
-	}
-}
-
-/*
- * This routine is called from the scheduler tqueue when the interrupt
- * routine has signalled that a hangup has occurred.  The path of
- * hangup processing is:
- *
- * 	serial interrupt routine -> (scheduler tqueue) ->
- * 	do_serial_hangup() -> tty->hangup() -> esp_hangup()
- * 
- */
-static void do_serial_hangup(struct work_struct *work)
-{
-	struct esp_struct	*info =
-		container_of(work, struct esp_struct, tqueue_hangup);
-	struct tty_struct	*tty;
-	
-	tty = info->tty;
-	if (tty)
-		tty_hangup(tty);
-}
-
 /*
  * ---------------------------------------------------------------
  * Low level utility subroutines for the serial driver:  routines to
@@ -2038,7 +1994,6 @@ static void rs_close(struct tty_struct *
 		tty->driver->flush_buffer(tty);
 	tty_ldisc_flush(tty);
 	tty->closing = 0;
-	info->event = 0;
 	info->tty = NULL;
 
 	if (info->blocked_open) {
@@ -2106,7 +2061,6 @@ static void esp_hangup(struct tty_struct
 	
 	rs_flush_buffer(tty);
 	shutdown(info);
-	info->event = 0;
 	info->count = 0;
 	info->flags &= ~ASYNC_NORMAL_ACTIVE;
 	info->tty = NULL;
@@ -2492,8 +2446,6 @@ static int __init espserial_init(void)
 		info->magic = ESP_MAGIC;
 		info->close_delay = 5*HZ/10;
 		info->closing_wait = 30*HZ;
-		INIT_WORK(&info->tqueue, do_softint);
-		INIT_WORK(&info->tqueue_hangup, do_serial_hangup);
 		info->config.rx_timeout = rx_timeout;
 		info->config.flow_on = flow_on;
 		info->config.flow_off = flow_off;
diff -puN include/linux/hayesesp.h~char-esp-remove-hangup-and-wakeup-bottomhalves include/linux/hayesesp.h
--- a/include/linux/hayesesp.h~char-esp-remove-hangup-and-wakeup-bottomhalves
+++ a/include/linux/hayesesp.h
@@ -71,7 +71,6 @@ struct hayes_esp_config {
 #define ESP_STAT_NEVER_DMA      0x08
 #define ESP_STAT_USE_PIO        0x10
 
-#define ESP_EVENT_WRITE_WAKEUP	0
 #define ESP_MAGIC		0x53ee
 #define ESP_XMIT_SIZE		4096
 
@@ -92,7 +91,6 @@ struct esp_struct {
 	unsigned short		closing_wait2;
 	int			IER; 	/* Interrupt Enable Register */
 	int			MCR; 	/* Modem control register */
-	unsigned long		event;
 	unsigned long		last_active;
 	int			line;
 	int			count;	    /* # of fd on device */
@@ -101,8 +99,6 @@ struct esp_struct {
 	int			xmit_head;
 	int			xmit_tail;
 	int			xmit_cnt;
-	struct work_struct	tqueue;
-	struct work_struct	tqueue_hangup;
 	wait_queue_head_t	open_wait;
 	wait_queue_head_t	close_wait;
 	wait_queue_head_t	delta_msr_wait;
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
