From: akpm@linux-foundation.org
Subject: + add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch added to -mm tree
Date: Thu, 31 May 2007 12:57:15 -0700
Message-ID: <200705311957.l4VJvFKi026776@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38374 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758813AbXEaT6C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 May 2007 15:58:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     Add a flag to indicate deferrable timers in /proc/timer_stats
has been added to the -mm tree.  Its filename is
     add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add a flag to indicate deferrable timers in /proc/timer_stats
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>

Add a flag in /proc/timer_stats to indicate deferrable timers.  This will
let developers/users to differentiate between types of tiemrs in
/proc/timer_stats.

Deferrable timer and normal timer will appear in /proc/timer_stats as below.
  10D,     1 swapper          queue_delayed_work_on (delayed_work_timer_fn)
   10,     1 swapper          queue_delayed_work_on (delayed_work_timer_fn)

Also version of timer_stats changes from v0.1 to v0.2

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/hrtimer/timer_stats.txt |    4 ++++
 include/linux/hrtimer.h               |    5 +++--
 include/linux/timer.h                 |   15 ++++-----------
 kernel/time/timer_stats.c             |   14 +++++++++++---
 kernel/timer.c                        |   14 ++++++++++++++
 5 files changed, 36 insertions(+), 16 deletions(-)

diff -puN Documentation/hrtimer/timer_stats.txt~add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats Documentation/hrtimer/timer_stats.txt
--- a/Documentation/hrtimer/timer_stats.txt~add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats
+++ a/Documentation/hrtimer/timer_stats.txt
@@ -66,3 +66,7 @@ executed on expiry.
 
     Thomas, Ingo
 
+Added flag to indicate 'deferrable timer' in /proc/timer_stats. A deferrable
+timer will appear as follows
+  10D,     1 swapper          queue_delayed_work_on (delayed_work_timer_fn)
+
diff -puN include/linux/hrtimer.h~add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats include/linux/hrtimer.h
--- a/include/linux/hrtimer.h~add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats
+++ a/include/linux/hrtimer.h
@@ -329,12 +329,13 @@ extern void sysrq_timer_list_show(void);
 #ifdef CONFIG_TIMER_STATS
 
 extern void timer_stats_update_stats(void *timer, pid_t pid, void *startf,
-				     void *timerf, char * comm);
+				     void *timerf, char *comm,
+				     unsigned int timer_flag);
 
 static inline void timer_stats_account_hrtimer(struct hrtimer *timer)
 {
 	timer_stats_update_stats(timer, timer->start_pid, timer->start_site,
-				 timer->function, timer->start_comm);
+				 timer->function, timer->start_comm, 0);
 }
 
 extern void __timer_stats_hrtimer_set_start_info(struct hrtimer *timer,
diff -puN include/linux/timer.h~add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats include/linux/timer.h
--- a/include/linux/timer.h~add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats
+++ a/include/linux/timer.h
@@ -90,16 +90,13 @@ extern unsigned long get_next_timer_inte
  */
 #ifdef CONFIG_TIMER_STATS
 
+#define TIMER_STATS_FLAG_DEFERRABLE	0x1
+
 extern void init_timer_stats(void);
 
 extern void timer_stats_update_stats(void *timer, pid_t pid, void *startf,
-				     void *timerf, char * comm);
-
-static inline void timer_stats_account_timer(struct timer_list *timer)
-{
-	timer_stats_update_stats(timer, timer->start_pid, timer->start_site,
-				 timer->function, timer->start_comm);
-}
+				     void *timerf, char *comm,
+				     unsigned int timer_flag);
 
 extern void __timer_stats_timer_set_start_info(struct timer_list *timer,
 					       void *addr);
@@ -118,10 +115,6 @@ static inline void init_timer_stats(void
 {
 }
 
-static inline void timer_stats_account_timer(struct timer_list *timer)
-{
-}
-
 static inline void timer_stats_timer_set_start_info(struct timer_list *timer)
 {
 }
diff -puN kernel/time/timer_stats.c~add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats kernel/time/timer_stats.c
--- a/kernel/time/timer_stats.c~add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats
+++ a/kernel/time/timer_stats.c
@@ -68,6 +68,7 @@ struct entry {
 	 * Number of timeout events:
 	 */
 	unsigned long		count;
+	unsigned int		timer_flag;
 
 	/*
 	 * We save the command-line string to preserve
@@ -227,7 +228,8 @@ static struct entry *tstat_lookup(struct
  * incremented. Otherwise the timer is registered in a free slot.
  */
 void timer_stats_update_stats(void *timer, pid_t pid, void *startf,
-			      void *timerf, char * comm)
+			      void *timerf, char *comm,
+			      unsigned int timer_flag)
 {
 	/*
 	 * It doesnt matter which lock we take:
@@ -240,6 +242,7 @@ void timer_stats_update_stats(void *time
 	input.start_func = startf;
 	input.expire_func = timerf;
 	input.pid = pid;
+	input.timer_flag = timer_flag;
 
 	spin_lock_irqsave(lock, flags);
 	if (!active)
@@ -286,7 +289,7 @@ static int tstats_show(struct seq_file *
 	period = ktime_to_timespec(time);
 	ms = period.tv_nsec / 1000000;
 
-	seq_puts(m, "Timer Stats Version: v0.1\n");
+	seq_puts(m, "Timer Stats Version: v0.2\n");
 	seq_printf(m, "Sample period: %ld.%03ld s\n", period.tv_sec, ms);
 	if (atomic_read(&overflow_count))
 		seq_printf(m, "Overflow: %d entries\n",
@@ -294,8 +297,13 @@ static int tstats_show(struct seq_file *
 
 	for (i = 0; i < nr_entries; i++) {
 		entry = entries + i;
-		seq_printf(m, "%4lu, %5d %-16s ",
+ 		if (entry->timer_flag & TIMER_STATS_FLAG_DEFERRABLE) {
+			seq_printf(m, "%4luD, %5d %-16s ",
 				entry->count, entry->pid, entry->comm);
+		} else {
+			seq_printf(m, " %4lu, %5d %-16s ",
+				entry->count, entry->pid, entry->comm);
+		}
 
 		print_name_offset(m, (unsigned long)entry->start_func);
 		seq_puts(m, " (");
diff -puN kernel/timer.c~add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats kernel/timer.c
--- a/kernel/timer.c~add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats
+++ a/kernel/timer.c
@@ -305,6 +305,20 @@ void __timer_stats_timer_set_start_info(
 	memcpy(timer->start_comm, current->comm, TASK_COMM_LEN);
 	timer->start_pid = current->pid;
 }
+
+static void timer_stats_account_timer(struct timer_list *timer)
+{
+	unsigned int flag = 0;
+
+	if (unlikely(tbase_get_deferrable(timer->base)))
+		flag |= TIMER_STATS_FLAG_DEFERRABLE;
+
+	timer_stats_update_stats(timer, timer->start_pid, timer->start_site,
+				 timer->function, timer->start_comm, flag);
+}
+
+#else
+static void timer_stats_account_timer(struct timer_list *timer) {}
 #endif
 
 /**
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

git-cpufreq.patch
make-usb-autosuspend-timer-1-sec-jiffy-aligned.patch
round_jiffies-for-i386-and-x86-64-non-critical-corrected-mce-polling.patch
add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch
