From: akpm@linux-foundation.org
Subject: [to-be-updated] oom-avoid-oom-killer-for-lowmem-allocations.patch removed from -mm tree
Date: Wed, 19 May 2010 11:47:59 -0700
Message-ID: <201005191847.o4JIlxTZ029449@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754000Ab0ESSsv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 14:48:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, npiggin@suse.de, riel@redhat.com, mm-commits@vge


The patch titled
     oom: avoid oom killer for lowmem allocations
has been removed from the -mm tree.  Its filename was
     oom-avoid-oom-killer-for-lowmem-allocations.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom: avoid oom killer for lowmem allocations
From: David Rientjes <rientjes@google.com>

If memory has been depleted in lowmem zones even with the protection
afforded to it by /proc/sys/vm/lowmem_reserve_ratio, it is unlikely that
killing current users will help.  The memory is either reclaimable (or
migratable) already, in which case we should not invoke the oom killer at
all, or it is pinned by an application for I/O.  Killing such an
application may leave the hardware in an unspecified state and there is no
guarantee that it will be able to make a timely exit.

Lowmem allocations are now failed in oom conditions when __GFP_NOFAIL is
not used so that the task can perhaps recover or try again later.

Previously, the heuristic provided some protection for those tasks with
CAP_SYS_RAWIO, but this is no longer necessary since we will not be
killing tasks for the purposes of ISA allocations.

high_zoneidx is gfp_zone(gfp_flags), meaning that ZONE_NORMAL will be the
default for all allocations that are not __GFP_DMA, __GFP_DMA32,
__GFP_HIGHMEM, and __GFP_MOVABLE on kernels configured to support those
flags.  Testing for high_zoneidx being less than ZONE_NORMAL will only
return true for allocations that have either __GFP_DMA or __GFP_DMA32.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff -puN mm/page_alloc.c~oom-avoid-oom-killer-for-lowmem-allocations mm/page_alloc.c
--- a/mm/page_alloc.c~oom-avoid-oom-killer-for-lowmem-allocations
+++ a/mm/page_alloc.c
@@ -1695,6 +1695,9 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 		/* The OOM killer will not help higher order allocs */
 		if (order > PAGE_ALLOC_COSTLY_ORDER)
 			goto out;
+		/* The OOM killer does not needlessly kill tasks for lowmem */
+		if (high_zoneidx < ZONE_NORMAL)
+			goto out;
 		/*
 		 * GFP_THISNODE contains __GFP_NORETRY and we never hit this.
 		 * Sanity check for bare calls of __GFP_THISNODE, not real OOM.
@@ -1923,15 +1926,23 @@ rebalance:
 			if (page)
 				goto got_pg;
 
-			/*
-			 * The OOM killer does not trigger for high-order
-			 * ~__GFP_NOFAIL allocations so if no progress is being
-			 * made, there are no other options and retrying is
-			 * unlikely to help.
-			 */
-			if (order > PAGE_ALLOC_COSTLY_ORDER &&
-						!(gfp_mask & __GFP_NOFAIL))
-				goto nopage;
+			if (!(gfp_mask & __GFP_NOFAIL)) {
+				/*
+				 * The oom killer is not called for high-order
+				 * allocations that may fail, so if no progress
+				 * is being made, there are no other options and
+				 * retrying is unlikely to help.
+				 */
+				if (order > PAGE_ALLOC_COSTLY_ORDER)
+					goto nopage;
+				/*
+				 * The oom killer is not called for lowmem
+				 * allocations to prevent needlessly killing
+				 * innocent tasks.
+				 */
+				if (high_zoneidx < ZONE_NORMAL)
+					goto nopage;
+			}
 
 			goto restart;
 		}
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
mempolicy-remove-redundant-code.patch
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

