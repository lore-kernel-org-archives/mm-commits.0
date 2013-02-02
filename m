From: akpm@linux-foundation.org
Subject: + mm-add-use-zone_end_pfn-and-zone_spans_pfn.patch added to -mm tree
Date: Fri, 01 Feb 2013 16:39:43 -0800
Message-ID: <20130202003944.49FA931C1FA@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:63929 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660Ab3BBAjp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2013 19:39:45 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so266165vea.0
        for <mm-commits@vger.kernel.org>; Fri, 01 Feb 2013 16:39:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cody@linux.vnet.ibm.com, catalin.marinas@arm.com, dave@linux.vnet.ibm.com, hannes@cmpxchg.org, mel@csn.ul.ie


The patch titled
     Subject: mm: add & use zone_end_pfn() and zone_spans_pfn()
has been added to the -mm tree.  Its filename is
     mm-add-use-zone_end_pfn-and-zone_spans_pfn.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -249,9 +249,7 @@ static int page_outside_zone_boundaries(
 
 	do {
 		seq = zone_span_seqbegin(zone);
-		if (pfn >= zone->zone_start_pfn + zone->spanned_pages)
-			ret = 1;
-		else if (pfn < zone->zone_start_pfn)
+		if (!zone_spans_pfn(zone, pfn))
 			ret = 1;
 	} while (zone_span_seqretry(zone, seq));
 
@@ -985,9 +983,9 @@ int move_freepages_block(struct zone *zo
 	end_pfn = start_pfn + pageblock_nr_pages - 1;
 
 	/* Do not cross zone boundaries */
-	if (start_pfn < zone->zone_start_pfn)
+	if (!zone_spans_pfn(zone, start_pfn))
 		start_page = page;
-	if (end_pfn >= zone->zone_start_pfn + zone->spanned_pages)
+	if (!zone_spans_pfn(zone, end_pfn))
 		return 0;
 
 	return move_freepages(zone, start_page, end_page, migratetype);
@@ -1281,7 +1279,7 @@ void mark_free_pages(struct zone *zone)
 
 	spin_lock_irqsave(&zone->lock, flags);
 
-	max_zone_pfn = zone->zone_start_pfn + zone->spanned_pages;
+	max_zone_pfn = zone_end_pfn(zone);
 	for (pfn = zone->zone_start_pfn; pfn < max_zone_pfn; pfn++)
 		if (pfn_valid(pfn)) {
 			struct page *page = pfn_to_page(pfn);
@@ -3793,7 +3791,7 @@ static void setup_zone_migrate_reserve(s
 	 * the block.
 	 */
 	start_pfn = zone->zone_start_pfn;
-	end_pfn = start_pfn + zone->spanned_pages;
+	end_pfn = zone_end_pfn(zone);
 	start_pfn = roundup(start_pfn, pageblock_nr_pages);
 	reserve = roundup(min_wmark_pages(zone), pageblock_nr_pages) >>
 							pageblock_order;
@@ -3910,7 +3908,7 @@ void __meminit memmap_init_zone(unsigned
 		 * pfn out of zone.
 		 */
 		if ((z->zone_start_pfn <= pfn)
-		    && (pfn < z->zone_start_pfn + z->spanned_pages)
+		    && (pfn < zone_end_pfn(z))
 		    && !(pfn & (pageblock_nr_pages - 1)))
 			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
 
@@ -4708,7 +4706,7 @@ static void __init_refok alloc_node_mem_
 		 * for the buddy allocator to function correctly.
 		 */
 		start = pgdat->node_start_pfn & ~(MAX_ORDER_NR_PAGES - 1);
-		end = pgdat->node_start_pfn + pgdat->node_spanned_pages;
+		end = pgdat_end_pfn(pgdat);
 		end = ALIGN(end, MAX_ORDER_NR_PAGES);
 		size =  (end - start) * sizeof(struct page);
 		map = alloc_remap(pgdat->node_id, size);
@@ -5923,8 +5921,7 @@ void set_pageblock_flags_group(struct pa
 	pfn = page_to_pfn(page);
 	bitmap = get_pageblock_bitmap(zone, pfn);
 	bitidx = pfn_to_bitidx(zone, pfn);
-	VM_BUG_ON(pfn < zone->zone_start_pfn);
-	VM_BUG_ON(pfn >= zone->zone_start_pfn + zone->spanned_pages);
+	VM_BUG_ON(!zone_spans_pfn(zone, pfn));
 
 	for (; start_bitidx <= end_bitidx; start_bitidx++, value <<= 1)
 		if (flags & value)
@@ -6022,8 +6019,7 @@ bool is_pageblock_removable_nolock(struc
 
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

linux-next.patch
mm-add-section_in_page_flags.patch
mm-add-use-zone_end_pfn-and-zone_spans_pfn.patch
mm-add-zone_is_empty-and-zone_is_initialized.patch
mm-page_alloc-add-a-vm_bug-in-__free_one_page-if-the-zone-is-uninitialized.patch
mmzone-add-pgdat_end_pfnis_empty-helpers-consolidate.patch
mm-page_alloc-add-informative-debugging-message-in-page_outside_zone_boundaries.patch
mm-page_alloc-add-informative-debugging-message-in-page_outside_zone_boundaries-fix.patch
mm-add-helper-ensure_zone_is_initialized.patch
mm-memory_hotplug-use-ensure_zone_is_initialized.patch
mm-memory_hotplug-use-pgdat_end_pfn-instead-of-open-coding-the-same.patch
maintainers-mm-add-additional-include-files-to-listing.patch

