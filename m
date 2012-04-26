From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-move-pc-lookup-point-to-commit_charge.patch removed from -mm tree
Date: Thu, 26 Apr 2012 13:49:07 -0700
Message-ID: <20120426204909.D1C8DA04C2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:41239 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758042Ab2DZUtM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Apr 2012 16:49:12 -0400
Received: by qabg24 with SMTP id g24so21807qab.1
        for <mm-commits@vger.kernel.org>; Thu, 26 Apr 2012 13:49:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: move pc lookup point to commit_charge()
has been removed from the -mm tree.  Its filename was
     mm-memcg-move-pc-lookup-point-to-commit_charge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcg: move pc lookup point to commit_charge()

None of the callsites actually need the page_cgroup descriptor themselves,
so just pass the page and do the look up in there.

We already had two bugs: 6568d4a ("mm: memcg: update the correct soft
limit tree during migration") and 9b7f43afd4 ("memcg: fix Bad page state
after replace_page_cache") where the passed page and pc were not referring
to the same page frame.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-move-pc-lookup-point-to-commit_charge mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-move-pc-lookup-point-to-commit_charge
+++ a/mm/memcontrol.c
@@ -2470,10 +2470,10 @@ struct mem_cgroup *try_get_mem_cgroup_fr
 static void __mem_cgroup_commit_charge(struct mem_cgroup *memcg,
 				       struct page *page,
 				       unsigned int nr_pages,
-				       struct page_cgroup *pc,
 				       enum charge_type ctype,
 				       bool lrucare)
 {
+	struct page_cgroup *pc = lookup_page_cgroup(page);
 	struct zone *uninitialized_var(zone);
 	bool was_on_lru = false;
 	bool anon;
@@ -2710,7 +2710,6 @@ static int mem_cgroup_charge_common(stru
 {
 	struct mem_cgroup *memcg = NULL;
 	unsigned int nr_pages = 1;
-	struct page_cgroup *pc;
 	bool oom = true;
 	int ret;
 
@@ -2724,11 +2723,10 @@ static int mem_cgroup_charge_common(stru
 		oom = false;
 	}
 
-	pc = lookup_page_cgroup(page);
 	ret = __mem_cgroup_try_charge(mm, gfp_mask, nr_pages, &memcg, oom);
 	if (ret == -ENOMEM)
 		return ret;
-	__mem_cgroup_commit_charge(memcg, page, nr_pages, pc, ctype, false);
+	__mem_cgroup_commit_charge(memcg, page, nr_pages, ctype, false);
 	return 0;
 }
 
@@ -2825,16 +2823,13 @@ static void
 __mem_cgroup_commit_charge_swapin(struct page *page, struct mem_cgroup *memcg,
 					enum charge_type ctype)
 {
-	struct page_cgroup *pc;
-
 	if (mem_cgroup_disabled())
 		return;
 	if (!memcg)
 		return;
 	cgroup_exclude_rmdir(&memcg->css);
 
-	pc = lookup_page_cgroup(page);
-	__mem_cgroup_commit_charge(memcg, page, 1, pc, ctype, true);
+	__mem_cgroup_commit_charge(memcg, page, 1, ctype, true);
 	/*
 	 * Now swap is on-memory. This means this page may be
 	 * counted both as mem and swap....double count.
@@ -3450,14 +3445,13 @@ int mem_cgroup_prepare_migration(struct 
 	 * page. In the case new page is migrated but not remapped, new page's
 	 * mapcount will be finally 0 and we call uncharge in end_migration().
 	 */
-	pc = lookup_page_cgroup(newpage);
 	if (PageAnon(page))
 		ctype = MEM_CGROUP_CHARGE_TYPE_MAPPED;
 	else if (page_is_file_cache(page))
 		ctype = MEM_CGROUP_CHARGE_TYPE_CACHE;
 	else
 		ctype = MEM_CGROUP_CHARGE_TYPE_SHMEM;
-	__mem_cgroup_commit_charge(memcg, newpage, 1, pc, ctype, false);
+	__mem_cgroup_commit_charge(memcg, newpage, 1, ctype, false);
 	return ret;
 }
 
@@ -3544,8 +3538,7 @@ void mem_cgroup_replace_page_cache(struc
 	 * the newpage may be on LRU(or pagevec for LRU) already. We lock
 	 * LRU while we overwrite pc->mem_cgroup.
 	 */
-	pc = lookup_page_cgroup(newpage);
-	__mem_cgroup_commit_charge(memcg, newpage, 1, pc, type, true);
+	__mem_cgroup_commit_charge(memcg, newpage, 1, type, true);
 }
 
 #ifdef CONFIG_DEBUG_VM
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-fix-up-the-vmscan-stat-in-vmstat.patch
mm-fix-null-ptr-dereference-in-migrate_pages.patch
mm-fix-null-ptr-dereference-in-move_pages.patch
linux-next.patch
mm-remove-swap-token-code.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlbfs-dont-use-err_ptr-with-vm_fault-values.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
memcg-add-hugetlb-extension.patch
hugetlb-add-charge-uncharge-calls-for-hugetlb-alloc-free.patch
memcg-track-resource-index-in-cftype-private.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
hugetlbfs-add-a-list-for-tracking-in-use-hugetlb-pages.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration.patch
memcg-add-memory-controller-documentation-for-hugetlb-management.patch
memcg-fix-change-behavior-of-shared-anon-at-moving-task.patch
memcg-swap-mem_cgroup_move_swap_account-never-needs-fixup.patch
memcg-swap-use-mem_cgroup_uncharge_swap.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
memcg-revise-the-position-of-threshold-index-while-unregistering-event.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch

