From: akpm@osdl.org
Subject: - updated-hrtimers-state-tracking.patch removed from -mm tree
Date: Wed, 13 Dec 2006 14:48:41 -0800
Message-ID: <200612132248.kBDMmfFY023098@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54057 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbWLMW6s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 17:58:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ak@suse.de, akpm@osdl.org, johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     hrtimers: state tracking
has been removed from the -mm tree.  Its filename was
     updated-hrtimers-state-tracking.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: hrtimers: state tracking
From: Thomas Gleixner <tglx@linutronix.de>

Reintroduce ktimers feature "optimized away" by the ktimers review process:
multiple hrtimer states to enable the running of hrtimers without holding the
cpu-base-lock.

(The "optimized" rbtree hack carried only 2 states worth of information and we
need 4 for high resolution timers and dynamic ticks.)

Build-fixes-from: Andrew Morton <akpm@osdl.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/hrtimer.h |   36 +++++++++++++++++++++++++++++++++++-
 kernel/hrtimer.c        |   29 +++++++++++++++++++++--------
 2 files changed, 56 insertions(+), 9 deletions(-)

diff -puN include/linux/hrtimer.h~updated-hrtimers-state-tracking include/linux/hrtimer.h
--- a/include/linux/hrtimer.h~updated-hrtimers-state-tracking
+++ a/include/linux/hrtimer.h
@@ -40,6 +40,34 @@ enum hrtimer_restart {
 	HRTIMER_RESTART,	/* Timer must be restarted */
 };
 
+/*
+ * Bit values to track state of the timer
+ *
+ * Possible states:
+ *
+ * 0x00		inactive
+ * 0x01		enqueued into rbtree
+ * 0x02		callback function running
+ * 0x03		callback function running and enqueued
+ *		(was requeued on another CPU)
+ *
+ * The "callback function running and enqueued" status is only possible on
+ * SMP. It happens for example when a posix timer expired and the callback
+ * queued a signal. Between dropping the lock which protects the posix timer
+ * and reacquiring the base lock of the hrtimer, another CPU can deliver the
+ * signal and rearm the timer. We have to preserve the callback running state,
+ * as otherwise the timer could be removed before the softirq code finishes the
+ * the handling of the timer.
+ *
+ * The HRTIMER_STATE_ENQUEUE bit is always or'ed to the current state to
+ * preserve the HRTIMER_STATE_CALLBACK bit in the above scenario.
+ *
+ * All state transitions are protected by cpu_base->lock.
+ */
+#define HRTIMER_STATE_INACTIVE	0x00
+#define HRTIMER_STATE_ENQUEUED	0x01
+#define HRTIMER_STATE_CALLBACK	0x02
+
 /**
  * struct hrtimer - the basic hrtimer structure
  * @node:	red black tree node for time ordered insertion
@@ -48,6 +76,7 @@ enum hrtimer_restart {
  *		which the timer is based.
  * @function:	timer expiry callback function
  * @base:	pointer to the timer base (per cpu and per clock)
+ * @state:	state information (See bit values above)
  *
  * The hrtimer structure must be initialized by init_hrtimer_#CLOCKTYPE()
  */
@@ -56,6 +85,7 @@ struct hrtimer {
 	ktime_t				expires;
 	enum hrtimer_restart		(*function)(struct hrtimer *);
 	struct hrtimer_clock_base	*base;
+	unsigned long			state;
 };
 
 /**
@@ -141,9 +171,13 @@ extern int hrtimer_get_res(const clockid
 extern ktime_t hrtimer_get_next_event(void);
 #endif
 
+/*
+ * A timer is active, when it is enqueued into the rbtree or the callback
+ * function is running.
+ */
 static inline int hrtimer_active(const struct hrtimer *timer)
 {
-	return rb_parent(&timer->node) != &timer->node;
+	return timer->state != HRTIMER_STATE_INACTIVE;
 }
 
 /* Forward a hrtimer so it expires after now: */
