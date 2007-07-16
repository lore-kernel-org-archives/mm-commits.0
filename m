From: akpm@linux-foundation.org
Subject: - add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:55:28 -0700
Message-ID: <200707162055.l6GKtSOk001916@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55610 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760940AbXGPVWI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:22:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: venkatesh.pallipadi@intel.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Add a flag to indicate deferrable timers in /proc/timer_stats
has been removed from the -mm tree.  Its filename was
     add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Ingo Molnar <mingo@elte.hu>
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
@@ -67,3 +67,7 @@ executed on expiry.
 
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
@@ -231,7 +232,8 @@ static struct entry *tstat_lookup(struct
  * incremented. Otherwise the timer is registered in a free slot.
  */
 void timer_stats_update_stats(void *timer, pid_t pid, void *startf,
-			      void *timerf, char * comm)
+			      void *timerf, char *comm,
+			      unsigned int timer_flag)
 {
 	/*
 	 * It doesnt matter which lock we take:
@@ -249,6 +251,7 @@ void timer_stats_update_stats(void *time
 	input.start_func = startf;
 	input.expire_func = timerf;
 	input.pid = pid;
+	input.timer_flag = timer_flag;
 
 	spin_lock_irqsave(lock, flags);
 	if (!active)
@@ -295,7 +298,7 @@ static int tstats_show(struct seq_file *
 	period = ktime_to_timespec(time);
 	ms = period.tv_nsec / 1000000;
 
-	seq_puts(m, "Timer Stats Version: v0.1\n");
+	seq_puts(m, "Timer Stats Version: v0.2\n");
 	seq_printf(m, "Sample period: %ld.%03ld s\n", period.tv_sec, ms);
 	if (atomic_read(&overflow_count))
 		seq_printf(m, "Overflow: %d entries\n",
@@ -303,8 +306,13 @@ static int tstats_show(struct seq_file *
 
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

origin.patch
git-acpi.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default-fix.patch
round_jiffies-for-i386-and-x86-64-non-critical-corrected-mce-polling.patch
x86_64-convert-to-cleckevents.patch
x86_64-block-irq-balancing-for-timer.patch
ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer.patch
ich-force-hpet-restructure-hpet-generic-clock-code.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-late-initialization-of-hpet-after-quirk.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch
ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch
