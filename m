Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DE6204C36
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450014; cv=none; b=MEcYO1/jG4h/LUt2FStuI1iZO+D34aNoRvIaGo52UknMm+7badAvO9kwLznRW/gIXkVzuKFevnUyOSFSa/zQxKkYJNJStRqEasKZGmebx4j4XytG8mlqsTlCrKe96E2VtXkJ13BjDn9u/v3NeQkbBDSJ2WyiTycEQlLFoB5iubM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450014; c=relaxed/simple;
	bh=YznCyTiEtqeYHHlEwUqMBKlE9ATrb2BpzCuFUiVvSMs=;
	h=Date:To:From:Subject:Message-Id; b=DBBUBr80kjan5atvKSf3TAa+sb+f1VuyuqDSVibe1uU9Eq6ZN/IBqrFPnOs4Ri32byNyQxiAvo8v2MzboU1eciZb+TT56USzbvACaaOHGm7m78jqg3Gqk0cEcV8OYkRQfLwRdDVHnTd2YJBTIDQPTHB9kDvtzi65b0+jopqLITk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dfvW30P/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dfvW30P/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC364C4CEE3;
	Sun, 13 Jul 2025 23:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450014;
	bh=YznCyTiEtqeYHHlEwUqMBKlE9ATrb2BpzCuFUiVvSMs=;
	h=Date:To:From:Subject:From;
	b=dfvW30P/rIPZ/BE95Ae5W2s6TX0pZaWbMlMDBcTo9Y/kwoEo8F2n9hkYOEs+0jxCm
	 Q58JCY5Kkx0S/G7JQriZcamoogrxmC/gqv1feq9FBJXGI66QS4CN3EqsJ7PaxaJLgR
	 8/ZkKaoJ9b1eGqTwHRU5nB1jAsFjMiVI5xKhGy7o=
Date: Sun, 13 Jul 2025 16:40:13 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,richardycc@google.com,osalvador@suse.de,mhocko@suse.com,mgorman@techsingularity.net,kirill.shutemov@linux.intel.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-add-support-for-initializing-pageblock-as-isolated.patch removed from -mm tree
Message-Id: <20250713234013.EC364C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: add support for initializing pageblock as isolated
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-add-support-for-initializing-pageblock-as-isolated.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/page_alloc: add support for initializing pageblock as isolated
Date: Mon, 16 Jun 2025 22:11:11 -0400

MIGRATE_ISOLATE is a standalone bit, so a pageblock cannot be initialized
to just MIGRATE_ISOLATE.  Add init_pageblock_migratetype() to enable
initialize a pageblock with a migratetype and isolated.

Link: https://lkml.kernel.org/r/20250617021115.2331563-4-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Richard Chang <richardycc@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    3 ++-
 include/linux/page-isolation.h |    3 +++
 kernel/kexec_handover.c        |    4 ++--
 mm/hugetlb.c                   |    4 ++--
 mm/internal.h                  |    3 ++-
 mm/memory_hotplug.c            |   12 ++++++++----
 mm/memremap.c                  |    2 +-
 mm/mm_init.c                   |   24 +++++++++++++++---------
 mm/page_alloc.c                |   26 ++++++++++++++++++++++++++
 9 files changed, 61 insertions(+), 20 deletions(-)

--- a/include/linux/memory_hotplug.h~mm-page_alloc-add-support-for-initializing-pageblock-as-isolated
+++ a/include/linux/memory_hotplug.h
@@ -314,7 +314,8 @@ extern int add_memory_driver_managed(int
 				     mhp_t mhp_flags);
 extern void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 				   unsigned long nr_pages,
-				   struct vmem_altmap *altmap, int migratetype);
+				   struct vmem_altmap *altmap, int migratetype,
+				   bool isolate_pageblock);
 extern void remove_pfn_range_from_zone(struct zone *zone,
 				       unsigned long start_pfn,
 				       unsigned long nr_pages);
--- a/include/linux/page-isolation.h~mm-page_alloc-add-support-for-initializing-pageblock-as-isolated
+++ a/include/linux/page-isolation.h
@@ -41,6 +41,9 @@ static inline void set_pageblock_isolate
 #define MEMORY_OFFLINE	0x1
 #define REPORT_FAILURE	0x2
 
+void __meminit init_pageblock_migratetype(struct page *page,
+					  enum migratetype migratetype,
+					  bool isolate);
 void set_pageblock_migratetype(struct page *page, enum migratetype migratetype);
 
 bool move_freepages_block_isolate(struct zone *zone, struct page *page,
--- a/kernel/kexec_handover.c~mm-page_alloc-add-support-for-initializing-pageblock-as-isolated
+++ a/kernel/kexec_handover.c
@@ -1100,8 +1100,8 @@ static void __init kho_release_scratch(v
 		ulong pfn;
 
 		for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages)
-			set_pageblock_migratetype(pfn_to_page(pfn),
-						  MIGRATE_CMA);
+			init_pageblock_migratetype(pfn_to_page(pfn),
+						   MIGRATE_CMA, false);
 	}
 }
 
