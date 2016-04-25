From: akpm@linux-foundation.org
Subject: [withdrawn]
 mm-compaction-direct-freepage-allocation-for-async-direct-compaction.patch
 removed from -mm tree
Date: Mon, 25 Apr 2016 13:05:20 -0700
Message-ID: <571e7880.oJ7j4tdU3OIZjIAs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55201 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933160AbcDYUFW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Apr 2016 16:05:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: direct freepage allocation for async direct compaction
has been removed from the -mm tree.  Its filename was
     mm-compaction-direct-freepage-allocation-for-async-direct-compaction.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: direct freepage allocation for async direct compaction

The goal of direct compaction is to quickly make a high-order page
available for the pending allocation.  The free page scanner can add
significant latency when searching for migration targets, although to
succeed the compaction, the only important limit on the target free pages
is that they must not come from the same order-aligned block as the
migrated pages.

This patch therefore makes direct async compaction allocate freepages
directly from freelists.  Pages that do come from the same block (which we
cannot simply exclude from the freelist allocation) are put on separate
list and released only after migration to allow them to merge.

In addition to reduced stall, another advantage is that we split larger
free pages for migration targets only when smaller pages are depleted,
while the free scanner can split pages up to (order - 1) as it encouters
them.  However, this approach likely sacrifices some of the long-term
anti-fragmentation features of a thorough compaction, so we limit the
direct allocation approach to direct async compaction.

For observational purposes, the patch introduces two new counters to
/proc/vmstat.  compact_free_direct_alloc counts how many pages were
allocated directly without scanning, and compact_free_direct_miss counts
the subset of these allocations that were from the wrong range and had to
be held on the separate list.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vm_event_item.h |    1 
 mm/compaction.c               |   52 +++++++++++++++++++++++++++++++-
 mm/internal.h                 |    5 +++
 mm/page_alloc.c               |   27 ++++++++++++++++
 mm/vmstat.c                   |    2 +
 5 files changed, 86 insertions(+), 1 deletion(-)

diff -puN include/linux/vm_event_item.h~mm-compaction-direct-freepage-allocation-for-async-direct-compaction include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~mm-compaction-direct-freepage-allocation-for-async-direct-compaction
+++ a/include/linux/vm_event_item.h
@@ -51,6 +51,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 #endif
 #ifdef CONFIG_COMPACTION
 		COMPACTMIGRATE_SCANNED, COMPACTFREE_SCANNED,
+		COMPACTFREE_DIRECT_ALLOC, COMPACTFREE_DIRECT_MISS,
 		COMPACTISOLATED,
 		COMPACTSTALL, COMPACTFAIL, COMPACTSUCCESS,
 		KCOMPACTD_WAKE,
diff -puN mm/compaction.c~mm-compaction-direct-freepage-allocation-for-async-direct-compaction mm/compaction.c
--- a/mm/compaction.c~mm-compaction-direct-freepage-allocation-for-async-direct-compaction
+++ a/mm/compaction.c
@@ -1083,6 +1083,41 @@ static void isolate_freepages(struct com
 	cc->free_pfn = isolate_start_pfn;
 }
 
