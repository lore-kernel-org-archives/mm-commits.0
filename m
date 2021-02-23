Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 749F3C433E0
	for <mm-commits@archiver.kernel.org>; Tue, 23 Feb 2021 23:37:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C10064F77
	for <mm-commits@archiver.kernel.org>; Tue, 23 Feb 2021 23:37:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232552AbhBWXgN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 23 Feb 2021 18:36:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:52116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233553AbhBWXa7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 23 Feb 2021 18:30:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4097964E05;
        Tue, 23 Feb 2021 23:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614122997;
        bh=T46OQbBlLmcPMLmZ0mxeIZCCCKTtGm07eRAEZMN88Ls=;
        h=Date:From:To:Subject:From;
        b=dYf2twQO3gocsgtP1zns1DnzJXINoVbi0RcR/n2AfQPt4LCpDzQwZQJMh4hsFvhqM
         Uzgk7DMbCerbgdJZuwWayNKX6BnqWgXKKG+rrV3ivYHQRYnlS/V7Lu0ZLf1j+8SnOB
         UbZJzF2tNtOKCpVw2wxQjKamR47Z2JRNdeNiZsIE=
Date:   Tue, 23 Feb 2021 15:29:56 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, bhe@redhat.com, cai@lca.pw, david@redhat.com,
        mgorman@suse.de, mhocko@kernel.org, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com, vbabka@suse.cz
Subject:  [to-be-updated]
 mm-refactor-initialization-of-struct-page-for-holes-in-memory-layout.patch
 removed from -mm tree
Message-ID: <20210223232956.mgoo8ebto%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: refactor initialization of struct page for holes in memory layout
has been removed from the -mm tree.  Its filename was
     mm-refactor-initialization-of-struct-page-for-holes-in-memory-layout.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm/page_alloc.c: refactor initialization of struct page for holes in memory layout

There could be struct pages that are not backed by actual physical memory.
This can happen when the actual memory bank is not a multiple of
SECTION_SIZE or when an architecture does not register memory holes
reserved by the firmware as memblock.memory.

Such pages are currently initialized using init_unavailable_mem() function
that iterates through PFNs in holes in memblock.memory and if there is a
struct page corresponding to a PFN, the fields of this page are set to
default values and it is marked as Reserved.

init_unavailable_mem() does not take into account zone and node the page
belongs to and sets both zone and node links in struct page to zero.

On a system that has firmware reserved holes in a zone above ZONE_DMA, for
instance in a configuration below:

	# grep -A1 E820 /proc/iomem
	7a17b000-7a216fff : Unknown E820 type
	7a217000-7bffffff : System RAM

unset zone link in struct page will trigger

	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);

because there are pages in both ZONE_DMA32 and ZONE_DMA (unset zone link
in struct page) in the same pageblock.

Moreover, it is possible that the lowest node and zone start is not aligned
to the section boundarie, for example on x86:

[    0.078898] Zone ranges:
[    0.078899]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
...
[    0.078910] Early memory node ranges
[    0.078912]   node   0: [mem 0x0000000000001000-0x000000000009cfff]
[    0.078913]   node   0: [mem 0x0000000000100000-0x000000003fffffff]

and thus with SPARSEMEM memory model the beginning of the memory map will
have struct pages that are not spanned by any node and zone.

Update detection of node boundaries in get_pfn_range_for_nid() so that the
node range will be expanded to cover memory map section.  Since zone spans
are derived from the node span, there always will be a zone that covers
the part of the memory map with unavailable pages.

Interleave initialization of the unavailable pages with the normal
initialization of memory map, so that zone and node information will be
properly set on struct pages that are not backed by the actual memory.

Link: https://lkml.kernel.org/r/20210208110820.6269-1-rppt@kernel.org
Fixes: 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions rather that check each PFN")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reported-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qian Cai <cai@lca.pw>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |  160 +++++++++++++++++++++-------------------------
 1 file changed, 75 insertions(+), 85 deletions(-)

--- a/mm/page_alloc.c~mm-refactor-initialization-of-struct-page-for-holes-in-memory-layout
+++ a/mm/page_alloc.c
@@ -6256,22 +6256,84 @@ static void __meminit zone_init_free_lis
 	}
 }
 
