From: akpm@linux-foundation.org
Subject: + memcg-mem_cgroup_move_parent-doesnt-need-gfp_mask.patch added to -mm tree
Date: Thu, 21 Jun 2012 13:04:58 -0700
Message-ID: <20120621200458.A1E5DA016C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:38616 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313Ab2FUUE7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jun 2012 16:04:59 -0400
Received: by ggeh3 with SMTP id h3so103645gge.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Jun 2012 13:04:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, mhocko@suse.cz


The patch titled
     Subject: memcg: mem_cgroup_move_parent() doesn't need gfp_mask
has been added to the -mm tree.  Its filename is
     memcg-mem_cgroup_move_parent-doesnt-need-gfp_mask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: memcg: mem_cgroup_move_parent() doesn't need gfp_mask

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~memcg-mem_cgroup_move_parent-doesnt-need-gfp_mask mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-mem_cgroup_move_parent-doesnt-need-gfp_mask
+++ a/mm/memcontrol.c
@@ -2643,8 +2643,7 @@ out:
 
 static int mem_cgroup_move_parent(struct page *page,
 				  struct page_cgroup *pc,
-				  struct mem_cgroup *child,
-				  gfp_t gfp_mask)
+				  struct mem_cgroup *child)
 {
 	struct mem_cgroup *parent;
 	unsigned int nr_pages;
@@ -3652,7 +3651,7 @@ static int mem_cgroup_force_empty_list(s
 
 		pc = lookup_page_cgroup(page);
 
-		ret = mem_cgroup_move_parent(page, pc, memcg, GFP_KERNEL);
+		ret = mem_cgroup_move_parent(page, pc, memcg);
 
 		if (ret == -EBUSY || ret == -EINVAL) {
 			/* found lock contention or "pc" is obsolete. */
_
Subject: Subject: memcg: mem_cgroup_move_parent() doesn't need gfp_mask

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix.patch
memcg-rename-mem_cgroup_stat_swapout-as-mem_cgroup_stat_swap.patch
memcg-rename-mem_cgroup_charge_type_mapped-as-mem_cgroup_charge_type_anon.patch
memcg-remove-mem_cgroup_charge_type_force.patch
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
memcg-remove-check-for-signal_pending-during-rmdir.patch
memcg-clean-up-force_empty_list-return-value-check.patch
memcg-mem_cgroup_move_parent-doesnt-need-gfp_mask.patch

