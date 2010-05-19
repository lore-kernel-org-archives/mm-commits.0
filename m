From: akpm@linux-foundation.org
Subject: [to-be-updated] oom-remove-special-handling-for-pagefault-ooms.patch removed from -mm tree
Date: Wed, 19 May 2010 11:47:43 -0700
Message-ID: <201005191847.o4JIlhKQ029405@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55972 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754624Ab0ESSsh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 14:48:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, npiggin@suse.de, riel@redhat.com, mm-commits@vge


The patch titled
     oom: remove special handling for pagefault ooms
has been removed from the -mm tree.  Its filename was
     oom-remove-special-handling-for-pagefault-ooms.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom: remove special handling for pagefault ooms
From: David Rientjes <rientjes@google.com>

It is possible to remove the special pagefault oom handler by simply oom
locking all system zones and then calling directly into out_of_memory().

All populated zones must have ZONE_OOM_LOCKED set, otherwise there is a
parallel oom killing in progress that will lead to eventual memory freeing
so it's not necessary to needlessly kill another task.  The context in
which the pagefault is allocating memory is unknown to the oom killer, so
this is done on a system-wide level.

If a task has already been oom killed and hasn't fully exited yet, this
will be a no-op since select_bad_process() recognizes tasks across the
system with TIF_MEMDIE set.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   91 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 59 insertions(+), 32 deletions(-)

diff -puN mm/oom_kill.c~oom-remove-special-handling-for-pagefault-ooms mm/oom_kill.c
--- a/mm/oom_kill.c~oom-remove-special-handling-for-pagefault-ooms
+++ a/mm/oom_kill.c
@@ -583,6 +583,44 @@ void clear_zonelist_oom(struct zonelist 
 }
 
 /*
+ * Try to acquire the oom killer lock for all system zones.  Returns zero if a
+ * parallel oom killing is taking place, otherwise locks all zones and returns
+ * non-zero.
+ */
+static int try_set_system_oom(void)
+{
+	struct zone *zone;
+	int ret = 1;
+
+	spin_lock(&zone_scan_lock);
+	for_each_populated_zone(zone)
+		if (zone_is_oom_locked(zone)) {
+			ret = 0;
+			goto out;
+		}
+	for_each_populated_zone(zone)
+		zone_set_flag(zone, ZONE_OOM_LOCKED);
+out:
+	spin_unlock(&zone_scan_lock);
+	return ret;
+}
+
+/*
+ * Clears ZONE_OOM_LOCKED for all system zones so that failed allocation
+ * attempts or page faults may now recall the oom killer, if necessary.
+ */
+static void clear_system_oom(void)
+{
+	struct zone *zone;
+
+	spin_lock(&zone_scan_lock);
+	for_each_populated_zone(zone)
+		zone_clear_flag(zone, ZONE_OOM_LOCKED);
+	spin_unlock(&zone_scan_lock);
+}
+
+
+/*
  * Must be called with tasklist_lock held for read.
  */
 static void __out_of_memory(gfp_t gfp_mask, int order,
@@ -617,38 +655,9 @@ retry:
 		goto retry;
 }
 
-/*
- * pagefault handler calls into here because it is out of memory but
- * doesn't know exactly how or why.
- */
-void pagefault_out_of_memory(void)
-{
-	unsigned long freed = 0;
-
-	blocking_notifier_call_chain(&oom_notify_list, 0, &freed);
-	if (freed > 0)
-		/* Got some memory back in the last second. */
-		return;
-
-	if (sysctl_panic_on_oom)
-		panic("out of memory from page fault. panic_on_oom is selected.\n");
-
-	read_lock(&tasklist_lock);
-	/* unknown gfp_mask and order */
-	__out_of_memory(0, 0, CONSTRAINT_NONE, NULL);
-	read_unlock(&tasklist_lock);
-
-	/*
-	 * Give "p" a good chance of killing itself before we
-	 * retry to allocate memory.
-	 */
-	if (!test_thread_flag(TIF_MEMDIE))
-		schedule_timeout_uninterruptible(1);
-}
-
 /**
  * out_of_memory - kill the "best" process when we run out of memory
- * @zonelist: zonelist pointer
+ * @zonelist: zonelist pointer passed to page allocator
  * @gfp_mask: memory allocation flags
  * @order: amount of memory being requested as a power of 2
  * @nodemask: nodemask passed to page allocator
@@ -662,7 +671,7 @@ void out_of_memory(struct zonelist *zone
 		int order, nodemask_t *nodemask)
 {
 	unsigned long freed = 0;
-	enum oom_constraint constraint;
+	enum oom_constraint constraint = CONSTRAINT_NONE;
 
 	blocking_notifier_call_chain(&oom_notify_list, 0, &freed);
 	if (freed > 0)
@@ -678,7 +687,8 @@ void out_of_memory(struct zonelist *zone
 	 * Check if there were limitations on the allocation (only relevant for
 	 * NUMA) that may require different handling.
 	 */
-	constraint = constrained_alloc(zonelist, gfp_mask, nodemask);
+	if (zonelist)
+		constraint = constrained_alloc(zonelist, gfp_mask, nodemask);
 	read_lock(&tasklist_lock);
 	if (unlikely(sysctl_panic_on_oom)) {
 		/*
@@ -688,6 +698,7 @@ void out_of_memory(struct zonelist *zone
 		 */
 		if (constraint == CONSTRAINT_NONE) {
 			dump_header(NULL, gfp_mask, order, NULL);
+			read_unlock(&tasklist_lock);
 			panic("Out of memory: panic_on_oom is enabled\n");
 		}
 	}
@@ -701,3 +712,19 @@ void out_of_memory(struct zonelist *zone
 	if (!test_thread_flag(TIF_MEMDIE))
 		schedule_timeout_uninterruptible(1);
 }
+
+/*
+ * The pagefault handler calls here because it is out of memory, so kill a
+ * memory-hogging task.  If a populated zone has ZONE_OOM_LOCKED set, a parallel
+ * oom killing is already in progress so do nothing.  If a task is found with
+ * TIF_MEMDIE set, it has been killed so do nothing and allow it to exit.
+ */
+void pagefault_out_of_memory(void)
+{
+	if (try_set_system_oom()) {
+		out_of_memory(NULL, 0, 0, NULL);
+		clear_system_oom();
+	}
+	if (!test_thread_flag(TIF_MEMDIE))
+		schedule_timeout_uninterruptible(1);
+}
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
mempolicy-remove-redundant-code.patch
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

