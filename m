From: akpm@linux-foundation.org
Subject: [merged] cpusetmm-update-tasks-mems_allowed-in-time.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:33:25 -0700
Message-ID: <200906171833.n5HIXPLn031947@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759735AbZFQSeH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:34:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miaox@cn.fujitsu.com, a.p.zijlstra@chello.nl, cl@linux-foundation.org, lee.schermerhorn@hp.com, menage@google.com, mingo@elte.hu, nickpiggin@yahoo.com.au, penberg@cs.helsinki.fi, rien


The patch titled
     cpuset,mm: update tasks' mems_allowed in time
has been removed from the -mm tree.  Its filename was
     cpusetmm-update-tasks-mems_allowed-in-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuset,mm: update tasks' mems_allowed in time
From: Miao Xie <miaox@cn.fujitsu.com>

Fix allocating page cache/slab object on the unallowed node when memory
spread is set by updating tasks' mems_allowed after its cpuset's mems is
changed.

In order to update tasks' mems_allowed in time, we must modify the code of
memory policy.  Because the memory policy is applied in the process's
context originally.  After applying this patch, one task directly
manipulates anothers mems_allowed, and we use alloc_lock in the
task_struct to protect mems_allowed and memory policy of the task.

But in the fast path, we didn't use lock to protect them, because adding a
lock may lead to performance regression.  But if we don't add a lock,the
task might see no nodes when changing cpuset's mems_allowed to some
non-overlapping set.  In order to avoid it, we set all new allowed nodes,
then clear newly disallowed ones.

[lee.schermerhorn@hp.com:
  The rework of mpol_new() to extract the adjusting of the node mask to
  apply cpuset and mpol flags "context" breaks set_mempolicy() and mbind()
  with MPOL_PREFERRED and a NULL nodemask--i.e., explicit local
  allocation.  Fix this by adding the check for MPOL_PREFERRED and empty
  node mask to mpol_new_mpolicy().

  Remove the now unneeded 'nodes = NULL' from mpol_new().

  Note that mpol_new_mempolicy() is always called with a non-NULL
  'nodes' parameter now that it has been removed from mpol_new(). 
  Therefore, we don't need to test nodes for NULL before testing it for
  'empty'.  However, just to be extra paranoid, add a VM_BUG_ON() to
  verify this assumption.]
[lee.schermerhorn@hp.com:

  I don't think the function name 'mpol_new_mempolicy' is descriptive
  enough to differentiate it from mpol_new().

  This function applies cpuset set context, usually constraining nodes
  to those allowed by the cpuset.  However, when the 'RELATIVE_NODES flag
  is set, it also translates the nodes.  So I settled on
  'mpol_set_nodemask()', because the comment block for mpol_new() mentions
  that we need to call this function to "set nodes".

  Some additional minor line length, whitespace and typo cleanup.]
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Paul Menage <menage@google.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpuset.h |   13 +-
 include/linux/sched.h  |    8 -
 init/main.c            |    6 +
 kernel/cpuset.c        |  184 +++++++++------------------------------
 kernel/kthread.c       |    2 
 mm/mempolicy.c         |  143 +++++++++++++++++++++---------
 mm/page_alloc.c        |    5 -
 7 files changed, 170 insertions(+), 191 deletions(-)

diff -puN include/linux/cpuset.h~cpusetmm-update-tasks-mems_allowed-in-time include/linux/cpuset.h
--- a/include/linux/cpuset.h~cpusetmm-update-tasks-mems_allowed-in-time
+++ a/include/linux/cpuset.h
@@ -18,7 +18,6 @@
 
 extern int number_of_cpusets;	/* How many cpusets are defined in system? */
 
-extern int cpuset_init_early(void);
 extern int cpuset_init(void);
 extern void cpuset_init_smp(void);
 extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
@@ -27,7 +26,6 @@ extern void cpuset_cpus_allowed_locked(s
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
 #define cpuset_current_mems_allowed (current->mems_allowed)
 void cpuset_init_current_mems_allowed(void);
-void cpuset_update_task_memory_state(void);
 int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask);
 
 extern int __cpuset_node_allowed_softwall(int node, gfp_t gfp_mask);
