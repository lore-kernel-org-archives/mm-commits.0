From: akpm@linux-foundation.org
Subject: + cfs-scheduler-v16.patch added to -mm tree
Date: Mon, 11 Jun 2007 11:36:38 -0700
Message-ID: <200706111836.l5BIacfb026088@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47756 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756468AbXFKSg5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jun 2007 14:36:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, dmitry.adamushko@gmail.com


The patch titled
     CFS scheduler, -v16
has been added to the -mm tree.  Its filename is
     cfs-scheduler-v16.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: CFS scheduler, -v16
From: Ingo Molnar <mingo@elte.hu>

-v16 includes smaller fixes. Continued work on precise /proc CPU
accounting of both SCHED_OTHER and RT tasks by Dmitry Adamushko and
Balbir Singh. Reniced tasks should now disturb nice-0 tasks even less.
Also, i have changed SCHED_BATCH back to its current mainline meaning
and have added a SCHED_IDLEPRIO instead (first introduced by Con Kolivas
in staircase/RSDL/SD).

Changes since -v15:

 - more /proc CPU stats accounting improvements (Dmitry Adamushko,
   Balbir Singh)

 - fix SCHED_BATCH (reported by Con Kolivas)

 - update_load_fair() - use 64-bit arithmetics (Dmitry Adamushko)

 - fix RT->NORMAL accounting issue raised by Srivatsa Vaddagiri: have
   correct exec_start stamping. (Dmitry Adamushko)

 - check for negative deltas in task_sched_runtime() (Dmitry Adamushko)

 - check for large forward-jumping sched_clock()

 - cleanup: remove task_struct :: last_ran (Dmitry Adamushko)

 - /proc/sched_debug printk fixes (Andrew Morton)

 - add SCHED_IDLEPRIO

 - consolidate the granularity settings and make them scale together

 - improve /proc/sched_debug output

 - remove the yield workarounds - the default seems to be working now.

 - introduce lower and upper limits for the granularity tunables.
   Setting them to zero accidentally broke nice levels.

 - various small fixes/cleanups

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/drm/radeon_cp.c |    5 -
 fs/proc/array.c              |   32 ++++--
 include/linux/sched.h        |   10 +-
 kernel/posix-cpu-timers.c    |    2 
 kernel/sched.c               |  127 +++++++++++++++-----------
 kernel/sched_debug.c         |   38 +++++--
 kernel/sched_fair.c          |  160 +++++++++++++--------------------
 kernel/sched_rt.c            |   36 ++++++-
 kernel/sysctl.c              |   34 +++----
 9 files changed, 247 insertions(+), 197 deletions(-)

diff -puN drivers/char/drm/radeon_cp.c~cfs-scheduler-v16 drivers/char/drm/radeon_cp.c
--- a/drivers/char/drm/radeon_cp.c~cfs-scheduler-v16
+++ a/drivers/char/drm/radeon_cp.c
@@ -2267,11 +2267,6 @@ int radeon_driver_load(struct drm_device
 
 	DRM_DEBUG("%s card detected\n",
 		  ((dev_priv->flags & RADEON_IS_AGP) ? "AGP" : (((dev_priv->flags & RADEON_IS_PCIE) ? "PCIE" : "PCI"))));
-	if (sysctl_sched_yield_bug_workaround == -1) {
-		sysctl_sched_yield_bug_workaround = 1;
-		printk(KERN_WARNING "quirk installed: turning on "
-			"sys_sched_yield() workaround for Radeon DRM.\n");
-	}
 	return ret;
 }
 
diff -puN fs/proc/array.c~cfs-scheduler-v16 fs/proc/array.c
--- a/fs/proc/array.c~cfs-scheduler-v16
+++ a/fs/proc/array.c
@@ -172,8 +172,8 @@ static inline char * task_state(struct t
 		"Uid:\t%d\t%d\t%d\t%d\n"
 		"Gid:\t%d\t%d\t%d\t%d\n",
 		get_task_state(p),
-		p->tgid, p->pid,
-		pid_alive(p) ? rcu_dereference(p->real_parent)->tgid : 0,
+	       	p->tgid, p->pid,
+	       	pid_alive(p) ? rcu_dereference(p->real_parent)->tgid : 0,
 		pid_alive(p) && p->ptrace ? rcu_dereference(p->parent)->pid : 0,
 		p->uid, p->euid, p->suid, p->fsuid,
 		p->gid, p->egid, p->sgid, p->fsgid);
