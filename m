From: akpm@linux-foundation.org
Subject: - cfs-scheduler-v15-rc3-mm1.patch removed from -mm tree
Date: Tue, 10 Jul 2007 12:49:51 -0700
Message-ID: <200707101949.l6AJnpdD026198@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51354 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760521AbXGJTzJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jul 2007 15:55:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     CFS scheduler, -v15, -rc3-mm1
has been removed from the -mm tree.  Its filename was
     cfs-scheduler-v15-rc3-mm1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: CFS scheduler, -v15, -rc3-mm1
From: Ingo Molnar <mingo@elte.hu>

-v15 includes smaller fixes only. More precise sched_info statistics
from Balbir Singh, interactivity tweaks from Mike Galbraith and a number
of corner-cases fixed/cleaned up by Dmitry Adamushko.

Changes since -v14:

 - more precise sched_info statistics (Balbir Singh)

 - call update_curr() when preempting to an RT task (Dmitry Adamushko)

 - smaller interactivity tweaks (Mike Galbraith)

 - apply runtime-limit to yield_to() as well (Dmitry Adamushko)

 - load-balancing iterator cleanup/simplification (Dmitry Adamushko)

 - fix code duplication (noticed by Li Yu)

 - cleanups (Mike Galbraith)

 - fix CPU usage accounting of threadeded apps in 'top'

 - more cleanups

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c       |   49 +++++---
 include/linux/sched.h |   10 -
 kernel/delayacct.c    |   10 -
 kernel/sched_fair.c   |  233 +++++++++++++++-------------------------
 kernel/sched_stats.h  |   28 ++--
 5 files changed, 150 insertions(+), 180 deletions(-)

diff -puN fs/proc/array.c~cfs-scheduler-v15-rc3-mm1 fs/proc/array.c
--- a/fs/proc/array.c~cfs-scheduler-v15-rc3-mm1
+++ a/fs/proc/array.c
@@ -320,6 +320,29 @@ int proc_pid_status(struct task_struct *
 	return buffer - orig;
 }
 
