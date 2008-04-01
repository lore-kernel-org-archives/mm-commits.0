From: akpm@linux-foundation.org
Subject: - itimer-fix-hangs-with-many-threads.patch removed from -mm tree
Date: Tue, 01 Apr 2008 11:38:00 -0700
Message-ID: <200804011848.m31Im3R1007860@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753497AbYDAStJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2008 14:49:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fmayhar@google.com, mingo@elte.hu, oleg@tv-sign.ru, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     itimer: fix hangs with many threads
has been removed from the -mm tree.  Its filename was
     itimer-fix-hangs-with-many-threads.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: itimer: fix hangs with many threads
From: Frank Mayhar <fmayhar@google.com>

The problem is that run_posix_cpu_timers() repeatedly walks the entire thread
group every time it runs, which is at interrupt.  With heavy load and lots of
threads, this can take longer than the tick, at which point the kernel stops
doing anything put servicing clock ticks and the occasional interrupt.  Many
thanks to Roland McGrath for his help in my attempt to understand his code.

The change adds a new structure to the signal_struct, thread_group_cputime. 
On an SMP kernel, this is allocated as a percpu structure when needed (from
do_setitimer()) using the alloc_percpu() mechanism).  It is manipulated via a
set of functions defined in sched.c and sched.h.  These new functions are

      * thread_group_times_free(), inline function to free via
        free_percpu() (SMP) or kfree (UP) the thread_group_cputime
        structure.
      * thread_group_times_alloc(), external function to allocate the
        thread_group_cputime structure when needed.
      * thread_group_update(), inline function to update a field of the
        thread_group_cputime structure; called at interrupt from tick
        handlers, generally.  It depends on the "offsetof()" macro to
        know which field to update and on compiler optimization to
        remove the unused code paths in each case.
      * thread_group_cputime(), inline function that sums the time
        fields for all running CPUs (SMP) or snapshots the time fields
        (UP) into a passed structure.

I've changed the uniprocessor case to retain the dynamic allocation of the
thread_group_cputime structure as needed; this makes the code somewhat more
consistent between SMP and UP and retains the feature of reducing overhead for
processes that don't use interval timers.

In addition to fixing the hang, this change removes the overloading of
it_prof_expires for RLIMIT_CPU handling, replacing it with a new field,
rlim_expires, which is checked instead.  This makes the code simpler and more
straightforward.

The kernel/posix-cpu-timers.c file has changed pretty drastically, with it no
longer using the per-task times to know when to check for timer expiration. 
Instead, it consecutively checks the per-task timers and then the per-process
timers for expiration, consulting the individual expiration fields (including
the new RLIMIT_CPU expiration field) which are now logically separate.  Rather
than performing "rebalancing" functions now do simple assignments and all
loops through the thread group have gone away, replaced with calls to
thread_group_cputime().

Elsewhere, do_getitimer(), compat_sys_times() and sys_times() now use
thread_group_cputime() to get the times if a POSIX interval timer is in use,
providing a faster path in that case.

This version moves the thread_group_times_alloc() routine to sched.c, changes
the thread_group_update() macro to an inline function, shortens a few things
and cleans up the sched.h changes a bit.

Again, performance with the fix is at least as good as before and in a few
cases is slightly improved, possibly due to the reduced tick overhead.

Signed-off-by: Frank Mayhar <fmayhar@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h     |  117 +++++++++++++++
 kernel/compat.c           |   30 ++-
 kernel/fork.c             |   22 --
 kernel/itimer.c           |   40 +++--
 kernel/posix-cpu-timers.c |  278 ++++++++++--------------------------
 kernel/sched.c            |   73 +++++++++
 kernel/sched_fair.c       |    3 
 kernel/sched_rt.c         |    3 
 kernel/sys.c              |   44 +++--
 security/selinux/hooks.c  |    2 
 10 files changed, 355 insertions(+), 257 deletions(-)

diff -puN include/linux/sched.h~itimer-fix-hangs-with-many-threads include/linux/sched.h
--- a/include/linux/sched.h~itimer-fix-hangs-with-many-threads
+++ a/include/linux/sched.h
@@ -423,6 +423,18 @@ struct pacct_struct {
 };
 
 /*
+ * This structure contains the versions of utime, stime and sum_exec_runtime
+ * that are shared across threads within a process.  It's only used for
+ * interval timers and is allocated via alloc_percpu() in the signal
+ * structure when such a timer is set up.
+ */
+struct thread_group_cputime {
+	cputime_t utime;		/* User time. */
+	cputime_t stime;		/* System time. */
+	unsigned long long sum_exec_runtime; /* Scheduler time. */
+};
+
+/*
  * NOTE! "signal_struct" does not have it's own
  * locking, because a shared signal_struct always
  * implies a shared sighand_struct, so locking
@@ -467,6 +479,12 @@ struct signal_struct {
 	cputime_t it_prof_expires, it_virt_expires;
 	cputime_t it_prof_incr, it_virt_incr;
 
+	/* Scheduling timer for the process */
+	unsigned long long it_sched_expires;
+
+	/* RLIMIT_CPU timer for the process */
+	cputime_t rlim_expires;
+
 	/* job control IDs */
 
 	/*
@@ -491,6 +509,9 @@ struct signal_struct {
 
 	struct tty_struct *tty; /* NULL if no tty */
 
+	/* Process-wide times for POSIX interval timing.  Per CPU. */
+	struct thread_group_cputime *thread_group_times;
+
 	/*
 	 * Cumulative resource counters for dead threads in the group,
 	 * and for reaped dead child processes forked by this group.
@@ -1984,6 +2005,102 @@ static inline int spin_needbreak(spinloc
 #endif
 }
 
+#ifdef CONFIG_SMP
+
+static inline void thread_group_times_free(
+	struct thread_group_cputime *tg_times)
+{
+	free_percpu(tg_times);
+}
+
+/*
+ * Sum the time fields across all running CPUs.
+ */
+static inline void thread_group_cputime(
+	struct thread_group_cputime *tg_times,
+	struct signal_struct *sig)
+{
+	int i;
+	struct thread_group_cputime *tg;
+
+	/*
+	 * Get the values for the current CPU separately so we don't get
+	 * preempted, then sum all the rest.
+	 */
+	tg = per_cpu_ptr(sig->thread_group_times, get_cpu());
+	*tg_times = *tg;
+	put_cpu_no_resched();
+	for_each_online_cpu(i) {
+		if (i == smp_processor_id())
+			continue;
+		tg = per_cpu_ptr(sig->thread_group_times, i);
+		tg_times->utime = cputime_add(tg_times->utime, tg->utime);
+		tg_times->stime = cputime_add(tg_times->stime, tg->stime);
+		tg_times->sum_exec_runtime += tg->sum_exec_runtime;
+	}
+}
+
+#else /* CONFIG_SMP */
+
+static inline void thread_group_times_free(
+	struct thread_group_cputime *tg_times)
+{
+	kfree(tg_times);
+}
+
+/*
+ * Snapshot the time fields.
+ */
+static inline void thread_group_cputime(
+	struct thread_group_cputime *tg_times,
+	struct signal_struct *sig)
+{
+	*tg_times = *sig->thread_group_times;
+}
+
+#endif /* CONFIG_SMP */
+
+/*
+ * Update one of the fields in the thread_group_cputime structure.  This is
+ * passed the offset of the field to be updated (acquired via the "offsetof"
+ * macro) and uses that to determine the actual field.
+ */
+static inline void thread_group_update(struct signal_struct *sig,
+	const int fieldoff, void *val)
+{
+	cputime_t cputime;
+	unsigned long long sum_exec_runtime;
+	struct thread_group_cputime *tg_times;
+
+	if (!sig || !sig->thread_group_times)
+		return;
+#ifdef CONFIG_SMP
+	tg_times = per_cpu_ptr(sig->thread_group_times, get_cpu());
+#else
+	tg_times = sig->thread_group_times;
+#endif
+	switch (fieldoff) {
+	case offsetof(struct thread_group_cputime, utime):
+		cputime = *(cputime_t *)val;
+		tg_times->utime = cputime_add(tg_times->utime, cputime);
+		break;
+	case offsetof(struct thread_group_cputime, stime):
+		cputime = *(cputime_t *)val;
+		tg_times->utime = cputime_add(tg_times->utime, cputime);
+		break;
+	case offsetof(struct thread_group_cputime, sum_exec_runtime):
+		sum_exec_runtime = *(unsigned long long *)val;
+		tg_times->sum_exec_runtime += sum_exec_runtime;
+		break;
+	}
+#ifdef CONFIG_SMP
+	put_cpu_no_resched();
+#endif
+}
+
+/* The thread_group_cputime allocator. */
+extern int thread_group_times_alloc(struct task_struct *);
+
 /*
  * Reevaluate whether the task has signals pending delivery.
  * Wake the task if so.
diff -puN kernel/compat.c~itimer-fix-hangs-with-many-threads kernel/compat.c
--- a/kernel/compat.c~itimer-fix-hangs-with-many-threads
+++ a/kernel/compat.c
@@ -161,18 +161,29 @@ asmlinkage long compat_sys_times(struct 
 	if (tbuf) {
 		struct compat_tms tmp;
 		struct task_struct *tsk = current;
-		struct task_struct *t;
 		cputime_t utime, stime, cutime, cstime;
+		struct thread_group_cputime thread_group_times;
 
 		read_lock(&tasklist_lock);
-		utime = tsk->signal->utime;
-		stime = tsk->signal->stime;
-		t = tsk;
-		do {
-			utime = cputime_add(utime, t->utime);
-			stime = cputime_add(stime, t->stime);
-			t = next_thread(t);
-		} while (t != tsk);
+		/*
+		 * If a POSIX interval timer is running use the process-wide
+		 * fields, else fall back to brute force.
+		 */
+		if (sig->thread_group_times) {
+			thread_group_cputime(&thread_group_times, tsk->signal);
+			utime = thread_group_times.utime;
+			stime = thread_group_times.stime;
+		} else {
+			struct task_struct *t;
+
+			utime = tsk->signal->utime;
+			stime = tsk->signal->stime;
+			t = tsk;
+			do {
+				utime = cputime_add(utime, t->utime);
+				stime = cputime_add(stime, t->stime);
+			} while_each_thread(tsk, t);
+		}
 
 		/*
 		 * While we have tasklist_lock read-locked, no dying thread
@@ -1080,4 +1091,3 @@ compat_sys_sysinfo(struct compat_sysinfo
 
 	return 0;
 }
-
diff -puN kernel/fork.c~itimer-fix-hangs-with-many-threads kernel/fork.c
--- a/kernel/fork.c~itimer-fix-hangs-with-many-threads
+++ a/kernel/fork.c
@@ -914,10 +914,14 @@ static int copy_signal(unsigned long clo
 	sig->it_virt_incr = cputime_zero;
 	sig->it_prof_expires = cputime_zero;
 	sig->it_prof_incr = cputime_zero;
+	sig->it_sched_expires = 0;
+	sig->rlim_expires = cputime_zero;
 
 	sig->leader = 0;	/* session leadership doesn't inherit */
 	sig->tty_old_pgrp = NULL;
 
+	sig->thread_group_times = NULL;
+
 	sig->utime = sig->stime = sig->cutime = sig->cstime = cputime_zero;
 	sig->gtime = cputime_zero;
 	sig->cgtime = cputime_zero;
@@ -939,7 +943,7 @@ static int copy_signal(unsigned long clo
 		 * New sole thread in the process gets an expiry time
 		 * of the whole CPU time limit.
 		 */
-		tsk->it_prof_expires =
+		sig->rlim_expires =
 			secs_to_cputime(sig->rlim[RLIMIT_CPU].rlim_cur);
 	}
 	acct_init_pacct(&sig->pacct);
@@ -952,6 +956,7 @@ static int copy_signal(unsigned long clo
 void __cleanup_signal(struct signal_struct *sig)
 {
 	exit_thread_group_keys(sig);
+	thread_group_times_free(sig->thread_group_times);
 	kmem_cache_free(signal_cachep, sig);
 }
 
@@ -1311,21 +1316,6 @@ static struct task_struct *copy_process(
 	if (clone_flags & CLONE_THREAD) {
 		p->group_leader = current->group_leader;
 		list_add_tail_rcu(&p->thread_group, &p->group_leader->thread_group);
-
-		if (!cputime_eq(current->signal->it_virt_expires,
-				cputime_zero) ||
-		    !cputime_eq(current->signal->it_prof_expires,
-				cputime_zero) ||
-		    current->signal->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY ||
-		    !list_empty(&current->signal->cpu_timers[0]) ||
-		    !list_empty(&current->signal->cpu_timers[1]) ||
-		    !list_empty(&current->signal->cpu_timers[2])) {
-			/*
-			 * Have child wake up on its first tick to check
-			 * for process CPU timers.
-			 */
-			p->it_prof_expires = jiffies_to_cputime(1);
-		}
 	}
 
 	if (likely(p->pid)) {
diff -puN kernel/itimer.c~itimer-fix-hangs-with-many-threads kernel/itimer.c
--- a/kernel/itimer.c~itimer-fix-hangs-with-many-threads
+++ a/kernel/itimer.c
@@ -60,12 +60,11 @@ int do_getitimer(int which, struct itime
 		cval = tsk->signal->it_virt_expires;
 		cinterval = tsk->signal->it_virt_incr;
 		if (!cputime_eq(cval, cputime_zero)) {
-			struct task_struct *t = tsk;
-			cputime_t utime = tsk->signal->utime;
-			do {
-				utime = cputime_add(utime, t->utime);
-				t = next_thread(t);
-			} while (t != tsk);
+			struct thread_group_cputime thread_group_times;
+			cputime_t utime;
+
+			thread_group_cputime(&thread_group_times, tsk->signal);
+			utime = thread_group_times.utime;
 			if (cputime_le(cval, utime)) { /* about to fire */
 				cval = jiffies_to_cputime(1);
 			} else {
@@ -83,15 +82,12 @@ int do_getitimer(int which, struct itime
 		cval = tsk->signal->it_prof_expires;
 		cinterval = tsk->signal->it_prof_incr;
 		if (!cputime_eq(cval, cputime_zero)) {
-			struct task_struct *t = tsk;
-			cputime_t ptime = cputime_add(tsk->signal->utime,
-						      tsk->signal->stime);
-			do {
-				ptime = cputime_add(ptime,
-						    cputime_add(t->utime,
-								t->stime));
-				t = next_thread(t);
-			} while (t != tsk);
+			struct thread_group_cputime thread_group_times;
+			cputime_t ptime;
+
+			thread_group_cputime(&thread_group_times, tsk->signal);
+			ptime = cputime_add(thread_group_times.utime,
+					    thread_group_times.stime);
 			if (cputime_le(cval, ptime)) { /* about to fire */
 				cval = jiffies_to_cputime(1);
 			} else {
@@ -185,6 +181,13 @@ again:
 	case ITIMER_VIRTUAL:
 		nval = timeval_to_cputime(&value->it_value);
 		ninterval = timeval_to_cputime(&value->it_interval);
+		/*
+		 * If he's setting the timer for the first time, we need to
+		 * allocate the percpu area.  It's freed when the process
+		 * exits.
+		 */
+		if (!cputime_eq(nval, cputime_zero))
+			thread_group_times_alloc(tsk);
 		read_lock(&tasklist_lock);
 		spin_lock_irq(&tsk->sighand->siglock);
 		cval = tsk->signal->it_virt_expires;
@@ -209,6 +212,13 @@ again:
 	case ITIMER_PROF:
 		nval = timeval_to_cputime(&value->it_value);
 		ninterval = timeval_to_cputime(&value->it_interval);
+		/*
+		 * If he's setting the timer for the first time, we need to
+		 * allocate the percpu area.  It's freed when the process
+		 * exits.
+		 */
+		if (!cputime_eq(nval, cputime_zero))
+			thread_group_times_alloc(tsk);
 		read_lock(&tasklist_lock);
 		spin_lock_irq(&tsk->sighand->siglock);
 		cval = tsk->signal->it_prof_expires;
diff -puN kernel/posix-cpu-timers.c~itimer-fix-hangs-with-many-threads kernel/posix-cpu-timers.c
--- a/kernel/posix-cpu-timers.c~itimer-fix-hangs-with-many-threads
+++ a/kernel/posix-cpu-timers.c
@@ -227,31 +227,21 @@ static int cpu_clock_sample_group_locked
 					 struct task_struct *p,
 					 union cpu_time_count *cpu)
 {
-	struct task_struct *t = p;
- 	switch (clock_idx) {
+	struct thread_group_cputime thread_group_times;
+
+	thread_group_cputime(&thread_group_times, p->signal);
+	switch (clock_idx) {
 	default:
 		return -EINVAL;
 	case CPUCLOCK_PROF:
-		cpu->cpu = cputime_add(p->signal->utime, p->signal->stime);
-		do {
-			cpu->cpu = cputime_add(cpu->cpu, prof_ticks(t));
-			t = next_thread(t);
-		} while (t != p);
+		cpu->cpu = cputime_add(thread_group_times.utime,
+			thread_group_times.stime);
 		break;
 	case CPUCLOCK_VIRT:
-		cpu->cpu = p->signal->utime;
-		do {
-			cpu->cpu = cputime_add(cpu->cpu, virt_ticks(t));
-			t = next_thread(t);
-		} while (t != p);
+		cpu->cpu = thread_group_times.utime;
 		break;
 	case CPUCLOCK_SCHED:
-		cpu->sched = p->signal->sum_sched_runtime;
-		/* Add in each other live thread.  */
-		while ((t = next_thread(t)) != p) {
-			cpu->sched += t->se.sum_exec_runtime;
-		}
-		cpu->sched += sched_ns(p);
+		cpu->sched = thread_group_times.sum_exec_runtime;
 		break;
 	}
 	return 0;
@@ -472,80 +462,13 @@ void posix_cpu_timers_exit(struct task_s
 }
 void posix_cpu_timers_exit_group(struct task_struct *tsk)
 {
-	cleanup_timers(tsk->signal->cpu_timers,
-		       cputime_add(tsk->utime, tsk->signal->utime),
-		       cputime_add(tsk->stime, tsk->signal->stime),
-		     tsk->se.sum_exec_runtime + tsk->signal->sum_sched_runtime);
-}
-
-
-/*
- * Set the expiry times of all the threads in the process so one of them
- * will go off before the process cumulative expiry total is reached.
- */
-static void process_timer_rebalance(struct task_struct *p,
-				    unsigned int clock_idx,
-				    union cpu_time_count expires,
-				    union cpu_time_count val)
-{
-	cputime_t ticks, left;
-	unsigned long long ns, nsleft;
- 	struct task_struct *t = p;
-	unsigned int nthreads = atomic_read(&p->signal->live);
-
-	if (!nthreads)
-		return;
+	struct thread_group_cputime thread_group_times;
 
-	switch (clock_idx) {
-	default:
-		BUG();
-		break;
-	case CPUCLOCK_PROF:
-		left = cputime_div_non_zero(cputime_sub(expires.cpu, val.cpu),
-				       nthreads);
-		do {
-			if (likely(!(t->flags & PF_EXITING))) {
-				ticks = cputime_add(prof_ticks(t), left);
-				if (cputime_eq(t->it_prof_expires,
-					       cputime_zero) ||
-				    cputime_gt(t->it_prof_expires, ticks)) {
-					t->it_prof_expires = ticks;
-				}
-			}
-			t = next_thread(t);
-		} while (t != p);
-		break;
-	case CPUCLOCK_VIRT:
-		left = cputime_div_non_zero(cputime_sub(expires.cpu, val.cpu),
-				       nthreads);
-		do {
-			if (likely(!(t->flags & PF_EXITING))) {
-				ticks = cputime_add(virt_ticks(t), left);
-				if (cputime_eq(t->it_virt_expires,
-					       cputime_zero) ||
-				    cputime_gt(t->it_virt_expires, ticks)) {
-					t->it_virt_expires = ticks;
-				}
-			}
-			t = next_thread(t);
-		} while (t != p);
-		break;
-	case CPUCLOCK_SCHED:
-		nsleft = expires.sched - val.sched;
-		do_div(nsleft, nthreads);
-		nsleft = max_t(unsigned long long, nsleft, 1);
-		do {
-			if (likely(!(t->flags & PF_EXITING))) {
-				ns = t->se.sum_exec_runtime + nsleft;
-				if (t->it_sched_expires == 0 ||
-				    t->it_sched_expires > ns) {
-					t->it_sched_expires = ns;
-				}
-			}
-			t = next_thread(t);
-		} while (t != p);
-		break;
-	}
+	thread_group_cputime(&thread_group_times, tsk->signal);
+	cleanup_timers(tsk->signal->cpu_timers,
+		       thread_group_times.utime,
+		       thread_group_times.stime,
+		       thread_group_times.sum_exec_runtime);
 }
 
 static void clear_dead_task(struct k_itimer *timer, union cpu_time_count now)
@@ -572,7 +495,6 @@ static void arm_timer(struct k_itimer *t
 	struct list_head *head, *listpos;
 	struct cpu_timer_list *const nt = &timer->it.cpu;
 	struct cpu_timer_list *next;
-	unsigned long i;
 
 	head = (CPUCLOCK_PERTHREAD(timer->it_clock) ?
 		p->cpu_timers : p->signal->cpu_timers);
@@ -642,24 +564,21 @@ static void arm_timer(struct k_itimer *t
 				    cputime_lt(p->signal->it_virt_expires,
 					       timer->it.cpu.expires.cpu))
 					break;
-				goto rebalance;
+				p->signal->it_virt_expires =
+					timer->it.cpu.expires.cpu;
+				break;
 			case CPUCLOCK_PROF:
 				if (!cputime_eq(p->signal->it_prof_expires,
 						cputime_zero) &&
 				    cputime_lt(p->signal->it_prof_expires,
 					       timer->it.cpu.expires.cpu))
 					break;
-				i = p->signal->rlim[RLIMIT_CPU].rlim_cur;
-				if (i != RLIM_INFINITY &&
-				    i <= cputime_to_secs(timer->it.cpu.expires.cpu))
-					break;
-				goto rebalance;
+				p->signal->it_prof_expires =
+					timer->it.cpu.expires.cpu;
+				break;
 			case CPUCLOCK_SCHED:
-			rebalance:
-				process_timer_rebalance(
-					timer->it.cpu.task,
-					CPUCLOCK_WHICH(timer->it_clock),
-					timer->it.cpu.expires, now);
+				p->signal->it_sched_expires =
+					timer->it.cpu.expires.sched;
 				break;
 			}
 		}
@@ -1053,10 +972,10 @@ static void check_process_timers(struct 
 {
 	int maxfire;
 	struct signal_struct *const sig = tsk->signal;
-	cputime_t utime, stime, ptime, virt_expires, prof_expires;
+	cputime_t utime, ptime, virt_expires, prof_expires;
 	unsigned long long sum_sched_runtime, sched_expires;
-	struct task_struct *t;
 	struct list_head *timers = sig->cpu_timers;
+	struct thread_group_cputime thread_group_times;
 
 	/*
 	 * Don't sample the current process CPU clocks if there are no timers.
@@ -1072,17 +991,10 @@ static void check_process_timers(struct 
 	/*
 	 * Collect the current process totals.
 	 */
-	utime = sig->utime;
-	stime = sig->stime;
-	sum_sched_runtime = sig->sum_sched_runtime;
-	t = tsk;
-	do {
-		utime = cputime_add(utime, t->utime);
-		stime = cputime_add(stime, t->stime);
-		sum_sched_runtime += t->se.sum_exec_runtime;
-		t = next_thread(t);
-	} while (t != tsk);
-	ptime = cputime_add(utime, stime);
+	thread_group_cputime(&thread_group_times, sig);
+	utime = thread_group_times.utime;
+	ptime = cputime_add(utime, thread_group_times.stime);
+	sum_sched_runtime = thread_group_times.sum_exec_runtime;
 
 	maxfire = 20;
 	prof_expires = cputime_zero;
@@ -1185,66 +1097,24 @@ static void check_process_timers(struct 
 			}
 		}
 		x = secs_to_cputime(sig->rlim[RLIMIT_CPU].rlim_cur);
-		if (cputime_eq(prof_expires, cputime_zero) ||
-		    cputime_lt(x, prof_expires)) {
-			prof_expires = x;
+		if (cputime_eq(sig->rlim_expires, cputime_zero) ||
+		    cputime_lt(x, sig->rlim_expires)) {
+			sig->rlim_expires = x;
 		}
 	}
 
-	if (!cputime_eq(prof_expires, cputime_zero) ||
-	    !cputime_eq(virt_expires, cputime_zero) ||
-	    sched_expires != 0) {
-		/*
-		 * Rebalance the threads' expiry times for the remaining
-		 * process CPU timers.
-		 */
-
-		cputime_t prof_left, virt_left, ticks;
-		unsigned long long sched_left, sched;
-		const unsigned int nthreads = atomic_read(&sig->live);
-
-		if (!nthreads)
-			return;
-
-		prof_left = cputime_sub(prof_expires, utime);
-		prof_left = cputime_sub(prof_left, stime);
-		prof_left = cputime_div_non_zero(prof_left, nthreads);
-		virt_left = cputime_sub(virt_expires, utime);
-		virt_left = cputime_div_non_zero(virt_left, nthreads);
-		if (sched_expires) {
-			sched_left = sched_expires - sum_sched_runtime;
-			do_div(sched_left, nthreads);
-			sched_left = max_t(unsigned long long, sched_left, 1);
-		} else {
-			sched_left = 0;
-		}
-		t = tsk;
-		do {
-			if (unlikely(t->flags & PF_EXITING))
-				continue;
-
-			ticks = cputime_add(cputime_add(t->utime, t->stime),
-					    prof_left);
-			if (!cputime_eq(prof_expires, cputime_zero) &&
-			    (cputime_eq(t->it_prof_expires, cputime_zero) ||
-			     cputime_gt(t->it_prof_expires, ticks))) {
-				t->it_prof_expires = ticks;
-			}
-
-			ticks = cputime_add(t->utime, virt_left);
-			if (!cputime_eq(virt_expires, cputime_zero) &&
-			    (cputime_eq(t->it_virt_expires, cputime_zero) ||
-			     cputime_gt(t->it_virt_expires, ticks))) {
-				t->it_virt_expires = ticks;
-			}
-
-			sched = t->se.sum_exec_runtime + sched_left;
-			if (sched_expires && (t->it_sched_expires == 0 ||
-					      t->it_sched_expires > sched)) {
-				t->it_sched_expires = sched;
-			}
-		} while ((t = next_thread(t)) != tsk);
-	}
+	if (!cputime_eq(prof_expires, cputime_zero) &&
+	    (cputime_eq(sig->it_prof_expires, cputime_zero) ||
+	     cputime_gt(sig->it_prof_expires, prof_expires)))
+		sig->it_prof_expires = prof_expires;
+	if (!cputime_eq(virt_expires, cputime_zero) &&
+	    (cputime_eq(sig->it_virt_expires, cputime_zero) ||
+	     cputime_gt(sig->it_virt_expires, virt_expires)))
+		sig->it_virt_expires = virt_expires;
+	if (sched_expires != 0 &&
+	    (sig->it_sched_expires == 0 ||
+	     sig->it_sched_expires > sched_expires))
+		sig->it_sched_expires = sched_expires;
 }
 
 /*
@@ -1321,19 +1191,40 @@ void run_posix_cpu_timers(struct task_st
 {
 	LIST_HEAD(firing);
 	struct k_itimer *timer, *next;
+	struct thread_group_cputime tg_times;
+	cputime_t tg_virt, tg_prof;
+	unsigned long long tg_exec_runtime;
 
 	BUG_ON(!irqs_disabled());
 
-#define UNEXPIRED(clock) \
-		(cputime_eq(tsk->it_##clock##_expires, cputime_zero) || \
-		 cputime_lt(clock##_ticks(tsk), tsk->it_##clock##_expires))
-
-	if (UNEXPIRED(prof) && UNEXPIRED(virt) &&
-	    (tsk->it_sched_expires == 0 ||
-	     tsk->se.sum_exec_runtime < tsk->it_sched_expires))
-		return;
+#define UNEXPIRED(p, prof, virt, sched) \
+	((cputime_eq((p)->it_prof_expires, cputime_zero) ||	\
+	 cputime_lt((prof), (p)->it_prof_expires)) &&		\
+	(cputime_eq((p)->it_virt_expires, cputime_zero) ||	\
+	 cputime_lt((virt), (p)->it_virt_expires)) &&		\
+	((p)->it_sched_expires == 0 || (sched) < (p)->it_sched_expires))
 
-#undef	UNEXPIRED
+	/*
+	 * If there are no expired thread timers, no expired thread group
+	 * timers and no expired RLIMIT_CPU timer, just return.
+	 */
+	if (UNEXPIRED(tsk, prof_ticks(tsk),
+	    virt_ticks(tsk), tsk->se.sum_exec_runtime)) {
+		if (unlikely(tsk->signal == NULL))
+			return;
+		if (!sig->thread_group_times)
+			return;
+		thread_group_cputime(&tg_times, tsk->signal);
+		tg_prof = cputime_add(tg_times.utime, tg_times.stime);
+		tg_virt = tg_times.utime;
+		tg_exec_runtime = tg_times.sum_exec_runtime;
+		if ((tsk->signal->rlim[RLIMIT_CPU].rlim_cur == RLIM_INFINITY ||
+		     cputime_lt(tg_prof, tsk->signal->rlim_expires)) &&
+		    UNEXPIRED(tsk->signal, tg_virt, tg_prof, tg_exec_runtime))
+			return;
+	}
+
+#undef UNEXPIRED
 
 	/*
 	 * Double-check with locks held.
@@ -1414,14 +1305,6 @@ void set_process_cpu_timer(struct task_s
 		if (cputime_eq(*newval, cputime_zero))
 			return;
 		*newval = cputime_add(*newval, now.cpu);
-
-		/*
-		 * If the RLIMIT_CPU timer will expire before the
-		 * ITIMER_PROF timer, we have nothing else to do.
-		 */
-		if (tsk->signal->rlim[RLIMIT_CPU].rlim_cur
-		    < cputime_to_secs(*newval))
-			return;
 	}
 
 	/*
@@ -1433,13 +1316,14 @@ void set_process_cpu_timer(struct task_s
 	    cputime_ge(list_first_entry(head,
 				  struct cpu_timer_list, entry)->expires.cpu,
 		       *newval)) {
-		/*
-		 * Rejigger each thread's expiry time so that one will
-		 * notice before we hit the process-cumulative expiry time.
-		 */
-		union cpu_time_count expires = { .sched = 0 };
-		expires.cpu = *newval;
-		process_timer_rebalance(tsk, clock_idx, expires, now);
+		switch (clock_idx) {
+		case CPUCLOCK_PROF:
+			tsk->signal->it_prof_expires = *newval;
+			break;
+		case CPUCLOCK_VIRT:
+			tsk->signal->it_virt_expires = *newval;
+			break;
+		}
 	}
 }
 
diff -puN kernel/sched.c~itimer-fix-hangs-with-many-threads kernel/sched.c
--- a/kernel/sched.c~itimer-fix-hangs-with-many-threads
+++ a/kernel/sched.c
@@ -3726,6 +3726,9 @@ void account_user_time(struct task_struc
 	cputime64_t tmp;
 
 	p->utime = cputime_add(p->utime, cputime);
+	thread_group_update(p->signal,
+		offsetof(struct thread_group_cputime, utime),
+		(void *)&cputime);
 
 	/* Add user time to cpustat. */
 	tmp = cputime_to_cputime64(cputime);
@@ -3748,6 +3751,9 @@ static void account_guest_time(struct ta
 	tmp = cputime_to_cputime64(cputime);
 
 	p->utime = cputime_add(p->utime, cputime);
+	thread_group_update(p->signal,
+		offsetof(struct thread_group_cputime, utime),
+		(void *)&cputime);
 	p->gtime = cputime_add(p->gtime, cputime);
 
 	cpustat->user = cputime64_add(cpustat->user, tmp);
@@ -3781,6 +3787,9 @@ void account_system_time(struct task_str
 		return account_guest_time(p, cputime);
 
 	p->stime = cputime_add(p->stime, cputime);
+	thread_group_update(p->signal,
+		offsetof(struct thread_group_cputime, stime),
+		(void *)&cputime);
 
 	/* Add system time to cpustat. */
 	tmp = cputime_to_cputime64(cputime);
@@ -3822,6 +3831,9 @@ void account_steal_time(struct task_stru
 
 	if (p == rq->idle) {
 		p->stime = cputime_add(p->stime, steal);
+		thread_group_update(p->signal,
+			offsetof(struct thread_group_cputime, stime),
+			(void *)&steal);
 		if (atomic_read(&rq->nr_iowait) > 0)
 			cpustat->iowait = cputime64_add(cpustat->iowait, tmp);
 		else
@@ -8210,3 +8222,64 @@ struct cgroup_subsys cpuacct_subsys = {
 	.subsys_id = cpuacct_subsys_id,
 };
 #endif	/* CONFIG_CGROUP_CPUACCT */
+
+/*
+ * Allocate the thread_group_cputime struct appropriately and fill in the
+ * current values of the fields.  Called from do_setitimer() when setting an
+ * interval timer (ITIMER_PROF or ITIMER_VIRTUAL).  Assumes interrupts are
+ * enabled when it's called.  Note that there is no corresponding deallocation
+ * done from do_setitimer(); the structure is freed at process exit.
+ */
+int thread_group_times_alloc(struct task_struct *tsk)
+{
+	struct signal_struct *sig = tsk->signal;
+	struct thread_group_cputime *thread_group_times;
+	struct task_struct *t;
+	cputime_t utime, stime;
+	unsigned long long sum_exec_runtime;
+
+	/*
+	 * If we don't already have a thread_group_cputime struct, allocate
+	 * one and fill it in with the accumulated times.
+	 */
+	if (sig->thread_group_times)
+		return 0;
+#ifdef CONFIG_SMP
+	thread_group_times = alloc_percpu(struct thread_group_cputime);
+#else
+	thread_group_times =
+		kmalloc(sizeof(struct thread_group_cputime), GFP_KERNEL);
+#endif
+	if (thread_group_times == NULL)
+		return -ENOMEM;
+	read_lock(&tasklist_lock);
+	spin_lock_irq(&tsk->sighand->siglock);
+	if (sig->thread_group_times) {
+		spin_unlock_irq(&tsk->sighand->siglock);
+		read_unlock(&tasklist_lock);
+		thread_group_times_free(thread_group_times);
+		return 0;
+	}
+	sig->thread_group_times = thread_group_times;
+	utime = sig->utime;
+	stime = sig->stime;
+	sum_exec_runtime = tsk->se.sum_exec_runtime;
+	t = tsk;
+	do {
+		utime = cputime_add(utime, t->utime);
+		stime = cputime_add(stime, t->stime);
+		sum_exec_runtime += t->se.sum_exec_runtime;
+	} while_each_thread(tsk, t);
+#ifdef CONFIG_SMP
+	thread_group_times = per_cpu_ptr(sig->thread_group_times, get_cpu());
+#endif
+	thread_group_times->utime = utime;
+	thread_group_times->stime = stime;
+	thread_group_times->sum_exec_runtime = sum_exec_runtime;
+#ifdef CONFIG_SMP
+	put_cpu_no_resched();
+#endif
+	spin_unlock_irq(&tsk->sighand->siglock);
+	read_unlock(&tasklist_lock);
+	return 0;
+}
diff -puN kernel/sched_fair.c~itimer-fix-hangs-with-many-threads kernel/sched_fair.c
--- a/kernel/sched_fair.c~itimer-fix-hangs-with-many-threads
+++ a/kernel/sched_fair.c
@@ -343,6 +343,9 @@ static void update_curr(struct cfs_rq *c
 		struct task_struct *curtask = task_of(curr);
 
 		cpuacct_charge(curtask, delta_exec);
+		thread_group_update(curtask->signal,
+			offsetof(struct thread_group_cputime, sum_exec_runtime),
+			(void *)&delta_exec);
 	}
 }
 
diff -puN kernel/sched_rt.c~itimer-fix-hangs-with-many-threads kernel/sched_rt.c
--- a/kernel/sched_rt.c~itimer-fix-hangs-with-many-threads
+++ a/kernel/sched_rt.c
@@ -256,6 +256,9 @@ static void update_curr_rt(struct rq *rq
 	schedstat_set(curr->se.exec_max, max(curr->se.exec_max, delta_exec));
 
 	curr->se.sum_exec_runtime += delta_exec;
+	thread_group_update(curr->signal,
+		offsetof(struct thread_group_cputime, sum_exec_runtime),
+		(void *)&delta_exec);
 	curr->se.exec_start = rq->clock;
 	cpuacct_charge(curr, delta_exec);
 
diff -puN kernel/sys.c~itimer-fix-hangs-with-many-threads kernel/sys.c
--- a/kernel/sys.c~itimer-fix-hangs-with-many-threads
+++ a/kernel/sys.c
@@ -864,6 +864,8 @@ asmlinkage long sys_setfsgid(gid_t gid)
 
 asmlinkage long sys_times(struct tms __user * tbuf)
 {
+	struct thread_group_cputime thread_group_times;
+
 	/*
 	 *	In the SMP world we might just be unlucky and have one of
 	 *	the times increment as we use it. Since the value is an
@@ -873,19 +875,28 @@ asmlinkage long sys_times(struct tms __u
 	if (tbuf) {
 		struct tms tmp;
 		struct task_struct *tsk = current;
-		struct task_struct *t;
 		cputime_t utime, stime, cutime, cstime;
 
 		spin_lock_irq(&tsk->sighand->siglock);
-		utime = tsk->signal->utime;
-		stime = tsk->signal->stime;
-		t = tsk;
-		do {
-			utime = cputime_add(utime, t->utime);
-			stime = cputime_add(stime, t->stime);
-			t = next_thread(t);
-		} while (t != tsk);
-
+		/*
+		 * If a POSIX interval timer is running use the process-wide
+		 * fields, else fall back to brute force.
+		 */
+		if (sig->thread_group_times) {
+			thread_group_cputime(&thread_group_times, tsk->signal);
+			utime = thread_group_times.utime;
+			stime = thread_group_times.stime;
+		} else {
+			struct task_struct *t;
+
+			utime = tsk->signal->utime;
+			stime = tsk->signal->stime;
+			t = tsk;
+			do {
+				utime = cputime_add(utime, t->utime);
+				stime = cputime_add(stime, t->stime);
+			} while_each_thread(tsk, t);
+		}
 		cutime = tsk->signal->cutime;
 		cstime = tsk->signal->cstime;
 		spin_unlock_irq(&tsk->sighand->siglock);
@@ -1444,7 +1455,7 @@ asmlinkage long sys_old_getrlimit(unsign
 asmlinkage long sys_setrlimit(unsigned int resource, struct rlimit __user *rlim)
 {
 	struct rlimit new_rlim, *old_rlim;
-	unsigned long it_prof_secs;
+	unsigned long rlim_secs;
 	int retval;
 
 	if (resource >= RLIM_NLIMITS)
@@ -1490,15 +1501,12 @@ asmlinkage long sys_setrlimit(unsigned i
 	if (new_rlim.rlim_cur == RLIM_INFINITY)
 		goto out;
 
-	it_prof_secs = cputime_to_secs(current->signal->it_prof_expires);
-	if (it_prof_secs == 0 || new_rlim.rlim_cur <= it_prof_secs) {
-		unsigned long rlim_cur = new_rlim.rlim_cur;
-		cputime_t cputime;
-
-		cputime = secs_to_cputime(rlim_cur);
+	rlim_secs = cputime_to_secs(current->signal->rlim_expires);
+	if (rlim_secs == 0 || new_rlim.rlim_cur <= rlim_secs) {
 		read_lock(&tasklist_lock);
 		spin_lock_irq(&current->sighand->siglock);
-		set_process_cpu_timer(current, CPUCLOCK_PROF, &cputime, NULL);
+		current->signal->rlim_expires =
+			secs_to_cputime(new_rlim.rlim_cur);
 		spin_unlock_irq(&current->sighand->siglock);
 		read_unlock(&tasklist_lock);
 	}
diff -puN security/selinux/hooks.c~itimer-fix-hangs-with-many-threads security/selinux/hooks.c
--- a/security/selinux/hooks.c~itimer-fix-hangs-with-many-threads
+++ a/security/selinux/hooks.c
@@ -2256,7 +2256,7 @@ static void selinux_bprm_post_apply_cred
 			 * This will cause RLIMIT_CPU calculations
 			 * to be refigured.
 			 */
-			current->it_prof_expires = jiffies_to_cputime(1);
+			current->signal->rlim_expires = jiffies_to_cputime(1);
 		}
 	}
 
_

Patches currently in -mm which might be from fmayhar@google.com are

itimer-fix-hangs-with-many-threads.patch

