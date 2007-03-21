From: akpm@linux-foundation.org
Subject: + sched-rsdl-improvements.patch added to -mm tree
Date: Wed, 21 Mar 2007 16:36:27 -0700
Message-ID: <200703212336.l2LNaSsu007061@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59021 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209AbXCUXgx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Mar 2007 19:36:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kernel@kolivas.org, mingo@elte.hu


The patch titled
     sched: rsdl improvements
has been added to the -mm tree.  Its filename is
     sched-rsdl-improvements.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sched: rsdl improvements
From: Con Kolivas <kernel@kolivas.org>

Further improve the deterministic nature of the RSDL cpu scheduler and make
the rr_interval tunable.

By only giving out priority slots to tasks at the current runqueue's
prio_level or below we can make the cpu allocation not altered by
accounting issues across major_rotation periods.  This makes the cpu
allocation and latencies more deterministic, and decreases maximum
latencies substantially.  This change removes the possibility that tasks
can get bursts of cpu activity which can favour towards interactive tasks
but also favour towards cpu bound tasks which happen to wait on other
activity (such as I/O) and is a net gain.

This change also makes negative nice values less harmful to latencies of
more niced tasks, and should lead to less preemption which might decrease
the context switch rate and subsequently improve throughput.

The rr_interval can be made a tunable such that if an environment exists
that is not as latency sensitive, it can be increased for maximum
throughput.

A tiny change checking for MAX_PRIO in normal_prio() may prevent oopses on
bootup on large SMP due to forking off the idle task.

Other minor cleanups.

Signed-off-by: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |   12 +++
 kernel/sched.c                  |   94 ++++++++++++++++--------------
 kernel/sysctl.c                 |   25 ++++++-
 3 files changed, 83 insertions(+), 48 deletions(-)

diff -puN Documentation/sysctl/kernel.txt~sched-rsdl-improvements Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~sched-rsdl-improvements
+++ a/Documentation/sysctl/kernel.txt
@@ -43,6 +43,7 @@ show up in /proc/sys/kernel:
 - printk
 - real-root-dev               ==> Documentation/initrd.txt
 - reboot-cmd                  [ SPARC only ]
+- rr_interval
 - rtsig-max
 - rtsig-nr
 - sem
@@ -288,6 +289,17 @@ rebooting. ???
 
 ==============================================================
 
+rr_interval:
+
+This is the smallest duration that any cpu process scheduling unit
+will run for. Increasing this value can increase throughput of cpu
+bound tasks substantially but at the expense of increased latencies
+overall. This value is in _ticks_ and the default value chosen depends
+on the number of cpus available at scheduler initialisation. Valid
+values are from 1-100.
+
+==============================================================
+
 rtsig-max & rtsig-nr:
 
 The file rtsig-max can be used to tune the maximum number
diff -puN kernel/sched.c~sched-rsdl-improvements kernel/sched.c
--- a/kernel/sched.c~sched-rsdl-improvements
+++ a/kernel/sched.c
@@ -93,8 +93,10 @@ unsigned long long __attribute__((weak))
 /*
  * This is the time all tasks within the same priority round robin.
  * Set to a minimum of 8ms. Scales with number of cpus and rounds with HZ.
+ * Tunable via /proc interface.
  */
-static unsigned int rr_interval __read_mostly;
+int rr_interval __read_mostly;
+
 #define RR_INTERVAL		8
 #define DEF_TIMESLICE		(rr_interval * 20)
 
@@ -686,19 +688,32 @@ static inline void task_new_array(struct
 	p->rotation = rq->prio_rotation;
 }
 
+/* Find the first slot from the relevant prio_matrix entry */
 static inline int first_prio_slot(struct task_struct *p)
 {
 	return SCHED_PRIO(find_first_zero_bit(
 		prio_matrix[USER_PRIO(p->static_prio)], PRIO_RANGE));
 }
 
-static inline int next_prio_slot(struct task_struct *p, int prio)
+/* Is a dynamic_prio part of the allocated slots for this static_prio */
+static inline int entitled_slot(int static_prio, int dynamic_prio)
+{
+	return !test_bit(USER_PRIO(dynamic_prio),
+		prio_matrix[USER_PRIO(static_prio)]);
+}
+
+/*
+ * Find the first unused slot by this task that is also in its prio_matrix
+ * level.
+ */
+static inline int next_entitled_slot(struct task_struct *p, struct rq *rq)
 {
 	DECLARE_BITMAP(tmp, PRIO_RANGE);
+
 	bitmap_or(tmp, p->bitmap, prio_matrix[USER_PRIO(p->static_prio)],
 		  PRIO_RANGE);
 	return SCHED_PRIO(find_next_zero_bit(tmp, PRIO_RANGE,
-		USER_PRIO(prio)));
+		USER_PRIO(rq->prio_level)));
 }
 
 static void queue_expired(struct task_struct *p, struct rq *rq)