+#if !defined(CONFIG_FLAT_NODE_MEM_MAP)
+/*
+ * Only struct pages that correspond to ranges defined by memblock.memory
+ * are zeroed and initialized by going through __init_single_page() during
+ * memmap_init_zone().
+ *
+ * But, there could be struct pages that correspond to holes in
+ * memblock.memory. This can happen because of the following reasons:
+ * - phyiscal memory bank size is not necessarily the exact multiple of the
+ *   arbitrary section size
+ * - early reserved memory may not be listed in memblock.memory
+ * - memory layouts defined with memmap= kernel parameter may not align
+ *   nicely with memmap sections
+ *
+ * Explicitly initialize those struct pages so that:
+ * - PG_Reserved is set
+ * - zone and node links point to zone and node that span the page
+ */
+static u64 __meminit init_unavailable_range(unsigned long spfn,
+					    unsigned long epfn,
+					    int zone, int node)
+{
+	unsigned long pfn;
+	u64 pgcnt = 0;
+
+	for (pfn = spfn; pfn < epfn; pfn++) {
+		if (!pfn_valid(ALIGN_DOWN(pfn, pageblock_nr_pages))) {
+			pfn = ALIGN_DOWN(pfn, pageblock_nr_pages)
+				+ pageblock_nr_pages - 1;
+			continue;
+		}
+		__init_single_page(pfn_to_page(pfn), pfn, zone, node);
+		__SetPageReserved(pfn_to_page(pfn));
+		pgcnt++;
+	}
+
+	return pgcnt;
+}
+#else
+static inline u64 init_unavailable_range(unsigned long spfn, unsigned long epfn,
+					 int zone, int node)
+{
+	return 0;
+}
+#endif
+
 void __meminit __weak memmap_init_zone(struct zone *zone)
 {
 	unsigned long zone_start_pfn = zone->zone_start_pfn;
 	unsigned long zone_end_pfn = zone_start_pfn + zone->spanned_pages;
 	int i, nid = zone_to_nid(zone), zone_id = zone_idx(zone);
 	unsigned long start_pfn, end_pfn;
+	unsigned long hole_pfn = 0;
+	u64 pgcnt = 0;
 
 	for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
 		start_pfn = clamp(start_pfn, zone_start_pfn, zone_end_pfn);
 		end_pfn = clamp(end_pfn, zone_start_pfn, zone_end_pfn);
+		hole_pfn = clamp(hole_pfn, zone_start_pfn, zone_end_pfn);
 
 		if (end_pfn > start_pfn)
 			memmap_init_range(end_pfn - start_pfn, nid,
 					zone_id, start_pfn, zone_end_pfn,
 					MEMINIT_EARLY, NULL, MIGRATE_MOVABLE);
+
+		if (hole_pfn < start_pfn)
+			pgcnt += init_unavailable_range(hole_pfn, start_pfn,
+							zone_id, nid);
+		hole_pfn = end_pfn;
 	}
+
+	if (hole_pfn < zone_end_pfn)
+		pgcnt += init_unavailable_range(hole_pfn, zone_end_pfn,
+						zone_id, nid);
+
+	if (pgcnt)
+		pr_info("  %s zone: %lld pages in unavailable ranges\n",
+			zone->name, pgcnt);
 }
 
 static int zone_batchsize(struct zone *zone)
@@ -6518,8 +6580,19 @@ void __init get_pfn_range_for_nid(unsign
 		*end_pfn = max(*end_pfn, this_end_pfn);
 	}
 
