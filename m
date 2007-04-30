From: akpm@linux-foundation.org
Subject: - sched-implement-staircase-deadline-scheduler-timeslice-fixes.patch removed from -mm tree
Date: Mon, 30 Apr 2007 11:47:53 -0700
Message-ID: <200704301847.l3UIlrUA011794@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34649 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946597AbXD3Sr7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 14:47:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kernel@kolivas.org, mm-commits@vger.kernel.org


The patch titled
     sched: implement staircase deadline scheduler timeslice fixes
has been removed from the -mm tree.  Its filename was
     sched-implement-staircase-deadline-scheduler-timeslice-fixes.patch

This patch was dropped because I need to clear the decks

------------------------------------------------------
Subject: sched: implement staircase deadline scheduler timeslice fixes
From: Con Kolivas <kernel@kolivas.org>

There is no need for time_slice and quota to be stored in nanoseconds and can
overflow on 32bit when rr_intervals are large.  Convert them to microseconds.

This then allows the maximum rr_interval to be as large as 5000 milliseconds.

Alter the choice of initial rr_interval to scale more with cpus in an
understandable fashion along with explanation.

Don't check that rr_interval is at least one tick every time rr_quota is
called.  Simply allow it to be less if the user desires and allow aliasing to
keep accounting sane overall.

Thanks to Nick Piggin for suggesting larger timeslices.
Thanks to Peter Zijlstra for help.

Signed-off-by: Con Kolivas <kernel@kolivas.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c  |   44 +++++++++++++++++++++++---------------------
 kernel/sysctl.c |   11 ++++++-----
 2 files changed, 29 insertions(+), 26 deletions(-)

diff -puN kernel/sched.c~sched-implement-staircase-deadline-scheduler-timeslice-fixes kernel/sched.c
--- a/kernel/sched.c~sched-implement-staircase-deadline-scheduler-timeslice-fixes
+++ a/kernel/sched.c
@@ -42,6 +42,7 @@
 #include <linux/smp.h>
 #include <linux/threads.h>
 #include <linux/timer.h>
+#include <linux/log2.h>
 #include <linux/rcupdate.h>
 #include <linux/cpu.h>
 #include <linux/cpuset.h>
@@ -90,7 +91,7 @@ unsigned long long __attribute__((weak))
 /* Some helpers for converting to/from various scales.*/
 #define NS_TO_JIFFIES(TIME)	((TIME) / (1000000000 / HZ))
 #define JIFFIES_TO_NS(TIME)	((TIME) * (1000000000 / HZ))
-#define MS_TO_NS(TIME)		((TIME) * 1000000)
+#define MS_TO_US(TIME)		((TIME) * 1000)
 /* Can return 0 */
 #define MS_TO_JIFFIES(TIME)	((TIME) * HZ / 1000)
 #define JIFFIES_TO_MS(TIME)	((TIME) * 1000 / HZ)
@@ -102,9 +103,8 @@ unsigned long long __attribute__((weak))
  * Value is in ms and set to a minimum of 8ms. Scales with number of cpus.
  * Tunable via /proc interface.
  */
-int rr_interval __read_mostly;
+int rr_interval __read_mostly = 8;
 
-#define RR_INTERVAL		8
 #define DEF_TIMESLICE		(rr_interval * 20)
 
 /*
@@ -1014,23 +1014,20 @@ static int effective_prio(struct task_st
  * tick still. Below nice 0 they get progressively larger.
  * ie nice -6..0 = rr_interval. nice -10 = 2.5 * rr_interval
  * nice -20 = 10 * rr_interval. nice 1-19 = rr_interval / 2.
- * Value returned is in nanoseconds.
+ * Value returned is in microseconds.
  */
 static unsigned int rr_quota(struct task_struct *p)
 {
 	int nice = TASK_NICE(p), rr = rr_interval;
 
-	/* Ensure that rr_interval is at least 1 tick */
-	if (unlikely(!MS_TO_JIFFIES(rr)))
-		rr = rr_interval = JIFFIES_TO_MS(1) ? : 1;
 	if (!rt_task(p)) {
 		if (nice < -6) {
 			rr *= nice * nice;
 			rr /= 40;
-		} else if (nice > 0 && (rr * HZ / 1000 / 2) > 0)
-			rr /= 2;
+		} else if (nice > 0)
+			rr = rr / 2 ? : 1;
 	}
-	return MS_TO_NS(rr);
+	return MS_TO_US(rr);
 }
 
 /*
@@ -3243,16 +3240,17 @@ EXPORT_PER_CPU_SYMBOL(kstat);
 /*
  * This is called on clock ticks and on context switches.
  * Bank in p->sched_time the ns elapsed since the last tick or switch.
- * CPU scheduler quota accounting is also performed here.
+ * CPU scheduler quota accounting is also performed here in microseconds.
  * The value returned from sched_clock() occasionally gives bogus values so
  * some sanity checking is required.
  */
