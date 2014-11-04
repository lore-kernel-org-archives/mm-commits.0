From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-restrict-max-order-of-merging-on-isolated-pageblock.patch
 added to -mm tree
Date: Tue, 04 Nov 2014 12:22:05 -0800
Message-ID: <5459356d.kpJwcjwNSLlKcW5M%akpm__13907.7058564455$1415132543$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47334 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaKDUWF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2014 15:22:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, aneesh.kumar@linux.vnet.ibm.com, b.zolnierkie@samsung.com, gioh.kim@lge.com, hannes@cmpxchg.org, heesub.shin@samsung.com, isimatu.yasuaki@jp.fujitsu.com, kirill.shutemov@linux.intel.com, lauraa@codeaurora.org, m.szyprowski@samsung.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, ritesh.list@gmail.com, stable@vger.kernel.org, tangchen@cn.fujitsu.com, vbabka@suse.cz, wency@cn.fujitsu.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: restrict max order of merging on isolated pageblock
has been added to the -mm tree.  Its filename is
     mm-page_alloc-restrict-max-order-of-merging-on-isolated-pageblock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-restrict-max-order-of-merging-on-isolated-pageblock.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-restrict-max-order-of-merging-on-isolated-pageblock.patch

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
Subject: mm/page_alloc: restrict max order of merging on isolated pageblock

Current pageblock isolation logic could isolate each pageblock
individually.  This causes freepage accounting problem if freepage with
pageblock order on isolate pageblock is merged with other freepage on
normal pageblock.  We can prevent merging by restricting max order of
merging to pageblock order if freepage is on isolate pageblock.

Side-effect of this change is that there could be non-merged buddy
freepage even if finishing pageblock isolation, because undoing pageblock
isolation is just to move freepage from isolate buddy list to normal buddy
list rather than to consider merging.  So, the patch also makes undoing
pageblock isolation consider freepage merge.  When un-isolation, freepage
with more than pageblock order and it's buddy are checked.  If they are on
normal pageblock, instead of just moving, we isolate the freepage and free
it in order to get merged.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Heesub Shin <heesub.shin@samsung.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Gioh Kim <gioh.kim@lge.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h       |   25 +++++++++++++++++++++++++
 mm/page_alloc.c     |   41 ++++++++++++++---------------------------
 mm/page_isolation.c |   41 +++++++++++++++++++++++++++++++++++++++--
 3 files changed, 78 insertions(+), 29 deletions(-)

diff -puN mm/internal.h~mm-page_alloc-restrict-max-order-of-merging-on-isolated-pageblock mm/internal.h
--- a/mm/internal.h~mm-page_alloc-restrict-max-order-of-merging-on-isolated-pageblock
+++ a/mm/internal.h
@@ -108,6 +108,31 @@ extern pmd_t *mm_find_pmd(struct mm_stru
 /*
  * in mm/page_alloc.c
  */
+
+/*
+ * Locate the struct page for both the matching buddy in our
+ * pair (buddy1) and the combined O(n+1) page they form (page).
+ *
+ * 1) Any buddy B1 will have an order O twin B2 which satisfies
+ * the following equation:
+ *     B2 = B1 ^ (1 << O)
+ * For example, if the starting buddy (buddy2) is #8 its order
+ * 1 buddy is #10:
+ *     B2 = 8 ^ (1 << 1) = 8 ^ 2 = 10
+ *
+ * 2) Any buddy B will have an order O+1 parent P which
+ * satisfies the following equation:
+ *     P = B & ~(1 << O)
+ *
+ * Assumption: *_mem_map is contiguous at least up to MAX_ORDER
+ */
+static inline unsigned long
+__find_buddy_index(unsigned long page_idx, unsigned int order)
+{
+	return page_idx ^ (1 << order);
+}
+
+extern int __isolate_free_page(struct page *page, unsigned int order);
 extern void __free_pages_bootmem(struct page *page, unsigned int order);
 extern void prep_compound_page(struct page *page, unsigned long order);
 #ifdef CONFIG_MEMORY_FAILURE
diff -puN mm/page_alloc.c~mm-page_alloc-restrict-max-order-of-merging-on-isolated-pageblock mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-restrict-max-order-of-merging-on-isolated-pageblock
+++ a/mm/page_alloc.c
@@ -467,29 +467,6 @@ static inline void rmv_page_order(struct
 }
 
 /*
- * Locate the struct page for both the matching buddy in our
- * pair (buddy1) and the combined O(n+1) page they form (page).
- *
- * 1) Any buddy B1 will have an order O twin B2 which satisfies
- * the following equation:
- *     B2 = B1 ^ (1 << O)
- * For example, if the starting buddy (buddy2) is #8 its order
- * 1 buddy is #10:
- *     B2 = 8 ^ (1 << 1) = 8 ^ 2 = 10
- *
- * 2) Any buddy B will have an order O+1 parent P which
- * satisfies the following equation:
- *     P = B & ~(1 << O)
- *
- * Assumption: *_mem_map is contiguous at least up to MAX_ORDER
- */
-static inline unsigned long
-__find_buddy_index(unsigned long page_idx, unsigned int order)
-{
-	return page_idx ^ (1 << order);
-}
-
-/*
  * This function checks whether a page is free && is the buddy
  * we can do coalesce a page and its buddy if
  * (a) the buddy is not in a hole &&
@@ -569,6 +546,7 @@ static inline void __free_one_page(struc
 	unsigned long combined_idx;
 	unsigned long uninitialized_var(buddy_idx);
 	struct page *buddy;
+	int max_order = MAX_ORDER;
 
 	VM_BUG_ON(!zone_is_initialized(zone));
 
@@ -577,15 +555,24 @@ static inline void __free_one_page(struc
 			return;
 
 	VM_BUG_ON(migratetype == -1);
-	if (!is_migrate_isolate(migratetype))
+	if (is_migrate_isolate(migratetype)) {
+		/*
+		 * We restrict max order of merging to prevent merge
+		 * between freepages on isolate pageblock and normal
+		 * pageblock. Without this, pageblock isolation
+		 * could cause incorrect freepage accounting.
+		 */
+		max_order = min(MAX_ORDER, pageblock_order + 1);
+	} else {
 		__mod_zone_freepage_state(zone, 1 << order, migratetype);
+	}
 