-	if (*start_pfn == -1UL)
+	if (*start_pfn == -1UL) {
 		*start_pfn = 0;
+		return;
+	}
+
+#ifdef CONFIG_SPARSEMEM
+	/*
+	 * Sections in the memory map may not match actual populated
+	 * memory, extend the node span to cover the entire section.
+	 */
+	*start_pfn = round_down(*start_pfn, PAGES_PER_SECTION);
+	*end_pfn = round_up(*end_pfn, PAGES_PER_SECTION);
+#endif
 }
 
 /*
@@ -7068,88 +7141,6 @@ void __init free_area_init_memoryless_no
 	free_area_init_node(nid);
 }
 
-#if !defined(CONFIG_FLAT_NODE_MEM_MAP)
-/*
- * Initialize all valid struct pages in the range [spfn, epfn) and mark them
- * PageReserved(). Return the number of struct pages that were initialized.
- */
-static u64 __init init_unavailable_range(unsigned long spfn, unsigned long epfn)
-{
-	unsigned long pfn;
-	u64 pgcnt = 0;
-
-	for (pfn = spfn; pfn < epfn; pfn++) {
-		if (!pfn_valid(ALIGN_DOWN(pfn, pageblock_nr_pages))) {
-			pfn = ALIGN_DOWN(pfn, pageblock_nr_pages)
-				+ pageblock_nr_pages - 1;
-			continue;
-		}
-		/*
-		 * Use a fake node/zone (0) for now. Some of these pages
-		 * (in memblock.reserved but not in memblock.memory) will
-		 * get re-initialized via reserve_bootmem_region() later.
-		 */
-		__init_single_page(pfn_to_page(pfn), pfn, 0, 0);
-		__SetPageReserved(pfn_to_page(pfn));
-		pgcnt++;
-	}
-
-	return pgcnt;
-}
-
-/*
- * Only struct pages that are backed by physical memory are zeroed and
- * initialized by going through __init_single_page(). But, there are some
- * struct pages which are reserved in memblock allocator and their fields
- * may be accessed (for example page_to_pfn() on some configuration accesses
- * flags). We must explicitly initialize those struct pages.
- *
- * This function also addresses a similar issue where struct pages are left
- * uninitialized because the physical address range is not covered by
- * memblock.memory or memblock.reserved. That could happen when memblock
- * layout is manually configured via memmap=, or when the highest physical
- * address (max_pfn) does not end on a section boundary.
- */
-static void __init init_unavailable_mem(void)
-{
-	phys_addr_t start, end;
-	u64 i, pgcnt;
-	phys_addr_t next = 0;
-
-	/*
-	 * Loop through unavailable ranges not covered by memblock.memory.
-	 */
-	pgcnt = 0;
-	for_each_mem_range(i, &start, &end) {
-		if (next < start)
-			pgcnt += init_unavailable_range(PFN_DOWN(next),
-							PFN_UP(start));
-		next = end;
-	}
-
-	/*
-	 * Early sections always have a fully populated memmap for the whole
-	 * section - see pfn_valid(). If the last section has holes at the
-	 * end and that section is marked "online", the memmap will be
-	 * considered initialized. Make sure that memmap has a well defined
-	 * state.
-	 */
-	pgcnt += init_unavailable_range(PFN_DOWN(next),
-					round_up(max_pfn, PAGES_PER_SECTION));
-
-	/*
-	 * Struct pages that do not have backing memory. This could be because
-	 * firmware is using some of this memory, or for some other reasons.
-	 */
-	if (pgcnt)
-		pr_info("Zeroed struct page in unavailable ranges: %lld pages", pgcnt);
-}
-#else
-static inline void __init init_unavailable_mem(void)
-{
-}
-#endif /* !CONFIG_FLAT_NODE_MEM_MAP */
-
 #if MAX_NUMNODES > 1
 /*
  * Figure out the number of possible node ids.
@@ -7509,7 +7500,7 @@ void __init free_area_init(unsigned long
 	memset(arch_zone_highest_possible_pfn, 0,
 				sizeof(arch_zone_highest_possible_pfn));
 
-	start_pfn = find_min_pfn_with_active_regions();
+	start_pfn = 0;
 	descending = arch_has_descending_max_zone_pfns();
 
 	for (i = 0; i < MAX_NR_ZONES; i++) {
@@ -7573,7 +7564,6 @@ void __init free_area_init(unsigned long
 	/* Initialise every node */
 	mminit_verify_pageflags_layout();
 	setup_nr_node_ids();
-	init_unavailable_mem();
 	for_each_online_node(nid) {
 		pg_data_t *pgdat = NODE_DATA(nid);
 		free_area_init_node(nid);
_

Patches currently in -mm which might be from rppt@linux.ibm.com are