@@ -322,24 +322,38 @@ int proc_pid_status(struct task_struct *
 
 static clock_t task_utime(struct task_struct *p)
 {
+	clock_t utime = cputime_to_clock_t(p->utime),
+		total = utime + cputime_to_clock_t(p->stime);
+
 	/*
 	 * Use CFS's precise accounting, if available:
 	 */
-	if (!has_rt_policy(p) && !(sysctl_sched_load_smoothing & 128))
-		return nsec_to_clock_t(p->sum_exec_runtime);
+	if (!(sysctl_sched_features & 128)) {
+		u64 temp = (u64)nsec_to_clock_t(p->sum_exec_runtime);
+
+		if (total) {
+			temp *= utime;
+			do_div(temp, total);
+		}
+		utime = (clock_t)temp;
+	}
 
-	return cputime_to_clock_t(p->utime);
+	return utime;
 }
 
 static clock_t task_stime(struct task_struct *p)
 {
+	clock_t stime = cputime_to_clock_t(p->stime);
+
 	/*
-	 * Use CFS's precise accounting, if available:
+	 * Use CFS's precise accounting, if available (we subtract
+	 * utime from the total, to make sure the total observed
+	 * by userspace grows monotonically - apps rely on that):
 	 */
-	if (!has_rt_policy(p) && !(sysctl_sched_load_smoothing & 128))
-		return 0;
+	if (!(sysctl_sched_features & 128))
+		stime = nsec_to_clock_t(p->sum_exec_runtime) - task_utime(p);
 
-	return cputime_to_clock_t(p->stime);
+	return stime;
 }
 
 
diff -puN include/linux/sched.h~cfs-scheduler-v16 include/linux/sched.h
--- a/include/linux/sched.h~cfs-scheduler-v16
+++ a/include/linux/sched.h
@@ -34,6 +34,8 @@
 #define SCHED_FIFO		1
 #define SCHED_RR		2
 #define SCHED_BATCH		3
+#define SCHED_ISO		4
+#define SCHED_IDLEPRIO		5
 
 #ifdef __KERNEL__
 
@@ -876,7 +878,6 @@ struct task_struct {
 	u64 block_max;
 	u64 exec_max;
 	u64 wait_max;
-	u64 last_ran;
 
 	s64 wait_runtime;
 	u64 sum_exec_runtime;
@@ -1265,7 +1266,7 @@ static inline int set_cpus_allowed(struc
 extern unsigned long long sched_clock(void);
 extern void sched_clock_unstable_event(void);
 extern unsigned long long
-current_sched_runtime(const struct task_struct *current_task);
+task_sched_runtime(struct task_struct *task);
 
 /* sched_exec is called by processes performing an exec */
 #ifdef CONFIG_SMP
@@ -1284,11 +1285,10 @@ extern void sched_idle_next(void);
 extern char * sched_print_task_state(struct task_struct *p, char *buffer);
 
 extern unsigned int sysctl_sched_granularity;
-extern unsigned int sysctl_sched_wakeup_granularity;
+extern unsigned int sysctl_sched_batch_wakeup_granularity;
 extern unsigned int sysctl_sched_runtime_limit;
 extern unsigned int sysctl_sched_child_runs_first;
-extern unsigned int sysctl_sched_load_smoothing;
-extern int sysctl_sched_yield_bug_workaround;
+extern unsigned int sysctl_sched_features;
 
 #ifdef CONFIG_RT_MUTEXES
 extern int rt_mutex_getprio(struct task_struct *p);
diff -puN kernel/posix-cpu-timers.c~cfs-scheduler-v16 kernel/posix-cpu-timers.c
--- a/kernel/posix-cpu-timers.c~cfs-scheduler-v16
+++ a/kernel/posix-cpu-timers.c
@@ -161,7 +161,7 @@ static inline cputime_t virt_ticks(struc
 }
 static inline unsigned long long sched_ns(struct task_struct *p)
 {
-	return (p == current) ? current_sched_runtime(p) : p->sum_exec_runtime;
+	return task_sched_runtime(p);
 }
 
 int posix_cpu_clock_getres(const clockid_t which_clock, struct timespec *tp)
diff -puN kernel/sched.c~cfs-scheduler-v16 kernel/sched.c
--- a/kernel/sched.c~cfs-scheduler-v16
+++ a/kernel/sched.c
@@ -154,12 +154,12 @@ struct rq {
 
 	u64 clock, prev_clock_raw;
 	s64 clock_max_delta;
-	u64 fair_clock, prev_fair_clock;
-	u64 exec_clock, prev_exec_clock;
+	u64 fair_clock, delta_fair_clock;
+	u64 exec_clock, delta_exec_clock;
 	s64 wait_runtime;
 	unsigned long wait_runtime_overruns, wait_runtime_underruns;
 
-	unsigned int clock_warps;
+	unsigned int clock_warps, clock_overflows;
 	unsigned int clock_unstable_events;
 
 	struct sched_class *load_balance_class;
@@ -271,9 +271,17 @@ static inline unsigned long long __rq_cl
 		clock++;
 		rq->clock_warps++;
 	} else {
-		if (unlikely(delta > rq->clock_max_delta))
-			rq->clock_max_delta = delta;
-		clock += delta;
+		/*
+		 * Catch too large forward jumps too:
+		 */
+		if (delta > 2*TICK_NSEC) {
+			clock++;
+			rq->clock_overflows++;
+		} else {
+			if (unlikely(delta > rq->clock_max_delta))
+				rq->clock_max_delta = delta;
+			clock += delta;
+		}
 	}
 
 	rq->prev_clock_raw = now;
@@ -613,9 +621,9 @@ static void set_load_weight(struct task_
 		return;
 	}
 	/*
-	 * SCHED_BATCH tasks get minimal weight:
+	 * SCHED_IDLEPRIO tasks get minimal weight:
 	 */
-	if (p->policy == SCHED_BATCH) {
+	if (p->policy == SCHED_IDLEPRIO) {
 		p->load_weight = 1;
 		return;
 	}
@@ -1275,7 +1283,7 @@ static void task_running_tick(struct rq 
  */
 static void __sched_fork(struct task_struct *p)
 {
-	p->wait_start_fair = p->wait_start = p->exec_start = p->last_ran = 0;
+	p->wait_start_fair = p->wait_start = p->exec_start = 0;
 	p->sum_exec_runtime = 0;
 
 	p->wait_runtime = 0;
@@ -1579,37 +1587,34 @@ unsigned long nr_active(void)
 static void update_load_fair(struct rq *this_rq)
 {
 	unsigned long this_load, fair_delta, exec_delta, idle_delta;
+	u64 fair_delta64, exec_delta64, tmp64;
 	unsigned int i, scale;
-	s64 fair_delta64, exec_delta64;
-	unsigned long tmp;
-	u64 tmp64;
 
 	this_rq->nr_load_updates++;
-	if (!(sysctl_sched_load_smoothing & 64)) {
+	if (!(sysctl_sched_features & 64)) {
 		this_load = this_rq->raw_weighted_load;
 		goto do_avg;
 	}
 
-	fair_delta64 = this_rq->fair_clock - this_rq->prev_fair_clock + 1;
-	this_rq->prev_fair_clock = this_rq->fair_clock;
+	fair_delta64 = this_rq->delta_fair_clock + 1;
+	this_rq->delta_fair_clock = 0;
 
-	exec_delta64 = this_rq->exec_clock - this_rq->prev_exec_clock + 1;
-	this_rq->prev_exec_clock = this_rq->exec_clock;
+	exec_delta64 = this_rq->delta_exec_clock + 1;
+	this_rq->delta_exec_clock = 0;
 
-	if (fair_delta64 > (s64)LONG_MAX)
-		fair_delta64 = (s64)LONG_MAX;
+	if (fair_delta64 > (u64)LONG_MAX)
+		fair_delta64 = (u64)LONG_MAX;
 	fair_delta = (unsigned long)fair_delta64;
 
-	if (exec_delta64 > (s64)LONG_MAX)
-		exec_delta64 = (s64)LONG_MAX;
+	if (exec_delta64 > (u64)TICK_NSEC)
+		exec_delta64 = (u64)TICK_NSEC;
 	exec_delta = (unsigned long)exec_delta64;
-	if (exec_delta > TICK_NSEC)
-		exec_delta = TICK_NSEC;
 
 	idle_delta = TICK_NSEC - exec_delta;
 
-	tmp = (SCHED_LOAD_SCALE * exec_delta) / fair_delta;
-	tmp64 = (u64)tmp * (u64)exec_delta;
+	tmp64 = SCHED_LOAD_SCALE * exec_delta64;
+	do_div(tmp64, fair_delta);
+	tmp64 *= exec_delta64;
 	do_div(tmp64, TICK_NSEC);
 	this_load = (unsigned long)tmp64;
 
@@ -2821,17 +2826,23 @@ DEFINE_PER_CPU(struct kernel_stat, kstat
 EXPORT_PER_CPU_SYMBOL(kstat);
 
 /*
- * Return current->sum_exec_runtime plus any more ns on the sched_clock
- * that have not yet been banked.
+ * Return p->sum_exec_runtime plus any more ns on the sched_clock
+ * that have not yet been banked in case the task is currently running.
  */
-unsigned long long current_sched_runtime(const struct task_struct *p)
+unsigned long long task_sched_runtime(struct task_struct *p)
 {
-	unsigned long long ns;
 	unsigned long flags;
+	u64 ns, delta_exec;
+	struct rq *rq;
 
-	local_irq_save(flags);
-	ns = p->sum_exec_runtime + sched_clock() - p->last_ran;
-	local_irq_restore(flags);
+	rq = task_rq_lock(p, &flags);
+	ns = p->sum_exec_runtime;
+	if (rq->curr == p) {
+		delta_exec = rq_clock(rq) - p->exec_start;
+		if ((s64)delta_exec > 0)
+			ns += delta_exec;
+	}
+	task_rq_unlock(rq, &flags);
 
 	return ns;
 }
@@ -3565,7 +3576,7 @@ void set_user_nice(struct task_struct *p
 	 * The RT priorities are set via sched_setscheduler(), but we still
 	 * allow the 'normal' nice value to be set - but as expected
 	 * it wont have any effect on scheduling until the task is
-	 * not SCHED_NORMAL/SCHED_BATCH:
+	 * SCHED_FIFO/SCHED_RR:
 	 */
 	if (has_rt_policy(p)) {
 		p->static_prio = NICE_TO_PRIO(nice);
@@ -3714,6 +3725,7 @@ __setscheduler(struct rq *rq, struct tas
 	switch (p->policy) {
 	case SCHED_NORMAL:
 	case SCHED_BATCH:
+	case SCHED_IDLEPRIO:
 		p->sched_class = &fair_sched_class;
 		break;
 	case SCHED_FIFO:
@@ -3751,12 +3763,13 @@ recheck:
 	if (policy < 0)
 		policy = oldpolicy = p->policy;
 	else if (policy != SCHED_FIFO && policy != SCHED_RR &&
-			policy != SCHED_NORMAL && policy != SCHED_BATCH)
+			policy != SCHED_NORMAL && policy != SCHED_BATCH &&
+			policy != SCHED_IDLEPRIO)
 		return -EINVAL;
 	/*
 	 * Valid priorities for SCHED_FIFO and SCHED_RR are
-	 * 1..MAX_USER_RT_PRIO-1, valid priority for SCHED_NORMAL and
-	 * SCHED_BATCH is 0.
+	 * 1..MAX_USER_RT_PRIO-1, valid priority for SCHED_NORMAL,
+	 * SCHED_BATCH and SCHED_IDLEPRIO is 0.
 	 */
 	if (param->sched_priority < 0 ||
 	    (p->mm && param->sched_priority > MAX_USER_RT_PRIO-1) ||
@@ -4310,6 +4323,7 @@ asmlinkage long sys_sched_get_priority_m
 		break;
 	case SCHED_NORMAL:
 	case SCHED_BATCH:
+	case SCHED_IDLEPRIO:
 		ret = 0;
 		break;
 	}
@@ -4334,6 +4348,7 @@ asmlinkage long sys_sched_get_priority_m
 		break;
 	case SCHED_NORMAL:
 	case SCHED_BATCH:
+	case SCHED_IDLEPRIO:
 		ret = 0;
 	}
 	return ret;
@@ -4496,6 +4511,29 @@ void __cpuinit init_idle(struct task_str
  */
 cpumask_t nohz_cpu_mask = CPU_MASK_NONE;
 
+/*
+ * Increase the granularity value when there are more CPUs,
+ * because with more CPUs the 'effective latency' as visible
+ * to users decreases. But the relationship is not linear,
+ * so pick a second-best guess by going with the log2 of the
+ * number of CPUs.
+ *
+ * This idea comes from the SD scheduler of Con Kolivas:
+ */
+static inline void sched_init_granularity(void)
+{
+	unsigned int factor = 1 + ilog2(num_online_cpus());
+	const unsigned long gran_limit = 10000000;
+
+	sysctl_sched_granularity *= factor;
+	sysctl_sched_runtime_limit *= factor;
+
+	if (sysctl_sched_granularity > gran_limit)
+		sysctl_sched_granularity = gran_limit;
+
+	sysctl_sched_runtime_limit = sysctl_sched_granularity * 2;
+}
+
 #ifdef CONFIG_SMP
 /*
  * This is how migration works:
@@ -5900,25 +5938,12 @@ void __init sched_init_smp(void)
 	/* Move init over to a non-isolated CPU */
 	if (set_cpus_allowed(current, non_isolated_cpus) < 0)
 		BUG();
-	/*
-	 * Increase the granularity value when there are more CPUs,
-	 * because with more CPUs the 'effective latency' as visible
-	 * to users decreases. But the relationship is not linear,
-	 * so pick a second-best guess by going with the log2 of the
-	 * number of CPUs.
-	 *
-	 * This idea comes from the SD scheduler of Con Kolivas:
-	 */
-	{
-		unsigned int factor = 1 + ilog2(num_online_cpus());
-
-		sysctl_sched_granularity *= factor;
-		sysctl_sched_runtime_limit *= factor;
-	}
+	sched_init_granularity();
 }
 #else
 void __init sched_init_smp(void)
 {
+	sched_init_granularity();
 }
 #endif /* CONFIG_SMP */
 
diff -puN kernel/sched_debug.c~cfs-scheduler-v16 kernel/sched_debug.c
--- a/kernel/sched_debug.c~cfs-scheduler-v16
+++ a/kernel/sched_debug.c
@@ -54,8 +54,7 @@ print_task(struct seq_file *m, struct rq
 
 static void print_rq(struct seq_file *m, struct rq *rq, u64 now)
 {
-	struct task_struct *p;
-	struct rb_node *curr;
+	struct task_struct *g, *p;
 
 	SEQ_printf(m,
 	"\nrunnable tasks:\n"
@@ -68,13 +67,16 @@ static void print_rq(struct seq_file *m,
 	"------------------------------------------------"
 	"--------------------------------\n");
 
-	curr = first_fair(rq);
-	while (curr) {
-		p = rb_entry(curr, struct task_struct, run_node);
+	read_lock_irq(&tasklist_lock);
+
+	do_each_thread(g, p) {
+		if (!p->on_rq)
+			continue;
+
 		print_task(m, rq, p, now);
+	} while_each_thread(g, p);
 
-		curr = rb_next(curr);
-	}
+	read_unlock_irq(&tasklist_lock);
 }
 
 static void print_rq_runtime_sum(struct seq_file *m, struct rq *rq)
@@ -117,13 +119,13 @@ static void print_cpu(struct seq_file *m
 	P(clock);
 	P(prev_clock_raw);
 	P(clock_warps);
+	P(clock_overflows);
 	P(clock_unstable_events);
 	P(clock_max_delta);
-	rq->clock_max_delta = 0;
 	P(fair_clock);
-	P(prev_fair_clock);
+	P(delta_fair_clock);
 	P(exec_clock);
-	P(prev_exec_clock);
+	P(delta_exec_clock);
 	P(wait_runtime);
 	P(wait_runtime_overruns);
 	P(wait_runtime_underruns);
@@ -188,6 +190,18 @@ __initcall(init_sched_debug_procfs);
 
 void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 {
+	unsigned long flags;
+	int num_threads = 1;
+
+	rcu_read_lock();
+	if (lock_task_sighand(p, &flags)) {
+		num_threads = atomic_read(&p->signal->count);
+		unlock_task_sighand(p, &flags);
+	}
+	rcu_read_unlock();
+
+	SEQ_printf(m, "%s (%d, #threads: %d)\n", p->comm, p->pid, num_threads);
+	SEQ_printf(m, "----------------------------------------------\n");
 #define P(F) \
 	SEQ_printf(m, "%-25s:%20Ld\n", #F, (long long)p->F)
 
@@ -201,11 +215,13 @@ void proc_sched_show_task(struct task_st
 	P(block_max);
 	P(exec_max);
 	P(wait_max);
-	P(last_ran);
 	P(wait_runtime);
 	P(wait_runtime_overruns);
 	P(wait_runtime_underruns);
 	P(sum_exec_runtime);
+	P(load_weight);
+	P(policy);
+	P(prio);
 #undef P
 
 	{
diff -puN kernel/sched_fair.c~cfs-scheduler-v16 kernel/sched_fair.c
--- a/kernel/sched_fair.c~cfs-scheduler-v16
+++ a/kernel/sched_fair.c
@@ -1,5 +1,10 @@
 /*
  * Completely Fair Scheduling (CFS) Class (SCHED_NORMAL/SCHED_BATCH)
+ *
+ *  Copyright (C) 2007 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
+ *
+ *  Cleanups and fixes by Dmitry Adamushko.
+ *  (C) 2007 Dmitry Adamushko <dmitry.adamushko@gmail.com>
  */
 
 /*
@@ -16,33 +21,24 @@
  * number of CPUs. (i.e. factor 2x on 2-way systems, 3x on 4-way
  * systems, 4x on 8-way systems, 5x on 16-way systems, etc.)
  */
-unsigned int sysctl_sched_granularity __read_mostly = 3000000000ULL/HZ;
+unsigned int sysctl_sched_granularity __read_mostly = 2000000000ULL/HZ;
 
 /*
- * Wake-up granularity.
- * (default: 0, units: nanoseconds)
+ * SCHED_BATCH wake-up granularity.
+ * (default: 1 msec, units: nanoseconds)
  *
  * This option delays the preemption effects of decoupled workloads
  * and reduces their over-scheduling. Synchronous workloads will still
  * have immediate wakeup/sleep latencies.
  */
-unsigned int sysctl_sched_wakeup_granularity __read_mostly = 0;
-
-unsigned int sysctl_sched_runtime_limit __read_mostly = 6000000000ULL/HZ;
-
-unsigned int sysctl_sched_load_smoothing __read_mostly = 1 | 2 | 4 | 8 | 0;
-
+unsigned int sysctl_sched_batch_wakeup_granularity __read_mostly =
+							1000000000ULL/HZ;
 /*
- * sys_sched_yield unfairness bug workaround switch.
- * (default: -1:auto-detect+disabled. Other values: 0:disabled, 1:enabled)
- *
- * This option switches the unfair yield implementation of the
- * old scheduler back on. Needed for good performance of certain
- * apps like 3D games on Radeon cards.
+ * Initialized in sched_init_granularity():
  */
-int sysctl_sched_yield_bug_workaround __read_mostly = 1;
+unsigned int sysctl_sched_runtime_limit __read_mostly;
 
-EXPORT_SYMBOL_GPL(sysctl_sched_yield_bug_workaround);
+unsigned int sysctl_sched_features __read_mostly = 1 | 2 | 4 | 8 | 0 | 0;
 
 extern struct sched_class fair_sched_class;
 
@@ -193,14 +189,14 @@ static inline void update_curr(struct rq
 	u64 delta_exec, delta_fair, delta_mine;
 	struct task_struct *curr = rq->curr;
 
-	if (curr->sched_class != &fair_sched_class || curr == rq->idle)
+	if (curr->sched_class != &fair_sched_class || curr == rq->idle || !load)
 		return;
 	/*
 	 * Get the amount of time the current task was running
 	 * since the last time we changed raw_weighted_load:
 	 */
 	delta_exec = now - curr->exec_start;
-	if (unlikely(delta_exec < 0))
+	if (unlikely((s64)delta_exec < 0))
 		delta_exec = 0;
 	if (unlikely(delta_exec > curr->exec_max))
 		curr->exec_max = delta_exec;
@@ -209,22 +205,24 @@ static inline void update_curr(struct rq
 	curr->exec_start = now;
 	rq->exec_clock += delta_exec;
 
-	if (!load)
-		return;
+	delta_fair = delta_exec * NICE_0_LOAD;
+	delta_fair += load >> 1; /* rounding */
+	do_div(delta_fair, load);
+
+	/* Load-balancing accounting. */
+	rq->delta_fair_clock += delta_fair;
+	rq->delta_exec_clock += delta_exec;
+
 	/*
 	 * Task already marked for preemption, do not burden
 	 * it with the cost of not having left the CPU yet:
 	 */
-	if (unlikely(sysctl_sched_load_smoothing & 1))
+	if (unlikely(sysctl_sched_features & 1))
 		if (unlikely(test_tsk_thread_flag(curr, TIF_NEED_RESCHED)))
 			return;
 
-	delta_fair = delta_exec * NICE_0_LOAD;
-	delta_fair += load >> 1;
-	do_div(delta_fair, load);
-
 	delta_mine = delta_exec * curr->load_weight;
-	delta_mine += load >> 1;
+	delta_mine += load >> 1; /* rounding */
 	do_div(delta_mine, load);
 
 	rq->fair_clock += delta_fair;
@@ -352,7 +350,7 @@ static void distribute_fair_add(struct r
 	struct task_struct *curr = rq->curr;
 	s64 delta_fair = 0;
 
-	if (!(sysctl_sched_load_smoothing & 2))
+	if (!(sysctl_sched_features & 2))
 		return;
 
 	if (rq->nr_running) {
@@ -361,7 +359,8 @@ static void distribute_fair_add(struct r
 		 * The currently running task's next wait_runtime value does
 		 * not depend on the fair_clock, so fix it up explicitly:
 		 */
-		add_wait_runtime(rq, curr, -delta_fair);
+		 if (curr->sched_class == &fair_sched_class)
+			add_wait_runtime(rq, curr, -delta_fair);
 	}
 	rq->fair_clock -= delta_fair;
 }
@@ -375,7 +374,7 @@ static void enqueue_sleeper(struct rq *r
 	unsigned long load = rq->raw_weighted_load;
 	s64 delta_fair, prev_runtime;
 
-	if (!(sysctl_sched_load_smoothing & 4))
+	if (p->policy == SCHED_BATCH || !(sysctl_sched_features & 4))
 		goto out;
 
 	delta_fair = rq->fair_clock - p->sleep_start_fair;
@@ -384,7 +383,9 @@ static void enqueue_sleeper(struct rq *r
 	 * Fix up delta_fair with the effect of us running
 	 * during the whole sleep period:
 	 */
-	delta_fair = div64_s(delta_fair * load, load + p->load_weight);
+	if (!(sysctl_sched_features & 32))
+		delta_fair = div64_s(delta_fair * load, load + p->load_weight);
+	delta_fair = div64_s(delta_fair * p->load_weight, NICE_0_LOAD);
 
 	prev_runtime = p->wait_runtime;
 	__add_wait_runtime(rq, p, delta_fair);
@@ -476,85 +477,39 @@ dequeue_task_fair(struct rq *rq, struct 
 static void
 yield_task_fair(struct rq *rq, struct task_struct *p, struct task_struct *p_to)
 {
-	struct rb_node *curr, *next, *first;
 	struct task_struct *p_next;
-	s64 yield_key;
 	u64 now;
 
+	now = __rq_clock(rq);
 	/*
-	 * Bug workaround for 3D apps running on the radeon 3D driver:
+	 * Dequeue and enqueue the task to update its
+	 * position within the tree:
 	 */
-	if (unlikely(sysctl_sched_yield_bug_workaround > 0)) {
-		if (sysctl_sched_yield_bug_workaround == 2) {
-			resched_task(p);
-			return;
-		}
-		now = __rq_clock(rq);
-		/*
-		 * Dequeue and enqueue the task to update its
-		 * position within the tree:
-		 */
-		dequeue_task_fair(rq, p, 0, now);
-		p->on_rq = 0;
-		enqueue_task_fair(rq, p, 0, now);
-		p->on_rq = 1;
-
-		/*
-		 * Reschedule if another task tops the current one.
-		 */
-		p_next = __pick_next_task_fair(rq);
-		if (p_next != p)
-			resched_task(p);
-		return;
-	}
+	dequeue_task_fair(rq, p, 0, now);
+	p->on_rq = 0;
+	enqueue_task_fair(rq, p, 0, now);
+	p->on_rq = 1;
 
 	/*
 	 * yield-to support: if we are on the same runqueue then
 	 * give half of our wait_runtime (if it's positive) to the other task:
 	 */
-	if (p_to && rq == task_rq(p_to) && p->wait_runtime > 0) {
+	if (p_to && rq == task_rq(p_to) &&
+			p_to->sched_class == &fair_sched_class
+			&& p->wait_runtime > 0) {
+
 		s64 delta = p->wait_runtime >> 1;
 
 		__add_wait_runtime(rq, p_to, delta);
 		__add_wait_runtime(rq, p, -delta);
 	}
 
-	curr = &p->run_node;
-	first = first_fair(rq);
-	/*
-	 * Move this task to the second place in the tree:
-	 */
-	if (unlikely(curr != first)) {
-		next = first;
-	} else {
-		next = rb_next(curr);
-		/*
-		 * We were the last one already - nothing to do, return
-		 * and reschedule:
-		 */
-		if (unlikely(!next))
-			return;
-	}
-
-	p_next = rb_entry(next, struct task_struct, run_node);
 	/*
-	 * Minimally necessary key value to be the second in the tree:
-	 */
-	yield_key = p_next->fair_key + 1;
-
-	now = __rq_clock(rq);
-	dequeue_task_fair(rq, p, 0, now);
-	p->on_rq = 0;
-
-	/*
-	 * Only update the key if we need to move more backwards
-	 * than the minimally necessary position to be the second:
+	 * Reschedule if another task tops the current one.
 	 */
-	if (p->fair_key < yield_key)
-		p->fair_key = yield_key;
-
-	__enqueue_task_fair(rq, p);
-	p->on_rq = 1;
+	p_next = __pick_next_task_fair(rq);
+	if (p_next != p)
+		resched_task(p);
 }
 
 /*
@@ -581,16 +536,23 @@ __check_preempt_curr_fair(struct rq *rq,
 static void check_preempt_curr_fair(struct rq *rq, struct task_struct *p)
 {
 	struct task_struct *curr = rq->curr;
+	unsigned long granularity;
 
 	if ((curr == rq->idle) || rt_prio(p->prio)) {
-		if (sysctl_sched_load_smoothing & 8) {
+		if (sysctl_sched_features & 8) {
 			if (rt_prio(p->prio))
 				update_curr(rq, rq_clock(rq));
 		}
 		resched_task(curr);
 	} else {
-		__check_preempt_curr_fair(rq, p, curr,
-					  sysctl_sched_wakeup_granularity);
+		/*
+		 * Batch tasks prefer throughput over latency:
+		 */
+		granularity = 0;
+		if (unlikely(p->policy == SCHED_BATCH))
+			granularity = sysctl_sched_batch_wakeup_granularity;
+
+		__check_preempt_curr_fair(rq, p, curr, granularity);
 	}
 }
 
@@ -624,7 +586,7 @@ static void put_prev_task_fair(struct rq
 	 * preempted), update its position within the tree and
 	 * start the wait period:
 	 */
-	if (sysctl_sched_load_smoothing & 16)  {
+	if (sysctl_sched_features & 16)  {
 		if (prev->on_rq &&
 			test_tsk_thread_flag(prev, TIF_NEED_RESCHED)) {
 
@@ -735,6 +697,12 @@ static void task_new_fair(struct rq *rq,
 	 */
 	p->wait_start_fair = 0;
 
+	/*
+	 * The statistical average of wait_runtime is about
+	 * -granularity/2, so initialize the task with that:
+	 */
+//	p->wait_runtime = -(s64)(sysctl_sched_granularity / 2);
+
 	__enqueue_task_fair(rq, p);
 	p->on_rq = 1;
 	inc_nr_running(p, rq);
diff -puN kernel/sched_rt.c~cfs-scheduler-v16 kernel/sched_rt.c
--- a/kernel/sched_rt.c~cfs-scheduler-v16
+++ a/kernel/sched_rt.c
@@ -3,6 +3,28 @@
  * policies)
  */
 
+/*
+ * Update the current task's runtime statistics. Skip current tasks that
+ * are not in our scheduling class.
+ */
+static inline void update_curr_rt(struct rq *rq, u64 now)
+{
+	struct task_struct *curr = rq->curr;
+	u64 delta_exec;
+
+	if (!has_rt_policy(curr))
+		return;
+
+	delta_exec = now - curr->exec_start;
+	if (unlikely((s64)delta_exec < 0))
+		delta_exec = 0;
+	if (unlikely(delta_exec > curr->exec_max))
+		curr->exec_max = delta_exec;
+
+	curr->sum_exec_runtime += delta_exec;
+	curr->exec_start = now;
+}
+
 static void
 enqueue_task_rt(struct rq *rq, struct task_struct *p, int wakeup, u64 now)
 {
@@ -20,6 +42,8 @@ dequeue_task_rt(struct rq *rq, struct ta
 {
 	struct prio_array *array = &rq->active;
 
+	update_curr_rt(rq, now);
+
 	list_del(&p->run_list);
 	if (list_empty(array->queue + p->prio))
 		__clear_bit(p->prio, array->bitmap);
@@ -54,6 +78,7 @@ static void check_preempt_curr_rt(struct
 static struct task_struct * pick_next_task_rt(struct rq *rq, u64 now)
 {
 	struct prio_array *array = &rq->active;
+	struct task_struct *next;
 	struct list_head *queue;
 	int idx;
 
@@ -62,14 +87,17 @@ static struct task_struct * pick_next_ta
 		return NULL;
 
 	queue = array->queue + idx;
-	return list_entry(queue->next, struct task_struct, run_list);
+	next = list_entry(queue->next, struct task_struct, run_list);
+
+	next->exec_start = now;
+
+	return next;
 }
 
-/*
- * No accounting done when RT tasks are descheduled:
- */
 static void put_prev_task_rt(struct rq *rq, struct task_struct *p, u64 now)
 {
+	update_curr_rt(rq, now);
+	p->exec_start = 0;
 }
 
 /*
diff -puN kernel/sysctl.c~cfs-scheduler-v16 kernel/sysctl.c
--- a/kernel/sysctl.c~cfs-scheduler-v16
+++ a/kernel/sysctl.c
@@ -207,6 +207,9 @@ static ctl_table root_table[] = {
 	{ .ctl_name = 0 }
 };
 
+static unsigned long min_sched_granularity_ns = 100000; /* 100 usecs */
+static unsigned long max_sched_granularity_ns = 1000000000; /* 1 second */
+
 static ctl_table kern_table[] = {
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -214,15 +217,21 @@ static ctl_table kern_table[] = {
 		.data		= &sysctl_sched_granularity,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &min_sched_granularity_ns,
+		.extra2		= &max_sched_granularity_ns,
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "sched_wakeup_granularity_ns",
-		.data		= &sysctl_sched_wakeup_granularity,
+		.procname	= "sched_batch_wakeup_granularity_ns",
+		.data		= &sysctl_sched_batch_wakeup_granularity,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &min_sched_granularity_ns,
+		.extra2		= &max_sched_granularity_ns,
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -230,7 +239,10 @@ static ctl_table kern_table[] = {
 		.data		= &sysctl_sched_runtime_limit,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &min_sched_granularity_ns,
+		.extra2		= &max_sched_granularity_ns,
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -242,16 +254,8 @@ static ctl_table kern_table[] = {
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "sched_load_smoothing",
-		.data		= &sysctl_sched_load_smoothing,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
-	},
-	{
-		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "sched_yield_bug_workaround",
-		.data		= &sysctl_sched_yield_bug_workaround,
+		.procname	= "sched_features",
+		.data		= &sysctl_sched_features,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
_

Patches currently in -mm which might be from mingo@elte.hu are

rt-mutex-fix-stale-return-value.patch
rt-mutex-fix-chain-walk-early-wakeup-bug.patch
pi-futex-fix-exit-races-and-locking-problems.patch
git-acpi-add-exports.patch
git-kvm.patch
git-selinux.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
introduce-write_trylock_irqsave.patch
use-write_trylock_irqsave-in-ptrace_attach.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
pie-randomization.patch
vdso-print-fatal-signals.patch
remove-clockevents_releaserequest_device.patch
add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch
introduce-o_cloexec-take-2.patch
introduce-o_cloexec-parisc-fix.patch
o_cloexec-for-scm_rights.patch
o_cloexec-for-scm_rights-fix.patch
o_cloexec-for-scm_rights-fix-2.patch
futex-tidy-up-the-code.patch
improve-behaviour-of-spurious-irq-detect.patch
improve-behaviour-of-spurious-irq-detect-fix.patch
lock-debugging-loop-nicer-in-mark_rt_mutex_waiters.patch
cfs-scheduler.patch
cfs-scheduler-vs-detach-schedh-from-mmh.patch
cfs-scheduler-v14-rc2-mm1.patch
cfs-scheduler-warning-fixes.patch
cfs-scheduler-v15-rc3-mm1.patch
fs-proc-basec-make-a-struct-static.patch
cfs-warning-fixes.patch
schedstats-fix-printk-format.patch
cfs-scheduler-v16.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
fix-raw_spinlock_t-vs-lockdep.patch
lockdep-sanitise-config_prove_locking.patch
lockdep-reduce-the-ifdeffery.patch
lockstat-core-infrastructure.patch
lockstat-core-infrastructure-fix.patch
lockstat-core-infrastructure-fix-fix.patch
lockstat-core-infrastructure-fix-fix-fix.patch
lockstat-human-readability-tweaks.patch
lockstat-hook-into-spinlock_t-rwlock_t-rwsem-and-mutex.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
kmap_atomic-debugging.patch
random-warning-squishes.patch
