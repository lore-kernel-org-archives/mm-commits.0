From: akpm@linux-foundation.org
Subject: + sched-introduce-get_cpu_iowait_time_us.patch added to -mm tree
Date: Mon, 19 Apr 2010 15:35:44 -0700
Message-ID: <201004192235.o3JMZi76013702@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56635 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752746Ab0DSWfr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Apr 2010 18:35:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com


The patch titled
     sched: introduce get_cpu_iowait_time_us()
has been added to the -mm tree.  Its filename is
     sched-introduce-get_cpu_iowait_time_us.patch

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
Subject: sched: introduce get_cpu_iowait_time_us()
From: Arjan van de Ven <arjan@linux.intel.com>

For the ondemand cpufreq governor, it is desired that the iowait
time is microaccounted in a similar way as idle time is.

This patch introduces the infrastructure to account and expose
this information via the get_cpu_iowait_time_us() function.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tick.h     |    4 ++++
 kernel/time/tick-sched.c |   28 ++++++++++++++++++++++++++++
 kernel/time/timer_list.c |    1 +
 3 files changed, 33 insertions(+)

diff -puN include/linux/tick.h~sched-introduce-get_cpu_iowait_time_us include/linux/tick.h
--- a/include/linux/tick.h~sched-introduce-get_cpu_iowait_time_us
+++ a/include/linux/tick.h
@@ -42,6 +42,7 @@ enum tick_nohz_mode {
  * @idle_waketime:	Time when the idle was interrupted
  * @idle_exittime:	Time when the idle state was left
  * @idle_sleeptime:	Sum of the time slept in idle with sched tick stopped
+ * @iowait_sleeptime:	Sum of the time slept in idle with sched tick stopped, with IO outstanding
  * @sleep_length:	Duration of the current idle sleep
  * @do_timer_lst:	CPU was the last one doing do_timer before going idle
  */
@@ -60,6 +61,7 @@ struct tick_sched {
 	ktime_t				idle_waketime;
 	ktime_t				idle_exittime;
 	ktime_t				idle_sleeptime;
+	ktime_t				iowait_sleeptime;
 	ktime_t				sleep_length;
 	unsigned long			last_jiffies;
 	unsigned long			next_jiffies;
@@ -123,6 +125,7 @@ extern void tick_nohz_stop_sched_tick(in
 extern void tick_nohz_restart_sched_tick(void);
 extern ktime_t tick_nohz_get_sleep_length(void);
 extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
+extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
 # else
 static inline void tick_nohz_stop_sched_tick(int inidle) { }
 static inline void tick_nohz_restart_sched_tick(void) { }
@@ -133,6 +136,7 @@ static inline ktime_t tick_nohz_get_slee
 	return len;
 }
 static inline u64 get_cpu_idle_time_us(int cpu, u64 *unused) { return -1; }
+static inline u64 get_cpu_iowait(int cpu, u64 *unused) { return -1; }
 # endif /* !NO_HZ */
 
 #endif
diff -puN kernel/time/tick-sched.c~sched-introduce-get_cpu_iowait_time_us kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~sched-introduce-get_cpu_iowait_time_us
+++ a/kernel/time/tick-sched.c
@@ -161,6 +161,8 @@ update_ts_time_stats(struct tick_sched *
 	if (ts->idle_active) {
 		delta = ktime_sub(now, ts->idle_entrytime);
 		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
+		if (nr_iowait_cpu() > 0)
+			ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
 		ts->idle_entrytime = now;
 	}
 
@@ -220,6 +222,32 @@ u64 get_cpu_idle_time_us(int cpu, u64 *l
 }
 EXPORT_SYMBOL_GPL(get_cpu_idle_time_us);
 
+/*
+ * get_cpu_iowait_time_us - get the total iowait time of a cpu
+ * @cpu: CPU number to query
+ * @last_update_time: variable to store update time in
+ *
+ * Return the cummulative iowait time (since boot) for a given
+ * CPU, in microseconds.
+ *
+ * This time is measured via accounting rather than sampling,
+ * and is as accurate as ktime_get() is.
+ *
+ * This function returns -1 if NOHZ is not enabled.
+ */
+u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
+{
+	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+
+	if (!tick_nohz_enabled)
+		return -1;
+
+	update_ts_time_stats(ts, ktime_get(), last_update_time);
+
+	return ktime_to_us(ts->iowait_sleeptime);
+}
+EXPORT_SYMBOL_GPL(get_cpu_iowait_time_us);
+
 /**
  * tick_nohz_stop_sched_tick - stop the idle tick from the idle task
  *
diff -puN kernel/time/timer_list.c~sched-introduce-get_cpu_iowait_time_us kernel/time/timer_list.c
--- a/kernel/time/timer_list.c~sched-introduce-get_cpu_iowait_time_us
+++ a/kernel/time/timer_list.c
@@ -176,6 +176,7 @@ static void print_cpu(struct seq_file *m
 		P_ns(idle_waketime);
 		P_ns(idle_exittime);
 		P_ns(idle_sleeptime);
+		P_ns(iowait_sleeptime);
 		P(last_jiffies);
 		P(next_jiffies);
 		P_ns(idle_expires);
_

Patches currently in -mm which might be from arjan@linux.intel.com are

linux-next.patch
sched-add-a-comment-to-get_cpu_idle_time_us.patch
sched-introduce-a-function-to-update-the-idle-statistics.patch
sched-update-the-idle-statistics-in-get_cpu_idle_time_us.patch
sched-fold-updating-of-the-last-update-time-into-update_ts_time_stats.patch
sched-eliminate-the-ts-idle_lastupdate-field.patch
sched-introduce-get_cpu_iowait_time_us.patch
ondemand-solve-the-big-performance-issue-with-ondemand-during-disk-io.patch

