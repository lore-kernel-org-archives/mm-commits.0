From: akpm@linux-foundation.org
Subject: [to-be-updated] oom-default-to-killing-current-for-pagefault-ooms.patch removed from -mm tree
Date: Wed, 19 May 2010 11:48:05 -0700
Message-ID: <201005191848.o4JIm520029461@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41979 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753870Ab0ESS4f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 14:56:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, npiggin@suse.de, riel@redhat.com, mm-commits@vge


The patch titled
     oom: default to killing current for pagefault ooms
has been removed from the -mm tree.  Its filename was
     oom-default-to-killing-current-for-pagefault-ooms.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom: default to killing current for pagefault ooms
From: David Rientjes <rientjes@google.com>

The pagefault oom handler does not know the context (gfp_mask, order, etc)
in which memory was not found when a VM_FAULT_OOM is generated.  The only
information known is that current is trying to allocate in that context,
so killing it is a legitimate response (and is the default for
architectures that do not even use the pagefault oom handler such as ia64
and powerpc).

When a VM_FAULT_OOM occurs, the pagefault oom handler will now attempt to
kill current by default.  If it is unkillable, the oom killer is called to
find a memory-hogging task to kill instead that will lead to future memory
freeing.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff -puN mm/oom_kill.c~oom-default-to-killing-current-for-pagefault-ooms mm/oom_kill.c
--- a/mm/oom_kill.c~oom-default-to-killing-current-for-pagefault-ooms
+++ a/mm/oom_kill.c
@@ -726,15 +726,23 @@ void out_of_memory(struct zonelist *zone
 }
 
 /*
- * The pagefault handler calls here because it is out of memory, so kill a
- * memory-hogging task.  If a populated zone has ZONE_OOM_LOCKED set, a parallel
- * oom killing is already in progress so do nothing.  If a task is found with
- * TIF_MEMDIE set, it has been killed so do nothing and allow it to exit.
+ * The pagefault handler calls here because it is out of memory, so kill current
+ * by default.  If it's unkillable, then fallback to killing a memory-hogging
+ * task.  If a populated zone has ZONE_OOM_LOCKED set, a parallel oom killing is
+ * already in progress so do nothing.  If a task is found with TIF_MEMDIE set,
+ * it has been killed so do nothing and allow it to exit.
  */
 void pagefault_out_of_memory(void)
 {
+	unsigned long totalpages;
+	int err;
+
 	if (try_set_system_oom()) {
-		out_of_memory(NULL, 0, 0, NULL);
+		constrained_alloc(NULL, 0, NULL, &totalpages);
+		err = oom_kill_process(current, 0, 0, 0, totalpages, NULL,
+					"Out of memory (pagefault)");
+		if (err)
+			out_of_memory(NULL, 0, 0, NULL);
 		clear_system_oom();
 	}
 	if (!test_thread_flag(TIF_MEMDIE))
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
mempolicy-remove-redundant-code.patch
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

