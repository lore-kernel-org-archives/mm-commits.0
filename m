From: akpm@linux-foundation.org
Subject: - cfs-v19.patch removed from -mm tree
Date: Tue, 10 Jul 2007 12:50:10 -0700
Message-ID: <200707101950.l6AJoAH9026229@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44219 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760698AbXGJTzR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jul 2007 15:55:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     CFS -v19
has been removed from the -mm tree.  Its filename was
     cfs-v19.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: CFS -v19
From: Ingo Molnar <mingo@elte.hu>

The biggest user-visible change in -v19 is reworked sleeper fairness:
it's similar in behavior to -v18 but works more consistently across nice
levels. Fork-happy workloads (like kernel builds) should behave better
as well. There are also a handful of speedups: unsigned math, 32-bit
speedups, O(1) task pickup, debloating and other micro-optimizations.

Changes since -v18:

 - merged the group-scheduling CFS-core changes from Srivatsa Vaddagiri.
   This makes up for the bulk of the changes in -v19 but has no
   behavioral impact. The final group-fairness enabler patch is now a
   small and lean add-on patch to CFS.

 - fix the bloat noticed by Andrew. On 32-bit it's now this:

      text    data     bss     dec     hex   filename
     24362    3905      24   28291    6e83   sched.o-rc7
     33015    2538      20   35573    8af5   sched.o-v18
     25805    2426      20   28251    6e5b   sched.o-v19

   so it's a net win compared to vanilla. On 64-bit it's even better:

      text    data     bss     dec     hex   filename
     35732   40314    2168   78214   13186   sched.o.x64-rc7
     41397   37642    2168   81207   13d37   sched.o.x64-v18
     36132   37410    2168   75710   127be   sched.o.x64-v19

   ( and there's also a +1.5K data win per CPU on x32, which is not
     shown here. [+3.0K data win per CPU on x64.] )

 - good number of core code updates, cleanups and streamlining.
   (Mike Galbraith, Srivatsa Vaddagiri, Dmitry Adamushko, me.)

 - use unsigned data types almost everywhere in CFS. This produces
   faster and smaller code, and simplifies the logic.

 - turn as many 'u64' data types into 'unsigned long' as possible, to
   reduce the 32-bit footprint and to reduce 64-bit arithmetics.

 - replaced the nr_running based 'sleep fairness' logic with a more
   robust concept. The end-result is similar in behavior to v18, but
   negative nice levels are handled much better in this scheme.

 - speedup: O(1) task pickup by Srivatsa Vaddagiri. [sleep/wakeup is
   O(log2(nr_running)).] This gives 5-10% better hackbench 100/500
   results on a 4-way box.

 - fix: set idle->sched_class back to &idle_sched_class in
   migration_call(). (Dmitry Adamushko)

 - cleanup: use an enum for the sched_feature flags. (suggested by
   Andrew Morton)

 - cleanup: turn the priority macros into inlines. (suggested by
   Andrew Morton)

 - (other cleanups suggested by Andrew Morton)

 - debug: split out the debugging data into CONFIG_SCHED_DEBUG.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile                |    0 
 fs/proc/array.c         |   24 -
 fs/proc/base.c          |    7 
 include/linux/sched.h   |  157 ++++++----
 kernel/exit.c           |    2 
 kernel/sched.c          |  313 ++++++++++++--------
 kernel/sched_debug.c    |   34 +-
 kernel/sched_fair.c     |  571 ++++++++++++++++++++++++++------------
 kernel/sched_idletask.c |   13 
 kernel/sched_rt.c       |   62 +++-
 lib/Kconfig.debug       |    9 
 11 files changed, 804 insertions(+), 388 deletions(-)

diff -puN fs/proc/array.c~cfs-v19 fs/proc/array.c
--- a/fs/proc/array.c~cfs-v19
+++ a/fs/proc/array.c
@@ -324,19 +324,18 @@ static clock_t task_utime(struct task_st
 {
 	clock_t utime = cputime_to_clock_t(p->utime),
 		total = utime + cputime_to_clock_t(p->stime);
+	u64 temp;
 
 	/*
-	 * Use CFS's precise accounting, if available:
+	 * Use CFS's precise accounting:
 	 */
-	if (!(sysctl_sched_features & 128)) {
-		u64 temp = (u64)nsec_to_clock_t(p->se.sum_exec_runtime);
+	temp = (u64)nsec_to_clock_t(p->se.sum_exec_runtime);
 
-		if (total) {
-			temp *= utime;
-			do_div(temp, total);
-		}
-		utime = (clock_t)temp;
+	if (total) {
+		temp *= utime;
+		do_div(temp, total);
 	}
+	utime = (clock_t)temp;
 
 	return utime;
 }
@@ -346,12 +345,11 @@ static clock_t task_stime(struct task_st
 	clock_t stime = cputime_to_clock_t(p->stime);
 
 	/*
-	 * Use CFS's precise accounting, if available (we subtract
-	 * utime from the total, to make sure the total observed
-	 * by userspace grows monotonically - apps rely on that):
+	 * Use CFS's precise accounting. (we subtract utime from
+	 * the total, to make sure the total observed by userspace
+	 * grows monotonically - apps rely on that):
 	 */
-	if (!(sysctl_sched_features & 128))
-		stime = nsec_to_clock_t(p->se.sum_exec_runtime) - task_utime(p);
+	stime = nsec_to_clock_t(p->se.sum_exec_runtime) - task_utime(p);
 
 	return stime;
 }
diff -puN fs/proc/base.c~cfs-v19 fs/proc/base.c
--- a/fs/proc/base.c~cfs-v19
+++ a/fs/proc/base.c
@@ -832,6 +832,7 @@ static const struct file_operations proc
 };
 #endif
 
+#ifdef CONFIG_SCHED_DEBUG
 /*
  * Print out various scheduling related per-task fields:
  */
@@ -892,6 +893,8 @@ static const struct file_operations proc
 	.release	= seq_release,
 };
 
+#endif
+
 static void *proc_pid_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
 	struct inode *inode = dentry->d_inode;
@@ -1927,7 +1930,9 @@ static const struct pid_entry tgid_base_
 	INF("environ",    S_IRUSR, pid_environ),
 	INF("auxv",       S_IRUSR, pid_auxv),
 	INF("status",     S_IRUGO, pid_status),
+#ifdef CONFIG_SCHED_DEBUG
 	REG("sched",      S_IRUGO|S_IWUSR, pid_sched),
+#endif
 	INF("cmdline",    S_IRUGO, pid_cmdline),
 	INF("stat",       S_IRUGO, tgid_stat),
 	INF("statm",      S_IRUGO, pid_statm),
@@ -2216,7 +2221,9 @@ static const struct pid_entry tid_base_s
 	INF("environ",   S_IRUSR, pid_environ),
 	INF("auxv",      S_IRUSR, pid_auxv),
 	INF("status",    S_IRUGO, pid_status),
+#ifdef CONFIG_SCHED_DEBUG
 	REG("sched",     S_IRUGO|S_IWUSR, pid_sched),
+#endif
 	INF("cmdline",   S_IRUGO, pid_cmdline),
 	INF("stat",      S_IRUGO, tid_stat),
 	INF("statm",     S_IRUGO, pid_statm),
diff -puN include/linux/sched.h~cfs-v19 include/linux/sched.h
--- a/include/linux/sched.h~cfs-v19
+++ a/include/linux/sched.h
@@ -136,8 +136,25 @@ extern unsigned long nr_iowait(void);
 extern unsigned long weighted_cpuload(const int cpu);
 
 struct seq_file;
+struct cfs_rq;
+#ifdef CONFIG_SCHED_DEBUG
 extern void proc_sched_show_task(struct task_struct *p, struct seq_file *m);
 extern void proc_sched_set_task(struct task_struct *p);
+extern void
+print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq, u64 now);
+#else
+static inline void
+proc_sched_show_task(struct task_struct *p, struct seq_file *m)
+{
+}
+static inline void proc_sched_set_task(struct task_struct *p)
+{
+}
+static inline void
+print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq, u64 now)
+{
+}
+#endif
 
 /*
  * Task state bitmask. NOTE! These bits are also
@@ -535,31 +552,6 @@ struct signal_struct {
 #define SIGNAL_STOP_CONTINUED	0x00000004 /* SIGCONT since WCONTINUED reap */
 #define SIGNAL_GROUP_EXIT	0x00000008 /* group exit in progress */
 
-
-/*
- * Priority of a process goes from 0..MAX_PRIO-1, valid RT
- * priority is 0..MAX_RT_PRIO-1, and SCHED_NORMAL/SCHED_BATCH
- * tasks are in the range MAX_RT_PRIO..MAX_PRIO-1. Priority
- * values are inverted: lower p->prio value means higher priority.
- *
- * The MAX_USER_RT_PRIO value allows the actual maximum
- * RT priority to be separate from the value exported to
- * user-space.  This allows kernel threads to set their
- * priority to a value higher than any user task. Note:
- * MAX_RT_PRIO must not be smaller than MAX_USER_RT_PRIO.
- */
-
-#define MAX_USER_RT_PRIO	100
-#define MAX_RT_PRIO		MAX_USER_RT_PRIO
-
-#define MAX_PRIO		(MAX_RT_PRIO + 40)
-#define DEFAULT_PRIO		(MAX_RT_PRIO + 20)
-
-#define rt_prio(prio)		unlikely((prio) < MAX_RT_PRIO)
-#define rt_task(p)		rt_prio((p)->prio)
-#define is_rt_policy(p)		((p) == SCHED_FIFO || (p) == SCHED_RR)
-#define has_rt_policy(p)	unlikely(is_rt_policy((p)->policy))
-
 /*
  * Some day this will be a full-fledged user tracking system..
  */
@@ -653,8 +645,7 @@ static inline int sched_info_on(void)
 #endif
 }
 
-enum cpu_idle_type
-{
+enum cpu_idle_type {
 	CPU_IDLE,
 	CPU_NOT_IDLE,
 	CPU_NEWLY_IDLE,
@@ -669,7 +660,7 @@ enum cpu_idle_type
  * Increase resolution of nice-level calculations:
  */
 #define SCHED_LOAD_SHIFT	10
-#define SCHED_LOAD_SCALE	(1UL << SCHED_LOAD_SHIFT)
+#define SCHED_LOAD_SCALE	(1L << SCHED_LOAD_SHIFT)
 
 #define SCHED_LOAD_SCALE_FUZZ	(SCHED_LOAD_SCALE >> 5)
 
@@ -838,6 +829,7 @@ struct pipe_inode_info;
 struct uts_namespace;
 
 struct rq;
+struct sched_domain;
 
 struct sched_class {
 	struct sched_class *next;
@@ -853,8 +845,13 @@ struct sched_class {
 	struct task_struct * (*pick_next_task) (struct rq *rq, u64 now);
 	void (*put_prev_task) (struct rq *rq, struct task_struct *p, u64 now);
 
-	struct task_struct * (*load_balance_start) (struct rq *rq);
-	struct task_struct * (*load_balance_next) (struct rq *rq);
+	int (*load_balance) (struct rq *this_rq, int this_cpu,
+			struct rq *busiest,
+			unsigned long max_nr_move, unsigned long max_load_move,
+			struct sched_domain *sd, enum cpu_idle_type idle,
+			int *all_pinned, unsigned long *total_load_moved);
+
+	void (*set_curr_task) (struct rq *rq);
 	void (*task_tick) (struct rq *rq, struct task_struct *p);
 	void (*task_new) (struct rq *rq, struct task_struct *p);
 };
@@ -863,30 +860,53 @@ struct load_weight {
 	unsigned long weight, inv_weight;
 };
 
-/* CFS stats for a schedulable entity (task, task-group etc) */
+/*
+ * CFS stats for a schedulable entity (task, task-group etc)
+ *
+ * Current field usage histogram:
+ *
+ *     4 se->block_start
+ *     4 se->run_node
+ *     4 se->sleep_start
+ *     4 se->sleep_start_fair
+ *     6 se->load.weight
+ *     7 se->delta_fair
+ *    15 se->wait_runtime
+ */
 struct sched_entity {
-	struct load_weight load;	/* for nice- load-balancing purposes */
-	int on_rq;
-	struct rb_node run_node;
-	unsigned long delta_exec;
-	s64 delta_fair;
-
-	u64 wait_start_fair;
-	u64 wait_start;
-	u64 exec_start;
-	u64 sleep_start, sleep_start_fair;
-	u64 block_start;
-	u64 sleep_max;
-	u64 block_max;
-	u64 exec_max;
-	u64 wait_max;
-	u64 last_ran;
-
-	s64 wait_runtime;
-	u64 sum_exec_runtime;
-	s64 fair_key;
-	s64 sum_wait_runtime, sum_sleep_runtime;
-	unsigned long wait_runtime_overruns, wait_runtime_underruns;
+	long			wait_runtime;
+	unsigned long		delta_fair_run;
+	unsigned long		delta_fair_sleep;
+	unsigned long		delta_exec;
+	s64			fair_key;
+	struct load_weight	load;		/* for load-balancing */
+	struct rb_node		run_node;
+	unsigned int		on_rq;
+
+	u64			wait_start_fair;
+	u64			wait_start;
+	u64			exec_start;
+	u64			sleep_start;
+	u64			sleep_start_fair;
+	u64			block_start;
+	u64			sleep_max;
+	u64			block_max;
+	u64			exec_max;
+	u64			wait_max;
+	u64			last_ran;
+
+	u64			sum_exec_runtime;
+	s64			sum_wait_runtime;
+	s64			sum_sleep_runtime;
+	unsigned long		wait_runtime_overruns;
+	unsigned long		wait_runtime_underruns;
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	struct sched_entity	*parent;
+	/* rq on which this entity is (to be) queued: */
+	struct cfs_rq		*cfs_rq;
+	/* rq "owned" by this entity/group: */
+	struct cfs_rq		*my_q;
+#endif
 };
 
 struct task_struct {
@@ -1147,6 +1167,37 @@ struct task_struct {
 #endif
 };
 
+/*
+ * Priority of a process goes from 0..MAX_PRIO-1, valid RT
+ * priority is 0..MAX_RT_PRIO-1, and SCHED_NORMAL/SCHED_BATCH
+ * tasks are in the range MAX_RT_PRIO..MAX_PRIO-1. Priority
+ * values are inverted: lower p->prio value means higher priority.
+ *
+ * The MAX_USER_RT_PRIO value allows the actual maximum
+ * RT priority to be separate from the value exported to
+ * user-space.  This allows kernel threads to set their
+ * priority to a value higher than any user task. Note:
+ * MAX_RT_PRIO must not be smaller than MAX_USER_RT_PRIO.
+ */
+
+#define MAX_USER_RT_PRIO	100
+#define MAX_RT_PRIO		MAX_USER_RT_PRIO
+
+#define MAX_PRIO		(MAX_RT_PRIO + 40)
+#define DEFAULT_PRIO		(MAX_RT_PRIO + 20)
+
+static inline int rt_prio(int prio)
+{
+	if (unlikely(prio < MAX_RT_PRIO))
+		return 1;
+	return 0;
+}
+
+static inline int rt_task(struct task_struct *p)
+{
+	return rt_prio(p->prio);
+}
+
 static inline pid_t process_group(struct task_struct *tsk)
 {
 	return tsk->signal->pgrp;
diff -puN kernel/exit.c~cfs-v19 kernel/exit.c
--- a/kernel/exit.c~cfs-v19
+++ a/kernel/exit.c
@@ -292,7 +292,7 @@ static void reparent_to_kthreadd(void)
 	/* Set the exit signal to SIGCHLD so we signal init on exit */
 	current->exit_signal = SIGCHLD;
 
-	if (!has_rt_policy(current) && (task_nice(current) < 0))
+	if (task_nice(current) < 0)
 		set_user_nice(current, 0);
 	/* cpus_allowed? */
 	/* rt_priority? */
diff -puN kernel/sched.c~cfs-v19 kernel/sched.c
--- a/kernel/sched.c~cfs-v19
+++ a/kernel/sched.c
@@ -108,6 +108,18 @@ unsigned long long __attribute__((weak))
 #define MIN_TIMESLICE		max(5 * HZ / 1000, 1)
 #define DEF_TIMESLICE		(100 * HZ / 1000)
 
+static inline int rt_policy(int policy)
+{
+	if (unlikely(policy == SCHED_FIFO) || unlikely(policy == SCHED_RR))
+		return 1;
+	return 0;
+}
+
+static inline int task_has_rt_policy(struct task_struct *p)
+{
+	return rt_policy(p->policy);
+}
+
 /*
  * This is the priority-queue data structure of the RT scheduling class:
  */
@@ -119,7 +131,7 @@ struct prio_array {
 struct load_stat {
 	struct load_weight load;
 	u64 load_update_start, load_update_last;
-	u64 delta_fair, delta_exec, delta_stat;
+	unsigned long delta_fair, delta_exec, delta_stat;
 };
 
 /* CFS-related fields in a runqueue */
@@ -127,14 +139,31 @@ struct cfs_rq {
 	struct load_weight load;
 	unsigned long nr_running;
 
-	u64 fair_clock;
+	s64 fair_clock;
 	u64 exec_clock;
 	s64 wait_runtime;
+	u64 sleeper_bonus;
 	unsigned long wait_runtime_overruns, wait_runtime_underruns;
 
 	struct rb_root tasks_timeline;
 	struct rb_node *rb_leftmost;
 	struct rb_node *rb_load_balance_curr;
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	/* 'curr' points to currently running entity on this cfs_rq.
+	 * It is set to NULL otherwise (i.e when none are currently running).
+	 */
+	struct sched_entity *curr;
+	struct rq *rq;	/* cpu runqueue to which this cfs_rq is attached */
+
+	/* leaf cfs_rqs are those that hold tasks (lowest schedulable entity in
+	 * a hierarchy). Non-leaf lrqs hold other higher schedulable entities
+	 * (like users, containers etc.)
+	 *
+	 * leaf_cfs_rq_list ties together list of leaf cfs_rq's in a cpu. This
+	 * list is used during load balance.
+	 */
+	struct list_head leaf_cfs_rq_list; /* Better name : task_cfs_rq_list? */
+#endif
 };
 
 /* Real-Time classes' related field in a runqueue: */
@@ -158,7 +187,7 @@ struct rq {
 	 * nr_running and cpu_load should be in the same cacheline because
 	 * remote CPUs use both these fields when doing load calculation.
 	 */
-	long nr_running;
+	unsigned long nr_running;
 	#define CPU_LOAD_IDX_MAX 5
 	unsigned long cpu_load[CPU_LOAD_IDX_MAX];
 	unsigned char idle_at_tick;
@@ -170,6 +199,9 @@ struct rq {
 	u64 nr_switches;
 
 	struct cfs_rq cfs;
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	struct list_head leaf_cfs_rq_list; /* list of leaf cfs_rq on this cpu */
+#endif
 	struct rt_rq  rt;
 
 	/*
@@ -344,6 +376,18 @@ static inline unsigned long long rq_cloc
 #define task_rq(p)		cpu_rq(task_cpu(p))
 #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+/* Change a task's ->cfs_rq if it moves across CPUs */
+static inline void set_task_cfs_rq(struct task_struct *p)
+{
+	p->se.cfs_rq = &task_rq(p)->cfs;
+}
+#else
+static inline void set_task_cfs_rq(struct task_struct *p)
+{
+}
+#endif
+
 #ifndef prepare_arch_switch
 # define prepare_arch_switch(next)	do { } while (0)
 #endif
@@ -571,19 +615,6 @@ static u64 div64_likely32(u64 divident, 
 #endif
 }
 
-static s64 div64_s(s64 divident, unsigned long divisor)
-{
-	u64 tmp;
-
-	if (divident < 0) {
-		tmp = -divident;
-		return -(s64)div64_likely32(tmp, divisor);
-	} else {
-		tmp = divident;
-		return (s64)div64_likely32(tmp, divisor);
-	}
-}
-
 #if BITS_PER_LONG == 32
 # define WMULT_CONST	(~0UL)
 #else
@@ -592,16 +623,31 @@ static s64 div64_s(s64 divident, unsigne
 
 #define WMULT_SHIFT	32
 
-static inline u64
-calc_delta_mine(u64 delta_exec, unsigned long weight, struct load_weight *lw)
+static inline unsigned long
+calc_delta_mine(unsigned long delta_exec, unsigned long weight,
+		struct load_weight *lw)
 {
+	u64 tmp;
+
 	if (unlikely(!lw->inv_weight))
 		lw->inv_weight = WMULT_CONST / lw->weight;
 
-	return (delta_exec * weight * lw->inv_weight) >> WMULT_SHIFT;
+	tmp = (u64)delta_exec * weight;
+	/*
+	 * Check whether we'd overflow the 64-bit multiplication:
+	 */
+	if (unlikely(tmp > WMULT_CONST)) {
+		tmp = ((tmp >> WMULT_SHIFT/2) * lw->inv_weight)
+				>> (WMULT_SHIFT/2);
+	} else {
+		tmp = (tmp * lw->inv_weight) >> WMULT_SHIFT;
+	}
+
+	return (unsigned long)min(tmp, (u64)sysctl_sched_runtime_limit);
 }
 
-static inline u64 calc_delta_fair(u64 delta_exec, struct load_weight *lw)
+static inline unsigned long
+calc_delta_fair(unsigned long delta_exec, struct load_weight *lw)
 {
 	return calc_delta_mine(delta_exec, NICE_0_LOAD, lw);
 }
@@ -642,7 +688,7 @@ static void __update_curr_load(struct rq
  * This function is called /before/ updating rq->ls.load
  * and when switching tasks.
  */
-static inline void update_curr_load(struct rq *rq, u64 now)
+static void update_curr_load(struct rq *rq, u64 now)
 {
 	struct load_stat *ls = &rq->ls;
 	u64 start;
@@ -658,7 +704,6 @@ static inline void update_curr_load(stru
 		__update_curr_load(rq, ls);
 }
 
-
 /*
  * To aid in avoiding the subversion of "niceness" due to uneven distribution
  * of tasks with abnormal "nice" values across CPUs the contribution that
@@ -741,11 +786,26 @@ static inline void dec_nr_running(struct
 
 static void activate_task(struct rq *rq, struct task_struct *p, int wakeup);
 
+struct rq_iterator {
+	void *arg;
+	struct task_struct *(*start)(void *);
+	struct task_struct *(*next)(void *);
+};
+
+static int balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
+		      unsigned long max_nr_move, unsigned long max_load_move,
+		      struct sched_domain *sd, enum cpu_idle_type idle,
+		      int *all_pinned, unsigned long *load_moved,
+		      int this_best_prio, int best_prio, int best_prio_seen,
+		      struct rq_iterator *iterator);
+
 #include "sched_stats.h"
 #include "sched_rt.c"
 #include "sched_fair.c"
 #include "sched_idletask.c"
-#include "sched_debug.c"
+#ifdef CONFIG_SCHED_DEBUG
+# include "sched_debug.c"
+#endif
 
 #define sched_class_highest (&rt_sched_class)
 
@@ -754,7 +814,7 @@ static void set_load_weight(struct task_
 	task_rq(p)->cfs.wait_runtime -= p->se.wait_runtime;
 	p->se.wait_runtime = 0;
 
-	if (has_rt_policy(p)) {
+	if (task_has_rt_policy(p)) {
 		p->se.load.weight = prio_to_weight[0] * 2;
 		p->se.load.inv_weight = prio_to_wmult[0] >> 1;
 		return;
@@ -807,7 +867,7 @@ static inline int normal_prio(struct tas
 {
 	int prio;
 
-	if (has_rt_policy(p))
+	if (task_has_rt_policy(p))
 		prio = MAX_RT_PRIO-1 - p->rt_priority;
 	else
 		prio = __normal_prio(p);
@@ -896,6 +956,7 @@ unsigned long weighted_cpuload(const int
 static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
 {
 	task_thread_info(p)->cpu = cpu;
+	set_task_cfs_rq(p);
 }
 
 void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
@@ -907,7 +968,6 @@ void set_task_cpu(struct task_struct *p,
 	clock_offset = old_rq->clock - new_rq->clock;
 	fair_clock_offset = old_rq->cfs.fair_clock -
 						 new_rq->cfs.fair_clock;
-
 	if (p->se.wait_start)
 		p->se.wait_start -= clock_offset;
 	if (p->se.wait_start_fair)
@@ -921,6 +981,7 @@ void set_task_cpu(struct task_struct *p,
 
 	task_thread_info(p)->cpu = new_cpu;
 
+	set_task_cfs_rq(p);
 }
 
 struct migration_req {
@@ -1478,17 +1539,25 @@ int fastcall wake_up_state(struct task_s
  */
 static void __sched_fork(struct task_struct *p)
 {
-	p->se.wait_start_fair = p->se.wait_start = p->se.exec_start = 0;
-	p->se.sum_exec_runtime = 0;
-	p->se.delta_exec = 0;
-	p->se.delta_fair = 0;
-
-	p->se.wait_runtime = 0;
-
-	p->se.sum_wait_runtime = p->se.sum_sleep_runtime = 0;
-	p->se.sleep_start = p->se.sleep_start_fair = p->se.block_start = 0;
-	p->se.sleep_max = p->se.block_max = p->se.exec_max = p->se.wait_max = 0;
-	p->se.wait_runtime_overruns = p->se.wait_runtime_underruns = 0;
+	p->se.wait_start_fair		= 0;
+	p->se.wait_start		= 0;
+	p->se.exec_start		= 0;
+	p->se.sum_exec_runtime		= 0;
+	p->se.delta_exec		= 0;
+	p->se.delta_fair_run		= 0;
+	p->se.delta_fair_sleep		= 0;
+	p->se.wait_runtime		= 0;
+	p->se.sum_wait_runtime		= 0;
+	p->se.sum_sleep_runtime		= 0;
+	p->se.sleep_start		= 0;
+	p->se.sleep_start_fair		= 0;
+	p->se.block_start		= 0;
+	p->se.sleep_max			= 0;
+	p->se.block_max			= 0;
+	p->se.exec_max			= 0;
+	p->se.wait_max			= 0;
+	p->se.wait_runtime_overruns	= 0;
+	p->se.wait_runtime_underruns	= 0;
 
 	INIT_LIST_HEAD(&p->run_list);
 	p->se.on_rq = 0;
@@ -1801,7 +1870,7 @@ static void update_cpu_load(struct rq *t
 	int i, scale;
 
 	this_rq->nr_load_updates++;
-	if (sysctl_sched_features & 64)
+	if (unlikely(!(sysctl_sched_features & SCHED_FEAT_PRECISE_CPU_LOAD)))
 		goto do_avg;
 
 	/* Update delta_fair/delta_exec fields first */
@@ -2005,89 +2074,26 @@ int can_migrate_task(struct task_struct 
 	return 1;
 }
 
-/*
- * Load-balancing iterator: iterate through the hieararchy of scheduling
- * classes, starting with the highest-prio one:
- */
-
-struct task_struct * load_balance_start(struct rq *rq)
-{
-	struct sched_class *class = sched_class_highest;
-	struct task_struct *p;
-
-	do {
-		p = class->load_balance_start(rq);
-		if (p) {
-			rq->load_balance_class = class;
-			return p;
-		}
-		class = class->next;
-	} while (class);
-
-	return NULL;
-}
-
-struct task_struct * load_balance_next(struct rq *rq)
-{
-	struct sched_class *class = rq->load_balance_class;
-	struct task_struct *p;
-
-	p = class->load_balance_next(rq);
-	if (p)
-		return p;
-	/*
-	 * Pick up the next class (if any) and attempt to start
-	 * the iterator there:
-	 */
-	while ((class = class->next)) {
-		p = class->load_balance_start(rq);
-		if (p) {
-			rq->load_balance_class = class;
-			return p;
-		}
-	}
-	return NULL;
-}
-
-#define rq_best_prio(rq) (rq)->curr->prio
-
-/*
- * move_tasks tries to move up to max_nr_move tasks and max_load_move weighted
- * load from busiest to this_rq, as part of a balancing operation within
- * "domain". Returns the number of tasks moved.
- *
- * Called with both runqueues locked.
- */
-static int move_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
+static int balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		      unsigned long max_nr_move, unsigned long max_load_move,
 		      struct sched_domain *sd, enum cpu_idle_type idle,
-		      int *all_pinned)
+		      int *all_pinned, unsigned long *load_moved,
+		      int this_best_prio, int best_prio, int best_prio_seen,
+		      struct rq_iterator *iterator)
 {
-	int pulled = 0, pinned = 0, this_best_prio, best_prio,
-	    best_prio_seen, skip_for_load;
+	int pulled = 0, pinned = 0, skip_for_load;
 	struct task_struct *p;
-	long rem_load_move;
+	long rem_load_move = max_load_move;
 
 	if (max_nr_move == 0 || max_load_move == 0)
 		goto out;
 
-	rem_load_move = max_load_move;
 	pinned = 1;
-	this_best_prio = rq_best_prio(this_rq);
-	best_prio = rq_best_prio(busiest);
-	/*
-	 * Enable handling of the case where there is more than one task
-	 * with the best priority.   If the current running task is one
-	 * of those with prio==best_prio we know it won't be moved
-	 * and therefore it's safe to override the skip (based on load) of
-	 * any task we find with that prio.
-	 */
-	best_prio_seen = best_prio == busiest->curr->prio;
 
 	/*
 	 * Start the load-balancing iterator:
 	 */
-	p = load_balance_start(busiest);
+	p = iterator->start(iterator->arg);
 next:
 	if (!p)
 		goto out;
@@ -2104,7 +2110,7 @@ next:
 	    !can_migrate_task(p, busiest, this_cpu, sd, idle, &pinned)) {
 
 		best_prio_seen |= p->prio == best_prio;
-		p = load_balance_next(busiest);
+		p = iterator->next(iterator->arg);
 		goto next;
 	}
 
@@ -2119,7 +2125,7 @@ next:
 	if (pulled < max_nr_move && rem_load_move > 0) {
 		if (p->prio < this_best_prio)
 			this_best_prio = p->prio;
-		p = load_balance_next(busiest);
+		p = iterator->next(iterator->arg);
 		goto next;
 	}
 out:
@@ -2132,10 +2138,40 @@ out:
 
 	if (all_pinned)
 		*all_pinned = pinned;
+	*load_moved = max_load_move - rem_load_move;
 	return pulled;
 }
 
 /*
+ * move_tasks tries to move up to max_nr_move tasks and max_load_move weighted
+ * load from busiest to this_rq, as part of a balancing operation within
+ * "domain". Returns the number of tasks moved.
+ *
+ * Called with both runqueues locked.
+ */
+static int move_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
+		      unsigned long max_nr_move, unsigned long max_load_move,
+		      struct sched_domain *sd, enum cpu_idle_type idle,
+		      int *all_pinned)
+{
+	struct sched_class *class = sched_class_highest;
+	unsigned long load_moved, total_nr_moved = 0, nr_moved;
+	long rem_load_move = max_load_move;
+
+	do {
+		nr_moved = class->load_balance(this_rq, this_cpu, busiest,
+				max_nr_move, (unsigned long)rem_load_move,
+				sd, idle, all_pinned, &load_moved);
+		total_nr_moved += nr_moved;
+		max_nr_move -= nr_moved;
+		rem_load_move -= load_moved;
+		class = class->next;
+	} while (class && max_nr_move && rem_load_move > 0);
+
+	return total_nr_moved;
+}
+
+/*
  * find_busiest_group finds and returns the busiest CPU group within the
  * domain. It calculates and returns the amount of weighted load which
  * should be moved to restore balance via the imbalance parameter.
@@ -3043,6 +3079,19 @@ static inline void idle_balance(int cpu,
 {
 }
 
+/* Avoid "used but not defined" warning on UP */
+static int balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
+		      unsigned long max_nr_move, unsigned long max_load_move,
+		      struct sched_domain *sd, enum cpu_idle_type idle,
+		      int *all_pinned, unsigned long *load_moved,
+		      int this_best_prio, int best_prio, int best_prio_seen,
+		      struct rq_iterator *iterator)
+{
+	*load_moved = 0;
+
+	return 0;
+}
+
 #endif	/* CONFIG_SMP */
 
 DEFINE_PER_CPU(struct kernel_stat, kstat);
@@ -3803,7 +3852,7 @@ void set_user_nice(struct task_struct *p
 	 * it wont have any effect on scheduling until the task is
 	 * SCHED_FIFO/SCHED_RR:
 	 */
-	if (has_rt_policy(p)) {
+	if (task_has_rt_policy(p)) {
 		p->static_prio = NICE_TO_PRIO(nice);
 		goto out_unlock;
 	}
@@ -4001,16 +4050,15 @@ recheck:
 	    (p->mm && param->sched_priority > MAX_USER_RT_PRIO-1) ||
 	    (!p->mm && param->sched_priority > MAX_RT_PRIO-1))
 		return -EINVAL;
-	if (is_rt_policy(policy) != (param->sched_priority != 0))
+	if (rt_policy(policy) != (param->sched_priority != 0))
 		return -EINVAL;
 
 	/*
 	 * Allow unprivileged RT tasks to decrease priority:
 	 */
 	if (!capable(CAP_SYS_NICE)) {
-		if (is_rt_policy(policy)) {
+		if (rt_policy(policy)) {
 			unsigned long rlim_rtprio;
-			unsigned long flags;
 
 			if (!lock_task_sighand(p, &flags))
 				return -ESRCH;
@@ -4653,7 +4701,9 @@ void show_state_filter(unsigned long sta
 	 */
 	if (state_filter == -1)
 		debug_show_all_locks();
+#ifdef CONFIG_SCHED_DEBUG
 	sysrq_sched_debug_show();
+#endif
 }
 
 void __cpuinit init_idle_bootup_task(struct task_struct *idle)
@@ -4728,6 +4778,7 @@ static inline void sched_init_granularit
 		sysctl_sched_granularity = gran_limit;
 
 	sysctl_sched_runtime_limit = sysctl_sched_granularity * 4;
+	sysctl_sched_wakeup_granularity = sysctl_sched_granularity / 2;
 }
 
 #ifdef CONFIG_SMP
@@ -5233,6 +5284,7 @@ migration_call(struct notifier_block *nf
 		deactivate_task(rq, rq->idle, 0);
 		rq->idle->static_prio = MAX_PRIO;
 		__setscheduler(rq, rq->idle, SCHED_NORMAL, 0);
+		rq->idle->sched_class = &idle_sched_class;
 		migrate_dead_tasks(cpu);
 		task_rq_unlock(rq, &flags);
 		migrate_nr_uninterruptible(rq);
@@ -5841,7 +5893,6 @@ static void init_sched_groups_power(int 
 static int build_sched_domains(const cpumask_t *cpu_map)
 {
 	int i;
-	struct sched_domain *sd;
 #ifdef CONFIG_NUMA
 	struct sched_group **sched_group_nodes = NULL;
 	int sd_allnodes = 0;
@@ -5986,6 +6037,7 @@ static int build_sched_domains(const cpu
 		sched_group_nodes[i] = sg;
 		for_each_cpu_mask(j, nodemask) {
 			struct sched_domain *sd;
+
 			sd = &per_cpu(node_domains, j);
 			sd->groups = sg;
 		}
@@ -6030,19 +6082,22 @@ static int build_sched_domains(const cpu
 	/* Calculate CPU power for physical packages and nodes */
 #ifdef CONFIG_SCHED_SMT
 	for_each_cpu_mask(i, *cpu_map) {
-		sd = &per_cpu(cpu_domains, i);
+		struct sched_domain *sd = &per_cpu(cpu_domains, i);
+
 		init_sched_groups_power(i, sd);
 	}
 #endif
 #ifdef CONFIG_SCHED_MC
 	for_each_cpu_mask(i, *cpu_map) {
-		sd = &per_cpu(core_domains, i);
+		struct sched_domain *sd = &per_cpu(core_domains, i);
+
 		init_sched_groups_power(i, sd);
 	}
 #endif
 
 	for_each_cpu_mask(i, *cpu_map) {
-		sd = &per_cpu(phys_domains, i);
+		struct sched_domain *sd = &per_cpu(phys_domains, i);
+
 		init_sched_groups_power(i, sd);
 	}
 
@@ -6270,8 +6325,18 @@ int in_sched_functions(unsigned long add
 		&& addr < (unsigned long)__sched_text_end);
 }
 
+static inline void init_cfs_rq(struct cfs_rq *cfs_rq, struct rq *rq)
+{
+	cfs_rq->tasks_timeline = RB_ROOT;
+	cfs_rq->fair_clock = 1;
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	cfs_rq->rq = rq;
+#endif
+}
+
 void __init sched_init(void)
 {
+	u64 now = sched_clock();
 	int highest_cpu = 0;
 	int i, j;
 
@@ -6290,10 +6355,14 @@ void __init sched_init(void)
 		spin_lock_init(&rq->lock);
 		lockdep_set_class(&rq->lock, &rq->rq_lock_key);
 		rq->nr_running = 0;
-		rq->cfs.tasks_timeline = RB_ROOT;
-		rq->clock = rq->cfs.fair_clock = 1;
-		rq->ls.load_update_last = sched_clock();
-		rq->ls.load_update_start = sched_clock();
+		rq->clock = 1;
+		init_cfs_rq(&rq->cfs, rq);
+#ifdef CONFIG_FAIR_GROUP_SCHED
+		INIT_LIST_HEAD(&rq->leaf_cfs_rq_list);
+		list_add(&rq->cfs.leaf_cfs_rq_list, &rq->leaf_cfs_rq_list);
+#endif
+		rq->ls.load_update_last = now;
+		rq->ls.load_update_start = now;
 
 		for (j = 0; j < CPU_LOAD_IDX_MAX; j++)
 			rq->cpu_load[j] = 0;
diff -puN kernel/sched_debug.c~cfs-v19 kernel/sched_debug.c
--- a/kernel/sched_debug.c~cfs-v19
+++ a/kernel/sched_debug.c
@@ -80,15 +80,17 @@ static void print_rq(struct seq_file *m,
 	read_unlock_irq(&tasklist_lock);
 }
 
-static void print_rq_runtime_sum(struct seq_file *m, struct rq *rq)
+static void
+print_cfs_rq_runtime_sum(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 {
 	s64 wait_runtime_rq_sum = 0;
 	struct task_struct *p;
 	struct rb_node *curr;
 	unsigned long flags;
+	struct rq *rq = &per_cpu(runqueues, cpu);
 
 	spin_lock_irqsave(&rq->lock, flags);
-	curr = first_fair(&rq->cfs);
+	curr = first_fair(cfs_rq);
 	while (curr) {
 		p = rb_entry(curr, struct task_struct, se.run_node);
 		wait_runtime_rq_sum += p->se.wait_runtime;
@@ -101,6 +103,24 @@ static void print_rq_runtime_sum(struct 
 		(long long)wait_runtime_rq_sum);
 }
 
+void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq, u64 now)
+{
+	SEQ_printf(m, "\ncfs_rq %p\n", cfs_rq);
+
+#define P(x) \
+	SEQ_printf(m, "  .%-30s: %Ld\n", #x, (long long)(cfs_rq->x))
+
+	P(fair_clock);
+	P(exec_clock);
+	P(wait_runtime);
+	P(wait_runtime_overruns);
+	P(wait_runtime_underruns);
+	P(sleeper_bonus);
+#undef P
+
+	print_cfs_rq_runtime_sum(m, cpu, cfs_rq);
+}
+
 static void print_cpu(struct seq_file *m, int cpu, u64 now)
 {
 	struct rq *rq = &per_cpu(runqueues, cpu);
@@ -136,18 +156,14 @@ static void print_cpu(struct seq_file *m
 	P(clock_overflows);
 	P(clock_unstable_events);
 	P(clock_max_delta);
-	P(cfs.fair_clock);
-	P(cfs.exec_clock);
-	P(cfs.wait_runtime);
-	P(cfs.wait_runtime_overruns);
-	P(cfs.wait_runtime_underruns);
 	P(cpu_load[0]);
 	P(cpu_load[1]);
 	P(cpu_load[2]);
 	P(cpu_load[3]);
 	P(cpu_load[4]);
 #undef P
-	print_rq_runtime_sum(m, rq);
+
+	print_cfs_stats(m, cpu, now);
 
 	print_rq(m, rq, cpu, now);
 }
@@ -157,7 +173,7 @@ static int sched_debug_show(struct seq_f
 	u64 now = ktime_to_ns(ktime_get());
 	int cpu;
 
-	SEQ_printf(m, "Sched Debug Version: v0.03, cfs-v18, %s %.*s\n",
+	SEQ_printf(m, "Sched Debug Version: v0.04, cfs-v19, %s %.*s\n",
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
 		init_utsname()->version);
diff -puN kernel/sched_fair.c~cfs-v19 kernel/sched_fair.c
--- a/kernel/sched_fair.c~cfs-v19
+++ a/kernel/sched_fair.c
@@ -61,8 +61,25 @@ unsigned int sysctl_sched_stat_granulari
  */
 unsigned int sysctl_sched_runtime_limit __read_mostly;
 
+/*
+ * Debugging: various feature bits
+ */
+enum {
+	SCHED_FEAT_FAIR_SLEEPERS	= 1,
+	SCHED_FEAT_SLEEPER_AVG		= 2,
+	SCHED_FEAT_SLEEPER_LOAD_AVG	= 4,
+	SCHED_FEAT_PRECISE_CPU_LOAD	= 8,
+	SCHED_FEAT_START_DEBIT		= 16,
+	SCHED_FEAT_SKIP_INITIAL		= 32,
+};
+
 unsigned int sysctl_sched_features __read_mostly =
-			0 | 2 | 4 | 8 | 0 | 0 | 0 | 0;
+		SCHED_FEAT_FAIR_SLEEPERS	*1 |
+		SCHED_FEAT_SLEEPER_AVG		*1 |
+		SCHED_FEAT_SLEEPER_LOAD_AVG	*1 |
+		SCHED_FEAT_PRECISE_CPU_LOAD	*1 |
+		SCHED_FEAT_START_DEBIT		*1 |
+		SCHED_FEAT_SKIP_INITIAL		*0;
 
 extern struct sched_class fair_sched_class;
 
@@ -70,6 +87,31 @@ extern struct sched_class fair_sched_cla
  * CFS operations on generic schedulable entities:
  */
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+
+/* cpu runqueue to which this cfs_rq is attached */
+static inline struct rq *rq_of(struct cfs_rq *cfs_rq)
+{
+	return cfs_rq->rq;
+}
+
+/* currently running entity (if any) on this cfs_rq */
+static inline struct sched_entity *cfs_rq_curr(struct cfs_rq *cfs_rq)
+{
+	return cfs_rq->curr;
+}
+
+/* An entity is a task if it doesn't "own" a runqueue */
+#define entity_is_task(se)	(!se->my_q)
+
+static inline void
+set_cfs_rq_curr(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+	cfs_rq->curr = se;
+}
+
+#else	/* CONFIG_FAIR_GROUP_SCHED */
+
 static inline struct rq *rq_of(struct cfs_rq *cfs_rq)
 {
 	return container_of(cfs_rq, struct rq, cfs);
@@ -87,6 +129,11 @@ static inline struct sched_entity *cfs_r
 
 #define entity_is_task(se)	1
 
+static inline void
+set_cfs_rq_curr(struct cfs_rq *cfs_rq, struct sched_entity *se) { }
+
+#endif	/* CONFIG_FAIR_GROUP_SCHED */
+
 static inline struct task_struct *task_of(struct sched_entity *se)
 {
 	return container_of(se, struct task_struct, se);
@@ -119,7 +166,7 @@ __enqueue_entity(struct cfs_rq *cfs_rq, 
 		 * We dont care about collisions. Nodes with
 		 * the same key stay together.
 		 */
-		if ((s64)(key - entry->fair_key) < 0) {
+		if (key - entry->fair_key < 0) {
 			link = &parent->rb_left;
 		} else {
 			link = &parent->rb_right;
@@ -145,7 +192,7 @@ static inline void
 __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	if (cfs_rq->rb_leftmost == &se->run_node)
-		cfs_rq->rb_leftmost = NULL;
+		cfs_rq->rb_leftmost = rb_next(&se->run_node);
 	rb_erase(&se->run_node, &cfs_rq->tasks_timeline);
 	update_load_sub(&cfs_rq->load, se->load.weight);
 	cfs_rq->nr_running--;
@@ -154,10 +201,6 @@ __dequeue_entity(struct cfs_rq *cfs_rq, 
 
 static inline struct rb_node * first_fair(struct cfs_rq *cfs_rq)
 {
-	if (cfs_rq->rb_leftmost)
-		return cfs_rq->rb_leftmost;
-	/* Cache the value returned by rb_first() */
-	cfs_rq->rb_leftmost = rb_first(&cfs_rq->tasks_timeline);
 	return cfs_rq->rb_leftmost;
 }
 
@@ -174,7 +217,7 @@ static struct sched_entity * __pick_next
  * We rescale the rescheduling granularity of tasks according to their
  * nice level, but only linearly, not exponentially:
  */
-static s64
+static long
 niced_granularity(struct sched_entity *curr, unsigned long granularity)
 {
 	u64 tmp;
@@ -182,20 +225,24 @@ niced_granularity(struct sched_entity *c
 	/*
 	 * Negative nice levels get the same granularity as nice-0:
 	 */
-	if (curr->load.weight >= NICE_0_LOAD)
+	if (likely(curr->load.weight >= NICE_0_LOAD))
 		return granularity;
 	/*
 	 * Positive nice level tasks get linearly finer
 	 * granularity:
 	 */
 	tmp = curr->load.weight * (u64)granularity;
-	return (s64) (tmp >> NICE_0_SHIFT);
+
+	/*
+	 * It will always fit into 'long':
+	 */
+	return (long) (tmp >> NICE_0_SHIFT);
 }
 
 static inline void
 limit_wait_runtime(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	s64 limit = sysctl_sched_runtime_limit;
+	long limit = sysctl_sched_runtime_limit;
 
 	/*
 	 * Niced tasks have the same history dynamic range as
@@ -214,7 +261,7 @@ limit_wait_runtime(struct cfs_rq *cfs_rq
 }
 
 static inline void
-__add_wait_runtime(struct cfs_rq *cfs_rq, struct sched_entity *se, s64 delta)
+__add_wait_runtime(struct cfs_rq *cfs_rq, struct sched_entity *se, long delta)
 {
 	se->wait_runtime += delta;
 	schedstat_add(se, sum_wait_runtime, delta);
@@ -222,7 +269,7 @@ __add_wait_runtime(struct cfs_rq *cfs_rq
 }
 
 static void
-add_wait_runtime(struct cfs_rq *cfs_rq, struct sched_entity *se, s64 delta)
+add_wait_runtime(struct cfs_rq *cfs_rq, struct sched_entity *se, long delta)
 {
 	schedstat_add(cfs_rq, wait_runtime, -se->wait_runtime);
 	__add_wait_runtime(cfs_rq, se, delta);
@@ -236,33 +283,35 @@ add_wait_runtime(struct cfs_rq *cfs_rq, 
 static inline void
 __update_curr(struct cfs_rq *cfs_rq, struct sched_entity *curr, u64 now)
 {
+	unsigned long delta, delta_exec, delta_fair;
+	long delta_mine;
 	struct load_weight *lw = &cfs_rq->load;
-	u64 delta_exec, delta_fair, delta_mine;
-	struct rq *rq = rq_of(cfs_rq);
-	struct task_struct *curtask = rq->curr;
 	unsigned long load = lw->weight;
 
 	if (unlikely(!load))
 		return;
 
 	delta_exec = curr->delta_exec;
+#ifdef CONFIG_SCHEDSTATS
 	if (unlikely(delta_exec > curr->exec_max))
 		curr->exec_max = delta_exec;
+#endif
 
 	curr->sum_exec_runtime += delta_exec;
 	cfs_rq->exec_clock += delta_exec;
 
 	delta_fair = calc_delta_fair(delta_exec, lw);
+	delta_mine = calc_delta_mine(delta_exec, curr->load.weight, lw);
 
-	/*
-	 * Task already marked for preemption, do not burden
-	 * it with the cost of not having left the CPU yet:
-	 */
-	if (unlikely(sysctl_sched_features & 1))
-		if (unlikely(test_tsk_thread_flag(curtask, TIF_NEED_RESCHED)))
-			return;
+	if (cfs_rq->sleeper_bonus > sysctl_sched_stat_granularity) {
+		delta = calc_delta_mine(cfs_rq->sleeper_bonus,
+					curr->load.weight, lw);
+		if (unlikely(delta > cfs_rq->sleeper_bonus))
+			delta = cfs_rq->sleeper_bonus;
 
-	delta_mine = calc_delta_mine(delta_exec, curr->load.weight, lw);
+		cfs_rq->sleeper_bonus -= delta;
+		delta_mine -= delta;
+	}
 
 	cfs_rq->fair_clock += delta_fair;
 	/*
@@ -285,13 +334,14 @@ static void update_curr(struct cfs_rq *c
 
 	/*
 	 * Get the amount of time the current task was running
-	 * since the last time we changed load:
+	 * since the last time we changed load (this cannot
+	 * overflow on 32 bits):
 	 */
-	delta_exec = now - curr->exec_start;
+	delta_exec = (unsigned long)(now - curr->exec_start);
 
 	curr->delta_exec += delta_exec;
 
-	if (curr->delta_exec > sysctl_sched_stat_granularity) {
+	if (unlikely(curr->delta_exec > sysctl_sched_stat_granularity)) {
 		__update_curr(cfs_rq, curr, now);
 		curr->delta_exec = 0;
 	}
@@ -305,19 +355,10 @@ update_stats_wait_start(struct cfs_rq *c
 	se->wait_start = now;
 }
 
-static inline s64 weight_s64(s64 calc, unsigned long weight, int shift)
-{
-	if (calc < 0) {
-		calc = - calc * weight;
-		return - (calc >> shift);
-	}
-	return (calc * weight) >> shift;
-}
-
 /*
  * Task is being enqueued - update stats:
  */
-static inline void
+static void
 update_stats_enqueue(struct cfs_rq *cfs_rq, struct sched_entity *se, u64 now)
 {
 	s64 key;
@@ -339,15 +380,15 @@ update_stats_enqueue(struct cfs_rq *cfs_
 	if (likely(se->load.weight == NICE_0_LOAD)) {
 		key -= se->wait_runtime;
 	} else {
-		s64 tmp;
+		u64 tmp;
 
 		if (se->wait_runtime < 0) {
 			tmp = -se->wait_runtime;
 			key += (tmp * se->load.inv_weight) >>
 					(WMULT_SHIFT - NICE_0_SHIFT);
 		} else {
-			tmp = se->wait_runtime * se->load.weight;
-			key -= tmp >> NICE_0_SHIFT;
+			tmp = se->wait_runtime;
+			key -= (tmp * se->load.weight) >> NICE_0_SHIFT;
 		}
 	}
 
@@ -360,17 +401,18 @@ update_stats_enqueue(struct cfs_rq *cfs_
 static inline void
 __update_stats_wait_end(struct cfs_rq *cfs_rq, struct sched_entity *se, u64 now)
 {
-	s64 delta_fair, delta_wait;
-
-	delta_wait = now - se->wait_start;
-	if (unlikely(delta_wait > se->wait_max))
-		se->wait_max = delta_wait;
+	unsigned long delta_fair = se->delta_fair_run;
 
-	delta_fair = se->delta_fair;
+#ifdef CONFIG_SCHEDSTATS
+	{
+		s64 delta_wait = now - se->wait_start;
+		if (unlikely(delta_wait > se->wait_max))
+			se->wait_max = delta_wait;
+	}
+#endif
 
 	if (unlikely(se->load.weight != NICE_0_LOAD))
-		delta_fair = weight_s64(delta_fair, se->load.weight,
-						NICE_0_SHIFT);
+		delta_fair = (u64)delta_fair * se->load.weight >> NICE_0_SHIFT;
 
 	add_wait_runtime(cfs_rq, se, delta_fair);
 }
@@ -378,12 +420,16 @@ __update_stats_wait_end(struct cfs_rq *c
 static void
 update_stats_wait_end(struct cfs_rq *cfs_rq, struct sched_entity *se, u64 now)
 {
-	s64 delta_fair = cfs_rq->fair_clock - se->wait_start_fair;
+	unsigned long delta_fair;
+
+	delta_fair = (unsigned long)min((u64)(2*sysctl_sched_runtime_limit),
+			(u64)(cfs_rq->fair_clock - se->wait_start_fair));
 
-	se->delta_fair += delta_fair;
-	if (unlikely(se->delta_fair >= sysctl_sched_stat_granularity)) {
+	se->delta_fair_run += delta_fair;
+	if (unlikely(abs(se->delta_fair_run) >=
+				sysctl_sched_stat_granularity)) {
 		__update_stats_wait_end(cfs_rq, se, now);
-		se->delta_fair = 0;
+		se->delta_fair_run = 0;
 	}
 
 	se->wait_start_fair = 0;
@@ -423,36 +469,6 @@ update_stats_curr_end(struct cfs_rq *cfs
 	se->exec_start = 0;
 }
 
-/*
- * A task gets added back to the runnable tasks and gets
- * a small credit for the CPU time it missed out on, so
- * fix up all other runnable task's wait_runtime so that
- * the sum stays constant (around 0).
- *
- * Instead of looping over all runnable tasks in an O(N)
- * manner we move the fair clock back by a proportional
- * amount of the new wait_runtime this task adds to the pool.
- */
-static void distribute_fair_add(struct cfs_rq *cfs_rq, s64 delta)
-{
-	struct sched_entity *curr = cfs_rq_curr(cfs_rq);
-	s64 delta_fair = 0;
-
-	if (!(sysctl_sched_features & 2))
-		return;
-
-	if (cfs_rq->nr_running) {
-		delta_fair = div64_s(delta, cfs_rq->nr_running);
-		/*
-		 * The currently running task's next wait_runtime value does
-		 * not depend on the fair_clock, so fix it up explicitly:
-		 */
-		 if (curr)
-			add_wait_runtime(cfs_rq, curr, -delta_fair);
-	}
-	cfs_rq->fair_clock -= delta_fair;
-}
-
 /**************************************************
  * Scheduling class queueing methods:
  */
@@ -460,30 +476,33 @@ static void distribute_fair_add(struct c
 static void
 __enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se, u64 now)
 {
-	unsigned long load = cfs_rq->load.weight;
-	s64 delta_fair, prev_runtime;
+	unsigned long load = cfs_rq->load.weight, delta_fair;
+	long prev_runtime;
+
+	if (sysctl_sched_features & SCHED_FEAT_SLEEPER_LOAD_AVG)
+		load = rq_of(cfs_rq)->cpu_load[2];
 
-	delta_fair = cfs_rq->fair_clock - se->sleep_start_fair;
+	delta_fair = se->delta_fair_sleep;
 
 	/*
 	 * Fix up delta_fair with the effect of us running
 	 * during the whole sleep period:
 	 */
-	if (!(sysctl_sched_features & 32))
-		delta_fair = div64_s(delta_fair * load, load + se->load.weight);
+	if (sysctl_sched_features & SCHED_FEAT_SLEEPER_AVG)
+		delta_fair = div64_likely32((u64)delta_fair * load,
+						load + se->load.weight);
 
-	delta_fair = weight_s64(delta_fair, se->load.weight, NICE_0_SHIFT);
+	if (unlikely(se->load.weight != NICE_0_LOAD))
+		delta_fair = (u64)delta_fair * se->load.weight >> NICE_0_SHIFT;
 
 	prev_runtime = se->wait_runtime;
 	__add_wait_runtime(cfs_rq, se, delta_fair);
 	delta_fair = se->wait_runtime - prev_runtime;
 
 	/*
-	 * We move the fair clock back by a load-proportional
-	 * amount of the new wait_runtime this task adds to
-	 * the 'pool':
+	 * Track the amount of bonus we've given to sleepers:
 	 */
-	distribute_fair_add(cfs_rq, delta_fair);
+	cfs_rq->sleeper_bonus += delta_fair;
 
 	schedstat_add(cfs_rq, wait_runtime, se->wait_runtime);
 }
@@ -492,17 +511,20 @@ static void
 enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se, u64 now)
 {
 	struct task_struct *tsk = task_of(se);
-	s64 delta_fair;
+	unsigned long delta_fair;
 
 	if ((entity_is_task(se) && tsk->policy == SCHED_BATCH) ||
-						 !(sysctl_sched_features & 4))
+			 !(sysctl_sched_features & SCHED_FEAT_FAIR_SLEEPERS))
 		return;
 
-	delta_fair = cfs_rq->fair_clock - se->sleep_start_fair;
-	se->delta_fair += delta_fair;
-	if (unlikely(se->delta_fair >= sysctl_sched_stat_granularity)) {
+	delta_fair = (unsigned long)min((u64)(2*sysctl_sched_runtime_limit),
+		(u64)(cfs_rq->fair_clock - se->sleep_start_fair));
+
+	se->delta_fair_sleep += delta_fair;
+	if (unlikely(abs(se->delta_fair_sleep) >=
+				sysctl_sched_stat_granularity)) {
 		__enqueue_sleeper(cfs_rq, se, now);
-		se->delta_fair = 0;
+		se->delta_fair_sleep = 0;
 	}
 
 	se->sleep_start_fair = 0;
@@ -535,8 +557,9 @@ enqueue_sleeper(struct cfs_rq *cfs_rq, s
 #endif
 }
 
-static void enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
-							 int wakeup, u64 now)
+static void
+enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
+	       int wakeup, u64 now)
 {
 	/*
 	 * Update the fair clock.
@@ -550,8 +573,9 @@ static void enqueue_entity(struct cfs_rq
 	__enqueue_entity(cfs_rq, se);
 }
 
-static void dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
-							 int sleep, u64 now)
+static void
+dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
+	       int sleep, u64 now)
 {
 	update_stats_dequeue(cfs_rq, se, now);
 	if (sleep) {
@@ -574,7 +598,7 @@ static void dequeue_entity(struct cfs_rq
 /*
  * Preempt the current task with a newly woken task if needed:
  */
-static inline void
+static void
 __check_preempt_curr_fair(struct cfs_rq *cfs_rq, struct sched_entity *se,
 			  struct sched_entity *curr, unsigned long granularity)
 {
@@ -589,10 +613,9 @@ __check_preempt_curr_fair(struct cfs_rq 
 		resched_task(rq_of(cfs_rq)->curr);
 }
 
-static struct sched_entity * pick_next_entity(struct cfs_rq *cfs_rq, u64 now)
+static inline void
+set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, u64 now)
 {
-	struct sched_entity *se = __pick_next_entity(cfs_rq);
-
 	/*
 	 * Any task has to be enqueued before it get to execute on
 	 * a CPU. So account for the time it spent waiting on the
@@ -602,6 +625,14 @@ static struct sched_entity * pick_next_e
 	 */
 	update_stats_wait_end(cfs_rq, se, now);
 	update_stats_curr_start(cfs_rq, se, now);
+	set_cfs_rq_curr(cfs_rq, se);
+}
+
+static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq, u64 now)
+{
+	struct sched_entity *se = __pick_next_entity(cfs_rq);
+
+	set_next_entity(cfs_rq, se, now);
 
 	return se;
 }
@@ -609,42 +640,24 @@ static struct sched_entity * pick_next_e
 static void
 put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev, u64 now)
 {
-	int updated = 0;
-
-	/*
-	 * If the task is still waiting for the CPU (it just got
-	 * preempted), update its position within the tree and
-	 * start the wait period:
-	 */
-	if ((sysctl_sched_features & 16) && entity_is_task(prev))  {
-		struct task_struct *prevtask = task_of(prev);
-
-		if (prev->on_rq &&
-			test_tsk_thread_flag(prevtask, TIF_NEED_RESCHED)) {
-
-			dequeue_entity(cfs_rq, prev, 0, now);
-			enqueue_entity(cfs_rq, prev, 0, now);
-			updated = 1;
-		}
-	}
-
 	/*
 	 * If still on the runqueue then deactivate_task()
 	 * was not called and update_curr() has to be done:
 	 */
-	if (prev->on_rq && !updated)
+	if (prev->on_rq)
 		update_curr(cfs_rq, now);
 
 	update_stats_curr_end(cfs_rq, prev, now);
 
 	if (prev->on_rq)
 		update_stats_wait_start(cfs_rq, prev, now);
+	set_cfs_rq_curr(cfs_rq, NULL);
 }
 
 static void entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 {
-	struct sched_entity *next;
 	struct rq *rq = rq_of(cfs_rq);
+	struct sched_entity *next;
 	u64 now = __rq_clock(rq);
 
 	/*
@@ -661,16 +674,6 @@ static void entity_tick(struct cfs_rq *c
 	if (next == curr)
 		return;
 
-	if (entity_is_task(curr)) {
-		struct task_struct *curtask = task_of(curr),
-				   *nexttask = task_of(next);
-
-		if ((rt_prio(nexttask->prio) &&
-				(nexttask->prio < curtask->prio))) {
-			resched_task(curtask);
-			return;
-		}
-	}
 	__check_preempt_curr_fair(cfs_rq, next, curr, sysctl_sched_granularity);
 }
 
@@ -678,11 +681,90 @@ static void entity_tick(struct cfs_rq *c
  * CFS operations on tasks:
  */
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+
+/* Walk up scheduling entities hierarchy */
+#define for_each_sched_entity(se) \
+		for (; se; se = se->parent)
+
+static inline struct cfs_rq *task_cfs_rq(struct task_struct *p)
+{
+	return p->se.cfs_rq;
+}
+
+/* runqueue on which this entity is (to be) queued */
+static inline struct cfs_rq *cfs_rq_of(struct sched_entity *se)
+{
+	return se->cfs_rq;
+}
+
+/* runqueue "owned" by this group */
+static inline struct cfs_rq *group_cfs_rq(struct sched_entity *grp)
+{
+	return grp->my_q;
+}
+
+/* Given a group's cfs_rq on one cpu, return its corresponding cfs_rq on
+ * another cpu ('this_cpu')
+ */
+static inline struct cfs_rq *cpu_cfs_rq(struct cfs_rq *cfs_rq, int this_cpu)
+{
+	/* A later patch will take group into account */
+	return &cpu_rq(this_cpu)->cfs;
+}
+
+/* Iterate thr' all leaf cfs_rq's on a runqueue */
+#define for_each_leaf_cfs_rq(rq, cfs_rq) \
+	list_for_each_entry(cfs_rq, &rq->leaf_cfs_rq_list, leaf_cfs_rq_list)
+
+/* Do the two (enqueued) tasks belong to the same group ? */
+static inline int is_same_group(struct task_struct *curr, struct task_struct *p)
+{
+	if (curr->se.cfs_rq == p->se.cfs_rq)
+		return 1;
+
+	return 0;
+}
+
+#else	/* CONFIG_FAIR_GROUP_SCHED */
+
+#define for_each_sched_entity(se) \
+		for (; se; se = NULL)
+
 static inline struct cfs_rq *task_cfs_rq(struct task_struct *p)
 {
 	return &task_rq(p)->cfs;
 }
 
+static inline struct cfs_rq *cfs_rq_of(struct sched_entity *se)
+{
+	struct task_struct *p = task_of(se);
+	struct rq *rq = task_rq(p);
+
+	return &rq->cfs;
+}
+
+/* runqueue "owned" by this group */
+static inline struct cfs_rq *group_cfs_rq(struct sched_entity *grp)
+{
+	return NULL;
+}
+
+static inline struct cfs_rq *cpu_cfs_rq(struct cfs_rq *cfs_rq, int this_cpu)
+{
+	return &cpu_rq(this_cpu)->cfs;
+}
+
+#define for_each_leaf_cfs_rq(rq, cfs_rq) \
+		for (cfs_rq = &rq->cfs; cfs_rq; cfs_rq = NULL)
+
+static inline int is_same_group(struct task_struct *curr, struct task_struct *p)
+{
+	return 1;
+}
+
+#endif	/* CONFIG_FAIR_GROUP_SCHED */
+
 /*
  * The enqueue_task method is called before nr_running is
  * increased. Here we update the fair scheduling stats and
@@ -691,10 +773,15 @@ static inline struct cfs_rq *task_cfs_rq
 static void
 enqueue_task_fair(struct rq *rq, struct task_struct *p, int wakeup, u64 now)
 {
-	struct cfs_rq *cfs_rq = task_cfs_rq(p);
+	struct cfs_rq *cfs_rq;
 	struct sched_entity *se = &p->se;
 
-	enqueue_entity(cfs_rq, se, wakeup, now);
+	for_each_sched_entity(se) {
+		if (se->on_rq)
+			break;
+		cfs_rq = cfs_rq_of(se);
+		enqueue_entity(cfs_rq, se, wakeup, now);
+	}
 }
 
 /*
@@ -705,30 +792,32 @@ enqueue_task_fair(struct rq *rq, struct 
 static void
 dequeue_task_fair(struct rq *rq, struct task_struct *p, int sleep, u64 now)
 {
-	struct cfs_rq *cfs_rq = task_cfs_rq(p);
+	struct cfs_rq *cfs_rq;
 	struct sched_entity *se = &p->se;
 
-	dequeue_entity(cfs_rq, se, sleep, now);
+	for_each_sched_entity(se) {
+		cfs_rq = cfs_rq_of(se);
+		dequeue_entity(cfs_rq, se, sleep, now);
+		/* Don't dequeue parent if it has other entities besides us */
+		if (cfs_rq->load.weight)
+			break;
+	}
 }
 
 /*
- * sched_yield() support is very simple via the rbtree: we just
- * dequeue the task and move it after the next task, which
- * causes tasks to roundrobin.
+ * sched_yield() support is very simple - we dequeue and enqueue
  */
 static void yield_task_fair(struct rq *rq, struct task_struct *p)
 {
 	struct cfs_rq *cfs_rq = task_cfs_rq(p);
-	struct sched_entity *se = &p->se;
-	struct rb_node *first, *curr, *next;
+	u64 now = __rq_clock(rq);
 
-	curr = &se->run_node;
-	next = rb_next(curr);
-	first = rb_first(&cfs_rq->tasks_timeline);
-	if ((first == curr) && next)
-		cfs_rq->rb_leftmost = next;
-	else
-		cfs_rq->rb_leftmost = first;
+	/*
+	 * Dequeue and enqueue the task to update its
+	 * position within the tree:
+	 */
+	dequeue_entity(cfs_rq, &p->se, 0, now);
+	enqueue_entity(cfs_rq, &p->se, 0, now);
 }
 
 /*
@@ -741,10 +830,7 @@ static void check_preempt_curr_fair(stru
 	unsigned long gran;
 
 	if (unlikely(rt_prio(p->prio))) {
-		if (sysctl_sched_features & 8) {
-			if (rt_prio(p->prio))
-				update_curr(cfs_rq, rq_clock(rq));
-		}
+		update_curr(cfs_rq, rq_clock(rq));
 		resched_task(curr);
 		return;
 	}
@@ -756,7 +842,8 @@ static void check_preempt_curr_fair(stru
 	if (unlikely(p->policy == SCHED_BATCH))
 		gran = sysctl_sched_batch_wakeup_granularity;
 
-	__check_preempt_curr_fair(cfs_rq, &p->se, &curr->se, gran);
+	if (is_same_group(curr, p))
+		__check_preempt_curr_fair(cfs_rq, &p->se, &curr->se, gran);
 }
 
 static struct task_struct * pick_next_task_fair(struct rq *rq, u64 now)
@@ -767,7 +854,10 @@ static struct task_struct * pick_next_ta
 	if (unlikely(!cfs_rq->nr_running))
 		return NULL;
 
-	se = pick_next_entity(cfs_rq, now);
+	do {
+		se = pick_next_entity(cfs_rq, now);
+		cfs_rq = group_cfs_rq(se);
+	} while (cfs_rq);
 
 	return task_of(se);
 }
@@ -777,7 +867,13 @@ static struct task_struct * pick_next_ta
  */
 static void put_prev_task_fair(struct rq *rq, struct task_struct *prev, u64 now)
 {
-	put_prev_entity(task_cfs_rq(prev), &prev->se, now);
+	struct sched_entity *se = &prev->se;
+	struct cfs_rq *cfs_rq;
+
+	for_each_sched_entity(se) {
+		cfs_rq = cfs_rq_of(se);
+		put_prev_entity(cfs_rq, se, now);
+	}
 }
 
 /**************************************************
@@ -792,7 +888,7 @@ static void put_prev_task_fair(struct rq
  * the current task:
  */
 static inline struct task_struct *
-__load_balance_iterator(struct rq *rq, struct rb_node *curr)
+__load_balance_iterator(struct cfs_rq *cfs_rq, struct rb_node *curr)
 {
 	struct task_struct *p;
 
@@ -800,19 +896,104 @@ __load_balance_iterator(struct rq *rq, s
 		return NULL;
 
 	p = rb_entry(curr, struct task_struct, se.run_node);
-	rq->cfs.rb_load_balance_curr = rb_next(curr);
+	cfs_rq->rb_load_balance_curr = rb_next(curr);
 
 	return p;
 }
 
-static struct task_struct * load_balance_start_fair(struct rq *rq)
+static struct task_struct *load_balance_start_fair(void *arg)
 {
-	return __load_balance_iterator(rq, first_fair(&rq->cfs));
+	struct cfs_rq *cfs_rq = arg;
+
+	return __load_balance_iterator(cfs_rq, first_fair(cfs_rq));
 }
 
-static struct task_struct * load_balance_next_fair(struct rq *rq)
+static struct task_struct *load_balance_next_fair(void *arg)
 {
-	return __load_balance_iterator(rq, rq->cfs.rb_load_balance_curr);
+	struct cfs_rq *cfs_rq = arg;
+
+	return __load_balance_iterator(cfs_rq, cfs_rq->rb_load_balance_curr);
+}
+
+static int cfs_rq_best_prio(struct cfs_rq *cfs_rq)
+{
+	struct sched_entity *curr;
+	struct task_struct *p;
+
+	if (!cfs_rq->nr_running)
+		return MAX_PRIO;
+
+	curr = __pick_next_entity(cfs_rq);
+	p = task_of(curr);
+
+	return p->prio;
+}
+
+static int
+load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
+			unsigned long max_nr_move, unsigned long max_load_move,
+			struct sched_domain *sd, enum cpu_idle_type idle,
+			int *all_pinned, unsigned long *total_load_moved)
+{
+	struct cfs_rq *busy_cfs_rq;
+	unsigned long load_moved, total_nr_moved = 0, nr_moved;
+	long rem_load_move = max_load_move;
+	struct rq_iterator cfs_rq_iterator;
+
+	cfs_rq_iterator.start = load_balance_start_fair;
+	cfs_rq_iterator.next = load_balance_next_fair;
+
+	for_each_leaf_cfs_rq(busiest, busy_cfs_rq) {
+		struct cfs_rq *this_cfs_rq;
+		long imbalance;
+		unsigned long maxload;
+		int this_best_prio, best_prio, best_prio_seen = 0;
+
+		this_cfs_rq = cpu_cfs_rq(busy_cfs_rq, this_cpu);
+
+		imbalance = busy_cfs_rq->load.weight -
+						 this_cfs_rq->load.weight;
+		/* Don't pull if this_cfs_rq has more load than busy_cfs_rq */
+		if (imbalance <= 0)
+			continue;
+
+		/* Don't pull more than imbalance/2 */
+		imbalance /= 2;
+		maxload = min(rem_load_move, imbalance);
+
+		this_best_prio = cfs_rq_best_prio(this_cfs_rq);
+		best_prio = cfs_rq_best_prio(busy_cfs_rq);
+
+		/*
+		 * Enable handling of the case where there is more than one task
+		 * with the best priority. If the current running task is one
+		 * of those with prio==best_prio we know it won't be moved
+		 * and therefore it's safe to override the skip (based on load)
+		 * of any task we find with that prio.
+		 */
+		if (cfs_rq_curr(busy_cfs_rq) == &busiest->curr->se)
+			best_prio_seen = 1;
+
+		/* pass busy_cfs_rq argument into
+		 * load_balance_[start|next]_fair iterators
+		 */
+		cfs_rq_iterator.arg = busy_cfs_rq;
+		nr_moved = balance_tasks(this_rq, this_cpu, busiest,
+				max_nr_move, maxload, sd, idle, all_pinned,
+				&load_moved, this_best_prio, best_prio,
+				best_prio_seen, &cfs_rq_iterator);
+
+		total_nr_moved += nr_moved;
+		max_nr_move -= nr_moved;
+		rem_load_move -= load_moved;
+
+		if (max_nr_move <= 0 || rem_load_move <= 0)
+			break;
+	}
+
+	*total_load_moved = max_load_move - rem_load_move;
+
+	return total_nr_moved;
 }
 
 /*
@@ -820,7 +1001,13 @@ static struct task_struct * load_balance
  */
 static void task_tick_fair(struct rq *rq, struct task_struct *curr)
 {
-	entity_tick(task_cfs_rq(curr), &curr->se);
+	struct cfs_rq *cfs_rq;
+	struct sched_entity *se = &curr->se;
+
+	for_each_sched_entity(se) {
+		cfs_rq = cfs_rq_of(se);
+		entity_tick(cfs_rq, se);
+	}
 }
 
 /*
@@ -844,26 +1031,50 @@ static void task_new_fair(struct rq *rq,
 	 * until it reschedules once. We set up the key so that
 	 * it will preempt the parent:
 	 */
-	p->se.fair_key = current->se.fair_key - niced_granularity(&rq->curr->se,
-						sysctl_sched_granularity) - 1;
+	p->se.fair_key = current->se.fair_key -
+		niced_granularity(&rq->curr->se, sysctl_sched_granularity) - 1;
 	/*
 	 * The first wait is dominated by the child-runs-first logic,
 	 * so do not credit it with that waiting time yet:
 	 */
-	if (sysctl_sched_features & 256)
+	if (sysctl_sched_features & SCHED_FEAT_SKIP_INITIAL)
 		p->se.wait_start_fair = 0;
 
 	/*
 	 * The statistical average of wait_runtime is about
 	 * -granularity/2, so initialize the task with that:
 	 */
-	if (sysctl_sched_features & 128)
-		p->se.wait_runtime = -(s64)(sysctl_sched_granularity / 2);
+	if (sysctl_sched_features & SCHED_FEAT_START_DEBIT)
+		p->se.wait_runtime = -(sysctl_sched_granularity / 2);
 
 	__enqueue_entity(cfs_rq, se);
 	inc_nr_running(p, rq, now);
 }
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+/* Account for a task changing its policy or group.
+ *
+ * This routine is mostly called to set cfs_rq->curr field when a task
+ * migrates between groups/classes.
+ */
+static void set_curr_task_fair(struct rq *rq)
+{
+	struct task_struct *curr = rq->curr;
+	struct sched_entity *se = &curr->se;
+	u64 now = rq_clock(rq);
+	struct cfs_rq *cfs_rq;
+
+	for_each_sched_entity(se) {
+		cfs_rq = cfs_rq_of(se);
+		set_next_entity(cfs_rq, se, now);
+	}
+}
+#else
+static void set_curr_task_fair(struct rq *rq)
+{
+}
+#endif
+
 /*
  * All the scheduling class methods:
  */
@@ -877,8 +1088,20 @@ struct sched_class fair_sched_class __re
 	.pick_next_task		= pick_next_task_fair,
 	.put_prev_task		= put_prev_task_fair,
 
-	.load_balance_start	= load_balance_start_fair,
-	.load_balance_next	= load_balance_next_fair,
+	.load_balance		= load_balance_fair,
+
+	.set_curr_task          = set_curr_task_fair,
 	.task_tick		= task_tick_fair,
 	.task_new		= task_new_fair,
 };
+
+#ifdef CONFIG_SCHED_DEBUG
+void print_cfs_stats(struct seq_file *m, int cpu, u64 now)
+{
+	struct rq *rq = cpu_rq(cpu);
+	struct cfs_rq *cfs_rq;
+
+	for_each_leaf_cfs_rq(rq, cfs_rq)
+		print_cfs_rq(m, cpu, cfs_rq, now);
+}
+#endif
diff -puN kernel/sched_idletask.c~cfs-v19 kernel/sched_idletask.c
--- a/kernel/sched_idletask.c~cfs-v19
+++ a/kernel/sched_idletask.c
@@ -37,9 +37,13 @@ static void put_prev_task_idle(struct rq
 {
 }
 
-static struct task_struct *load_balance_start_idle(struct rq *rq)
+static int
+load_balance_idle(struct rq *this_rq, int this_cpu, struct rq *busiest,
+			unsigned long max_nr_move, unsigned long max_load_move,
+			struct sched_domain *sd, enum cpu_idle_type idle,
+			int *all_pinned, unsigned long *total_load_moved)
 {
-	return NULL;
+	return 0;
 }
 
 static void task_tick_idle(struct rq *rq, struct task_struct *curr)
@@ -49,7 +53,7 @@ static void task_tick_idle(struct rq *rq
 /*
  * Simple, special scheduling class for the per-CPU idle tasks:
  */
-struct sched_class idle_sched_class __read_mostly = {
+static struct sched_class idle_sched_class __read_mostly = {
 	/* no enqueue/yield_task for idle tasks */
 
 	/* dequeue is not valid, we print a debug message there: */
@@ -60,8 +64,7 @@ struct sched_class idle_sched_class __re
 	.pick_next_task		= pick_next_task_idle,
 	.put_prev_task		= put_prev_task_idle,
 
-	.load_balance_start	= load_balance_start_idle,
-	/* no .load_balance_next for idle tasks */
+	.load_balance		= load_balance_idle,
 
 	.task_tick		= task_tick_idle,
 	/* no .task_new for idle tasks */
diff -puN kernel/sched_rt.c~cfs-v19 kernel/sched_rt.c
--- a/kernel/sched_rt.c~cfs-v19
+++ a/kernel/sched_rt.c
@@ -12,7 +12,7 @@ static inline void update_curr_rt(struct
 	struct task_struct *curr = rq->curr;
 	u64 delta_exec;
 
-	if (!has_rt_policy(curr))
+	if (!task_has_rt_policy(curr))
 		return;
 
 	delta_exec = now - curr->se.exec_start;
@@ -107,8 +107,9 @@ static void put_prev_task_rt(struct rq *
  * achieve that by always pre-iterating before returning
  * the current task:
  */
-static struct task_struct * load_balance_start_rt(struct rq *rq)
+static struct task_struct *load_balance_start_rt(void *arg)
 {
+	struct rq *rq = arg;
 	struct prio_array *array = &rq->rt.active;
 	struct list_head *head, *curr;
 	struct task_struct *p;
@@ -132,8 +133,9 @@ static struct task_struct * load_balance
 	return p;
 }
 
-static struct task_struct * load_balance_next_rt(struct rq *rq)
+static struct task_struct *load_balance_next_rt(void *arg)
 {
+	struct rq *rq = arg;
 	struct prio_array *array = &rq->rt.active;
 	struct list_head *head, *curr;
 	struct task_struct *p;
@@ -170,6 +172,44 @@ static struct task_struct * load_balance
 	return p;
 }
 
+static int
+load_balance_rt(struct rq *this_rq, int this_cpu, struct rq *busiest,
+			unsigned long max_nr_move, unsigned long max_load_move,
+			struct sched_domain *sd, enum cpu_idle_type idle,
+			int *all_pinned, unsigned long *load_moved)
+{
+	int this_best_prio, best_prio, best_prio_seen = 0;
+	int nr_moved;
+	struct rq_iterator rt_rq_iterator;
+
+	best_prio = sched_find_first_bit(busiest->rt.active.bitmap);
+	this_best_prio = sched_find_first_bit(this_rq->rt.active.bitmap);
+
+	/*
+	 * Enable handling of the case where there is more than one task
+	 * with the best priority.   If the current running task is one
+	 * of those with prio==best_prio we know it won't be moved
+	 * and therefore it's safe to override the skip (based on load)
+	 * of any task we find with that prio.
+	 */
+	if (busiest->curr->prio == best_prio)
+		best_prio_seen = 1;
+
+	rt_rq_iterator.start = load_balance_start_rt;
+	rt_rq_iterator.next = load_balance_next_rt;
+	/* pass 'busiest' rq argument into
+	 * load_balance_[start|next]_rt iterators
+	 */
+	rt_rq_iterator.arg = busiest;
+
+	nr_moved = balance_tasks(this_rq, this_cpu, busiest, max_nr_move,
+			max_load_move, sd, idle, all_pinned, load_moved,
+			this_best_prio, best_prio, best_prio_seen,
+			&rt_rq_iterator);
+
+	return nr_moved;
+}
+
 static void task_tick_rt(struct rq *rq, struct task_struct *p)
 {
 	/*
@@ -179,13 +219,14 @@ static void task_tick_rt(struct rq *rq, 
 	if (p->policy != SCHED_RR)
 		return;
 
-	if (!(--p->time_slice)) {
-		p->time_slice = static_prio_timeslice(p->static_prio);
-		set_tsk_need_resched(p);
+	if (--p->time_slice)
+		return;
 
-		/* put it at the end of the queue: */
-		requeue_task_rt(rq, p);
-	}
+	p->time_slice = static_prio_timeslice(p->static_prio);
+	set_tsk_need_resched(p);
+
+	/* put it at the end of the queue: */
+	requeue_task_rt(rq, p);
 }
 
 /*
@@ -207,8 +248,7 @@ static struct sched_class rt_sched_class
 	.pick_next_task		= pick_next_task_rt,
 	.put_prev_task		= put_prev_task_rt,
 
-	.load_balance_start	= load_balance_start_rt,
-	.load_balance_next	= load_balance_next_rt,
+	.load_balance		= load_balance_rt,
 
 	.task_tick		= task_tick_rt,
 	.task_new		= task_new_rt,
diff -puN lib/Kconfig.debug~cfs-v19 lib/Kconfig.debug
--- a/lib/Kconfig.debug~cfs-v19
+++ a/lib/Kconfig.debug
@@ -105,6 +105,15 @@ config DETECT_SOFTLOCKUP
 	   can be detected via the NMI-watchdog, on platforms that
 	   support it.)
 
+config SCHED_DEBUG
+	bool "Collect scheduler debugging info"
+	depends on DEBUG_KERNEL && PROC_FS
+	default y
+	help
+	  If you say Y here, the /proc/sched_debug file will be provided
+	  that can help debug the scheduler. The runtime overhead of this
+	  option is minimal.
+
 config SCHEDSTATS
 	bool "Collect scheduler statistics"
 	depends on DEBUG_KERNEL && PROC_FS
diff -puN Makefile~cfs-v19 Makefile
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
