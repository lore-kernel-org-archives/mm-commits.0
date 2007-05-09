From: akpm@linux-foundation.org
Subject: - highres-dyntick-prevent-xtime-lock-contention.patch removed from -mm tree
Date: Tue, 08 May 2007 19:50:10 -0700
Message-ID: <200705090250.l492oAqH009320@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34624 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032160AbXEICvi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:51:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, mingo@elte.hu, mlord@pobox.com, rostedt@goodmis.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     highres/dyntick: prevent xtime lock contention
has been removed from the -mm tree.  Its filename was
     highres-dyntick-prevent-xtime-lock-contention.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: highres/dyntick: prevent xtime lock contention
From: Thomas Gleixner <tglx@linutronix.de>

While the !highres/!dyntick code assigns the duty of the do_timer() call to
one specific CPU, this was dropped in the highres/dyntick part during
development.

Steven Rostedt discovered the xtime lock contention on highres/dyntick due
to several CPUs trying to update jiffies.

Add the single CPU assignement back.  In the dyntick case this needs to be
handled carefully, as the CPU which has the do_timer() duty must drop the
assignement and let it be grabbed by another CPU, which is active. 
Otherwise the do_timer() calls would not happen during the long sleep.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Mark Lord <mlord@pobox.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/tick-common.c   |    8 +++++-
 kernel/time/tick-internal.h |    1 
 kernel/time/tick-sched.c    |   42 ++++++++++++++++++++++++++++++++--
 3 files changed, 48 insertions(+), 3 deletions(-)

diff -puN kernel/time/tick-common.c~highres-dyntick-prevent-xtime-lock-contention kernel/time/tick-common.c
--- a/kernel/time/tick-common.c~highres-dyntick-prevent-xtime-lock-contention
+++ a/kernel/time/tick-common.c
@@ -31,7 +31,7 @@ DEFINE_PER_CPU(struct tick_device, tick_
  */
 ktime_t tick_next_period;
 ktime_t tick_period;
-static int tick_do_timer_cpu = -1;
+int tick_do_timer_cpu __read_mostly = -1;
 DEFINE_SPINLOCK(tick_device_lock);
 
 /*
@@ -295,6 +295,12 @@ static void tick_shutdown(unsigned int *
 		clockevents_exchange_device(dev, NULL);
 		td->evtdev = NULL;
 	}
+	/* Transfer the do_timer job away from this cpu */
+	if (*cpup == tick_do_timer_cpu) {
+		int cpu = first_cpu(cpu_online_map);
+
+		tick_do_timer_cpu = (cpu != NR_CPUS) ? cpu : -1;
+	}
 	spin_unlock_irqrestore(&tick_device_lock, flags);
 }
 
diff -puN kernel/time/tick-internal.h~highres-dyntick-prevent-xtime-lock-contention kernel/time/tick-internal.h
--- a/kernel/time/tick-internal.h~highres-dyntick-prevent-xtime-lock-contention
+++ a/kernel/time/tick-internal.h
@@ -5,6 +5,7 @@ DECLARE_PER_CPU(struct tick_device, tick
 extern spinlock_t tick_device_lock;
 extern ktime_t tick_next_period;
 extern ktime_t tick_period;
+extern int tick_do_timer_cpu __read_mostly;
 
 extern void tick_setup_periodic(struct clock_event_device *dev, int broadcast);
 extern void tick_handle_periodic(struct clock_event_device *dev);
diff -puN kernel/time/tick-sched.c~highres-dyntick-prevent-xtime-lock-contention kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~highres-dyntick-prevent-xtime-lock-contention
+++ a/kernel/time/tick-sched.c
@@ -221,6 +221,18 @@ void tick_nohz_stop_sched_tick(void)
 			ts->tick_stopped = 1;
 			ts->idle_jiffies = last_jiffies;
 		}
+
+		/*
+		 * If this cpu is the one which updates jiffies, then
+		 * give up the assignment and let it be taken by the
+		 * cpu which runs the tick timer next, which might be
+		 * this cpu as well. If we don't drop this here the
+		 * jiffies might be stale and do_timer() never
+		 * invoked.
+		 */
+		if (cpu == tick_do_timer_cpu)
+			tick_do_timer_cpu = -1;
+
 		/*
 		 * calculate the expiry time for the next timer wheel
 		 * timer
@@ -338,12 +350,24 @@ static void tick_nohz_handler(struct clo
 {
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 	struct pt_regs *regs = get_irq_regs();
+	int cpu = smp_processor_id();
 	ktime_t now = ktime_get();
 
 	dev->next_event.tv64 = KTIME_MAX;
 
+	/*
+	 * Check if the do_timer duty was dropped. We don't care about
+	 * concurrency: This happens only when the cpu in charge went
+	 * into a long sleep. If two cpus happen to assign themself to
+	 * this duty, then the jiffies update is still serialized by
+	 * xtime_lock.
+	 */
+	if (unlikely(tick_do_timer_cpu == -1))
+		tick_do_timer_cpu = cpu;
+
 	/* Check, if the jiffies need an update */
-	tick_do_update_jiffies64(now);
+	if (tick_do_timer_cpu == cpu)
+		tick_do_update_jiffies64(now);
 
 	/*
 	 * When we are idle and the tick is stopped, we have to touch
@@ -431,9 +455,23 @@ static enum hrtimer_restart tick_sched_t
 	struct hrtimer_cpu_base *base = timer->base->cpu_base;
 	struct pt_regs *regs = get_irq_regs();
 	ktime_t now = ktime_get();
+	int cpu = smp_processor_id();
+
+#ifdef CONFIG_NO_HZ
+	/*
+	 * Check if the do_timer duty was dropped. We don't care about
+	 * concurrency: This happens only when the cpu in charge went
+	 * into a long sleep. If two cpus happen to assign themself to
+	 * this duty, then the jiffies update is still serialized by
+	 * xtime_lock.
+	 */
+	if (unlikely(tick_do_timer_cpu == -1))
+		tick_do_timer_cpu = cpu;
+#endif
 
 	/* Check, if the jiffies need an update */
-	tick_do_update_jiffies64(now);
+	if (tick_do_timer_cpu == cpu)
+		tick_do_update_jiffies64(now);
 
 	/*
 	 * Do not call, when we are not in irq context and have
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
arm-spinlock-initializer-cleanup.patch
git-avr32.patch
drm-spinlock-initializer-cleanup.patch
git-dvb.patch
git-ieee1394.patch
git-mtd.patch
s390-spinlock-initializer-cleanup.patch
fix-printk-format-warnings-in-timer_listc.patch
blacklist-dell-optiplex-320-from-using-the-hpet.patch
blacklist-dell-optiplex-320-from-using-the-hpet-fix.patch
declare-struct-ktime.patch
timer-parenthesis-fix-in-tbase_get_deferrable-etc.patch
clocksource-fix-resume-logic.patch
clockevents-fix-resume-logic-updated-version.patch
timer_stats-slimmed-down-using-statistics-infrastucture.patch