-	page_idx = pfn & ((1 << MAX_ORDER) - 1);
+	page_idx = pfn & ((1 << max_order) - 1);
 
 	VM_BUG_ON_PAGE(page_idx & ((1 << order) - 1), page);
 	VM_BUG_ON_PAGE(bad_range(zone, page), page);
 
-	while (order < MAX_ORDER-1) {
+	while (order < max_order - 1) {
 		buddy_idx = __find_buddy_index(page_idx, order);
 		buddy = page + (buddy_idx - page_idx);
 		if (!page_is_buddy(page, buddy, order))
@@ -1486,7 +1473,7 @@ void split_page(struct page *page, unsig
 }
 EXPORT_SYMBOL_GPL(split_page);
 
-static int __isolate_free_page(struct page *page, unsigned int order)
+int __isolate_free_page(struct page *page, unsigned int order)
 {
 	unsigned long watermark;
 	struct zone *zone;
diff -puN mm/page_isolation.c~mm-page_alloc-restrict-max-order-of-merging-on-isolated-pageblock mm/page_isolation.c
--- a/mm/page_isolation.c~mm-page_alloc-restrict-max-order-of-merging-on-isolated-pageblock
+++ a/mm/page_isolation.c
@@ -76,17 +76,54 @@ void unset_migratetype_isolate(struct pa
 {
 	struct zone *zone;
 	unsigned long flags, nr_pages;
+	struct page *isolated_page = NULL;
+	unsigned int order;
+	unsigned long page_idx, buddy_idx;
+	struct page *buddy;
 
 	zone = page_zone(page);
 	spin_lock_irqsave(&zone->lock, flags);
 	if (get_pageblock_migratetype(page) != MIGRATE_ISOLATE)
 		goto out;
-	nr_pages = move_freepages_block(zone, page, migratetype);
-	__mod_zone_freepage_state(zone, nr_pages, migratetype);
+
+	/*
+	 * Because freepage with more than pageblock_order on isolated
+	 * pageblock is restricted to merge due to freepage counting problem,
+	 * it is possible that there is free buddy page.
+	 * move_freepages_block() doesn't care of merge so we need other
+	 * approach in order to merge them. Isolation and free will make
+	 * these pages to be merged.
+	 */
+	if (PageBuddy(page)) {
+		order = page_order(page);
+		if (order >= pageblock_order) {
+			page_idx = page_to_pfn(page) & ((1 << MAX_ORDER) - 1);
+			buddy_idx = __find_buddy_index(page_idx, order);
+			buddy = page + (buddy_idx - page_idx);
+
+			if (!is_migrate_isolate_page(buddy)) {
+				__isolate_free_page(page, order);
+				set_page_refcounted(page);
+				isolated_page = page;
+			}
+		}
+	}
+
+	/*
+	 * If we isolate freepage with more than pageblock_order, there
+	 * should be no freepage in the range, so we could avoid costly
+	 * pageblock scanning for freepage moving.
+	 */
+	if (!isolated_page) {
+		nr_pages = move_freepages_block(zone, page, migratetype);
+		__mod_zone_freepage_state(zone, nr_pages, migratetype);
+	}
 	set_pageblock_migratetype(page, migratetype);
 	zone->nr_isolate_pageblock--;
 out:
 	spin_unlock_irqrestore(&zone->lock, flags);
+	if (isolated_page)
+		__free_pages(isolated_page, order);
 }
 
 static inline struct page *
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-compaction-skip-the-range-until-proper-target-pageblock-is-met.patch
mm-page_alloc-fix-incorrect-isolation-behavior-by-rechecking-migratetype.patch
mm-page_alloc-add-freepage-on-isolate-pageblock-to-correct-buddy-list.patch
mm-page_alloc-move-freepage-counting-logic-to-__free_one_page.patch
mm-page_alloc-restrict-max-order-of-merging-on-isolated-pageblock.patch
mm-slab-slub-coding-style-whitespaces-and-tabs-mixture.patch
slab-print-slabinfo-header-in-seq-show.patch
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
zsmalloc-merge-size_class-to-reduce-fragmentation.patch
slab-fix-cpuset-check-in-fallback_alloc.patch
slub-fix-cpuset-check-in-get_any_partial.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch
mm-cma-split-cma-reserved-in-dmesg-log.patch
fs-proc-include-cma-info-in-proc-meminfo.patch
page-owners-correct-page-order-when-to-free-page.patch

