From: akpm@linux-foundation.org
Subject: - memcg-move_lists-on-page-not-page_cgroup.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:45:10 -0800
Message-ID: <200803050745.m257jA3r021571@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759881AbYCEHww (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:52:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, rientjes@google.com, taka@valinux.co.jp, yamamoto@valinux.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: move_lists on page not page_cgroup
has been removed from the -mm tree.  Its filename was
     memcg-move_lists-on-page-not-page_cgroup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: move_lists on page not page_cgroup
From: Hugh Dickins <hugh@veritas.com>

Each caller of mem_cgroup_move_lists is having to use page_get_page_cgroup:
it's more convenient if it acts upon the page itself not the page_cgroup; and
in a later patch this becomes important to handle within memcontrol.c.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: David Rientjes <rientjes@google.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hirokazu Takahashi <taka@valinux.co.jp>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    5 ++---
 mm/memcontrol.c            |    4 +++-
 mm/swap.c                  |    2 +-
 mm/vmscan.c                |    5 +++--
 4 files changed, 9 insertions(+), 7 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-move_lists-on-page-not-page_cgroup include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-move_lists-on-page-not-page_cgroup
+++ a/include/linux/memcontrol.h
@@ -36,7 +36,7 @@ extern int mem_cgroup_charge(struct page
 				gfp_t gfp_mask);
 extern void mem_cgroup_uncharge(struct page_cgroup *pc);
 extern void mem_cgroup_uncharge_page(struct page *page);
-extern void mem_cgroup_move_lists(struct page_cgroup *pc, bool active);
+extern void mem_cgroup_move_lists(struct page *page, bool active);
 extern unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
 					struct list_head *dst,
 					unsigned long *scanned, int order,
@@ -106,8 +106,7 @@ static inline void mem_cgroup_uncharge_p
 {
 }
 
-static inline void mem_cgroup_move_lists(struct page_cgroup *pc,
-						bool active)
+static inline void mem_cgroup_move_lists(struct page *page, bool active)
 {
 }
 
diff -puN mm/memcontrol.c~memcg-move_lists-on-page-not-page_cgroup mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-move_lists-on-page-not-page_cgroup
+++ a/mm/memcontrol.c
@@ -407,11 +407,13 @@ int task_in_mem_cgroup(struct task_struc
 /*
  * This routine assumes that the appropriate zone's lru lock is already held
  */
-void mem_cgroup_move_lists(struct page_cgroup *pc, bool active)
+void mem_cgroup_move_lists(struct page *page, bool active)
 {
+	struct page_cgroup *pc;
 	struct mem_cgroup_per_zone *mz;
 	unsigned long flags;
 
+	pc = page_get_page_cgroup(page);
 	if (!pc)
 		return;
 
diff -puN mm/swap.c~memcg-move_lists-on-page-not-page_cgroup mm/swap.c
--- a/mm/swap.c~memcg-move_lists-on-page-not-page_cgroup
+++ a/mm/swap.c
@@ -176,7 +176,7 @@ void activate_page(struct page *page)
 		SetPageActive(page);
 		add_page_to_active_list(zone, page);
 		__count_vm_event(PGACTIVATE);
-		mem_cgroup_move_lists(page_get_page_cgroup(page), true);
+		mem_cgroup_move_lists(page, true);
 	}
 	spin_unlock_irq(&zone->lru_lock);
 }
diff -puN mm/vmscan.c~memcg-move_lists-on-page-not-page_cgroup mm/vmscan.c
--- a/mm/vmscan.c~memcg-move_lists-on-page-not-page_cgroup
+++ a/mm/vmscan.c
@@ -1128,7 +1128,7 @@ static void shrink_active_list(unsigned 
 		ClearPageActive(page);
 
 		list_move(&page->lru, &zone->inactive_list);
-		mem_cgroup_move_lists(page_get_page_cgroup(page), false);
+		mem_cgroup_move_lists(page, false);
 		pgmoved++;
 		if (!pagevec_add(&pvec, page)) {
 			__mod_zone_page_state(zone, NR_INACTIVE, pgmoved);
@@ -1156,8 +1156,9 @@ static void shrink_active_list(unsigned 
 		VM_BUG_ON(PageLRU(page));
 		SetPageLRU(page);
 		VM_BUG_ON(!PageActive(page));
+
 		list_move(&page->lru, &zone->active_list);
-		mem_cgroup_move_lists(page_get_page_cgroup(page), true);
+		mem_cgroup_move_lists(page, true);
 		pgmoved++;
 		if (!pagevec_add(&pvec, page)) {
 			__mod_zone_page_state(zone, NR_ACTIVE, pgmoved);
_

Patches currently in -mm which might be from hugh@veritas.com are

git-unionfs.patch
mmap_region-cleanup-the-final-vma_merge-related-code.patch
mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages.patch
mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask.patch
mm-remember-what-the-preferred-zone-is-for-zone_statistics.patch
mm-use-two-zonelist-that-are-filtered-by-gfp-mask.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
mm-try-both-endianess-when-checking-for-endianess.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
prio_tree-debugging-patch.patch

