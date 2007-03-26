From: akpm@linux-foundation.org
Subject: - sched-accurate-user-accounting.patch removed from -mm tree
Date: Mon, 26 Mar 2007 02:18:01 -0700
Message-ID: <200703260920.l2Q9K4U1015490@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50516 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933740AbXCZJUa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2007 05:20:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kernel@kolivas.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     sched: accurate user accounting
has been removed from the -mm tree.  Its filename was
     sched-accurate-user-accounting.patch

This patch was dropped because it is obsolete

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

Remove the now defunct Documentation/cpu-load.txt file.

Signed-off-by: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cpu-load.txt  |  113 ----------------------------------
 include/linux/kernel_stat.h |    3 
 include/linux/sched.h       |    4 -
 kernel/sched.c              |   58 ++++++++++++++++-
 kernel/timer.c              |    5 -
 5 files changed, 62 insertions(+), 121 deletions(-)

diff -puN Documentation/cpu-load.txt~sched-accurate-user-accounting /dev/null
--- a/Documentation/cpu-load.txt
+++ /dev/null
@@ -1,113 +0,0 @@
-CPU load
---------
-
-Linux exports various bits of information via `/proc/stat' and
-`/proc/uptime' that userland tools, such as top(1), use to calculate
-the average time system spent in a particular state, for example:
-
-    $ iostat
-    Linux 2.6.18.3-exp (linmac)     02/20/2007
-
-    avg-cpu:  %user   %nice %system %iowait  %steal   %idle
-              10.01    0.00    2.92    5.44    0.00   81.63
-
-    ...
-
-Here the system thinks that over the default sampling period the
-system spent 10.01% of the time doing work in user space, 2.92% in the
-kernel, and was overall 81.63% of the time idle.
-
-In most cases the `/proc/stat' information reflects the reality quite
-closely, however due to the nature of how/when the kernel collects
-this data sometimes it can not be trusted at all.
-
-So how is this information collected?  Whenever timer interrupt is
-signalled the kernel looks what kind of task was running at this
-moment and increments the counter that corresponds to this tasks
-kind/state.  The problem with this is that the system could have
-switched between various states multiple times between two timer
-interrupts yet the counter is incremented only for the last state.
-
-
-Example
--------
-
-If we imagine the system with one task that periodically burns cycles
-in the following manner:
-
- time line between two timer interrupts
-|--------------------------------------|
- ^                                    ^
- |_ something begins working          |
-                                      |_ something goes to sleep
-                                     (only to be awaken quite soon)
-
-In the above situation the system will be 0% loaded according to the
-`/proc/stat' (since the timer interrupt will always happen when the
-system is executing the idle handler), but in reality the load is
-closer to 99%.
-
-One can imagine many more situations where this behavior of the kernel
-will lead to quite erratic information inside `/proc/stat'.
-
-
-/* gcc -o hog smallhog.c */
-#include <time.h>
-#include <limits.h>
-#include <signal.h>
-#include <sys/time.h>
-#define HIST 10
-
-static volatile sig_atomic_t stop;
-
-static void sighandler (int signr)
-{
-     (void) signr;
-     stop = 1;
-}
-static unsigned long hog (unsigned long niters)
-{
-     stop = 0;
-     while (!stop && --niters);
-     return niters;
-}
-int main (void)
-{
-     int i;
-     struct itimerval it = { .it_interval = { .tv_sec = 0, .tv_usec = 1 },
-                             .it_value = { .tv_sec = 0, .tv_usec = 1 } };
-     sigset_t set;
-     unsigned long v[HIST];
-     double tmp = 0.0;
-     unsigned long n;
-     signal (SIGALRM, &sighandler);
-     setitimer (ITIMER_REAL, &it, NULL);
-
-     hog (ULONG_MAX);
-     for (i = 0; i < HIST; ++i) v[i] = ULONG_MAX - hog (ULONG_MAX);
-     for (i = 0; i < HIST; ++i) tmp += v[i];
-     tmp /= HIST;
-     n = tmp - (tmp / 3.0);
-
-     sigemptyset (&set);
-     sigaddset (&set, SIGALRM);
-
-     for (;;) {
-         hog (n);
-         sigwait (&set, &i);
-     }
-     return 0;
-}
-
-
-References
-----------
-
-http://lkml.org/lkml/2007/2/12/6
-Documentation/filesystems/proc.txt (1.8)
-
-
-Thanks
-------
-
-Con Kolivas, Pavel Machek
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
@@ -89,6 +89,7 @@ unsigned long long __attribute__((weak))
  */
 #define NS_TO_JIFFIES(TIME)	((TIME) / (1000000000 / HZ))
 #define JIFFIES_TO_NS(TIME)	((TIME) * (1000000000 / HZ))
+#define JIFFY_NS		JIFFIES_TO_NS(1)
 
 /*
  * These are the 'tuning knobs' of the scheduler:
@@ -3018,8 +3019,59 @@ EXPORT_PER_CPU_SYMBOL(kstat);
 static inline void
 update_cpu_clock(struct task_struct *p, struct rq *rq, unsigned long long now)
 {
-	p->sched_time += now - p->last_ran;
-	p->last_ran = rq->most_recent_timestamp = now;
+	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	cputime64_t time_diff;
+
+	/* Sanity check. It should never go backwards or ruin accounting */
+	if (unlikely(now < p->last_ran))
+		goto out_set;
+	/* All the userspace visible cpu accounting is done here */
+	time_diff = now - p->last_ran;
+	p->sched_time += time_diff;
+	if (p != rq->idle) {
+		cputime_t utime_diff = time_diff;
+
+		if (TASK_NICE(p) > 0) {
+			cpustat->nice_ns = cputime64_add(cpustat->nice_ns,
+							 time_diff);
+			if (cpustat->nice_ns > JIFFY_NS) {
+				cpustat->nice_ns =
+					cputime64_sub(cpustat->nice_ns,
+					JIFFY_NS);
+				cpustat->nice =
+					cputime64_add(cpustat->nice, 1);
+			}
+		} else {
+			cpustat->user_ns = cputime64_add(cpustat->user_ns,
+							 time_diff);
+			if (cpustat->user_ns > JIFFY_NS) {
+				cpustat->user_ns =
+					cputime64_sub(cpustat->user_ns,
+					JIFFY_NS);
+				cpustat ->user =
+					cputime64_add(cpustat->user, 1);
+			}
+		}
+		p->utime_ns = cputime_add(p->utime_ns, utime_diff);
+		if (p->utime_ns > JIFFY_NS) {
+			p->utime_ns = cputime_sub(p->utime_ns, JIFFY_NS);
+			p->utime = cputime_add(p->utime,
+					       jiffies_to_cputime(1));
+		}
+	} else {
+		cpustat->idle_ns = cputime64_add(cpustat->idle_ns, time_diff);
+		if (cpustat->idle_ns > JIFFY_NS) {
+			cpustat->idle_ns = cputime64_sub(cpustat->idle_ns,
+							 JIFFY_NS);
+			cpustat->idle = cputime64_add(cpustat->idle, 1);
+		}
+	}
+out_set:
+	/*
+	 * We still need to set these values even if the clock appeared to
+	 * go backwards in case _this_ is the correct timestamp.
+	 */
+	rq->most_recent_timestamp = p->last_ran = now;
 }
 
 /*
@@ -3105,8 +3157,6 @@ void account_system_time(struct task_str
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
@@ -1209,10 +1209,9 @@ void update_process_times(int user_tick)
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
