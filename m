From: akpm@linux-foundation.org
Subject: [merged] mm-add-use-zone_end_pfn-and-zone_spans_pfn.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:54:29 -0800
Message-ID: <20130225205429.BC17C5A426D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:33369 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115Ab3BYUyb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:54:31 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so347854vch.0
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:54:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cody@linux.vnet.ibm.com, catalin.marinas@arm.com, dave@linux.vnet.ibm.com, hannes@cmpxchg.org, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add & use zone_end_pfn() and zone_spans_pfn()
has been removed from the -mm tree.  Its filename was
     mm-add-use-zone_end_pfn-and-zone_spans_pfn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: mm: add & use zone_end_pfn() and zone_spans_pfn()

Add 2 helpers (zone_end_pfn() and zone_spans_pfn()) to reduce code
duplication.

This also switches to using them in compaction (where an additional
variable needed to be renamed), page_alloc, vmstat, memory_hotplug, and
kmemleak.

Note that in compaction.c I avoid calling zone_end_pfn() repeatedly because I
expect at some point the sycronization issues with start_pfn & spanned_pages
will need fixing, either by actually using the seqlock or clever memory barrier
usage.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: David Hansen <dave@linux.vnet.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   10 ++++++++++
 mm/compaction.c        |   10 +++++-----
 mm/kmemleak.c          |    5 ++---
 mm/memory_hotplug.c    |   10 +++++-----
 mm/page_alloc.c        |   22 +++++++++-------------
 mm/vmstat.c            |    2 +-
 6 files changed, 32 insertions(+), 27 deletions(-)

diff -puN include/linux/mmzone.h~mm-add-use-zone_end_pfn-and-zone_spans_pfn include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-add-use-zone_end_pfn-and-zone_spans_pfn
+++ a/include/linux/mmzone.h
@@ -527,6 +527,16 @@ static inline int zone_is_oom_locked(con
 	return test_bit(ZONE_OOM_LOCKED, &zone->flags);
 }
 
+static inline unsigned zone_end_pfn(const struct zone *zone)
+{
+	return zone->zone_start_pfn + zone->spanned_pages;
+}
+
+static inline bool zone_spans_pfn(const struct zone *zone, unsigned long pfn)
+{
+	return zone->zone_start_pfn <= pfn && pfn < zone_end_pfn(zone);
+}
+
 /*
  * The "priority" of VM scanning is how much of the queues we will scan in one
  * go. A value of 12 for DEF_PRIORITY implies that we will scan 1/4096th of the
diff -puN mm/compaction.c~mm-add-use-zone_end_pfn-and-zone_spans_pfn mm/compaction.c
--- a/mm/compaction.c~mm-add-use-zone_end_pfn-and-zone_spans_pfn
+++ a/mm/compaction.c
@@ -86,7 +86,7 @@ static inline bool isolation_suitable(st
 static void __reset_isolation_suitable(struct zone *zone)
 {
 	unsigned long start_pfn = zone->zone_start_pfn;
-	unsigned long end_pfn = zone->zone_start_pfn + zone->spanned_pages;
+	unsigned long end_pfn = zone_end_pfn(zone);
 	unsigned long pfn;
 
 	zone->compact_cached_migrate_pfn = start_pfn;
@@ -647,7 +647,7 @@ static void isolate_freepages(struct zon
 				struct compact_control *cc)
 {
 	struct page *page;
-	unsigned long high_pfn, low_pfn, pfn, zone_end_pfn, end_pfn;
+	unsigned long high_pfn, low_pfn, pfn, z_end_pfn, end_pfn;
 	int nr_freepages = cc->nr_freepages;
 	struct list_head *freelist = &cc->freepages;
 
@@ -666,7 +666,7 @@ static void isolate_freepages(struct zon
 	 */
 	high_pfn = min(low_pfn, pfn);
 
-	zone_end_pfn = zone->zone_start_pfn + zone->spanned_pages;
+	z_end_pfn = zone_end_pfn(zone);
 
 	/*
 	 * Isolate free pages until enough are available to migrate the
@@ -709,7 +709,7 @@ static void isolate_freepages(struct zon
 		 * only scans within a pageblock
 		 */
 		end_pfn = ALIGN(pfn + 1, pageblock_nr_pages);
