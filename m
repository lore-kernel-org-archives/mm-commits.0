From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-use-zone-and-order-instead-of-free-area-in-free_list-manipulators.patch
 added to -mm tree
Date: Tue, 11 Feb 2020 16:19:43 -0800
Message-ID: <20200212001943._nhfNpvgs%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728060AbgBLATr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Feb 2020 19:19:47 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, alexander.h.duyck@linux.intel.com, dan.j.williams@intel.com, dave.hansen@intel.com, david@redhat.com, konrad.wilk@oracle.com, lcapitulino@redhat.com, mgorman@techsingularity.net, mhocko@kernel.org, mm-commits@vger.kernel.org, mst@redhat.com, nitesh@redhat.com, osalvador@suse.de, pagupta@redhat.com, pbonzini@redhat.com, riel@surriel.com, vbabka@suse.cz, wei.w.wang@intel.com, willy@infradead.org, yang.zhang.wz@gmail.com


The patch titled
     Subject: mm: use zone and order instead of free area in free_list manipulators
has been added to the -mm tree.  Its filename is
     mm-use-zone-and-order-instead-of-free-area-in-free_list-manipulators.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-zone-and-order-instead-of-free-area-in-free_list-manipulators.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-zone-and-order-instead-of-free-area-in-free_list-manipulators.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Subject: mm: use zone and order instead of free area in free_list manipulators

In order to enable the use of the zone from the list manipulator functions
I will need access to the zone pointer.  As it turns out most of the
accessors were always just being directly passed &zone->free_area[order]
anyway so it would make sense to just fold that into the function itself
and pass the zone and order as arguments instead of the free area.

In order to be able to reference the zone we need to move the declaration
of the functions down so that we have the zone defined before we define
the list manipulation functions.  Since the functions are only used in the
file mm/page_alloc.c we can just move them there to reduce noise in the
header.

Link: http://lkml.kernel.org/r/20200211224613.29318.43080.stgit@localhost.localdomain
Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Pankaj Gupta <pagupta@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Nitesh Narayan Lal <nitesh@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Wang <wei.w.wang@intel.com>
Cc: Yang Zhang <yang.zhang.wz@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   32 ------------------
 mm/page_alloc.c        |   67 ++++++++++++++++++++++++++++-----------
 2 files changed, 49 insertions(+), 50 deletions(-)

--- a/include/linux/mmzone.h~mm-use-zone-and-order-instead-of-free-area-in-free_list-manipulators
+++ a/include/linux/mmzone.h
@@ -100,29 +100,6 @@ struct free_area {
 	unsigned long		nr_free;
 };
 
-/* Used for pages not on another list */
-static inline void add_to_free_area(struct page *page, struct free_area *area,
-			     int migratetype)
-{
-	list_add(&page->lru, &area->free_list[migratetype]);
-	area->nr_free++;
-}
-
-/* Used for pages not on another list */
-static inline void add_to_free_area_tail(struct page *page, struct free_area *area,
-				  int migratetype)
-{
-	list_add_tail(&page->lru, &area->free_list[migratetype]);
-	area->nr_free++;
-}
-
-/* Used for pages which are on another list */
-static inline void move_to_free_area(struct page *page, struct free_area *area,
-			     int migratetype)
-{
-	list_move(&page->lru, &area->free_list[migratetype]);
-}
-
 static inline struct page *get_page_from_free_area(struct free_area *area,
 					    int migratetype)
 {
@@ -130,15 +107,6 @@ static inline struct page *get_page_from
 					struct page, lru);
 }
 
