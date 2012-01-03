From: akpm@linux-foundation.org
Subject: + mm-enum-lru_list-lru.patch added to -mm tree
Date: Tue, 03 Jan 2012 15:34:37 -0800
Message-ID: <20120103233438.A2BDB5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:53120 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880Ab2ACXek (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jan 2012 18:34:40 -0500
Received: by eaak10 with SMTP id k10so312687eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 03 Jan 2012 15:34:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     Subject: mm: enum lru_list lru
has been added to the -mm tree.  Its filename is
     mm-enum-lru_list-lru.patch

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
Subject: mm: enum lru_list lru

Mostly we use "enum lru_list lru": change those few "l"s to "lru"s.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |   26 +++++++++++++-------------
 include/linux/mmzone.h    |   16 ++++++++--------
 mm/page_alloc.c           |    6 +++---
 mm/vmscan.c               |   22 +++++++++++-----------
 4 files changed, 35 insertions(+), 35 deletions(-)

diff -puN include/linux/mm_inline.h~mm-enum-lru_list-lru include/linux/mm_inline.h
--- a/include/linux/mm_inline.h~mm-enum-lru_list-lru
+++ a/include/linux/mm_inline.h
@@ -22,21 +22,21 @@ static inline int page_is_file_cache(str
 }
 
 static inline void
-add_page_to_lru_list(struct zone *zone, struct page *page, enum lru_list l)
+add_page_to_lru_list(struct zone *zone, struct page *page, enum lru_list lru)
 {
 	struct lruvec *lruvec;
 
-	lruvec = mem_cgroup_lru_add_list(zone, page, l);
-	list_add(&page->lru, &lruvec->lists[l]);
-	__mod_zone_page_state(zone, NR_LRU_BASE + l, hpage_nr_pages(page));
+	lruvec = mem_cgroup_lru_add_list(zone, page, lru);
+	list_add(&page->lru, &lruvec->lists[lru]);
+	__mod_zone_page_state(zone, NR_LRU_BASE + lru, hpage_nr_pages(page));
 }
 
 static inline void
-del_page_from_lru_list(struct zone *zone, struct page *page, enum lru_list l)
+del_page_from_lru_list(struct zone *zone, struct page *page, enum lru_list lru)
 {
-	mem_cgroup_lru_del_list(page, l);
+	mem_cgroup_lru_del_list(page, lru);
 	list_del(&page->lru);
-	__mod_zone_page_state(zone, NR_LRU_BASE + l, -hpage_nr_pages(page));
+	__mod_zone_page_state(zone, NR_LRU_BASE + lru, -hpage_nr_pages(page));
 }
 
 /**
@@ -57,21 +57,21 @@ static inline enum lru_list page_lru_bas
 static inline void
 del_page_from_lru(struct zone *zone, struct page *page)
 {
-	enum lru_list l;
+	enum lru_list lru;
 
 	if (PageUnevictable(page)) {
 		__ClearPageUnevictable(page);
-		l = LRU_UNEVICTABLE;
+		lru = LRU_UNEVICTABLE;
 	} else {
-		l = page_lru_base_type(page);
+		lru = page_lru_base_type(page);
 		if (PageActive(page)) {
 			__ClearPageActive(page);
-			l += LRU_ACTIVE;
+			lru += LRU_ACTIVE;
 		}
 	}
-	mem_cgroup_lru_del_list(page, l);
+	mem_cgroup_lru_del_list(page, lru);
 	list_del(&page->lru);
-	__mod_zone_page_state(zone, NR_LRU_BASE + l, -hpage_nr_pages(page));
+	__mod_zone_page_state(zone, NR_LRU_BASE + lru, -hpage_nr_pages(page));
 }
 
 /**
diff -puN include/linux/mmzone.h~mm-enum-lru_list-lru include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-enum-lru_list-lru
+++ a/include/linux/mmzone.h
@@ -140,23 +140,23 @@ enum lru_list {
 	NR_LRU_LISTS
 };
 
-#define for_each_lru(l) for (l = 0; l < NR_LRU_LISTS; l++)
+#define for_each_lru(lru) for (lru = 0; lru < NR_LRU_LISTS; lru++)
 
-#define for_each_evictable_lru(l) for (l = 0; l <= LRU_ACTIVE_FILE; l++)
+#define for_each_evictable_lru(lru) for (lru = 0; lru <= LRU_ACTIVE_FILE; lru++)
 
-static inline int is_file_lru(enum lru_list l)
+static inline int is_file_lru(enum lru_list lru)
 {
-	return (l == LRU_INACTIVE_FILE || l == LRU_ACTIVE_FILE);
+	return (lru == LRU_INACTIVE_FILE || lru == LRU_ACTIVE_FILE);
 }
 
-static inline int is_active_lru(enum lru_list l)
+static inline int is_active_lru(enum lru_list lru)
 {
-	return (l == LRU_ACTIVE_ANON || l == LRU_ACTIVE_FILE);
+	return (lru == LRU_ACTIVE_ANON || lru == LRU_ACTIVE_FILE);
 }
 
-static inline int is_unevictable_lru(enum lru_list l)
+static inline int is_unevictable_lru(enum lru_list lru)
 {
-	return (l == LRU_UNEVICTABLE);
+	return (lru == LRU_UNEVICTABLE);
 }
 
 struct lruvec {
diff -puN mm/page_alloc.c~mm-enum-lru_list-lru mm/page_alloc.c
--- a/mm/page_alloc.c~mm-enum-lru_list-lru
+++ a/mm/page_alloc.c
@@ -4275,7 +4275,7 @@ static void __paginginit free_area_init_
 	for (j = 0; j < MAX_NR_ZONES; j++) {
 		struct zone *zone = pgdat->node_zones + j;
 		unsigned long size, realsize, memmap_pages;
-		enum lru_list l;
+		enum lru_list lru;
 
 		size = zone_spanned_pages_in_node(nid, j, zones_size);
 		realsize = size - zone_absent_pages_in_node(nid, j,
@@ -4325,8 +4325,8 @@ static void __paginginit free_area_init_
 		zone->zone_pgdat = pgdat;
 
 		zone_pcp_init(zone);
-		for_each_lru(l)
-			INIT_LIST_HEAD(&zone->lruvec.lists[l]);
+		for_each_lru(lru)
+			INIT_LIST_HEAD(&zone->lruvec.lists[lru]);
 		zone->reclaim_stat.recent_rotated[0] = 0;
 		zone->reclaim_stat.recent_rotated[1] = 0;
 		zone->reclaim_stat.recent_scanned[0] = 0;
diff -puN mm/vmscan.c~mm-enum-lru_list-lru mm/vmscan.c
--- a/mm/vmscan.c~mm-enum-lru_list-lru
+++ a/mm/vmscan.c
@@ -1920,7 +1920,7 @@ static void get_scan_count(struct mem_cg
 	unsigned long ap, fp;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(mz);
 	u64 fraction[2], denominator;
-	enum lru_list l;
+	enum lru_list lru;
 	int noswap = 0;
 	bool force_scan = false;
 
@@ -2010,18 +2010,18 @@ static void get_scan_count(struct mem_cg
 	fraction[1] = fp;
 	denominator = ap + fp + 1;
 out:
-	for_each_evictable_lru(l) {
-		int file = is_file_lru(l);
+	for_each_evictable_lru(lru) {
+		int file = is_file_lru(lru);
 		unsigned long scan;
 
-		scan = zone_nr_lru_pages(mz, l);
+		scan = zone_nr_lru_pages(mz, lru);
 		if (priority || noswap) {
 			scan >>= priority;
 			if (!scan && force_scan)
 				scan = SWAP_CLUSTER_MAX;
 			scan = div64_u64(scan * fraction[file], denominator);
 		}
-		nr[l] = scan;
+		nr[lru] = scan;
 	}
 }
 
@@ -2097,7 +2097,7 @@ static void shrink_mem_cgroup_zone(int p
 {
 	unsigned long nr[NR_LRU_LISTS];
 	unsigned long nr_to_scan;
-	enum lru_list l;
+	enum lru_list lru;
 	unsigned long nr_reclaimed, nr_scanned;
 	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
 	struct blk_plug plug;
@@ -2110,13 +2110,13 @@ restart:
 	blk_start_plug(&plug);
 	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
 					nr[LRU_INACTIVE_FILE]) {
-		for_each_evictable_lru(l) {
-			if (nr[l]) {
+		for_each_evictable_lru(lru) {
+			if (nr[lru]) {
 				nr_to_scan = min_t(unsigned long,
-						   nr[l], SWAP_CLUSTER_MAX);
-				nr[l] -= nr_to_scan;
+						   nr[lru], SWAP_CLUSTER_MAX);
+				nr[lru] -= nr_to_scan;
 
-				nr_reclaimed += shrink_list(l, nr_to_scan,
+				nr_reclaimed += shrink_list(lru, nr_to_scan,
 							    mz, sc, priority);
 			}
 		}
_
Subject: Subject: mm: enum lru_list lru

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

