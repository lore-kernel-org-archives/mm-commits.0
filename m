From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous.patch
 removed from -mm tree
Date: Wed, 16 Mar 2016 12:57:19 -0700
Message-ID: <56e9ba9f.00gVsP20FsFko0y6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39130 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934390AbcCPT5U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:57:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, aaron.lu@intel.com, mgorman@suse.de, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: speed up pageblock_pfn_to_page() when zone is contiguous
has been removed from the -mm tree.  Its filename was
     mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/compaction: speed up pageblock_pfn_to_page() when zone is contiguous

There is a performance drop report due to hugepage allocation and in there
half of cpu time are spent on pageblock_pfn_to_page() in compaction [1].
In that workload, compaction is triggered to make hugepage but most of
pageblocks are un-available for compaction due to pageblock type and
skip bit so compaction usually fails. Most costly operations in this case
is to find valid pageblock while scanning whole zone range. To check
if pageblock is valid to compact, valid pfn within pageblock is required
and we can obtain it by calling pageblock_pfn_to_page(). This function
checks whether pageblock is in a single zone and return valid pfn
if possible. Problem is that we need to check it every time before
scanning pageblock even if we re-visit it and this turns out to
be very expensive in this workload.

Although we have no way to skip this pageblock check in the system
where hole exists at arbitrary position, we can use cached value for
zone continuity and just do pfn_to_page() in the system where hole doesn't
exist. This optimization considerably speeds up in above workload.

Before vs After
Max: 1096 MB/s vs 1325 MB/s
Min: 635 MB/s 1015 MB/s
Avg: 899 MB/s 1194 MB/s

Avg is improved by roughly 30% [2].

[1]: http://www.spinics.net/lists/linux-mm/msg97378.html
[2]: https://lkml.org/lkml/2015/12/9/23