+static void isolate_freepages_direct(struct compact_control *cc)
+{
+	unsigned long nr_pages;
+	unsigned long flags;
+
+	nr_pages = cc->nr_migratepages - cc->nr_freepages;
+
+	if (!compact_trylock_irqsave(&cc->zone->lock, &flags, cc))
+		return;
+
+	while (nr_pages) {
+		struct page *page;
+		unsigned long pfn;
+
+		page = alloc_pages_zone(cc->zone, 0, MIGRATE_MOVABLE);
+		if (!page)
+			break;
+		pfn = page_to_pfn(page);
+
+		count_compact_event(COMPACTFREE_DIRECT_ALLOC);
+
+		/* Is the free page in the block we are migrating from? */
+		if (pfn >> cc->order ==	(cc->migrate_pfn - 1) >> cc->order) {
+			list_add(&page->lru, &cc->freepages_held);
+			count_compact_event(COMPACTFREE_DIRECT_MISS);
+		} else {
+			list_add(&page->lru, &cc->freepages);
+			cc->nr_freepages++;
+			nr_pages--;
+		}
+	}
+
+	spin_unlock_irqrestore(&cc->zone->lock, flags);
+}
+
 /*
  * This is a migrate-callback that "allocates" freepages by taking pages
  * from the isolated freelists in the block we are migrating to.
@@ -1099,7 +1134,12 @@ static struct page *compaction_alloc(str
 	 * contention.
 	 */
 	if (list_empty(&cc->freepages)) {
-		if (!cc->contended)
+		if (cc->contended)
+			return NULL;
+
+		if (cc->direct_compaction && (cc->mode == MIGRATE_ASYNC))
+			isolate_freepages_direct(cc);
+		else
 			isolate_freepages(cc);
 
 		if (list_empty(&cc->freepages))
@@ -1475,6 +1515,10 @@ static int compact_zone(struct zone *zon
 						(cc->mode == MIGRATE_ASYNC)) {
 				cc->migrate_pfn = block_end_pfn(
 						cc->migrate_pfn - 1, cc->order);
+
+				if (!list_empty(&cc->freepages_held))
+					release_freepages(&cc->freepages_held);
+
 				/* Draining pcplists is useless in this case */
 				cc->last_migrated_pfn = 0;
 
@@ -1495,6 +1539,8 @@ check_drain:
 				block_start_pfn(cc->migrate_pfn, cc->order);
 
 			if (cc->last_migrated_pfn < current_block_start) {
+				if (!list_empty(&cc->freepages_held))
+					release_freepages(&cc->freepages_held);
 				cpu = get_cpu();
 				lru_add_drain_cpu(cpu);
 				drain_local_pages(zone);
@@ -1525,6 +1571,8 @@ out:
 		if (free_pfn > zone->compact_cached_free_pfn)
 			zone->compact_cached_free_pfn = free_pfn;
 	}
+	if (!list_empty(&cc->freepages_held))
+		release_freepages(&cc->freepages_held);
 
 	trace_mm_compaction_end(start_pfn, cc->migrate_pfn,
 				cc->free_pfn, end_pfn, sync, ret);
@@ -1553,6 +1601,7 @@ static unsigned long compact_zone_order(
 	};
 	INIT_LIST_HEAD(&cc.freepages);
 	INIT_LIST_HEAD(&cc.migratepages);
+	INIT_LIST_HEAD(&cc.freepages_held);
 
 	ret = compact_zone(zone, &cc);
 
@@ -1698,6 +1747,7 @@ static void __compact_pgdat(pg_data_t *p
 		cc->zone = zone;
 		INIT_LIST_HEAD(&cc->freepages);
 		INIT_LIST_HEAD(&cc->migratepages);
+		INIT_LIST_HEAD(&cc->freepages_held);
 
 		/*
 		 * When called via /proc/sys/vm/compact_memory
diff -puN mm/internal.h~mm-compaction-direct-freepage-allocation-for-async-direct-compaction mm/internal.h
--- a/mm/internal.h~mm-compaction-direct-freepage-allocation-for-async-direct-compaction
+++ a/mm/internal.h
@@ -145,6 +145,8 @@ static inline struct page *pageblock_pfn
 }
 
 extern int __isolate_free_page(struct page *page, unsigned int order);
+extern struct page *alloc_pages_zone(struct zone *zone, unsigned int order,
+							int migratetype);
 extern void __free_pages_bootmem(struct page *page, unsigned long pfn,
 					unsigned int order);
 extern void prep_compound_page(struct page *page, unsigned int order);
@@ -165,6 +167,9 @@ extern int user_min_free_kbytes;
 struct compact_control {
 	struct list_head freepages;	/* List of free pages to migrate to */
 	struct list_head migratepages;	/* List of pages being migrated */
+	struct list_head freepages_held;/* List of free pages from the block
+					 * that's being migrated
+					 */
 	unsigned long nr_freepages;	/* Number of isolated free pages */
 	unsigned long nr_migratepages;	/* Number of pages to migrate */
 	unsigned long free_pfn;		/* isolate_freepages search base */
diff -puN mm/page_alloc.c~mm-compaction-direct-freepage-allocation-for-async-direct-compaction mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-direct-freepage-allocation-for-async-direct-compaction
+++ a/mm/page_alloc.c
@@ -2342,6 +2342,33 @@ int split_free_page(struct page *page)
 }
 
 /*
+ * Like split_free_page, but given the zone, it will grab a free page from
+ * the freelists.
+ */
+struct page *
+alloc_pages_zone(struct zone *zone, unsigned int order, int migratetype)
+{
+	struct page *page;
+	unsigned long watermark;
+
+	watermark = low_wmark_pages(zone) + (1 << order);
+	if (!zone_watermark_ok(zone, 0, watermark, 0, 0))
+		return NULL;
+
+	page = __rmqueue(zone, order, migratetype);
+	if (!page)
+		return NULL;
+
+	__mod_zone_freepage_state(zone, -(1 << order),
+					  get_pcppage_migratetype(page));
+
+	set_page_owner(page, order, __GFP_MOVABLE);
+	set_page_refcounted(page);
+
+	return page;
+}
+
+/*
  * Allocate a page from the given zone. Use pcplists for order-0 allocations.
  */
 static inline
diff -puN mm/vmstat.c~mm-compaction-direct-freepage-allocation-for-async-direct-compaction mm/vmstat.c
--- a/mm/vmstat.c~mm-compaction-direct-freepage-allocation-for-async-direct-compaction
+++ a/mm/vmstat.c
@@ -822,6 +822,8 @@ const char * const vmstat_text[] = {
 #ifdef CONFIG_COMPACTION
 	"compact_migrate_scanned",
 	"compact_free_scanned",
+	"compact_free_direct_alloc",
+	"compact_free_direct_miss",
 	"compact_isolated",
 	"compact_stall",
 	"compact_fail",
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-wake-kcompactd-before-kswapds-short-sleep.patch
mm-compaction-wrap-calculating-first-and-last-pfn-of-pageblock.patch
mm-compaction-reduce-spurious-pcplist-drains.patch
mm-compaction-skip-blocks-where-isolation-fails-in-async-direct-compaction.patch
cpuset-use-static-key-better-and-convert-to-new-api.patch