@@ -92,9 +90,13 @@ extern void rebuild_sched_domains(void);
 
 extern void cpuset_print_task_mems_allowed(struct task_struct *p);
 
+static inline void set_mems_allowed(nodemask_t nodemask)
+{
+	current->mems_allowed = nodemask;
+}
+
 #else /* !CONFIG_CPUSETS */
 
-static inline int cpuset_init_early(void) { return 0; }
 static inline int cpuset_init(void) { return 0; }
 static inline void cpuset_init_smp(void) {}
 
@@ -116,7 +118,6 @@ static inline nodemask_t cpuset_mems_all
 
 #define cpuset_current_mems_allowed (node_states[N_HIGH_MEMORY])
 static inline void cpuset_init_current_mems_allowed(void) {}
-static inline void cpuset_update_task_memory_state(void) {}
 
 static inline int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask)
 {
@@ -188,6 +189,10 @@ static inline void cpuset_print_task_mem
 {
 }
 
+static inline void set_mems_allowed(nodemask_t nodemask)
+{
+}
+
 #endif /* !CONFIG_CPUSETS */
 
 #endif /* _LINUX_CPUSET_H */
diff -puN include/linux/sched.h~cpusetmm-update-tasks-mems_allowed-in-time include/linux/sched.h
--- a/include/linux/sched.h~cpusetmm-update-tasks-mems_allowed-in-time
+++ a/include/linux/sched.h
@@ -1318,7 +1318,8 @@ struct task_struct {
 /* Thread group tracking */
    	u32 parent_exec_id;
    	u32 self_exec_id;
-/* Protection of (de-)allocation: mm, files, fs, tty, keyrings */
+/* Protection of (de-)allocation: mm, files, fs, tty, keyrings, mems_allowed,
+ * mempolicy */
 	spinlock_t alloc_lock;
 
 #ifdef CONFIG_GENERIC_HARDIRQS
@@ -1386,8 +1387,7 @@ struct task_struct {
 	cputime_t acct_timexpd;	/* stime + utime since last update */
 #endif
 #ifdef CONFIG_CPUSETS
-	nodemask_t mems_allowed;
-	int cpuset_mems_generation;
+	nodemask_t mems_allowed;	/* Protected by alloc_lock */
 	int cpuset_mem_spread_rotor;
 #endif
 #ifdef CONFIG_CGROUPS
@@ -1410,7 +1410,7 @@ struct task_struct {
 	struct list_head perf_counter_list;
 #endif
 #ifdef CONFIG_NUMA
-	struct mempolicy *mempolicy;
+	struct mempolicy *mempolicy;	/* Protected by alloc_lock */
 	short il_next;
 #endif
 	atomic_t fs_excl;	/* holding fs exclusive resources */
diff -puN init/main.c~cpusetmm-update-tasks-mems_allowed-in-time init/main.c
--- a/init/main.c~cpusetmm-update-tasks-mems_allowed-in-time
+++ a/init/main.c
@@ -670,7 +670,6 @@ asmlinkage void __init start_kernel(void
 		initrd_start = 0;
 	}
 #endif
-	cpuset_init_early();
 	page_cgroup_init();
 	enable_debug_pagealloc();
 	cpu_hotplug_init();
@@ -867,6 +866,11 @@ static noinline int init_post(void)
 static int __init kernel_init(void * unused)
 {
 	lock_kernel();
+
+	/*
+	 * init can allocate pages on any node
+	 */
+	set_mems_allowed(node_possible_map);
 	/*
 	 * init can run on any cpu.
 	 */
diff -puN kernel/cpuset.c~cpusetmm-update-tasks-mems_allowed-in-time kernel/cpuset.c
--- a/kernel/cpuset.c~cpusetmm-update-tasks-mems_allowed-in-time
+++ a/kernel/cpuset.c
@@ -97,12 +97,6 @@ struct cpuset {
 
 	struct cpuset *parent;		/* my parent */
 
-	/*
-	 * Copy of global cpuset_mems_generation as of the most
-	 * recent time this cpuset changed its mems_allowed.
-	 */
-	int mems_generation;
-
 	struct fmeter fmeter;		/* memory_pressure filter */
 
 	/* partition number for rebuild_sched_domains() */
@@ -176,27 +170,6 @@ static inline int is_spread_slab(const s
 	return test_bit(CS_SPREAD_SLAB, &cs->flags);
 }
 
-/*
- * Increment this integer everytime any cpuset changes its
- * mems_allowed value.  Users of cpusets can track this generation
- * number, and avoid having to lock and reload mems_allowed unless
- * the cpuset they're using changes generation.
- *
- * A single, global generation is needed because cpuset_attach_task() could
- * reattach a task to a different cpuset, which must not have its
- * generation numbers aliased with those of that tasks previous cpuset.
- *
- * Generations are needed for mems_allowed because one task cannot
- * modify another's memory placement.  So we must enable every task,
- * on every visit to __alloc_pages(), to efficiently check whether
- * its current->cpuset->mems_allowed has changed, requiring an update
- * of its current->mems_allowed.
- *
- * Since writes to cpuset_mems_generation are guarded by the cgroup lock
- * there is no need to mark it atomic.
- */
-static int cpuset_mems_generation;
-
 static struct cpuset top_cpuset = {
 	.flags = ((1 << CS_CPU_EXCLUSIVE) | (1 << CS_MEM_EXCLUSIVE)),
 };
@@ -228,8 +201,9 @@ static struct cpuset top_cpuset = {
  * If a task is only holding callback_mutex, then it has read-only
  * access to cpusets.
  *
- * The task_struct fields mems_allowed and mems_generation may only
- * be accessed in the context of that task, so require no locks.
+ * Now, the task_struct fields mems_allowed and mempolicy may be changed
+ * by other task, we use alloc_lock in the task_struct fields to protect
+ * them.
  *
  * The cpuset_common_file_read() handlers only hold callback_mutex across
  * small pieces of code, such as when reading out possibly multi-word
@@ -349,69 +323,6 @@ static void cpuset_update_task_spread_fl
 		tsk->flags &= ~PF_SPREAD_SLAB;
 }
 
-/**
- * cpuset_update_task_memory_state - update task memory placement
- *
- * If the current tasks cpusets mems_allowed changed behind our
- * backs, update current->mems_allowed, mems_generation and task NUMA
- * mempolicy to the new value.
- *
- * Task mempolicy is updated by rebinding it relative to the
- * current->cpuset if a task has its memory placement changed.
- * Do not call this routine if in_interrupt().
- *
- * Call without callback_mutex or task_lock() held.  May be
- * called with or without cgroup_mutex held.  Thanks in part to
- * 'the_top_cpuset_hack', the task's cpuset pointer will never
- * be NULL.  This routine also might acquire callback_mutex during
- * call.
- *
- * Reading current->cpuset->mems_generation doesn't need task_lock
- * to guard the current->cpuset derefence, because it is guarded
- * from concurrent freeing of current->cpuset using RCU.
- *
- * The rcu_dereference() is technically probably not needed,
- * as I don't actually mind if I see a new cpuset pointer but
- * an old value of mems_generation.  However this really only
- * matters on alpha systems using cpusets heavily.  If I dropped
- * that rcu_dereference(), it would save them a memory barrier.
- * For all other arch's, rcu_dereference is a no-op anyway, and for
- * alpha systems not using cpusets, another planned optimization,
- * avoiding the rcu critical section for tasks in the root cpuset
- * which is statically allocated, so can't vanish, will make this
- * irrelevant.  Better to use RCU as intended, than to engage in
- * some cute trick to save a memory barrier that is impossible to
- * test, for alpha systems using cpusets heavily, which might not
- * even exist.
- *
- * This routine is needed to update the per-task mems_allowed data,
- * within the tasks context, when it is trying to allocate memory
- * (in various mm/mempolicy.c routines) and notices that some other
- * task has been modifying its cpuset.
- */
-
-void cpuset_update_task_memory_state(void)
-{
-	int my_cpusets_mem_gen;
-	struct task_struct *tsk = current;
-	struct cpuset *cs;
-
-	rcu_read_lock();
-	my_cpusets_mem_gen = task_cs(tsk)->mems_generation;
-	rcu_read_unlock();
-
-	if (my_cpusets_mem_gen != tsk->cpuset_mems_generation) {
-		mutex_lock(&callback_mutex);
-		task_lock(tsk);
-		cs = task_cs(tsk); /* Maybe changed when task not locked */
-		guarantee_online_mems(cs, &tsk->mems_allowed);
-		tsk->cpuset_mems_generation = cs->mems_generation;
-		task_unlock(tsk);
-		mutex_unlock(&callback_mutex);
-		mpol_rebind_task(tsk, &tsk->mems_allowed);
-	}
-}
-
 /*
  * is_cpuset_subset(p, q) - Is cpuset p a subset of cpuset q?
  *
@@ -1017,14 +928,6 @@ static int update_cpumask(struct cpuset 
  *    other task, the task_struct mems_allowed that we are hacking
  *    is for our current task, which must allocate new pages for that
  *    migrating memory region.
- *
- *    We call cpuset_update_task_memory_state() before hacking
- *    our tasks mems_allowed, so that we are assured of being in
- *    sync with our tasks cpuset, and in particular, callbacks to
- *    cpuset_update_task_memory_state() from nested page allocations
- *    won't see any mismatch of our cpuset and task mems_generation
- *    values, so won't overwrite our hacked tasks mems_allowed
- *    nodemask.
  */
 
 static void cpuset_migrate_mm(struct mm_struct *mm, const nodemask_t *from,
@@ -1032,22 +935,37 @@ static void cpuset_migrate_mm(struct mm_
 {
 	struct task_struct *tsk = current;
 
-	cpuset_update_task_memory_state();
-
-	mutex_lock(&callback_mutex);
 	tsk->mems_allowed = *to;
-	mutex_unlock(&callback_mutex);
 
 	do_migrate_pages(mm, from, to, MPOL_MF_MOVE_ALL);
 
-	mutex_lock(&callback_mutex);
 	guarantee_online_mems(task_cs(tsk),&tsk->mems_allowed);
-	mutex_unlock(&callback_mutex);
 }
 
 /*
- * Rebind task's vmas to cpuset's new mems_allowed, and migrate pages to new
- * nodes if memory_migrate flag is set. Called with cgroup_mutex held.
+ * cpuset_change_task_nodemask - change task's mems_allowed and mempolicy
+ * @tsk: the task to change
+ * @newmems: new nodes that the task will be set
+ *
+ * In order to avoid seeing no nodes if the old and new nodes are disjoint,
+ * we structure updates as setting all new allowed nodes, then clearing newly
+ * disallowed ones.
+ *
+ * Called with task's alloc_lock held
+ */
+static void cpuset_change_task_nodemask(struct task_struct *tsk,
+					nodemask_t *newmems)
+{
+	nodes_or(tsk->mems_allowed, tsk->mems_allowed, *newmems);
+	mpol_rebind_task(tsk, &tsk->mems_allowed);
+	mpol_rebind_task(tsk, newmems);
+	tsk->mems_allowed = *newmems;
+}
+
+/*
+ * Update task's mems_allowed and rebind its mempolicy and vmas' mempolicy
+ * of it to cpuset's new mems_allowed, and migrate pages to new nodes if
+ * memory_migrate flag is set. Called with cgroup_mutex held.
  */
 static void cpuset_change_nodemask(struct task_struct *p,
 				   struct cgroup_scanner *scan)
@@ -1056,12 +974,19 @@ static void cpuset_change_nodemask(struc
 	struct cpuset *cs;
 	int migrate;
 	const nodemask_t *oldmem = scan->data;
+	nodemask_t newmems;
+
+	cs = cgroup_cs(scan->cg);
+	guarantee_online_mems(cs, &newmems);
+
+	task_lock(p);
+	cpuset_change_task_nodemask(p, &newmems);
+	task_unlock(p);
 
 	mm = get_task_mm(p);
 	if (!mm)
 		return;
 
-	cs = cgroup_cs(scan->cg);
 	migrate = is_memory_migrate(cs);
 
 	mpol_rebind_mm(mm, &cs->mems_allowed);
@@ -1114,10 +1039,10 @@ static void update_tasks_nodemask(struct
 /*
  * Handle user request to change the 'mems' memory placement
  * of a cpuset.  Needs to validate the request, update the
- * cpusets mems_allowed and mems_generation, and for each
- * task in the cpuset, rebind any vma mempolicies and if
- * the cpuset is marked 'memory_migrate', migrate the tasks
- * pages to the new memory.
+ * cpusets mems_allowed, and for each task in the cpuset,
+ * update mems_allowed and rebind task's mempolicy and any vma
+ * mempolicies and if the cpuset is marked 'memory_migrate',
+ * migrate the tasks pages to the new memory.
  *
  * Call with cgroup_mutex held.  May take callback_mutex during call.
  * Will take tasklist_lock, scan tasklist for tasks in cpuset cs,
@@ -1170,7 +1095,6 @@ static int update_nodemask(struct cpuset
 
 	mutex_lock(&callback_mutex);
 	cs->mems_allowed = trialcs->mems_allowed;
-	cs->mems_generation = cpuset_mems_generation++;
 	mutex_unlock(&callback_mutex);
 
 	update_tasks_nodemask(cs, &oldmem, &heap);
@@ -1434,15 +1358,18 @@ static void cpuset_attach(struct cgroup_
 
 	if (cs == &top_cpuset) {
 		cpumask_copy(cpus_attach, cpu_possible_mask);
+		to = node_possible_map;
 	} else {
-		mutex_lock(&callback_mutex);
 		guarantee_online_cpus(cs, cpus_attach);
-		mutex_unlock(&callback_mutex);
+		guarantee_online_mems(cs, &to);
 	}
 	err = set_cpus_allowed_ptr(tsk, cpus_attach);
 	if (err)
 		return;
 
+	task_lock(tsk);
+	cpuset_change_task_nodemask(tsk, &to);
+	task_unlock(tsk);
 	cpuset_update_task_spread_flag(cs, tsk);
 
 	from = oldcs->mems_allowed;
@@ -1848,8 +1775,6 @@ static struct cgroup_subsys_state *cpuse
 	struct cpuset *parent;
 
 	if (!cont->parent) {
-		/* This is early initialization for the top cgroup */
-		top_cpuset.mems_generation = cpuset_mems_generation++;
 		return &top_cpuset.css;
 	}
 	parent = cgroup_cs(cont->parent);
@@ -1861,7 +1786,6 @@ static struct cgroup_subsys_state *cpuse
 		return ERR_PTR(-ENOMEM);
 	}
 
-	cpuset_update_task_memory_state();
 	cs->flags = 0;
 	if (is_spread_page(parent))
 		set_bit(CS_SPREAD_PAGE, &cs->flags);
@@ -1870,7 +1794,6 @@ static struct cgroup_subsys_state *cpuse
 	set_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
 	cpumask_clear(cs->cpus_allowed);
 	nodes_clear(cs->mems_allowed);
-	cs->mems_generation = cpuset_mems_generation++;
 	fmeter_init(&cs->fmeter);
 	cs->relax_domain_level = -1;
 
@@ -1889,8 +1812,6 @@ static void cpuset_destroy(struct cgroup
 {
 	struct cpuset *cs = cgroup_cs(cont);
 
-	cpuset_update_task_memory_state();
-
 	if (is_sched_load_balance(cs))
 		update_flag(CS_SCHED_LOAD_BALANCE, cs, 0);
 
@@ -1911,21 +1832,6 @@ struct cgroup_subsys cpuset_subsys = {
 	.early_init = 1,
 };
 
-/*
- * cpuset_init_early - just enough so that the calls to
- * cpuset_update_task_memory_state() in early init code
- * are harmless.
- */
-
-int __init cpuset_init_early(void)
-{
-	alloc_cpumask_var(&top_cpuset.cpus_allowed, GFP_NOWAIT);
-
-	top_cpuset.mems_generation = cpuset_mems_generation++;
-	return 0;
-}
-
-
 /**
  * cpuset_init - initialize cpusets at system boot
  *
@@ -1936,11 +1842,13 @@ int __init cpuset_init(void)
 {
 	int err = 0;
 
+	if (!alloc_cpumask_var(&top_cpuset.cpus_allowed, GFP_KERNEL))
+		BUG();
+
 	cpumask_setall(top_cpuset.cpus_allowed);
 	nodes_setall(top_cpuset.mems_allowed);
 
 	fmeter_init(&top_cpuset.fmeter);
-	top_cpuset.mems_generation = cpuset_mems_generation++;
 	set_bit(CS_SCHED_LOAD_BALANCE, &top_cpuset.flags);
 	top_cpuset.relax_domain_level = -1;
 
diff -puN kernel/kthread.c~cpusetmm-update-tasks-mems_allowed-in-time kernel/kthread.c
--- a/kernel/kthread.c~cpusetmm-update-tasks-mems_allowed-in-time
+++ a/kernel/kthread.c
@@ -9,6 +9,7 @@
 #include <linux/kthread.h>
 #include <linux/completion.h>
 #include <linux/err.h>
+#include <linux/cpuset.h>
 #include <linux/unistd.h>
 #include <linux/file.h>
 #include <linux/module.h>
@@ -236,6 +237,7 @@ int kthreadd(void *unused)
 	ignore_signals(tsk);
 	set_user_nice(tsk, KTHREAD_NICE_LEVEL);
 	set_cpus_allowed_ptr(tsk, cpu_all_mask);
+	set_mems_allowed(node_possible_map);
 
 	current->flags |= PF_NOFREEZE | PF_FREEZER_NOSIG;
 
diff -puN mm/mempolicy.c~cpusetmm-update-tasks-mems_allowed-in-time mm/mempolicy.c
--- a/mm/mempolicy.c~cpusetmm-update-tasks-mems_allowed-in-time
+++ a/mm/mempolicy.c
@@ -182,13 +182,54 @@ static int mpol_new_bind(struct mempolic
 	return 0;
 }
 
-/* Create a new policy */
+/*
+ * mpol_set_nodemask is called after mpol_new() to set up the nodemask, if
+ * any, for the new policy.  mpol_new() has already validated the nodes
+ * parameter with respect to the policy mode and flags.  But, we need to
+ * handle an empty nodemask with MPOL_PREFERRED here.
+ *
+ * Must be called holding task's alloc_lock to protect task's mems_allowed
+ * and mempolicy.  May also be called holding the mmap_semaphore for write.
+ */
+static int mpol_set_nodemask(struct mempolicy *pol, const nodemask_t *nodes)
+{
+	nodemask_t cpuset_context_nmask;
+	int ret;
+
+	/* if mode is MPOL_DEFAULT, pol is NULL. This is right. */
+	if (pol == NULL)
+		return 0;
+
+	VM_BUG_ON(!nodes);
+	if (pol->mode == MPOL_PREFERRED && nodes_empty(*nodes))
+		nodes = NULL;	/* explicit local allocation */
+	else {
+		if (pol->flags & MPOL_F_RELATIVE_NODES)
+			mpol_relative_nodemask(&cpuset_context_nmask, nodes,
+					       &cpuset_current_mems_allowed);
+		else
+			nodes_and(cpuset_context_nmask, *nodes,
+				  cpuset_current_mems_allowed);
+		if (mpol_store_user_nodemask(pol))
+			pol->w.user_nodemask = *nodes;
+		else
+			pol->w.cpuset_mems_allowed =
+						cpuset_current_mems_allowed;
+	}
+
+	ret = mpol_ops[pol->mode].create(pol,
+				nodes ? &cpuset_context_nmask : NULL);
+	return ret;
+}
+
+/*
+ * This function just creates a new policy, does some check and simple
+ * initialization. You must invoke mpol_set_nodemask() to set nodes.
+ */
 static struct mempolicy *mpol_new(unsigned short mode, unsigned short flags,
 				  nodemask_t *nodes)
 {
 	struct mempolicy *policy;
-	nodemask_t cpuset_context_nmask;
-	int ret;
 
 	pr_debug("setting mode %d flags %d nodes[0] %lx\n",
 		 mode, flags, nodes ? nodes_addr(*nodes)[0] : -1);
@@ -210,7 +251,6 @@ static struct mempolicy *mpol_new(unsign
 			if (((flags & MPOL_F_STATIC_NODES) ||
 			     (flags & MPOL_F_RELATIVE_NODES)))
 				return ERR_PTR(-EINVAL);
-			nodes = NULL;	/* flag local alloc */
 		}
 	} else if (nodes_empty(*nodes))
 		return ERR_PTR(-EINVAL);
@@ -221,30 +261,6 @@ static struct mempolicy *mpol_new(unsign
 	policy->mode = mode;
 	policy->flags = flags;
 
-	if (nodes) {
-		/*
-		 * cpuset related setup doesn't apply to local allocation
-		 */
-		cpuset_update_task_memory_state();
-		if (flags & MPOL_F_RELATIVE_NODES)
-			mpol_relative_nodemask(&cpuset_context_nmask, nodes,
-					       &cpuset_current_mems_allowed);
-		else
-			nodes_and(cpuset_context_nmask, *nodes,
-				  cpuset_current_mems_allowed);
-		if (mpol_store_user_nodemask(policy))
-			policy->w.user_nodemask = *nodes;
-		else
-			policy->w.cpuset_mems_allowed =
-						cpuset_mems_allowed(current);
-	}
-
-	ret = mpol_ops[mode].create(policy,
-				nodes ? &cpuset_context_nmask : NULL);
-	if (ret < 0) {
-		kmem_cache_free(policy_cache, policy);
-		return ERR_PTR(ret);
-	}
 	return policy;
 }
 
@@ -324,6 +340,8 @@ static void mpol_rebind_policy(struct me
 /*
  * Wrapper for mpol_rebind_policy() that just requires task
  * pointer, and updates task mempolicy.
+ *
+ * Called with task's alloc_lock held.
  */
 
 void mpol_rebind_task(struct task_struct *tsk, const nodemask_t *new)
@@ -600,8 +618,9 @@ static void mpol_set_task_struct_flag(vo
 static long do_set_mempolicy(unsigned short mode, unsigned short flags,
 			     nodemask_t *nodes)
 {
-	struct mempolicy *new;
+	struct mempolicy *new, *old;
 	struct mm_struct *mm = current->mm;
+	int ret;
 
 	new = mpol_new(mode, flags, nodes);
 	if (IS_ERR(new))
@@ -615,20 +634,33 @@ static long do_set_mempolicy(unsigned sh
 	 */
 	if (mm)
 		down_write(&mm->mmap_sem);
-	mpol_put(current->mempolicy);
+	task_lock(current);
+	ret = mpol_set_nodemask(new, nodes);
+	if (ret) {
+		task_unlock(current);
+		if (mm)
+			up_write(&mm->mmap_sem);
+		mpol_put(new);
+		return ret;
+	}
+	old = current->mempolicy;
 	current->mempolicy = new;
 	mpol_set_task_struct_flag();
 	if (new && new->mode == MPOL_INTERLEAVE &&
 	    nodes_weight(new->v.nodes))
 		current->il_next = first_node(new->v.nodes);
+	task_unlock(current);
 	if (mm)
 		up_write(&mm->mmap_sem);
 
+	mpol_put(old);
 	return 0;
 }
 
 /*
  * Return nodemask for policy for get_mempolicy() query
+ *
+ * Called with task's alloc_lock held
  */
 static void get_policy_nodemask(struct mempolicy *p, nodemask_t *nodes)
 {
@@ -674,7 +706,6 @@ static long do_get_mempolicy(int *policy
 	struct vm_area_struct *vma = NULL;
 	struct mempolicy *pol = current->mempolicy;
 
-	cpuset_update_task_memory_state();
 	if (flags &
 		~(unsigned long)(MPOL_F_NODE|MPOL_F_ADDR|MPOL_F_MEMS_ALLOWED))
 		return -EINVAL;
@@ -683,7 +714,9 @@ static long do_get_mempolicy(int *policy
 		if (flags & (MPOL_F_NODE|MPOL_F_ADDR))
 			return -EINVAL;
 		*policy = 0;	/* just so it's initialized */
+		task_lock(current);
 		*nmask  = cpuset_current_mems_allowed;
+		task_unlock(current);
 		return 0;
 	}
 
@@ -738,8 +771,11 @@ static long do_get_mempolicy(int *policy
 	}
 
 	err = 0;
-	if (nmask)
+	if (nmask) {
+		task_lock(current);
 		get_policy_nodemask(pol, nmask);
+		task_unlock(current);
+	}
 
  out:
 	mpol_cond_put(pol);
@@ -979,6 +1015,14 @@ static long do_mbind(unsigned long start
 			return err;
 	}
 	down_write(&mm->mmap_sem);
+	task_lock(current);
+	err = mpol_set_nodemask(new, nmask);
+	task_unlock(current);
+	if (err) {
+		up_write(&mm->mmap_sem);
+		mpol_put(new);
+		return err;
+	}
 	vma = check_range(mm, start, end, nmask,
 			  flags | MPOL_MF_INVERT, &pagelist);
 
@@ -1545,8 +1589,6 @@ alloc_page_vma(gfp_t gfp, struct vm_area
 	struct mempolicy *pol = get_vma_policy(current, vma, addr);
 	struct zonelist *zl;
 
-	cpuset_update_task_memory_state();
-
 	if (unlikely(pol->mode == MPOL_INTERLEAVE)) {
 		unsigned nid;
 
@@ -1593,8 +1635,6 @@ struct page *alloc_pages_current(gfp_t g
 {
 	struct mempolicy *pol = current->mempolicy;
 
-	if ((gfp & __GFP_WAIT) && !in_interrupt())
-		cpuset_update_task_memory_state();
 	if (!pol || in_interrupt() || (gfp & __GFP_THISNODE))
 		pol = &default_policy;
 
@@ -1854,6 +1894,8 @@ restart:
  */
 void mpol_shared_policy_init(struct shared_policy *sp, struct mempolicy *mpol)
 {
+	int ret;
+
 	sp->root = RB_ROOT;		/* empty tree == default mempolicy */
 	spin_lock_init(&sp->lock);
 
@@ -1863,9 +1905,19 @@ void mpol_shared_policy_init(struct shar
 
 		/* contextualize the tmpfs mount point mempolicy */
 		new = mpol_new(mpol->mode, mpol->flags, &mpol->w.user_nodemask);
-		mpol_put(mpol);	/* drop our ref on sb mpol */
-		if (IS_ERR(new))
+		if (IS_ERR(new)) {
+			mpol_put(mpol);	/* drop our ref on sb mpol */
 			return;		/* no valid nodemask intersection */
+		}
+
+		task_lock(current);
+		ret = mpol_set_nodemask(new, &mpol->w.user_nodemask);
+		task_unlock(current);
+		mpol_put(mpol);	/* drop our ref on sb mpol */
+		if (ret) {
+			mpol_put(new);
+			return;
+		}
 
 		/* Create pseudo-vma that contains just the policy */
 		memset(&pvma, 0, sizeof(struct vm_area_struct));
@@ -2086,8 +2138,19 @@ int mpol_parse_str(char *str, struct mem
 	new = mpol_new(mode, mode_flags, &nodes);
 	if (IS_ERR(new))
 		err = 1;
-	else if (no_context)
-		new->w.user_nodemask = nodes;	/* save for contextualization */
+	else {
+		int ret;
+
+		task_lock(current);
+		ret = mpol_set_nodemask(new, &nodes);
+		task_unlock(current);
+		if (ret)
+			err = 1;
+		else if (no_context) {
+			/* save for contextualization */
+			new->w.user_nodemask = nodes;
+		}
+	}
 
 out:
 	/* Restore string for error message */
diff -puN mm/page_alloc.c~cpusetmm-update-tasks-mems_allowed-in-time mm/page_alloc.c
--- a/mm/page_alloc.c~cpusetmm-update-tasks-mems_allowed-in-time
+++ a/mm/page_alloc.c
@@ -1569,10 +1569,7 @@ nofail_alloc:
 
 	/* We now go into synchronous reclaim */
 	cpuset_memory_pressure_bump();
-	/*
-	 * The task's cpuset might have expanded its set of allowable nodes
-	 */
-	cpuset_update_task_memory_state();
+
 	p->flags |= PF_MEMALLOC;
 
 	lockdep_set_current_reclaim_state(gfp_mask);
_

Patches currently in -mm which might be from miaox@cn.fujitsu.com are

origin.patch

