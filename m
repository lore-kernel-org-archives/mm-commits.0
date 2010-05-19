From: akpm@linux-foundation.org
Subject: [to-be-updated] oom-avoid-race-for-oom-killed-tasks-detaching-mm-prior-to-exit.patch removed from -mm tree
Date: Wed, 19 May 2010 11:48:08 -0700
Message-ID: <201005191848.o4JIm8Tu029469@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55303 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754197Ab0ESSsx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 14:48:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, npiggin@suse.de, riel@redhat.com, mm-commits@vge


The patch titled
     oom: avoid race for oom killed tasks detaching mm prior to exit
has been removed from the -mm tree.  Its filename was
     oom-avoid-race-for-oom-killed-tasks-detaching-mm-prior-to-exit.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom: avoid race for oom killed tasks detaching mm prior to exit
From: David Rientjes <rientjes@google.com>

Tasks detach its ->mm prior to exiting so it's possible that in progress
oom kills or already exiting tasks may be missed during the oom killer's
tasklist scan.  When an eligible task is found with either TIF_MEMDIE or
PF_EXITING set, the oom killer is supposed to be a no-op to avoid
needlessly killing additional tasks.  This closes the race between a task
detaching its ->mm and being removed from the tasklist.

Out of memory conditions as the result of memory controllers will
automatically filter tasks that have detached their ->mm (since
task_in_mem_cgroup() will return 0).  This is acceptable, however, since
memcg constrained ooms aren't the result of a lack of memory resources but
rather a limit imposed by userspace that requires a task be killed
regardless.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/oom_kill.c~oom-avoid-race-for-oom-killed-tasks-detaching-mm-prior-to-exit mm/oom_kill.c
--- a/mm/oom_kill.c~oom-avoid-race-for-oom-killed-tasks-detaching-mm-prior-to-exit
+++ a/mm/oom_kill.c
@@ -305,12 +305,6 @@ static struct task_struct *select_bad_pr
 	for_each_process(p) {
 		unsigned int points;
 
-		/*
-		 * skip kernel threads and tasks which have already released
-		 * their mm.
-		 */
-		if (!p->mm)
-			continue;
 		/* skip the init task */
 		if (is_global_init(p))
 			continue;
@@ -351,6 +345,12 @@ static struct task_struct *select_bad_pr
 			*ppoints = 1000;
 		}
 
+		/*
+		 * skip kernel threads and tasks which have already released
+		 * their mm.
+		 */
+		if (!p->mm)
+			continue;
 		if (p->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
 			continue;
 
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
mempolicy-remove-redundant-code.patch
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

