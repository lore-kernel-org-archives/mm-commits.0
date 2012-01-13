From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-split_huge_page_refcounts.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:35:35 -0800
Message-ID: <20120113203536.285715C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:37836 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759071Ab2AMUfi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:35:38 -0500
Received: by mail-ey0-f202.google.com with SMTP id d12so25396eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:35:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: fix split_huge_page_refcounts()
has been removed from the -mm tree.  Its filename was
     memcg-fix-split_huge_page_refcounts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: memcg: fix split_huge_page_refcounts()

This patch started off as a cleanup: __split_huge_page_refcounts() has to
cope with two scenarios, when the hugepage being split is already on LRU,
and when it is not; but why does it have to split that accounting across
three different sites?  Consolidate it in lru_add_page_tail(), handling
evictable and unevictable alike, and use standard add_page_to_lru_list()
when accounting is needed (when the head is not yet on LRU).

But a recent regression in -next, I guess the removal of PageCgroupAcctLRU
test from mem_cgroup_split_huge_fixup(), makes this now a necessary fix:
under load, the MEM_CGROUP_ZSTAT count was wrapping to a huge number,
messing up reclaim calculations and causing a freeze at rmdir of cgroup.

Add a VM_BUG_ON to mem_cgroup_lru_del_list() when we're about to wrap that
count - this has not been the only such incident.  Document that
lru_add_page_tail() is for Transparent HugePages by #ifdef around it.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   10 ----------
 mm/memcontrol.c  |   12 ++----------
 mm/swap.c        |   29 +++++++++++++++++++----------
 3 files changed, 21 insertions(+), 30 deletions(-)

diff -puN mm/huge_memory.c~memcg-fix-split_huge_page_refcounts mm/huge_memory.c
--- a/mm/huge_memory.c~memcg-fix-split_huge_page_refcounts
+++ a/mm/huge_memory.c
@@ -1229,7 +1229,6 @@ static void __split_huge_page_refcount(s
 {
 	int i;
 	struct zone *zone = page_zone(page);
-	int zonestat;
 	int tail_count = 0;
 
 	/* prevent PageLRU to go away from under us, and freeze lru stats */
@@ -1317,15 +1316,6 @@ static void __split_huge_page_refcount(s
 	__dec_zone_page_state(page, NR_ANON_TRANSPARENT_HUGEPAGES);
 	__mod_zone_page_state(zone, NR_ANON_PAGES, HPAGE_PMD_NR);
 
-	/*
-	 * A hugepage counts for HPAGE_PMD_NR pages on the LRU statistics,
-	 * so adjust those appropriately if this page is on the LRU.
-	 */
-	if (PageLRU(page)) {
-		zonestat = NR_LRU_BASE + page_lru(page);
-		__mod_zone_page_state(zone, zonestat, -(HPAGE_PMD_NR-1));
-	}
-
 	ClearPageCompound(page);
 	compound_unlock(page);
 	spin_unlock_irq(&zone->lru_lock);
diff -puN mm/memcontrol.c~memcg-fix-split_huge_page_refcounts mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-split_huge_page_refcounts
+++ a/mm/memcontrol.c
@@ -1071,6 +1071,7 @@ void mem_cgroup_lru_del_list(struct page
 	VM_BUG_ON(!memcg);
 	mz = page_cgroup_zoneinfo(memcg, page);
 	/* huge page split is done under lru_lock. so, we have no races. */
+	VM_BUG_ON(MEM_CGROUP_ZSTAT(mz, lru) < (1 << compound_order(page)));
 	MEM_CGROUP_ZSTAT(mz, lru) -= 1 << compound_order(page);
 }
 
@@ -2465,9 +2466,7 @@ static void __mem_cgroup_commit_charge(s
 void mem_cgroup_split_huge_fixup(struct page *head)
 {
 	struct page_cgroup *head_pc = lookup_page_cgroup(head);
-	struct mem_cgroup_per_zone *mz;
 	struct page_cgroup *pc;
-	enum lru_list lru;
 	int i;
 
 	if (mem_cgroup_disabled())
@@ -2478,15 +2477,8 @@ void mem_cgroup_split_huge_fixup(struct 
 		smp_wmb();/* see __commit_charge() */
 		pc->flags = head_pc->flags & ~PCGF_NOCOPY_AT_SPLIT;
 	}
-	/*
-	 * Tail pages will be added to LRU.
-	 * We hold lru_lock,then,reduce counter directly.
-	 */
-	lru = page_lru(head);
-	mz = page_cgroup_zoneinfo(head_pc->mem_cgroup, head);
-	MEM_CGROUP_ZSTAT(mz, lru) -= HPAGE_PMD_NR - 1;
 }
-#endif
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 /**
  * mem_cgroup_move_account - move account of the page
diff -puN mm/swap.c~memcg-fix-split_huge_page_refcounts mm/swap.c
--- a/mm/swap.c~memcg-fix-split_huge_page_refcounts
+++ a/mm/swap.c
@@ -650,6 +650,7 @@ void __pagevec_release(struct pagevec *p
 
 EXPORT_SYMBOL(__pagevec_release);
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /* used by __split_huge_page_refcount() */
 void lru_add_page_tail(struct zone* zone,
 		       struct page *page, struct page *page_tail)
@@ -666,8 +667,6 @@ void lru_add_page_tail(struct zone* zone
 	SetPageLRU(page_tail);
 
 	if (page_evictable(page_tail, NULL)) {
-		struct lruvec *lruvec;
-
 		if (PageActive(page)) {
 			SetPageActive(page_tail);
 			active = 1;
@@ -677,18 +676,28 @@ void lru_add_page_tail(struct zone* zone
 			lru = LRU_INACTIVE_ANON;
 		}
 		update_page_reclaim_stat(zone, page_tail, file, active);
-		lruvec = mem_cgroup_lru_add_list(zone, page_tail, lru);
-		if (likely(PageLRU(page)))
-			list_add(&page_tail->lru, page->lru.prev);
-		else
-			list_add(&page_tail->lru, lruvec->lists[lru].prev);
-		__mod_zone_page_state(zone, NR_LRU_BASE + lru,
-				      hpage_nr_pages(page_tail));
 	} else {
 		SetPageUnevictable(page_tail);
-		add_page_to_lru_list(zone, page_tail, LRU_UNEVICTABLE);
+		lru = LRU_UNEVICTABLE;
+	}
+
+	if (likely(PageLRU(page)))
+		list_add_tail(&page_tail->lru, &page->lru);
+	else {
+		struct list_head *list_head;
+		/*
+		 * Head page has not yet been counted, as an hpage,
+		 * so we must account for each subpage individually.
+		 *
+		 * Use the standard add function to put page_tail on the list,
+		 * but then correct its position so they all end up in order.
+		 */
+		add_page_to_lru_list(zone, page_tail, lru);
+		list_head = page_tail->lru.prev;
+		list_move_tail(&page_tail->lru, list_head);
 	}
 }
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 static void ____pagevec_lru_add_fn(struct page *page, void *arg)
 {
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
prio_tree-debugging-patch.patch