[akpm@linux-foundation.org: don't forget to restore zone->contiguous on error path, per Vlastimil]
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reported-by: Aaron Lu <aaron.lu@intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Aaron Lu <aaron.lu@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h            |    6 --
 include/linux/memory_hotplug.h |    3 +
 include/linux/mmzone.h         |    2 
 mm/compaction.c                |   43 -----------------
 mm/internal.h                  |   12 ++++
 mm/memory_hotplug.c            |   13 ++++-
 mm/page_alloc.c                |   78 ++++++++++++++++++++++++++++++-
 7 files changed, 105 insertions(+), 52 deletions(-)

diff -puN include/linux/gfp.h~mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous include/linux/gfp.h
--- a/include/linux/gfp.h~mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous
+++ a/include/linux/gfp.h
@@ -519,13 +519,7 @@ void drain_zone_pages(struct zone *zone,
 void drain_all_pages(struct zone *zone);
 void drain_local_pages(struct zone *zone);
 
-#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 void page_alloc_init_late(void);
-#else
-static inline void page_alloc_init_late(void)
-{
-}
-#endif
 
 /*
  * gfp_allowed_mask is set to GFP_BOOT_MASK during early boot to restrict what
diff -puN include/linux/memory_hotplug.h~mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous
+++ a/include/linux/memory_hotplug.h
@@ -198,6 +198,9 @@ void put_online_mems(void);
 void mem_hotplug_begin(void);
 void mem_hotplug_done(void);
 
+extern void set_zone_contiguous(struct zone *zone);
+extern void clear_zone_contiguous(struct zone *zone);
+
 #else /* ! CONFIG_MEMORY_HOTPLUG */
 /*
  * Stub functions for when hotplug is off
diff -puN include/linux/mmzone.h~mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous
+++ a/include/linux/mmzone.h
@@ -522,6 +522,8 @@ struct zone {
 	bool			compact_blockskip_flush;
 #endif
 
+	bool			contiguous;
+
 	ZONE_PADDING(_pad3_)
 	/* Zone statistics */
 	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
diff -puN mm/compaction.c~mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous mm/compaction.c
--- a/mm/compaction.c~mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous
+++ a/mm/compaction.c
@@ -71,49 +71,6 @@ static inline bool migrate_async_suitabl
 	return is_migrate_cma(migratetype) || migratetype == MIGRATE_MOVABLE;
 }
 
-/*
- * Check that the whole (or subset of) a pageblock given by the interval of
- * [start_pfn, end_pfn) is valid and within the same zone, before scanning it
- * with the migration of free compaction scanner. The scanners then need to
- * use only pfn_valid_within() check for arches that allow holes within
- * pageblocks.
- *
- * Return struct page pointer of start_pfn, or NULL if checks were not passed.
- *
- * It's possible on some configurations to have a setup like node0 node1 node0
- * i.e. it's possible that all pages within a zones range of pages do not
- * belong to a single zone. We assume that a border between node0 and node1
- * can occur within a single pageblock, but not a node0 node1 node0
- * interleaving within a single pageblock. It is therefore sufficient to check
- * the first and last page of a pageblock and avoid checking each individual
- * page in a pageblock.
- */
-static struct page *pageblock_pfn_to_page(unsigned long start_pfn,
-				unsigned long end_pfn, struct zone *zone)
-{
-	struct page *start_page;
-	struct page *end_page;
-
-	/* end_pfn is one past the range we are checking */
-	end_pfn--;
-
-	if (!pfn_valid(start_pfn) || !pfn_valid(end_pfn))
-		return NULL;
-
-	start_page = pfn_to_page(start_pfn);
-
-	if (page_zone(start_page) != zone)
-		return NULL;
-
-	end_page = pfn_to_page(end_pfn);
-
-	/* This gives a shorter code than deriving page_zone(end_page) */
-	if (page_zone_id(start_page) != page_zone_id(end_page))
-		return NULL;
-
-	return start_page;
-}
-
 #ifdef CONFIG_COMPACTION
 
 /* Do not skip compaction more than 64 times */
diff -puN mm/internal.h~mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous mm/internal.h
--- a/mm/internal.h~mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous
+++ a/mm/internal.h
@@ -132,6 +132,18 @@ __find_buddy_index(unsigned long page_id
 	return page_idx ^ (1 << order);
 }
 
+extern struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
+				unsigned long end_pfn, struct zone *zone);
+
+static inline struct page *pageblock_pfn_to_page(unsigned long start_pfn,
+				unsigned long end_pfn, struct zone *zone)
+{
+	if (zone->contiguous)
+		return pfn_to_page(start_pfn);
+
+	return __pageblock_pfn_to_page(start_pfn, end_pfn, zone);
+}
+
 extern int __isolate_free_page(struct page *page, unsigned int order);
 extern void __free_pages_bootmem(struct page *page, unsigned long pfn,
 					unsigned int order);
diff -puN mm/memory_hotplug.c~mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous
+++ a/mm/memory_hotplug.c
@@ -512,6 +512,8 @@ int __ref __add_pages(int nid, struct zo
 	int start_sec, end_sec;
 	struct vmem_altmap *altmap;
 
+	clear_zone_contiguous(zone);
+
 	/* during initialize mem_map, align hot-added range to section */
 	start_sec = pfn_to_section_nr(phys_start_pfn);
 	end_sec = pfn_to_section_nr(phys_start_pfn + nr_pages - 1);
@@ -524,7 +526,8 @@ int __ref __add_pages(int nid, struct zo
 		if (altmap->base_pfn != phys_start_pfn
 				|| vmem_altmap_offset(altmap) > nr_pages) {
 			pr_warn_once("memory add fail, invalid altmap\n");
-			return -EINVAL;
+			err = -EINVAL;
+			goto out;
 		}
 		altmap->alloc = 0;
 	}
@@ -542,7 +545,8 @@ int __ref __add_pages(int nid, struct zo
 		err = 0;
 	}
 	vmemmap_populate_print_last();
-
+out:
+	set_zone_contiguous(zone);
 	return err;
 }
 EXPORT_SYMBOL_GPL(__add_pages);
@@ -814,6 +818,8 @@ int __remove_pages(struct zone *zone, un
 		}
 	}
 
+	clear_zone_contiguous(zone);
+
 	/*
 	 * We can only remove entire sections
 	 */
@@ -829,6 +835,9 @@ int __remove_pages(struct zone *zone, un
 		if (ret)
 			break;
 	}
