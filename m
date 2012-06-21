From: akpm@linux-foundation.org
Subject: + memcg-make-mem_cgroup_force_empty_list-return-bool.patch added to -mm tree
Date: Thu, 21 Jun 2012 13:13:53 -0700
Message-ID: <20120621201354.2F074A04A3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:57507 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756375Ab2FUUNz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jun 2012 16:13:55 -0400
Received: by vcbfl13 with SMTP id fl13so105979vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Jun 2012 13:13:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, mhocko@suse.cz


The patch titled
     Subject: memcg: make mem_cgroup_force_empty_list() return bool
has been added to the -mm tree.  Its filename is
     memcg-make-mem_cgroup_force_empty_list-return-bool.patch

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
Subject: memcg: make mem_cgroup_force_empty_list() return bool

mem_cgroup_force_empty_list() just returns 0 or -EBUSY and -EBUSY
indicates 'you need to retry'.  Make mem_cgroup_force_empty_list() return
a bool to simplify the logic.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff -puN mm/memcontrol.c~memcg-make-mem_cgroup_force_empty_list-return-bool mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-make-mem_cgroup_force_empty_list-return-bool
+++ a/mm/memcontrol.c
@@ -3612,7 +3612,7 @@ unsigned long mem_cgroup_soft_limit_recl
  * This routine traverse page_cgroup in given list and drop them all.
  * *And* this routine doesn't reclaim page itself, just removes page_cgroup.
  */
-static int mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
+static bool mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
 				int node, int zid, enum lru_list lru)
 {
 	struct mem_cgroup_per_zone *mz;
@@ -3620,7 +3620,6 @@ static int mem_cgroup_force_empty_list(s
 	struct list_head *list;
 	struct page *busy;
 	struct zone *zone;
-	int ret = 0;
 
 	zone = &NODE_DATA(node)->node_zones[zid];
 	mz = mem_cgroup_zoneinfo(memcg, node, zid);
@@ -3634,7 +3633,6 @@ static int mem_cgroup_force_empty_list(s
 		struct page_cgroup *pc;
 		struct page *page;
 
-		ret = 0;
 		spin_lock_irqsave(&zone->lru_lock, flags);
 		if (list_empty(list)) {
 			spin_unlock_irqrestore(&zone->lru_lock, flags);
@@ -3651,19 +3649,14 @@ static int mem_cgroup_force_empty_list(s
 
 		pc = lookup_page_cgroup(page);
 
-		ret = mem_cgroup_move_parent(page, pc, memcg);
-
-		if (ret == -EBUSY || ret == -EINVAL) {
+		if (mem_cgroup_move_parent(page, pc, memcg)) {
 			/* found lock contention or "pc" is obsolete. */
 			busy = page;
 			cond_resched();
 		} else
 			busy = NULL;
 	}
-
-	if (!ret && !list_empty(list))
-		return -EBUSY;
-	return ret;
+	return !list_empty(list);
 }
 
 /*
_
Subject: Subject: memcg: make mem_cgroup_force_empty_list() return bool

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
memcg-make-mem_cgroup_force_empty_list-return-bool.patch
memcg-make-mem_cgroup_force_empty_list-return-bool-fix.patch

