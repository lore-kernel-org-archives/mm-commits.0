From: akpm@linux-foundation.org
Subject: + cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4.patch added to -mm tree
Date: Wed, 16 Jun 2010 23:59:23 -0700
Message-ID: <201006170659.o5H6xHp4019456@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41641 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754822Ab0FQG7c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jun 2010 02:59:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sergey.senozhatsky@gmail.com, arjan@infradead.org, jslaby@suse.cz, len.brown@intel.com, maximlevitsky@gmail.com, pavel@ucw.cz, rjw@sisk.pl


The patch titled
     cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4
has been added to the -mm tree.  Its filename is
     cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tick.h     |    1 +
 kernel/time/tick-sched.c |   25 +++++++++++++------------
 2 files changed, 14 insertions(+), 12 deletions(-)

diff -puN include/linux/tick.h~cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4 include/linux/tick.h
--- a/include/linux/tick.h~cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4
+++ a/include/linux/tick.h
@@ -51,6 +51,7 @@ struct tick_sched {
 	unsigned long			check_clocks;
 	enum tick_nohz_mode		nohz_mode;
 	ktime_t				idle_tick;
+	int				cpu;
 	int				inidle;
 	int				tick_stopped;
 	unsigned long			idle_jiffies;
diff -puN kernel/time/tick-sched.c~cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4 kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4
+++ a/kernel/time/tick-sched.c
@@ -38,6 +38,9 @@ static ktime_t last_jiffies_update;
 
 struct tick_sched *tick_get_tick_sched(int cpu)
 {
+	/*FIXME: Arjan van de Ven:
+	 can we do this bit once, when the ts structure gets initialized?*/
+	per_cpu(tick_cpu_sched, cpu).cpu = cpu;
 	return &per_cpu(tick_cpu_sched, cpu);
 }
 
@@ -137,7 +140,7 @@ __setup("nohz=", setup_tick_nohz);
 static void tick_nohz_update_jiffies(ktime_t now)
 {
 	int cpu = smp_processor_id();
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	struct tick_sched *ts = tick_get_tick_sched(cpu);
 	unsigned long flags;
 
 	cpumask_clear_cpu(cpu, nohz_cpu_mask);
@@ -159,12 +162,10 @@ update_ts_time_stats(struct tick_sched *
 	ktime_t delta;
 
 	if (ts->idle_active) {
-		int cpu = get_cpu();
 		delta = ktime_sub(now, ts->idle_entrytime);
 		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
-		if (nr_iowait_cpu(cpu) > 0)
+		if (nr_iowait_cpu(ts->cpu) > 0)
 			ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
-		put_cpu();
 		ts->idle_entrytime = now;
 	}
 
@@ -175,7 +176,7 @@ update_ts_time_stats(struct tick_sched *
 
 static void tick_nohz_stop_idle(int cpu, ktime_t now)
 {
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	struct tick_sched *ts = tick_get_tick_sched(cpu);
 
 	update_ts_time_stats(ts, now, NULL);
 	ts->idle_active = 0;
@@ -213,7 +214,7 @@ static ktime_t tick_nohz_start_idle(stru
  */
 u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 {
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	struct tick_sched *ts = tick_get_tick_sched(cpu);
 
 	if (!tick_nohz_enabled)
 		return -1;
@@ -239,7 +240,7 @@ EXPORT_SYMBOL_GPL(get_cpu_idle_time_us);
  */
 u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
 {
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	struct tick_sched *ts = tick_get_tick_sched(cpu);
 
 	if (!tick_nohz_enabled)
 		return -1;
@@ -269,7 +270,7 @@ void tick_nohz_stop_sched_tick(int inidl
 	local_irq_save(flags);
 
 	cpu = smp_processor_id();
-	ts = &per_cpu(tick_cpu_sched, cpu);
+	ts = tick_get_tick_sched(cpu);
 
 	/*
 	 * Call to tick_nohz_start_idle stops the last_update_time from being
@@ -510,7 +511,7 @@ static void tick_nohz_restart(struct tic
 void tick_nohz_restart_sched_tick(void)
 {
 	int cpu = smp_processor_id();
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	struct tick_sched *ts = tick_get_tick_sched(cpu);
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
 	unsigned long ticks;
 #endif
@@ -673,7 +674,7 @@ static void tick_nohz_kick_tick(int cpu,
 #if 0
 	/* Switch back to 2.6.27 behaviour */
 
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	struct tick_sched *ts = tick_get_tick_sched(cpu);
 	ktime_t delta;
 
 	/*
@@ -690,7 +691,7 @@ static void tick_nohz_kick_tick(int cpu,
 
 static inline void tick_check_nohz(int cpu)
 {
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	struct tick_sched *ts = tick_get_tick_sched(cpu);
 	ktime_t now;
 
 	if (!ts->idle_active && !ts->tick_stopped)
@@ -820,7 +821,7 @@ void tick_setup_sched_timer(void)
 #if defined CONFIG_NO_HZ || defined CONFIG_HIGH_RES_TIMERS
 void tick_cancel_sched_timer(int cpu)
 {
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	struct tick_sched *ts = tick_get_tick_sched(cpu);
 
 # ifdef CONFIG_HIGH_RES_TIMERS
 	if (ts->sched_timer.base)
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu.patch
cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4.patch
cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4-fix.patch