--- a/mm/hugetlb.c~mm-page_alloc-add-support-for-initializing-pageblock-as-isolated
+++ a/mm/hugetlb.c
@@ -3297,8 +3297,8 @@ static void __init hugetlb_bootmem_init_
 		if (folio_test_hugetlb_cma(folio))
 			init_cma_pageblock(folio_page(folio, i));
 		else
-			set_pageblock_migratetype(folio_page(folio, i),
-					  MIGRATE_MOVABLE);
+			init_pageblock_migratetype(folio_page(folio, i),
+					  MIGRATE_MOVABLE, false);
 	}
 }
 
--- a/mm/internal.h~mm-page_alloc-add-support-for-initializing-pageblock-as-isolated
+++ a/mm/internal.h
@@ -820,7 +820,8 @@ extern void *memmap_alloc(phys_addr_t si
 			  int nid, bool exact_nid);
 
 void memmap_init_range(unsigned long, int, unsigned long, unsigned long,
-		unsigned long, enum meminit_context, struct vmem_altmap *, int);
+		unsigned long, enum meminit_context, struct vmem_altmap *, int,
+		bool);
 
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
 
--- a/mm/memory_hotplug.c~mm-page_alloc-add-support-for-initializing-pageblock-as-isolated
+++ a/mm/memory_hotplug.c
@@ -747,7 +747,8 @@ static inline void section_taint_zone_de
  */
 void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 				  unsigned long nr_pages,
-				  struct vmem_altmap *altmap, int migratetype)
+				  struct vmem_altmap *altmap, int migratetype,
+				  bool isolate_pageblock)
 {
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	int nid = pgdat->node_id;
@@ -779,7 +780,8 @@ void move_pfn_range_to_zone(struct zone
 	 * are reserved so nobody should be touching them so we should be safe
 	 */
 	memmap_init_range(nr_pages, nid, zone_idx(zone), start_pfn, 0,
-			 MEMINIT_HOTPLUG, altmap, migratetype);
+			 MEMINIT_HOTPLUG, altmap, migratetype,
+			 isolate_pageblock);
 
 	set_zone_contiguous(zone);
 }
