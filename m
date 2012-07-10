From: akpm@linux-foundation.org
Subject: + mm-memcg-move-all-oom-handling-to-memcontrolc.patch added to -mm tree
Date: Tue, 10 Jul 2012 14:18:07 -0700
Message-ID: <20120710211808.4CC8C100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:52688 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab2GJVSJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jul 2012 17:18:09 -0400
Received: by yenl3 with SMTP id l3so52793yen.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jul 2012 14:18:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, oleg@redhat.com


The patch titled
     Subject: mm, memcg: move all oom handling to memcontrol.c
has been added to the -mm tree.  Its filename is
     mm-memcg-move-all-oom-handling-to-memcontrolc.patch

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
Subject: mm, memcg: move all oom handling to memcontrol.c

By globally defining check_panic_on_oom(), the memcg oom handler can be
moved entirely to mm/memcontrol.c.  This removes the ugly #ifdef in the
oom killer and cleans up the code.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 --
 include/linux/oom.h        |    3 +++
 mm/memcontrol.c            |   15 +++++++++++++--
 mm/oom_kill.c              |   23 ++---------------------
 4 files changed, 18 insertions(+), 25 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcg-move-all-oom-handling-to-memcontrolc include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcg-move-all-oom-handling-to-memcontrolc
+++ a/include/linux/memcontrol.h
@@ -180,8 +180,6 @@ static inline void mem_cgroup_dec_page_s
 unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
 						gfp_t gfp_mask,
 						unsigned long *total_scanned);
-extern void __mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
-				       int order);
 
 void mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx);
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
diff -puN include/linux/oom.h~mm-memcg-move-all-oom-handling-to-memcontrolc include/linux/oom.h
--- a/include/linux/oom.h~mm-memcg-move-all-oom-handling-to-memcontrolc
+++ a/include/linux/oom.h
@@ -61,6 +61,9 @@ extern void oom_kill_process(struct task
 extern int try_set_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
 extern void clear_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
 
+extern void check_panic_on_oom(enum oom_constraint constraint, gfp_t gfp_mask,
+			       int order, const nodemask_t *nodemask);
+
 extern enum oom_scan_t oom_scan_process_thread(struct task_struct *task,
 		unsigned long totalpages, const nodemask_t *nodemask,
 		bool force_kill);
diff -puN mm/memcontrol.c~mm-memcg-move-all-oom-handling-to-memcontrolc mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-move-all-oom-handling-to-memcontrolc
+++ a/mm/memcontrol.c
@@ -1469,8 +1469,8 @@ static u64 mem_cgroup_get_limit(struct m
 	return min(limit, memsw);
 }
 
-void __mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
-				int order)
+void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
+			      int order)
 {
 	struct mem_cgroup *iter;
 	unsigned long chosen_points = 0;
@@ -1478,6 +1478,17 @@ void __mem_cgroup_out_of_memory(struct m
 	unsigned int points = 0;
 	struct task_struct *chosen = NULL;
 
+	/*
+	 * If current has a pending SIGKILL, then automatically select it.  The
+	 * goal is to allow it to allocate so that it may quickly exit and free
+	 * its memory.
+	 */
+	if (fatal_signal_pending(current)) {
+		set_thread_flag(TIF_MEMDIE);
+		return;
+	}
+
+	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, order, NULL);
 	totalpages = mem_cgroup_get_limit(memcg) >> PAGE_SHIFT ? : 1;
 	for_each_mem_cgroup_tree(iter, memcg) {
 		struct cgroup *cgroup = iter->css.cgroup;
diff -puN mm/oom_kill.c~mm-memcg-move-all-oom-handling-to-memcontrolc mm/oom_kill.c
--- a/mm/oom_kill.c~mm-memcg-move-all-oom-handling-to-memcontrolc
+++ a/mm/oom_kill.c
@@ -555,8 +555,8 @@ void oom_kill_process(struct task_struct
 /*
  * Determines whether the kernel must panic because of the panic_on_oom sysctl.
  */
-static void check_panic_on_oom(enum oom_constraint constraint, gfp_t gfp_mask,
-				int order, const nodemask_t *nodemask)
+void check_panic_on_oom(enum oom_constraint constraint, gfp_t gfp_mask,
+			int order, const nodemask_t *nodemask)
 {
 	if (likely(!sysctl_panic_on_oom))
 		return;
@@ -574,25 +574,6 @@ static void check_panic_on_oom(enum oom_
 		sysctl_panic_on_oom == 2 ? "compulsory" : "system-wide");
 }
 
-#ifdef CONFIG_MEMCG
-void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
-			      int order)
-{
-	/*
-	 * If current has a pending SIGKILL, then automatically select it.  The
-	 * goal is to allow it to allocate so that it may quickly exit and free
-	 * its memory.
-	 */
-	if (fatal_signal_pending(current)) {
-		set_thread_flag(TIF_MEMDIE);
-		return;
-	}
-
-	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, order, NULL);
-	__mem_cgroup_out_of_memory(memcg, gfp_mask, order);
-}
-#endif
-
 static BLOCKING_NOTIFIER_HEAD(oom_notify_list);
 
 int register_oom_notifier(struct notifier_block *nb)
_
Subject: Subject: mm, memcg: move all oom handling to memcontrol.c

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

