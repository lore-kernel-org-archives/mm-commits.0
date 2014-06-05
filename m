From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-reduce-number-of-times-page_to_pfn-is-called.patch removed
 from -mm tree
Date: Thu, 05 Jun 2014 12:52:33 -0700
Message-ID: <5390ca81./WJ718hXErz9A+m6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56403 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaFETwe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:52:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, tytso@mit.edu, riel@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com, oleg@redhat.com, mhocko@suse.cz, jack@suse.cz, hughd@google.com, hannes@cmpxchg.org, dave.hansen@intel.com, mgorman@suse.de

Subject: [merged] mm-page_alloc-reduce-number-of-times-page_to_pfn-is-called.patch removed from -mm tree
To: mgorman@suse.de,dave.hansen@intel.com,hannes@cmpxchg.org,hughd@google.com,jack@suse.cz,mhocko@suse.cz,oleg@redhat.com,paulmck@linux.vnet.ibm.com,peterz@infradead.org,riel@redhat.com,tytso@mit.edu,vbabka@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:52:33 -0700


The patch titled
     Subject: mm: page_alloc: reduce number of times page_to_pfn is called
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-reduce-number-of-times-page_to_pfn-is-called.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: page_alloc: reduce number of times page_to_pfn is called

In the free path we calculate page_to_pfn multiple times. Reduce that.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h          |    9 ++++++-
 include/linux/pageblock-flags.h |   33 +++++++++++------------------
 mm/page_alloc.c                 |   34 ++++++++++++++++--------------
 3 files changed, 39 insertions(+), 37 deletions(-)

diff -puN include/linux/mmzone.h~mm-page_alloc-reduce-number-of-times-page_to_pfn-is-called include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-page_alloc-reduce-number-of-times-page_to_pfn-is-called
+++ a/include/linux/mmzone.h
@@ -78,10 +78,15 @@ extern int page_group_by_mobility_disabl
 #define NR_MIGRATETYPE_BITS (PB_migrate_end - PB_migrate + 1)
 #define MIGRATETYPE_MASK ((1UL << NR_MIGRATETYPE_BITS) - 1)
 
