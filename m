From: akpm@linux-foundation.org
Subject: - add-scaled-time-to-taskstats-based-process-accounting.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:44:53 -0700
Message-ID: <200710190344.l9J3irgZ013178@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49517 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966364AbXJSD4p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:56:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mikey@neuling.org, balbir@in.ibm.com, benh@kernel.crashing.org, jlan@engr.sgi.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Add scaled time to taskstats based process accounting
has been removed from the -mm tree.  Its filename was
     add-scaled-time-to-taskstats-based-process-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add scaled time to taskstats based process accounting
From: Michael Neuling <mikey@neuling.org>

This adds items to the taststats struct to account for user and system
time based on scaling the CPU frequency and instruction issue rates.

Adds account_(user|system)_time_scaled callbacks which architectures
can use to account for time using this mechanism.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Jay Lan <jlan@engr.sgi.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel_stat.h |    2 ++
 include/linux/sched.h       |    2 +-
 include/linux/taskstats.h   |   11 +++++++++--
 kernel/delayacct.c          |    6 ++++++
 kernel/fork.c               |    2 ++
 kernel/sched.c              |   21 +++++++++++++++++++++
 kernel/timer.c              |    7 +++++--
 kernel/tsacct.c             |    4 ++++
 8 files changed, 50 insertions(+), 5 deletions(-)

diff -puN include/linux/kernel_stat.h~add-scaled-time-to-taskstats-based-process-accounting include/linux/kernel_stat.h
--- a/include/linux/kernel_stat.h~add-scaled-time-to-taskstats-based-process-accounting
+++ a/include/linux/kernel_stat.h
@@ -53,7 +53,9 @@ static inline int kstat_irqs(int irq)
 }
 
 extern void account_user_time(struct task_struct *, cputime_t);
+extern void account_user_time_scaled(struct task_struct *, cputime_t);
 extern void account_system_time(struct task_struct *, int, cputime_t);
+extern void account_system_time_scaled(struct task_struct *, cputime_t);
 extern void account_steal_time(struct task_struct *, cputime_t);
 
 #endif /* _LINUX_KERNEL_STAT_H */