-static inline void
+static void
 update_cpu_clock(struct task_struct *p, struct rq *rq, unsigned long long now,
 		 int tick)
 {
 	cputime64_t time_diff = now - p->last_ran;
-	unsigned int min_diff = 1000;
+	const unsigned int min_diff = 1000;
+	int us_time_diff;
 
 	if (tick) {
 		/*
@@ -3271,8 +3269,11 @@ update_cpu_clock(struct task_struct *p, 
 		if (time_diff > JIFFIES_TO_NS(1) || time_diff < min_diff)
 			time_diff = min_diff;
 	}
+	/* time_slice accounting is done in usecs to avoid overflow on 32bit */
+	us_time_diff = time_diff;
+	us_time_diff /= 1000;
 	if (p != rq->idle && p->policy != SCHED_FIFO)
-		p->time_slice -= time_diff;
+		p->time_slice -= us_time_diff;
 	p->sched_time += time_diff;
 	p->last_ran = rq->most_recent_timestamp = now;
 }
@@ -3373,8 +3374,7 @@ void account_steal_time(struct task_stru
 static void task_expired_entitlement(struct rq *rq, struct task_struct *p)
 {
 	struct prio_array *old_array;
-	int overrun;
-	int old_prio;
+	int overrun, old_prio;
 
 	if (unlikely(p->first_time_slice))
 		p->first_time_slice = 0;
@@ -6872,6 +6872,13 @@ void __init sched_init_smp(void)
 	/* Move init over to a non-isolated CPU */
 	if (set_cpus_allowed(current, non_isolated_cpus) < 0)
 		BUG();
+
+	/*
+	 * Assume that every added cpu gives us slightly less overall latency
+	 * allowing us to increase the base rr_interval, but in a non linear
+	 * fashion.
+	 */
+	rr_interval *= 1 + ilog2(num_online_cpus());
 }
 #else
 void __init sched_init_smp(void)
@@ -6893,7 +6900,6 @@ void __init sched_init(void)
 {
 	int i, j, k;
 	int highest_cpu = 0;
-	unsigned int rr_us = 0, rr_inc = RR_INTERVAL * 1000;
 
 	/* Generate the priority matrix */
 	for (i = 0; i < PRIO_RANGE; i++) {
@@ -6942,12 +6948,8 @@ void __init sched_init(void)
 			/* delimiter for bitsearch */
 			__set_bit(MAX_PRIO, array->prio_bitmap);
 		}
-		/* Every added cpu increases the rr_interval */
-		rr_us += rr_inc;
-		rr_inc /= 2;
 		highest_cpu = i;
 	}
-	rr_interval = rr_us / 1000;
 	set_load_weight(&init_task);
 
 #ifdef CONFIG_SMP
diff -puN kernel/sysctl.c~sched-implement-staircase-deadline-scheduler-timeslice-fixes kernel/sysctl.c
--- a/kernel/sysctl.c~sched-implement-staircase-deadline-scheduler-timeslice-fixes
+++ a/kernel/sysctl.c
@@ -161,11 +161,12 @@ int sysctl_legacy_va_layout;
 #endif
 
 
-/* Constants for minimum and maximum testing in vm_table.
+/* Constants for minimum and maximum testing.
    We use these as one-element integer vectors. */
-static int  __read_mostly zero;
-static int  __read_mostly one = 1;
-static int  __read_mostly one_hundred = 100;
+static int __read_mostly zero;
+static int __read_mostly one = 1;
+static int __read_mostly one_hundred = 100;
+static int __read_mostly five_thousand = 5000;
 
 
 /* The default sysctl tables: */
@@ -517,7 +518,7 @@ static ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec_minmax,
 		.strategy	= &sysctl_intvec,
 		.extra1		= &one,
-		.extra2		= &one_hundred,
+		.extra2		= &five_thousand,
 	},
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86)
 	{
_

Patches currently in -mm which might be from kernel@kolivas.org are

sched-fix-idle-load-balancing-in-softirqd-context-fix.patch
sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array-update.patch
sched-implement-staircase-deadline-scheduler-timeslice-fixes.patch
sched-implement-staircase-scheduler-yaf-fix.patch
sched-implement-staircase-deadline-scheduler-ymf-accounting-fixes.patch
sched-ymf-typo.patch
sched-implement-staircase-deadline-scheduler-load-weight-fix.patch
sched-increase-ksoftirqd-priority.patch
sched-remove-noninteractive-flag.patch
sched-document-sd-cpu-scheduler.patch
sched-implement-staircase-deadline-scheduler-rework-priomatrix-doc.patch
sched-consolidate-sched_clock-drift-adjustments.patch
sched-consolidate-sched_clock-drift-adjustments-fix.patch
sched-implement-staircase-deadline-scheduler-docupdate.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
swap-prefetch-avoid-repeating-entry.patch
