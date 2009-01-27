From: akpm@linux-foundation.org
Subject: + cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set.patch added to -mm tree
Date: Tue, 27 Jan 2009 14:42:43 -0800
Message-ID: <200901272242.n0RMghRB008257@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752032AbZA0WnH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 17:43:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: miaox@cn.fujitsu.com, cl@linux-foundation.org, menage@google.com, nickpiggin@yahoo.com.au


The patch titled
     cpuset: fix allocating page cache/slab object on the unallowed node when memory spread is set
has been added to the -mm tree.  Its filename is
     cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuset: fix allocating page cache/slab object on the unallowed node when memory spread is set
From: Miao Xie <miaox@cn.fujitsu.com>

The task still allocated the page caches on old node after modifying its
cpuset's mems when 'memory_spread_page' was set, it is caused by the old
mem_allowed_list of the task, the current kernel doesn't updates it unless
some function invokes cpuset_update_task_memory_state(), it is too late
sometimes.  We must update the mem_allowed_list of the tasks in time.

Slab has the same problem.

We fix the bug by updating tasks' mem_allowed_list and spread flag after
its cpuset's mems or spread flag is changed.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Paul Menage <menage@google.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpuset.h |    4 
 include/linux/sched.h  |    1 
 init/main.c            |    3 
 kernel/cpuset.c        |  204 ++++++++++++---------------------------
 kernel/kthread.c       |    1 
 mm/mempolicy.c         |   12 --
 mm/page_alloc.c        |    5 
 7 files changed, 69 insertions(+), 161 deletions(-)

diff -puN include/linux/cpuset.h~cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set include/linux/cpuset.h
--- a/include/linux/cpuset.h~cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set
+++ a/include/linux/cpuset.h
@@ -17,7 +17,6 @@
 
 extern int number_of_cpusets;	/* How many cpusets are defined in system? */
 
-extern int cpuset_init_early(void);
 extern int cpuset_init(void);
 extern void cpuset_init_smp(void);
 extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
@@ -26,7 +25,6 @@ extern void cpuset_cpus_allowed_locked(s
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
 #define cpuset_current_mems_allowed (current->mems_allowed)
 void cpuset_init_current_mems_allowed(void);
-void cpuset_update_task_memory_state(void);
 int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask);
 
 extern int __cpuset_zone_allowed_softwall(struct zone *z, gfp_t gfp_mask);
@@ -83,7 +81,6 @@ extern void cpuset_print_task_mems_allow
 
 #else /* !CONFIG_CPUSETS */
 
-static inline int cpuset_init_early(void) { return 0; }
 static inline int cpuset_init(void) { return 0; }
 static inline void cpuset_init_smp(void) {}
 
@@ -105,7 +102,6 @@ static inline nodemask_t cpuset_mems_all
 
 #define cpuset_current_mems_allowed (node_states[N_HIGH_MEMORY])
 static inline void cpuset_init_current_mems_allowed(void) {}
