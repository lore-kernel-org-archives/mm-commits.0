From: akpm@linux-foundation.org
Subject: + sched-accurate-user-accounting.patch added to -mm tree
Date: Sun, 25 Mar 2007 01:41:35 -0800
Message-ID: <200703250941.l2P9fZf3024890@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37833 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbXCYJlu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 05:41:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kernel@kolivas.org, mingo@elte.hu


The patch titled
     sched: accurate user accounting
has been added to the -mm tree.  Its filename is
     sched-accurate-user-accounting.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sched: accurate user accounting
From: Con Kolivas <kernel@kolivas.org>

Currently we only do cpu accounting to userspace based on what is actually
happening precisely on each tick.  The accuracy of that accounting gets
progressively worse the lower HZ is.  As we already keep accounting of
nanosecond resolution we can accurately track user cpu, nice cpu and idle
cpu if we move the accounting to update_cpu_clock with a nanosecond
cpu_usage_stat entry.  This increases overhead slightly but avoids the
problem of tick aliasing errors making accounting unreliable.

Signed-off-by: Con Kolivas <kernel@kolivas.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel_stat.h |    3 +
 include/linux/sched.h       |    4 +-
 kernel/sched.c              |   52 ++++++++++++++++++++++++++++++++--
 kernel/timer.c              |    5 +--
 4 files changed, 57 insertions(+), 7 deletions(-)

diff -puN include/linux/kernel_stat.h~sched-accurate-user-accounting include/linux/kernel_stat.h
--- a/include/linux/kernel_stat.h~sched-accurate-user-accounting
+++ a/include/linux/kernel_stat.h
@@ -16,11 +16,14 @@
 
 struct cpu_usage_stat {
 	cputime64_t user;
+	cputime64_t user_ns;
 	cputime64_t nice;
+	cputime64_t nice_ns;
 	cputime64_t system;
 	cputime64_t softirq;
 	cputime64_t irq;
 	cputime64_t idle;
+	cputime64_t idle_ns;
 	cputime64_t iowait;
 	cputime64_t steal;
 };
