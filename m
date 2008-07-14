From: akpm@linux-foundation.org
Subject: - sched_clock-stop-maximum-check-on-no-hz.patch removed from -mm tree
Date: Mon, 14 Jul 2008 12:36:02 -0700
Message-ID: <200807141936.m6EJa2uD024059@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755355AbYGNTgm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jul 2008 15:36:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, mingo@elte.hu, peterz@infradead.org, srostedt@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     sched_clock: stop maximum check on NO HZ
has been removed from the -mm tree.  Its filename was
     sched_clock-stop-maximum-check-on-no-hz.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sched_clock: stop maximum check on NO HZ
From: Steven Rostedt <rostedt@goodmis.org>

Working with ftrace I would get large jumps of 11 millisecs or more with
the clock tracer.  This killed the latencing timings of ftrace and also
caused the irqoff self tests to fail.

What was happening is with NO_HZ the idle would stop the jiffy counter and
before the jiffy counter was updated the sched_clock would have a bad
delta jiffies to compare with the gtod with the maximum.

The jiffies would stop and the last sched_tick would record the last gtod.
 On wakeup, the sched clock update would compare the gtod + delta jiffies
(which would be zero) and compare it to the TSC.  The TSC would have
correctly (with a stable TSC) moved forward several jiffies.  But because
the jiffies has not been updated yet the clock would be prevented from
moving forward because it would appear that the TSC jumped too far ahead.

The clock would then virtually stop, until the jiffies are updated.  Then
the next sched clock update would see that the clock was very much behind
since the delta jiffies is now correct.  This would then jump the clock
forward by several jiffies.

This caused ftrace to report several milliseconds of interrupts off
latency at every resume from NO_HZ idle.

This patch adds hooks into the nohz code to disable the checking of the
maximum clock update when nohz is in effect.  It resumes the max check
when nohz has updated the jiffies again.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h    |   17 +++++++++++++++-
 kernel/sched_clock.c     |   39 ++++++++++++++++++++++++++++++++++++-
 kernel/time/tick-sched.c |    2 +
 3 files changed, 56 insertions(+), 2 deletions(-)

diff -puN include/linux/sched.h~sched_clock-stop-maximum-check-on-no-hz include/linux/sched.h
--- a/include/linux/sched.h~sched_clock-stop-maximum-check-on-no-hz
+++ a/include/linux/sched.h
@@ -1561,13 +1561,28 @@ static inline void sched_clock_idle_slee
 static inline void sched_clock_idle_wakeup_event(u64 delta_ns)
 {
 }
-#else
+
+#ifdef CONFIG_NO_HZ
+static inline void sched_clock_tick_stop(int cpu)
+{
+}
+
+static inline void sched_clock_tick_start(int cpu)
+{
+}
+#endif
+
+#else /* CONFIG_HAVE_UNSTABLE_SCHED_CLOCK */
 extern void sched_clock_init(void);
 extern u64 sched_clock_cpu(int cpu);
 extern void sched_clock_tick(void);
 extern void sched_clock_idle_sleep_event(void);
 extern void sched_clock_idle_wakeup_event(u64 delta_ns);
+#ifdef CONFIG_NO_HZ
+extern void sched_clock_tick_stop(int cpu);
+extern void sched_clock_tick_start(int cpu);
 #endif
+#endif /* CONFIG_HAVE_UNSTABLE_SCHED_CLOCK */
 
 /*
  * For kernel-internal use: high-speed (but slightly incorrect) per-cpu
diff -puN kernel/sched_clock.c~sched_clock-stop-maximum-check-on-no-hz kernel/sched_clock.c
--- a/kernel/sched_clock.c~sched_clock-stop-maximum-check-on-no-hz
+++ a/kernel/sched_clock.c
@@ -45,6 +45,9 @@ struct sched_clock_data {
 	u64			tick_raw;
 	u64			tick_gtod;
 	u64			clock;
+#ifdef CONFIG_NO_HZ
+	int			check_max;
+#endif
 };
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct sched_clock_data, sched_clock_data);
@@ -76,11 +79,45 @@ void sched_clock_init(void)
 		scd->tick_raw = 0;
 		scd->tick_gtod = ktime_now;
 		scd->clock = ktime_now;
+#ifdef CONFIG_NO_HZ
+		scd->check_max = 1;
+#endif
 	}
 
 	sched_clock_running = 1;
 }
 
+#ifdef CONFIG_NO_HZ
+/*
+ * The dynamic ticks makes the delta jiffies inaccurate. This
+ * prevents us from checking the maximum time update.
+ * Disable the maximum check during stopped ticks.
+ */
+void sched_clock_tick_stop(int cpu)
+{
+	struct sched_clock_data *scd = cpu_sdc(cpu);
+
+	scd->check_max = 0;
+}
+
+void sched_clock_tick_start(int cpu)
+{
+	struct sched_clock_data *scd = cpu_sdc(cpu);
+
+	scd->check_max = 1;
+}
+
+static int check_max(struct sched_clock_data *scd)
+{
+	return scd->check_max;
+}
+#else
+static int check_max(struct sched_clock_data *scd)
+{
+	return 1;
+}
+#endif /* CONFIG_NO_HZ */
+
 /*
  * update the percpu scd from the raw @now value
  *
@@ -112,7 +149,7 @@ static void __update_sched_clock(struct 
 	 */
 	max_clock = scd->tick_gtod + (2 + delta_jiffies) * TICK_NSEC;
 
-	if (unlikely(clock + delta > max_clock)) {
+	if (unlikely(clock + delta > max_clock) && check_max(scd)) {
 		if (clock < max_clock)
 			clock = max_clock;
 		else
diff -puN kernel/time/tick-sched.c~sched_clock-stop-maximum-check-on-no-hz kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~sched_clock-stop-maximum-check-on-no-hz
+++ a/kernel/time/tick-sched.c
@@ -294,6 +294,7 @@ void tick_nohz_stop_sched_tick(void)
 			ts->tick_stopped = 1;
 			ts->idle_jiffies = last_jiffies;
 			rcu_enter_nohz();
+			sched_clock_tick_stop(cpu);
 		}
 
 		/*
@@ -389,6 +390,7 @@ void tick_nohz_restart_sched_tick(void)
 	select_nohz_load_balancer(0);
 	now = ktime_get();
 	tick_do_update_jiffies64(now);
+	sched_clock_tick_start(cpu);
 	cpu_clear(cpu, nohz_cpu_mask);
 
 	/*
_

Patches currently in -mm which might be from rostedt@goodmis.org are

linux-next.patch
ftrace-disable-function-tracing-bringing-up-new-cpu.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix.patch

