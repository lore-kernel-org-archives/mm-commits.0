From: akpm@osdl.org
Subject: + updated-high-res-timers-core-cleanup-state-tracking-update.patch added to -mm tree
Date: Mon, 11 Dec 2006 13:34:07 -0800
Message-ID: <200612112134.kBBLY7MF008319@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:38878 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763080AbWLKVeP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Dec 2006 16:34:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu


The patch titled
     hrtimers: cleanup, state tracking update
has been added to the -mm tree.  Its filename is
     updated-high-res-timers-core-cleanup-state-tracking-update.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hrtimers: cleanup, state tracking update
From: Thomas Gleixner <tglx@linutronix.de>

Cleanup: address the issues which were pointed out by Arjan's review.  Add
inline functions to access the state and fix comments.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/hrtimer.h |    7 +++---
 kernel/hrtimer.c        |   44 +++++++++++++++++++++++++-------------
 2 files changed, 33 insertions(+), 18 deletions(-)

diff -puN include/linux/hrtimer.h~updated-high-res-timers-core-cleanup-state-tracking-update include/linux/hrtimer.h
--- a/include/linux/hrtimer.h~updated-high-res-timers-core-cleanup-state-tracking-update
+++ a/include/linux/hrtimer.h
@@ -59,17 +59,18 @@ enum hrtimer_cb_mode {
 };
 
 /*
- * Bit values to track state of the timer
+ * Values to track state of the timer
  *
  * Possible states:
  *
  * 0x00		inactive
  * 0x01		enqueued into rbtree
  * 0x02		callback function running
- * 0x03		callback function running and enqueued
- *		(was requeued on another CPU)
  * 0x04		callback pending (high resolution mode)
  *
+ * Special case:
+ * 0x03		callback function running and enqueued
+ *		(was requeued on another CPU)
  * The "callback function running and enqueued" status is only possible on
  * SMP. It happens for example when a posix timer expired and the callback
  * queued a signal. Between dropping the lock which protects the posix timer
diff -puN kernel/hrtimer.c~updated-high-res-timers-core-cleanup-state-tracking-update kernel/hrtimer.c
--- a/kernel/hrtimer.c~updated-high-res-timers-core-cleanup-state-tracking-update
+++ a/kernel/hrtimer.c
@@ -151,6 +151,24 @@ static void hrtimer_get_softirq_time(str
 }
 
 /*
+ * Helper function to check, whether the timer is on one of the queues
+ */
+static inline int hrtimer_is_queued(struct hrtimer *timer)
+{
+	return timer->state &
+		(HRTIMER_STATE_ENQUEUED || HRTIMER_STATE_PENDING);
+}
+
+/*
+ * Helper function to check, whether the timer is running the callback
+ * function
+ */
+static inline int hrtimer_callback_running(struct hrtimer *timer)
+{
+	return timer->state & HRTIMER_STATE_CALLBACK;
+}
+
+/*
  * Functions and macros which are different for UP/SMP systems are kept in a
  * single place
  */