-		end_pfn = min(end_pfn, zone_end_pfn);
+		end_pfn = min(end_pfn, z_end_pfn);
 		isolated = isolate_freepages_block(cc, pfn, end_pfn,
 						   freelist, false);
 		nr_freepages += isolated;
@@ -923,7 +923,7 @@ static int compact_zone(struct zone *zon
 {
 	int ret;
 	unsigned long start_pfn = zone->zone_start_pfn;
-	unsigned long end_pfn = zone->zone_start_pfn + zone->spanned_pages;
+	unsigned long end_pfn = zone_end_pfn(zone);
 
 	ret = compaction_suitable(zone, cc->order);
 	switch (ret) {
diff -puN mm/kmemleak.c~mm-add-use-zone_end_pfn-and-zone_spans_pfn mm/kmemleak.c
--- a/mm/kmemleak.c~mm-add-use-zone_end_pfn-and-zone_spans_pfn
+++ a/mm/kmemleak.c
@@ -1300,9 +1300,8 @@ static void kmemleak_scan(void)
 	 */
 	lock_memory_hotplug();
 	for_each_online_node(i) {
-		pg_data_t *pgdat = NODE_DATA(i);
-		unsigned long start_pfn = pgdat->node_start_pfn;
-		unsigned long end_pfn = start_pfn + pgdat->node_spanned_pages;
+		unsigned long start_pfn = node_start_pfn(i);
+		unsigned long end_pfn = node_end_pfn(i);
 		unsigned long pfn;
 
 		for (pfn = start_pfn; pfn < end_pfn; pfn++) {
diff -puN mm/memory_hotplug.c~mm-add-use-zone_end_pfn-and-zone_spans_pfn mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-add-use-zone_end_pfn-and-zone_spans_pfn
+++ a/mm/memory_hotplug.c
@@ -299,7 +299,7 @@ static int __meminit move_pfn_range_left
 	pgdat_resize_lock(z1->zone_pgdat, &flags);
 
 	/* can't move pfns which are higher than @z2 */
-	if (end_pfn > z2->zone_start_pfn + z2->spanned_pages)
+	if (end_pfn > zone_end_pfn(z2))
 		goto out_fail;
 	/* the move out part mast at the left most of @z2 */
 	if (start_pfn > z2->zone_start_pfn)
@@ -315,7 +315,7 @@ static int __meminit move_pfn_range_left
 		z1_start_pfn = start_pfn;
 
 	resize_zone(z1, z1_start_pfn, end_pfn);
-	resize_zone(z2, end_pfn, z2->zone_start_pfn + z2->spanned_pages);
+	resize_zone(z2, end_pfn, zone_end_pfn(z2));
 
 	pgdat_resize_unlock(z1->zone_pgdat, &flags);
 
@@ -347,15 +347,15 @@ static int __meminit move_pfn_range_righ
 	if (z1->zone_start_pfn > start_pfn)
 		goto out_fail;
 	/* the move out part mast at the right most of @z1 */
-	if (z1->zone_start_pfn + z1->spanned_pages >  end_pfn)
+	if (zone_end_pfn(z1) >  end_pfn)
 		goto out_fail;
 	/* must included/overlap */
-	if (start_pfn >= z1->zone_start_pfn + z1->spanned_pages)
+	if (start_pfn >= zone_end_pfn(z1))
 		goto out_fail;
 
 	/* use end_pfn for z2's end_pfn if z2 is empty */
 	if (z2->spanned_pages)
-		z2_end_pfn = z2->zone_start_pfn + z2->spanned_pages;
+		z2_end_pfn = zone_end_pfn(z2);
 	else
 		z2_end_pfn = end_pfn;
 
diff -puN mm/page_alloc.c~mm-add-use-zone_end_pfn-and-zone_spans_pfn mm/page_alloc.c
--- a/mm/page_alloc.c~mm-add-use-zone_end_pfn-and-zone_spans_pfn
+++ a/mm/page_alloc.c
@@ -250,9 +250,7 @@ static int page_outside_zone_boundaries(
 
 	do {
 		seq = zone_span_seqbegin(zone);
-		if (pfn >= zone->zone_start_pfn + zone->spanned_pages)
-			ret = 1;
-		else if (pfn < zone->zone_start_pfn)
+		if (!zone_spans_pfn(zone, pfn))
 			ret = 1;
 	} while (zone_span_seqretry(zone, seq));
 
@@ -990,9 +988,9 @@ int move_freepages_block(struct zone *zo
 	end_pfn = start_pfn + pageblock_nr_pages - 1;
 
 	/* Do not cross zone boundaries */
-	if (start_pfn < zone->zone_start_pfn)
+	if (!zone_spans_pfn(zone, start_pfn))
 		start_page = page;
-	if (end_pfn >= zone->zone_start_pfn + zone->spanned_pages)
+	if (!zone_spans_pfn(zone, end_pfn))
 		return 0;
 
 	return move_freepages(zone, start_page, end_page, migratetype);
@@ -1286,7 +1284,7 @@ void mark_free_pages(struct zone *zone)
 
 	spin_lock_irqsave(&zone->lock, flags);
 
-	max_zone_pfn = zone->zone_start_pfn + zone->spanned_pages;
+	max_zone_pfn = zone_end_pfn(zone);
 	for (pfn = zone->zone_start_pfn; pfn < max_zone_pfn; pfn++)
 		if (pfn_valid(pfn)) {
 			struct page *page = pfn_to_page(pfn);
@@ -3798,7 +3796,7 @@ static void setup_zone_migrate_reserve(s
 	 * the block.
 	 */
 	start_pfn = zone->zone_start_pfn;
-	end_pfn = start_pfn + zone->spanned_pages;
+	end_pfn = zone_end_pfn(zone);
 	start_pfn = roundup(start_pfn, pageblock_nr_pages);
 	reserve = roundup(min_wmark_pages(zone), pageblock_nr_pages) >>
 							pageblock_order;
@@ -3912,7 +3910,7 @@ void __meminit memmap_init_zone(unsigned
 		 * pfn out of zone.
 		 */
 		if ((z->zone_start_pfn <= pfn)
-		    && (pfn < z->zone_start_pfn + z->spanned_pages)
+		    && (pfn < zone_end_pfn(z))
 		    && !(pfn & (pageblock_nr_pages - 1)))
 			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
 
@@ -4713,7 +4711,7 @@ static void __init_refok alloc_node_mem_
 		 * for the buddy allocator to function correctly.
 		 */
 		start = pgdat->node_start_pfn & ~(MAX_ORDER_NR_PAGES - 1);
-		end = pgdat->node_start_pfn + pgdat->node_spanned_pages;
+		end = pgdat_end_pfn(pgdat);
 		end = ALIGN(end, MAX_ORDER_NR_PAGES);
 		size =  (end - start) * sizeof(struct page);
 		map = alloc_remap(pgdat->node_id, size);
@@ -5928,8 +5926,7 @@ void set_pageblock_flags_group(struct pa
 	pfn = page_to_pfn(page);
 	bitmap = get_pageblock_bitmap(zone, pfn);
 	bitidx = pfn_to_bitidx(zone, pfn);
-	VM_BUG_ON(pfn < zone->zone_start_pfn);
-	VM_BUG_ON(pfn >= zone->zone_start_pfn + zone->spanned_pages);
+	VM_BUG_ON(!zone_spans_pfn(zone, pfn));
 
 	for (; start_bitidx <= end_bitidx; start_bitidx++, value <<= 1)
 		if (flags & value)
@@ -6027,8 +6024,7 @@ bool is_pageblock_removable_nolock(struc
 
 	zone = page_zone(page);
 	pfn = page_to_pfn(page);
-	if (zone->zone_start_pfn > pfn ||
-			zone->zone_start_pfn + zone->spanned_pages <= pfn)
+	if (!zone_spans_pfn(zone, pfn))
 		return false;
 
 	return !has_unmovable_pages(zone, page, 0, true);
diff -puN mm/vmstat.c~mm-add-use-zone_end_pfn-and-zone_spans_pfn mm/vmstat.c
--- a/mm/vmstat.c~mm-add-use-zone_end_pfn-and-zone_spans_pfn
+++ a/mm/vmstat.c
@@ -891,7 +891,7 @@ static void pagetypeinfo_showblockcount_
 	int mtype;
 	unsigned long pfn;
 	unsigned long start_pfn = zone->zone_start_pfn;
-	unsigned long end_pfn = start_pfn + zone->spanned_pages;
+	unsigned long end_pfn = zone_end_pfn(zone);
 	unsigned long count[MIGRATE_TYPES] = { 0, };
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages) {
_

Patches currently in -mm which might be from cody@linux.vnet.ibm.com are

origin.patch