diff -puN kernel/hrtimer.c~updated-hrtimers-state-tracking kernel/hrtimer.c
--- a/kernel/hrtimer.c~updated-hrtimers-state-tracking
+++ a/kernel/hrtimer.c
@@ -235,6 +235,12 @@ lock_hrtimer_base(const struct hrtimer *
 
 #endif	/* !CONFIG_SMP */
 
+static inline int hrtimer_is_queued(struct hrtimer *timer)
+{
+	return timer->state != HRTIMER_STATE_INACTIVE &&
+		timer->state != HRTIMER_STATE_CALLBACK;
+}
+
 /*
  * Functions for the union type storage format of ktime_t which are
  * too large for inlining:
@@ -385,6 +391,11 @@ static void enqueue_hrtimer(struct hrtim
 	 */
 	rb_link_node(&timer->node, parent, link);
 	rb_insert_color(&timer->node, &base->active);
+	/*
+	 * HRTIMER_STATE_ENQUEUED is or'ed to the current state to preserve the
+	 * state of a possibly running callback.
+	 */
+	timer->state |= HRTIMER_STATE_ENQUEUED;
 
 	if (!base->first || timer->expires.tv64 <
 	    rb_entry(base->first, struct hrtimer, node)->expires.tv64)
@@ -397,7 +408,8 @@ static void enqueue_hrtimer(struct hrtim
  * Caller must hold the base lock.
  */
 static void __remove_hrtimer(struct hrtimer *timer,
-			     struct hrtimer_clock_base *base)
+			     struct hrtimer_clock_base *base,
+			     unsigned long newstate)
 {
 	/*
 	 * Remove the timer from the rbtree and replace the
@@ -406,7 +418,7 @@ static void __remove_hrtimer(struct hrti
 	if (base->first == &timer->node)
 		base->first = rb_next(&timer->node);
 	rb_erase(&timer->node, &base->active);
-	rb_set_parent(&timer->node, &timer->node);
+	timer->state = newstate;
 }
 
 /*
@@ -415,8 +427,8 @@ static void __remove_hrtimer(struct hrti
 static inline int
 remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base)
 {
-	if (hrtimer_active(timer)) {
-		__remove_hrtimer(timer, base);
+	if (hrtimer_is_queued(timer)) {
+		__remove_hrtimer(timer, base, HRTIMER_STATE_INACTIVE);
 		return 1;
 	}
 	return 0;
@@ -488,7 +500,7 @@ int hrtimer_try_to_cancel(struct hrtimer
 
 	base = lock_hrtimer_base(timer, &flags);
 
-	if (base->cpu_base->curr_timer != timer)
+	if (!(timer->state & HRTIMER_STATE_CALLBACK))
 		ret = remove_hrtimer(timer, base);
 
 	unlock_hrtimer_base(timer, &flags);
@@ -593,7 +605,6 @@ void hrtimer_init(struct hrtimer *timer,
 		clock_id = CLOCK_MONOTONIC;
 
 	timer->base = &cpu_base->clock_base[clock_id];
-	rb_set_parent(&timer->node, &timer->node);
 }
 EXPORT_SYMBOL_GPL(hrtimer_init);
 
@@ -644,13 +655,14 @@ static inline void run_hrtimer_queue(str
 
 		fn = timer->function;
 		set_curr_timer(cpu_base, timer);
-		__remove_hrtimer(timer, base);
+		__remove_hrtimer(timer, base, HRTIMER_STATE_CALLBACK);
 		spin_unlock_irq(&cpu_base->lock);
 
 		restart = fn(timer);
 
 		spin_lock_irq(&cpu_base->lock);
 
+		timer->state &= ~HRTIMER_STATE_CALLBACK;
 		if (restart != HRTIMER_NORESTART) {
 			BUG_ON(hrtimer_active(timer));
 			enqueue_hrtimer(timer, base);
@@ -821,7 +833,8 @@ static void migrate_hrtimer_list(struct 
 
 	while ((node = rb_first(&old_base->active))) {
 		timer = rb_entry(node, struct hrtimer, node);
-		__remove_hrtimer(timer, old_base);
+		BUG_ON(timer->state & HRTIMER_STATE_CALLBACK);
+		__remove_hrtimer(timer, old_base, HRTIMER_STATE_INACTIVE);
 		timer->base = new_base;
 		enqueue_hrtimer(timer, new_base);
 	}
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-mtd.patch
gtod-uninline-jiffiesh.patch
gtod-fix-multiple-conversion-bugs-in-msecs_to_jiffies.patch
gtod-fix-timeout-overflow.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
dynticks-uninline-irq_enter.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-clean-up-locking.patch
hrtimers-add-state-tracking.patch
hrtimers-clean-up-callback-tracking.patch
hrtimers-move-and-add-documentation.patch
acpi-include-fix.patch
acpi-keep-track-of-timer-broadcast.patch
acpi-add-state-propagation-for-dynamic-broadcasting.patch
acpi-cleanups-allow-early-access-to-pmtimer.patch
i386-apic-clean-up-the-apic-code.patch
clockevents-core.patch
clockevents-i386-drivers.patch
clockevents-i386-hpet-driver.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
high-res-timers-core.patch
high-res-timers-core-do-itimer-rearming-in-process-context.patch
high-res-timers-allow-tsc-clocksource-if-pmtimer-present.patch
dynticks-core.patch
dynticks-add-nohz-stats-to-proc-stat.patch
dynticks-i386-support-idle-handler-callbacks.patch
dynticks-i386-prepare-nmi-watchdog.patch
high-res-timers-dynticks-i386-support-enable-in-kconfig.patch
debugging-feature-add-proc-timer_stat.patch