+
+	set_zone_contiguous(zone);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(__remove_pages);
diff -puN mm/page_alloc.c~mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous
+++ a/mm/page_alloc.c
@@ -1128,6 +1128,75 @@ void __init __free_pages_bootmem(struct
 	return __free_pages_boot_core(page, pfn, order);
 }
 
+/*
+ * Check that the whole (or subset of) a pageblock given by the interval of
+ * [start_pfn, end_pfn) is valid and within the same zone, before scanning it
+ * with the migration of free compaction scanner. The scanners then need to
+ * use only pfn_valid_within() check for arches that allow holes within
+ * pageblocks.
+ *
+ * Return struct page pointer of start_pfn, or NULL if checks were not passed.
+ *
+ * It's possible on some configurations to have a setup like node0 node1 node0
+ * i.e. it's possible that all pages within a zones range of pages do not
+ * belong to a single zone. We assume that a border between node0 and node1
+ * can occur within a single pageblock, but not a node0 node1 node0
+ * interleaving within a single pageblock. It is therefore sufficient to check
+ * the first and last page of a pageblock and avoid checking each individual
+ * page in a pageblock.
+ */
+struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
+				     unsigned long end_pfn, struct zone *zone)
+{
+	struct page *start_page;
+	struct page *end_page;
+
+	/* end_pfn is one past the range we are checking */
+	end_pfn--;
+
+	if (!pfn_valid(start_pfn) || !pfn_valid(end_pfn))
+		return NULL;
+
+	start_page = pfn_to_page(start_pfn);
+
+	if (page_zone(start_page) != zone)
+		return NULL;
+
+	end_page = pfn_to_page(end_pfn);
+
+	/* This gives a shorter code than deriving page_zone(end_page) */
+	if (page_zone_id(start_page) != page_zone_id(end_page))
+		return NULL;
+
+	return start_page;
+}
+
+void set_zone_contiguous(struct zone *zone)
+{
+	unsigned long block_start_pfn = zone->zone_start_pfn;
+	unsigned long block_end_pfn;
+
+	block_end_pfn = ALIGN(block_start_pfn + 1, pageblock_nr_pages);
+	for (; block_start_pfn < zone_end_pfn(zone);
+			block_start_pfn = block_end_pfn,
+			 block_end_pfn += pageblock_nr_pages) {
+
+		block_end_pfn = min(block_end_pfn, zone_end_pfn(zone));
+
+		if (!__pageblock_pfn_to_page(block_start_pfn,
+					     block_end_pfn, zone))
+			return;
+	}
+
+	/* We confirm that there is no hole */
+	zone->contiguous = true;
+}
+
+void clear_zone_contiguous(struct zone *zone)
+{
+	zone->contiguous = false;
+}
+
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 static void __init deferred_free_range(struct page *page,
 					unsigned long pfn, int nr_pages)
@@ -1278,9 +1347,13 @@ free_range:
 	pgdat_init_report_one_done();
 	return 0;
 }
+#endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
 
 void __init page_alloc_init_late(void)
 {
+	struct zone *zone;
+
+#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 	int nid;
 
 	/* There will be num_node_state(N_MEMORY) threads */
@@ -1294,8 +1367,11 @@ void __init page_alloc_init_late(void)
 
 	/* Reinit limits that are based on free pages after the kernel is up */
 	files_maxfiles_init();
+#endif
+
+	for_each_populated_zone(zone)
+		set_zone_contiguous(zone);
 }
-#endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
 
 #ifdef CONFIG_CMA
 /* Free whole pageblock and set its migration type to MIGRATE_CMA. */
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-vmalloc-query-dynamic-debug_pagealloc-setting.patch
mm-slub-query-dynamic-debug_pagealloc-setting.patch
mm-slub-query-dynamic-debug_pagealloc-setting-v2.patch
sound-query-dynamic-debug_pagealloc-setting.patch
powerpc-query-dynamic-debug_pagealloc-setting.patch
tile-query-dynamic-debug_pagealloc-setting.patch
mm-introduce-page-reference-manipulation-functions.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3.patch

