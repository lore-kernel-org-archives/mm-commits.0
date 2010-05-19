From: akpm@linux-foundation.org
Subject: [to-be-updated] oom-filter-tasks-not-sharing-the-same-cpuset.patch removed from -mm tree
Date: Wed, 19 May 2010 11:47:31 -0700
Message-ID: <201005191847.o4JIlW1r029393@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54284 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754295Ab0ESSsf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 14:48:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, npiggin@suse.de, riel@redhat.com, mm-commits@vge


The patch titled
     oom: filter tasks not sharing the same cpuset
has been removed from the -mm tree.  Its filename was
     oom-filter-tasks-not-sharing-the-same-cpuset.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom: filter tasks not sharing the same cpuset
From: David Rientjes <rientjes@google.com>

Tasks that do not share the same set of allowed nodes with the task that
triggered the oom should not be considered as candidates for oom kill.

Tasks in other cpusets with a disjoint set of mems would be unfairly
penalized otherwise because of oom conditions elsewhere; an extreme
example could unfairly kill all other applications on the system if a
single task in a user's cpuset sets itself to OOM_DISABLE and then uses
more memory than allowed.

Killing tasks outside of current's cpuset rarely would free memory for
current anyway.  To use a sane heuristic, we must ensure that killing a
task would likely free memory for current and avoid needlessly killing
others at all costs just because their potential memory freeing is
unknown.  It is better to kill current than another task needlessly.

Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff -puN mm/oom_kill.c~oom-filter-tasks-not-sharing-the-same-cpuset mm/oom_kill.c
--- a/mm/oom_kill.c~oom-filter-tasks-not-sharing-the-same-cpuset
+++ a/mm/oom_kill.c
@@ -36,7 +36,7 @@ static DEFINE_SPINLOCK(zone_scan_lock);
 /* #define DEBUG */
 
 /*
- * Is all threads of the target process nodes overlap ours?
+ * Do all threads of the target process overlap our allowed nodes?
  */
 static int has_intersects_mems_allowed(struct task_struct *tsk)
 {
@@ -168,14 +168,6 @@ unsigned long badness(struct task_struct
 		points /= 4;
 
 	/*
-	 * If p's nodes don't overlap ours, it may still help to kill p
-	 * because p may have allocated or otherwise mapped memory on
-	 * this node before. However it will be less likely.
-	 */
-	if (!has_intersects_mems_allowed(p))
-		points /= 8;
-
-	/*
 	 * Adjust the score by oom_adj.
 	 */
 	if (oom_adj) {
@@ -267,6 +259,8 @@ static struct task_struct *select_bad_pr
 			continue;
 		if (mem && !task_in_mem_cgroup(p, mem))
 			continue;
+		if (!has_intersects_mems_allowed(p))
+			continue;
 
 		/*
 		 * This task already has access to memory reserves and is
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
mempolicy-remove-redundant-code.patch
oom-filter-tasks-not-sharing-the-same-cpuset.patch
oom-sacrifice-child-with-highest-badness-score-for-parent.patch
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

