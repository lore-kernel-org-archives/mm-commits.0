From: akpm@linux-foundation.org
Subject: [to-be-updated] oom-select-task-from-tasklist-for-mempolicy-ooms.patch removed from -mm tree
Date: Wed, 19 May 2010 11:47:40 -0700
Message-ID: <201005191847.o4JIleqS029402@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45321 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753882Ab0ESSse (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 14:48:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, npiggin@suse.de, riel@redhat.com, mm-commits@vge


The patch titled
     oom: select task from tasklist for mempolicy ooms
has been removed from the -mm tree.  Its filename was
     oom-select-task-from-tasklist-for-mempolicy-ooms.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom: select task from tasklist for mempolicy ooms
From: David Rientjes <rientjes@google.com>

The oom killer presently kills current whenever there is no more memory
free or reclaimable on its mempolicy's nodes.  There is no guarantee that
current is a memory-hogging task or that killing it will free any
substantial amount of memory, however.

In such situations, it is better to scan the tasklist for nodes that are
allowed to allocate on current's set of nodes and kill the task with the
highest badness() score.  This ensures that the most memory-hogging task,
or the one configured by the user with /proc/pid/oom_adj, is always
selected in such scenarios.

It is necessary to synchronize the detachment of task->mempolicy with
task_lock(task) to ensure it is not prematurely destroyed while a user is
operating on it.

Signed-off-by: David Rientjes <rientjes@google.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |   13 +++++-
 kernel/exit.c             |    8 +--
 mm/mempolicy.c            |   44 ++++++++++++++++++++
 mm/oom_kill.c             |   77 +++++++++++++++++++++---------------
 4 files changed, 107 insertions(+), 35 deletions(-)

diff -puN include/linux/mempolicy.h~oom-select-task-from-tasklist-for-mempolicy-ooms include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~oom-select-task-from-tasklist-for-mempolicy-ooms
+++ a/include/linux/mempolicy.h
@@ -202,6 +202,8 @@ extern struct zonelist *huge_zonelist(st
 				unsigned long addr, gfp_t gfp_flags,
 				struct mempolicy **mpol, nodemask_t **nodemask);
 extern bool init_nodemask_of_mempolicy(nodemask_t *mask);
+extern bool mempolicy_nodemask_intersects(struct task_struct *tsk,
+				const nodemask_t *mask);
 extern unsigned slab_node(struct mempolicy *policy);
 
 extern enum zone_type policy_zone;
@@ -329,7 +331,16 @@ static inline struct zonelist *huge_zone
 	return node_zonelist(0, gfp_flags);
 }
 