-static inline int get_pageblock_migratetype(struct page *page)
+#define get_pageblock_migratetype(page)					\
+	get_pfnblock_flags_mask(page, page_to_pfn(page),		\
+			PB_migrate_end, MIGRATETYPE_MASK)
+
+static inline int get_pfnblock_migratetype(struct page *page, unsigned long pfn)
 {
 	BUILD_BUG_ON(PB_migrate_end - PB_migrate != 2);
-	return get_pageblock_flags_mask(page, PB_migrate_end, MIGRATETYPE_MASK);
+	return get_pfnblock_flags_mask(page, pfn, PB_migrate_end,
+					MIGRATETYPE_MASK);
 }
 
 struct free_area {
diff -puN include/linux/pageblock-flags.h~mm-page_alloc-reduce-number-of-times-page_to_pfn-is-called include/linux/pageblock-flags.h
--- a/include/linux/pageblock-flags.h~mm-page_alloc-reduce-number-of-times-page_to_pfn-is-called
+++ a/include/linux/pageblock-flags.h
@@ -65,33 +65,26 @@ extern int pageblock_order;
 /* Forward declaration */
 struct page;
 
-unsigned long get_pageblock_flags_mask(struct page *page,
+unsigned long get_pfnblock_flags_mask(struct page *page,
+				unsigned long pfn,
 				unsigned long end_bitidx,
 				unsigned long mask);
-void set_pageblock_flags_mask(struct page *page,
+
+void set_pfnblock_flags_mask(struct page *page,
 				unsigned long flags,
+				unsigned long pfn,
 				unsigned long end_bitidx,
 				unsigned long mask);
 
 /* Declarations for getting and setting flags. See mm/page_alloc.c */
-static inline unsigned long get_pageblock_flags_group(struct page *page,
-					int start_bitidx, int end_bitidx)
-{
-	unsigned long nr_flag_bits = end_bitidx - start_bitidx + 1;
-	unsigned long mask = (1 << nr_flag_bits) - 1;
-
-	return get_pageblock_flags_mask(page, end_bitidx, mask);
-}
-
-static inline void set_pageblock_flags_group(struct page *page,
-					unsigned long flags,
-					int start_bitidx, int end_bitidx)
-{
-	unsigned long nr_flag_bits = end_bitidx - start_bitidx + 1;
-	unsigned long mask = (1 << nr_flag_bits) - 1;
-
-	set_pageblock_flags_mask(page, flags, end_bitidx, mask);
-}
+#define get_pageblock_flags_group(page, start_bitidx, end_bitidx) \
+	get_pfnblock_flags_mask(page, page_to_pfn(page),		\
+			end_bitidx,					\
+			(1 << (end_bitidx - start_bitidx + 1)) - 1)
+#define set_pageblock_flags_group(page, flags, start_bitidx, end_bitidx) \
+	set_pfnblock_flags_mask(page, flags, page_to_pfn(page),		\
+			end_bitidx,					\
+			(1 << (end_bitidx - start_bitidx + 1)) - 1)
 
 #ifdef CONFIG_COMPACTION
 #define get_pageblock_skip(page) \
diff -puN mm/page_alloc.c~mm-page_alloc-reduce-number-of-times-page_to_pfn-is-called mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-reduce-number-of-times-page_to_pfn-is-called
+++ a/mm/page_alloc.c
@@ -560,6 +560,7 @@ static inline int page_is_buddy(struct p
  */
 
 static inline void __free_one_page(struct page *page,
+		unsigned long pfn,
 		struct zone *zone, unsigned int order,
 		int migratetype)
 {
@@ -576,7 +577,7 @@ static inline void __free_one_page(struc
 
 	VM_BUG_ON(migratetype == -1);
 
-	page_idx = page_to_pfn(page) & ((1 << MAX_ORDER) - 1);
+	page_idx = pfn & ((1 << MAX_ORDER) - 1);
 
 	VM_BUG_ON_PAGE(page_idx & ((1 << order) - 1), page);
 	VM_BUG_ON_PAGE(bad_range(zone, page), page);
@@ -711,7 +712,7 @@ static void free_pcppages_bulk(struct zo
 			list_del(&page->lru);
 			mt = get_freepage_migratetype(page);
 			/* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
-			__free_one_page(page, zone, 0, mt);
+			__free_one_page(page, page_to_pfn(page), zone, 0, mt);
 			trace_mm_page_pcpu_drain(page, 0, mt);
 			if (likely(!is_migrate_isolate_page(page))) {
 				__mod_zone_page_state(zone, NR_FREE_PAGES, 1);
@@ -723,13 +724,15 @@ static void free_pcppages_bulk(struct zo
 	spin_unlock(&zone->lock);
 }
 
-static void free_one_page(struct zone *zone, struct page *page, int order,
+static void free_one_page(struct zone *zone,
+				struct page *page, unsigned long pfn,
+				int order,
 				int migratetype)
 {
 	spin_lock(&zone->lock);
 	zone->pages_scanned = 0;
 
-	__free_one_page(page, zone, order, migratetype);
+	__free_one_page(page, pfn, zone, order, migratetype);
 	if (unlikely(!is_migrate_isolate(migratetype)))
 		__mod_zone_freepage_state(zone, 1 << order, migratetype);
 	spin_unlock(&zone->lock);
@@ -766,15 +769,16 @@ static void __free_pages_ok(struct page
 {
 	unsigned long flags;
 	int migratetype;
+	unsigned long pfn = page_to_pfn(page);
 
 	if (!free_pages_prepare(page, order))
 		return;
 
 	local_irq_save(flags);
 	__count_vm_events(PGFREE, 1 << order);
-	migratetype = get_pageblock_migratetype(page);
+	migratetype = get_pfnblock_migratetype(page, pfn);
 	set_freepage_migratetype(page, migratetype);
-	free_one_page(page_zone(page), page, order, migratetype);
+	free_one_page(page_zone(page), page, pfn, order, migratetype);
 	local_irq_restore(flags);
 }
 
@@ -1380,12 +1384,13 @@ void free_hot_cold_page(struct page *pag
 	struct zone *zone = page_zone(page);
 	struct per_cpu_pages *pcp;
 	unsigned long flags;
+	unsigned long pfn = page_to_pfn(page);
 	int migratetype;
 
 	if (!free_pages_prepare(page, 0))
 		return;
 
-	migratetype = get_pageblock_migratetype(page);
+	migratetype = get_pfnblock_migratetype(page, pfn);
 	set_freepage_migratetype(page, migratetype);
 	local_irq_save(flags);
 	__count_vm_event(PGFREE);
@@ -1399,7 +1404,7 @@ void free_hot_cold_page(struct page *pag
 	 */
 	if (migratetype >= MIGRATE_PCPTYPES) {
 		if (unlikely(is_migrate_isolate(migratetype))) {
-			free_one_page(zone, page, 0, migratetype);
+			free_one_page(zone, page, pfn, 0, migratetype);
 			goto out;
 		}
 		migratetype = MIGRATE_MOVABLE;
@@ -6028,17 +6033,16 @@ static inline int pfn_to_bitidx(struct z
  * @end_bitidx: The last bit of interest
  * returns pageblock_bits flags
  */
-unsigned long get_pageblock_flags_mask(struct page *page,
+unsigned long get_pfnblock_flags_mask(struct page *page, unsigned long pfn,
 					unsigned long end_bitidx,
 					unsigned long mask)
 {
 	struct zone *zone;
 	unsigned long *bitmap;
-	unsigned long pfn, bitidx, word_bitidx;
+	unsigned long bitidx, word_bitidx;
 	unsigned long word;
 
 	zone = page_zone(page);
-	pfn = page_to_pfn(page);
 	bitmap = get_pageblock_bitmap(zone, pfn);
 	bitidx = pfn_to_bitidx(zone, pfn);
 	word_bitidx = bitidx / BITS_PER_LONG;
@@ -6050,25 +6054,25 @@ unsigned long get_pageblock_flags_mask(s
 }
 
 /**
- * set_pageblock_flags_mask - Set the requested group of flags for a pageblock_nr_pages block of pages
+ * set_pfnblock_flags_mask - Set the requested group of flags for a pageblock_nr_pages block of pages
  * @page: The page within the block of interest
  * @start_bitidx: The first bit of interest
  * @end_bitidx: The last bit of interest
  * @flags: The flags to set
  */
-void set_pageblock_flags_mask(struct page *page, unsigned long flags,
+void set_pfnblock_flags_mask(struct page *page, unsigned long flags,
+					unsigned long pfn,
 					unsigned long end_bitidx,
 					unsigned long mask)
 {
 	struct zone *zone;
 	unsigned long *bitmap;
-	unsigned long pfn, bitidx, word_bitidx;
+	unsigned long bitidx, word_bitidx;
 	unsigned long old_word, word;
 
 	BUILD_BUG_ON(NR_PAGEBLOCK_BITS != 4);
 
 	zone = page_zone(page);
-	pfn = page_to_pfn(page);
 	bitmap = get_pageblock_bitmap(zone, pfn);
 	bitidx = pfn_to_bitidx(zone, pfn);
 	word_bitidx = bitidx / BITS_PER_LONG;
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-v5.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
linux-next.patch

