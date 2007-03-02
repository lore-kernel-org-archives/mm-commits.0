From: akpm@linux-foundation.org
Subject: + sched-remove-smt-nice.patch added to -mm tree
Date: Thu, 01 Mar 2007 17:31:11 -0800
Message-ID: <200703020131.l221VB5K028812@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34275 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422696AbXCBBbZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 20:31:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kernel@kolivas.org, mingo@elte.hu, nickpiggin@yahoo.com.au


The patch titled
     sched: remove SMT nice
has been added to the -mm tree.  Its filename is
     sched-remove-smt-nice.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sched: remove SMT nice
From: Con Kolivas <kernel@kolivas.org>

Remove the SMT-nice feature which idles sibling cpus on SMT cpus to
facilitiate nice working properly where cpu power is shared.  The idling of
cpus in the presence of runnable tasks is considered too fragile, easy to
break with outside code, and the complexity of managing this system if an
architecture comes along with many logical cores sharing cpu power will be
unworkable.

Remove the associated per_cpu_gain variable in sched_domains used only by
this code.

Signed-off-by: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/topology.h           |    1 
 include/asm-ia64/topology.h           |    2 
 include/asm-mips/mach-ip27/topology.h |    1 
 include/asm-powerpc/topology.h        |    1 
 include/asm-x86_64/topology.h         |    1 
 include/linux/sched.h                 |    1 
 include/linux/topology.h              |    4 
 kernel/sched.c                        |  155 ------------------------
 8 files changed, 1 insertion(+), 165 deletions(-)

diff -puN include/asm-i386/topology.h~sched-remove-smt-nice include/asm-i386/topology.h
--- a/include/asm-i386/topology.h~sched-remove-smt-nice
+++ a/include/asm-i386/topology.h
@@ -85,7 +85,6 @@ static inline int node_to_first_cpu(int 
 	.idle_idx		= 1,			\
 	.newidle_idx		= 2,			\
 	.wake_idx		= 1,			\
-	.per_cpu_gain		= 100,			\
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_EXEC	\
 				| SD_BALANCE_FORK	\
diff -puN include/asm-ia64/topology.h~sched-remove-smt-nice include/asm-ia64/topology.h
--- a/include/asm-ia64/topology.h~sched-remove-smt-nice
+++ a/include/asm-ia64/topology.h
@@ -65,7 +65,6 @@ void build_cpu_to_node_map(void);
 	.max_interval		= 4,			\
 	.busy_factor		= 64,			\
 	.imbalance_pct		= 125,			\
-	.per_cpu_gain		= 100,			\
 	.cache_nice_tries	= 2,			\
 	.busy_idx		= 2,			\
 	.idle_idx		= 1,			\
@@ -97,7 +96,6 @@ void build_cpu_to_node_map(void);
 	.newidle_idx		= 0, /* unused */	\
 	.wake_idx		= 1,			\
 	.forkexec_idx		= 1,			\
-	.per_cpu_gain		= 100,			\
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_EXEC	\
 				| SD_BALANCE_FORK	\
diff -puN include/asm-mips/mach-ip27/topology.h~sched-remove-smt-nice include/asm-mips/mach-ip27/topology.h
--- a/include/asm-mips/mach-ip27/topology.h~sched-remove-smt-nice
+++ a/include/asm-mips/mach-ip27/topology.h
@@ -28,7 +28,6 @@ extern unsigned char __node_distances[MA
 	.busy_factor		= 32,			\
 	.imbalance_pct		= 125,			\
 	.cache_nice_tries	= 1,			\
-	.per_cpu_gain		= 100,			\
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_EXEC	\
 				| SD_WAKE_BALANCE,	\
diff -puN include/asm-powerpc/topology.h~sched-remove-smt-nice include/asm-powerpc/topology.h
--- a/include/asm-powerpc/topology.h~sched-remove-smt-nice
+++ a/include/asm-powerpc/topology.h
@@ -57,7 +57,6 @@ static inline int pcibus_to_node(struct 
 	.busy_factor		= 32,			\
 	.imbalance_pct		= 125,			\
 	.cache_nice_tries	= 1,			\
-	.per_cpu_gain		= 100,			\
 	.busy_idx		= 3,			\
 	.idle_idx		= 1,			\
 	.newidle_idx		= 2,			\
diff -puN include/asm-x86_64/topology.h~sched-remove-smt-nice include/asm-x86_64/topology.h
--- a/include/asm-x86_64/topology.h~sched-remove-smt-nice
+++ a/include/asm-x86_64/topology.h
@@ -43,7 +43,6 @@ extern int __node_distance(int, int);
 	.newidle_idx		= 0, 			\
 	.wake_idx		= 1,			\
 	.forkexec_idx		= 1,			\
-	.per_cpu_gain		= 100,			\
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_FORK	\
 				| SD_BALANCE_EXEC	\
diff -puN include/linux/sched.h~sched-remove-smt-nice include/linux/sched.h
--- a/include/linux/sched.h~sched-remove-smt-nice
+++ a/include/linux/sched.h
@@ -684,7 +684,6 @@ struct sched_domain {
 	unsigned int imbalance_pct;	/* No balance until over watermark */
 	unsigned long long cache_hot_time; /* Task considered cache hot (ns) */
 	unsigned int cache_nice_tries;	/* Leave cache hot tasks for # tries */
-	unsigned int per_cpu_gain;	/* CPU % gained by adding domain cpus */
 	unsigned int busy_idx;
 	unsigned int idle_idx;
 	unsigned int newidle_idx;
diff -puN include/linux/topology.h~sched-remove-smt-nice include/linux/topology.h
--- a/include/linux/topology.h~sched-remove-smt-nice
+++ a/include/linux/topology.h
@@ -96,7 +96,6 @@
 	.busy_factor		= 64,			\
 	.imbalance_pct		= 110,			\
 	.cache_nice_tries	= 0,			\
-	.per_cpu_gain		= 25,			\
 	.busy_idx		= 0,			\
 	.idle_idx		= 0,			\
 	.newidle_idx		= 1,			\
@@ -128,7 +127,6 @@
 	.busy_factor		= 64,			\
 	.imbalance_pct		= 125,			\
 	.cache_nice_tries	= 1,			\
-	.per_cpu_gain		= 100,			\
 	.busy_idx		= 2,			\
 	.idle_idx		= 1,			\
 	.newidle_idx		= 2,			\
@@ -159,7 +157,6 @@
 	.busy_factor		= 64,			\
 	.imbalance_pct		= 125,			\
 	.cache_nice_tries	= 1,			\
-	.per_cpu_gain		= 100,			\
 	.busy_idx		= 2,			\
 	.idle_idx		= 1,			\
 	.newidle_idx		= 2,			\
@@ -193,7 +190,6 @@
 	.newidle_idx		= 0, /* unused */	\
 	.wake_idx		= 0, /* unused */	\
 	.forkexec_idx		= 0, /* unused */	\
-	.per_cpu_gain		= 100,			\
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_SERIALIZE,	\
 	.last_balance		= jiffies,		\
diff -puN kernel/sched.c~sched-remove-smt-nice kernel/sched.c
--- a/kernel/sched.c~sched-remove-smt-nice
+++ a/kernel/sched.c
@@ -3006,23 +3006,6 @@ static inline void idle_balance(int cpu,
 }
 #endif
 
-static inline void wake_priority_sleeper(struct rq *rq)
-{
-#ifdef CONFIG_SCHED_SMT
-	if (!rq->nr_running)
-		return;
-
-	spin_lock(&rq->lock);
-	/*
-	 * If an SMT sibling task has been put to sleep for priority
-	 * reasons reschedule the idle task to see if it can now run.
-	 */
-	if (rq->nr_running)
-		resched_task(rq->idle);
-	spin_unlock(&rq->lock);
-#endif
-}
-
 DEFINE_PER_CPU(struct kernel_stat, kstat);
 
 EXPORT_PER_CPU_SYMBOL(kstat);
@@ -3239,10 +3222,7 @@ void scheduler_tick(void)
 
 	update_cpu_clock(p, rq, now);
 
-	if (p == rq->idle)
-		/* Task on the idle queue */
-		wake_priority_sleeper(rq);
-	else
+	if (p != rq->idle)
 		task_running_tick(rq, p);
 #ifdef CONFIG_SMP
 	update_load(rq);
@@ -3251,136 +3231,6 @@ void scheduler_tick(void)
 #endif
 }
 
-#ifdef CONFIG_SCHED_SMT
-static inline void wakeup_busy_runqueue(struct rq *rq)
-{
-	/* If an SMT runqueue is sleeping due to priority reasons wake it up */
-	if (rq->curr == rq->idle && rq->nr_running)
-		resched_task(rq->idle);
-}
-
-/*
- * Called with interrupt disabled and this_rq's runqueue locked.
- */
-static void wake_sleeping_dependent(int this_cpu)
-{
-	struct sched_domain *tmp, *sd = NULL;
-	int i;
-
-	for_each_domain(this_cpu, tmp) {
-		if (tmp->flags & SD_SHARE_CPUPOWER) {
-			sd = tmp;
-			break;
-		}
-	}
-
-	if (!sd)
-		return;
-
-	for_each_cpu_mask(i, sd->span) {
-		struct rq *smt_rq = cpu_rq(i);
-
-		if (i == this_cpu)
-			continue;
-		if (unlikely(!spin_trylock(&smt_rq->lock)))
-			continue;
-
-		wakeup_busy_runqueue(smt_rq);
-		spin_unlock(&smt_rq->lock);
-	}
-}
-
-/*
- * number of 'lost' timeslices this task wont be able to fully
- * utilize, if another task runs on a sibling. This models the
- * slowdown effect of other tasks running on siblings:
- */
-static inline unsigned long
-smt_slice(struct task_struct *p, struct sched_domain *sd)
-{
-	return p->time_slice * (100 - sd->per_cpu_gain) / 100;
-}
-
-/*
- * To minimise lock contention and not have to drop this_rq's runlock we only
- * trylock the sibling runqueues and bypass those runqueues if we fail to
- * acquire their lock. As we only trylock the normal locking order does not
- * need to be obeyed.
- */
-static int
-dependent_sleeper(int this_cpu, struct rq *this_rq, struct task_struct *p)
-{
-	struct sched_domain *tmp, *sd = NULL;
-	int ret = 0, i;
-
-	/* kernel/rt threads do not participate in dependent sleeping */
-	if (!p->mm || rt_task(p))
-		return 0;
-
-	for_each_domain(this_cpu, tmp) {
-		if (tmp->flags & SD_SHARE_CPUPOWER) {
-			sd = tmp;
-			break;
-		}
-	}
-
-	if (!sd)
-		return 0;
-
-	for_each_cpu_mask(i, sd->span) {
-		struct task_struct *smt_curr;
-		struct rq *smt_rq;
-
-		if (i == this_cpu)
-			continue;
-
-		smt_rq = cpu_rq(i);
-		if (unlikely(!spin_trylock(&smt_rq->lock)))
-			continue;
-
-		smt_curr = smt_rq->curr;
-
-		if (!smt_curr->mm)
-			goto unlock;
-
-		/*
-		 * If a user task with lower static priority than the
-		 * running task on the SMT sibling is trying to schedule,
-		 * delay it till there is proportionately less timeslice
-		 * left of the sibling task to prevent a lower priority
-		 * task from using an unfair proportion of the
-		 * physical cpu's resources. -ck
-		 */
-		if (rt_task(smt_curr)) {
-			/*
-			 * With real time tasks we run non-rt tasks only
-			 * per_cpu_gain% of the time.
-			 */
-			if ((jiffies % DEF_TIMESLICE) >
-				(sd->per_cpu_gain * DEF_TIMESLICE / 100))
-					ret = 1;
-		} else {
-			if (smt_curr->static_prio < p->static_prio &&
-				!TASK_PREEMPTS_CURR(p, smt_rq) &&
-				smt_slice(smt_curr, sd) > task_timeslice(p))
-					ret = 1;
-		}
-unlock:
-		spin_unlock(&smt_rq->lock);
-	}
-	return ret;
-}
-#else
-static inline void wake_sleeping_dependent(int this_cpu)
-{
-}
-static inline int
-dependent_sleeper(int this_cpu, struct rq *this_rq, struct task_struct *p)
-{
-	return 0;
-}
-#endif
-
 #if defined(CONFIG_PREEMPT) && defined(CONFIG_DEBUG_PREEMPT)
 
 void fastcall add_preempt_count(int val)
@@ -3507,7 +3357,6 @@ need_resched_nonpreemptible:
 		if (!rq->nr_running) {
 			next = rq->idle;
 			rq->expired_timestamp = 0;
-			wake_sleeping_dependent(cpu);
 			goto switch_tasks;
 		}
 	}
@@ -3547,8 +3396,6 @@ need_resched_nonpreemptible:
 		}
 	}
 	next->sleep_type = SLEEP_NORMAL;
-	if (rq->nr_running == 1 && dependent_sleeper(cpu, rq, next))
-		next = rq->idle;
 switch_tasks:
 	if (next == rq->idle)
 		schedstat_inc(rq, sched_goidle);
_

Patches currently in -mm which might be from kernel@kolivas.org are

sched-remove-smt-nice.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
