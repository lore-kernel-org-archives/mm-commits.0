From: akpm@linux-foundation.org
Subject: + mm-oom-replace-some-information-in-tasklist-dump.patch added to -mm tree
Date: Fri, 22 Jun 2012 14:50:28 -0700
Message-ID: <20120622215028.68334A0123@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:35460 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab2FVVub (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Jun 2012 17:50:31 -0400
Received: by wgbdt11 with SMTP id dt11so130138wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Jun 2012 14:50:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     Subject: mm, oom: replace some information in tasklist dump
has been added to the -mm tree.  Its filename is
     mm-oom-replace-some-information-in-tasklist-dump.patch

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
Subject: mm, oom: replace some information in tasklist dump

The number of ptes and swap entries are used in the oom killer's badness
heuristic, so they should be shown in the tasklist dump.

This patch adds those fields and replaces cpu and oom_adj values that are
currently emitted.  Cpu isn't interesting and oom_adj is deprecated and
will be removed later this year, the same information is already displayed
as oom_score_adj which is used internally.

At the same time, make the documentation a little more clear to state this
information is helpful to determine why the oom killer chose the task it
did to kill.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |    7 ++++---
 mm/oom_kill.c               |   11 ++++++-----
 2 files changed, 10 insertions(+), 8 deletions(-)

diff -puN Documentation/sysctl/vm.txt~mm-oom-replace-some-information-in-tasklist-dump Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-oom-replace-some-information-in-tasklist-dump
+++ a/Documentation/sysctl/vm.txt
@@ -491,9 +491,10 @@ oom_dump_tasks
 
 Enables a system-wide task dump (excluding kernel threads) to be
 produced when the kernel performs an OOM-killing and includes such
-information as pid, uid, tgid, vm size, rss, cpu, oom_adj score, and
-name.  This is helpful to determine why the OOM killer was invoked
-and to identify the rogue task that caused it.
+information as pid, uid, tgid, vm size, rss, nr_ptes, swapents,
+oom_score_adj score, and name.  This is helpful to determine why the
+OOM killer was invoked, to identify the rogue task that caused it,
+and to determine why the OOM killer chose the task it did to kill.
 
 If this is set to zero, this information is suppressed.  On very
 large systems with thousands of tasks it may not be feasible to dump
diff -puN mm/oom_kill.c~mm-oom-replace-some-information-in-tasklist-dump mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-replace-some-information-in-tasklist-dump
+++ a/mm/oom_kill.c
@@ -371,8 +371,8 @@ static struct task_struct *select_bad_pr
  * Dumps the current memory state of all eligible tasks.  Tasks not in the same
  * memcg, not in the same cpuset, or bound to a disjoint set of mempolicy nodes
  * are not shown.
- * State information includes task's pid, uid, tgid, vm size, rss, cpu, oom_adj
- * value, oom_score_adj value, and name.
+ * State information includes task's pid, uid, tgid, vm size, rss, nr_ptes,
+ * swapents, oom_score_adj value, and name.
  *
  * Call with tasklist_lock read-locked.
  */
@@ -381,7 +381,7 @@ static void dump_tasks(const struct mem_
 	struct task_struct *p;
 	struct task_struct *task;
 
-	pr_info("[ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name\n");
+	pr_info("[ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name\n");
 	for_each_process(p) {
 		if (oom_unkillable_task(p, memcg, nodemask))
 			continue;
@@ -396,10 +396,11 @@ static void dump_tasks(const struct mem_
 			continue;
 		}
 
-		pr_info("[%5d] %5d %5d %8lu %8lu %3u     %3d         %5d %s\n",
+		pr_info("[%5d] %5d %5d %8lu %8lu %7lu %8lu         %5d %s\n",
 			task->pid, from_kuid(&init_user_ns, task_uid(task)),
 			task->tgid, task->mm->total_vm, get_mm_rss(task->mm),
-			task_cpu(task), task->signal->oom_adj,
+			task->mm->nr_ptes,
+			get_mm_counter(task->mm, MM_SWAPENTS),
 			task->signal->oom_score_adj, task->comm);
 		task_unlock(task);
 	}
_
Subject: Subject: mm, oom: replace some information in tasklist dump

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix.patch
mm-thp-abort-compaction-if-migration-page-cannot-be-charged-to-memcg.patch
slab-move-full-state-transition-to-an-initcall.patch
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
hugetlb-cgroup-add-the-cgroup-pointer-to-page-lru.patch
hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup.patch
hugetlb-cgroup-add-support-for-cgroup-removal.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files.patch
hugetlb-cgroup-migrate-hugetlb-cgroup-info-from-oldpage-to-new-page-during-migration.patch
hugetlb-cgroup-add-hugetlb-controller-documentation.patch
mm-oom-do-not-schedule-if-current-has-been-killed.patch
mm-compaction-cleanup-on-compaction_deferred.patch
mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator-again.patch
mm-oom-fix-potential-killing-of-thread-that-is-disabled-from-oom-killing.patch
mm-oom-replace-some-information-in-tasklist-dump.patch

