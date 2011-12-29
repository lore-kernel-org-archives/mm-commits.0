From: akpm@linux-foundation.org
Subject: + memcg-fix-split_huge_page_refcounts.patch added to -mm tree
Date: Thu, 29 Dec 2011 14:44:38 -0800
Message-ID: <20111229224438.ACFA510004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:50249 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714Ab1L2Woj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Dec 2011 17:44:39 -0500
Received: by yhjj51 with SMTP id j51so1863858yhj.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Dec 2011 14:44:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, nishimura@mxp.nes.nec.co.jp


The patch titled
     Subject: memcg: fix split_huge_page_refcounts()
has been added to the -mm tree.  Its filename is
     memcg-fix-split_huge_page_refcounts.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1062,6 +1062,7 @@ void mem_cgroup_lru_del_list(struct page
 	VM_BUG_ON(!memcg);
 	mz = page_cgroup_zoneinfo(memcg, page);
 	/* huge page split is done under lru_lock. so, we have no races. */
+	VM_BUG_ON(MEM_CGROUP_ZSTAT(mz, lru) < (1 << compound_order(page)));
 	MEM_CGROUP_ZSTAT(mz, lru) -= 1 << compound_order(page);
 }
 
@@ -2456,9 +2457,7 @@ static void __mem_cgroup_commit_charge(s
 void mem_cgroup_split_huge_fixup(struct page *head)
 {
 	struct page_cgroup *head_pc = lookup_page_cgroup(head);
-	struct mem_cgroup_per_zone *mz;
 	struct page_cgroup *pc;
-	enum lru_list lru;
 	int i;
 
 	if (mem_cgroup_disabled())
@@ -2469,15 +2468,8 @@ void mem_cgroup_split_huge_fixup(struct 
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
@@ -717,6 +717,7 @@ void __pagevec_release(struct pagevec *p
 
 EXPORT_SYMBOL(__pagevec_release);
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /* used by __split_huge_page_refcount() */
 void lru_add_page_tail(struct zone* zone,
 		       struct page *page, struct page *page_tail)
@@ -733,8 +734,6 @@ void lru_add_page_tail(struct zone* zone
 	SetPageLRU(page_tail);
 
 	if (page_evictable(page_tail, NULL)) {
-		struct lruvec *lruvec;
-
 		if (PageActive(page)) {
 			SetPageActive(page_tail);
 			active = 1;
@@ -744,18 +743,28 @@ void lru_add_page_tail(struct zone* zone
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
Subject: Subject: memcg: fix split_huge_page_refcounts()

Patches currently in -mm which might be from hughd@google.com are

linux-next.patch
mm-add-free_hot_cold_page_list-helper.patch
mm-add-free_hot_cold_page_list-helper-v2.patch
mm-add-free_hot_cold_page_list-helper-v3.patch
mm-remove-unused-pagevec_free.patch
mm-tracepoint-rename-page-free-events.patch
mm-tracepoint-fixup-documentation-and-examples.patch
mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma.patch
mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma-update.patch
mm-simplify-find_vma_prev.patch
memcg-add-mem_cgroup_replace_page_cache-to-fix-lru-issue.patch
mm-memcg-consolidate-hierarchy-iteration-primitives.patch
mm-vmscan-distinguish-global-reclaim-from-global-lru-scanning.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned.patch
mm-memcg-per-priority-per-zone-hierarchy-scan-generations.patch
mm-move-memcg-hierarchy-reclaim-to-generic-reclaim-code.patch
mm-memcg-remove-optimization-of-keeping-the-root_mem_cgroup-lru-lists-empty.patch
mm-vmscan-convert-global-reclaim-to-per-memcg-lru-lists.patch
mm-collect-lru-list-heads-into-struct-lruvec.patch
mm-make-per-memcg-lru-lists-exclusive.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags-fix.patch
mm-oom_kill-remove-memcg-argument-from-oom_kill_task.patch
mm-unify-remaining-mem_cont-mem-etc-variable-names-to-memcg.patch
mm-memcg-clean-up-fault-accounting.patch
mm-memcg-lookup_page_cgroup-almost-never-returns-null.patch
mm-memcg-lookup_page_cgroup-almost-never-returns-null-fix.patch
mm-page_cgroup-check-page_cgroup-arrays-in-lookup_page_cgroup-only-when-necessary.patch
mm-memcg-remove-unneeded-checks-from-newpage_charge.patch
mm-memcg-remove-unneeded-checks-from-uncharge_page.patch
memcg-clean-up-soft_limit_tree-if-allocation-fails.patch
memcg-simplify-page-cache-charging.patch
memcg-simplify-corner-case-handling-of-lru.patch
memcg-clear-pc-mem_cgorup-if-necessary.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-2.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-2-fix.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-3.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-page-migration-to-reset_owner.patch
memcg-simplify-lru-handling-by-new-rule.patch
memcg-simplify-lru-handling-by-new-rule-fix.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge-fix.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge-fix-null-mem_cgroup_try_charge.patch
memcg-fix-split_huge_page_refcounts.patch
memcg-fix-mem_cgroup_print_bad_page.patch
procfs-add-hidepid=-and-gid=-mount-options-fix.patch
radix_tree-remove-radix_tree_indirect_to_ptr.patch
radix_tree-take-radix_tree_path-off-stack.patch
radix_tree-take-radix_tree_path-off-stack-expand-comment-on-optimization.patch
prio_tree-debugging-patch.patch

