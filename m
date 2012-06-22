From: akpm@linux-foundation.org
Subject: + mm-oom-fix-potential-killing-of-thread-that-is-disabled-from-oom-killing.patch added to -mm tree
Date: Fri, 22 Jun 2012 14:49:27 -0700
Message-ID: <20120622214927.AC9A2A0123@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:46618 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab2FVVt3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Jun 2012 17:49:29 -0400
Received: by ggeh3 with SMTP id h3so245747gge.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Jun 2012 14:49:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     Subject: mm, oom: fix potential killing of thread that is disabled from oom killing
has been added to the -mm tree.  Its filename is
     mm-oom-fix-potential-killing-of-thread-that-is-disabled-from-oom-killing.patch

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
Subject: mm, oom: fix potential killing of thread that is disabled from oom killing

/proc/sys/vm/oom_kill_allocating_task will immediately kill current when
the oom killer is called to avoid a potentially expensive tasklist scan
for large systems.

Currently, however, it is not checking current's oom_score_adj value which
may be OOM_SCORE_ADJ_MIN, meaning that it has been disabled from oom
killing.

This patch avoids killing current in such a condition and simply falls
back to the tasklist scan since memory still needs to be freed.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/oom_kill.c~mm-oom-fix-potential-killing-of-thread-that-is-disabled-from-oom-killing mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-fix-potential-killing-of-thread-that-is-disabled-from-oom-killing
+++ a/mm/oom_kill.c
@@ -719,9 +719,9 @@ void out_of_memory(struct zonelist *zone
 	check_panic_on_oom(constraint, gfp_mask, order, mpol_mask);
 
 	read_lock(&tasklist_lock);
-	if (sysctl_oom_kill_allocating_task &&
+	if (sysctl_oom_kill_allocating_task && current->mm &&
 	    !oom_unkillable_task(current, NULL, nodemask) &&
-	    current->mm) {
+	    current->signal->oom_score_adj != OOM_SCORE_ADJ_MIN) {
 		oom_kill_process(current, gfp_mask, order, 0, totalpages, NULL,
 				 nodemask,
 				 "Out of memory (oom_kill_allocating_task)");
_
Subject: Subject: mm, oom: fix potential killing of thread that is disabled from oom killing

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

