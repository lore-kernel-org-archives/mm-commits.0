From: akpm@linux-foundation.org
Subject: + cgroups-update-comments-in-cpusetc.patch added to -mm tree
Date: Wed, 30 Jan 2008 15:40:55 -0800
Message-ID: <200801302340.m0UNet7S030739@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56190 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751321AbYA3Xlg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jan 2008 18:41:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com, pj@sgi.com


The patch titled
     cgroups: update comments in cpuset.c
has been added to the -mm tree.  Its filename is
     cgroups-update-comments-in-cpusetc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: update comments in cpuset.c
From: Paul Menage <menage@google.com>

Some of the comments in kernel/cpuset.c were stale following the
transition to control groups; this patch updates them to more closely
match reality.

Signed-off-by: Paul Menage <menage@google.com>
Acked-by: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |  128 +++++++++++++++-------------------------------
 1 file changed, 43 insertions(+), 85 deletions(-)

diff -puN kernel/cpuset.c~cgroups-update-comments-in-cpusetc kernel/cpuset.c
--- a/kernel/cpuset.c~cgroups-update-comments-in-cpusetc
+++ a/kernel/cpuset.c
@@ -65,7 +65,7 @@
  */
 int number_of_cpusets __read_mostly;
 
-/* Retrieve the cpuset from a cgroup */
+/* Forward declare cgroup structures */
 struct cgroup_subsys cpuset_subsys;
 struct cpuset;
 
@@ -167,17 +167,17 @@ static inline int is_spread_slab(const s
  * number, and avoid having to lock and reload mems_allowed unless
  * the cpuset they're using changes generation.
  *
- * A single, global generation is needed because attach_task() could
+ * A single, global generation is needed because cpuset_attach_task() could
  * reattach a task to a different cpuset, which must not have its
  * generation numbers aliased with those of that tasks previous cpuset.
  *
  * Generations are needed for mems_allowed because one task cannot
- * modify anothers memory placement.  So we must enable every task,
+ * modify another's memory placement.  So we must enable every task,
  * on every visit to __alloc_pages(), to efficiently check whether
  * its current->cpuset->mems_allowed has changed, requiring an update
  * of its current->mems_allowed.
  *
- * Since cpuset_mems_generation is guarded by manage_mutex,
+ * Since writes to cpuset_mems_generation are guarded by the cgroup lock
  * there is no need to mark it atomic.
  */
 static int cpuset_mems_generation;
@@ -189,17 +189,20 @@ static struct cpuset top_cpuset = {
 };
 
 /*
- * We have two global cpuset mutexes below.  They can nest.
- * It is ok to first take manage_mutex, then nest callback_mutex.  We also
- * require taking task_lock() when dereferencing a tasks cpuset pointer.
- * See "The task_lock() exception", at the end of this comment.
+ * There are two global mutexes guarding cpuset structures.  The first
+ * is the main control groups cgroup_mutex, accessed via
+ * cgroup_lock()/cgroup_unlock().  The second is the cpuset-specific
+ * callback_mutex, below. They can nest.  It is ok to first take
+ * cgroup_mutex, then nest callback_mutex.  We also require taking
+ * task_lock() when dereferencing a task's cpuset pointer.  See "The
+ * task_lock() exception", at the end of this comment.
  *
  * A task must hold both mutexes to modify cpusets.  If a task
- * holds manage_mutex, then it blocks others wanting that mutex,
+ * holds cgroup_mutex, then it blocks others wanting that mutex,
  * ensuring that it is the only task able to also acquire callback_mutex
  * and be able to modify cpusets.  It can perform various checks on
  * the cpuset structure first, knowing nothing will change.  It can
- * also allocate memory while just holding manage_mutex.  While it is
+ * also allocate memory while just holding cgroup_mutex.  While it is
  * performing these checks, various callback routines can briefly
  * acquire callback_mutex to query cpusets.  Once it is ready to make
  * the changes, it takes callback_mutex, blocking everyone else.
@@ -215,60 +218,16 @@ static struct cpuset top_cpuset = {
  * The task_struct fields mems_allowed and mems_generation may only
  * be accessed in the context of that task, so require no locks.
  *
- * Any task can increment and decrement the count field without lock.
- * So in general, code holding manage_mutex or callback_mutex can't rely
- * on the count field not changing.  However, if the count goes to
- * zero, then only attach_task(), which holds both mutexes, can
- * increment it again.  Because a count of zero means that no tasks
- * are currently attached, therefore there is no way a task attached
- * to that cpuset can fork (the other way to increment the count).
- * So code holding manage_mutex or callback_mutex can safely assume that
- * if the count is zero, it will stay zero.  Similarly, if a task
- * holds manage_mutex or callback_mutex on a cpuset with zero count, it
- * knows that the cpuset won't be removed, as cpuset_rmdir() needs
- * both of those mutexes.
- *
  * The cpuset_common_file_write handler for operations that modify
- * the cpuset hierarchy holds manage_mutex across the entire operation,
+ * the cpuset hierarchy holds cgroup_mutex across the entire operation,
  * single threading all such cpuset modifications across the system.
  *
  * The cpuset_common_file_read() handlers only hold callback_mutex across
  * small pieces of code, such as when reading out possibly multi-word
  * cpumasks and nodemasks.
  *
- * The fork and exit callbacks cpuset_fork() and cpuset_exit(), don't
- * (usually) take either mutex.  These are the two most performance
- * critical pieces of code here.  The exception occurs on cpuset_exit(),
- * when a task in a notify_on_release cpuset exits.  Then manage_mutex
- * is taken, and if the cpuset count is zero, a usermode call made
- * to /sbin/cpuset_release_agent with the name of the cpuset (path
- * relative to the root of cpuset file system) as the argument.
- *
- * A cpuset can only be deleted if both its 'count' of using tasks
- * is zero, and its list of 'children' cpusets is empty.  Since all
- * tasks in the system use _some_ cpuset, and since there is always at
- * least one task in the system (init), therefore, top_cpuset
- * always has either children cpusets and/or using tasks.  So we don't
- * need a special hack to ensure that top_cpuset cannot be deleted.
- *
- * The above "Tale of Two Semaphores" would be complete, but for:
- *
- *	The task_lock() exception
- *
- * The need for this exception arises from the action of attach_task(),
- * which overwrites one tasks cpuset pointer with another.  It does
- * so using both mutexes, however there are several performance
- * critical places that need to reference task->cpuset without the
- * expense of grabbing a system global mutex.  Therefore except as
- * noted below, when dereferencing or, as in attach_task(), modifying
- * a tasks cpuset pointer we use task_lock(), which acts on a spinlock
- * (task->alloc_lock) already in the task_struct routinely used for
- * such matters.
- *
- * P.S.  One more locking exception.  RCU is used to guard the
- * update of a tasks cpuset pointer by attach_task() and the
- * access of task->cpuset->mems_generation via that pointer in
- * the routine cpuset_update_task_memory_state().
+ * Accessing a task's cpuset should be done in accordance with the
+ * guidelines for accessing subsystem state in kernel/cgroup.c
  */
 
 static DEFINE_MUTEX(callback_mutex);
@@ -361,15 +320,14 @@ static void guarantee_online_mems(const 
  * Do not call this routine if in_interrupt().
  *
  * Call without callback_mutex or task_lock() held.  May be
- * called with or without manage_mutex held.  Thanks in part to
- * 'the_top_cpuset_hack', the tasks cpuset pointer will never
+ * called with or without cgroup_mutex held.  Thanks in part to
+ * 'the_top_cpuset_hack', the task's cpuset pointer will never
  * be NULL.  This routine also might acquire callback_mutex and
  * current->mm->mmap_sem during call.
  *
  * Reading current->cpuset->mems_generation doesn't need task_lock
  * to guard the current->cpuset derefence, because it is guarded
- * from concurrent freeing of current->cpuset by attach_task(),
- * using RCU.
+ * from concurrent freeing of current->cpuset using RCU.
  *
  * The rcu_dereference() is technically probably not needed,
  * as I don't actually mind if I see a new cpuset pointer but
@@ -431,7 +389,7 @@ void cpuset_update_task_memory_state(voi
  *
  * One cpuset is a subset of another if all its allowed CPUs and
  * Memory Nodes are a subset of the other, and its exclusive flags
- * are only set if the other's are set.  Call holding manage_mutex.
+ * are only set if the other's are set.  Call holding cgroup_mutex.
  */
 
 static int is_cpuset_subset(const struct cpuset *p, const struct cpuset *q)
@@ -449,7 +407,7 @@ static int is_cpuset_subset(const struct
  * If we replaced the flag and mask values of the current cpuset
  * (cur) with those values in the trial cpuset (trial), would
  * our various subset and exclusive rules still be valid?  Presumes
- * manage_mutex held.
+ * cgroup_mutex held.
  *
  * 'cur' is the address of an actual, in-use cpuset.  Operations
  * such as list traversal that depend on the actual address of the
@@ -483,7 +441,10 @@ static int validate_change(const struct 
 	if (!is_cpuset_subset(trial, par))
 		return -EACCES;
 
-	/* If either I or some sibling (!= me) is exclusive, we can't overlap */
+	/*
+	 * If either I or some sibling (!= me) is exclusive, we can't
+	 * overlap
+	 */
 	list_for_each_entry(cont, &par->css.cgroup->children, sibling) {
 		c = cgroup_cs(cont);
 		if ((is_cpu_exclusive(trial) || is_cpu_exclusive(c)) &&
@@ -744,7 +705,7 @@ static inline int started_after(void *p1
  * @tsk: task to test
  * @scan: struct cgroup_scanner contained in its struct cpuset_hotplug_scanner
  *
- * Call with manage_mutex held.  May take callback_mutex during call.
+ * Call with cgroup_mutex held.  May take callback_mutex during call.
  * Called for each task in a cgroup by cgroup_scan_tasks().
  * Return nonzero if this tasks's cpus_allowed mask should be changed (in other
  * words, if its mask is not equal to its cpuset's mask).
@@ -847,11 +808,11 @@ static int update_cpumask(struct cpuset 
  *    Temporarilly set tasks mems_allowed to target nodes of migration,
  *    so that the migration code can allocate pages on these nodes.
  *
- *    Call holding manage_mutex, so our current->cpuset won't change
- *    during this call, as manage_mutex holds off any attach_task()
+ *    Call holding cgroup_mutex, so current's cpuset won't change
+ *    during this call, as cgroup_mutex holds off any attach_task()
  *    calls.  Therefore we don't need to take task_lock around the
  *    call to guarantee_online_mems(), as we know no one is changing
- *    our tasks cpuset.
+ *    our task's cpuset.
  *
  *    Hold callback_mutex around the two modifications of our tasks
  *    mems_allowed to synchronize with cpuset_mems_allowed().
@@ -896,7 +857,7 @@ static void cpuset_migrate_mm(struct mm_
  * the cpuset is marked 'memory_migrate', migrate the tasks
  * pages to the new memory.
  *
- * Call with manage_mutex held.  May take callback_mutex during call.
+ * Call with cgroup_mutex held.  May take callback_mutex during call.
  * Will take tasklist_lock, scan tasklist for tasks in cpuset cs,
  * lock each such tasks mm->mmap_sem, scan its vma's and rebind
  * their mempolicies to the cpusets new mems_allowed.
@@ -1009,7 +970,7 @@ static int update_nodemask(struct cpuset
 	 * tasklist_lock.  Forks can happen again now - the mpol_copy()
 	 * cpuset_being_rebound check will catch such forks, and rebind
 	 * their vma mempolicies too.  Because we still hold the global
-	 * cpuset manage_mutex, we know that no other rebind effort will
+	 * cgroup_mutex, we know that no other rebind effort will
 	 * be contending for the global variable cpuset_being_rebound.
 	 * It's ok if we rebind the same mm twice; mpol_rebind_mm()
 	 * is idempotent.  Also migrate pages in each mm to new nodes.
@@ -1024,7 +985,7 @@ static int update_nodemask(struct cpuset
 		mmput(mm);
 	}
 
-	/* We're done rebinding vma's to this cpusets new mems_allowed. */
+	/* We're done rebinding vmas to this cpuset's new mems_allowed. */
 	kfree(mmarray);
 	cpuset_being_rebound = NULL;
 	retval = 0;
@@ -1038,7 +999,7 @@ int current_cpuset_is_being_rebound(void
 }
 
 /*
- * Call with manage_mutex held.
+ * Call with cgroup_mutex held.
  */
 
 static int update_memory_pressure_enabled(struct cpuset *cs, char *buf)
@@ -1059,7 +1020,7 @@ static int update_memory_pressure_enable
  * cs:	the cpuset to update
  * buf:	the buffer where we read the 0 or 1
  *
- * Call with manage_mutex held.
+ * Call with cgroup_mutex held.
  */
 
 static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs, char *buf)
@@ -1193,6 +1154,7 @@ static int fmeter_getrate(struct fmeter 
 	return val;
 }
 
+/* Called by cgroups to determine if a cpuset is usable; cgroup_mutex held */
 static int cpuset_can_attach(struct cgroup_subsys *ss,
 			     struct cgroup *cont, struct task_struct *tsk)
 {
@@ -1540,7 +1502,8 @@ static int cpuset_populate(struct cgroup
  * If this becomes a problem for some users who wish to
  * allow that scenario, then cpuset_post_clone() could be
  * changed to grant parent->cpus_allowed-sibling_cpus_exclusive
- * (and likewise for mems) to the new cgroup.
+ * (and likewise for mems) to the new cgroup. Called with cgroup_mutex
+ * held.
  */
 static void cpuset_post_clone(struct cgroup_subsys *ss,
 			      struct cgroup *cgroup)
@@ -1564,11 +1527,8 @@ static void cpuset_post_clone(struct cgr
 
 /*
  *	cpuset_create - create a cpuset
- *	parent:	cpuset that will be parent of the new cpuset.
- *	name:		name of the new cpuset. Will be strcpy'ed.
- *	mode:		mode to set on new inode
- *
- *	Must be called with the mutex on the parent inode held
+ *	ss:	cpuset cgroup subsystem
+ *	cont:	control group that the new cpuset will be part of
  */
 
 static struct cgroup_subsys_state *cpuset_create(
@@ -1769,7 +1729,7 @@ static void remove_tasks_in_empty_cpuset
  * member tasks or cpuset descendants and cpus and memory, before it can
  * be a candidate for release.
  *
- * Called with manage_mutex held.  We take callback_mutex to modify
+ * Called with cgroup_mutex held.  We take callback_mutex to modify
  * cpus_allowed and mems_allowed.
  *
  * This walk processes the tree from top to bottom, completing one layer
@@ -1909,7 +1869,7 @@ cpumask_t cpuset_cpus_allowed(struct tas
 
 /**
  * cpuset_cpus_allowed_locked - return cpus_allowed mask from a tasks cpuset.
- * Must be  called with callback_mutex held.
+ * Must be called with callback_mutex held.
  **/
 cpumask_t cpuset_cpus_allowed_locked(struct task_struct *tsk)
 {
@@ -2246,10 +2206,8 @@ void __cpuset_memory_pressure_bump(void)
  *  - Used for /proc/<pid>/cpuset.
  *  - No need to task_lock(tsk) on this tsk->cpuset reference, as it
  *    doesn't really matter if tsk->cpuset changes after we read it,
- *    and we take manage_mutex, keeping attach_task() from changing it
- *    anyway.  No need to check that tsk->cpuset != NULL, thanks to
- *    the_top_cpuset_hack in cpuset_exit(), which sets an exiting tasks
- *    cpuset to top_cpuset.
+ *    and we take cgroup_mutex, keeping attach_task() from changing it
+ *    anyway.
  */
 static int proc_cpuset_show(struct seq_file *m, void *unused_v)
 {
_

Patches currently in -mm which might be from menage@google.com are

kernel-cgroupc-remove-dead-code.patch
cgroup-brace-coding-style-fix.patch
cgroup-simplify-space-stripping.patch
cgroup-simplify-space-stripping-fix.patch
cgroups-move-cgroups-destroy-callbacks-to-cgroup_diput.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
memcgroup-reinstate-swapoff-mod.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages-fix.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch
memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch
memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-memorystat-file.patch
memory-cgroup-enhancements-add-pre_destroy-handler.patch
memory-cgroup-enhancements-implicit-force_empty-at-rmdir.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-add-scan_global_lru-macro.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-nid-zid-helper-function-for-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-active-inactive-counter.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-mapper_ratio-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-active-inactive-imbalance-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-the-number-of-pages-to-be-scanned-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lock-for-cgroup.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup-cleanup.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup-checkpatch-fixes.patch
hotplug-cpu-move-tasks-in-empty-cpusets-to-parent.patch
hotplug-cpu-move-tasks-in-empty-cpusets-to-parent-checkpatch-fixes.patch
cpusets-update_cpumask-revision.patch
cpusets-update_cpumask-revision-fix.patch
cpusets-update_cpumask-revision-checkpatch-fixes.patch
cgroups-update-comments-in-cpusetc.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
add-a-refcount-check-in-dput.patch
