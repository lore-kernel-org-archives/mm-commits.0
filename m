From: akpm@linux-foundation.org
Subject: + mm-rearrange-putback_inactive_pages.patch added to -mm tree
Date: Tue, 03 Jan 2012 15:34:48 -0800
Message-ID: <20120103233449.912315C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:62915 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab2ACXew (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jan 2012 18:34:52 -0500
Received: by eekc1 with SMTP id c1so587213eek.1
        for <mm-commits@vger.kernel.org>; Tue, 03 Jan 2012 15:34:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, hannes@cmpxchg.org, kosaki.motohiro@gmail.com


The patch titled
     Subject: mm: rearrange putback_inactive_pages
has been added to the -mm tree.  Its filename is
     mm-rearrange-putback_inactive_pages.patch

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
Subject: mm: rearrange putback_inactive_pages

There is sometimes confusion between the global putback_lru_pages() in
migrate.c and the static putback_lru_pages() in vmscan.c: rename the
latter putback_inactive_pages(): it helps shrink_inactive_list() rather as
move_active_pages_to_lru() helps shrink_active_list().

Remove unused scan_control arg from putback_inactive_pages() and from
update_isolated_counts().  Move clear_active_flags() inside
update_isolated_counts().  Move NR_ISOLATED accounting up into
shrink_inactive_list() itself, so the balance is clearer.

Do the spin_lock_irq() before calling putback_inactive_pages() and
spin_unlock_irq() after return from it, so that it better matches
update_isolated_counts() and move_active_pages_to_lru().

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   96 ++++++++++++++++++++++----------------------------
 1 file changed, 44 insertions(+), 52 deletions(-)

diff -puN mm/vmscan.c~mm-rearrange-putback_inactive_pages mm/vmscan.c
--- a/mm/vmscan.c~mm-rearrange-putback_inactive_pages
+++ a/mm/vmscan.c
@@ -1284,32 +1284,6 @@ static unsigned long isolate_lru_pages(u
 	return nr_taken;
 }
 
-/*
- * clear_active_flags() is a helper for shrink_active_list(), clearing
- * any active bits from the pages in the list.
- */
-static unsigned long clear_active_flags(struct list_head *page_list,
-					unsigned int *count)
-{
-	int nr_active = 0;
-	int lru;
-	struct page *page;
-
-	list_for_each_entry(page, page_list, lru) {
-		int numpages = hpage_nr_pages(page);
-		lru = page_lru_base_type(page);
-		if (PageActive(page)) {
-			lru += LRU_ACTIVE;
-			ClearPageActive(page);
-			nr_active += numpages;
-		}
-		if (count)
-			count[lru] += numpages;
-	}
-
-	return nr_active;
-}
-
 /**
  * isolate_lru_page - tries to isolate a page from its LRU list
  * @page: page to isolate from its LRU list
@@ -1383,26 +1357,21 @@ static int too_many_isolated(struct zone
 	return isolated > inactive;
 }
 
-/*
- * TODO: Try merging with migrations version of putback_lru_pages
- */
 static noinline_for_stack void
-putback_lru_pages(struct mem_cgroup_zone *mz, struct scan_control *sc,
-		  unsigned long nr_anon, unsigned long nr_file,
-		  struct list_head *page_list)
+putback_inactive_pages(struct mem_cgroup_zone *mz,
+		       struct list_head *page_list)
 {
-	struct page *page;
-	LIST_HEAD(pages_to_free);
-	struct zone *zone = mz->zone;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(mz);
+	struct zone *zone = mz->zone;
+	LIST_HEAD(pages_to_free);
 
 	/*
 	 * Put back any unfreeable pages.
 	 */
-	spin_lock(&zone->lru_lock);
 	while (!list_empty(page_list)) {
+		struct page *page = lru_to_page(page_list);
 		int lru;
-		page = lru_to_page(page_list);
+
 		VM_BUG_ON(PageLRU(page));
 		list_del(&page->lru);
 		if (unlikely(!page_evictable(page, NULL))) {
@@ -1432,26 +1401,40 @@ putback_lru_pages(struct mem_cgroup_zone
 				list_add(&page->lru, &pages_to_free);
 		}
 	}
-	__mod_zone_page_state(zone, NR_ISOLATED_ANON, -nr_anon);
-	__mod_zone_page_state(zone, NR_ISOLATED_FILE, -nr_file);
 
-	spin_unlock_irq(&zone->lru_lock);
-	free_hot_cold_page_list(&pages_to_free, 1);
+	/*
+	 * To save our caller's stack, now use input list for pages to free.
+	 */
+	list_splice(&pages_to_free, page_list);
 }
 
 static noinline_for_stack void
 update_isolated_counts(struct mem_cgroup_zone *mz,
-		       struct scan_control *sc,
+		       struct list_head *page_list,
 		       unsigned long *nr_anon,
-		       unsigned long *nr_file,
-		       struct list_head *isolated_list)
+		       unsigned long *nr_file)
 {
-	unsigned long nr_active;
+	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(mz);
 	struct zone *zone = mz->zone;
 	unsigned int count[NR_LRU_LISTS] = { 0, };
-	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(mz);
+	unsigned long nr_active = 0;
+	struct page *page;
+	int lru;
+
+	/*
+	 * Count pages and clear active flags
+	 */
+	list_for_each_entry(page, page_list, lru) {
+		int numpages = hpage_nr_pages(page);
+		lru = page_lru_base_type(page);
+		if (PageActive(page)) {
+			lru += LRU_ACTIVE;
+			ClearPageActive(page);
+			nr_active += numpages;
+		}
+		count[lru] += numpages;
+	}
 
-	nr_active = clear_active_flags(isolated_list, count);
 	__count_vm_events(PGDEACTIVATE, nr_active);
 
 	__mod_zone_page_state(zone, NR_ACTIVE_FILE,
@@ -1465,8 +1448,6 @@ update_isolated_counts(struct mem_cgroup
 
 	*nr_anon = count[LRU_ACTIVE_ANON] + count[LRU_INACTIVE_ANON];
 	*nr_file = count[LRU_ACTIVE_FILE] + count[LRU_INACTIVE_FILE];
-	__mod_zone_page_state(zone, NR_ISOLATED_ANON, *nr_anon);
-	__mod_zone_page_state(zone, NR_ISOLATED_FILE, *nr_file);
 
 	reclaim_stat->recent_scanned[0] += *nr_anon;
 	reclaim_stat->recent_scanned[1] += *nr_file;
@@ -1571,7 +1552,10 @@ shrink_inactive_list(unsigned long nr_to
 		return 0;
 	}
 
-	update_isolated_counts(mz, sc, &nr_anon, &nr_file, &page_list);
+	update_isolated_counts(mz, &page_list, &nr_anon, &nr_file);
+
+	__mod_zone_page_state(zone, NR_ISOLATED_ANON, nr_anon);
+	__mod_zone_page_state(zone, NR_ISOLATED_FILE, nr_file);
 
 	spin_unlock_irq(&zone->lru_lock);
 
@@ -1585,12 +1569,20 @@ shrink_inactive_list(unsigned long nr_to
 					priority, &nr_dirty, &nr_writeback);
 	}
 
-	local_irq_disable();
+	spin_lock_irq(&zone->lru_lock);
+
 	if (current_is_kswapd())
 		__count_vm_events(KSWAPD_STEAL, nr_reclaimed);
 	__count_zone_vm_events(PGSTEAL, zone, nr_reclaimed);
 
-	putback_lru_pages(mz, sc, nr_anon, nr_file, &page_list);
+	putback_inactive_pages(mz, &page_list);
+
+	__mod_zone_page_state(zone, NR_ISOLATED_ANON, -nr_anon);
+	__mod_zone_page_state(zone, NR_ISOLATED_FILE, -nr_file);
+
+	spin_unlock_irq(&zone->lru_lock);
+
+	free_hot_cold_page_list(&page_list, 1);
 
 	/*
 	 * If reclaim is isolating dirty pages under writeback, it implies
_
Subject: Subject: mm: rearrange putback_inactive_pages

Patches currently in -mm which might be from hughd@google.com are

origin.patch
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
mm-test-pageswapbacked-in-lumpy-reclaim.patch
mm-vmscan-fix-typo-in-isolating-lru-pages.patch
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
mm-take-pagevecs-off-reclaim-stack.patch
mm-fewer-underscores-in-____pagevec_lru_add.patch
mm-no-blank-line-after-export_symbol-in-swapc.patch
mm-enum-lru_list-lru.patch
mm-remove-del_page_from_lru-add-page_off_lru.patch
mm-remove-isolate_pages.patch
mm-rearrange-putback_inactive_pages.patch
procfs-add-hidepid=-and-gid=-mount-options.patch
radix_tree-remove-radix_tree_indirect_to_ptr.patch
radix_tree-take-radix_tree_path-off-stack.patch
radix_tree-take-radix_tree_path-off-stack-expand-comment-on-optimization.patch
prio_tree-debugging-patch.patch

