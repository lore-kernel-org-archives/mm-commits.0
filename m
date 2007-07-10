From: akpm@linux-foundation.org
Subject: - sched-cfs-v2.6.22-git-v18.patch removed from -mm tree
Date: Tue, 10 Jul 2007 12:50:05 -0700
Message-ID: <200707101950.l6AJo5OO026226@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50708 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760409AbXGJTzS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jul 2007 15:55:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     CFS scheduler, -v18
has been removed from the -mm tree.  Its filename was
     sched-cfs-v2.6.22-git-v18.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: CFS scheduler, -v18
From: Ingo Molnar <mingo@elte.hu>

The biggest change in -v18 are various performance related improvements. 
Thomas Gleixner has eliminated expensive 64-bit divisions by converting 
the arithmetics to scaled math (without impacting the quality of 
calculations). Srivatsa Vaddagiri and Dmitry Adamushko have continued 
the abstraction and cleanup work. Srivatsa Vaddagiri and Christoph 
Lameter fixed the NUMA balancing bug reported by Paul McKenney. There 
were also a good number of other refinements to the CFS code. (No 
reproducible behavioral regressions were reported against -v17 so far, 
so the 'behavioral' bits are mostly unchanged.)
 
Changes since -v17:

 - implement scaled math speedups for CFS. (Thomas Gleixner)

 - lots of core code updates, cleanups and streamlining.
   (Srivatsa Vaddagiri, Dmitry Adamushko, me.)

 - bugfix: fix NUMA balancing. (Srivatsa Vaddagiri, Christoph Lameter,
   Paul E. McKenney)

 - feature: SCHED_IDLE now also implies block-scheduler (CFQ)
   idle-IO-priority. (suggested by Thomas Sattler, picked up from -ck)

 - build fix for ppc32. (reported, tested and confirmed fixed by
   Art Haas)

 - ARM fix. (reported and debugged by Thomas Gleixner)

 - cleanup: implemented idle_sched_class in kernel/sched_idletask.c as a
   way to separate out rq->idle handling out of the core scheduler. This
   made a good deal of idle-task related special-cases go away.

 - debug: make the sysctls safer by introducing high and low limits.

 - cleanup: move some of the debug counters to under CONFIG_SCHEDSTATS.

 - speedup: various micro-optimizations

 - various other small updates.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/syscall_table.S |    1 
 block/cfq-iosched.c              |    3 
 fs/proc/array.c                  |    4 
 include/asm-i386/unistd.h        |    3 
 include/asm-x86_64/unistd.h      |    2 
 include/linux/sched.h            |   90 +--
 init/main.c                      |    3 
 kernel/exit.c                    |    2 
 kernel/posix-cpu-timers.c        |   16 
 kernel/sched.c                   |  861 +++++++++++++++++------------
 kernel/sched_debug.c             |  111 ++-
 kernel/sched_fair.c              |  802 ++++++++++++++++-----------
 kernel/sched_idletask.c          |   68 ++
 kernel/sched_rt.c                |   51 -
 kernel/sched_stats.h             |    4 
 kernel/softirq.c                 |    2 
 kernel/sysctl.c                  |   32 -
 17 files changed, 1242 insertions(+), 813 deletions(-)

diff -puN arch/i386/kernel/syscall_table.S~sched-cfs-v2.6.22-git-v18 arch/i386/kernel/syscall_table.S
--- a/arch/i386/kernel/syscall_table.S~sched-cfs-v2.6.22-git-v18
+++ a/arch/i386/kernel/syscall_table.S
@@ -326,4 +326,3 @@ ENTRY(sys_call_table)
 	.long sys_revokeat
 	.long sys_frevoke		/* 325 */
 	.long sys_fallocate
-	.long sys_sched_yield_to
diff -puN block/cfq-iosched.c~sched-cfs-v2.6.22-git-v18 block/cfq-iosched.c
--- a/block/cfq-iosched.c~sched-cfs-v2.6.22-git-v18
+++ a/block/cfq-iosched.c
@@ -1278,6 +1278,8 @@ static void cfq_init_prio_data(struct cf
 			/*
 			 * no prio set, place us in the middle of the BE classes
 			 */
+			if (tsk->policy == SCHED_IDLE)
+				goto set_class_idle;
 			cfqq->ioprio = task_nice_ioprio(tsk);
 			cfqq->ioprio_class = IOPRIO_CLASS_BE;
 			break;
@@ -1290,6 +1292,7 @@ static void cfq_init_prio_data(struct cf
 			cfqq->ioprio_class = IOPRIO_CLASS_BE;
 			break;
 		case IOPRIO_CLASS_IDLE:
+ set_class_idle:
 			cfqq->ioprio_class = IOPRIO_CLASS_IDLE;
 			cfqq->ioprio = 7;
 			cfq_clear_cfqq_idle_window(cfqq);
diff -puN fs/proc/array.c~sched-cfs-v2.6.22-git-v18 fs/proc/array.c
--- a/fs/proc/array.c~sched-cfs-v2.6.22-git-v18
+++ a/fs/proc/array.c
@@ -329,7 +329,7 @@ static clock_t task_utime(struct task_st
 	 * Use CFS's precise accounting, if available:
 	 */
 	if (!(sysctl_sched_features & 128)) {
-		u64 temp = (u64)nsec_to_clock_t(p->sum_exec_runtime);
+		u64 temp = (u64)nsec_to_clock_t(p->se.sum_exec_runtime);
 
 		if (total) {
 			temp *= utime;
@@ -351,7 +351,7 @@ static clock_t task_stime(struct task_st
 	 * by userspace grows monotonically - apps rely on that):
 	 */
 	if (!(sysctl_sched_features & 128))
-		stime = nsec_to_clock_t(p->sum_exec_runtime) - task_utime(p);
+		stime = nsec_to_clock_t(p->se.sum_exec_runtime) - task_utime(p);
 
 	return stime;
 }
diff -puN include/asm-i386/unistd.h~sched-cfs-v2.6.22-git-v18 include/asm-i386/unistd.h
--- a/include/asm-i386/unistd.h~sched-cfs-v2.6.22-git-v18
+++ a/include/asm-i386/unistd.h
@@ -332,11 +332,10 @@
 #define __NR_revokeat		324
 #define __NR_frevoke		325
 #define __NR_fallocate		326
-#define __NR_sched_yield_to	327
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 328
+#define NR_syscalls 327
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff -puN include/asm-x86_64/unistd.h~sched-cfs-v2.6.22-git-v18 include/asm-x86_64/unistd.h
--- a/include/asm-x86_64/unistd.h~sched-cfs-v2.6.22-git-v18
+++ a/include/asm-x86_64/unistd.h
@@ -632,8 +632,6 @@ __SYSCALL(__NR_timerfd, sys_timerfd)
 __SYSCALL(__NR_eventfd, sys_eventfd)
 #define __NR_fallocate		284
 __SYSCALL(__NR_fallocate, sys_fallocate)
-#define __NR_sched_yield_to	285
-__SYSCALL(__NR_sched_yield_to, sys_sched_yield_to)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff -puN include/linux/sched.h~sched-cfs-v2.6.22-git-v18 include/linux/sched.h
--- a/include/linux/sched.h~sched-cfs-v2.6.22-git-v18
+++ a/include/linux/sched.h
@@ -36,7 +36,7 @@
 #define SCHED_RR		2
 #define SCHED_BATCH		3
 #define SCHED_ISO		4
-#define SCHED_IDLEPRIO		5
+#define SCHED_IDLE		5
 
 #ifdef __KERNEL__
 
@@ -201,6 +201,7 @@ struct task_struct;
 extern void sched_init(void);
 extern void sched_init_smp(void);
 extern void init_idle(struct task_struct *idle, int cpu);
+extern void init_idle_bootup_task(struct task_struct *idle);
 
 extern cpumask_t nohz_cpu_mask;
 #if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
@@ -556,8 +557,7 @@ struct signal_struct {
 
 #define rt_prio(prio)		unlikely((prio) < MAX_RT_PRIO)
 #define rt_task(p)		rt_prio((p)->prio)
-#define batch_task(p)		(unlikely((p)->policy == SCHED_BATCH))
-#define is_rt_policy(p)		((p) != SCHED_NORMAL && (p) != SCHED_BATCH)
+#define is_rt_policy(p)		((p) == SCHED_FIFO || (p) == SCHED_RR)
 #define has_rt_policy(p)	unlikely(is_rt_policy((p)->policy))
 
 /*
@@ -653,12 +653,12 @@ static inline int sched_info_on(void)
 #endif
 }
 
-enum idle_type
+enum cpu_idle_type
 {
-	SCHED_IDLE,
-	NOT_IDLE,
-	NEWLY_IDLE,
-	MAX_IDLE_TYPES
+	CPU_IDLE,
+	CPU_NOT_IDLE,
+	CPU_NEWLY_IDLE,
+	CPU_MAX_IDLE_TYPES
 };
 
 /*
@@ -740,14 +740,14 @@ struct sched_domain {
 
 #ifdef CONFIG_SCHEDSTATS
 	/* load_balance() stats */
-	unsigned long lb_cnt[MAX_IDLE_TYPES];
-	unsigned long lb_failed[MAX_IDLE_TYPES];
-	unsigned long lb_balanced[MAX_IDLE_TYPES];
-	unsigned long lb_imbalance[MAX_IDLE_TYPES];
-	unsigned long lb_gained[MAX_IDLE_TYPES];
-	unsigned long lb_hot_gained[MAX_IDLE_TYPES];
-	unsigned long lb_nobusyg[MAX_IDLE_TYPES];
-	unsigned long lb_nobusyq[MAX_IDLE_TYPES];
+	unsigned long lb_cnt[CPU_MAX_IDLE_TYPES];
+	unsigned long lb_failed[CPU_MAX_IDLE_TYPES];
+	unsigned long lb_balanced[CPU_MAX_IDLE_TYPES];
+	unsigned long lb_imbalance[CPU_MAX_IDLE_TYPES];
+	unsigned long lb_gained[CPU_MAX_IDLE_TYPES];
+	unsigned long lb_hot_gained[CPU_MAX_IDLE_TYPES];
+	unsigned long lb_nobusyg[CPU_MAX_IDLE_TYPES];
+	unsigned long lb_nobusyq[CPU_MAX_IDLE_TYPES];
 
 	/* Active load balancing */
 	unsigned long alb_cnt;
@@ -830,8 +830,7 @@ struct sched_class {
 			      int wakeup, u64 now);
 	void (*dequeue_task) (struct rq *rq, struct task_struct *p,
 			      int sleep, u64 now);
-	void (*yield_task) (struct rq *rq, struct task_struct *p,
-			    struct task_struct *p_to);
+	void (*yield_task) (struct rq *rq, struct task_struct *p);
 
 	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p);
 
@@ -844,6 +843,36 @@ struct sched_class {
 	void (*task_new) (struct rq *rq, struct task_struct *p);
 };
 
+struct load_weight {
+	unsigned long weight, inv_weight;
+};
+
+/* CFS stats for a schedulable entity (task, task-group etc) */
+struct sched_entity {
+	struct load_weight load;	/* for nice- load-balancing purposes */
+	int on_rq;
+	struct rb_node run_node;
+	unsigned long delta_exec;
+	s64 delta_fair;
+
+	u64 wait_start_fair;
+	u64 wait_start;
+	u64 exec_start;
+	u64 sleep_start, sleep_start_fair;
+	u64 block_start;
+	u64 sleep_max;
+	u64 block_max;
+	u64 exec_max;
+	u64 wait_max;
+	u64 last_ran;
+
+	s64 wait_runtime;
+	u64 sum_exec_runtime;
+	s64 fair_key;
+	s64 sum_wait_runtime, sum_sleep_runtime;
+	unsigned long wait_runtime_overruns, wait_runtime_underruns;
+};
+
 struct task_struct {
 	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
 	void *stack;
@@ -858,33 +887,15 @@ struct task_struct {
 	int oncpu;
 #endif
 #endif
-	int load_weight;	/* for niceness load balancing purposes */
 
 	int prio, static_prio, normal_prio;
-	int on_rq;
 	struct list_head run_list;
-	struct rb_node run_node;
+	struct sched_entity se;
 
 	unsigned short ioprio;
 #ifdef CONFIG_BLK_DEV_IO_TRACE
 	unsigned int btrace_seq;
 #endif
-	/* CFS scheduling class statistics fields: */
-	u64 wait_start_fair;
-	u64 wait_start;
-	u64 exec_start;
-	u64 sleep_start, sleep_start_fair;
-	u64 block_start;
-	u64 sleep_max;
-	u64 block_max;
-	u64 exec_max;
-	u64 wait_max;
-
-	s64 wait_runtime;
-	u64 sum_exec_runtime;
-	s64 fair_key;
-	s64 sum_wait_runtime, sum_sleep_runtime;
-	unsigned long wait_runtime_overruns, wait_runtime_underruns;
 
 	unsigned int policy;
 	cpumask_t cpus_allowed;
@@ -894,7 +905,6 @@ struct task_struct {
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	struct sched_info sched_info;
 #endif
-	u64 nr_switches;
 
 	struct list_head tasks;
 	/*
@@ -1286,7 +1296,9 @@ extern void sched_idle_next(void);
 extern char * sched_print_task_state(struct task_struct *p, char *buffer);
 
 extern unsigned int sysctl_sched_granularity;
+extern unsigned int sysctl_sched_wakeup_granularity;
 extern unsigned int sysctl_sched_batch_wakeup_granularity;
+extern unsigned int sysctl_sched_stat_granularity;
 extern unsigned int sysctl_sched_runtime_limit;
 extern unsigned int sysctl_sched_child_runs_first;
 extern unsigned int sysctl_sched_features;
@@ -1457,7 +1469,7 @@ extern struct mm_struct * mm_alloc(void)
 extern void FASTCALL(__mmdrop(struct mm_struct *));
 static inline void mmdrop(struct mm_struct * mm)
 {
-	if (atomic_dec_and_test(&mm->mm_count))
+	if (unlikely(atomic_dec_and_test(&mm->mm_count)))
 		__mmdrop(mm);
 }
 
diff -puN init/main.c~sched-cfs-v2.6.22-git-v18 init/main.c
--- a/init/main.c~sched-cfs-v2.6.22-git-v18
+++ a/init/main.c
@@ -446,13 +446,14 @@ static void noinline __init_refok rest_i
 	 * The boot idle thread must execute schedule()
 	 * at least once to get things moving:
 	 */
+	init_idle_bootup_task(current);
 	preempt_enable_no_resched();
 	schedule();
 	preempt_disable();
 
 	/* Call into cpu_idle with preempt disabled */
 	cpu_idle();
-} 
+}
 
 /* Check for early params. */
 static int __init do_early_param(char *param, char *val)
diff -puN kernel/exit.c~sched-cfs-v2.6.22-git-v18 kernel/exit.c
--- a/kernel/exit.c~sched-cfs-v2.6.22-git-v18
+++ a/kernel/exit.c
@@ -126,7 +126,7 @@ static void __exit_signal(struct task_st
 		sig->nivcsw += tsk->nivcsw;
 		sig->inblock += task_io_get_inblock(tsk);
 		sig->oublock += task_io_get_oublock(tsk);
-		sig->sum_sched_runtime += tsk->sum_exec_runtime;
+		sig->sum_sched_runtime += tsk->se.sum_exec_runtime;
 		sig = NULL; /* Marker for below. */
 	}
 
diff -puN kernel/posix-cpu-timers.c~sched-cfs-v2.6.22-git-v18 kernel/posix-cpu-timers.c
--- a/kernel/posix-cpu-timers.c~sched-cfs-v2.6.22-git-v18
+++ a/kernel/posix-cpu-timers.c
@@ -249,7 +249,7 @@ static int cpu_clock_sample_group_locked
 		cpu->sched = p->signal->sum_sched_runtime;
 		/* Add in each other live thread.  */
 		while ((t = next_thread(t)) != p) {
-			cpu->sched += t->sum_exec_runtime;
+			cpu->sched += t->se.sum_exec_runtime;
 		}
 		cpu->sched += sched_ns(p);
 		break;
@@ -467,7 +467,7 @@ static void cleanup_timers(struct list_h
 void posix_cpu_timers_exit(struct task_struct *tsk)
 {
 	cleanup_timers(tsk->cpu_timers,
-		       tsk->utime, tsk->stime, tsk->sum_exec_runtime);
+		       tsk->utime, tsk->stime, tsk->se.sum_exec_runtime);
 
 }
 void posix_cpu_timers_exit_group(struct task_struct *tsk)
@@ -475,7 +475,7 @@ void posix_cpu_timers_exit_group(struct 
 	cleanup_timers(tsk->signal->cpu_timers,
 		       cputime_add(tsk->utime, tsk->signal->utime),
 		       cputime_add(tsk->stime, tsk->signal->stime),
-		       tsk->sum_exec_runtime + tsk->signal->sum_sched_runtime);
+		     tsk->se.sum_exec_runtime + tsk->signal->sum_sched_runtime);
 }
 
 
@@ -536,7 +536,7 @@ static void process_timer_rebalance(stru
 		nsleft = max_t(unsigned long long, nsleft, 1);
 		do {
 			if (likely(!(t->flags & PF_EXITING))) {
-				ns = t->sum_exec_runtime + nsleft;
+				ns = t->se.sum_exec_runtime + nsleft;
 				if (t->it_sched_expires == 0 ||
 				    t->it_sched_expires > ns) {
 					t->it_sched_expires = ns;
@@ -1004,7 +1004,7 @@ static void check_thread_timers(struct t
 		struct cpu_timer_list *t = list_first_entry(timers,
 						      struct cpu_timer_list,
 						      entry);
-		if (!--maxfire || tsk->sum_exec_runtime < t->expires.sched) {
+		if (!--maxfire || tsk->se.sum_exec_runtime < t->expires.sched) {
 			tsk->it_sched_expires = t->expires.sched;
 			break;
 		}
@@ -1049,7 +1049,7 @@ static void check_process_timers(struct 
 	do {
 		utime = cputime_add(utime, t->utime);
 		stime = cputime_add(stime, t->stime);
-		sum_sched_runtime += t->sum_exec_runtime;
+		sum_sched_runtime += t->se.sum_exec_runtime;
 		t = next_thread(t);
 	} while (t != tsk);
 	ptime = cputime_add(utime, stime);
@@ -1208,7 +1208,7 @@ static void check_process_timers(struct 
 				t->it_virt_expires = ticks;
 			}
 
-			sched = t->sum_exec_runtime + sched_left;
+			sched = t->se.sum_exec_runtime + sched_left;
 			if (sched_expires && (t->it_sched_expires == 0 ||
 					      t->it_sched_expires > sched)) {
 				t->it_sched_expires = sched;
@@ -1300,7 +1300,7 @@ void run_posix_cpu_timers(struct task_st
 
 	if (UNEXPIRED(prof) && UNEXPIRED(virt) &&
 	    (tsk->it_sched_expires == 0 ||
-	     tsk->sum_exec_runtime < tsk->it_sched_expires))
+	     tsk->se.sum_exec_runtime < tsk->it_sched_expires))
 		return;
 
 #undef	UNEXPIRED
diff -puN kernel/sched.c~sched-cfs-v2.6.22-git-v18 kernel/sched.c
--- a/kernel/sched.c~sched-cfs-v2.6.22-git-v18
+++ a/kernel/sched.c
@@ -115,6 +115,34 @@ struct prio_array {
 	struct list_head queue[MAX_RT_PRIO];
 };
 
+struct load_stat {
+	struct load_weight load;
+	u64 load_update_start, load_update_last;
+	u64 delta_fair, delta_exec, delta_stat;
+};
+
+/* CFS-related fields in a runqueue */
+struct cfs_rq {
+	struct load_weight load;
+	unsigned long nr_running;
+
+	u64 fair_clock;
+	u64 exec_clock;
+	s64 wait_runtime;
+	unsigned long wait_runtime_overruns, wait_runtime_underruns;
+
+	struct rb_root tasks_timeline;
+	struct rb_node *rb_leftmost;
+	struct rb_node *rb_load_balance_curr;
+};
+
+/* Real-Time classes' related field in a runqueue: */
+struct rt_rq {
+	struct prio_array active;
+	int rt_load_balance_idx;
+	struct list_head *rt_load_balance_head, *rt_load_balance_curr;
+};
+
 /*
  * This is the main, per-CPU runqueue data structure.
  *
@@ -130,16 +158,18 @@ struct rq {
 	 * remote CPUs use both these fields when doing load calculation.
 	 */
 	long nr_running;
-	unsigned long raw_weighted_load;
 	#define CPU_LOAD_IDX_MAX 5
 	unsigned long cpu_load[CPU_LOAD_IDX_MAX];
-
 	unsigned char idle_at_tick;
 #ifdef CONFIG_NO_HZ
 	unsigned char in_nohz_recently;
 #endif
-	u64 nr_switches;
+	struct load_stat ls;	/* capture load from *all* tasks on this cpu */
 	unsigned long nr_load_updates;
+	u64 nr_switches;
+
+	struct cfs_rq cfs;
+	struct rt_rq  rt;
 
 	/*
 	 * This is part of a global counter where only the total sum
@@ -155,24 +185,12 @@ struct rq {
 
 	u64 clock, prev_clock_raw;
 	s64 clock_max_delta;
-	u64 fair_clock, delta_fair_clock;
-	u64 exec_clock, delta_exec_clock;
-	s64 wait_runtime;
-	unsigned long wait_runtime_overruns, wait_runtime_underruns;
 
 	unsigned int clock_warps, clock_overflows;
 	unsigned int clock_unstable_events;
 
 	struct sched_class *load_balance_class;
 
-	struct prio_array active;
-	int rt_load_balance_idx;
-	struct list_head *rt_load_balance_head, *rt_load_balance_curr;
-
-	struct rb_root tasks_timeline;
-	struct rb_node *rb_leftmost;
-	struct rb_node *rb_load_balance_curr;
-
 	atomic_t nr_iowait;
 
 #ifdef CONFIG_SMP
@@ -235,6 +253,15 @@ static unsigned int static_prio_timeslic
 		return SCALE_PRIO(DEF_TIMESLICE, static_prio);
 }
 
+static inline int cpu_of(struct rq *rq)
+{
+#ifdef CONFIG_SMP
+	return rq->cpu;
+#else
+	return 0;
+#endif
+}
+
 #ifdef CONFIG_SMP
 /*
  * Divide a load by a sched group cpu_power : (load / sg->__cpu_power)
@@ -258,12 +285,12 @@ static inline void sg_inc_cpu_power(stru
 /*
  * Per-runqueue clock, as finegrained as the platform can give us:
  */
-static inline unsigned long long __rq_clock(struct rq *rq)
+static unsigned long long __rq_clock(struct rq *rq)
 {
-	u64 now = sched_clock();
-	u64 clock = rq->clock;
 	u64 prev_raw = rq->prev_clock_raw;
+	u64 now = sched_clock();
 	s64 delta = now - prev_raw;
+	u64 clock = rq->clock;
 
 	/*
 	 * Protect against sched_clock() occasionally going backwards:
@@ -275,7 +302,7 @@ static inline unsigned long long __rq_cl
 		/*
 		 * Catch too large forward jumps too:
 		 */
-		if (delta > 2*TICK_NSEC) {
+		if (unlikely(delta > 2*TICK_NSEC)) {
 			clock++;
 			rq->clock_overflows++;
 		} else {
@@ -291,15 +318,6 @@ static inline unsigned long long __rq_cl
 	return clock;
 }
 
-static inline int cpu_of(struct rq *rq)
-{
-#ifdef CONFIG_SMP
-	return rq->cpu;
-#else
-	return 0;
-#endif
-}
-
 static inline unsigned long long rq_clock(struct rq *rq)
 {
 	int this_cpu = smp_processor_id();
@@ -483,6 +501,9 @@ void sched_clock_unstable_event(void)
 	task_rq_unlock(rq, &flags);
 }
 
+#define NICE_0_LOAD	SCHED_LOAD_SCALE
+#define NICE_0_SHIFT	SCHED_LOAD_SHIFT
+
 /*
  * resched_task - mark a task 'to be rescheduled now'.
  *
@@ -536,6 +557,107 @@ static inline void resched_task(struct t
 }
 #endif
 
+static u64 div64_likely32(u64 divident, unsigned long divisor)
+{
+#if BITS_PER_LONG == 32
+	if (likely(divident <= 0xffffffffULL))
+		return (u32)divident / divisor;
+	do_div(divident, divisor);
+
+	return divident;
+#else
+	return divident / divisor;
+#endif
+}
+
+static s64 div64_s(s64 divident, unsigned long divisor)
+{
+	u64 tmp;
+
+	if (divident < 0) {
+		tmp = -divident;
+		return -(s64)div64_likely32(tmp, divisor);
+	} else {
+		tmp = divident;
+		return (s64)div64_likely32(tmp, divisor);
+	}
+}
+
+#if BITS_PER_LONG == 32
+# define WMULT_CONST	(~0UL)
+#else
+# define WMULT_CONST	(1UL << 32)
+#endif
+
+#define WMULT_SHIFT	32
+
+static inline u64
+calc_delta_mine(u64 delta_exec, unsigned long weight, struct load_weight *lw)
+{
+	if (unlikely(!lw->inv_weight))
+		lw->inv_weight = WMULT_CONST / lw->weight;
+
+	return (delta_exec * weight * lw->inv_weight) >> WMULT_SHIFT;
+}
+
+static inline u64 calc_delta_fair(u64 delta_exec, struct load_weight *lw)
+{
+	return calc_delta_mine(delta_exec, NICE_0_LOAD, lw);
+}
+
+static void update_load_add(struct load_weight *lw, unsigned long inc)
+{
+	lw->weight += inc;
+	lw->inv_weight = 0;
+}
+
+static void update_load_sub(struct load_weight *lw, unsigned long dec)
+{
+	lw->weight -= dec;
+	lw->inv_weight = 0;
+}
+
+static void __update_curr_load(struct rq *rq, struct load_stat *ls)
+{
+	if (rq->curr != rq->idle && ls->load.weight) {
+		ls->delta_exec += ls->delta_stat;
+		ls->delta_fair += calc_delta_fair(ls->delta_stat, &ls->load);
+		ls->delta_stat = 0;
+	}
+}
+
+/*
+ * Update delta_exec, delta_fair fields for rq.
+ *
+ * delta_fair clock advances at a rate inversely proportional to
+ * total load (rq->ls.load.weight) on the runqueue, while
+ * delta_exec advances at the same rate as wall-clock (provided
+ * cpu is not idle).
+ *
+ * delta_exec / delta_fair is a measure of the (smoothened) load on this
+ * runqueue over any given interval. This (smoothened) load is used
+ * during load balance.
+ *
+ * This function is called /before/ updating rq->ls.load
+ * and when switching tasks.
+ */
+static inline void update_curr_load(struct rq *rq, u64 now)
+{
+	struct load_stat *ls = &rq->ls;
+	u64 start;
+
+	start = ls->load_update_start;
+	ls->load_update_start = now;
+	ls->delta_stat += now - start;
+	/*
+	 * Stagger updates to ls->delta_fair. Very frequent updates
+	 * can be expensive.
+	 */
+	if (ls->delta_stat >= sysctl_sched_stat_granularity)
+		__update_curr_load(rq, ls);
+}
+
+
 /*
  * To aid in avoiding the subversion of "niceness" due to uneven distribution
  * of tasks with abnormal "nice" values across CPUs the contribution that
@@ -551,15 +673,15 @@ static inline void resched_task(struct t
  * this code will need modification
  */
 #define TIME_SLICE_NICE_ZERO DEF_TIMESLICE
-#define LOAD_WEIGHT(lp) \
+#define load_weight(lp) \
 	(((lp) * SCHED_LOAD_SCALE) / TIME_SLICE_NICE_ZERO)
-#define PRIO_TO_LOAD_WEIGHT(prio) \
-	LOAD_WEIGHT(static_prio_timeslice(prio))
-#define RTPRIO_TO_LOAD_WEIGHT(rp) \
-	(PRIO_TO_LOAD_WEIGHT(MAX_RT_PRIO) + LOAD_WEIGHT(rp))
+#define PRIO_TO_load_weight(prio) \
+	load_weight(static_prio_timeslice(prio))
+#define RTPRIO_TO_load_weight(rp) \
+	(PRIO_TO_load_weight(MAX_RT_PRIO) + load_weight(rp))
 
-#define NICE_0_LOAD	SCHED_LOAD_SCALE
-#define NICE_0_SHIFT	SCHED_LOAD_SHIFT
+#define WEIGHT_IDLEPRIO		2
+#define WMULT_IDLEPRIO		(1 << 31)
 
 /*
  * Nice levels are multiplicative, with a gentle 10% change for every
@@ -579,28 +701,41 @@ static const int prio_to_weight[40] = {
 /*  10 */   110,    87,    70,    56,    45,    36,    29,    23,    18,    15,
 };
 
+static const u32 prio_to_wmult[40] = {
+	48356,   60446,   75558,   94446,  118058,  147573,
+	184467,  230589,  288233,  360285,  450347,
+	562979,  703746,  879575, 1099582, 1374389,
+	717986, 2147483, 2684354, 3355443, 4194304,
+	244160, 6557201, 8196502, 10250518, 12782640,
+	16025997, 19976592, 24970740, 31350126, 39045157,
+	49367440, 61356675, 76695844, 95443717, 119304647,
+	148102320, 186737708, 238609294, 286331153,
+};
+
 static inline void
-inc_raw_weighted_load(struct rq *rq, const struct task_struct *p)
+inc_load(struct rq *rq, const struct task_struct *p, u64 now)
 {
-	rq->raw_weighted_load += p->load_weight;
+	update_curr_load(rq, now);
+	update_load_add(&rq->ls.load, p->se.load.weight);
 }
 
 static inline void
-dec_raw_weighted_load(struct rq *rq, const struct task_struct *p)
+dec_load(struct rq *rq, const struct task_struct *p, u64 now)
 {
-	rq->raw_weighted_load -= p->load_weight;
+	update_curr_load(rq, now);
+	update_load_sub(&rq->ls.load, p->se.load.weight);
 }
 
-static inline void inc_nr_running(struct task_struct *p, struct rq *rq)
+static inline void inc_nr_running(struct task_struct *p, struct rq *rq, u64 now)
 {
 	rq->nr_running++;
-	inc_raw_weighted_load(rq, p);
+	inc_load(rq, p, now);
 }
 
-static inline void dec_nr_running(struct task_struct *p, struct rq *rq)
+static inline void dec_nr_running(struct task_struct *p, struct rq *rq, u64 now)
 {
 	rq->nr_running--;
-	dec_raw_weighted_load(rq, p);
+	dec_load(rq, p, now);
 }
 
 static void activate_task(struct rq *rq, struct task_struct *p, int wakeup);
@@ -608,45 +743,48 @@ static void activate_task(struct rq *rq,
 #include "sched_stats.h"
 #include "sched_rt.c"
 #include "sched_fair.c"
+#include "sched_idletask.c"
 #include "sched_debug.c"
 
 #define sched_class_highest (&rt_sched_class)
 
 static void set_load_weight(struct task_struct *p)
 {
-	task_rq(p)->wait_runtime -= p->wait_runtime;
-	p->wait_runtime = 0;
+	task_rq(p)->cfs.wait_runtime -= p->se.wait_runtime;
+	p->se.wait_runtime = 0;
 
 	if (has_rt_policy(p)) {
-		p->load_weight = prio_to_weight[0] * 2;
+		p->se.load.weight = prio_to_weight[0] * 2;
+		p->se.load.inv_weight = prio_to_wmult[0] >> 1;
 		return;
 	}
+
 	/*
-	 * SCHED_IDLEPRIO tasks get minimal weight:
+	 * SCHED_IDLE tasks get minimal weight:
 	 */
-	if (p->policy == SCHED_IDLEPRIO) {
-		p->load_weight = 1;
+	if (p->policy == SCHED_IDLE) {
+		p->se.load.weight = WEIGHT_IDLEPRIO;
+		p->se.load.inv_weight = WMULT_IDLEPRIO;
 		return;
 	}
 
-	p->load_weight = prio_to_weight[p->static_prio - MAX_RT_PRIO];
+	p->se.load.weight = prio_to_weight[p->static_prio - MAX_RT_PRIO];
+	p->se.load.inv_weight = prio_to_wmult[p->static_prio - MAX_RT_PRIO];
 }
 
-static void enqueue_task(struct rq *rq, struct task_struct *p, int wakeup)
+static void
+enqueue_task(struct rq *rq, struct task_struct *p, int wakeup, u64 now)
 {
-	u64 now = rq_clock(rq);
-
 	sched_info_queued(p);
 	p->sched_class->enqueue_task(rq, p, wakeup, now);
-	p->on_rq = 1;
+	p->se.on_rq = 1;
 }
 
-static void dequeue_task(struct rq *rq, struct task_struct *p, int sleep)
+static void
+dequeue_task(struct rq *rq, struct task_struct *p, int sleep, u64 now)
 {
-	u64 now = rq_clock(rq);
-
 	p->sched_class->dequeue_task(rq, p, sleep, now);
-	p->on_rq = 0;
+	p->se.on_rq = 0;
 }
 
 /*
@@ -700,8 +838,13 @@ static int effective_prio(struct task_st
  */
 static void activate_task(struct rq *rq, struct task_struct *p, int wakeup)
 {
-	enqueue_task(rq, p, wakeup);
-	inc_nr_running(p, rq);
+	u64 now = rq_clock(rq);
+
+	if (p->state == TASK_UNINTERRUPTIBLE)
+		rq->nr_uninterruptible--;
+
+	enqueue_task(rq, p, wakeup, now);
+	inc_nr_running(p, rq, now);
 }
 
 /*
@@ -709,8 +852,13 @@ static void activate_task(struct rq *rq,
  */
 static inline void activate_idle_task(struct task_struct *p, struct rq *rq)
 {
-	enqueue_task(rq, p, 0);
-	inc_nr_running(p, rq);
+	u64 now = rq_clock(rq);
+
+	if (p->state == TASK_UNINTERRUPTIBLE)
+		rq->nr_uninterruptible--;
+
+	enqueue_task(rq, p, 0, now);
+	inc_nr_running(p, rq, now);
 }
 
 /*
@@ -718,8 +866,13 @@ static inline void activate_idle_task(st
  */
 static void deactivate_task(struct rq *rq, struct task_struct *p, int sleep)
 {
-	dequeue_task(rq, p, sleep);
-	dec_nr_running(p, rq);
+	u64 now = rq_clock(rq);
+
+	if (p->state == TASK_UNINTERRUPTIBLE)
+		rq->nr_uninterruptible++;
+
+	dequeue_task(rq, p, sleep, now);
+	dec_nr_running(p, rq, now);
 }
 
 /**
@@ -734,7 +887,7 @@ inline int task_curr(const struct task_s
 /* Used instead of source_load when we know the type == 0 */
 unsigned long weighted_cpuload(const int cpu)
 {
-	return cpu_rq(cpu)->raw_weighted_load;
+	return cpu_rq(cpu)->ls.load.weight;
 }
 
 #ifdef CONFIG_SMP
@@ -751,18 +904,19 @@ void set_task_cpu(struct task_struct *p,
 	u64 clock_offset, fair_clock_offset;
 
 	clock_offset = old_rq->clock - new_rq->clock;
-	fair_clock_offset = old_rq->fair_clock - new_rq->fair_clock;
+	fair_clock_offset = old_rq->cfs.fair_clock -
+						 new_rq->cfs.fair_clock;
 
-	if (p->wait_start)
-		p->wait_start -= clock_offset;
-	if (p->wait_start_fair)
-		p->wait_start_fair -= fair_clock_offset;
-	if (p->sleep_start)
-		p->sleep_start -= clock_offset;
-	if (p->block_start)
-		p->block_start -= clock_offset;
-	if (p->sleep_start_fair)
-		p->sleep_start_fair -= fair_clock_offset;
+	if (p->se.wait_start)
+		p->se.wait_start -= clock_offset;
+	if (p->se.wait_start_fair)
+		p->se.wait_start_fair -= fair_clock_offset;
+	if (p->se.sleep_start)
+		p->se.sleep_start -= clock_offset;
+	if (p->se.block_start)
+		p->se.block_start -= clock_offset;
+	if (p->se.sleep_start_fair)
+		p->se.sleep_start_fair -= fair_clock_offset;
 
 	task_thread_info(p)->cpu = new_cpu;
 
@@ -790,7 +944,7 @@ migrate_task(struct task_struct *p, int 
 	 * If the task is not on a runqueue (and not running), then
 	 * it is sufficient to simply update the task's cpu field.
 	 */
-	if (!p->on_rq && !task_running(rq, p)) {
+	if (!p->se.on_rq && !task_running(rq, p)) {
 		set_task_cpu(p, dest_cpu);
 		return 0;
 	}
@@ -815,9 +969,8 @@ migrate_task(struct task_struct *p, int 
 void wait_task_inactive(struct task_struct *p)
 {
 	unsigned long flags;
+	int running, on_rq;
 	struct rq *rq;
-	int on_rq;
-	int running;
 
 repeat:
 	/*
@@ -849,7 +1002,7 @@ repeat:
 	 */
 	rq = task_rq_lock(p, &flags);
 	running = task_running(rq, p);
-	on_rq = p->on_rq;
+	on_rq = p->se.on_rq;
 	task_rq_unlock(rq, &flags);
 
 	/*
@@ -918,11 +1071,12 @@ void kick_process(struct task_struct *p)
 static inline unsigned long source_load(int cpu, int type)
 {
 	struct rq *rq = cpu_rq(cpu);
+	unsigned long total = weighted_cpuload(cpu);
 
 	if (type == 0)
-		return rq->raw_weighted_load;
+		return total;
 
-	return min(rq->cpu_load[type-1], rq->raw_weighted_load);
+	return min(rq->cpu_load[type-1], total);
 }
 
 /*
@@ -932,11 +1086,12 @@ static inline unsigned long source_load(
 static inline unsigned long target_load(int cpu, int type)
 {
 	struct rq *rq = cpu_rq(cpu);
+	unsigned long total = weighted_cpuload(cpu);
 
 	if (type == 0)
-		return rq->raw_weighted_load;
+		return total;
 
-	return max(rq->cpu_load[type-1], rq->raw_weighted_load);
+	return max(rq->cpu_load[type-1], total);
 }
 
 /*
@@ -945,9 +1100,10 @@ static inline unsigned long target_load(
 static inline unsigned long cpu_avg_load_per_task(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
+	unsigned long total = weighted_cpuload(cpu);
 	unsigned long n = rq->nr_running;
 
-	return n ? rq->raw_weighted_load / n : SCHED_LOAD_SCALE;
+	return n ? total / n : SCHED_LOAD_SCALE;
 }
 
 /*
@@ -1178,7 +1334,7 @@ static int try_to_wake_up(struct task_st
 	if (!(old_state & state))
 		goto out;
 
-	if (p->on_rq)
+	if (p->se.on_rq)
 		goto out_running;
 
 	cpu = task_cpu(p);
@@ -1233,11 +1389,11 @@ static int try_to_wake_up(struct task_st
 			 * of the current CPU:
 			 */
 			if (sync)
-				tl -= current->load_weight;
+				tl -= current->se.load.weight;
 
 			if ((tl <= load &&
 				tl + target_load(cpu, idx) <= tl_per_task) ||
-				100*(tl + p->load_weight) <= imbalance*load) {
+			       100*(tl + p->se.load.weight) <= imbalance*load) {
 				/*
 				 * This domain has SD_WAKE_AFFINE and
 				 * p is cache cold in this domain, and
@@ -1271,7 +1427,7 @@ out_set_cpu:
 		old_state = p->state;
 		if (!(old_state & state))
 			goto out;
-		if (p->on_rq)
+		if (p->se.on_rq)
 			goto out_running;
 
 		this_cpu = smp_processor_id();
@@ -1280,9 +1436,6 @@ out_set_cpu:
 
 out_activate:
 #endif /* CONFIG_SMP */
-	if (old_state == TASK_UNINTERRUPTIBLE)
-		rq->nr_uninterruptible--;
-
 	activate_task(rq, p, 1);
 	/*
 	 * Sync wakeups (i.e. those types of wakeups where the waker
@@ -1317,17 +1470,6 @@ int fastcall wake_up_state(struct task_s
 }
 
 /*
- * The task was running during this tick - call the class tick
- * (to update the time slice counter and other statistics, etc.):
- */
-static void task_running_tick(struct rq *rq, struct task_struct *p)
-{
-	spin_lock(&rq->lock);
-	p->sched_class->task_tick(rq, p);
-	spin_unlock(&rq->lock);
-}
-
-/*
  * Perform scheduler related setup for a newly forked process p.
  * p is forked by current.
  *
@@ -1335,19 +1477,20 @@ static void task_running_tick(struct rq 
  */
 static void __sched_fork(struct task_struct *p)
 {
-	p->wait_start_fair = p->wait_start = p->exec_start = 0;
-	p->sum_exec_runtime = 0;
-
-	p->wait_runtime = 0;
-
-	p->sum_wait_runtime = p->sum_sleep_runtime = 0;
-	p->sleep_start = p->sleep_start_fair = p->block_start = 0;
-	p->sleep_max = p->block_max = p->exec_max = p->wait_max = 0;
-	p->wait_runtime_overruns = p->wait_runtime_underruns = 0;
+	p->se.wait_start_fair = p->se.wait_start = p->se.exec_start = 0;
+	p->se.sum_exec_runtime = 0;
+	p->se.delta_exec = 0;
+	p->se.delta_fair = 0;
+
+	p->se.wait_runtime = 0;
+
+	p->se.sum_wait_runtime = p->se.sum_sleep_runtime = 0;
+	p->se.sleep_start = p->se.sleep_start_fair = p->se.block_start = 0;
+	p->se.sleep_max = p->se.block_max = p->se.exec_max = p->se.wait_max = 0;
+	p->se.wait_runtime_overruns = p->se.wait_runtime_underruns = 0;
 
 	INIT_LIST_HEAD(&p->run_list);
-	p->on_rq = 0;
-	p->nr_switches = 0;
+	p->se.on_rq = 0;
 
 	/*
 	 * We mark the process as running here, but have not actually
@@ -1417,7 +1560,7 @@ void fastcall wake_up_new_task(struct ta
 	p->prio = effective_prio(p);
 
 	if (!sysctl_sched_child_runs_first || (clone_flags & CLONE_VM) ||
-			task_cpu(p) != this_cpu || !current->on_rq) {
+			task_cpu(p) != this_cpu || !current->se.on_rq) {
 		activate_task(rq, p, 0);
 	} else {
 		/*
@@ -1432,7 +1575,7 @@ void fastcall wake_up_new_task(struct ta
 
 void sched_dead(struct task_struct *p)
 {
-	WARN_ON_ONCE(p->on_rq);
+	WARN_ON_ONCE(p->se.on_rq);
 }
 
 /**
@@ -1490,13 +1633,13 @@ static inline void finish_task_switch(st
 	prev_state = prev->state;
 	finish_arch_switch(prev);
 	finish_lock_switch(rq, prev);
-	if (mm)
+	if (likely(mm))
 		mmdrop(mm);
 	if (unlikely(prev_state == TASK_DEAD)) {
 		/*
 		 * Remove function-return probe instances associated with this
 		 * task and put them back on the free list.
-	 	 */
+		 */
 		kprobe_flush_task(prev);
 		put_task_struct(prev);
 	}
@@ -1524,13 +1667,15 @@ asmlinkage void schedule_tail(struct tas
  * context_switch - switch to the new MM and the new
  * thread's register state.
  */
-static inline struct task_struct *
+static inline void
 context_switch(struct rq *rq, struct task_struct *prev,
 	       struct task_struct *next)
 {
-	struct mm_struct *mm = next->mm;
-	struct mm_struct *oldmm = prev->active_mm;
+	struct mm_struct *mm, *oldmm;
 
+	prepare_task_switch(rq, next);
+	mm = next->mm;
+	oldmm = prev->active_mm;
 	/*
 	 * For paravirt, this is coupled with an exit in switch_to to
 	 * combine the page table reload and the switch backend into
@@ -1538,16 +1683,15 @@ context_switch(struct rq *rq, struct tas
 	 */
 	arch_enter_lazy_cpu_mode();
 
-	if (!mm) {
+	if (unlikely(!mm)) {
 		next->active_mm = oldmm;
 		atomic_inc(&oldmm->mm_count);
 		enter_lazy_tlb(oldmm, next);
 	} else
 		switch_mm(oldmm, mm, next);
 
-	if (!prev->mm) {
+	if (unlikely(!prev->mm)) {
 		prev->active_mm = NULL;
-		WARN_ON(rq->prev_mm);
 		rq->prev_mm = oldmm;
 	}
 	/*
@@ -1563,7 +1707,13 @@ context_switch(struct rq *rq, struct tas
 	/* Here we just switch the register state and the stack. */
 	switch_to(prev, next, prev);
 
-	return prev;
+	barrier();
+	/*
+	 * this_rq must be evaluated again because prev may have moved
+	 * CPUs since it called schedule(), thus the 'rq' on its stack
+	 * frame will be invalid.
+	 */
+	finish_task_switch(this_rq(), prev);
 }
 
 /*
@@ -1636,41 +1786,50 @@ unsigned long nr_active(void)
 	return running + uninterruptible;
 }
 
-static void update_load_fair(struct rq *this_rq)
+/*
+ * Update rq->cpu_load[] statistics. This function is usually called every
+ * scheduler tick (TICK_NSEC).
+ */
+static void update_cpu_load(struct rq *this_rq)
 {
-	unsigned long this_load, fair_delta, exec_delta, idle_delta;
-	u64 fair_delta64, exec_delta64, tmp64;
-	unsigned int i, scale;
+	u64 fair_delta64, exec_delta64, idle_delta64, sample_interval64, tmp64;
+	unsigned long total_load = this_rq->ls.load.weight;
+	unsigned long this_load =  total_load;
+	struct load_stat *ls = &this_rq->ls;
+	u64 now = __rq_clock(this_rq);
+	int i, scale;
 
 	this_rq->nr_load_updates++;
-	if (!(sysctl_sched_features & 64)) {
-		this_load = this_rq->raw_weighted_load;
+	if (sysctl_sched_features & 64)
 		goto do_avg;
-	}
 
-	fair_delta64 = this_rq->delta_fair_clock + 1;
-	this_rq->delta_fair_clock = 0;
+	/* Update delta_fair/delta_exec fields first */
+	update_curr_load(this_rq, now);
+
+	fair_delta64 = ls->delta_fair + 1;
+	ls->delta_fair = 0;
 
-	exec_delta64 = this_rq->delta_exec_clock + 1;
-	this_rq->delta_exec_clock = 0;
+	exec_delta64 = ls->delta_exec + 1;
+	ls->delta_exec = 0;
+
+	sample_interval64 = now - ls->load_update_last;
+	ls->load_update_last = now;
+
+	if ((s64)sample_interval64 < (s64)TICK_NSEC)
+		sample_interval64 = TICK_NSEC;
+
+	if (exec_delta64 > sample_interval64)
+		exec_delta64 = sample_interval64;
+
+	idle_delta64 = sample_interval64 - exec_delta64;
+
+	tmp64 = div64_64(SCHED_LOAD_SCALE * exec_delta64, fair_delta64);
+	tmp64 = div64_64(tmp64 * exec_delta64, sample_interval64);
 
-	if (fair_delta64 > (u64)LONG_MAX)
-		fair_delta64 = (u64)LONG_MAX;
-	fair_delta = (unsigned long)fair_delta64;
-
-	if (exec_delta64 > (u64)TICK_NSEC)
-		exec_delta64 = (u64)TICK_NSEC;
-	exec_delta = (unsigned long)exec_delta64;
-
-	idle_delta = TICK_NSEC - exec_delta;
-
-	tmp64 = SCHED_LOAD_SCALE * exec_delta64;
-	do_div(tmp64, fair_delta);
-	tmp64 *= exec_delta64;
-	do_div(tmp64, TICK_NSEC);
 	this_load = (unsigned long)tmp64;
 
 do_avg:
+
 	/* Update our load: */
 	for (i = 0, scale = 1; i < CPU_LOAD_IDX_MAX; i++, scale += scale) {
 		unsigned long old_load, new_load;
@@ -1820,7 +1979,7 @@ static void pull_task(struct rq *src_rq,
  */
 static
 int can_migrate_task(struct task_struct *p, struct rq *rq, int this_cpu,
-		     struct sched_domain *sd, enum idle_type idle,
+		     struct sched_domain *sd, enum cpu_idle_type idle,
 		     int *all_pinned)
 {
 	/*
@@ -1900,7 +2059,7 @@ struct task_struct * load_balance_next(s
  */
 static int move_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		      unsigned long max_nr_move, unsigned long max_load_move,
-		      struct sched_domain *sd, enum idle_type idle,
+		      struct sched_domain *sd, enum cpu_idle_type idle,
 		      int *all_pinned)
 {
 	int pulled = 0, pinned = 0, this_best_prio, best_prio,
@@ -1936,7 +2095,8 @@ next:
 	 * skip a task if it will be the highest priority task (i.e. smallest
 	 * prio value) on its new queue regardless of its load weight
 	 */
-	skip_for_load = (p->load_weight >> 1) > rem_load_move + SCHED_LOAD_SCALE_FUZZ;
+	skip_for_load = (p->se.load.weight >> 1) > rem_load_move +
+							 SCHED_LOAD_SCALE_FUZZ;
 	if (skip_for_load && p->prio < this_best_prio)
 		skip_for_load = !best_prio_seen && p->prio == best_prio;
 	if (skip_for_load ||
@@ -1949,7 +2109,7 @@ next:
 
 	pull_task(busiest, p, this_rq, this_cpu);
 	pulled++;
-	rem_load_move -= p->load_weight;
+	rem_load_move -= p->se.load.weight;
 
 	/*
 	 * We only want to steal up to the prescribed number of tasks
@@ -1981,8 +2141,8 @@ out:
  */
 static struct sched_group *
 find_busiest_group(struct sched_domain *sd, int this_cpu,
-		   unsigned long *imbalance, enum idle_type idle, int *sd_idle,
-		   cpumask_t *cpus, int *balance)
+		   unsigned long *imbalance, enum cpu_idle_type idle,
+		   int *sd_idle, cpumask_t *cpus, int *balance)
 {
 	struct sched_group *busiest = NULL, *this = NULL, *group = sd->groups;
 	unsigned long max_load, avg_load, total_load, this_load, total_pwr;
@@ -2000,9 +2160,9 @@ find_busiest_group(struct sched_domain *
 	max_load = this_load = total_load = total_pwr = 0;
 	busiest_load_per_task = busiest_nr_running = 0;
 	this_load_per_task = this_nr_running = 0;
-	if (idle == NOT_IDLE)
+	if (idle == CPU_NOT_IDLE)
 		load_idx = sd->busy_idx;
-	else if (idle == NEWLY_IDLE)
+	else if (idle == CPU_NEWLY_IDLE)
 		load_idx = sd->newidle_idx;
 	else
 		load_idx = sd->idle_idx;
@@ -2046,7 +2206,7 @@ find_busiest_group(struct sched_domain *
 
 			avg_load += load;
 			sum_nr_running += rq->nr_running;
-			sum_weighted_load += rq->raw_weighted_load;
+			sum_weighted_load += weighted_cpuload(i);
 		}
 
 		/*
@@ -2086,7 +2246,8 @@ find_busiest_group(struct sched_domain *
 		 * Busy processors will not participate in power savings
 		 * balance.
 		 */
-		if (idle == NOT_IDLE || !(sd->flags & SD_POWERSAVINGS_BALANCE))
+		if (idle == CPU_NOT_IDLE ||
+				!(sd->flags & SD_POWERSAVINGS_BALANCE))
 			goto group_next;
 
 		/*
@@ -2249,7 +2410,7 @@ small_imbalance:
 
 out_balanced:
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-	if (idle == NOT_IDLE || !(sd->flags & SD_POWERSAVINGS_BALANCE))
+	if (idle == CPU_NOT_IDLE || !(sd->flags & SD_POWERSAVINGS_BALANCE))
 		goto ret;
 
 	if (this == group_leader && group_leader != group_min) {
@@ -2266,7 +2427,7 @@ ret:
  * find_busiest_queue - find the busiest runqueue among the cpus in group.
  */
 static struct rq *
-find_busiest_queue(struct sched_group *group, enum idle_type idle,
+find_busiest_queue(struct sched_group *group, enum cpu_idle_type idle,
 		   unsigned long imbalance, cpumask_t *cpus)
 {
 	struct rq *busiest = NULL, *rq;
@@ -2274,17 +2435,19 @@ find_busiest_queue(struct sched_group *g
 	int i;
 
 	for_each_cpu_mask(i, group->cpumask) {
+		unsigned long wl;
 
 		if (!cpu_isset(i, *cpus))
 			continue;
 
 		rq = cpu_rq(i);
+		wl = weighted_cpuload(i);
 
-		if (rq->nr_running == 1 && rq->raw_weighted_load > imbalance)
+		if (rq->nr_running == 1 && wl > imbalance)
 			continue;
 
-		if (rq->raw_weighted_load > max_load) {
-			max_load = rq->raw_weighted_load;
+		if (wl > max_load) {
+			max_load = wl;
 			busiest = rq;
 		}
 	}
@@ -2308,7 +2471,7 @@ static inline unsigned long minus_1_or_z
  * tasks if there is an imbalance.
  */
 static int load_balance(int this_cpu, struct rq *this_rq,
-			struct sched_domain *sd, enum idle_type idle,
+			struct sched_domain *sd, enum cpu_idle_type idle,
 			int *balance)
 {
 	int nr_moved, all_pinned = 0, active_balance = 0, sd_idle = 0;
@@ -2321,10 +2484,10 @@ static int load_balance(int this_cpu, st
 	/*
 	 * When power savings policy is enabled for the parent domain, idle
 	 * sibling can pick up load irrespective of busy siblings. In this case,
-	 * let the state of idle sibling percolate up as IDLE, instead of
-	 * portraying it as NOT_IDLE.
+	 * let the state of idle sibling percolate up as CPU_IDLE, instead of
+	 * portraying it as CPU_NOT_IDLE.
 	 */
-	if (idle != NOT_IDLE && sd->flags & SD_SHARE_CPUPOWER &&
+	if (idle != CPU_NOT_IDLE && sd->flags & SD_SHARE_CPUPOWER &&
 	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
 		sd_idle = 1;
 
@@ -2458,7 +2621,7 @@ out_one_pinned:
  * Check this_cpu to ensure it is balanced within domain. Attempt to move
  * tasks if there is an imbalance.
  *
- * Called from schedule when this_rq is about to become idle (NEWLY_IDLE).
+ * Called from schedule when this_rq is about to become idle (CPU_NEWLY_IDLE).
  * this_rq is locked.
  */
 static int
@@ -2475,31 +2638,31 @@ load_balance_newidle(int this_cpu, struc
 	 * When power savings policy is enabled for the parent domain, idle
 	 * sibling can pick up load irrespective of busy siblings. In this case,
 	 * let the state of idle sibling percolate up as IDLE, instead of
-	 * portraying it as NOT_IDLE.
+	 * portraying it as CPU_NOT_IDLE.
 	 */
 	if (sd->flags & SD_SHARE_CPUPOWER &&
 	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
 		sd_idle = 1;
 
-	schedstat_inc(sd, lb_cnt[NEWLY_IDLE]);
+	schedstat_inc(sd, lb_cnt[CPU_NEWLY_IDLE]);
 redo:
-	group = find_busiest_group(sd, this_cpu, &imbalance, NEWLY_IDLE,
+	group = find_busiest_group(sd, this_cpu, &imbalance, CPU_NEWLY_IDLE,
 				   &sd_idle, &cpus, NULL);
 	if (!group) {
-		schedstat_inc(sd, lb_nobusyg[NEWLY_IDLE]);
+		schedstat_inc(sd, lb_nobusyg[CPU_NEWLY_IDLE]);
 		goto out_balanced;
 	}
 
-	busiest = find_busiest_queue(group, NEWLY_IDLE, imbalance,
+	busiest = find_busiest_queue(group, CPU_NEWLY_IDLE, imbalance,
 				&cpus);
 	if (!busiest) {
-		schedstat_inc(sd, lb_nobusyq[NEWLY_IDLE]);
+		schedstat_inc(sd, lb_nobusyq[CPU_NEWLY_IDLE]);
 		goto out_balanced;
 	}
 
 	BUG_ON(busiest == this_rq);
 
-	schedstat_add(sd, lb_imbalance[NEWLY_IDLE], imbalance);
+	schedstat_add(sd, lb_imbalance[CPU_NEWLY_IDLE], imbalance);
 
 	nr_moved = 0;
 	if (busiest->nr_running > 1) {
@@ -2507,7 +2670,7 @@ redo:
 		double_lock_balance(this_rq, busiest);
 		nr_moved = move_tasks(this_rq, this_cpu, busiest,
 					minus_1_or_zero(busiest->nr_running),
-					imbalance, sd, NEWLY_IDLE, NULL);
+					imbalance, sd, CPU_NEWLY_IDLE, NULL);
 		spin_unlock(&busiest->lock);
 
 		if (!nr_moved) {
@@ -2518,7 +2681,7 @@ redo:
 	}
 
 	if (!nr_moved) {
-		schedstat_inc(sd, lb_failed[NEWLY_IDLE]);
+		schedstat_inc(sd, lb_failed[CPU_NEWLY_IDLE]);
 		if (!sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
 		    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
 			return -1;
@@ -2528,7 +2691,7 @@ redo:
 	return nr_moved;
 
 out_balanced:
-	schedstat_inc(sd, lb_balanced[NEWLY_IDLE]);
+	schedstat_inc(sd, lb_balanced[CPU_NEWLY_IDLE]);
 	if (!sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
 	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
 		return -1;
@@ -2544,8 +2707,8 @@ out_balanced:
 static void idle_balance(int this_cpu, struct rq *this_rq)
 {
 	struct sched_domain *sd;
-	int pulled_task = 0;
-	unsigned long next_balance = jiffies + 60 *  HZ;
+	int pulled_task = -1;
+	unsigned long next_balance = jiffies + HZ;
 
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
@@ -2564,12 +2727,13 @@ static void idle_balance(int this_cpu, s
 		if (pulled_task)
 			break;
 	}
-	if (!pulled_task)
+	if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
 		/*
 		 * We are going idle. next_balance may be set based on
 		 * a busy processor. So reset next_balance.
 		 */
 		this_rq->next_balance = next_balance;
+	}
 }
 
 /*
@@ -2613,7 +2777,7 @@ static void active_load_balance(struct r
 		schedstat_inc(sd, alb_cnt);
 
 		if (move_tasks(target_rq, target_cpu, busiest_rq, 1,
-			       RTPRIO_TO_LOAD_WEIGHT(100), sd, SCHED_IDLE,
+			       RTPRIO_TO_load_weight(100), sd, CPU_IDLE,
 			       NULL))
 			schedstat_inc(sd, alb_pushed);
 		else
@@ -2704,7 +2868,7 @@ static DEFINE_SPINLOCK(balancing);
  *
  * Balancing parameters are set up in arch_init_sched_domains.
  */
-static inline void rebalance_domains(int cpu, enum idle_type idle)
+static inline void rebalance_domains(int cpu, enum cpu_idle_type idle)
 {
 	int balance = 1;
 	struct rq *rq = cpu_rq(cpu);
@@ -2718,7 +2882,7 @@ static inline void rebalance_domains(int
 			continue;
 
 		interval = sd->balance_interval;
-		if (idle != SCHED_IDLE)
+		if (idle != CPU_IDLE)
 			interval *= sd->busy_factor;
 
 		/* scale ms to jiffies */
@@ -2741,7 +2905,7 @@ static inline void rebalance_domains(int
 				 * longer idle, or one of our SMT siblings is
 				 * not idle.
 				 */
-				idle = NOT_IDLE;
+				idle = CPU_NOT_IDLE;
 			}
 			sd->last_balance = jiffies;
 		}
@@ -2771,7 +2935,8 @@ static void run_rebalance_domains(struct
 {
 	int local_cpu = smp_processor_id();
 	struct rq *local_rq = cpu_rq(local_cpu);
-	enum idle_type idle = local_rq->idle_at_tick ? SCHED_IDLE : NOT_IDLE;
+	enum cpu_idle_type idle = local_rq->idle_at_tick ?
+						CPU_IDLE : CPU_NOT_IDLE;
 
 	rebalance_domains(local_cpu, idle);
 
@@ -2814,9 +2979,8 @@ static void run_rebalance_domains(struct
  * idle load balancing owner or decide to stop the periodic load balancing,
  * if the whole system is idle.
  */
-static inline void trigger_load_balance(int cpu)
+static inline void trigger_load_balance(struct rq *rq, int cpu)
 {
-	struct rq *rq = cpu_rq(cpu);
 #ifdef CONFIG_NO_HZ
 	/*
 	 * If we were in the nohz mode recently and busy at the current
@@ -2868,14 +3032,17 @@ static inline void trigger_load_balance(
 	if (time_after_eq(jiffies, rq->next_balance))
 		raise_softirq(SCHED_SOFTIRQ);
 }
-#else
+
+#else	/* CONFIG_SMP */
+
 /*
  * on UP we do not need to balance between CPUs:
  */
 static inline void idle_balance(int cpu, struct rq *rq)
 {
 }
-#endif
+
+#endif	/* CONFIG_SMP */
 
 DEFINE_PER_CPU(struct kernel_stat, kstat);
 
@@ -2892,9 +3059,9 @@ unsigned long long task_sched_runtime(st
 	struct rq *rq;
 
 	rq = task_rq_lock(p, &flags);
-	ns = p->sum_exec_runtime;
+	ns = p->se.sum_exec_runtime;
 	if (rq->curr == p) {
-		delta_exec = rq_clock(rq) - p->exec_start;
+		delta_exec = rq_clock(rq) - p->se.exec_start;
 		if ((s64)delta_exec > 0)
 			ns += delta_exec;
 	}
@@ -2985,17 +3152,19 @@ void account_steal_time(struct task_stru
  */
 void scheduler_tick(void)
 {
-	struct task_struct *p = current;
 	int cpu = smp_processor_id();
-	int idle_at_tick = idle_cpu(cpu);
 	struct rq *rq = cpu_rq(cpu);
+	struct task_struct *curr = rq->curr;
+
+	spin_lock(&rq->lock);
+	if (curr != rq->idle) /* FIXME: needed? */
+		curr->sched_class->task_tick(rq, curr);
+	update_cpu_load(rq);
+	spin_unlock(&rq->lock);
 
-	if (!idle_at_tick)
-		task_running_tick(rq, p);
-	update_load_fair(rq);
 #ifdef CONFIG_SMP
-	rq->idle_at_tick = idle_at_tick;
-	trigger_load_balance(cpu);
+	rq->idle_at_tick = idle_cpu(cpu);
+	trigger_load_balance(rq, cpu);
 #endif
 }
 
@@ -3038,55 +3207,66 @@ EXPORT_SYMBOL(sub_preempt_count);
 #endif
 
 /*
+ * Print scheduling while atomic bug:
+ */
+static noinline void __schedule_bug(struct task_struct *prev)
+{
+	printk(KERN_ERR "BUG: scheduling while atomic: %s/0x%08x/%d\n",
+		prev->comm, preempt_count(), prev->pid);
+	debug_show_held_locks(prev);
+	if (irqs_disabled())
+		print_irqtrace_events(prev);
+	dump_stack();
+}
+
+/*
  * Various schedule()-time debugging checks and statistics:
  */
-static inline void schedule_debug(struct rq *rq, struct task_struct *prev)
+static inline void schedule_debug(struct task_struct *prev)
 {
 	/*
 	 * Test if we are atomic.  Since do_exit() needs to call into
 	 * schedule() atomically, we ignore that path for now.
 	 * Otherwise, whine if we are scheduling when we should not be.
 	 */
-	if (unlikely(in_atomic_preempt_off() && !prev->exit_state)) {
-		printk(KERN_ERR "BUG: scheduling while atomic: "
-			"%s/0x%08x/%d\n",
-			prev->comm, preempt_count(), prev->pid);
-		debug_show_held_locks(prev);
-		if (irqs_disabled())
-			print_irqtrace_events(prev);
-		dump_stack();
-	}
-	profile_hit(SCHED_PROFILING, __builtin_return_address(0));
+	if (unlikely(in_atomic_preempt_off()) && unlikely(!prev->exit_state))
+		__schedule_bug(prev);
 
-	/*
-	 * The idle thread is not allowed to schedule!
-	 * Remove this check after it has been exercised a bit.
-	 */
-	if (unlikely(prev == rq->idle) && prev->state != TASK_RUNNING) {
-		printk(KERN_ERR "bad: scheduling from the idle thread!\n");
-		dump_stack();
-	}
+	profile_hit(SCHED_PROFILING, __builtin_return_address(0));
 
-	schedstat_inc(rq, sched_cnt);
+	schedstat_inc(this_rq(), sched_cnt);
 }
 
+/*
+ * Pick up the highest-prio task:
+ */
 static inline struct task_struct *
-pick_next_task(struct rq *rq, struct task_struct *prev)
+pick_next_task(struct rq *rq, struct task_struct *prev, u64 now)
 {
-	struct sched_class *class = sched_class_highest;
-	u64 now = __rq_clock(rq);
+	struct sched_class *class;
 	struct task_struct *p;
 
-	prev->sched_class->put_prev_task(rq, prev, now);
+	/*
+	 * Optimization: we know that if all tasks are in
+	 * the fair class we can call that function directly:
+	 */
+	if (likely(rq->nr_running == rq->cfs.nr_running)) {
+		p = fair_sched_class.pick_next_task(rq, now);
+		if (likely(p))
+			return p;
+	}
 
-	do {
+	class = sched_class_highest;
+	for (;;) {
 		p = class->pick_next_task(rq, now);
 		if (p)
 			return p;
+		/*
+		 * Will never be NULL as the idle class always
+		 * returns a non-NULL p:
+		 */
 		class = class->next;
-	} while (class);
-
-	return NULL;
+	}
 }
 
 /*
@@ -3097,74 +3277,58 @@ asmlinkage void __sched schedule(void)
 	struct task_struct *prev, *next;
 	long *switch_count;
 	struct rq *rq;
+	u64 now;
 	int cpu;
 
 need_resched:
 	preempt_disable();
-	prev = current;
+	cpu = smp_processor_id();
+	rq = cpu_rq(cpu);
+	rcu_qsctr_inc(cpu);
+	prev = rq->curr;
+	switch_count = &prev->nivcsw;
+
 	release_kernel_lock(prev);
 need_resched_nonpreemptible:
-	rq = this_rq();
 
-	schedule_debug(rq, prev);
+	schedule_debug(prev);
 
 	spin_lock_irq(&rq->lock);
+	clear_tsk_need_resched(prev);
 
-	switch_count = &prev->nivcsw;
 	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
-		switch_count = &prev->nvcsw;
 		if (unlikely((prev->state & TASK_INTERRUPTIBLE) &&
-				unlikely(signal_pending(prev))))
+				unlikely(signal_pending(prev)))) {
 			prev->state = TASK_RUNNING;
-		else {
-			if (prev->state == TASK_UNINTERRUPTIBLE)
-				rq->nr_uninterruptible++;
+		} else {
 			deactivate_task(rq, prev, 1);
 		}
+		switch_count = &prev->nvcsw;
 	}
 
-	cpu = smp_processor_id();
-	if (unlikely(!rq->nr_running)) {
+	if (unlikely(!rq->nr_running))
 		idle_balance(cpu, rq);
-		if (!rq->nr_running) {
-			prev->sched_class->put_prev_task(rq, prev,
-							 __rq_clock(rq));
-			next = rq->idle;
-			schedstat_inc(rq, sched_goidle);
-			goto switch_tasks;
-		}
-	}
-
-	next = pick_next_task(rq, prev);
-	next->nr_switches++;
 
-switch_tasks:
-	prefetch(next);
-	prefetch_stack(next);
-	clear_tsk_need_resched(prev);
-	rcu_qsctr_inc(task_cpu(prev));
+	now = __rq_clock(rq);
+	prev->sched_class->put_prev_task(rq, prev, now);
+	next = pick_next_task(rq, prev, now);
 
 	sched_info_switch(prev, next);
+
 	if (likely(prev != next)) {
 		rq->nr_switches++;
 		rq->curr = next;
 		++*switch_count;
 
-		prepare_task_switch(rq, next);
-		prev = context_switch(rq, prev, next);
-		barrier();
-		/*
-		 * this_rq must be evaluated again because prev may have moved
-		 * CPUs since it called schedule(), thus the 'rq' on its stack
-		 * frame will be invalid.
-		 */
-		finish_task_switch(this_rq(), prev);
+		context_switch(rq, prev, next); /* unlocks the rq */
 	} else
 		spin_unlock_irq(&rq->lock);
 
-	prev = current;
-	if (unlikely(reacquire_kernel_lock(prev) < 0))
+	if (unlikely(reacquire_kernel_lock(current) < 0)) {
+		cpu = smp_processor_id();
+		rq = cpu_rq(cpu);
 		goto need_resched_nonpreemptible;
+	}
 	preempt_enable_no_resched();
 	if (unlikely(test_thread_flag(TIF_NEED_RESCHED)))
 		goto need_resched;
@@ -3579,15 +3743,17 @@ void rt_mutex_setprio(struct task_struct
 	unsigned long flags;
 	int oldprio, on_rq;
 	struct rq *rq;
+	u64 now;
 
 	BUG_ON(prio < 0 || prio > MAX_PRIO);
 
 	rq = task_rq_lock(p, &flags);
+	now = rq_clock(rq);
 
 	oldprio = p->prio;
-	on_rq = p->on_rq;
+	on_rq = p->se.on_rq;
 	if (on_rq)
-		dequeue_task(rq, p, 0);
+		dequeue_task(rq, p, 0, now);
 
 	if (rt_prio(prio))
 		p->sched_class = &rt_sched_class;
@@ -3597,7 +3763,7 @@ void rt_mutex_setprio(struct task_struct
 	p->prio = prio;
 
 	if (on_rq) {
-		enqueue_task(rq, p, 0);
+		enqueue_task(rq, p, 0, now);
 		/*
 		 * Reschedule if we are currently running on this runqueue and
 		 * our priority decreased, or if we are not currently running on
@@ -3620,6 +3786,7 @@ void set_user_nice(struct task_struct *p
 	int old_prio, delta, on_rq;
 	unsigned long flags;
 	struct rq *rq;
+	u64 now;
 
 	if (TASK_NICE(p) == nice || nice < -20 || nice > 19)
 		return;
@@ -3628,6 +3795,7 @@ void set_user_nice(struct task_struct *p
 	 * the task might be in the middle of scheduling on another CPU.
 	 */
 	rq = task_rq_lock(p, &flags);
+	now = rq_clock(rq);
 	/*
 	 * The RT priorities are set via sched_setscheduler(), but we still
 	 * allow the 'normal' nice value to be set - but as expected
@@ -3638,10 +3806,10 @@ void set_user_nice(struct task_struct *p
 		p->static_prio = NICE_TO_PRIO(nice);
 		goto out_unlock;
 	}
-	on_rq = p->on_rq;
+	on_rq = p->se.on_rq;
 	if (on_rq) {
-		dequeue_task(rq, p, 0);
-		dec_raw_weighted_load(rq, p);
+		dequeue_task(rq, p, 0, now);
+		dec_load(rq, p, now);
 	}
 
 	p->static_prio = NICE_TO_PRIO(nice);
@@ -3651,8 +3819,8 @@ void set_user_nice(struct task_struct *p
 	delta = p->prio - old_prio;
 
 	if (on_rq) {
-		enqueue_task(rq, p, 0);
-		inc_raw_weighted_load(rq, p);
+		enqueue_task(rq, p, 0, now);
+		inc_load(rq, p, now);
 		/*
 		 * If the task increased its priority or is running and
 		 * lowered its priority, then reschedule its CPU:
@@ -3775,13 +3943,14 @@ static inline struct task_struct *find_p
 static void
 __setscheduler(struct rq *rq, struct task_struct *p, int policy, int prio)
 {
-	BUG_ON(p->on_rq);
+	BUG_ON(p->se.on_rq);
 
 	p->policy = policy;
 	switch (p->policy) {
 	case SCHED_NORMAL:
 	case SCHED_BATCH:
-	case SCHED_IDLEPRIO:
+	case SCHED_ISO:
+	case SCHED_IDLE:
 		p->sched_class = &fair_sched_class;
 		break;
 	case SCHED_FIFO:
@@ -3820,12 +3989,12 @@ recheck:
 		policy = oldpolicy = p->policy;
 	else if (policy != SCHED_FIFO && policy != SCHED_RR &&
 			policy != SCHED_NORMAL && policy != SCHED_BATCH &&
-			policy != SCHED_IDLEPRIO)
+			policy != SCHED_ISO && policy != SCHED_IDLE)
 		return -EINVAL;
 	/*
 	 * Valid priorities for SCHED_FIFO and SCHED_RR are
 	 * 1..MAX_USER_RT_PRIO-1, valid priority for SCHED_NORMAL,
-	 * SCHED_BATCH and SCHED_IDLEPRIO is 0.
+	 * SCHED_BATCH, SCHED_ISO and SCHED_IDLE is 0.
 	 */
 	if (param->sched_priority < 0 ||
 	    (p->mm && param->sched_priority > MAX_USER_RT_PRIO-1) ||
@@ -3856,6 +4025,12 @@ recheck:
 			    param->sched_priority > rlim_rtprio)
 				return -EPERM;
 		}
+		/*
+		 * Like positive nice levels, dont allow tasks to
+		 * move out of SCHED_IDLE either:
+		 */
+		if (p->policy == SCHED_IDLE && policy != SCHED_IDLE)
+			return -EPERM;
 
 		/* can't change other user's priorities */
 		if ((current->euid != p->euid) &&
@@ -3883,7 +4058,7 @@ recheck:
 		spin_unlock_irqrestore(&p->pi_lock, flags);
 		goto recheck;
 	}
-	on_rq = p->on_rq;
+	on_rq = p->se.on_rq;
 	if (on_rq)
 		deactivate_task(rq, p, 0);
 	oldprio = p->prio;
@@ -4180,10 +4355,10 @@ asmlinkage long sys_sched_yield(void)
 	struct rq *rq = this_rq_lock();
 
 	schedstat_inc(rq, yld_cnt);
-	if (rq->nr_running == 1)
+	if (unlikely(rq->nr_running == 1))
 		schedstat_inc(rq, yld_act_empty);
 	else
-		current->sched_class->yield_task(rq, current, NULL);
+		current->sched_class->yield_task(rq, current);
 
 	/*
 	 * Since we are going to call schedule() anyway, there's
@@ -4199,51 +4374,6 @@ asmlinkage long sys_sched_yield(void)
 	return 0;
 }
 
-/**
- * sys_sched_yield_to - yield the current processor to another thread
- *
- * This function yields the current CPU by moving the calling thread
- * to the expired array. If there are no other threads running on this
- * CPU then this function will return.
- */
-asmlinkage long sys_sched_yield_to(pid_t pid)
-{
-	struct task_struct *p_to;
-	struct rq *rq;
-
-	rcu_read_lock();
-	p_to = find_task_by_pid(pid);
-	if (!p_to)
-		goto out_unlock;
-
-	rq = this_rq_lock();
-
-	schedstat_inc(rq, yld_cnt);
-	if (rq->nr_running == 1)
-		schedstat_inc(rq, yld_act_empty);
-	else
-		current->sched_class->yield_task(rq, current, p_to);
-
-	/*
-	 * Since we are going to call schedule() anyway, there's
-	 * no need to preempt or enable interrupts:
-	 */
-	__release(rq->lock);
-	spin_release(&rq->lock.dep_map, 1, _THIS_IP_);
-	_raw_spin_unlock(&rq->lock);
-	rcu_read_unlock();
-	preempt_enable_no_resched();
-
-	schedule();
-
-	return 0;
-
-out_unlock:
-	rcu_read_unlock();
-	return -ESRCH;
-}
-
-
 static void __cond_resched(void)
 {
 #ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
@@ -4379,7 +4509,8 @@ asmlinkage long sys_sched_get_priority_m
 		break;
 	case SCHED_NORMAL:
 	case SCHED_BATCH:
-	case SCHED_IDLEPRIO:
+	case SCHED_ISO:
+	case SCHED_IDLE:
 		ret = 0;
 		break;
 	}
@@ -4404,7 +4535,8 @@ asmlinkage long sys_sched_get_priority_m
 		break;
 	case SCHED_NORMAL:
 	case SCHED_BATCH:
-	case SCHED_IDLEPRIO:
+	case SCHED_ISO:
+	case SCHED_IDLE:
 		ret = 0;
 	}
 	return ret;
@@ -4523,6 +4655,11 @@ void show_state_filter(unsigned long sta
 	sysrq_sched_debug_show();
 }
 
+void __cpuinit init_idle_bootup_task(struct task_struct *idle)
+{
+	idle->sched_class = &idle_sched_class;
+}
+
 /**
  * init_idle - set up an idle thread for a given CPU
  * @idle: task in question
@@ -4537,7 +4674,7 @@ void __cpuinit init_idle(struct task_str
 	unsigned long flags;
 
 	__sched_fork(idle);
-	idle->exec_start = sched_clock();
+	idle->se.exec_start = sched_clock();
 
 	idle->prio = idle->normal_prio = MAX_PRIO;
 	idle->cpus_allowed = cpumask_of_cpu(cpu);
@@ -4556,6 +4693,10 @@ void __cpuinit init_idle(struct task_str
 #else
 	task_thread_info(idle)->preempt_count = 0;
 #endif
+	/*
+	 * The idle tasks have their own, simple scheduling class:
+	 */
+	idle->sched_class = &idle_sched_class;
 }
 
 /*
@@ -4582,12 +4723,10 @@ static inline void sched_init_granularit
 	const unsigned long gran_limit = 10000000;
 
 	sysctl_sched_granularity *= factor;
-	sysctl_sched_runtime_limit *= factor;
-
 	if (sysctl_sched_granularity > gran_limit)
 		sysctl_sched_granularity = gran_limit;
 
-	sysctl_sched_runtime_limit = sysctl_sched_granularity * 2;
+	sysctl_sched_runtime_limit = sysctl_sched_granularity * 4;
 }
 
 #ifdef CONFIG_SMP
@@ -4663,7 +4802,7 @@ EXPORT_SYMBOL_GPL(set_cpus_allowed);
 static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
 {
 	struct rq *rq_dest, *rq_src;
-	int ret = 0;
+	int ret = 0, on_rq;
 
 	if (unlikely(cpu_is_offline(dest_cpu)))
 		return ret;
@@ -4679,9 +4818,11 @@ static int __migrate_task(struct task_st
 	if (!cpu_isset(dest_cpu, p->cpus_allowed))
 		goto out;
 
-	set_task_cpu(p, dest_cpu);
-	if (p->on_rq) {
+	on_rq = p->se.on_rq;
+	if (on_rq)
 		deactivate_task(rq_src, p, 0);
+	set_task_cpu(p, dest_cpu);
+	if (on_rq) {
 		activate_task(rq_dest, p, 0);
 		check_preempt_curr(rq_dest, p);
 	}
@@ -4833,7 +4974,8 @@ static void migrate_live_tasks(int src_c
 	write_unlock_irq(&tasklist_lock);
 }
 
-/* Schedules idle task to be the next runnable task on current CPU.
+/*
+ * Schedules idle task to be the next runnable task on current CPU.
  * It does so by boosting its priority to highest possible and adding it to
  * the _front_ of the runqueue. Used by CPU offline code.
  */
@@ -4911,7 +5053,7 @@ static void migrate_dead_tasks(unsigned 
 	for (;;) {
 		if (!rq->nr_running)
 			break;
-		next = pick_next_task(rq, rq->curr);
+		next = pick_next_task(rq, rq->curr, rq_clock(rq));
 		if (!next)
 			break;
 		migrate_dead(dead_cpu, next);
@@ -6018,12 +6160,12 @@ void __init sched_init(void)
 	int highest_cpu = 0;
 	int i, j;
 
-	current->sched_class = &fair_sched_class;
 	/*
 	 * Link up the scheduling class hierarchy:
 	 */
 	rt_sched_class.next = &fair_sched_class;
-	fair_sched_class.next = NULL;
+	fair_sched_class.next = &idle_sched_class;
+	idle_sched_class.next = NULL;
 
 	for_each_possible_cpu(i) {
 		struct prio_array *array;
@@ -6033,14 +6175,17 @@ void __init sched_init(void)
 		spin_lock_init(&rq->lock);
 		lockdep_set_class(&rq->lock, &rq->rq_lock_key);
 		rq->nr_running = 0;
-		rq->tasks_timeline = RB_ROOT;
-		rq->clock = rq->fair_clock = 1;
+		rq->cfs.tasks_timeline = RB_ROOT;
+		rq->clock = rq->cfs.fair_clock = 1;
+		rq->ls.load_update_last = sched_clock();
+		rq->ls.load_update_start = sched_clock();
 
 		for (j = 0; j < CPU_LOAD_IDX_MAX; j++)
 			rq->cpu_load[j] = 0;
 #ifdef CONFIG_SMP
 		rq->sd = NULL;
 		rq->active_balance = 0;
+		rq->next_balance = jiffies;
 		rq->push_cpu = 0;
 		rq->cpu = i;
 		rq->migration_thread = NULL;
@@ -6048,7 +6193,7 @@ void __init sched_init(void)
 #endif
 		atomic_set(&rq->nr_iowait, 0);
 
-		array = &rq->active;
+		array = &rq->rt.active;
 		for (j = 0; j < MAX_RT_PRIO; j++) {
 			INIT_LIST_HEAD(array->queue + j);
 			__clear_bit(j, array->bitmap);
@@ -6082,6 +6227,10 @@ void __init sched_init(void)
 	 * when this runqueue becomes "idle".
 	 */
 	init_idle(current, smp_processor_id());
+	/*
+	 * During early bootup we pretend to be a normal task:
+	 */
+	current->sched_class = &fair_sched_class;
 }
 
 #ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
@@ -6115,22 +6264,22 @@ EXPORT_SYMBOL(__might_sleep);
 #ifdef CONFIG_MAGIC_SYSRQ
 void normalize_rt_tasks(void)
 {
-	struct task_struct *p;
+	struct task_struct *g, *p;
 	unsigned long flags;
 	struct rq *rq;
 	int on_rq;
 
 	read_lock_irq(&tasklist_lock);
-	for_each_process(p) {
-		p->fair_key = 0;
-		p->wait_runtime = 0;
-		p->wait_start_fair = 0;
-		p->wait_start = 0;
-		p->exec_start = 0;
-		p->sleep_start = 0;
-		p->sleep_start_fair = 0;
-		p->block_start = 0;
-		task_rq(p)->fair_clock = 0;
+	do_each_thread(g, p) {
+		p->se.fair_key = 0;
+		p->se.wait_runtime = 0;
+		p->se.wait_start_fair = 0;
+		p->se.wait_start = 0;
+		p->se.exec_start = 0;
+		p->se.sleep_start = 0;
+		p->se.sleep_start_fair = 0;
+		p->se.block_start = 0;
+		task_rq(p)->cfs.fair_clock = 0;
 		task_rq(p)->clock = 0;
 
 		if (!rt_task(p)) {
@@ -6153,7 +6302,7 @@ void normalize_rt_tasks(void)
 			goto out_unlock;
 #endif
 
-		on_rq = p->on_rq;
+		on_rq = p->se.on_rq;
 		if (on_rq)
 			deactivate_task(task_rq(p), p, 0);
 		__setscheduler(rq, p, SCHED_NORMAL, 0);
@@ -6166,7 +6315,7 @@ void normalize_rt_tasks(void)
 #endif
 		__task_rq_unlock(rq);
 		spin_unlock_irqrestore(&p->pi_lock, flags);
-	}
+	} while_each_thread(g, p);
 
 	read_unlock_irq(&tasklist_lock);
 }
diff -puN kernel/sched_debug.c~sched-cfs-v2.6.22-git-v18 kernel/sched_debug.c
--- a/kernel/sched_debug.c~sched-cfs-v2.6.22-git-v18
+++ a/kernel/sched_debug.c
@@ -14,6 +14,7 @@
 #include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <linux/kallsyms.h>
+#include <linux/utsname.h>
 
 typedef void (*print_fn_t)(struct seq_file *m, unsigned int *classes);
 
@@ -40,19 +41,19 @@ print_task(struct seq_file *m, struct rq
 	SEQ_printf(m, "%15s %5d %15Ld %13Ld %13Ld %9Ld %5d "
 		      "%15Ld %15Ld %15Ld %15Ld %15Ld\n",
 		p->comm, p->pid,
-		(long long)p->fair_key,
-		(long long)(p->fair_key - rq->fair_clock),
-		(long long)p->wait_runtime,
-		(long long)p->nr_switches,
+		(long long)p->se.fair_key,
+		(long long)(p->se.fair_key - rq->cfs.fair_clock),
+		(long long)p->se.wait_runtime,
+		(long long)(p->nvcsw + p->nivcsw),
 		p->prio,
-		(long long)p->sum_exec_runtime,
-		(long long)p->sum_wait_runtime,
-		(long long)p->sum_sleep_runtime,
-		(long long)p->wait_runtime_overruns,
-		(long long)p->wait_runtime_underruns);
+		(long long)p->se.sum_exec_runtime,
+		(long long)p->se.sum_wait_runtime,
+		(long long)p->se.sum_sleep_runtime,
+		(long long)p->se.wait_runtime_overruns,
+		(long long)p->se.wait_runtime_underruns);
 }
 
-static void print_rq(struct seq_file *m, struct rq *rq, u64 now)
+static void print_rq(struct seq_file *m, struct rq *rq, int rq_cpu, u64 now)
 {
 	struct task_struct *g, *p;
 
@@ -70,7 +71,7 @@ static void print_rq(struct seq_file *m,
 	read_lock_irq(&tasklist_lock);
 
 	do_each_thread(g, p) {
-		if (!p->on_rq)
+		if (!p->se.on_rq || task_cpu(p) != rq_cpu)
 			continue;
 
 		print_task(m, rq, p, now);
@@ -87,16 +88,16 @@ static void print_rq_runtime_sum(struct 
 	unsigned long flags;
 
 	spin_lock_irqsave(&rq->lock, flags);
-	curr = first_fair(rq);
+	curr = first_fair(&rq->cfs);
 	while (curr) {
-		p = rb_entry(curr, struct task_struct, run_node);
-		wait_runtime_rq_sum += p->wait_runtime;
+		p = rb_entry(curr, struct task_struct, se.run_node);
+		wait_runtime_rq_sum += p->se.wait_runtime;
 
 		curr = rb_next(curr);
 	}
 	spin_unlock_irqrestore(&rq->lock, flags);
 
-	SEQ_printf(m, "  .%-22s: %Ld\n", "wait_runtime_rq_sum",
+	SEQ_printf(m, "  .%-30s: %Ld\n", "wait_runtime_rq_sum",
 		(long long)wait_runtime_rq_sum);
 }
 
@@ -104,16 +105,29 @@ static void print_cpu(struct seq_file *m
 {
 	struct rq *rq = &per_cpu(runqueues, cpu);
 
-	SEQ_printf(m, "\ncpu: %d\n", cpu);
+#ifdef CONFIG_X86
+	{
+		unsigned int freq = cpu_khz ? : 1;
+
+		SEQ_printf(m, "\ncpu#%d, %u.%03u MHz\n",
+			   cpu, freq / 1000, (freq % 1000));
+	}
+#else
+	SEQ_printf(m, "\ncpu#%d\n", cpu);
+#endif
+
 #define P(x) \
-	SEQ_printf(m, "  .%-22s: %Ld\n", #x, (long long)(rq->x))
+	SEQ_printf(m, "  .%-30s: %Ld\n", #x, (long long)(rq->x))
 
 	P(nr_running);
-	P(raw_weighted_load);
+	SEQ_printf(m, "  .%-30s: %lu\n", "load",
+		   rq->ls.load.weight);
+	P(ls.delta_fair);
+	P(ls.delta_exec);
 	P(nr_switches);
 	P(nr_load_updates);
 	P(nr_uninterruptible);
-	SEQ_printf(m, "  .%-22s: %lu\n", "jiffies", jiffies);
+	SEQ_printf(m, "  .%-30s: %lu\n", "jiffies", jiffies);
 	P(next_balance);
 	P(curr->pid);
 	P(clock);
@@ -122,13 +136,11 @@ static void print_cpu(struct seq_file *m
 	P(clock_overflows);
 	P(clock_unstable_events);
 	P(clock_max_delta);
-	P(fair_clock);
-	P(delta_fair_clock);
-	P(exec_clock);
-	P(delta_exec_clock);
-	P(wait_runtime);
-	P(wait_runtime_overruns);
-	P(wait_runtime_underruns);
+	P(cfs.fair_clock);
+	P(cfs.exec_clock);
+	P(cfs.wait_runtime);
+	P(cfs.wait_runtime_overruns);
+	P(cfs.wait_runtime_underruns);
 	P(cpu_load[0]);
 	P(cpu_load[1]);
 	P(cpu_load[2]);
@@ -137,7 +149,7 @@ static void print_cpu(struct seq_file *m
 #undef P
 	print_rq_runtime_sum(m, rq);
 
-	print_rq(m, rq, now);
+	print_rq(m, rq, cpu, now);
 }
 
 static int sched_debug_show(struct seq_file *m, void *v)
@@ -145,7 +157,11 @@ static int sched_debug_show(struct seq_f
 	u64 now = ktime_to_ns(ktime_get());
 	int cpu;
 
-	SEQ_printf(m, "Sched Debug Version: v0.02\n");
+	SEQ_printf(m, "Sched Debug Version: v0.03, cfs-v18, %s %.*s\n",
+		init_utsname()->release,
+		(int)strcspn(init_utsname()->version, " "),
+		init_utsname()->version);
+
 	SEQ_printf(m, "now at %Lu nsecs\n", (unsigned long long)now);
 
 	for_each_online_cpu(cpu)
@@ -205,21 +221,24 @@ void proc_sched_show_task(struct task_st
 #define P(F) \
 	SEQ_printf(m, "%-25s:%20Ld\n", #F, (long long)p->F)
 
-	P(wait_start);
-	P(wait_start_fair);
-	P(exec_start);
-	P(sleep_start);
-	P(sleep_start_fair);
-	P(block_start);
-	P(sleep_max);
-	P(block_max);
-	P(exec_max);
-	P(wait_max);
-	P(wait_runtime);
-	P(wait_runtime_overruns);
-	P(wait_runtime_underruns);
-	P(sum_exec_runtime);
-	P(load_weight);
+	P(se.wait_start);
+	P(se.wait_start_fair);
+	P(se.exec_start);
+	P(se.sleep_start);
+	P(se.sleep_start_fair);
+	P(se.block_start);
+	P(se.sleep_max);
+	P(se.block_max);
+	P(se.exec_max);
+	P(se.wait_max);
+	P(se.wait_runtime);
+	P(se.wait_runtime_overruns);
+	P(se.wait_runtime_underruns);
+	P(se.sum_wait_runtime);
+	P(se.sum_exec_runtime);
+	SEQ_printf(m, "%-25s:%20Ld\n",
+		   "nr_switches", (long long)(p->nvcsw + p->nivcsw));
+	P(se.load.weight);
 	P(policy);
 	P(prio);
 #undef P
@@ -235,7 +254,7 @@ void proc_sched_show_task(struct task_st
 
 void proc_sched_set_task(struct task_struct *p)
 {
-	p->sleep_max = p->block_max = p->exec_max = p->wait_max = 0;
-	p->wait_runtime_overruns = p->wait_runtime_underruns = 0;
-	p->sum_exec_runtime = 0;
+	p->se.sleep_max = p->se.block_max = p->se.exec_max = p->se.wait_max = 0;
+	p->se.wait_runtime_overruns = p->se.wait_runtime_underruns = 0;
+	p->se.sum_exec_runtime = 0;
 }
diff -puN kernel/sched_fair.c~sched-cfs-v2.6.22-git-v18 kernel/sched_fair.c
--- a/kernel/sched_fair.c~sched-cfs-v2.6.22-git-v18
+++ a/kernel/sched_fair.c
@@ -3,8 +3,18 @@
  *
  *  Copyright (C) 2007 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
  *
- *  Cleanups and fixes by Dmitry Adamushko.
+ *  Interactivity improvements by Mike Galbraith
+ *  (C) 2007 Mike Galbraith <efault@gmx.de>
+ *
+ *  Various enhancements by Dmitry Adamushko.
  *  (C) 2007 Dmitry Adamushko <dmitry.adamushko@gmail.com>
+ *
+ *  Group scheduling enhancements by Srivatsa Vaddagiri
+ *  Copyright IBM Corporation, 2007
+ *  Author: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
+ *
+ *  Scaled math optimizations by Thomas Gleixner
+ *  Copyright (C) 2007, Thomas Gleixner <tglx@linutronix.de>
  */
 
 /*
@@ -25,36 +35,78 @@ unsigned int sysctl_sched_granularity __
 
 /*
  * SCHED_BATCH wake-up granularity.
- * (default: 1 msec, units: nanoseconds)
+ * (default: 10 msec, units: nanoseconds)
  *
  * This option delays the preemption effects of decoupled workloads
  * and reduces their over-scheduling. Synchronous workloads will still
  * have immediate wakeup/sleep latencies.
  */
 unsigned int sysctl_sched_batch_wakeup_granularity __read_mostly =
-							1000000000ULL/HZ;
+							10000000000ULL/HZ;
+
+/*
+ * SCHED_OTHER wake-up granularity.
+ * (default: 1 msec, units: nanoseconds)
+ *
+ * This option delays the preemption effects of decoupled workloads
+ * and reduces their over-scheduling. Synchronous workloads will still
+ * have immediate wakeup/sleep latencies.
+ */
+unsigned int sysctl_sched_wakeup_granularity __read_mostly = 1000000000ULL/HZ;
+
+unsigned int sysctl_sched_stat_granularity __read_mostly;
+
 /*
  * Initialized in sched_init_granularity():
  */
 unsigned int sysctl_sched_runtime_limit __read_mostly;
 
-unsigned int sysctl_sched_features __read_mostly = 1 | 2 | 4 | 8 | 0 | 0;
+unsigned int sysctl_sched_features __read_mostly =
+			0 | 2 | 4 | 8 | 0 | 0 | 0 | 0;
 
 extern struct sched_class fair_sched_class;
 
-/**************************************************************/
-/* Scheduling class tree data structure manipulation methods:
+/**************************************************************
+ * CFS operations on generic schedulable entities:
+ */
+
+static inline struct rq *rq_of(struct cfs_rq *cfs_rq)
+{
+	return container_of(cfs_rq, struct rq, cfs);
+}
+
+static inline struct sched_entity *cfs_rq_curr(struct cfs_rq *cfs_rq)
+{
+	struct rq *rq = rq_of(cfs_rq);
+
+	if (unlikely(rq->curr->sched_class != &fair_sched_class))
+		return NULL;
+
+	return &rq->curr->se;
+}
+
+#define entity_is_task(se)	1
+
+static inline struct task_struct *task_of(struct sched_entity *se)
+{
+	return container_of(se, struct task_struct, se);
+}
+
+
+/**************************************************************
+ * Scheduling class tree data structure manipulation methods:
  */
 
 /*
- * Enqueue a task into the rb-tree:
+ * Enqueue an entity into the rb-tree:
  */
-static inline void __enqueue_task_fair(struct rq *rq, struct task_struct *p)
+static inline void
+__enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	struct rb_node **link = &rq->tasks_timeline.rb_node;
+	struct rb_node **link = &cfs_rq->tasks_timeline.rb_node;
 	struct rb_node *parent = NULL;
-	struct task_struct *entry;
-	s64 key = p->fair_key;
+	struct sched_entity *entry;
+	s64 key = se->fair_key;
 	int leftmost = 1;
 
 	/*
@@ -62,7 +114,7 @@ static inline void __enqueue_task_fair(s
 	 */
 	while (*link) {
 		parent = *link;
-		entry = rb_entry(parent, struct task_struct, run_node);
+		entry = rb_entry(parent, struct sched_entity, run_node);
 		/*
 		 * We dont care about collisions. Nodes with
 		 * the same key stay together.
@@ -80,57 +132,68 @@ static inline void __enqueue_task_fair(s
 	 * used):
 	 */
 	if (leftmost)
-		rq->rb_leftmost = &p->run_node;
+		cfs_rq->rb_leftmost = &se->run_node;
 
-	rb_link_node(&p->run_node, parent, link);
-	rb_insert_color(&p->run_node, &rq->tasks_timeline);
+	rb_link_node(&se->run_node, parent, link);
+	rb_insert_color(&se->run_node, &cfs_rq->tasks_timeline);
+	update_load_add(&cfs_rq->load, se->load.weight);
+	cfs_rq->nr_running++;
+	se->on_rq = 1;
 }
 
-static inline void __dequeue_task_fair(struct rq *rq, struct task_struct *p)
+static inline void
+__dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	if (rq->rb_leftmost == &p->run_node)
-		rq->rb_leftmost = NULL;
-	rb_erase(&p->run_node, &rq->tasks_timeline);
+	if (cfs_rq->rb_leftmost == &se->run_node)
+		cfs_rq->rb_leftmost = NULL;
+	rb_erase(&se->run_node, &cfs_rq->tasks_timeline);
+	update_load_sub(&cfs_rq->load, se->load.weight);
+	cfs_rq->nr_running--;
+	se->on_rq = 0;
 }
 
-static inline struct rb_node * first_fair(struct rq *rq)
+static inline struct rb_node * first_fair(struct cfs_rq *cfs_rq)
 {
-	if (rq->rb_leftmost)
-		return rq->rb_leftmost;
+	if (cfs_rq->rb_leftmost)
+		return cfs_rq->rb_leftmost;
 	/* Cache the value returned by rb_first() */
-	rq->rb_leftmost = rb_first(&rq->tasks_timeline);
-	return rq->rb_leftmost;
+	cfs_rq->rb_leftmost = rb_first(&cfs_rq->tasks_timeline);
+	return cfs_rq->rb_leftmost;
 }
 
-static struct task_struct * __pick_next_task_fair(struct rq *rq)
+static struct sched_entity * __pick_next_entity(struct cfs_rq *cfs_rq)
 {
-	return rb_entry(first_fair(rq), struct task_struct, run_node);
+	return rb_entry(first_fair(cfs_rq), struct sched_entity, run_node);
 }
 
-/**************************************************************/
-/* Scheduling class statistics methods:
+/**************************************************************
+ * Scheduling class statistics methods:
  */
 
 /*
  * We rescale the rescheduling granularity of tasks according to their
  * nice level, but only linearly, not exponentially:
  */
-static u64
-niced_granularity(struct task_struct *curr, unsigned long granularity)
+static s64
+niced_granularity(struct sched_entity *curr, unsigned long granularity)
 {
+	u64 tmp;
+
 	/*
 	 * Negative nice levels get the same granularity as nice-0:
 	 */
-	if (curr->load_weight >= NICE_0_LOAD)
+	if (curr->load.weight >= NICE_0_LOAD)
 		return granularity;
 	/*
 	 * Positive nice level tasks get linearly finer
 	 * granularity:
 	 */
-	return curr->load_weight * (s64)(granularity / NICE_0_LOAD);
+	tmp = curr->load.weight * (u64)granularity;
+	return (s64) (tmp >> NICE_0_SHIFT);
 }
 
-static void limit_wait_runtime(struct rq *rq, struct task_struct *p)
+static inline void
+limit_wait_runtime(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	s64 limit = sysctl_sched_runtime_limit;
 
@@ -138,94 +201,70 @@ static void limit_wait_runtime(struct rq
 	 * Niced tasks have the same history dynamic range as
 	 * non-niced tasks:
 	 */
-	if (p->wait_runtime > limit) {
-		p->wait_runtime = limit;
-		p->wait_runtime_overruns++;
-		rq->wait_runtime_overruns++;
-	}
-	if (p->wait_runtime < -limit) {
-		p->wait_runtime = -limit;
-		p->wait_runtime_underruns++;
-		rq->wait_runtime_underruns++;
+	if (unlikely(se->wait_runtime > limit)) {
+		se->wait_runtime = limit;
+		schedstat_inc(se, wait_runtime_overruns);
+		schedstat_inc(cfs_rq, wait_runtime_overruns);
+	}
+	if (unlikely(se->wait_runtime < -limit)) {
+		se->wait_runtime = -limit;
+		schedstat_inc(se, wait_runtime_underruns);
+		schedstat_inc(cfs_rq, wait_runtime_underruns);
 	}
 }
 
-static void __add_wait_runtime(struct rq *rq, struct task_struct *p, s64 delta)
+static inline void
+__add_wait_runtime(struct cfs_rq *cfs_rq, struct sched_entity *se, s64 delta)
 {
-	p->wait_runtime += delta;
-	p->sum_wait_runtime += delta;
-	limit_wait_runtime(rq, p);
+	se->wait_runtime += delta;
+	schedstat_add(se, sum_wait_runtime, delta);
+	limit_wait_runtime(cfs_rq, se);
 }
 
-static void add_wait_runtime(struct rq *rq, struct task_struct *p, s64 delta)
+static void
+add_wait_runtime(struct cfs_rq *cfs_rq, struct sched_entity *se, s64 delta)
 {
-	rq->wait_runtime -= p->wait_runtime;
-	__add_wait_runtime(rq, p, delta);
-	rq->wait_runtime += p->wait_runtime;
-}
-
-static s64 div64_s(s64 divident, unsigned long divisor)
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
+	schedstat_add(cfs_rq, wait_runtime, -se->wait_runtime);
+	__add_wait_runtime(cfs_rq, se, delta);
+	schedstat_add(cfs_rq, wait_runtime, se->wait_runtime);
 }
 
 /*
  * Update the current task's runtime statistics. Skip current tasks that
  * are not in our scheduling class.
  */
-static inline void update_curr(struct rq *rq, u64 now)
+static inline void
+__update_curr(struct cfs_rq *cfs_rq, struct sched_entity *curr, u64 now)
 {
-	unsigned long load = rq->raw_weighted_load;
+	struct load_weight *lw = &cfs_rq->load;
 	u64 delta_exec, delta_fair, delta_mine;
-	struct task_struct *curr = rq->curr;
+	struct rq *rq = rq_of(cfs_rq);
+	struct task_struct *curtask = rq->curr;
+	unsigned long load = lw->weight;
 
-	if (curr->sched_class != &fair_sched_class || curr == rq->idle || !load)
+	if (unlikely(!load))
 		return;
-	/*
-	 * Get the amount of time the current task was running
-	 * since the last time we changed raw_weighted_load:
-	 */
-	delta_exec = now - curr->exec_start;
-	if (unlikely((s64)delta_exec < 0))
-		delta_exec = 0;
+
+	delta_exec = curr->delta_exec;
 	if (unlikely(delta_exec > curr->exec_max))
 		curr->exec_max = delta_exec;
 
 	curr->sum_exec_runtime += delta_exec;
-	curr->exec_start = now;
-	rq->exec_clock += delta_exec;
+	cfs_rq->exec_clock += delta_exec;
 
-	delta_fair = delta_exec * NICE_0_LOAD;
-	delta_fair += load >> 1; /* rounding */
-	do_div(delta_fair, load);
-
-	/* Load-balancing accounting. */
-	rq->delta_fair_clock += delta_fair;
-	rq->delta_exec_clock += delta_exec;
+	delta_fair = calc_delta_fair(delta_exec, lw);
 
 	/*
 	 * Task already marked for preemption, do not burden
 	 * it with the cost of not having left the CPU yet:
 	 */
 	if (unlikely(sysctl_sched_features & 1))
-		if (unlikely(test_tsk_thread_flag(curr, TIF_NEED_RESCHED)))
+		if (unlikely(test_tsk_thread_flag(curtask, TIF_NEED_RESCHED)))
 			return;
 
-	delta_mine = delta_exec * curr->load_weight;
-	delta_mine += load >> 1; /* rounding */
-	do_div(delta_mine, load);
+	delta_mine = calc_delta_mine(delta_exec, curr->load.weight, lw);
 
-	rq->fair_clock += delta_fair;
+	cfs_rq->fair_clock += delta_fair;
 	/*
 	 * We executed delta_exec amount of time on the CPU,
 	 * but we were only entitled to delta_mine amount of
@@ -233,21 +272,53 @@ static inline void update_curr(struct rq
 	 * the two values are equal)
 	 * [Note: delta_mine - delta_exec is negative]:
 	 */
-	add_wait_runtime(rq, curr, delta_mine - delta_exec);
+	add_wait_runtime(cfs_rq, curr, delta_mine - delta_exec);
+}
+
+static void update_curr(struct cfs_rq *cfs_rq, u64 now)
+{
+	struct sched_entity *curr = cfs_rq_curr(cfs_rq);
+	unsigned long delta_exec;
+
+	if (unlikely(!curr))
+		return;
+
+	/*
+	 * Get the amount of time the current task was running
+	 * since the last time we changed load:
+	 */
+	delta_exec = now - curr->exec_start;
+
+	curr->delta_exec += delta_exec;
+
+	if (curr->delta_exec > sysctl_sched_stat_granularity) {
+		__update_curr(cfs_rq, curr, now);
+		curr->delta_exec = 0;
+	}
+	curr->exec_start = now;
 }
 
 static inline void
-update_stats_wait_start(struct rq *rq, struct task_struct *p, u64 now)
+update_stats_wait_start(struct cfs_rq *cfs_rq, struct sched_entity *se, u64 now)
 {
-	p->wait_start_fair = rq->fair_clock;
-	p->wait_start = now;
+	se->wait_start_fair = cfs_rq->fair_clock;
+	se->wait_start = now;
+}
+
+static inline s64 weight_s64(s64 calc, unsigned long weight, int shift)
+{
+	if (calc < 0) {
+		calc = - calc * weight;
+		return - (calc >> shift);
+	}
+	return (calc * weight) >> shift;
 }
 
 /*
  * Task is being enqueued - update stats:
  */
 static inline void
-update_stats_enqueue(struct rq *rq, struct task_struct *p, u64 now)
+update_stats_enqueue(struct cfs_rq *cfs_rq, struct sched_entity *se, u64 now)
 {
 	s64 key;
 
@@ -255,84 +326,101 @@ update_stats_enqueue(struct rq *rq, stru
 	 * Are we enqueueing a waiting task? (for current tasks
 	 * a dequeue/enqueue event is a NOP)
 	 */
-	if (p != rq->curr)
-		update_stats_wait_start(rq, p, now);
+	if (se != cfs_rq_curr(cfs_rq))
+		update_stats_wait_start(cfs_rq, se, now);
 	/*
 	 * Update the key:
 	 */
-	key = rq->fair_clock;
+	key = cfs_rq->fair_clock;
 
 	/*
 	 * Optimize the common nice 0 case:
 	 */
-	if (likely(p->load_weight == NICE_0_LOAD))
-		key -= p->wait_runtime;
-	else {
-		if (p->wait_runtime < 0)
-			key -= div64_s(p->wait_runtime * NICE_0_LOAD, p->load_weight);
-		else
-			key -= div64_s(p->wait_runtime * p->load_weight, NICE_0_LOAD);
+	if (likely(se->load.weight == NICE_0_LOAD)) {
+		key -= se->wait_runtime;
+	} else {
+		s64 tmp;
+
+		if (se->wait_runtime < 0) {
+			tmp = -se->wait_runtime;
+			key += (tmp * se->load.inv_weight) >>
+					(WMULT_SHIFT - NICE_0_SHIFT);
+		} else {
+			tmp = se->wait_runtime * se->load.weight;
+			key -= tmp >> NICE_0_SHIFT;
+		}
 	}
 
-	p->fair_key = key;
+	se->fair_key = key;
 }
 
 /*
  * Note: must be called with a freshly updated rq->fair_clock.
  */
 static inline void
-update_stats_wait_end(struct rq *rq, struct task_struct *p, u64 now)
+__update_stats_wait_end(struct cfs_rq *cfs_rq, struct sched_entity *se, u64 now)
 {
 	s64 delta_fair, delta_wait;
 
-	delta_wait = now - p->wait_start;
-	if (unlikely(delta_wait > p->wait_max))
-		p->wait_max = delta_wait;
+	delta_wait = now - se->wait_start;
+	if (unlikely(delta_wait > se->wait_max))
+		se->wait_max = delta_wait;
 
-	if (p->wait_start_fair) {
-		delta_fair = rq->fair_clock - p->wait_start_fair;
+	delta_fair = se->delta_fair;
 
-		if (unlikely(p->load_weight != NICE_0_LOAD))
-			delta_fair = div64_s(delta_fair * p->load_weight,
-								NICE_0_LOAD);
-		add_wait_runtime(rq, p, delta_fair);
+	if (unlikely(se->load.weight != NICE_0_LOAD))
+		delta_fair = weight_s64(delta_fair, se->load.weight,
+						NICE_0_SHIFT);
+
+	add_wait_runtime(cfs_rq, se, delta_fair);
+}
+
+static void
+update_stats_wait_end(struct cfs_rq *cfs_rq, struct sched_entity *se, u64 now)
+{
+	s64 delta_fair = cfs_rq->fair_clock - se->wait_start_fair;
+
+	se->delta_fair += delta_fair;
+	if (unlikely(se->delta_fair >= sysctl_sched_stat_granularity)) {
+		__update_stats_wait_end(cfs_rq, se, now);
+		se->delta_fair = 0;
 	}
 
-	p->wait_start_fair = 0;
-	p->wait_start = 0;
+	se->wait_start_fair = 0;
+	se->wait_start = 0;
 }
 
 static inline void
-update_stats_dequeue(struct rq *rq, struct task_struct *p, u64 now)
+update_stats_dequeue(struct cfs_rq *cfs_rq, struct sched_entity *se, u64 now)
 {
-	update_curr(rq, now);
+	update_curr(cfs_rq, now);
 	/*
 	 * Mark the end of the wait period if dequeueing a
 	 * waiting task:
 	 */
-	if (p != rq->curr)
-		update_stats_wait_end(rq, p, now);
+	if (se != cfs_rq_curr(cfs_rq))
+		update_stats_wait_end(cfs_rq, se, now);
 }
 
 /*
  * We are picking a new current task - update its stats:
  */
 static inline void
-update_stats_curr_start(struct rq *rq, struct task_struct *p, u64 now)
+update_stats_curr_start(struct cfs_rq *cfs_rq, struct sched_entity *se, u64 now)
 {
 	/*
 	 * We are starting a new run period:
 	 */
-	p->exec_start = now;
+	se->exec_start = now;
 }
 
 /*
  * We are descheduling a task - update its stats:
  */
 static inline void
-update_stats_curr_end(struct rq *rq, struct task_struct *p, u64 now)
+update_stats_curr_end(struct cfs_rq *cfs_rq, struct sched_entity *se, u64 now)
 {
-	p->exec_start = 0;
+	se->exec_start = 0;
 }
 
 /*
@@ -345,189 +433,302 @@ update_stats_curr_end(struct rq *rq, str
  * manner we move the fair clock back by a proportional
  * amount of the new wait_runtime this task adds to the pool.
  */
-static void distribute_fair_add(struct rq *rq, s64 delta)
+static void distribute_fair_add(struct cfs_rq *cfs_rq, s64 delta)
 {
-	struct task_struct *curr = rq->curr;
+	struct sched_entity *curr = cfs_rq_curr(cfs_rq);
 	s64 delta_fair = 0;
 
 	if (!(sysctl_sched_features & 2))
 		return;
 
-	if (rq->nr_running) {
-		delta_fair = div64_s(delta, rq->nr_running);
+	if (cfs_rq->nr_running) {
+		delta_fair = div64_s(delta, cfs_rq->nr_running);
 		/*
 		 * The currently running task's next wait_runtime value does
 		 * not depend on the fair_clock, so fix it up explicitly:
 		 */
-		 if (curr->sched_class == &fair_sched_class)
-			add_wait_runtime(rq, curr, -delta_fair);
+		 if (curr)
+			add_wait_runtime(cfs_rq, curr, -delta_fair);
 	}
-	rq->fair_clock -= delta_fair;
+	cfs_rq->fair_clock -= delta_fair;
 }
 
-/**************************************************************/
-/* Scheduling class queueing methods:
+/**************************************************
+ * Scheduling class queueing methods:
  */
 
-static void enqueue_sleeper(struct rq *rq, struct task_struct *p)
+static void
+__enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se, u64 now)
 {
-	unsigned long load = rq->raw_weighted_load;
+	unsigned long load = cfs_rq->load.weight;
 	s64 delta_fair, prev_runtime;
 
-	if (p->policy == SCHED_BATCH || !(sysctl_sched_features & 4))
-		goto out;
-
-	delta_fair = rq->fair_clock - p->sleep_start_fair;
+	delta_fair = cfs_rq->fair_clock - se->sleep_start_fair;
 
 	/*
 	 * Fix up delta_fair with the effect of us running
 	 * during the whole sleep period:
 	 */
 	if (!(sysctl_sched_features & 32))
-		delta_fair = div64_s(delta_fair * load, load + p->load_weight);
-	delta_fair = div64_s(delta_fair * p->load_weight, NICE_0_LOAD);
+		delta_fair = div64_s(delta_fair * load, load + se->load.weight);
+
+	delta_fair = weight_s64(delta_fair, se->load.weight, NICE_0_SHIFT);
 
-	prev_runtime = p->wait_runtime;
-	__add_wait_runtime(rq, p, delta_fair);
-	delta_fair = p->wait_runtime - prev_runtime;
+	prev_runtime = se->wait_runtime;
+	__add_wait_runtime(cfs_rq, se, delta_fair);
+	delta_fair = se->wait_runtime - prev_runtime;
 
 	/*
 	 * We move the fair clock back by a load-proportional
 	 * amount of the new wait_runtime this task adds to
 	 * the 'pool':
 	 */
-	distribute_fair_add(rq, delta_fair);
+	distribute_fair_add(cfs_rq, delta_fair);
 
-out:
-	rq->wait_runtime += p->wait_runtime;
-
-	p->sleep_start_fair = 0;
+	schedstat_add(cfs_rq, wait_runtime, se->wait_runtime);
 }
 
-/*
- * The enqueue_task method is called before nr_running is
- * increased. Here we update the fair scheduling stats and
- * then put the task into the rbtree:
- */
 static void
-enqueue_task_fair(struct rq *rq, struct task_struct *p, int wakeup, u64 now)
+enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se, u64 now)
 {
-	u64 delta = 0;
+	struct task_struct *tsk = task_of(se);
+	s64 delta_fair;
 
-	/*
-	 * Update the fair clock.
-	 */
-	update_curr(rq, now);
+	if ((entity_is_task(se) && tsk->policy == SCHED_BATCH) ||
+						 !(sysctl_sched_features & 4))
+		return;
 
-	if (wakeup) {
-		if (p->sleep_start) {
-			delta = now - p->sleep_start;
-			if ((s64)delta < 0)
-				delta = 0;
+	delta_fair = cfs_rq->fair_clock - se->sleep_start_fair;
+	se->delta_fair += delta_fair;
+	if (unlikely(se->delta_fair >= sysctl_sched_stat_granularity)) {
+		__enqueue_sleeper(cfs_rq, se, now);
+		se->delta_fair = 0;
+	}
 
-			if (unlikely(delta > p->sleep_max))
-				p->sleep_max = delta;
+	se->sleep_start_fair = 0;
 
-			p->sleep_start = 0;
-		}
-		if (p->block_start) {
-			delta = now - p->block_start;
-			if ((s64)delta < 0)
-				delta = 0;
+#ifdef CONFIG_SCHEDSTATS
+	if (se->sleep_start) {
+		u64 delta = now - se->sleep_start;
 
-			if (unlikely(delta > p->block_max))
-				p->block_max = delta;
+		if ((s64)delta < 0)
+			delta = 0;
 
-			p->block_start = 0;
-		}
-		p->sum_sleep_runtime += delta;
+		if (unlikely(delta > se->sleep_max))
+			se->sleep_max = delta;
 
-		if (p->sleep_start_fair)
-			enqueue_sleeper(rq, p);
+		se->sleep_start = 0;
+		se->sum_sleep_runtime += delta;
 	}
-	update_stats_enqueue(rq, p, now);
-	__enqueue_task_fair(rq, p);
+	if (se->block_start) {
+		u64 delta = now - se->block_start;
+
+		if ((s64)delta < 0)
+			delta = 0;
+
+		if (unlikely(delta > se->block_max))
+			se->block_max = delta;
+
+		se->block_start = 0;
+		se->sum_sleep_runtime += delta;
+	}
+#endif
 }
 
-/*
- * The dequeue_task method is called before nr_running is
- * decreased. We remove the task from the rbtree and
- * update the fair scheduling stats:
- */
-static void
-dequeue_task_fair(struct rq *rq, struct task_struct *p, int sleep, u64 now)
+static void enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
+							 int wakeup, u64 now)
+{
+	/*
+	 * Update the fair clock.
+	 */
+	update_curr(cfs_rq, now);
+
+	if (wakeup)
+		enqueue_sleeper(cfs_rq, se, now);
+
+	update_stats_enqueue(cfs_rq, se, now);
+	__enqueue_entity(cfs_rq, se);
+}
+
+static void dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
+							 int sleep, u64 now)
 {
-	update_stats_dequeue(rq, p, now);
+	update_stats_dequeue(cfs_rq, se, now);
 	if (sleep) {
-		if (p->state & TASK_INTERRUPTIBLE)
-			p->sleep_start = now;
-		if (p->state & TASK_UNINTERRUPTIBLE)
-			p->block_start = now;
-		p->sleep_start_fair = rq->fair_clock;
-		rq->wait_runtime -= p->wait_runtime;
+		se->sleep_start_fair = cfs_rq->fair_clock;
+#ifdef CONFIG_SCHEDSTATS
+		if (entity_is_task(se)) {
+			struct task_struct *tsk = task_of(se);
+
+			if (tsk->state & TASK_INTERRUPTIBLE)
+				se->sleep_start = now;
+			if (tsk->state & TASK_UNINTERRUPTIBLE)
+				se->block_start = now;
+		}
+		cfs_rq->wait_runtime -= se->wait_runtime;
+#endif
 	}
-	__dequeue_task_fair(rq, p);
+	__dequeue_entity(cfs_rq, se);
 }
 
 /*
- * sched_yield() support is very simple via the rbtree: we just
- * dequeue the task and move it after the next task, which
- * causes tasks to roundrobin.
+ * Preempt the current task with a newly woken task if needed:
  */
-static void
-yield_task_fair(struct rq *rq, struct task_struct *p, struct task_struct *p_to)
+static inline void
+__check_preempt_curr_fair(struct cfs_rq *cfs_rq, struct sched_entity *se,
+			  struct sched_entity *curr, unsigned long granularity)
 {
-	struct task_struct *p_next;
-	u64 now;
+	s64 __delta = curr->fair_key - se->fair_key;
 
-	now = __rq_clock(rq);
 	/*
-	 * Dequeue and enqueue the task to update its
-	 * position within the tree:
+	 * Take scheduling granularity into account - do not
+	 * preempt the current task unless the best task has
+	 * a larger than sched_granularity fairness advantage:
+	 */
+	if (__delta > niced_granularity(curr, granularity))
+		resched_task(rq_of(cfs_rq)->curr);
+}
+
+static struct sched_entity * pick_next_entity(struct cfs_rq *cfs_rq, u64 now)
+{
+	struct sched_entity *se = __pick_next_entity(cfs_rq);
+
+	/*
+	 * Any task has to be enqueued before it get to execute on
+	 * a CPU. So account for the time it spent waiting on the
+	 * runqueue. (note, here we rely on pick_next_task() having
+	 * done a put_prev_task_fair() shortly before this, which
+	 * updated rq->fair_clock - used by update_stats_wait_end())
 	 */
-	dequeue_task_fair(rq, p, 0, now);
-	p->on_rq = 0;
-	enqueue_task_fair(rq, p, 0, now);
-	p->on_rq = 1;
+	update_stats_wait_end(cfs_rq, se, now);
+	update_stats_curr_start(cfs_rq, se, now);
+
+	return se;
+}
+
+static void
+put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev, u64 now)
+{
+	int updated = 0;
 
 	/*
-	 * yield-to support: if we are on the same runqueue then
-	 * give half of our wait_runtime (if it's positive) to the other task:
+	 * If the task is still waiting for the CPU (it just got
+	 * preempted), update its position within the tree and
+	 * start the wait period:
 	 */
-	if (p_to && rq == task_rq(p_to) &&
-			p_to->sched_class == &fair_sched_class
-			&& p->wait_runtime > 0) {
+	if ((sysctl_sched_features & 16) && entity_is_task(prev))  {
+		struct task_struct *prevtask = task_of(prev);
 
-		s64 delta = p->wait_runtime >> 1;
+		if (prev->on_rq &&
+			test_tsk_thread_flag(prevtask, TIF_NEED_RESCHED)) {
 
-		__add_wait_runtime(rq, p_to, delta);
-		__add_wait_runtime(rq, p, -delta);
+			dequeue_entity(cfs_rq, prev, 0, now);
+			enqueue_entity(cfs_rq, prev, 0, now);
+			updated = 1;
+		}
 	}
 
 	/*
+	 * If still on the runqueue then deactivate_task()
+	 * was not called and update_curr() has to be done:
+	 */
+	if (prev->on_rq && !updated)
+		update_curr(cfs_rq, now);
+
+	update_stats_curr_end(cfs_rq, prev, now);
+
+	if (prev->on_rq)
+		update_stats_wait_start(cfs_rq, prev, now);
+}
+
+static void entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
+{
+	struct sched_entity *next;
+	struct rq *rq = rq_of(cfs_rq);
+	u64 now = __rq_clock(rq);
+
+	/*
+	 * Dequeue and enqueue the task to update its
+	 * position within the tree:
+	 */
+	dequeue_entity(cfs_rq, curr, 0, now);
+	enqueue_entity(cfs_rq, curr, 0, now);
+
+	/*
 	 * Reschedule if another task tops the current one.
 	 */
-	p_next = __pick_next_task_fair(rq);
-	if (p_next != p)
-		resched_task(p);
+	next = __pick_next_entity(cfs_rq);
+	if (next == curr)
+		return;
+
+	if (entity_is_task(curr)) {
+		struct task_struct *curtask = task_of(curr),
+				   *nexttask = task_of(next);
+
+		if ((rt_prio(nexttask->prio) &&
+				(nexttask->prio < curtask->prio))) {
+			resched_task(curtask);
+			return;
+		}
+	}
+	__check_preempt_curr_fair(cfs_rq, next, curr, sysctl_sched_granularity);
+}
+
+/**************************************************
+ * CFS operations on tasks:
+ */
+
+static inline struct cfs_rq *task_cfs_rq(struct task_struct *p)
+{
+	return &task_rq(p)->cfs;
 }
 
 /*
- * Preempt the current task with a newly woken task if needed:
+ * The enqueue_task method is called before nr_running is
+ * increased. Here we update the fair scheduling stats and
+ * then put the task into the rbtree:
  */
-static inline void
-__check_preempt_curr_fair(struct rq *rq, struct task_struct *p,
-			  struct task_struct *curr, unsigned long granularity)
+static void
+enqueue_task_fair(struct rq *rq, struct task_struct *p, int wakeup, u64 now)
 {
-	s64 __delta = curr->fair_key - p->fair_key;
+	struct cfs_rq *cfs_rq = task_cfs_rq(p);
+	struct sched_entity *se = &p->se;
 
-	/*
-	 * Take scheduling granularity into account - do not
-	 * preempt the current task unless the best task has
-	 * a larger than sched_granularity fairness advantage:
-	 */
-	if (__delta > niced_granularity(curr, granularity))
-		resched_task(curr);
+	enqueue_entity(cfs_rq, se, wakeup, now);
+}
+
+/*
+ * The dequeue_task method is called before nr_running is
+ * decreased. We remove the task from the rbtree and
+ * update the fair scheduling stats:
+ */
+static void
+dequeue_task_fair(struct rq *rq, struct task_struct *p, int sleep, u64 now)
+{
+	struct cfs_rq *cfs_rq = task_cfs_rq(p);
+	struct sched_entity *se = &p->se;
+
+	dequeue_entity(cfs_rq, se, sleep, now);
+}
+
+/*
+ * sched_yield() support is very simple via the rbtree: we just
+ * dequeue the task and move it after the next task, which
+ * causes tasks to roundrobin.
+ */
+static void yield_task_fair(struct rq *rq, struct task_struct *p)
+{
+	struct cfs_rq *cfs_rq = task_cfs_rq(p);
+	struct sched_entity *se = &p->se;
+	struct rb_node *first, *curr, *next;
+
+	curr = &se->run_node;
+	next = rb_next(curr);
+	first = rb_first(&cfs_rq->tasks_timeline);
+	if ((first == curr) && next)
+		cfs_rq->rb_leftmost = next;
+	else
+		cfs_rq->rb_leftmost = first;
 }
 
 /*
@@ -536,41 +737,39 @@ __check_preempt_curr_fair(struct rq *rq,
 static void check_preempt_curr_fair(struct rq *rq, struct task_struct *p)
 {
 	struct task_struct *curr = rq->curr;
-	unsigned long granularity;
+	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
+	unsigned long gran;
 
-	if ((curr == rq->idle) || rt_prio(p->prio)) {
+	if (unlikely(rt_prio(p->prio))) {
 		if (sysctl_sched_features & 8) {
 			if (rt_prio(p->prio))
-				update_curr(rq, rq_clock(rq));
+				update_curr(cfs_rq, rq_clock(rq));
 		}
 		resched_task(curr);
-	} else {
-		/*
-		 * Batch tasks prefer throughput over latency:
-		 */
-		granularity = 0;
-		if (unlikely(p->policy == SCHED_BATCH))
-			granularity = sysctl_sched_batch_wakeup_granularity;
-
-		__check_preempt_curr_fair(rq, p, curr, granularity);
+		return;
 	}
+
+	gran = sysctl_sched_wakeup_granularity;
+	/*
+	 * Batch tasks prefer throughput over latency:
+	 */
+	if (unlikely(p->policy == SCHED_BATCH))
+		gran = sysctl_sched_batch_wakeup_granularity;
+
+	__check_preempt_curr_fair(cfs_rq, &p->se, &curr->se, gran);
 }
 
 static struct task_struct * pick_next_task_fair(struct rq *rq, u64 now)
 {
-	struct task_struct *p = __pick_next_task_fair(rq);
+	struct cfs_rq *cfs_rq = &rq->cfs;
+	struct sched_entity *se;
 
-	/*
-	 * Any task has to be enqueued before it get to execute on
-	 * a CPU. So account for the time it spent waiting on the
-	 * runqueue. (note, here we rely on pick_next_task() having
-	 * done a put_prev_task_fair() shortly before this, which
-	 * updated rq->fair_clock - used by update_stats_wait_end())
-	 */
-	update_stats_wait_end(rq, p, now);
-	update_stats_curr_start(rq, p, now);
+	if (unlikely(!cfs_rq->nr_running))
+		return NULL;
 
-	return p;
+	se = pick_next_entity(cfs_rq, now);
+
+	return task_of(se);
 }
 
 /*
@@ -578,36 +777,11 @@ static struct task_struct * pick_next_ta
  */
 static void put_prev_task_fair(struct rq *rq, struct task_struct *prev, u64 now)
 {
-	if (prev == rq->idle)
-		return;
-
-	/*
-	 * If the task is still waiting for the CPU (it just got
-	 * preempted), update its position within the tree and
-	 * start the wait period:
-	 */
-	if (sysctl_sched_features & 16)  {
-		if (prev->on_rq &&
-			test_tsk_thread_flag(prev, TIF_NEED_RESCHED)) {
-
-			dequeue_task_fair(rq, prev, 0, now);
-			prev->on_rq = 0;
-			enqueue_task_fair(rq, prev, 0, now);
-			prev->on_rq = 1;
-		} else
-			update_curr(rq, now);
-	} else {
-		update_curr(rq, now);
-	}
-
-	update_stats_curr_end(rq, prev, now);
-
-	if (prev->on_rq)
-		update_stats_wait_start(rq, prev, now);
+	put_prev_entity(task_cfs_rq(prev), &prev->se, now);
 }
 
-/**************************************************************/
-/* Fair scheduling class load-balancing methods:
+/**************************************************
+ * Fair scheduling class load-balancing methods:
  */
 
 /*
@@ -625,20 +799,20 @@ __load_balance_iterator(struct rq *rq, s
 	if (!curr)
 		return NULL;
 
-	p = rb_entry(curr, struct task_struct, run_node);
-	rq->rb_load_balance_curr = rb_next(curr);
+	p = rb_entry(curr, struct task_struct, se.run_node);
+	rq->cfs.rb_load_balance_curr = rb_next(curr);
 
 	return p;
 }
 
 static struct task_struct * load_balance_start_fair(struct rq *rq)
 {
-	return __load_balance_iterator(rq, first_fair(rq));
+	return __load_balance_iterator(rq, first_fair(&rq->cfs));
 }
 
 static struct task_struct * load_balance_next_fair(struct rq *rq)
 {
-	return __load_balance_iterator(rq, rq->rb_load_balance_curr);
+	return __load_balance_iterator(rq, rq->cfs.rb_load_balance_curr);
 }
 
 /*
@@ -646,31 +820,7 @@ static struct task_struct * load_balance
  */
 static void task_tick_fair(struct rq *rq, struct task_struct *curr)
 {
-	struct task_struct *next;
-	u64 now = __rq_clock(rq);
-
-	/*
-	 * Dequeue and enqueue the task to update its
-	 * position within the tree:
-	 */
-	dequeue_task_fair(rq, curr, 0, now);
-	curr->on_rq = 0;
-	enqueue_task_fair(rq, curr, 0, now);
-	curr->on_rq = 1;
-
-	/*
-	 * Reschedule if another task tops the current one.
-	 */
-	next = __pick_next_task_fair(rq);
-	if (next == curr)
-		return;
-
-	if ((curr == rq->idle) || (rt_prio(next->prio) &&
-					(next->prio < curr->prio)))
-		resched_task(curr);
-	else
-		__check_preempt_curr_fair(rq, next, curr,
-					  sysctl_sched_granularity);
+	entity_tick(task_cfs_rq(curr), &curr->se);
 }
 
 /*
@@ -682,30 +832,36 @@ static void task_tick_fair(struct rq *rq
  */
 static void task_new_fair(struct rq *rq, struct task_struct *p)
 {
+	struct cfs_rq *cfs_rq = task_cfs_rq(p);
+	struct sched_entity *se = &p->se;
+	u64 now = rq_clock(rq);
+
 	sched_info_queued(p);
-	update_stats_enqueue(rq, p, rq_clock(rq));
+
+	update_stats_enqueue(cfs_rq, se, now);
 	/*
 	 * Child runs first: we let it run before the parent
 	 * until it reschedules once. We set up the key so that
 	 * it will preempt the parent:
 	 */
-	p->fair_key = current->fair_key - niced_granularity(rq->curr,
+	p->se.fair_key = current->se.fair_key - niced_granularity(&rq->curr->se,
 						sysctl_sched_granularity) - 1;
 	/*
 	 * The first wait is dominated by the child-runs-first logic,
 	 * so do not credit it with that waiting time yet:
 	 */
-	p->wait_start_fair = 0;
+	if (sysctl_sched_features & 256)
+		p->se.wait_start_fair = 0;
 
 	/*
 	 * The statistical average of wait_runtime is about
 	 * -granularity/2, so initialize the task with that:
 	 */
-//	p->wait_runtime = -(s64)(sysctl_sched_granularity / 2);
+	if (sysctl_sched_features & 128)
+		p->se.wait_runtime = -(s64)(sysctl_sched_granularity / 2);
 
-	__enqueue_task_fair(rq, p);
-	p->on_rq = 1;
-	inc_nr_running(p, rq);
+	__enqueue_entity(cfs_rq, se);
+	inc_nr_running(p, rq, now);
 }
 
 /*
diff -puN /dev/null kernel/sched_idletask.c
--- /dev/null
+++ a/kernel/sched_idletask.c
@@ -0,0 +1,68 @@
+/*
+ * idle-task scheduling class.
+ *
+ * (NOTE: these are not related to SCHED_IDLE tasks which are
+ *  handled in sched_fair.c)
+ */
+
+/*
+ * Idle tasks are unconditionally rescheduled:
+ */
+static void check_preempt_curr_idle(struct rq *rq, struct task_struct *p)
+{
+	resched_task(rq->idle);
+}
+
+static struct task_struct *pick_next_task_idle(struct rq *rq, u64 now)
+{
+	schedstat_inc(rq, sched_goidle);
+
+	return rq->idle;
+}
+
+/*
+ * It is not legal to sleep in the idle task - print a warning
+ * message if some code attempts to do it:
+ */
+static void
+dequeue_task_idle(struct rq *rq, struct task_struct *p, int sleep, u64 now)
+{
+	spin_unlock_irq(&rq->lock);
+	printk(KERN_ERR "bad: scheduling from the idle thread!\n");
+	dump_stack();
+	spin_lock_irq(&rq->lock);
+}
+
+static void put_prev_task_idle(struct rq *rq, struct task_struct *prev, u64 now)
+{
+}
+
+static struct task_struct *load_balance_start_idle(struct rq *rq)
+{
+	return NULL;
+}
+
+static void task_tick_idle(struct rq *rq, struct task_struct *curr)
+{
+}
+
+/*
+ * Simple, special scheduling class for the per-CPU idle tasks:
+ */
+struct sched_class idle_sched_class __read_mostly = {
+	/* no enqueue/yield_task for idle tasks */
+
+	/* dequeue is not valid, we print a debug message there: */
+	.dequeue_task		= dequeue_task_idle,
+
+	.check_preempt_curr	= check_preempt_curr_idle,
+
+	.pick_next_task		= pick_next_task_idle,
+	.put_prev_task		= put_prev_task_idle,
+
+	.load_balance_start	= load_balance_start_idle,
+	/* no .load_balance_next for idle tasks */
+
+	.task_tick		= task_tick_idle,
+	/* no .task_new for idle tasks */
+};
diff -puN kernel/sched_rt.c~sched-cfs-v2.6.22-git-v18 kernel/sched_rt.c
--- a/kernel/sched_rt.c~sched-cfs-v2.6.22-git-v18
+++ a/kernel/sched_rt.c
@@ -15,20 +15,20 @@ static inline void update_curr_rt(struct
 	if (!has_rt_policy(curr))
 		return;
 
-	delta_exec = now - curr->exec_start;
+	delta_exec = now - curr->se.exec_start;
 	if (unlikely((s64)delta_exec < 0))
 		delta_exec = 0;
-	if (unlikely(delta_exec > curr->exec_max))
-		curr->exec_max = delta_exec;
+	if (unlikely(delta_exec > curr->se.exec_max))
+		curr->se.exec_max = delta_exec;
 
-	curr->sum_exec_runtime += delta_exec;
-	curr->exec_start = now;
+	curr->se.sum_exec_runtime += delta_exec;
+	curr->se.exec_start = now;
 }
 
 static void
 enqueue_task_rt(struct rq *rq, struct task_struct *p, int wakeup, u64 now)
 {
-	struct prio_array *array = &rq->active;
+	struct prio_array *array = &rq->rt.active;
 
 	list_add_tail(&p->run_list, array->queue + p->prio);
 	__set_bit(p->prio, array->bitmap);
@@ -40,7 +40,7 @@ enqueue_task_rt(struct rq *rq, struct ta
 static void
 dequeue_task_rt(struct rq *rq, struct task_struct *p, int sleep, u64 now)
 {
-	struct prio_array *array = &rq->active;
+	struct prio_array *array = &rq->rt.active;
 
 	update_curr_rt(rq, now);
 
@@ -55,13 +55,13 @@ dequeue_task_rt(struct rq *rq, struct ta
  */
 static void requeue_task_rt(struct rq *rq, struct task_struct *p)
 {
-	struct prio_array *array = &rq->active;
+	struct prio_array *array = &rq->rt.active;
 
 	list_move_tail(&p->run_list, array->queue + p->prio);
 }
 
 static void
-yield_task_rt(struct rq *rq, struct task_struct *p, struct task_struct *p_to)
+yield_task_rt(struct rq *rq, struct task_struct *p)
 {
 	requeue_task_rt(rq, p);
 }
@@ -77,7 +77,7 @@ static void check_preempt_curr_rt(struct
 
 static struct task_struct * pick_next_task_rt(struct rq *rq, u64 now)
 {
-	struct prio_array *array = &rq->active;
+	struct prio_array *array = &rq->rt.active;
 	struct task_struct *next;
 	struct list_head *queue;
 	int idx;
@@ -89,7 +89,7 @@ static struct task_struct * pick_next_ta
 	queue = array->queue + idx;
 	next = list_entry(queue->next, struct task_struct, run_list);
 
-	next->exec_start = now;
+	next->se.exec_start = now;
 
 	return next;
 }
@@ -97,7 +97,7 @@ static struct task_struct * pick_next_ta
 static void put_prev_task_rt(struct rq *rq, struct task_struct *p, u64 now)
 {
 	update_curr_rt(rq, now);
-	p->exec_start = 0;
+	p->se.exec_start = 0;
 }
 
 /*
@@ -109,7 +109,7 @@ static void put_prev_task_rt(struct rq *
  */
 static struct task_struct * load_balance_start_rt(struct rq *rq)
 {
-	struct prio_array *array = &rq->active;
+	struct prio_array *array = &rq->rt.active;
 	struct list_head *head, *curr;
 	struct task_struct *p;
 	int idx;
@@ -125,23 +125,23 @@ static struct task_struct * load_balance
 
 	curr = curr->prev;
 
-	rq->rt_load_balance_idx = idx;
-	rq->rt_load_balance_head = head;
-	rq->rt_load_balance_curr = curr;
+	rq->rt.rt_load_balance_idx = idx;
+	rq->rt.rt_load_balance_head = head;
+	rq->rt.rt_load_balance_curr = curr;
 
 	return p;
 }
 
 static struct task_struct * load_balance_next_rt(struct rq *rq)
 {
-	struct prio_array *array = &rq->active;
+	struct prio_array *array = &rq->rt.active;
 	struct list_head *head, *curr;
 	struct task_struct *p;
 	int idx;
 
-	idx = rq->rt_load_balance_idx;
-	head = rq->rt_load_balance_head;
-	curr = rq->rt_load_balance_curr;
+	idx = rq->rt.rt_load_balance_idx;
+	head = rq->rt.rt_load_balance_head;
+	curr = rq->rt.rt_load_balance_curr;
 
 	/*
 	 * If we arrived back to the head again then
@@ -157,15 +157,15 @@ static struct task_struct * load_balance
 		head = array->queue + idx;
 		curr = head->prev;
 
-		rq->rt_load_balance_idx = idx;
-		rq->rt_load_balance_head = head;
+		rq->rt.rt_load_balance_idx = idx;
+		rq->rt.rt_load_balance_head = head;
 	}
 
 	p = list_entry(curr, struct task_struct, run_list);
 
 	curr = curr->prev;
 
-	rq->rt_load_balance_curr = curr;
+	rq->rt.rt_load_balance_curr = curr;
 
 	return p;
 }
@@ -176,7 +176,10 @@ static void task_tick_rt(struct rq *rq, 
 	 * RR tasks need a special form of timeslice management.
 	 * FIFO tasks have no timeslices.
 	 */
-	if ((p->policy == SCHED_RR) && !--p->time_slice) {
+	if (p->policy != SCHED_RR)
+		return;
+
+	if (!(--p->time_slice)) {
 		p->time_slice = static_prio_timeslice(p->static_prio);
 		set_tsk_need_resched(p);
 
diff -puN kernel/sched_stats.h~sched-cfs-v2.6.22-git-v18 kernel/sched_stats.h
--- a/kernel/sched_stats.h~sched-cfs-v2.6.22-git-v18
+++ a/kernel/sched_stats.h
@@ -35,12 +35,12 @@ static int show_schedstat(struct seq_fil
 		/* domain-specific stats */
 		preempt_disable();
 		for_each_domain(cpu, sd) {
-			enum idle_type itype;
+			enum cpu_idle_type itype;
 			char mask_str[NR_CPUS];
 
 			cpumask_scnprintf(mask_str, NR_CPUS, sd->span);
 			seq_printf(seq, "domain%d %s", dcnt++, mask_str);
-			for (itype = SCHED_IDLE; itype < MAX_IDLE_TYPES;
+			for (itype = CPU_IDLE; itype < CPU_MAX_IDLE_TYPES;
 					itype++) {
 				seq_printf(seq, " %lu %lu %lu %lu %lu %lu %lu "
 						"%lu",
diff -puN kernel/softirq.c~sched-cfs-v2.6.22-git-v18 kernel/softirq.c
--- a/kernel/softirq.c~sched-cfs-v2.6.22-git-v18
+++ a/kernel/softirq.c
@@ -489,8 +489,6 @@ void __init softirq_init(void)
 
 static int ksoftirqd(void * __bind_cpu)
 {
-	set_user_nice(current, 19);
-
 	set_current_state(TASK_INTERRUPTIBLE);
 
 	while (!kthread_should_stop()) {
diff -puN kernel/sysctl.c~sched-cfs-v2.6.22-git-v18 kernel/sysctl.c
--- a/kernel/sysctl.c~sched-cfs-v2.6.22-git-v18
+++ a/kernel/sysctl.c
@@ -210,8 +210,10 @@ static ctl_table root_table[] = {
 	{ .ctl_name = 0 }
 };
 
-static unsigned long min_sched_granularity_ns = 100000; /* 100 usecs */
-static unsigned long max_sched_granularity_ns = 1000000000; /* 1 second */
+static unsigned long min_sched_granularity_ns = 100000;		/* 100 usecs */
+static unsigned long max_sched_granularity_ns = 1000000000;	/* 1 second */
+static unsigned long min_wakeup_granularity_ns;			/* 0 usecs */
+static unsigned long max_wakeup_granularity_ns = 1000000000;	/* 1 second */
 
 static ctl_table kern_table[] = {
 	{
@@ -227,14 +229,36 @@ static ctl_table kern_table[] = {
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_wakeup_granularity_ns",
+		.data		= &sysctl_sched_wakeup_granularity,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &min_wakeup_granularity_ns,
+		.extra2		= &max_wakeup_granularity_ns,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sched_batch_wakeup_granularity_ns",
 		.data		= &sysctl_sched_batch_wakeup_granularity,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
 		.strategy	= &sysctl_intvec,
-		.extra1		= &min_sched_granularity_ns,
-		.extra2		= &max_sched_granularity_ns,
+		.extra1		= &min_wakeup_granularity_ns,
+		.extra2		= &max_wakeup_granularity_ns,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_stat_granularity_ns",
+		.data		= &sysctl_sched_stat_granularity,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &min_wakeup_granularity_ns,
+		.extra2		= &max_wakeup_granularity_ns,
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
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
