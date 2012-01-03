From: akpm@linux-foundation.org
Subject: + mm-remove-isolate_pages.patch added to -mm tree
Date: Tue, 03 Jan 2012 15:34:45 -0800
Message-ID: <20120103233446.2510710004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:55859 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013Ab2ACXeq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jan 2012 18:34:46 -0500
Received: by mail-yx0-f202.google.com with SMTP id m5so2060568yen.1
        for <mm-commits@vger.kernel.org>; Tue, 03 Jan 2012 15:34:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     Subject: mm: remove isolate_pages()
has been added to the -mm tree.  Its filename is
     mm-remove-isolate_pages.patch

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
Subject: mm: remove isolate_pages()

The isolate_pages() level in vmscan.c offers little but indirection: merge
it into isolate_lru_pages() as the compiler does, and use the names
nr_to_scan and nr_scanned in each case.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   61 ++++++++++++++++++++++----------------------------
 1 file changed, 27 insertions(+), 34 deletions(-)

diff -puN mm/vmscan.c~mm-remove-isolate_pages mm/vmscan.c
--- a/mm/vmscan.c~mm-remove-isolate_pages
+++ a/mm/vmscan.c
@@ -1136,25 +1136,36 @@ int __isolate_lru_page(struct page *page
  * Appropriate locks must be held before calling this function.
  *
  * @nr_to_scan:	The number of pages to look through on the list.
- * @src:	The LRU list to pull pages off.
+ * @mz:		The mem_cgroup_zone to pull pages from.
  * @dst:	The temp list to put pages on to.
- * @scanned:	The number of pages that were scanned.
+ * @nr_scanned:	The number of pages that were scanned.
  * @order:	The caller's attempted allocation order
  * @mode:	One of the LRU isolation modes
+ * @active:	True [1] if isolating active pages
  * @file:	True [1] if isolating file [!anon] pages
  *
  * returns how many pages were moved onto *@dst.
  */
 static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
-		struct list_head *src, struct list_head *dst,
-		unsigned long *scanned, int order, isolate_mode_t mode,
-		int file)
+		struct mem_cgroup_zone *mz, struct list_head *dst,
+		unsigned long *nr_scanned, int order, isolate_mode_t mode,
+		int active, int file)
 {
+	struct lruvec *lruvec;
+	struct list_head *src;
 	unsigned long nr_taken = 0;
 	unsigned long nr_lumpy_taken = 0;
 	unsigned long nr_lumpy_dirty = 0;
 	unsigned long nr_lumpy_failed = 0;
 	unsigned long scan;
+	int lru = LRU_BASE;
+
+	lruvec = mem_cgroup_zone_lruvec(mz->zone, mz->mem_cgroup);
+	if (active)
+		lru += LRU_ACTIVE;
+	if (file)
+		lru += LRU_FILE;
+	src = &lruvec->lists[lru];
 
 	for (scan = 0; scan < nr_to_scan && !list_empty(src); scan++) {
 		struct page *page;
@@ -1263,7 +1274,7 @@ static unsigned long isolate_lru_pages(u
 			nr_lumpy_failed++;
 	}
 
-	*scanned = scan;
+	*nr_scanned = scan;
 
 	trace_mm_vmscan_lru_isolate(order,
 			nr_to_scan, scan,
@@ -1273,23 +1284,6 @@ static unsigned long isolate_lru_pages(u
 	return nr_taken;
 }
 
-static unsigned long isolate_pages(unsigned long nr, struct mem_cgroup_zone *mz,
-				   struct list_head *dst,
-				   unsigned long *scanned, int order,
-				   isolate_mode_t mode, int active, int file)
-{
-	struct lruvec *lruvec;
-	int lru = LRU_BASE;
-
-	lruvec = mem_cgroup_zone_lruvec(mz->zone, mz->mem_cgroup);
-	if (active)
-		lru += LRU_ACTIVE;
-	if (file)
-		lru += LRU_FILE;
-	return isolate_lru_pages(nr, &lruvec->lists[lru], dst,
-				 scanned, order, mode, file);
-}
-
 /*
  * clear_active_flags() is a helper for shrink_active_list(), clearing
  * any active bits from the pages in the list.
@@ -1559,9 +1553,9 @@ shrink_inactive_list(unsigned long nr_to
 
 	spin_lock_irq(&zone->lru_lock);
 
-	nr_taken = isolate_pages(nr_to_scan, mz, &page_list,
-				 &nr_scanned, sc->order,
-				 reclaim_mode, 0, file);
+	nr_taken = isolate_lru_pages(nr_to_scan, mz, &page_list,
+				     &nr_scanned, sc->order,
+				     reclaim_mode, 0, file);
 	if (global_reclaim(sc)) {
 		zone->pages_scanned += nr_scanned;
 		if (current_is_kswapd())
@@ -1700,13 +1694,13 @@ static void move_active_pages_to_lru(str
 		__count_vm_events(PGDEACTIVATE, pgmoved);
 }
 
-static void shrink_active_list(unsigned long nr_pages,
+static void shrink_active_list(unsigned long nr_to_scan,
 			       struct mem_cgroup_zone *mz,
 			       struct scan_control *sc,
 			       int priority, int file)
 {
 	unsigned long nr_taken;
-	unsigned long pgscanned;
+	unsigned long nr_scanned;
 	unsigned long vm_flags;
 	LIST_HEAD(l_hold);	/* The pages which were snipped off */
 	LIST_HEAD(l_active);
@@ -1726,16 +1720,15 @@ static void shrink_active_list(unsigned 
 
 	spin_lock_irq(&zone->lru_lock);
 
-	nr_taken = isolate_pages(nr_pages, mz, &l_hold,
-				 &pgscanned, sc->order,
-				 reclaim_mode, 1, file);
-
+	nr_taken = isolate_lru_pages(nr_to_scan, mz, &l_hold,
+				     &nr_scanned, sc->order,
+				     reclaim_mode, 1, file);
 	if (global_reclaim(sc))
-		zone->pages_scanned += pgscanned;
+		zone->pages_scanned += nr_scanned;
 
 	reclaim_stat->recent_scanned[file] += nr_taken;
 
-	__count_zone_vm_events(PGREFILL, zone, pgscanned);
+	__count_zone_vm_events(PGREFILL, zone, nr_scanned);
 	if (file)
 		__mod_zone_page_state(zone, NR_ACTIVE_FILE, -nr_taken);
 	else
_
Subject: Subject: mm: remove isolate_pages()

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