-static inline void del_page_from_free_area(struct page *page,
-		struct free_area *area)
-{
-	list_del(&page->lru);
-	__ClearPageBuddy(page);
-	set_page_private(page, 0);
-	area->nr_free--;
-}
-
 static inline bool free_area_empty(struct free_area *area, int migratetype)
 {
 	return list_empty(&area->free_list[migratetype]);
--- a/mm/page_alloc.c~mm-use-zone-and-order-instead-of-free-area-in-free_list-manipulators
+++ a/mm/page_alloc.c
@@ -872,6 +872,44 @@ compaction_capture(struct capture_contro
 }
 #endif /* CONFIG_COMPACTION */
 
+/* Used for pages not on another list */
+static inline void add_to_free_list(struct page *page, struct zone *zone,
+				    unsigned int order, int migratetype)
+{
+	struct free_area *area = &zone->free_area[order];
+
+	list_add(&page->lru, &area->free_list[migratetype]);
+	area->nr_free++;
+}
+
+/* Used for pages not on another list */
+static inline void add_to_free_list_tail(struct page *page, struct zone *zone,
+					 unsigned int order, int migratetype)
+{
+	struct free_area *area = &zone->free_area[order];
+
+	list_add_tail(&page->lru, &area->free_list[migratetype]);
+	area->nr_free++;
+}
+
+/* Used for pages which are on another list */
+static inline void move_to_free_list(struct page *page, struct zone *zone,
+				     unsigned int order, int migratetype)
+{
+	struct free_area *area = &zone->free_area[order];
+
+	list_move(&page->lru, &area->free_list[migratetype]);
+}
+
+static inline void del_page_from_free_list(struct page *page, struct zone *zone,
+					   unsigned int order)
+{
+	list_del(&page->lru);
+	__ClearPageBuddy(page);
+	set_page_private(page, 0);
+	zone->free_area[order].nr_free--;
+}
+
 /*
  * If this is not the largest possible page, check if the buddy
  * of the next-highest order is free. If it is, it's possible
@@ -934,7 +972,6 @@ static inline void __free_one_page(struc
 	struct capture_control *capc = task_capc(zone);
 	unsigned long uninitialized_var(buddy_pfn);
 	unsigned long combined_pfn;
-	struct free_area *area;
 	unsigned int max_order;
 	struct page *buddy;
 	bool to_tail;
@@ -972,7 +1009,7 @@ continue_merging:
 		if (page_is_guard(buddy))
 			clear_page_guard(zone, buddy, order, migratetype);
 		else
-			del_page_from_free_area(buddy, &zone->free_area[order]);
+			del_page_from_free_list(buddy, zone, order);
 		combined_pfn = buddy_pfn & pfn;
 		page = page + (combined_pfn - pfn);
 		pfn = combined_pfn;
@@ -1006,16 +1043,15 @@ continue_merging:
 done_merging:
 	set_page_order(page, order);
 
-	area = &zone->free_area[order];
 	if (is_shuffle_order(order))
 		to_tail = shuffle_pick_tail();
 	else
 		to_tail = buddy_merge_likely(pfn, buddy_pfn, page, order);
 
 	if (to_tail)
-		add_to_free_area_tail(page, area, migratetype);
+		add_to_free_list_tail(page, zone, order, migratetype);
 	else
-		add_to_free_area(page, area, migratetype);
+		add_to_free_list(page, zone, order, migratetype);
 }
 
 /*
@@ -2029,13 +2065,11 @@ void __init init_cma_reserved_pageblock(
  * -- nyc
  */
 static inline void expand(struct zone *zone, struct page *page,
-	int low, int high, struct free_area *area,
-	int migratetype)
+	int low, int high, int migratetype)
 {
 	unsigned long size = 1 << high;
 
 	while (high > low) {
-		area--;
 		high--;
 		size >>= 1;
 		VM_BUG_ON_PAGE(bad_range(zone, &page[size]), &page[size]);
@@ -2049,7 +2083,7 @@ static inline void expand(struct zone *z
 		if (set_page_guard(zone, &page[size], high, migratetype))
 			continue;
 
-		add_to_free_area(&page[size], area, migratetype);
+		add_to_free_list(&page[size], zone, high, migratetype);
 		set_page_order(&page[size], high);
 	}
 }
@@ -2207,8 +2241,8 @@ struct page *__rmqueue_smallest(struct z
 		page = get_page_from_free_area(area, migratetype);
 		if (!page)
 			continue;
-		del_page_from_free_area(page, area);
-		expand(zone, page, order, current_order, area, migratetype);
+		del_page_from_free_list(page, zone, current_order);
+		expand(zone, page, order, current_order, migratetype);
 		set_pcppage_migratetype(page, migratetype);
 		return page;
 	}
@@ -2282,7 +2316,7 @@ static int move_freepages(struct zone *z
 		VM_BUG_ON_PAGE(page_zone(page) != zone, page);
 
 		order = page_order(page);
-		move_to_free_area(page, &zone->free_area[order], migratetype);
+		move_to_free_list(page, zone, order, migratetype);
 		page += 1 << order;
 		pages_moved += 1 << order;
 	}
@@ -2398,7 +2432,6 @@ static void steal_suitable_fallback(stru
 		unsigned int alloc_flags, int start_type, bool whole_block)
 {
 	unsigned int current_order = page_order(page);
-	struct free_area *area;
 	int free_pages, movable_pages, alike_pages;
 	int old_block_type;
 
@@ -2469,8 +2502,7 @@ static void steal_suitable_fallback(stru
 	return;
 
 single_page:
-	area = &zone->free_area[current_order];
-	move_to_free_area(page, area, start_type);
+	move_to_free_list(page, zone, current_order, start_type);
 }
 
 /*
@@ -3141,7 +3173,6 @@ EXPORT_SYMBOL_GPL(split_page);
 
 int __isolate_free_page(struct page *page, unsigned int order)
 {
-	struct free_area *area = &page_zone(page)->free_area[order];
 	unsigned long watermark;
 	struct zone *zone;
 	int mt;
@@ -3167,7 +3198,7 @@ int __isolate_free_page(struct page *pag
 
 	/* Remove page from free list */
 
-	del_page_from_free_area(page, area);
+	del_page_from_free_list(page, zone, order);
 
 	/*
 	 * Set the pageblock if the isolated page is at least half of a
@@ -8724,7 +8755,7 @@ __offline_isolated_pages(unsigned long s
 		BUG_ON(!PageBuddy(page));
 		order = page_order(page);
 		offlined_pages += 1 << order;
-		del_page_from_free_area(page, &zone->free_area[order]);
+		del_page_from_free_list(page, zone, order);
 		pfn += (1 << order);
 	}
 	spin_unlock_irqrestore(&zone->lock, flags);
_

Patches currently in -mm which might be from alexander.h.duyck@linux.intel.com are

mm-adjust-shuffle-code-to-allow-for-future-coalescing.patch
mm-use-zone-and-order-instead-of-free-area-in-free_list-manipulators.patch
mm-add-function-__putback_isolated_page.patch
mm-introduce-reported-pages.patch
virtio-balloon-pull-page-poisoning-config-out-of-free-page-hinting.patch
virtio-balloon-add-support-for-providing-free-page-reports-to-host.patch
mm-page_reporting-rotate-reported-pages-to-the-tail-of-the-list.patch
mm-page_reporting-add-budget-limit-on-how-many-pages-can-be-reported-per-pass.patch
mm-page_reporting-add-free-page-reporting-documentation.patch
