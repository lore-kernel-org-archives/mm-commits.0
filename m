From: akpm@linux-foundation.org
Subject: [to-be-updated] oom-give-current-access-to-memory-reserves-if-it-has-been-killed.patch removed from -mm tree
Date: Wed, 19 May 2010 11:48:22 -0700
Message-ID: <201005191848.o4JImMe1029499@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40556 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754197Ab0ESSs7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 14:48:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     oom: give current access to memory reserves if it has been killed
has been removed from the -mm tree.  Its filename was
     oom-give-current-access-to-memory-reserves-if-it-has-been-killed.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom: give current access to memory reserves if it has been killed
From: David Rientjes <rientjes@google.com>

It's possible to livelock the page allocator if a thread has mm->mmap_sem
and fails to make forward progress because the oom killer selects another
thread sharing the same ->mm to kill that cannot exit until the semaphore
is dropped.

The oom killer will not kill multiple tasks at the same time; each oom
killed task must exit before another task may be killed.  Thus, if one
thread is holding mm->mmap_sem and cannot allocate memory, all threads
sharing the same ->mm are blocked from exiting as well.  In the oom kill
case, that means the thread holding mm->mmap_sem will never free
additional memory since it cannot get access to memory reserves and the
thread that depends on it with access to memory reserves cannot exit
because it cannot acquire the semaphore.  Thus, the page allocators
livelocks.

When the oom killer is called and current happens to have a pending
SIGKILL, this patch automatically gives it access to memory reserves and
returns.  Upon returning to the page allocator, its allocation will
hopefully succeed so it can quickly exit and free its memory.  If not, the
page allocator will fail the allocation if it is not __GFP_NOFAIL.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN mm/oom_kill.c~oom-give-current-access-to-memory-reserves-if-it-has-been-killed mm/oom_kill.c
--- a/mm/oom_kill.c~oom-give-current-access-to-memory-reserves-if-it-has-been-killed
+++ a/mm/oom_kill.c
@@ -698,6 +698,16 @@ void out_of_memory(struct zonelist *zone
 		return;
 
 	/*
+	 * If current has a pending SIGKILL, then automatically select it.  The
+	 * goal is to allow it to allocate so that it may quickly exit and free
+	 * its memory.
+	 */
+	if (fatal_signal_pending(current)) {
+		set_tsk_thread_flag(current, TIF_MEMDIE);
+		return;
+	}
+
+	/*
 	 * Check if there were limitations on the allocation (only relevant for
 	 * NUMA) that may require different handling.
 	 */
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
mempolicy-remove-redundant-code.patch
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