diff -puN include/linux/sched.h~add-scaled-time-to-taskstats-based-process-accounting include/linux/sched.h
--- a/include/linux/sched.h~add-scaled-time-to-taskstats-based-process-accounting
+++ a/include/linux/sched.h
@@ -991,7 +991,7 @@ struct task_struct {
 	int __user *clear_child_tid;		/* CLONE_CHILD_CLEARTID */
 
 	unsigned int rt_priority;
-	cputime_t utime, stime;
+	cputime_t utime, stime, utimescaled, stimescaled;
 	cputime_t gtime;
 	unsigned long nvcsw, nivcsw; /* context switch counts */
 	struct timespec start_time; 		/* monotonic time */
diff -puN include/linux/taskstats.h~add-scaled-time-to-taskstats-based-process-accounting include/linux/taskstats.h
--- a/include/linux/taskstats.h~add-scaled-time-to-taskstats-based-process-accounting
+++ a/include/linux/taskstats.h
@@ -31,7 +31,7 @@
  */
 
 
-#define TASKSTATS_VERSION	5
+#define TASKSTATS_VERSION	6
 #define TS_COMM_LEN		32	/* should be >= TASK_COMM_LEN
 					 * in linux/sched.h */
 
@@ -85,9 +85,12 @@ struct taskstats {
 	 * On some architectures, value will adjust for cpu time stolen
 	 * from the kernel in involuntary waits due to virtualization.
 	 * Value is cumulative, in nanoseconds, without a corresponding count
-	 * and wraps around to zero silently on overflow
+	 * and wraps around to zero silently on overflow.  The
+	 * _scaled_ version accounts for cpus which can scale the
+	 * number of instructions executed each cycle.
 	 */
 	__u64	cpu_run_real_total;
+	__u64	cpu_scaled_run_real_total;
 
 	/* cpu "virtual" running time
 	 * Uses time intervals seen by the kernel i.e. no adjustment
@@ -142,6 +145,10 @@ struct taskstats {
 	__u64	write_char;		/* bytes written */
 	__u64	read_syscalls;		/* read syscalls */
 	__u64	write_syscalls;		/* write syscalls */
+
+	/* time accounting for SMT machines */
+	__u64	ac_utimescaled;		/* utime scaled on frequency etc */
+	__u64	ac_stimescaled;		/* stime scaled on frequency etc */
 	/* Extended accounting fields end */
 
 #define TASKSTATS_HAS_IO_ACCOUNTING
diff -puN kernel/delayacct.c~add-scaled-time-to-taskstats-based-process-accounting kernel/delayacct.c
--- a/kernel/delayacct.c~add-scaled-time-to-taskstats-based-process-accounting
+++ a/kernel/delayacct.c
@@ -115,6 +115,12 @@ int __delayacct_add_tsk(struct taskstats
 	tmp += timespec_to_ns(&ts);
 	d->cpu_run_real_total = (tmp < (s64)d->cpu_run_real_total) ? 0 : tmp;
 
+	tmp = (s64)d->cpu_scaled_run_real_total;
+	cputime_to_timespec(tsk->utimescaled + tsk->stimescaled, &ts);
+	tmp += timespec_to_ns(&ts);
+	d->cpu_scaled_run_real_total =
+		(tmp < (s64)d->cpu_scaled_run_real_total) ? 0 : tmp;
+
 	/*
 	 * No locking available for sched_info (and too expensive to add one)
 	 * Mitigate by taking snapshot of values
diff -puN kernel/fork.c~add-scaled-time-to-taskstats-based-process-accounting kernel/fork.c
--- a/kernel/fork.c~add-scaled-time-to-taskstats-based-process-accounting
+++ a/kernel/fork.c
@@ -1059,6 +1059,8 @@ static struct task_struct *copy_process(
 	p->utime = cputime_zero;
 	p->stime = cputime_zero;
 	p->gtime = cputime_zero;
+	p->utimescaled = cputime_zero;
+	p->stimescaled = cputime_zero;
 
 #ifdef CONFIG_TASK_XACCT
 	p->rchar = 0;		/* I/O counter: bytes read */
diff -puN kernel/sched.c~add-scaled-time-to-taskstats-based-process-accounting kernel/sched.c
--- a/kernel/sched.c~add-scaled-time-to-taskstats-based-process-accounting
+++ a/kernel/sched.c
@@ -3334,6 +3334,16 @@ void account_guest_time(struct task_stru
 }
 
 /*
+ * Account scaled user cpu time to a process.
+ * @p: the process that the cpu time gets accounted to
+ * @cputime: the cpu time spent in user space since the last update
+ */
+void account_user_time_scaled(struct task_struct *p, cputime_t cputime)
+{
+	p->utimescaled = cputime_add(p->utimescaled, cputime);
+}
+
+/*
  * Account system cpu time to a process.
  * @p: the process that the cpu time gets accounted to
  * @hardirq_offset: the offset to subtract from hardirq_count()
@@ -3371,6 +3381,17 @@ void account_system_time(struct task_str
 }
 
 /*
+ * Account scaled system cpu time to a process.
+ * @p: the process that the cpu time gets accounted to
+ * @hardirq_offset: the offset to subtract from hardirq_count()
+ * @cputime: the cpu time spent in kernel space since the last update
+ */
+void account_system_time_scaled(struct task_struct *p, cputime_t cputime)
+{
+	p->stimescaled = cputime_add(p->stimescaled, cputime);
+}
+
+/*
  * Account for involuntary wait time.
  * @p: the process from which the cpu time has been stolen
  * @steal: the cpu time spent in involuntary wait
diff -puN kernel/timer.c~add-scaled-time-to-taskstats-based-process-accounting kernel/timer.c
--- a/kernel/timer.c~add-scaled-time-to-taskstats-based-process-accounting
+++ a/kernel/timer.c
@@ -826,10 +826,13 @@ void update_process_times(int user_tick)
 	int cpu = smp_processor_id();
 
 	/* Note: this timer irq context must be accounted for as well. */
-	if (user_tick)
+	if (user_tick) {
 		account_user_time(p, jiffies_to_cputime(1));
-	else
+		account_user_time_scaled(p, jiffies_to_cputime(1));
+	} else {
 		account_system_time(p, HARDIRQ_OFFSET, jiffies_to_cputime(1));
+		account_system_time_scaled(p, jiffies_to_cputime(1));
+	}
 	run_local_timers();
 	if (rcu_pending(cpu))
 		rcu_check_callbacks(cpu, user_tick);
diff -puN kernel/tsacct.c~add-scaled-time-to-taskstats-based-process-accounting kernel/tsacct.c
--- a/kernel/tsacct.c~add-scaled-time-to-taskstats-based-process-accounting
+++ a/kernel/tsacct.c
@@ -62,6 +62,10 @@ void bacct_add_tsk(struct taskstats *sta
 	rcu_read_unlock();
 	stats->ac_utime	 = cputime_to_msecs(tsk->utime) * USEC_PER_MSEC;
 	stats->ac_stime	 = cputime_to_msecs(tsk->stime) * USEC_PER_MSEC;
+	stats->ac_utimescaled =
+		cputime_to_msecs(tsk->utimescaled) * USEC_PER_MSEC;
+	stats->ac_stimescaled =
+		cputime_to_msecs(tsk->stimescaled) * USEC_PER_MSEC;
 	stats->ac_minflt = tsk->min_flt;
 	stats->ac_majflt = tsk->maj_flt;
 
_

Patches currently in -mm which might be from mikey@neuling.org are

origin.patch