@@ -725,23 +740,12 @@ static void queue_expired(struct task_st
 static void recalc_task_prio(struct task_struct *p, struct rq *rq)
 {
 	struct prio_array *array = rq->active;
-	int queue_prio, search_prio = MAX_RT_PRIO;
-
-	/*
-	 * SCHED_BATCH tasks never start at better priority than any other
-	 * task that is already running since they are flagged as latency
-	 * insensitive. This means they never cause greater latencies in other
-	 * non SCHED_BATCH tasks of the same nice level, but they still will
-	 * not be exposed to high latencies themselves.
-	 */
-	if (unlikely(p->policy == SCHED_BATCH))
-		search_prio = rq->prio_level;
+	int queue_prio;
 
 	if (p->rotation == rq->prio_rotation) {
 		if (p->array == array) {
 			if (p->time_slice && rq_quota(rq, p->prio))
 				return;
-			search_prio = p->prio;
 		} else if (p->array == rq->expired) {
 			queue_expired(p, rq);
 			return;
@@ -750,7 +754,7 @@ static void recalc_task_prio(struct task
 	} else
 		task_new_array(p, rq);
 
-	queue_prio = next_prio_slot(p, search_prio);
+	queue_prio = next_entitled_slot(p, rq);
 	if (queue_prio >= MAX_PRIO) {
 		queue_expired(p, rq);
 		return;
@@ -907,7 +911,7 @@ static inline int normal_prio(struct tas
 	if (has_rt_policy(p))
 		return MAX_RT_PRIO-1 - p->rt_priority;
 	/* Other tasks all have normal_prio set in recalc_task_prio */
-	if (likely(p->prio >= MAX_RT_PRIO))
+	if (likely(p->prio >= MAX_RT_PRIO && p->prio < MAX_PRIO))
 		return p->prio;
 	else
 		return p->static_prio;
@@ -942,10 +946,10 @@ static int effective_prio(struct task_st
  */
 static unsigned int rr_quota(struct task_struct *p)
 {
-	int neg_nice = -TASK_NICE(p), rr = rr_interval;
+	int nice = TASK_NICE(p), rr = rr_interval;
 
-	if (neg_nice > 6 && !rt_task(p)) {
-		rr *= neg_nice * neg_nice;
+	if (nice < -6 && !rt_task(p)) {
+		rr *= nice * nice;
 		rr /= 40;
 	}
 	return rr;
@@ -1583,7 +1587,7 @@ int fastcall wake_up_state(struct task_s
 	return try_to_wake_up(p, state, 0);
 }
 
-static void task_running_tick(struct rq *rq, struct task_struct *p);
+static void task_running_tick(struct rq *rq, struct task_struct *p, int tick);
 /*
  * Perform scheduler related setup for a newly forked process p.
  * p is forked by current.
@@ -1645,7 +1649,7 @@ void fastcall sched_fork(struct task_str
 		 * a problem.
 		 */
 		current->time_slice = 1;
-		task_running_tick(cpu_rq(cpu), current);
+		task_running_tick(cpu_rq(cpu), current, 0);
 	}
 	local_irq_enable();
 out:
@@ -1720,14 +1724,16 @@ void fastcall wake_up_new_task(struct ta
  */
 void fastcall sched_exit(struct task_struct *p)
 {
+	struct task_struct *parent;
 	unsigned long flags;
 	struct rq *rq;
 
-	rq = task_rq_lock(p->parent, &flags);
-	if (p->first_time_slice && task_cpu(p) == task_cpu(p->parent)) {
-		p->parent->time_slice += p->time_slice;
-		if (unlikely(p->parent->time_slice > p->quota))
-			p->parent->time_slice = p->quota;
+	parent = p->parent;
+	rq = task_rq_lock(parent, &flags);
+	if (p->first_time_slice && task_cpu(p) == task_cpu(parent)) {
+		parent->time_slice += p->time_slice;
+		if (unlikely(parent->time_slice > parent->quota))
+			parent->time_slice = parent->quota;
 	}
 	task_rq_unlock(rq, &flags);
 }
@@ -3372,7 +3378,7 @@ static inline void rotate_runqueue_prior
 	rq_quota(rq, new_prio_level) += 1;
 }
 
-static void task_running_tick(struct rq *rq, struct task_struct *p)
+static void task_running_tick(struct rq *rq, struct task_struct *p, int tick)
 {
 	if (unlikely(!task_queued(p))) {
 		/* Task has expired but was not scheduled yet */
@@ -3395,6 +3401,13 @@ static void task_running_tick(struct rq 
 	if (!--p->time_slice)
 		task_expired_entitlement(rq, p);
 	/*
+	 * If we're actually calling this function not in a scheduler_tick
+	 * we are doing so to fix accounting across fork and should not be
+	 * deducting anything from rq_quota.
+	 */
+	if (!tick)
+		goto out_unlock;
+	/*
 	 * We only employ the deadline mechanism if we run over the quota.
 	 * It allows aliasing problems around the scheduler_tick to be
 	 * less harmful.
@@ -3405,6 +3418,7 @@ static void task_running_tick(struct rq 
 		rotate_runqueue_priority(rq);
 		set_tsk_need_resched(p);
 	}
+out_unlock:
 	spin_unlock(&rq->lock);
 }
 
@@ -3423,7 +3437,7 @@ void scheduler_tick(void)
 	update_cpu_clock(p, rq, now);
 
 	if (!idle_at_tick)
-		task_running_tick(rq, p);
+		task_running_tick(rq, p, 1);
 #ifdef CONFIG_SMP
 	update_load(rq);
 	rq->idle_at_tick = idle_at_tick;
@@ -3469,20 +3483,13 @@ EXPORT_SYMBOL(sub_preempt_count);
 
 #endif
 
-/* Is a dynamic_prio part of the allocated slots for this static_prio */
-static inline int entitled_slot(int static_prio, int dynamic_prio)
-{
-	return !test_bit(USER_PRIO(dynamic_prio),
-		prio_matrix[USER_PRIO(static_prio)]);
-}
-
 /*
  * If a task is queued at a priority that isn't from its bitmap we exchange
  * by setting one of the entitlement bits.
  */
-static inline void exchange_slot(struct task_struct *p, int prio)
+static inline void exchange_slot(struct task_struct *p, struct rq *rq)
 {
-	int slot = next_prio_slot(p, prio);
+	int slot = next_entitled_slot(p, rq);
 
 	if (slot < MAX_PRIO)
 		__set_bit(USER_PRIO(slot), p->bitmap);
@@ -3524,6 +3531,7 @@ retry:
 	}
 	queue = array->queue + idx;
 	next = list_entry(queue->next, struct task_struct, run_list);
+	rq->prio_level = idx;
 	/*
 	 * When the task is chosen it is checked to see if its quota has been
 	 * added to this runqueue level which is only performed once per
@@ -3533,17 +3541,16 @@ retry:
 			/* Task has moved during major rotation */
 			task_new_array(next, rq);
 			if (!entitled_slot(next->static_prio, idx))
-				exchange_slot(next, idx);
+				exchange_slot(next, rq);
 			set_task_entitlement(next);
 			rq_quota(rq, idx) += next->quota;
 	} else if (!test_bit(USER_PRIO(idx), next->bitmap)) {
 			/* Task has moved during minor rotation */
 			if (!entitled_slot(next->static_prio, idx))
-				exchange_slot(next, idx);
+				exchange_slot(next, rq);
 			set_task_entitlement(next);
 			rq_quota(rq, idx) += next->quota;
 	}
-	rq->prio_level = idx;
 	/*
 	 * next needs to have its prio and array reset here in case the
 	 * values are wrong due to priority rotation.
@@ -3632,8 +3639,11 @@ need_resched_nonpreemptible:
 		next = list_entry(queue->next, struct task_struct, run_list);
 	}
 switch_tasks:
-	if (next == rq->idle)
+	if (next == rq->idle) {
+		rq->prio_level = MAX_RT_PRIO;
+		rq->prio_rotation++;
 		schedstat_inc(rq, sched_goidle);
+	}
 	prefetch(next);
 	prefetch_stack(next);
 	clear_tsk_need_resched(prev);
diff -puN kernel/sysctl.c~sched-rsdl-improvements kernel/sysctl.c
--- a/kernel/sysctl.c~sched-rsdl-improvements
+++ a/kernel/sysctl.c
@@ -78,6 +78,7 @@ extern int sysctl_drop_caches;
 extern int percpu_pagelist_fraction;
 extern int compat_log;
 extern int maps_protect;
+extern int rr_interval;
 
 /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
 static int maxolduid = 65535;
@@ -161,6 +162,13 @@ int sysctl_legacy_va_layout;
 #endif
 
 
+/* Constants for minimum and maximum testing in vm_table.
+   We use these as one-element integer vectors. */
+static int  __read_mostly zero;
+static int  __read_mostly one = 1;
+static int  __read_mostly one_hundred = 100;
+
+
 /* The default sysctl tables: */
 
 static ctl_table root_table[] = {
@@ -501,6 +509,17 @@ static ctl_table kern_table[] = {
 		.mode		= 0444,
 		.proc_handler	= &proc_dointvec,
 	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "rr_interval",
+		.data		= &rr_interval,
+		.maxlen		= sizeof (int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &one,
+		.extra2		= &one_hundred,
+	},
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86)
 	{
 		.ctl_name       = KERN_UNKNOWN_NMI_PANIC,
@@ -619,12 +638,6 @@ static ctl_table kern_table[] = {
 	{ .ctl_name = 0 }
 };
 
-/* Constants for minimum and maximum testing in vm_table.
-   We use these as one-element integer vectors. */
-static int zero;
-static int one_hundred = 100;
-
-
 static ctl_table vm_table[] = {
 	{
 		.ctl_name	= VM_OVERCOMMIT_MEMORY,
_

Patches currently in -mm which might be from kernel@kolivas.org are

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