@@ -209,7 +227,7 @@ switch_hrtimer_base(struct hrtimer *time
 		 * completed. There is no conflict as we hold the lock until
 		 * the timer is enqueued.
 		 */
-		if (unlikely(timer->state & HRTIMER_STATE_CALLBACK))
+		if (unlikely(hrtimer_callback_running(timer)))
 			return base;
 
 		/* See the comment in lock_timer_base() */
@@ -237,12 +255,6 @@ lock_hrtimer_base(const struct hrtimer *
 
 #endif	/* !CONFIG_SMP */
 
-static inline int hrtimer_is_queued(struct hrtimer *timer)
-{
-	return timer->state != HRTIMER_STATE_INACTIVE &&
-		timer->state != HRTIMER_STATE_CALLBACK;
-}
-
 /*
  * Functions for the union type storage format of ktime_t which are
  * too large for inlining:
@@ -385,7 +397,7 @@ static int hrtimer_reprogram(struct hrti
 	 * reprogramming is handled either by the softirq, which called the
 	 * callback or at the end of the hrtimer_interrupt.
 	 */
-	if (timer->state & HRTIMER_STATE_CALLBACK)
+	if (hrtimer_callback_running(timer))
 		return 0;
 
 	if (expires.tv64 >= expires_next->tv64)
@@ -614,7 +626,7 @@ static void hrtimer_check_clocks(void)
  */
 static inline int hrtimer_cb_pending(const struct hrtimer *timer)
 {
-	return timer->state == HRTIMER_STATE_PENDING;
+	return timer->state & HRTIMER_STATE_PENDING;
 }
 
 /*
@@ -964,7 +976,7 @@ int hrtimer_try_to_cancel(struct hrtimer
 
 	base = lock_hrtimer_base(timer, &flags);
 
-	if (!(timer->state & HRTIMER_STATE_CALLBACK))
+	if (!hrtimer_callback_running(timer))
 		ret = remove_hrtimer(timer, base);
 
 	unlock_hrtimer_base(timer, &flags);
@@ -1153,12 +1165,14 @@ void hrtimer_interrupt(struct pt_regs *r
 			__remove_hrtimer(timer, base,
 					 HRTIMER_STATE_CALLBACK, 0);
 
+			/*
+			 * Note: We clear the CALLBACK bit after
+			 * enqueue_hrtimer to avoid reprogramming of
+			 * the event hardware. This happens at the end
+			 * of this function anyway.
+			 */
 			if (timer->function(timer) != HRTIMER_NORESTART) {
 				BUG_ON(timer->state != HRTIMER_STATE_CALLBACK);
-				/*
-				 * Do not reprogram. We do this when we break
-				 * out of the loop !
-				 */
 				enqueue_hrtimer(timer, base, 0);
 			}
 			timer->state &= ~HRTIMER_STATE_CALLBACK;
@@ -1442,7 +1456,7 @@ static void migrate_hrtimer_list(struct 
 
 	while ((node = rb_first(&old_base->active))) {
 		timer = rb_entry(node, struct hrtimer, node);
-		BUG_ON(timer->state & HRTIMER_STATE_CALLBACK);
+		BUG_ON(hrtimer_callback_running(timer));
 		__remove_hrtimer(timer, old_base, HRTIMER_STATE_INACTIVE, 0);
 		timer->base = new_base;
 		/*
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-mtd.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
gtod-persistent-clock-support-i386-i386-unexport-read_persistent_clock.patch
time-uninline-jiffiesh.patch
time-uninline-jiffiesh-fix.patch
time-fix-msecs_to_jiffies-bug.patch
time-fix-timeout-overflow.patch
cleanup-uninline-irq_enter-and-move-it-into-a-function.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie-remove-incorrect-warning-in-kernel-timerc.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-clean-up-locking.patch
hrtimers-clean-up-locking-fix.patch
updated-hrtimers-state-tracking.patch
updated-hrtimers-clean-up-callback-tracking.patch
updated-hrtimers-move-and-add-documentation.patch
updated-add-a-framework-to-manage-clock-event-devices.patch
updated-add-a-framework-to-manage-clock-event-devices-next_event-calculation-fix.patch
updated-add-a-framework-to-manage-clock-event-devices-pit-broadcasting-fix.patch
updated-acpi-include-apich.patch
updated-acpi-keep-track-of-timer-broadcast.patch
updated-acpi-add-state-propagation-for-dynamic-broadcasting.patch
updated-i386-cleanup-apic-code.patch
updated-i386-convert-to-clock-event-devices.patch
updated-i386-convert-to-clock-event-devices-fix.patch
updated-i386-convert-to-clock-event-devices-arch-i386-kernel-apicc-make-a-function-static.patch
updated-i386-convert-to-clock-event-devices-remove-arch-i386-kernel-time_hpetchpet_reenable.patch
updated-pm_timer-allow-early-access-and-move-externs-to-a-header-file.patch
updated-i386-rework-local-apic-calibration.patch
updated-high-res-timers-core.patch
updated-high-res-timers-core-high-res-timers-do-itimer-rearming-in-process-context.patch
updated-high-res-timers-core-cleanup-state-tracking-update.patch
updated-gtod-mark-tsc-unusable-for-highres-timers.patch
high-res-timers-utilize-tsc-clocksource-again.patch
high-res-timers-utilize-tsc-clocksource-again-fix.patch
updated-dynticks-core-code.patch
updated-dyntick-add-nohz-stats-to-proc-stat.patch
updated-dynticks-i386-arch-code.patch
updated-dynticks-fix-nmi-watchdog.patch
updated-high-res-timers-dynticks-enable-i386-support.patch
updated-debugging-feature-timer-stats.patch
clockevents-core-check-for-clock-event-device-handler-being-non-null-before-calling-it.patch
clockevents-convert-hpet-to-clockevents.patch
clockevents-make-apicc-exports-gpl-remove-fastcall-attributes.patch
clockevents-i8253c-remove-hpet-dependencies.patch
clockevents-remove-ptregs-argument-from-handlers.patch