+static clock_t task_utime(struct task_struct *p)
+{
+	/*
+	 * Use CFS's precise accounting, if available:
+	 */
+	if (!has_rt_policy(p) && !(sysctl_sched_load_smoothing & 128))
+		return nsec_to_clock_t(p->sum_exec_runtime);
+
+	return cputime_to_clock_t(p->utime);
+}
+
+static clock_t task_stime(struct task_struct *p)
+{
+	/*
+	 * Use CFS's precise accounting, if available:
+	 */
+	if (!has_rt_policy(p) && !(sysctl_sched_load_smoothing & 128))
+		return 0;
+
+	return cputime_to_clock_t(p->stime);
+}
+
+
 static int do_task_stat(struct task_struct *task, char * buffer, int whole)
 {
 	unsigned long vsize, eip, esp, wchan = ~0UL;
@@ -334,7 +357,8 @@ static int do_task_stat(struct task_stru
 	unsigned long long start_time;
 	unsigned long cmin_flt = 0, cmaj_flt = 0;
 	unsigned long  min_flt = 0,  maj_flt = 0;
-	cputime_t cutime, cstime, utime, stime;
+	cputime_t cutime, cstime;
+	clock_t utime, stime;
 	unsigned long rsslim = 0;
 	char tcomm[sizeof(task->comm)];
 	unsigned long flags;
@@ -352,7 +376,8 @@ static int do_task_stat(struct task_stru
 
 	sigemptyset(&sigign);
 	sigemptyset(&sigcatch);
-	cutime = cstime = utime = stime = cputime_zero;
+	cutime = cstime = cputime_zero;
+	utime = stime = 0;
 
 	rcu_read_lock();
 	if (lock_task_sighand(task, &flags)) {
@@ -378,15 +403,15 @@ static int do_task_stat(struct task_stru
 			do {
 				min_flt += t->min_flt;
 				maj_flt += t->maj_flt;
-				utime = cputime_add(utime, t->utime);
-				stime = cputime_add(stime, t->stime);
+				utime += task_utime(t);
+				stime += task_stime(t);
 				t = next_thread(t);
 			} while (t != task);
 
 			min_flt += sig->min_flt;
 			maj_flt += sig->maj_flt;
-			utime = cputime_add(utime, sig->utime);
-			stime = cputime_add(stime, sig->stime);
+			utime += cputime_to_clock_t(sig->utime);
+			stime += cputime_to_clock_t(sig->stime);
 		}
 
 		sid = signal_session(sig);
@@ -402,8 +427,8 @@ static int do_task_stat(struct task_stru
 	if (!whole) {
 		min_flt = task->min_flt;
 		maj_flt = task->maj_flt;
-		utime = task->utime;
-		stime = task->stime;
+		utime = task_utime(task);
+		stime = task_stime(task);
 	}
 
 	/* scale priority and nice values from timeslices to -20..20 */
@@ -419,14 +444,6 @@ static int do_task_stat(struct task_stru
 	/* convert nsec -> ticks */
 	start_time = nsec_to_clock_t(start_time);
 
-	/*
-	 * Use CFS's precise accounting, if available:
-	 */
-	if (!has_rt_policy(task)) {
-		utime = nsec_to_clock_t(task->sum_exec_runtime);
-		stime = 0;
-	}
-
 	res = sprintf(buffer,"%d (%s) %c %d %d %d %d %d %u %lu \
 %lu %lu %lu %lu %lu %ld %ld %ld %ld %d 0 %llu %lu %ld %lu %lu %lu %lu %lu \
 %lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu\n",
diff -puN include/linux/sched.h~cfs-scheduler-v15-rc3-mm1 include/linux/sched.h
--- a/include/linux/sched.h~cfs-scheduler-v15-rc3-mm1
+++ a/include/linux/sched.h
@@ -595,13 +595,13 @@ struct reclaim_state;
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 struct sched_info {
 	/* cumulative counters */
-	unsigned long	cpu_time,	/* time spent on the cpu */
-			run_delay,	/* time spent waiting on a runqueue */
-			pcnt;		/* # of timeslices run on this cpu */
+	unsigned long pcnt;	      /* # of times run on this cpu */
+	unsigned long long cpu_time,  /* time spent on the cpu */
+			   run_delay; /* time spent waiting on a runqueue */
 
 	/* timestamps */
-	unsigned long	last_arrival,	/* when we last ran on a cpu */
-			last_queued;	/* when we were last queued to run */
+	unsigned long long last_arrival,/* when we last ran on a cpu */
+			   last_queued;	/* when we were last queued to run */
 };
 #endif /* defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT) */
 
diff -puN kernel/delayacct.c~cfs-scheduler-v15-rc3-mm1 kernel/delayacct.c
--- a/kernel/delayacct.c~cfs-scheduler-v15-rc3-mm1
+++ a/kernel/delayacct.c
@@ -99,9 +99,10 @@ void __delayacct_blkio_end(void)
 int __delayacct_add_tsk(struct taskstats *d, struct task_struct *tsk)
 {
 	s64 tmp;
-	struct timespec ts;
-	unsigned long t1,t2,t3;
+	unsigned long t1;
+	unsigned long long t2,t3;
 	unsigned long flags;
+	struct timespec ts;
 
 	/* Though tsk->delays accessed later, early exit avoids
 	 * unnecessary returning of other data
@@ -124,11 +125,10 @@ int __delayacct_add_tsk(struct taskstats
 
 	d->cpu_count += t1;
 
-	jiffies_to_timespec(t2, &ts);
-	tmp = (s64)d->cpu_delay_total + timespec_to_ns(&ts);
+	tmp = (s64)d->cpu_delay_total + t2;
 	d->cpu_delay_total = (tmp < (s64)d->cpu_delay_total) ? 0 : tmp;
 
-	tmp = (s64)d->cpu_run_virtual_total + (s64)jiffies_to_usecs(t3) * 1000;
+	tmp = (s64)d->cpu_run_virtual_total + t3;
 	d->cpu_run_virtual_total =
 		(tmp < (s64)d->cpu_run_virtual_total) ?	0 : tmp;
 
diff -puN kernel/sched_fair.c~cfs-scheduler-v15-rc3-mm1 kernel/sched_fair.c
--- a/kernel/sched_fair.c~cfs-scheduler-v15-rc3-mm1
+++ a/kernel/sched_fair.c
@@ -30,7 +30,7 @@ unsigned int sysctl_sched_wakeup_granula
 
 unsigned int sysctl_sched_runtime_limit __read_mostly = 6000000000ULL/HZ;
 
-unsigned int sysctl_sched_load_smoothing __read_mostly = 8 | 16 | 32;
+unsigned int sysctl_sched_load_smoothing __read_mostly = 1 | 2 | 4 | 8 | 0;
 
 /*
  * sys_sched_yield unfairness bug workaround switch.
@@ -134,34 +134,19 @@ niced_granularity(struct task_struct *cu
 	return curr->load_weight * (s64)(granularity / NICE_0_LOAD);
 }
 
-unsigned long get_rq_load(struct rq *rq)
-{
-	unsigned long load = rq->cpu_load[CPU_LOAD_IDX_MAX-1] + 1;
-
-	if (!(sysctl_sched_load_smoothing & 1))
-		return rq->raw_weighted_load;
-
-	if (sysctl_sched_load_smoothing & 4)
-		load = max(load, rq->raw_weighted_load);
-
-	return load;
-}
-
 static void limit_wait_runtime(struct rq *rq, struct task_struct *p)
 {
 	s64 limit = sysctl_sched_runtime_limit;
-	s64 nice_limit = limit; // niced_granularity(p, limit);
 
 	/*
 	 * Niced tasks have the same history dynamic range as
-	 * non-niced tasks, but their limits are offset.
+	 * non-niced tasks:
 	 */
-	if (p->wait_runtime > nice_limit) {
-		p->wait_runtime = nice_limit;
+	if (p->wait_runtime > limit) {
+		p->wait_runtime = limit;
 		p->wait_runtime_overruns++;
 		rq->wait_runtime_overruns++;
 	}
-	limit = (limit << 1) - nice_limit;
 	if (p->wait_runtime < -limit) {
 		p->wait_runtime = -limit;
 		p->wait_runtime_underruns++;
@@ -183,59 +168,64 @@ static void add_wait_runtime(struct rq *
 	rq->wait_runtime += p->wait_runtime;
 }
 
+static s64 div64_s(s64 divident, unsigned long divisor)
+{
+	u64 tmp;
+
+	if (divident < 0) {
+		tmp = -divident;
+		do_div(tmp, divisor);
+		return -(s64)tmp;
+	} else {
+		tmp = divident;
+		do_div(tmp, divisor);
+		return (s64)tmp;
+	}
+}
+
 /*
  * Update the current task's runtime statistics. Skip current tasks that
  * are not in our scheduling class.
  */
 static inline void update_curr(struct rq *rq, u64 now)
 {
+	unsigned long load = rq->raw_weighted_load;
 	u64 delta_exec, delta_fair, delta_mine;
 	struct task_struct *curr = rq->curr;
 
-	if (curr->sched_class != &fair_sched_class ||
-			!rq->raw_weighted_load || curr == rq->idle)
+	if (curr->sched_class != &fair_sched_class || curr == rq->idle)
 		return;
 	/*
 	 * Get the amount of time the current task was running
 	 * since the last time we changed raw_weighted_load:
 	 */
 	delta_exec = now - curr->exec_start;
+	if (unlikely(delta_exec < 0))
+		delta_exec = 0;
 	if (unlikely(delta_exec > curr->exec_max))
 		curr->exec_max = delta_exec;
 
-	if (sysctl_sched_load_smoothing & 1) {
-		unsigned long load = get_rq_load(rq);
-
-		if (sysctl_sched_load_smoothing & 2) {
-			delta_fair = delta_exec * NICE_0_LOAD;
-			do_div(delta_fair, load);
-		} else {
-			delta_fair = delta_exec * NICE_0_LOAD;
-			do_div(delta_fair, rq->raw_weighted_load);
-		}
-
-		delta_mine = delta_exec * curr->load_weight;
-		do_div(delta_mine, load);
-	} else {
-		delta_fair = delta_exec * NICE_0_LOAD;
-		delta_fair += rq->raw_weighted_load >> 1;
-		do_div(delta_fair, rq->raw_weighted_load);
-
-		delta_mine = delta_exec * curr->load_weight;
-		delta_mine += rq->raw_weighted_load >> 1;
-		do_div(delta_mine, rq->raw_weighted_load);
-	}
-
 	curr->sum_exec_runtime += delta_exec;
 	curr->exec_start = now;
 	rq->exec_clock += delta_exec;
 
+	if (!load)
+		return;
 	/*
 	 * Task already marked for preemption, do not burden
-	 * it with the cost of not having left the CPU yet.
+	 * it with the cost of not having left the CPU yet:
 	 */
-	if (unlikely(test_tsk_thread_flag(curr, TIF_NEED_RESCHED)))
-		goto out_nowait;
+	if (unlikely(sysctl_sched_load_smoothing & 1))
+		if (unlikely(test_tsk_thread_flag(curr, TIF_NEED_RESCHED)))
+			return;
+
+	delta_fair = delta_exec * NICE_0_LOAD;
+	delta_fair += load >> 1;
+	do_div(delta_fair, load);
+
+	delta_mine = delta_exec * curr->load_weight;
+	delta_mine += load >> 1;
+	do_div(delta_mine, load);
 
 	rq->fair_clock += delta_fair;
 	/*
@@ -246,8 +236,6 @@ static inline void update_curr(struct rq
 	 * [Note: delta_mine - delta_exec is negative]:
 	 */
 	add_wait_runtime(rq, curr, delta_mine - delta_exec);
-out_nowait:
-	;
 }
 
 static inline void
@@ -279,47 +267,13 @@ update_stats_enqueue(struct rq *rq, stru
 	/*
 	 * Optimize the common nice 0 case:
 	 */
-	if (likely(p->load_weight == NICE_0_LOAD)) {
+	if (likely(p->load_weight == NICE_0_LOAD))
 		key -= p->wait_runtime;
-	} else {
-		int negative = p->wait_runtime < 0;
-		u64 tmp;
-
-		if (p->load_weight > NICE_0_LOAD) {
-			/* negative-reniced tasks get helped: */
-
-			if (negative) {
-				tmp = -p->wait_runtime;
-				tmp *= NICE_0_LOAD;
-				do_div(tmp, p->load_weight);
-
-				key += tmp;
-			} else {
-				tmp = p->wait_runtime;
-				tmp *= p->load_weight;
-				do_div(tmp, NICE_0_LOAD);
-
-				key -= tmp;
-			}
-		} else {
-			/* plus-reniced tasks get hurt: */
-
-			if (negative) {
-				tmp = -p->wait_runtime;
-
-				tmp *= NICE_0_LOAD;
-				do_div(tmp, p->load_weight);
-
-				key += tmp;
-			} else {
-				tmp = p->wait_runtime;
-
-				tmp *= p->load_weight;
-				do_div(tmp, NICE_0_LOAD);
-
-				key -= tmp;
-			}
-		}
+	else {
+		if (p->wait_runtime < 0)
+			key -= div64_s(p->wait_runtime * NICE_0_LOAD, p->load_weight);
+		else
+			key -= div64_s(p->wait_runtime * p->load_weight, NICE_0_LOAD);
 	}
 
 	p->fair_key = key;
@@ -339,9 +293,10 @@ update_stats_wait_end(struct rq *rq, str
 
 	if (p->wait_start_fair) {
 		delta_fair = rq->fair_clock - p->wait_start_fair;
+
 		if (unlikely(p->load_weight != NICE_0_LOAD))
-			delta_fair = (delta_fair * p->load_weight) /
-								NICE_0_LOAD;
+			delta_fair = div64_s(delta_fair * p->load_weight,
+								NICE_0_LOAD);
 		add_wait_runtime(rq, p, delta_fair);
 	}
 
@@ -379,31 +334,14 @@ update_stats_curr_start(struct rq *rq, s
 static inline void
 update_stats_curr_end(struct rq *rq, struct task_struct *p, u64 now)
 {
-	update_curr(rq, now);
-
 	p->exec_start = 0;
 }
 
-long div64_s(s64 divident, unsigned long divisor)
-{
-	u64 tmp;
-
-	if (divident < 0) {
-		tmp = -divident;
-		do_div(tmp, divisor);
-		return -(s64)tmp;
-	} else {
-		tmp = divident;
-		do_div(tmp, divisor);
-		return (s64)tmp;
-	}
-}
-
 /*
  * A task gets added back to the runnable tasks and gets
- * a small credit for the CPU time it missed out on while
- * it slept, so fix up all other runnable task's wait_runtime
- * so that the sum stays constant (around 0).
+ * a small credit for the CPU time it missed out on, so
+ * fix up all other runnable task's wait_runtime so that
+ * the sum stays constant (around 0).
  *
  * Instead of looping over all runnable tasks in an O(N)
  * manner we move the fair clock back by a proportional
@@ -414,7 +352,7 @@ static void distribute_fair_add(struct r
 	struct task_struct *curr = rq->curr;
 	s64 delta_fair = 0;
 
-	if (!(sysctl_sched_load_smoothing & 32))
+	if (!(sysctl_sched_load_smoothing & 2))
 		return;
 
 	if (rq->nr_running) {
@@ -424,8 +362,8 @@ static void distribute_fair_add(struct r
 		 * not depend on the fair_clock, so fix it up explicitly:
 		 */
 		add_wait_runtime(rq, curr, -delta_fair);
-		rq->fair_clock -= delta_fair;
 	}
+	rq->fair_clock -= delta_fair;
 }
 
 /**************************************************************/
@@ -434,22 +372,19 @@ static void distribute_fair_add(struct r
 
 static void enqueue_sleeper(struct rq *rq, struct task_struct *p)
 {
-	unsigned long load = get_rq_load(rq);
+	unsigned long load = rq->raw_weighted_load;
 	s64 delta_fair, prev_runtime;
 
-	if (!(sysctl_sched_load_smoothing & 16))
+	if (!(sysctl_sched_load_smoothing & 4))
 		goto out;
 
 	delta_fair = rq->fair_clock - p->sleep_start_fair;
-	if ((s64)delta_fair < 0)
-		delta_fair = 0;
 
 	/*
 	 * Fix up delta_fair with the effect of us running
 	 * during the whole sleep period:
 	 */
-	if (sysctl_sched_load_smoothing & 8)
-		delta_fair = div64_s(delta_fair * load, load + p->load_weight);
+	delta_fair = div64_s(delta_fair * load, load + p->load_weight);
 
 	prev_runtime = p->wait_runtime;
 	__add_wait_runtime(rq, p, delta_fair);
@@ -577,10 +512,13 @@ yield_task_fair(struct rq *rq, struct ta
 	 * yield-to support: if we are on the same runqueue then
 	 * give half of our wait_runtime (if it's positive) to the other task:
 	 */
-	if (p_to && p->wait_runtime > 0) {
-		p_to->wait_runtime += p->wait_runtime >> 1;
-		p->wait_runtime >>= 1;
+	if (p_to && rq == task_rq(p_to) && p->wait_runtime > 0) {
+		s64 delta = p->wait_runtime >> 1;
+
+		__add_wait_runtime(rq, p_to, delta);
+		__add_wait_runtime(rq, p, -delta);
 	}
+
 	curr = &p->run_node;
 	first = first_fair(rq);
 	/*
@@ -645,6 +583,10 @@ static void check_preempt_curr_fair(stru
 	struct task_struct *curr = rq->curr;
 
 	if ((curr == rq->idle) || rt_prio(p->prio)) {
+		if (sysctl_sched_load_smoothing & 8) {
+			if (rt_prio(p->prio))
+				update_curr(rq, rq_clock(rq));
+		}
 		resched_task(curr);
 	} else {
 		__check_preempt_curr_fair(rq, p, curr,
@@ -677,11 +619,27 @@ static void put_prev_task_fair(struct rq
 	if (prev == rq->idle)
 		return;
 
-	update_stats_curr_end(rq, prev, now);
 	/*
 	 * If the task is still waiting for the CPU (it just got
-	 * preempted), start the wait period:
+	 * preempted), update its position within the tree and
+	 * start the wait period:
 	 */
+	if (sysctl_sched_load_smoothing & 16)  {
+		if (prev->on_rq &&
+			test_tsk_thread_flag(prev, TIF_NEED_RESCHED)) {
+
+			dequeue_task_fair(rq, prev, 0, now);
+			prev->on_rq = 0;
+			enqueue_task_fair(rq, prev, 0, now);
+			prev->on_rq = 1;
+		} else
+			update_curr(rq, now);
+	} else {
+		update_curr(rq, now);
+	}
+
+	update_stats_curr_end(rq, prev, now);
+
 	if (prev->on_rq)
 		update_stats_wait_start(rq, prev, now);
 }
@@ -697,33 +655,28 @@ static void put_prev_task_fair(struct rq
  * achieve that by always pre-iterating before returning
  * the current task:
  */
-static struct task_struct * load_balance_start_fair(struct rq *rq)
+static inline struct task_struct *
+__load_balance_iterator(struct rq *rq, struct rb_node *curr)
 {
-	struct rb_node *first = first_fair(rq);
 	struct task_struct *p;
 
-	if (!first)
+	if (!curr)
 		return NULL;
 
-	p = rb_entry(first, struct task_struct, run_node);
-
-	rq->rb_load_balance_curr = rb_next(first);
+	p = rb_entry(curr, struct task_struct, run_node);
+	rq->rb_load_balance_curr = rb_next(curr);
 
 	return p;
 }
 
-static struct task_struct * load_balance_next_fair(struct rq *rq)
+static struct task_struct * load_balance_start_fair(struct rq *rq)
 {
-	struct rb_node *curr = rq->rb_load_balance_curr;
-	struct task_struct *p;
-
-	if (!curr)
-		return NULL;
-
-	p = rb_entry(curr, struct task_struct, run_node);
-	rq->rb_load_balance_curr = rb_next(curr);
+	return __load_balance_iterator(rq, first_fair(rq));
+}
 
-	return p;
+static struct task_struct * load_balance_next_fair(struct rq *rq)
+{
+	return __load_balance_iterator(rq, rq->rb_load_balance_curr);
 }
 
 /*
diff -puN kernel/sched_stats.h~cfs-scheduler-v15-rc3-mm1 kernel/sched_stats.h
--- a/kernel/sched_stats.h~cfs-scheduler-v15-rc3-mm1
+++ a/kernel/sched_stats.h
@@ -97,10 +97,10 @@ const struct file_operations proc_scheds
  * Expects runqueue lock to be held for atomicity of update
  */
 static inline void
-rq_sched_info_arrive(struct rq *rq, unsigned long delta_jiffies)
+rq_sched_info_arrive(struct rq *rq, unsigned long long delta)
 {
 	if (rq) {
-		rq->rq_sched_info.run_delay += delta_jiffies;
+		rq->rq_sched_info.run_delay += delta;
 		rq->rq_sched_info.pcnt++;
 	}
 }
@@ -109,19 +109,19 @@ rq_sched_info_arrive(struct rq *rq, unsi
  * Expects runqueue lock to be held for atomicity of update
  */
 static inline void
-rq_sched_info_depart(struct rq *rq, unsigned long delta_jiffies)
+rq_sched_info_depart(struct rq *rq, unsigned long long delta)
 {
 	if (rq)
-		rq->rq_sched_info.cpu_time += delta_jiffies;
+		rq->rq_sched_info.cpu_time += delta;
 }
 # define schedstat_inc(rq, field)	do { (rq)->field++; } while (0)
 # define schedstat_add(rq, field, amt)	do { (rq)->field += (amt); } while (0)
 #else /* !CONFIG_SCHEDSTATS */
 static inline void
-rq_sched_info_arrive(struct rq *rq, unsigned long delta_jiffies)
+rq_sched_info_arrive(struct rq *rq, unsigned long long delta)
 {}
 static inline void
-rq_sched_info_depart(struct rq *rq, unsigned long delta_jiffies)
+rq_sched_info_depart(struct rq *rq, unsigned long long delta)
 {}
 # define schedstat_inc(rq, field)	do { } while (0)
 # define schedstat_add(rq, field, amt)	do { } while (0)
@@ -155,16 +155,16 @@ static inline void sched_info_dequeued(s
  */
 static void sched_info_arrive(struct task_struct *t)
 {
-	unsigned long now = jiffies, delta_jiffies = 0;
+	unsigned long long now = sched_clock(), delta = 0;
 
 	if (t->sched_info.last_queued)
-		delta_jiffies = now - t->sched_info.last_queued;
+		delta = now - t->sched_info.last_queued;
 	sched_info_dequeued(t);
-	t->sched_info.run_delay += delta_jiffies;
+	t->sched_info.run_delay += delta;
 	t->sched_info.last_arrival = now;
 	t->sched_info.pcnt++;
 
-	rq_sched_info_arrive(task_rq(t), delta_jiffies);
+	rq_sched_info_arrive(task_rq(t), delta);
 }
 
 /*
@@ -186,7 +186,7 @@ static inline void sched_info_queued(str
 {
 	if (unlikely(sched_info_on()))
 		if (!t->sched_info.last_queued)
-			t->sched_info.last_queued = jiffies;
+			t->sched_info.last_queued = sched_clock();
 }
 
 /*
@@ -195,10 +195,10 @@ static inline void sched_info_queued(str
  */
 static inline void sched_info_depart(struct task_struct *t)
 {
-	unsigned long delta_jiffies = jiffies - t->sched_info.last_arrival;
+	unsigned long long delta = sched_clock() - t->sched_info.last_arrival;
 
-	t->sched_info.cpu_time += delta_jiffies;
-	rq_sched_info_depart(task_rq(t), delta_jiffies);
+	t->sched_info.cpu_time += delta;
+	rq_sched_info_depart(task_rq(t), delta);
 }
 
 /*
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
git-acpi.patch
git-kvm.patch
git-selinux.patch
git-s390.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
tick-management-spread-timer-interrupt.patch
highres-improve-debug-output.patch
hrtimer-speedup-hrtimer_enqueue.patch
pcspkr-use-the-global-pit-lock.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
i386-pit-stop-only-when-in-periodic-or-oneshot-mode.patch
i386-remove-volatile-in-apicc.patch
i386-hpet-assumes-boot-cpu-is-0.patch
i386-move-pit-function-declarations-and-constants-to-correct-header-file.patch
x86_64-untangle-asm-hpeth-from-asm-timexh.patch
x86_64-use-generic-cmos-update.patch
x86_64-remove-dead-code-and-other-janitor-work-in-tscc.patch
x86_64-fix-apic-typo.patch
x86_64-convert-to-cleckevents.patch
acpi-remove-the-useless-ifdef-code.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-block-irq-balancing-for-timer.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer.patch
ich-force-hpet-restructure-hpet-generic-clock-code.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-late-initialization-of-hpet-after-quirk.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch
ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch
geode-mfgpt-clock-event-device-support.patch
i386-ioapic-remove-old-irq-balancing-debug-cruft.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
introduce-write_trylock_irqsave.patch
use-write_trylock_irqsave-in-ptrace_attach.patch
introduce-boot-based-time.patch
use-boot-based-time-for-process-start-time-and-boot-time.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
pie-randomization.patch
vdso-print-fatal-signals.patch
remove-clockevents_releaserequest_device.patch
add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch
introduce-o_cloexec-take-2.patch
o_cloexec-for-scm_rights.patch
improve-behaviour-of-spurious-irq-detect.patch
allow-softlockup-to-be-runtime-disabled.patch
sys_time-speedup.patch
futex-tidy-up-the-code-v2.patch
modules-remove-modlist_lock.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
fix-raw_spinlock_t-vs-lockdep.patch
lockdep-sanitise-config_prove_locking.patch
lockdep-reduce-the-ifdeffery.patch
lockstat-core-infrastructure.patch
lockstat-human-readability-tweaks.patch
lockstat-hook-into-spinlock_t-rwlock_t-rwsem-and-mutex.patch
lockdep-various-fixes.patch
lockdep-fixup-sk_callback_lock-annotation.patch
lockstat-measure-lock-bouncing.patch
lockstat-better-class-name-representation.patch
lockdep-debugging-give-stacktrace-for-init_error.patch
stacktrace-fix-header-file-for-config_stacktrace.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
kmap_atomic-debugging.patch
random-warning-squishes.patch
