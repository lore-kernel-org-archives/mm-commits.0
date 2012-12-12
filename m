From: akpm@linux-foundation.org
Subject: [merged] mm-oom-allow-exiting-threads-to-have-access-to-memory-reserves.patch removed from -mm tree
Date: Wed, 12 Dec 2012 11:58:46 -0800
Message-ID: <20121212195846.9610382004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:60233 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2LLT6r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 14:58:47 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so117301vcd.5
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 11:58:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, kosaki.motohiro@jp.fujitsu.com, minchan@kernel.org, semenzato@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: allow exiting threads to have access to memory reserves
has been removed from the -mm tree.  Its filename was
     mm-oom-allow-exiting-threads-to-have-access-to-memory-reserves.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: allow exiting threads to have access to memory reserves

Exiting threads, those with PF_EXITING set, can pagefault and require
memory before they can make forward progress.  This happens, for instance,
when a process must fault task->robust_list, a userspace structure, before
detaching its memory.

These threads also aren't guaranteed to get access to memory reserves
unless oom killed or killed from userspace.  The oom killer won't grant
memory reserves if other threads are also exiting other than current and
stalling at the same point.  This prevents needlessly killing processes
when others are already exiting.

Instead of special casing all the possible situations between PF_EXITING
getting set and a thread detaching its mm where it may allocate memory,
which probably wouldn't get updated when a change is made to the exit
path, the solution is to give all exiting threads access to memory
reserves if they call the oom killer.  This allows them to quickly
allocate, detach its mm, and free the memory it represents.

Summary of Luigi's bug report:

: He had an oom condition where threads were faulting on task->robust_list
: and repeatedly called the oom killer but it would defer killing a thread
: because it saw other PF_EXITING threads.  This can happen anytime we need
: to allocate memory after setting PF_EXITING and before detaching our mm;
: if there are other threads in the same state then the oom killer won't do
: anything unless one of them happens to be killed from userspace.
: 
: So instead of only deferring for PF_EXITING and !task->robust_list, it's
: better to just give them access to memory reserves to prevent a potential
: livelock so that any other faults that may be introduced in the future in
: the exit path don't cause the same problem (and hopefully we don't allow
: too many of those!).

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Tested-by: Luigi Semenzato <semenzato@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   31 +++++++++----------------------
 1 file changed, 9 insertions(+), 22 deletions(-)