-static inline void cpuset_update_task_memory_state(void) {}
 
 static inline int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask)
 {
diff -puN include/linux/sched.h~cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set include/linux/sched.h
--- a/include/linux/sched.h~cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set
+++ a/include/linux/sched.h
@@ -1356,7 +1356,6 @@ struct task_struct {
 #endif
 #ifdef CONFIG_CPUSETS
 	nodemask_t mems_allowed;
-	int cpuset_mems_generation;
 	int cpuset_mem_spread_rotor;
 #endif
 #ifdef CONFIG_CGROUPS
diff -puN init/main.c~cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set init/main.c
--- a/init/main.c~cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set
+++ a/init/main.c
@@ -651,7 +651,6 @@ asmlinkage void __init start_kernel(void
 #endif
 	vmalloc_init();
 	vfs_caches_init_early();
-	cpuset_init_early();
 	page_cgroup_init();
 	mem_init();
 	enable_debug_pagealloc();
@@ -874,6 +873,8 @@ static int __init kernel_init(void * unu
 	 */
 	init_pid_ns.child_reaper = current;
 
+	current->mems_allowed = node_possible_map;
+
 	cad_pid = task_pid(current);
 
 	smp_prepare_cpus(setup_max_cpus);
diff -puN kernel/cpuset.c~cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set
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
@@ -180,27 +174,6 @@ static inline int is_spread_slab(const s
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
@@ -232,8 +205,8 @@ static struct cpuset top_cpuset = {
  * If a task is only holding callback_mutex, then it has read-only
  * access to cpusets.
  *
- * The task_struct fields mems_allowed and mems_generation may only
- * be accessed in the context of that task, so require no locks.
+ * The task_struct fields mems_allowed may only be accessed in the context
+ * of that task, so require no locks.
  *
  * The cpuset_common_file_read() handlers only hold callback_mutex across
  * small pieces of code, such as when reading out possibly multi-word
@@ -335,77 +308,6 @@ static void guarantee_online_mems(const 
 	BUG_ON(!nodes_intersects(*pmask, node_states[N_HIGH_MEMORY]));
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
-		if (is_spread_page(cs))
-			tsk->flags |= PF_SPREAD_PAGE;
-		else
-			tsk->flags &= ~PF_SPREAD_PAGE;
-		if (is_spread_slab(cs))
-			tsk->flags |= PF_SPREAD_SLAB;
-		else
-			tsk->flags &= ~PF_SPREAD_SLAB;
-		task_unlock(tsk);
-		mutex_unlock(&callback_mutex);
-		mpol_rebind_task(tsk, &tsk->mems_allowed);
-	}
-}
-
 /*
  * is_cpuset_subset(p, q) - Is cpuset p a subset of cpuset q?
  *
@@ -998,14 +900,6 @@ static int update_cpumask(struct cpuset 
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
@@ -1013,8 +907,6 @@ static void cpuset_migrate_mm(struct mm_
 {
 	struct task_struct *tsk = current;
 
-	cpuset_update_task_memory_state();
-
 	mutex_lock(&callback_mutex);
 	tsk->mems_allowed = *to;
 	mutex_unlock(&callback_mutex);
@@ -1084,6 +976,10 @@ static int update_tasks_nodemask(struct 
 				"Cpuset mempolicy rebind incomplete.\n");
 			break;
 		}
+		mutex_lock(&callback_mutex);
+		guarantee_online_mems(cs, &p->mems_allowed);
+		mutex_unlock(&callback_mutex);
+		mpol_rebind_task(p, &p->mems_allowed);
 		mm = get_task_mm(p);
 		if (!mm)
 			continue;
@@ -1126,10 +1022,9 @@ done:
 /*
  * Handle user request to change the 'mems' memory placement
  * of a cpuset.  Needs to validate the request, update the
- * cpusets mems_allowed and mems_generation, and for each
- * task in the cpuset, rebind any vma mempolicies and if
- * the cpuset is marked 'memory_migrate', migrate the tasks
- * pages to the new memory.
+ * cpusets mems_allowed, and for each task in the cpuset,
+ * rebind any vma mempolicies and if the cpuset is marked
+ * 'memory_migrate', migrate the tasks pages to the new memory.
  *
  * Call with cgroup_mutex held.  May take callback_mutex during call.
  * Will take tasklist_lock, scan tasklist for tasks in cpuset cs,
@@ -1177,7 +1072,6 @@ static int update_nodemask(struct cpuset
 
 	mutex_lock(&callback_mutex);
 	cs->mems_allowed = trialcs->mems_allowed;
-	cs->mems_generation = cpuset_mems_generation++;
 	mutex_unlock(&callback_mutex);
 
 	retval = update_tasks_nodemask(cs, &oldmem);
@@ -1205,6 +1099,33 @@ static int update_relax_domain_level(str
 	return 0;
 }
 
+static void cpuset_change_flag(struct task_struct *tsk,
+				struct cgroup_scanner *scan)
+{
+	struct cpuset *cs;
+
+	cs = task_cs(tsk);
+	if (is_spread_page(cs))
+		tsk->flags |= PF_SPREAD_PAGE;
+	else
+		tsk->flags &= ~PF_SPREAD_PAGE;
+	if (is_spread_slab(cs))
+		tsk->flags |= PF_SPREAD_SLAB;
+	else
+		tsk->flags &= ~PF_SPREAD_SLAB;
+}
+
+static void update_tasks_flags(struct cpuset *cs, struct ptr_heap *heap)
+{
+	struct cgroup_scanner scan;
+
+	scan.cg = cs->css.cgroup;
+	scan.test_task = NULL;
+	scan.process_task = cpuset_change_flag;
+	scan.heap = heap;
+	cgroup_scan_tasks(&scan);
+}
+
 /*
  * update_flag - read a 0 or a 1 in a file and update associated flag
  * bit:		the bit to update (see cpuset_flagbits_t)
@@ -1220,6 +1141,8 @@ static int update_flag(cpuset_flagbits_t
 	struct cpuset *trialcs;
 	int err;
 	int balance_flag_changed;
+	int spread_changed;
+	struct ptr_heap heap;
 
 	trialcs = alloc_trial_cpuset(cs);
 	if (!trialcs)
@@ -1234,9 +1157,16 @@ static int update_flag(cpuset_flagbits_t
 	if (err < 0)
 		goto out;
 
+	err = heap_init(&heap, PAGE_SIZE, GFP_KERNEL, NULL);
+	if (err)
+		goto out;
+
 	balance_flag_changed = (is_sched_load_balance(cs) !=
 				is_sched_load_balance(trialcs));
 
+	spread_changed = ((is_spread_slab(cs) != is_spread_slab(trialcs))
+			|| (is_spread_page(cs) != is_spread_page(trialcs)));
+
 	mutex_lock(&callback_mutex);
 	cs->flags = trialcs->flags;
 	mutex_unlock(&callback_mutex);
@@ -1244,6 +1174,10 @@ static int update_flag(cpuset_flagbits_t
 	if (!cpumask_empty(trialcs->cpus_allowed) && balance_flag_changed)
 		async_rebuild_sched_domains();
 
+	if (spread_changed)
+		update_tasks_flags(cs, &heap);
+
+	heap_free(&heap);
 out:
 	free_trial_cpuset(trialcs);
 	return err;
@@ -1382,15 +1316,29 @@ static void cpuset_attach(struct cgroup_
 
 	if (cs == &top_cpuset) {
 		cpumask_copy(cpus_attach, cpu_possible_mask);
+		tsk->mems_allowed = node_possible_map;
 	} else {
 		mutex_lock(&callback_mutex);
 		guarantee_online_cpus(cs, cpus_attach);
+		guarantee_online_mems(cs,&tsk->mems_allowed);
 		mutex_unlock(&callback_mutex);
 	}
 	err = set_cpus_allowed_ptr(tsk, cpus_attach);
 	if (err)
 		return;
 
+	mutex_lock(&callback_mutex);
+	if (is_spread_page(cs))
+		tsk->flags |= PF_SPREAD_PAGE;
+	else
+		tsk->flags &= ~PF_SPREAD_PAGE;
+	if (is_spread_slab(cs))
+		tsk->flags |= PF_SPREAD_SLAB;
+	else
+		tsk->flags &= ~PF_SPREAD_SLAB;
+	mutex_unlock(&callback_mutex);
+	mpol_rebind_task(tsk, &tsk->mems_allowed);
+
 	from = oldcs->mems_allowed;
 	to = cs->mems_allowed;
 	mm = get_task_mm(tsk);
@@ -1452,11 +1400,9 @@ static int cpuset_write_u64(struct cgrou
 		break;
 	case FILE_SPREAD_PAGE:
 		retval = update_flag(CS_SPREAD_PAGE, cs, val);
-		cs->mems_generation = cpuset_mems_generation++;
 		break;
 	case FILE_SPREAD_SLAB:
 		retval = update_flag(CS_SPREAD_SLAB, cs, val);
-		cs->mems_generation = cpuset_mems_generation++;
 		break;
 	default:
 		retval = -EINVAL;
@@ -1795,8 +1741,6 @@ static struct cgroup_subsys_state *cpuse
 	struct cpuset *parent;
 
 	if (!cont->parent) {
-		/* This is early initialization for the top cgroup */
-		top_cpuset.mems_generation = cpuset_mems_generation++;
 		return &top_cpuset.css;
 	}
 	parent = cgroup_cs(cont->parent);
@@ -1808,7 +1752,6 @@ static struct cgroup_subsys_state *cpuse
 		return ERR_PTR(-ENOMEM);
 	}
 
-	cpuset_update_task_memory_state();
 	cs->flags = 0;
 	if (is_spread_page(parent))
 		set_bit(CS_SPREAD_PAGE, &cs->flags);
@@ -1817,7 +1760,6 @@ static struct cgroup_subsys_state *cpuse
 	set_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
 	cpumask_clear(cs->cpus_allowed);
 	nodes_clear(cs->mems_allowed);
-	cs->mems_generation = cpuset_mems_generation++;
 	fmeter_init(&cs->fmeter);
 	cs->relax_domain_level = -1;
 
@@ -1836,8 +1778,6 @@ static void cpuset_destroy(struct cgroup
 {
 	struct cpuset *cs = cgroup_cs(cont);
 
-	cpuset_update_task_memory_state();
-
 	if (is_sched_load_balance(cs))
 		update_flag(CS_SCHED_LOAD_BALANCE, cs, 0);
 
@@ -1858,21 +1798,6 @@ struct cgroup_subsys cpuset_subsys = {
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
-	alloc_bootmem_cpumask_var(&top_cpuset.cpus_allowed);
-
-	top_cpuset.mems_generation = cpuset_mems_generation++;
-	return 0;
-}
-
-
 /**
  * cpuset_init - initialize cpusets at system boot
  *
@@ -1883,11 +1808,12 @@ int __init cpuset_init(void)
 {
 	int err = 0;
 
+	if (!alloc_cpumask_var(&top_cpuset.cpus_allowed, GFP_KERNEL))
+		BUG();
 	cpumask_setall(top_cpuset.cpus_allowed);
 	nodes_setall(top_cpuset.mems_allowed);
 
 	fmeter_init(&top_cpuset.fmeter);
-	top_cpuset.mems_generation = cpuset_mems_generation++;
 	set_bit(CS_SCHED_LOAD_BALANCE, &top_cpuset.flags);
 	top_cpuset.relax_domain_level = -1;
 
diff -puN kernel/kthread.c~cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set kernel/kthread.c
--- a/kernel/kthread.c~cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set
+++ a/kernel/kthread.c
@@ -242,6 +242,7 @@ int kthreadd(void *unused)
 	set_user_nice(tsk, KTHREAD_NICE_LEVEL);
 	set_cpus_allowed_ptr(tsk, CPU_MASK_ALL_PTR);
 
+	current->mems_allowed = node_possible_map;
 	current->flags |= PF_NOFREEZE | PF_FREEZER_NOSIG;
 
 	for (;;) {
diff -puN mm/mempolicy.c~cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set mm/mempolicy.c
--- a/mm/mempolicy.c~cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set
+++ a/mm/mempolicy.c
@@ -222,10 +222,6 @@ static struct mempolicy *mpol_new(unsign
 	policy->flags = flags;
 
 	if (nodes) {
-		/*
-		 * cpuset related setup doesn't apply to local allocation
-		 */
-		cpuset_update_task_memory_state();
 		if (flags & MPOL_F_RELATIVE_NODES)
 			mpol_relative_nodemask(&cpuset_context_nmask, nodes,
 					       &cpuset_current_mems_allowed);
@@ -674,7 +670,6 @@ static long do_get_mempolicy(int *policy
 	struct vm_area_struct *vma = NULL;
 	struct mempolicy *pol = current->mempolicy;
 
-	cpuset_update_task_memory_state();
 	if (flags &
 		~(unsigned long)(MPOL_F_NODE|MPOL_F_ADDR|MPOL_F_MEMS_ALLOWED))
 		return -EINVAL;
@@ -1545,8 +1540,6 @@ alloc_page_vma(gfp_t gfp, struct vm_area
 	struct mempolicy *pol = get_vma_policy(current, vma, addr);
 	struct zonelist *zl;
 
-	cpuset_update_task_memory_state();
-
 	if (unlikely(pol->mode == MPOL_INTERLEAVE)) {
 		unsigned nid;
 
@@ -1585,16 +1578,11 @@ alloc_page_vma(gfp_t gfp, struct vm_area
  *	interrupt context and apply the current process NUMA policy.
  *	Returns NULL when no page can be allocated.
  *
- *	Don't call cpuset_update_task_memory_state() unless
- *	1) it's ok to take cpuset_sem (can WAIT), and
- *	2) allocating for current task (not interrupt).
  */
 struct page *alloc_pages_current(gfp_t gfp, unsigned order)
 {
 	struct mempolicy *pol = current->mempolicy;
 
-	if ((gfp & __GFP_WAIT) && !in_interrupt())
-		cpuset_update_task_memory_state();
 	if (!pol || in_interrupt() || (gfp & __GFP_THISNODE))
 		pol = &default_policy;
 
diff -puN mm/page_alloc.c~cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set mm/page_alloc.c
--- a/mm/page_alloc.c~cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set
+++ a/mm/page_alloc.c
@@ -1574,10 +1574,7 @@ nofail_alloc:
 
 	/* We now go into synchronous reclaim */
 	cpuset_memory_pressure_bump();
-	/*
-	 * The task's cpuset might have expanded its set of allowable nodes
-	 */
-	cpuset_update_task_memory_state();
+
 	p->flags |= PF_MEMALLOC;
 	reclaim_state.reclaimed_slab = 0;
 	p->reclaim_state = &reclaim_state;
_

Patches currently in -mm which might be from miaox@cn.fujitsu.com are

linux-next.patch
cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set.patch

