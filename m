From: akpm@linux-foundation.org
Subject: - track-accurate-idle-time-with-tick_schedidle_sleeptime.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:36:31 -0700
Message-ID: <200710051936.l95JaWmS021582@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60845 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761872AbXJEThH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 15:37:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: venkatesh.pallipadi@intel.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Track accurate idle time with tick_sched.idle_sleeptime
has been removed from the -mm tree.  Its filename was
     track-accurate-idle-time-with-tick_schedidle_sleeptime.patch

This patch was dropped because changes in git-acpi broke it

------------------------------------------------------
Subject: Track accurate idle time with tick_sched.idle_sleeptime
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>

Current idle time in kstat is based on jiffies and is coarse grained. 
tick_sched.idle_sleeptime is making some attempt to keep track of idle time
in a fine grained manner.  But, it is not handling the time spent in
interrupts fully.

Make tick_sched.idle_sleeptime accurate with respect to time spent on
handling interrupts and also add tick_sched.idle_lastupdate, which keeps
track of last time when idle_sleeptime was updated.

This statistics will be crucial for cpufreq-ondemand governor, which can
shed some conservative gaurd band that is uses today while setting the
frequency.  The ondemand changes that uses the exact idle time is coming
soon.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tick.h     |    6 +++
 kernel/softirq.c         |    7 +++
 kernel/time/tick-sched.c |   69 +++++++++++++++++++++++++------------
 3 files changed, 59 insertions(+), 23 deletions(-)

diff -puN include/linux/tick.h~track-accurate-idle-time-with-tick_schedidle_sleeptime include/linux/tick.h
--- a/include/linux/tick.h~track-accurate-idle-time-with-tick_schedidle_sleeptime
+++ a/include/linux/tick.h
@@ -50,8 +50,10 @@ struct tick_sched {
 	unsigned long			idle_jiffies;
 	unsigned long			idle_calls;
 	unsigned long			idle_sleeps;
+	int				idle_active;
 	ktime_t				idle_entrytime;
 	ktime_t				idle_sleeptime;
+	ktime_t				idle_lastupdate;
 	unsigned long			last_jiffies;
 	unsigned long			next_jiffies;
 	ktime_t				idle_expires;
@@ -100,10 +102,14 @@ static inline int tick_check_oneshot_cha
 extern void tick_nohz_stop_sched_tick(void);
 extern void tick_nohz_restart_sched_tick(void);
 extern void tick_nohz_update_jiffies(void);
+extern void tick_nohz_stop_idle(int cpu);
+extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
 # else
 static inline void tick_nohz_stop_sched_tick(void) { }
 static inline void tick_nohz_restart_sched_tick(void) { }
 static inline void tick_nohz_update_jiffies(void) { }
+static inline void tick_nohz_stop_idle(int cpu) { }
+static inline u64 get_cpu_idle_time_us(int cpu, u64 *unused) { return 0; }
 # endif /* !NO_HZ */
 
 #endif
diff -puN kernel/softirq.c~track-accurate-idle-time-with-tick_schedidle_sleeptime kernel/softirq.c
--- a/kernel/softirq.c~track-accurate-idle-time-with-tick_schedidle_sleeptime
+++ a/kernel/softirq.c
@@ -278,9 +278,14 @@ asmlinkage void do_softirq(void)
  */
 void irq_enter(void)
 {
+#ifdef CONFIG_NO_HZ
+	int cpu = smp_processor_id();
+	if (idle_cpu(cpu) && !in_interrupt())
+		tick_nohz_stop_idle(cpu);
+#endif
 	__irq_enter();
 #ifdef CONFIG_NO_HZ
-	if (idle_cpu(smp_processor_id()))
+	if (idle_cpu(cpu))
 		tick_nohz_update_jiffies();
 #endif
 }
diff -puN kernel/time/tick-sched.c~track-accurate-idle-time-with-tick_schedidle_sleeptime kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~track-accurate-idle-time-with-tick_schedidle_sleeptime
+++ a/kernel/time/tick-sched.c
@@ -141,6 +141,43 @@ void tick_nohz_update_jiffies(void)
 	local_irq_restore(flags);
 }
 
+void tick_nohz_stop_idle(int cpu)
+{
+	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+
+	if (ts->idle_active) {
+		ktime_t now, delta;
+		now = ktime_get();
+		delta = ktime_sub(now, ts->idle_entrytime);
+		ts->idle_lastupdate = now;
+		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
+		ts->idle_active = 0;
+	}
+}
+
+static void tick_nohz_start_idle(int cpu)
+{
+	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	ktime_t now, delta;
+
+	now = ktime_get();
+	if (ts->idle_active) {
+		delta = ktime_sub(now, ts->idle_entrytime);
+		ts->idle_lastupdate = now;
+		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
+	}
+	ts->idle_entrytime = now;
+	ts->idle_active = 1;
+}
+
+u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
+{
+	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+
+	*last_update_time = ktime_to_us(ts->idle_lastupdate);
+	return ktime_to_us(ts->idle_sleeptime);
+}
+
 /**
  * tick_nohz_stop_sched_tick - stop the idle tick from the idle task
  *
@@ -152,12 +189,13 @@ void tick_nohz_stop_sched_tick(void)
 {
 	unsigned long seq, last_jiffies, next_jiffies, delta_jiffies, flags;
 	struct tick_sched *ts;
-	ktime_t last_update, expires, now, delta;
+	ktime_t last_update, expires, now;
 	int cpu;
 
 	local_irq_save(flags);
 
 	cpu = smp_processor_id();
+	tick_nohz_start_idle(cpu);
 	ts = &per_cpu(tick_cpu_sched, cpu);
 
 	/*
@@ -189,19 +227,7 @@ void tick_nohz_stop_sched_tick(void)
 		}
 	}
 
-	now = ktime_get();
-	/*
-	 * When called from irq_exit we need to account the idle sleep time
-	 * correctly.
-	 */
-	if (ts->tick_stopped) {
-		delta = ktime_sub(now, ts->idle_entrytime);
-		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
-	}
-
-	ts->idle_entrytime = now;
 	ts->idle_calls++;
-
 	/* Read jiffies and the time when jiffies were updated last */
 	do {
 		seq = read_seqbegin(&xtime_lock);
@@ -316,23 +342,22 @@ void tick_nohz_restart_sched_tick(void)
 	int cpu = smp_processor_id();
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	unsigned long ticks;
-	ktime_t now, delta;
+	ktime_t now;
+
+	local_irq_disable();
+	tick_nohz_stop_idle(cpu);
 
-	if (!ts->tick_stopped)
+	if (!ts->tick_stopped) {
+		local_irq_enable();
 		return;
+	}
 
 	/* Update jiffies first */
-	now = ktime_get();
-
-	local_irq_disable();
 	select_nohz_load_balancer(0);
+	now = ktime_get();
 	tick_do_update_jiffies64(now);
 	cpu_clear(cpu, nohz_cpu_mask);
 
-	/* Account the idle time */
-	delta = ktime_sub(now, ts->idle_entrytime);
-	ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
-
 	/*
 	 * We stopped the tick in idle. Update process times would miss the
 	 * time we slept as update_process_times does only a 1 tick
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

git-acpi.patch
git-cpufreq.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init.patch
ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer.patch
ich-force-hpet-restructure-hpet-generic-clock-code.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-late-initialization-of-hpet-after-quirk.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch
ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch
hpet-force-enable-on-vt8235-37-chipsets.patch
track-accurate-idle-time-with-tick_schedidle_sleeptime.patch
track-accurate-idle-time-with-tick_schedidle_sleeptime-fix.patch
