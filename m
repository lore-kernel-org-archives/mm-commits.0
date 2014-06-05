From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-use-unsigned-int-for-order-in-more-places.patch removed from
 -mm tree
Date: Thu, 05 Jun 2014 12:52:37 -0700
Message-ID: <5390ca85.jgMtu0EQgrRNxDsc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56425 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaFETwi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:52:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, tytso@mit.edu, riel@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com, oleg@redhat.com, mhocko@suse.cz, jack@suse.cz, hughd@google.com, hannes@cmpxchg.org, dave.hansen@intel.com, mgorman@suse.de

Subject: [merged] mm-page_alloc-use-unsigned-int-for-order-in-more-places.patch removed from -mm tree
To: mgorman@suse.de,dave.hansen@intel.com,hannes@cmpxchg.org,hughd@google.com,jack@suse.cz,mhocko@suse.cz,oleg@redhat.com,paulmck@linux.vnet.ibm.com,peterz@infradead.org,riel@redhat.com,tytso@mit.edu,vbabka@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:52:37 -0700


The patch titled
     Subject: mm: page_alloc: use unsigned int for order in more places
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-use-unsigned-int-for-order-in-more-places.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: page_alloc: use unsigned int for order in more places

X86 prefers the use of unsigned types for iterators and there is a
tendency to mix whether a signed or unsigned type if used for page order. 
This converts a number of sites in mm/page_alloc.c to use unsigned int for
order where possible.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
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

 include/linux/mmzone.h |    8 +++----
 mm/page_alloc.c        |   43 ++++++++++++++++++++-------------------
 2 files changed, 27 insertions(+), 24 deletions(-)