-static inline bool init_nodemask_of_mempolicy(nodemask_t *m) { return false; }
+static inline bool init_nodemask_of_mempolicy(nodemask_t *m)
+{
+	return false;
+}
+
+static inline bool mempolicy_nodemask_intersects(struct task_struct *tsk,
+			const nodemask_t *mask)
+{
+	return false;
+}
 
 static inline int do_migrate_pages(struct mm_struct *mm,
 			const nodemask_t *from_nodes,
diff -puN kernel/exit.c~oom-select-task-from-tasklist-for-mempolicy-ooms kernel/exit.c
--- a/kernel/exit.c~oom-select-task-from-tasklist-for-mempolicy-ooms
+++ a/kernel/exit.c
@@ -696,6 +696,10 @@ static void exit_mm(struct task_struct *
 	enter_lazy_tlb(mm, current);
 	/* We don't want this task to be frozen prematurely */
 	clear_freeze_flag(tsk);
+#ifdef CONFIG_NUMA
+	mpol_put(tsk->mempolicy);
+	tsk->mempolicy = NULL;
+#endif
 	task_unlock(tsk);
 	mm_update_next_owner(mm);
 	mmput(mm);
@@ -1001,10 +1005,6 @@ NORET_TYPE void do_exit(long code)
 	perf_event_exit_task(tsk);
 
 	exit_notify(tsk, group_dead);
-#ifdef CONFIG_NUMA
-	mpol_put(tsk->mempolicy);
-	tsk->mempolicy = NULL;
-#endif
 #ifdef CONFIG_FUTEX
 	if (unlikely(current->pi_state_cache))
 		kfree(current->pi_state_cache);
diff -puN mm/mempolicy.c~oom-select-task-from-tasklist-for-mempolicy-ooms mm/mempolicy.c
--- a/mm/mempolicy.c~oom-select-task-from-tasklist-for-mempolicy-ooms
+++ a/mm/mempolicy.c
@@ -1638,6 +1638,50 @@ bool init_nodemask_of_mempolicy(nodemask
 }
 #endif
 
+/*
+ * mempolicy_nodemask_intersects
+ *
+ * If tsk's mempolicy is "default" [NULL], return 'true' to indicate default
+ * policy.  Otherwise, check for intersection between mask and the policy
+ * nodemask for 'bind' or 'interleave' policy.  For 'perferred' or 'local'
+ * policy, always return true since it may allocate elsewhere on fallback.
+ *
+ * Takes task_lock(tsk) to prevent freeing of its mempolicy.
+ */
+bool mempolicy_nodemask_intersects(struct task_struct *tsk,
+					const nodemask_t *mask)
+{
+	struct mempolicy *mempolicy;
+	bool ret = true;
+
+	if (!mask)
+		return ret;
+	task_lock(tsk);
+	mempolicy = tsk->mempolicy;
+	if (!mempolicy)
+		goto out;
+
+	switch (mempolicy->mode) {
+	case MPOL_PREFERRED:
+		/*
+		 * MPOL_PREFERRED and MPOL_F_LOCAL are only preferred nodes to
+		 * allocate from, they may fallback to other nodes when oom.
+		 * Thus, it's possible for tsk to have allocated memory from
+		 * nodes in mask.
+		 */
+		break;
+	case MPOL_BIND:
+	case MPOL_INTERLEAVE:
+		ret = nodes_intersects(mempolicy->v.nodes, *mask);
+		break;
+	default:
+		BUG();
+	}
+out:
+	task_unlock(tsk);
+	return ret;
+}
+
 /* Allocate a page in interleaved policy.
    Own path because it needs to do special accounting. */
 static struct page *alloc_page_interleave(gfp_t gfp, unsigned order,
diff -puN mm/oom_kill.c~oom-select-task-from-tasklist-for-mempolicy-ooms mm/oom_kill.c
--- a/mm/oom_kill.c~oom-select-task-from-tasklist-for-mempolicy-ooms
+++ a/mm/oom_kill.c
@@ -27,6 +27,7 @@
 #include <linux/module.h>
 #include <linux/notifier.h>
 #include <linux/memcontrol.h>
+#include <linux/mempolicy.h>
 #include <linux/security.h>
 
 int sysctl_panic_on_oom;
@@ -37,19 +38,35 @@ static DEFINE_SPINLOCK(zone_scan_lock);
 
 /*
  * Do all threads of the target process overlap our allowed nodes?
+ * @tsk: task struct of which task to consider
+ * @mask: nodemask passed to page allocator for mempolicy ooms
  */
-static int has_intersects_mems_allowed(struct task_struct *tsk)
+static bool has_intersects_mems_allowed(struct task_struct *tsk,
+						const nodemask_t *mask)
 {
-	struct task_struct *t;
+	struct task_struct *start = tsk;
 
-	t = tsk;
 	do {
-		if (cpuset_mems_allowed_intersects(current, t))
-			return 1;
-		t = next_thread(t);
-	} while (t != tsk);
-
-	return 0;
+		if (mask) {
+			/*
+			 * If this is a mempolicy constrained oom, tsk's
+			 * cpuset is irrelevant.  Only return true if its
+			 * mempolicy intersects current, otherwise it may be
+			 * needlessly killed.
+			 */
+			if (mempolicy_nodemask_intersects(tsk, mask))
+				return true;
+		} else {
+			/*
+			 * This is not a mempolicy constrained oom, so only
+			 * check the mems of tsk's cpuset.
+			 */
+			if (cpuset_mems_allowed_intersects(current, tsk))
+				return true;
+		}
+		tsk = next_thread(tsk);
+	} while (tsk != start);
+	return false;
 }
 
 /**
@@ -237,7 +254,8 @@ static enum oom_constraint constrained_a
  * (not docbooked, we don't want this one cluttering up the manual)
  */
 static struct task_struct *select_bad_process(unsigned long *ppoints,
-						struct mem_cgroup *mem)
+		struct mem_cgroup *mem, enum oom_constraint constraint,
+		const nodemask_t *mask)
 {
 	struct task_struct *p;
 	struct task_struct *chosen = NULL;
@@ -259,7 +277,9 @@ static struct task_struct *select_bad_pr
 			continue;
 		if (mem && !task_in_mem_cgroup(p, mem))
 			continue;
-		if (!has_intersects_mems_allowed(p))
+		if (!has_intersects_mems_allowed(p,
+				constraint == CONSTRAINT_MEMORY_POLICY ? mask :
+									 NULL))
 			continue;
 
 		/*
@@ -483,7 +503,7 @@ void mem_cgroup_out_of_memory(struct mem
 		panic("out of memory(memcg). panic_on_oom is selected.\n");
 	read_lock(&tasklist_lock);
 retry:
-	p = select_bad_process(&points, mem);
+	p = select_bad_process(&points, mem, CONSTRAINT_NONE, NULL);
 	if (PTR_ERR(p) == -1UL)
 		goto out;
 
@@ -565,7 +585,8 @@ void clear_zonelist_oom(struct zonelist 
 /*
  * Must be called with tasklist_lock held for read.
  */
-static void __out_of_memory(gfp_t gfp_mask, int order)
+static void __out_of_memory(gfp_t gfp_mask, int order,
+			enum oom_constraint constraint, const nodemask_t *mask)
 {
 	struct task_struct *p;
 	unsigned long points;
@@ -579,7 +600,7 @@ retry:
 	 * Rambo mode: Shoot down a process and hope it solves whatever
 	 * issues we may have.
 	 */
-	p = select_bad_process(&points, NULL);
+	p = select_bad_process(&points, NULL, constraint, mask);
 
 	if (PTR_ERR(p) == -1UL)
 		return;
@@ -613,7 +634,8 @@ void pagefault_out_of_memory(void)
 		panic("out of memory from page fault. panic_on_oom is selected.\n");
 
 	read_lock(&tasklist_lock);
-	__out_of_memory(0, 0); /* unknown gfp_mask and order */
+	/* unknown gfp_mask and order */
+	__out_of_memory(0, 0, CONSTRAINT_NONE, NULL);
 	read_unlock(&tasklist_lock);
 
 	/*
@@ -629,6 +651,7 @@ void pagefault_out_of_memory(void)
  * @zonelist: zonelist pointer
  * @gfp_mask: memory allocation flags
  * @order: amount of memory being requested as a power of 2
+ * @nodemask: nodemask passed to page allocator
  *
  * If we run out of memory, we have the choice between either
  * killing a random task (bad), letting the system crash (worse)
@@ -657,24 +680,18 @@ void out_of_memory(struct zonelist *zone
 	 */
 	constraint = constrained_alloc(zonelist, gfp_mask, nodemask);
 	read_lock(&tasklist_lock);
-
-	switch (constraint) {
-	case CONSTRAINT_MEMORY_POLICY:
-		oom_kill_process(current, gfp_mask, order, 0, NULL,
-				"No available memory (MPOL_BIND)");
-		break;
-
-	case CONSTRAINT_NONE:
-		if (sysctl_panic_on_oom) {
+	if (unlikely(sysctl_panic_on_oom)) {
+		/*
+		 * panic_on_oom only affects CONSTRAINT_NONE, the kernel
+		 * should not panic for cpuset or mempolicy induced memory
+		 * failures.
+		 */
+		if (constraint == CONSTRAINT_NONE) {
 			dump_header(NULL, gfp_mask, order, NULL);
-			panic("out of memory. panic_on_oom is selected\n");
+			panic("Out of memory: panic_on_oom is enabled\n");
 		}
-		/* Fall-through */
-	case CONSTRAINT_CPUSET:
-		__out_of_memory(gfp_mask, order);
-		break;
 	}
-
+	__out_of_memory(gfp_mask, order, constraint, nodemask);
 	read_unlock(&tasklist_lock);
 
 	/*
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
mempolicy-remove-redundant-code.patch
oom-select-task-from-tasklist-for-mempolicy-ooms.patch
oom-remove-special-handling-for-pagefault-ooms.patch
oom-badness-heuristic-rewrite.patch
oom-reintroduce-and-deprecate-oom_kill_allocating_task.patch
oom-move-sysctl-declarations-to-oomh.patch
oom-deprecate-oom_adj-tunable.patch
oom-replace-sysctls-with-quick-mode.patch
oom-avoid-oom-killer-for-lowmem-allocations.patch
oom-remove-unnecessary-code-and-cleanup.patch
oom-default-to-killing-current-for-pagefault-ooms.patch
oom-avoid-race-for-oom-killed-tasks-detaching-mm-prior-to-exit.patch
oom-select_bad_process-check-pf_kthread-instead-of-mm-to-skip-kthreads.patch
oom-select_bad_process-pf_exiting-check-should-take-mm-into-account.patch
oom-introduce-find_lock_task_mm-to-fix-mm-false-positives.patch
oom-oom_forkbomb_penalty-move-thread_group_cputime-out-of-task_lock.patch
oom-hold-tasklist_lock-when-dumping-tasks.patch
oom-give-current-access-to-memory-reserves-if-it-has-been-killed.patch
oom-avoid-sending-exiting-tasks-a-sigkill.patch
oom-clean-up-oom_kill_task.patch
oom-clean-up-oom_badness.patch
oom-select_bad_process-never-choose-tasks-with-badness-==-0.patch
oom-avoid-divide-by-zero.patch
mempolicy-remove-case-mpol_interleave-from-policy_zonelist.patch
mempolicy-remove-redundant-check.patch
mempolicy-dont-call-mpol_set_nodemask-when-no_context.patch
mempolicy-lose-unnecessary-loop-variable-in-mpol_parse_str.patch
mempolicy-rename-policy_types-and-cleanup-initialization.patch
mempolicy-factor-mpol_shared_policy_init-return-paths.patch
mempolicy-document-cpuset-interaction-with-tmpfs-mpol-mount-option.patch
mempolicy-restructure-rebinding-mempolicy-functions.patch
cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems.patch
cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems-fix2.patch
mm-default-to-node-zonelist-ordering-when-nodes-have-only-lowmem.patch
mmcompaction-memory-compaction-core-do-not-schedule-work-on-other-cpus-for-compaction.patch
memcg-oom-wakeup-filter.patch
memcg-oom-wakeup-filter-update.patch
memcg-oom-notifier.patch
memcg-oom-notifier-update.patch
memcg-oom-kill-disable-and-oom-status.patch
memcg-oom-kill-disable-and-oom-status-update.patch
memcg-make-oom-killer-a-no-op-when-no-killable-task-can-be-found.patch
numa-add-generic-percpu-var-numa_node_id-implementation.patch
numa-add-generic-percpu-var-numa_node_id-implementation-fix1.patch
numa-add-generic-percpu-var-numa_node_id-implementation-fix2.patch
numa-x86_64-use-generic-percpu-var-numa_node_id-implementation.patch
numa-x86_64-use-generic-percpu-var-numa_node_id-implementation-fix1.patch
numa-x86_64-use-generic-percpu-var-numa_node_id-implementation-fix2.patch
numa-ia64-use-generic-percpu-var-numa_node_id-implementation.patch
numa-introduce-numa_mem_id-effective-local-memory-node-id.patch
numa-introduce-numa_mem_id-effective-local-memory-node-id-fix2.patch
numa-introduce-numa_mem_id-effective-local-memory-node-id-fix3.patch
numa-ia64-support-numa_mem_id-for-memoryless-nodes.patch
numa-slab-use-numa_mem_id-for-slab-local-memory-node.patch
numa-in-kernel-profiling-use-cpu_to_mem-for-per-cpu-allocations.patch
numa-update-documentation-vm-numa-add-memoryless-node-info.patch
numa-update-documentation-vm-numa-add-memoryless-node-info-fix1.patch

