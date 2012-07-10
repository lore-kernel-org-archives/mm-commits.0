From: akpm@linux-foundation.org
Subject: + mm-oom-introduce-helper-function-to-process-threads-during-scan.patch added to -mm tree
Date: Tue, 10 Jul 2012 14:17:55 -0700
Message-ID: <20120710211756.827495C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:63197 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab2GJVR7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jul 2012 17:17:59 -0400
Received: by eaao13 with SMTP id o13so20672eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jul 2012 14:17:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, oleg@redhat.com


The patch titled
     Subject: mm, oom: introduce helper function to process threads during scan
has been added to the -mm tree.  Its filename is
     mm-oom-introduce-helper-function-to-process-threads-during-scan.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: introduce helper function to process threads during scan

This patch introduces a helper function to process each thread during the
iteration over the tasklist.  A new return type, enum oom_scan_t, is
defined to determine the future behavior of the iteration:

 - OOM_SCAN_OK: continue scanning the thread and find its badness,

 - OOM_SCAN_CONTINUE: do not consider this thread for oom kill, it's
   ineligible,

 - OOM_SCAN_ABORT: abort the iteration and return, or

 - OOM_SCAN_SELECT: always select this thread with the highest badness
   possible.

There is no functional change with this patch.  This new helper function
will be used in the next patch in the memory controller.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |  111 ++++++++++++++++++++++++++++--------------------
 1 file changed, 65 insertions(+), 46 deletions(-)

diff -puN mm/oom_kill.c~mm-oom-introduce-helper-function-to-process-threads-during-scan mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-introduce-helper-function-to-process-threads-during-scan
+++ a/mm/oom_kill.c
@@ -288,6 +288,59 @@ static enum oom_constraint constrained_a
 }
 #endif
 