diff -puN include/linux/mmzone.h~mm-page_alloc-use-unsigned-int-for-order-in-more-places include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-page_alloc-use-unsigned-int-for-order-in-more-places
+++ a/include/linux/mmzone.h
@@ -817,10 +817,10 @@ static inline bool pgdat_is_empty(pg_dat
 extern struct mutex zonelists_mutex;
 void build_all_zonelists(pg_data_t *pgdat, struct zone *zone);
 void wakeup_kswapd(struct zone *zone, int order, enum zone_type classzone_idx);
-bool zone_watermark_ok(struct zone *z, int order, unsigned long mark,
-		int classzone_idx, int alloc_flags);
-bool zone_watermark_ok_safe(struct zone *z, int order, unsigned long mark,
-		int classzone_idx, int alloc_flags);
+bool zone_watermark_ok(struct zone *z, unsigned int order,
+		unsigned long mark, int classzone_idx, int alloc_flags);
+bool zone_watermark_ok_safe(struct zone *z, unsigned int order,
+		unsigned long mark, int classzone_idx, int alloc_flags);
 enum memmap_context {
 	MEMMAP_EARLY,
 	MEMMAP_HOTPLUG,
diff -puN mm/page_alloc.c~mm-page_alloc-use-unsigned-int-for-order-in-more-places mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-use-unsigned-int-for-order-in-more-places
+++ a/mm/page_alloc.c
@@ -409,7 +409,8 @@ static int destroy_compound_page(struct
 	return bad;
 }
 
-static inline void prep_zero_page(struct page *page, int order, gfp_t gfp_flags)
+static inline void prep_zero_page(struct page *page, unsigned int order,
+							gfp_t gfp_flags)
 {
 	int i;
 
@@ -453,7 +454,7 @@ static inline void set_page_guard_flag(s
 static inline void clear_page_guard_flag(struct page *page) { }
 #endif
 
-static inline void set_page_order(struct page *page, int order)
+static inline void set_page_order(struct page *page, unsigned int order)
 {
 	set_page_private(page, order);
 	__SetPageBuddy(page);
@@ -504,7 +505,7 @@ __find_buddy_index(unsigned long page_id
  * For recording page's order, we use page_private(page).
  */
 static inline int page_is_buddy(struct page *page, struct page *buddy,
-								int order)
+							unsigned int order)
 {
 	if (!pfn_valid_within(page_to_pfn(buddy)))
 		return 0;
@@ -726,7 +727,7 @@ static void free_pcppages_bulk(struct zo
 
 static void free_one_page(struct zone *zone,
 				struct page *page, unsigned long pfn,
-				int order,
+				unsigned int order,
 				int migratetype)
 {
 	spin_lock(&zone->lock);
@@ -897,7 +898,7 @@ static inline int check_new_page(struct
 	return 0;
 }
 
-static int prep_new_page(struct page *page, int order, gfp_t gfp_flags)
+static int prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags)
 {
 	int i;
 
@@ -1108,16 +1109,17 @@ static int try_to_steal_freepages(struct
 
 /* Remove an element from the buddy allocator from the fallback list */
 static inline struct page *
-__rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
+__rmqueue_fallback(struct zone *zone, unsigned int order, int start_migratetype)
 {
 	struct free_area *area;
-	int current_order;
+	unsigned int current_order;
 	struct page *page;
 	int migratetype, new_type, i;
 
 	/* Find the largest possible block of pages in the other list */
-	for (current_order = MAX_ORDER-1; current_order >= order;
-						--current_order) {
+	for (current_order = MAX_ORDER-1;
+				current_order >= order && current_order <= MAX_ORDER-1;
+				--current_order) {
 		for (i = 0;; i++) {
 			migratetype = fallbacks[start_migratetype][i];
 
@@ -1345,7 +1347,7 @@ void mark_free_pages(struct zone *zone)
 {
 	unsigned long pfn, max_zone_pfn;
 	unsigned long flags;
-	int order, t;
+	unsigned int order, t;
 	struct list_head *curr;
 
 	if (zone_is_empty(zone))
@@ -1541,8 +1543,8 @@ int split_free_page(struct page *page)
  */
 static inline
 struct page *buffered_rmqueue(struct zone *preferred_zone,
-			struct zone *zone, int order, gfp_t gfp_flags,
-			int migratetype)
+			struct zone *zone, unsigned int order,
+			gfp_t gfp_flags, int migratetype)
 {
 	unsigned long flags;
 	struct page *page;
@@ -1691,8 +1693,9 @@ static inline bool should_fail_alloc_pag
  * Return true if free pages are above 'mark'. This takes into account the order
  * of the allocation.
  */
-static bool __zone_watermark_ok(struct zone *z, int order, unsigned long mark,
-		      int classzone_idx, int alloc_flags, long free_pages)
+static bool __zone_watermark_ok(struct zone *z, unsigned int order,
+			unsigned long mark, int classzone_idx, int alloc_flags,
+			long free_pages)
 {
 	/* free_pages my go negative - that's OK */
 	long min = mark;
@@ -1726,15 +1729,15 @@ static bool __zone_watermark_ok(struct z
 	return true;
 }
 
-bool zone_watermark_ok(struct zone *z, int order, unsigned long mark,
+bool zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
 		      int classzone_idx, int alloc_flags)
 {
 	return __zone_watermark_ok(z, order, mark, classzone_idx, alloc_flags,
 					zone_page_state(z, NR_FREE_PAGES));
 }
 
-bool zone_watermark_ok_safe(struct zone *z, int order, unsigned long mark,
-		      int classzone_idx, int alloc_flags)
+bool zone_watermark_ok_safe(struct zone *z, unsigned int order,
+			unsigned long mark, int classzone_idx, int alloc_flags)
 {
 	long free_pages = zone_page_state(z, NR_FREE_PAGES);
 
@@ -4121,7 +4124,7 @@ void __meminit memmap_init_zone(unsigned
 
 static void __meminit zone_init_free_lists(struct zone *zone)
 {
-	int order, t;
+	unsigned int order, t;
 	for_each_migratetype_order(order, t) {
 		INIT_LIST_HEAD(&zone->free_area[order].free_list[t]);
 		zone->free_area[order].nr_free = 0;
@@ -6444,7 +6447,7 @@ __offline_isolated_pages(unsigned long s
 {
 	struct page *page;
 	struct zone *zone;
-	int order, i;
+	unsigned int order, i;
 	unsigned long pfn;
 	unsigned long flags;
 	/* find the first valid pfn */
@@ -6496,7 +6499,7 @@ bool is_free_buddy_page(struct page *pag
 	struct zone *zone = page_zone(page);
 	unsigned long pfn = page_to_pfn(page);
 	unsigned long flags;
-	int order;
+	unsigned int order;
 
 	spin_lock_irqsave(&zone->lock, flags);
 	for (order = 0; order < MAX_ORDER; order++) {
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