diff -puN mm/oom_kill.c~mm-oom-allow-exiting-threads-to-have-access-to-memory-reserves mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-allow-exiting-threads-to-have-access-to-memory-reserves
+++ a/mm/oom_kill.c
@@ -310,26 +310,13 @@ enum oom_scan_t oom_scan_process_thread(
 	if (!task->mm)
 		return OOM_SCAN_CONTINUE;
 
-	if (task->flags & PF_EXITING) {
+	if (task->flags & PF_EXITING && !force_kill) {
 		/*
-		 * If task is current and is in the process of releasing memory,
-		 * allow the "kill" to set TIF_MEMDIE, which will allow it to
-		 * access memory reserves.  Otherwise, it may stall forever.
-		 *
-		 * The iteration isn't broken here, however, in case other
-		 * threads are found to have already been oom killed.
+		 * If this task is not being ptraced on exit, then wait for it
+		 * to finish before killing some other task unnecessarily.
 		 */
-		if (task == current)
-			return OOM_SCAN_SELECT;
-		else if (!force_kill) {
-			/*
-			 * If this task is not being ptraced on exit, then wait
-			 * for it to finish before killing some other task
-			 * unnecessarily.
-			 */
-			if (!(task->group_leader->ptrace & PT_TRACE_EXIT))
-				return OOM_SCAN_ABORT;
-		}
+		if (!(task->group_leader->ptrace & PT_TRACE_EXIT))
+			return OOM_SCAN_ABORT;
 	}
 	return OOM_SCAN_OK;
 }
@@ -706,11 +693,11 @@ void out_of_memory(struct zonelist *zone
 		return;
 
 	/*
-	 * If current has a pending SIGKILL, then automatically select it.  The
-	 * goal is to allow it to allocate so that it may quickly exit and free
-	 * its memory.
+	 * If current has a pending SIGKILL or is exiting, then automatically
+	 * select it.  The goal is to allow it to allocate so that it may
+	 * quickly exit and free its memory.
 	 */
-	if (fatal_signal_pending(current)) {
+	if (fatal_signal_pending(current) || current->flags & PF_EXITING) {
 		set_thread_flag(TIF_MEMDIE);
 		return;
 	}
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
thp-huge-zero-page-basic-preparation.patch
thp-huge-zero-page-basic-preparation-v6.patch
thp-zap_huge_pmd-zap-huge-zero-pmd.patch
thp-copy_huge_pmd-copy-huge-zero-page.patch
thp-copy_huge_pmd-copy-huge-zero-page-v6.patch
thp-copy_huge_pmd-copy-huge-zero-page-v6-fix.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page-v6.patch
thp-change_huge_pmd-make-sure-we-dont-try-to-make-a-page-writable.patch
thp-change-split_huge_page_pmd-interface.patch
thp-change-split_huge_page_pmd-interface-v6.patch
thp-implement-splitting-pmd-for-huge-zero-page.patch
thp-implement-splitting-pmd-for-huge-zero-page-v6.patch
thp-setup-huge-zero-page-on-non-write-page-fault.patch
thp-setup-huge-zero-page-on-non-write-page-fault-fix.patch
thp-lazy-huge-zero-page-allocation.patch
thp-implement-refcounting-for-huge-zero-page.patch
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events.patch
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events-v6.patch
thp-introduce-sysfs-knob-to-disable-huge-zero-page.patch
thp-avoid-race-on-multiple-parallel-page-faults-to-the-same-page.patch
node_states-introduce-n_memory.patch
cpuset-use-n_memory-instead-n_high_memory.patch
procfs-use-n_memory-instead-n_high_memory.patch
memcontrol-use-n_memory-instead-n_high_memory.patch
oom-use-n_memory-instead-n_high_memory.patch
mmmigrate-use-n_memory-instead-n_high_memory.patch
mempolicy-use-n_memory-instead-n_high_memory.patch
hugetlb-use-n_memory-instead-n_high_memory.patch
vmstat-use-n_memory-instead-n_high_memory.patch
kthread-use-n_memory-instead-n_high_memory.patch
init-use-n_memory-instead-n_high_memory.patch
vmscan-use-n_memory-instead-n_high_memory.patch
page_alloc-use-n_memory-instead-n_high_memory-change-the-node_states-initialization.patch
hotplug-update-nodemasks-management.patch
hotplug-update-nodemasks-management-fix.patch
mm-memcg-avoid-unnecessary-function-call-when-memcg-is-disabled.patch
mm-memcg-avoid-unnecessary-function-call-when-memcg-is-disabled-fix.patch
numa-add-config_movable_node-for-movable-dedicated-node.patch
numa-add-config_movable_node-for-movable-dedicated-node-fix.patch
memory_hotplug-allow-online-offline-memory-to-result-movable-node.patch
mm-oom-cleanup-pagefault-oom-handler.patch
mm-oom-remove-redundant-sleep-in-pagefault-oom-handler.patch
mm-oom-remove-statically-defined-arch-functions-of-same-name.patch
mm-introduce-new-field-managed_pages-to-struct-zone.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap-fix.patch
memcg-do-not-check-for-mm-in-mem_cgroup_count_vm_event-disabled.patch
linux-next.patch
x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions.patch
x86-fix-the-argument-passed-to-sync_global_pgds.patch
irq-tsk-comm-is-an-array.patch
mm-mempolicy-introduce-spinlock-to-read-shared-policy-tree.patch
mm-dmapoolc-fix-null-dev-in-dma_pool_create.patch

