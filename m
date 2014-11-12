From: akpm@linux-foundation.org
Subject: + mm-debug-pagealloc-cleanup-page-guard-code.patch added to -mm
 tree
Date: Wed, 12 Nov 2014 13:26:08 -0800
Message-ID: <5463d070.Dk5lgDRp7qxrwUuu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49269 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbaKLV0J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Nov 2014 16:26:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, gioh.kim@lge.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug-pagealloc: cleanup page guard code
has been added to the -mm tree.  Its filename is
     mm-debug-pagealloc-cleanup-page-guard-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-debug-pagealloc-cleanup-page-guard-code.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-debug-pagealloc-cleanup-page-guard-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/debug-pagealloc: cleanup page guard code

Page guard is used by debug-pagealloc feature.  Currently, it is
open-coded, but, I think that more abstraction of it makes core page
allocator code more readable.

There is no functional difference.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Gioh Kim <gioh.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff -puN mm/page_alloc.c~mm-debug-pagealloc-cleanup-page-guard-code mm/page_alloc.c
--- a/mm/page_alloc.c~mm-debug-pagealloc-cleanup-page-guard-code
+++ a/mm/page_alloc.c
@@ -439,18 +439,29 @@ static int __init debug_guardpage_minord
 }
 __setup("debug_guardpage_minorder=", debug_guardpage_minorder_setup);
 
-static inline void set_page_guard_flag(struct page *page)
+static inline void set_page_guard(struct zone *zone, struct page *page,
+				unsigned int order, int migratetype)
 {
 	__set_bit(PAGE_DEBUG_FLAG_GUARD, &page->debug_flags);
+	INIT_LIST_HEAD(&page->lru);
+	set_page_private(page, order);
+	/* Guard pages are not available for any usage */
+	__mod_zone_freepage_state(zone, -(1 << order), migratetype);
 }
 
-static inline void clear_page_guard_flag(struct page *page)
+static inline void clear_page_guard(struct zone *zone, struct page *page,
+				unsigned int order, int migratetype)
 {
 	__clear_bit(PAGE_DEBUG_FLAG_GUARD, &page->debug_flags);
+	set_page_private(page, 0);
+	if (!is_migrate_isolate(migratetype))
+		__mod_zone_freepage_state(zone, (1 << order), migratetype);
 }
 #else
-static inline void set_page_guard_flag(struct page *page) { }
-static inline void clear_page_guard_flag(struct page *page) { }
+static inline void set_page_guard(struct zone *zone, struct page *page,
+				unsigned int order, int migratetype) {}
+static inline void clear_page_guard(struct zone *zone, struct page *page,
+				unsigned int order, int migratetype) {}
 #endif
 
 static inline void set_page_order(struct page *page, unsigned int order)
@@ -581,12 +592,7 @@ static inline void __free_one_page(struc
 		 * merge with it and move up one order.
 		 */
 		if (page_is_guard(buddy)) {
-			clear_page_guard_flag(buddy);
-			set_page_private(buddy, 0);
-			if (!is_migrate_isolate(migratetype)) {
-				__mod_zone_freepage_state(zone, 1 << order,
-							  migratetype);
-			}
+			clear_page_guard(zone, buddy, order, migratetype);
 		} else {
 			list_del(&buddy->lru);
 			zone->free_area[order].nr_free--;
@@ -861,23 +867,17 @@ static inline void expand(struct zone *z
 		size >>= 1;
 		VM_BUG_ON_PAGE(bad_range(zone, &page[size]), &page[size]);
 
-#ifdef CONFIG_DEBUG_PAGEALLOC
-		if (high < debug_guardpage_minorder()) {
+		if (IS_ENABLED(CONFIG_DEBUG_PAGEALLOC) &&
+			high < debug_guardpage_minorder()) {
 			/*
 			 * Mark as guard pages (or page), that will allow to
 			 * merge back to allocator when buddy will be freed.
 			 * Corresponding page table entries will not be touched,
 			 * pages will stay not present in virtual address space
 			 */
-			INIT_LIST_HEAD(&page[size].lru);
-			set_page_guard_flag(&page[size]);
-			set_page_private(&page[size], high);
-			/* Guard pages are not available for any usage */
-			__mod_zone_freepage_state(zone, -(1 << high),
-						  migratetype);
+			set_page_guard(zone, &page[size], high, migratetype);
 			continue;
 		}
-#endif
 		list_add(&page[size].lru, &area->free_list[migratetype]);
 		area->nr_free++;
 		set_page_order(&page[size], high);
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-compaction-skip-the-range-until-proper-target-pageblock-is-met.patch
mm-page_alloc-fix-incorrect-isolation-behavior-by-rechecking-migratetype.patch
mm-page_alloc-add-freepage-on-isolate-pageblock-to-correct-buddy-list.patch
mm-page_alloc-move-freepage-counting-logic-to-__free_one_page.patch
mm-page_alloc-restrict-max-order-of-merging-on-isolated-pageblock.patch
mm-slab-fix-unalignment-problem-on-malta-with-eva-due-to-slab-merge.patch
mm-compaction-prevent-infinite-loop-in-compact_zone.patch
mm-debug-pagealloc-correct-freepage-accounting-and-order-resetting.patch
mm-slab-slub-coding-style-whitespaces-and-tabs-mixture.patch
slab-print-slabinfo-header-in-seq-show.patch
mm-slab-reverse-iteration-on-find_mergeable.patch
mm-slub-fix-format-mismatches-in-slab_err-callers.patch
slab-improve-checking-for-invalid-gfp_flags.patch
mm-introduce-single-zone-pcplists-drain.patch
mm-page_isolation-drain-single-zone-pcplists.patch
mm-cma-drain-single-zone-pcplists.patch
mm-memory_hotplug-failure-drain-single-zone-pcplists.patch
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking.patch
mm-compaction-simplify-deferred-compaction.patch
mm-compaction-defer-only-on-compact_complete.patch
mm-compaction-always-update-cached-scanner-positions.patch
mm-compaction-more-focused-lru-and-pcplists-draining.patch
memcg-use-generic-slab-iterators-for-showing-slabinfo.patch
mm-embed-the-memcg-pointer-directly-into-struct-page.patch
mm-embed-the-memcg-pointer-directly-into-struct-page-fix.patch
mm-page_cgroup-rename-file-to-mm-swap_cgroupc.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix-2.patch
lib-bitmap-added-alignment-offset-for-bitmap_find_next_zero_area.patch
mm-cma-align-to-physical-address-not-cma-region-position.patch
mm-debug-pagealloc-cleanup-page-guard-code.patch
zsmalloc-merge-size_class-to-reduce-fragmentation.patch
slab-fix-cpuset-check-in-fallback_alloc.patch
slub-fix-cpuset-check-in-get_any_partial.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch
mm-cma-split-cma-reserved-in-dmesg-log.patch
fs-proc-include-cma-info-in-proc-meminfo.patch
page-owners-correct-page-order-when-to-free-page.patch

