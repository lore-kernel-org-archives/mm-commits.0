From: akpm@linux-foundation.org
Subject: - char-esp-remove-hangup-and-wakeup-bottomhalves.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:09:40 -0800
Message-ID: <200802080809.m1889LS9014821@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36894 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761370AbYBHITk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Char: esp, remove hangup and wakeup bottomhalves
has been removed from the -mm tree.  Its filename was
     char-esp-remove-hangup-and-wakeup-bottomhalves.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