+enum oom_scan_t {
+	OOM_SCAN_OK,		/* scan thread and find its badness */
+	OOM_SCAN_CONTINUE,	/* do not consider thread for oom kill */
+	OOM_SCAN_ABORT,		/* abort the iteration and return */
+	OOM_SCAN_SELECT,	/* always select this thread first */
+};
+
+static enum oom_scan_t oom_scan_process_thread(struct task_struct *task,
+		struct mem_cgroup *memcg, unsigned long totalpages,
+		const nodemask_t *nodemask, bool force_kill)
+{
+	if (task->exit_state)
+		return OOM_SCAN_CONTINUE;
+	if (oom_unkillable_task(task, memcg, nodemask))
+		return OOM_SCAN_CONTINUE;
+
+	/*
+	 * This task already has access to memory reserves and is being killed.
+	 * Don't allow any other task to have access to the reserves.
+	 */
+	if (test_tsk_thread_flag(task, TIF_MEMDIE)) {
+		if (unlikely(frozen(task)))
+			__thaw_task(task);
+		if (!force_kill)
+			return OOM_SCAN_ABORT;
+	}
+	if (!task->mm)
+		return OOM_SCAN_CONTINUE;
+
+	if (task->flags & PF_EXITING) {
+		/*
+		 * If task is current and is in the process of releasing memory,
+		 * allow the "kill" to set TIF_MEMDIE, which will allow it to
+		 * access memory reserves.  Otherwise, it may stall forever.
+		 *
+		 * The iteration isn't broken here, however, in case other
+		 * threads are found to have already been oom killed.
+		 */
+		if (task == current)
+			return OOM_SCAN_SELECT;
+		else if (!force_kill) {
+			/*
+			 * If this task is not being ptraced on exit, then wait
+			 * for it to finish before killing some other task
+			 * unnecessarily.
+			 */
+			if (!(task->group_leader->ptrace & PT_TRACE_EXIT))
+				return OOM_SCAN_ABORT;
+		}
+	}
+	return OOM_SCAN_OK;
+}
+
 /*
  * Simple selection loop. We chose the process with the highest
  * number of 'points'. We expect the caller will lock the tasklist.
@@ -305,53 +358,19 @@ static struct task_struct *select_bad_pr
 	do_each_thread(g, p) {
 		unsigned int points;
 
-		if (p->exit_state)
-			continue;
-		if (oom_unkillable_task(p, memcg, nodemask))
-			continue;
-
-		/*
-		 * This task already has access to memory reserves and is
-		 * being killed. Don't allow any other task access to the
-		 * memory reserve.
-		 *
-		 * Note: this may have a chance of deadlock if it gets
-		 * blocked waiting for another task which itself is waiting
-		 * for memory. Is there a better alternative?
-		 */
-		if (test_tsk_thread_flag(p, TIF_MEMDIE)) {
-			if (unlikely(frozen(p)))
-				__thaw_task(p);
-			if (!force_kill)
-				return ERR_PTR(-1UL);
-		}
-		if (!p->mm)
+		switch (oom_scan_process_thread(p, memcg, totalpages, nodemask,
+						force_kill)) {
+		case OOM_SCAN_SELECT:
+			chosen = p;
+			chosen_points = ULONG_MAX;
+			/* fall through */
+		case OOM_SCAN_CONTINUE:
 			continue;
-
-		if (p->flags & PF_EXITING) {
-			/*
-			 * If p is the current task and is in the process of
-			 * releasing memory, we allow the "kill" to set
-			 * TIF_MEMDIE, which will allow it to gain access to
-			 * memory reserves.  Otherwise, it may stall forever.
-			 *
-			 * The loop isn't broken here, however, in case other
-			 * threads are found to have already been oom killed.
-			 */
-			if (p == current) {
-				chosen = p;
-				chosen_points = ULONG_MAX;
-			} else if (!force_kill) {
-				/*
-				 * If this task is not being ptraced on exit,
-				 * then wait for it to finish before killing
-				 * some other task unnecessarily.
-				 */
-				if (!(p->group_leader->ptrace & PT_TRACE_EXIT))
-					return ERR_PTR(-1UL);
-			}
-		}
-
+		case OOM_SCAN_ABORT:
+			return ERR_PTR(-1UL);
+		case OOM_SCAN_OK:
+			break;
+		};
 		points = oom_badness(p, memcg, nodemask, totalpages);
 		if (points > chosen_points) {
 			chosen = p;
_
Subject: Subject: mm, oom: introduce helper function to process threads during scan

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix.patch
mm-thp-abort-compaction-if-migration-page-cannot-be-charged-to-memcg.patch
mm-memory_hotplugc-release-memory-resources-if-hotadd_new_pgdat-fails.patch
slab-do-not-call-compound_head-in-page_get_cache.patch
mm-buddy-cleanup-on-should_fail_alloc_page.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlb-dont-use-err_ptr-with-vm_fault-values.patch
hugetlb-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
hugetlb-add-a-list-for-tracking-in-use-hugetlb-pages.patch
hugetlb-make-some-static-variables-global.patch
mm-hugetlb-add-new-hugetlb-cgroup.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix-fix.patch
hugetlb-cgroup-add-the-cgroup-pointer-to-page-lru.patch
hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup.patch
hugetlb-cgroup-add-support-for-cgroup-removal.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix-fix.patch
hugetlb-cgroup-migrate-hugetlb-cgroup-info-from-oldpage-to-new-page-during-migration.patch
hugetlb-cgroup-add-hugetlb-controller-documentation.patch
mm-oom-do-not-schedule-if-current-has-been-killed.patch
mm-compaction-cleanup-on-compaction_deferred.patch
mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator-again.patch
mm-oom-fix-potential-killing-of-thread-that-is-disabled-from-oom-killing.patch
mm-oom-replace-some-information-in-tasklist-dump.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix.patch
memcg-rename-config-variables-fix-fix.patch
mm-setup-pageblock_order-before-its-used-by-sparsemem.patch
mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat.patch
mm-hotplug-correctly-add-new-zone-to-all-other-nodes-zone-lists.patch
mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty.patch
mm-hotplug-mark-memory-hotplug-code-in-page_allocc-as-__meminit.patch
mm-oom-move-declaration-for-mem_cgroup_out_of_memory-to-oomh.patch
mm-oom-introduce-helper-function-to-process-threads-during-scan.patch
mm-memcg-introduce-own-oom-handler-to-iterate-only-over-its-own-threads.patch
mm-oom-reduce-dependency-on-tasklist_lock.patch
mm-memcg-move-all-oom-handling-to-memcontrolc.patch