diff -puN include/linux/sched.h~sched-accurate-user-accounting include/linux/sched.h
--- a/include/linux/sched.h~sched-accurate-user-accounting
+++ a/include/linux/sched.h
@@ -884,7 +884,9 @@ struct task_struct {
 	int __user *clear_child_tid;		/* CLONE_CHILD_CLEARTID */
 
 	unsigned int rt_priority;
-	cputime_t utime, stime;
+	cputime_t utime;
+	cputime_t utime_ns;
+	cputime_t stime;
 	unsigned long nvcsw, nivcsw; /* context switch counts */
 	struct timespec start_time;
 /* mm fault and swap info: this can arguably be seen as either mm-specific or thread-specific */
diff -puN kernel/sched.c~sched-accurate-user-accounting kernel/sched.c
--- a/kernel/sched.c~sched-accurate-user-accounting
+++ a/kernel/sched.c
@@ -167,6 +167,12 @@ unsigned long long __attribute__((weak))
 	(JIFFIES_TO_NS(MAX_SLEEP_AVG * \
 		(MAX_BONUS / 2 + DELTA((p)) + 1) / MAX_BONUS - 1))
 
+/*
+ * Some helpers for converting nanosecond timing to jiffy resolution
+ */
+#define NS_TO_JIFFIES(TIME)   ((TIME) / (1000000000 / HZ))
+#define JIFFIES_TO_NS(TIME)   ((TIME) * (1000000000 / HZ))
+
 #define TASK_PREEMPTS_CURR(p, rq) \
 	((p)->prio < (rq)->curr->prio)
 
@@ -3018,8 +3024,50 @@ EXPORT_PER_CPU_SYMBOL(kstat);
 static inline void
 update_cpu_clock(struct task_struct *p, struct rq *rq, unsigned long long now)
 {
-	p->sched_time += now - p->last_ran;
+	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	cputime64_t time_diff = now - p->last_ran;
+
+	p->sched_time += time_diff;
 	p->last_ran = rq->most_recent_timestamp = now;
+	if (p != rq->idle) {
+		cputime_t utime_diff = time_diff;
+
+		if (TASK_NICE(p) > 0) {
+			cpustat->nice_ns = cputime64_add(cpustat->nice_ns,
+							 time_diff);
+			if (NS_TO_JIFFIES(cpustat->nice_ns) > 1) {
+				cpustat->nice_ns =
+					cputime64_sub(cpustat->nice_ns,
+					JIFFIES_TO_NS(1));
+				cpustat->nice =
+					cputime64_add(cpustat->nice, 1);
+			}
+		} else {
+			cpustat->user_ns = cputime64_add(cpustat->user_ns,
+						time_diff);
+			if (NS_TO_JIFFIES(cpustat->user_ns) > 1) {
+				cpustat->user_ns =
+					cputime64_sub(cpustat->user_ns,
+					JIFFIES_TO_NS(1));
+				cpustat ->user =
+					cputime64_add(cpustat->user, 1);
+			}
+		}
+		p->utime_ns = cputime_add(p->utime_ns, utime_diff);
+		if (NS_TO_JIFFIES(p->utime_ns) > 1) {
+			p->utime_ns = cputime_sub(p->utime_ns,
+						  JIFFIES_TO_NS(1));
+			p->utime = cputime_add(p->utime,
+					       jiffies_to_cputime(1));
+		}
+	} else {
+		cpustat->idle_ns = cputime64_add(cpustat->idle_ns, time_diff);
+		if (NS_TO_JIFFIES(cpustat->idle_ns) > 1) {
+			cpustat->idle_ns = cputime64_sub(cpustat->idle_ns,
+							 JIFFIES_TO_NS(1));
+			cpustat->idle = cputime64_add(cpustat->idle, 1);
+		}
+	}
 }
 
 /*
@@ -3105,8 +3153,6 @@ void account_system_time(struct task_str
 		cpustat->system = cputime64_add(cpustat->system, tmp);
 	else if (atomic_read(&rq->nr_iowait) > 0)
 		cpustat->iowait = cputime64_add(cpustat->iowait, tmp);
-	else
-		cpustat->idle = cputime64_add(cpustat->idle, tmp);
 	/* Account for system time used */
 	acct_update_integrals(p);
 }
diff -puN kernel/timer.c~sched-accurate-user-accounting kernel/timer.c
--- a/kernel/timer.c~sched-accurate-user-accounting
+++ a/kernel/timer.c
@@ -1196,10 +1196,9 @@ void update_process_times(int user_tick)
 	int cpu = smp_processor_id();
 
 	/* Note: this timer irq context must be accounted for as well. */
-	if (user_tick)
-		account_user_time(p, jiffies_to_cputime(1));
-	else
+	if (!user_tick)
 		account_system_time(p, HARDIRQ_OFFSET, jiffies_to_cputime(1));
+	/* User time is accounted for in update_cpu_clock in sched.c */
 	run_local_timers();
 	if (rcu_pending(cpu))
 		rcu_check_callbacks(cpu, user_tick);
_

Patches currently in -mm which might be from kernel@kolivas.org are

sched-accurate-user-accounting.patch
sched-fix-idle-load-balancing-in-softirqd-context-fix.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
swap-prefetch-avoid-repeating-entry.patch
lists-add-list-splice-tail.patch
sched-remove-sleepavg-from-proc.patch
sched-remove-noninteractive-flag.patch
sched-dont-renice-kernel-threads.patch
sched-implement-rsdl-cpu-scheduler.patch
sched-document-rsdl-cpu-scheduler.patch
sched-rsdl-improvements.patch
sched-rsdl-check-for-niced-tasks-lowering-prio-level.patch
sched-rsdl-yet-more-fixes.patch