@@ -1104,7 +1106,8 @@ int mhp_init_memmap_on_memory(unsigned l
 	if (mhp_off_inaccessible)
 		page_init_poison(pfn_to_page(pfn), sizeof(struct page) * nr_pages);
 
-	move_pfn_range_to_zone(zone, pfn, nr_pages, NULL, MIGRATE_UNMOVABLE);
+	move_pfn_range_to_zone(zone, pfn, nr_pages, NULL, MIGRATE_UNMOVABLE,
+			       false);
 
 	for (i = 0; i < nr_pages; i++) {
 		struct page *page = pfn_to_page(pfn + i);
@@ -1175,7 +1178,8 @@ int online_pages(unsigned long pfn, unsi
 
 
 	/* associate pfn range with the zone */
-	move_pfn_range_to_zone(zone, pfn, nr_pages, NULL, MIGRATE_ISOLATE);
+	move_pfn_range_to_zone(zone, pfn, nr_pages, NULL, MIGRATE_MOVABLE,
+			       true);
 
 	if (!node_state(nid, N_MEMORY)) {
 		/* Adding memory to the node for the first time */
--- a/mm/memremap.c~mm-page_alloc-add-support-for-initializing-pageblock-as-isolated
+++ a/mm/memremap.c
@@ -228,7 +228,7 @@ static int pagemap_range(struct dev_page
 		zone = &NODE_DATA(nid)->node_zones[ZONE_DEVICE];
 		move_pfn_range_to_zone(zone, PHYS_PFN(range->start),
 				PHYS_PFN(range_len(range)), params->altmap,
-				MIGRATE_MOVABLE);
+				MIGRATE_MOVABLE, false);
 	}
 
 	mem_hotplug_done();
--- a/mm/mm_init.c~mm-page_alloc-add-support-for-initializing-pageblock-as-isolated
+++ a/mm/mm_init.c
@@ -685,7 +685,8 @@ void __meminit __init_page_from_nid(unsi
 	__init_single_page(pfn_to_page(pfn), pfn, zid, nid);
 
 	if (pageblock_aligned(pfn))
-		set_pageblock_migratetype(pfn_to_page(pfn), MIGRATE_MOVABLE);
+		init_pageblock_migratetype(pfn_to_page(pfn), MIGRATE_MOVABLE,
+				false);
 }
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
@@ -874,7 +875,8 @@ static void __init init_unavailable_rang
 void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone,
 		unsigned long start_pfn, unsigned long zone_end_pfn,
 		enum meminit_context context,
-		struct vmem_altmap *altmap, int migratetype)
+		struct vmem_altmap *altmap, int migratetype,
+		bool isolate_pageblock)
 {
 	unsigned long pfn, end_pfn = start_pfn + size;
 	struct page *page;
@@ -931,7 +933,8 @@ void __meminit memmap_init_range(unsigne
 		 * over the place during system boot.
 		 */
 		if (pageblock_aligned(pfn)) {
-			set_pageblock_migratetype(page, migratetype);
+			init_pageblock_migratetype(page, migratetype,
+					isolate_pageblock);
 			cond_resched();
 		}
 		pfn++;
@@ -954,7 +957,8 @@ static void __init memmap_init_zone_rang
 		return;
 
 	memmap_init_range(end_pfn - start_pfn, nid, zone_id, start_pfn,
-			  zone_end_pfn, MEMINIT_EARLY, NULL, MIGRATE_MOVABLE);
+			  zone_end_pfn, MEMINIT_EARLY, NULL, MIGRATE_MOVABLE,
+			  false);
 
 	if (*hole_pfn < start_pfn)
 		init_unavailable_range(*hole_pfn, start_pfn, zone_id, nid);
@@ -1035,7 +1039,7 @@ static void __ref __init_zone_device_pag
 	 * because this is done early in section_activate()
 	 */
 	if (pageblock_aligned(pfn)) {
-		set_pageblock_migratetype(page, MIGRATE_MOVABLE);
+		init_pageblock_migratetype(page, MIGRATE_MOVABLE, false);
 		cond_resched();
 	}
 
@@ -1996,7 +2000,8 @@ static void __init deferred_free_pages(u
 	/* Free a large naturally-aligned chunk if possible */
 	if (nr_pages == MAX_ORDER_NR_PAGES && IS_MAX_ORDER_ALIGNED(pfn)) {
 		for (i = 0; i < nr_pages; i += pageblock_nr_pages)
-			set_pageblock_migratetype(page + i, MIGRATE_MOVABLE);
+			init_pageblock_migratetype(page + i, MIGRATE_MOVABLE,
+					false);
 		__free_pages_core(page, MAX_PAGE_ORDER, MEMINIT_EARLY);
 		return;
 	}
@@ -2006,7 +2011,8 @@ static void __init deferred_free_pages(u
 
 	for (i = 0; i < nr_pages; i++, page++, pfn++) {
 		if (pageblock_aligned(pfn))
-			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
+			init_pageblock_migratetype(page, MIGRATE_MOVABLE,
+					false);
 		__free_pages_core(page, 0, MEMINIT_EARLY);
 	}
 }
@@ -2305,7 +2311,7 @@ void __init init_cma_reserved_pageblock(
 		set_page_count(p, 0);
 	} while (++p, --i);
 
-	set_pageblock_migratetype(page, MIGRATE_CMA);
+	init_pageblock_migratetype(page, MIGRATE_CMA, false);
 	set_page_refcounted(page);
 	/* pages were reserved and not allocated */
 	clear_page_tag_ref(page);
@@ -2319,7 +2325,7 @@ void __init init_cma_reserved_pageblock(
  */
 void __init init_cma_pageblock(struct page *page)
 {
-	set_pageblock_migratetype(page, MIGRATE_CMA);
+	init_pageblock_migratetype(page, MIGRATE_CMA, false);
 	adjust_managed_page_count(page, pageblock_nr_pages);
 	page_zone(page)->cma_pages += pageblock_nr_pages;
 }
--- a/mm/page_alloc.c~mm-page_alloc-add-support-for-initializing-pageblock-as-isolated
+++ a/mm/page_alloc.c
@@ -544,6 +544,32 @@ __always_inline void set_pageblock_migra
 				  MIGRATETYPE_AND_ISO_MASK);
 }
 
+void __meminit init_pageblock_migratetype(struct page *page,
+					  enum migratetype migratetype,
+					  bool isolate)
+{
+	unsigned long flags;
+
+	if (unlikely(page_group_by_mobility_disabled &&
+		     migratetype < MIGRATE_PCPTYPES))
+		migratetype = MIGRATE_UNMOVABLE;
+
+	flags = migratetype;
+
+#ifdef CONFIG_MEMORY_ISOLATION
+	if (migratetype == MIGRATE_ISOLATE) {
+		VM_WARN_ONCE(
+			1,
+			"Set isolate=true to isolate pageblock with a migratetype");
+		return;
+	}
+	if (isolate)
+		flags |= BIT(PB_migrate_isolate);
+#endif
+	__set_pfnblock_flags_mask(page, page_to_pfn(page), flags,
+				  MIGRATETYPE_AND_ISO_MASK);
+}
+
 #ifdef CONFIG_DEBUG_VM
 static int page_outside_zone_boundaries(struct zone *zone, struct page *page)
 {
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-fix-split_huge_page_test-for-folio_split-tests.patch
mm-huge_memory-move-unrelated-code-out-of-__split_unmapped_folio.patch
mm-huge_memory-use-folio_expected_ref_count-to-calculate-ref_count.patch

