Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58BFBC433E0
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:10:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C10464F22
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:10:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbhBZAJu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 19:09:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:45188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232077AbhBZAJq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 19:09:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0462A64F1F;
        Fri, 26 Feb 2021 00:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614298145;
        bh=N9zBPsmaCKxfHCBJC9lyFNajrFO8qdA4hhZiuktg0Gc=;
        h=Date:From:To:Subject:From;
        b=pYimEhOWkQUJpeSb8PKKF7dZT+TOdxtDas2L5kBsxlTMeBky+lmGYqqURQphbLN2y
         K5wvCvxBGCh01NshlXyuB9exrfFb0eYWjHwuih/0HLtJJ7FHXWh18hcNJ/tbseDbVX
         i5SOsDAze2sybGInd6iUVMTLvxMDgjh/u0Ull5V8=
Date:   Thu, 25 Feb 2021 16:09:04 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, bhe@redhat.com, bp@alien8.de, cai@lca.pw,
        chris@chris-wilson.co.uk, david@redhat.com, hpa@zytor.com,
        lma@semihalf.com, mgorman@suse.de, mhocko@kernel.org,
        mingo@redhat.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        tglx@linutronix.de, tomi.p.sarvela@intel.com, vbabka@suse.cz
Subject:  +
 =?US-ASCII?Q?mm-page=5Fallocc-refactor-initialization-of-struct-page-for-?=
 =?US-ASCII?Q?holes-in-memory-layout.patch?= added to -mm tree
Message-ID: <20210226000904.c7jJ1iCmA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: refactor initialization of struct page for h=
oles in memory layout
has been added to the -mm tree.  Its filename is
     mm-page_allocc-refactor-initialization-of-struct-page-for-holes-in-mem=
ory-layout.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_allocc-refactor-initi=
alization-of-struct-page-for-holes-in-memory-layout.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_allocc-refactor-initi=
alization-of-struct-page-for-holes-in-memory-layout.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm/page_alloc.c: refactor initialization of struct page for holes =
in memory layout

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

Before commit 73a6e474cb37 ("mm: memmap_init: iterate over memblock
regions rather that check each PFN") the holes inside a zone were
re-initialized during memmap_init() and got their zone/node links right.=20
However, after that commit nothing updates the struct pages representing
such holes.

On a system that has firmware reserved holes in a zone above ZONE_DMA, for
instance in a configuration below:

	# grep -A1 E820 /proc/iomem
	7a17b000-7a216fff : Unknown E820 type
	7a217000-7bffffff : System RAM

unset zone link in struct page will trigger

	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);

in set_pfnblock_flags_mask() when called with a struct page from a range
other than E820_TYPE_RAM because there are pages in the range of
ZONE_DMA32 but the unset zone link in struct page makes them appear as a
part of ZONE_DMA.

Interleave initialization of the unavailable pages with the normal
initialization of memory map, so that zone and node information will be
properly set on struct pages that are not backed by the actual memory.

With this change the pages for holes inside a zone will get proper
zone/node links and the pages that are not spanned by any node will get
links to the adjacent zone/node.  The holes between nodes will be
prepended to the zone/node above the hole and the trailing pages in the
last section that will be appended to the zone/node below.

Link: https://lkml.kernel.org/r/20210225224351.7356-2-rppt@kernel.org
Fixes: 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions rather=
 that check each PFN")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reported-by: Qian Cai <cai@lca.pw>
Reported-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: David Hildenbrand <david@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: =C5=81ukasz Majczak <lma@semihalf.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Sarvela, Tomi P" <tomi.p.sarvela@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |  158 +++++++++++++++++++++-------------------------
 1 file changed, 75 insertions(+), 83 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-refactor-initialization-of-struct-page=
-for-holes-in-memory-layout
+++ a/mm/page_alloc.c
@@ -6259,12 +6259,65 @@ static void __meminit zone_init_free_lis
 	}
 }
=20
+#if !defined(CONFIG_FLAT_NODE_MEM_MAP)
+/*
+ * Only struct pages that correspond to ranges defined by memblock.memory
+ * are zeroed and initialized by going through __init_single_page() during
+ * memmap_init_zone().
+ *
+ * But, there could be struct pages that correspond to holes in
+ * memblock.memory. This can happen because of the following reasons:
+ * - physical memory bank size is not necessarily the exact multiple of the
+ *   arbitrary section size
+ * - early reserved memory may not be listed in memblock.memory
+ * - memory layouts defined with memmap=3D kernel parameter may not align
+ *   nicely with memmap sections
+ *
+ * Explicitly initialize those struct pages so that:
+ * - PG_Reserved is set
+ * - zone and node links point to zone and node that span the page if the
+ *   hole is in the middle of a zone
+ * - zone and node links point to adjacent zone/node if the hole falls on
+ *   the zone boundary; the pages in such holes will be prepended to the
+ *   zone/node above the hole except for the trailing pages in the last
+ *   section that will be appended to the zone/node below.
+ */
+static u64 __meminit init_unavailable_range(unsigned long spfn,
+					    unsigned long epfn,
+					    int zone, int node)
+{
+	unsigned long pfn;
+	u64 pgcnt =3D 0;
+
+	for (pfn =3D spfn; pfn < epfn; pfn++) {
+		if (!pfn_valid(ALIGN_DOWN(pfn, pageblock_nr_pages))) {
+			pfn =3D ALIGN_DOWN(pfn, pageblock_nr_pages)
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
+static inline u64 init_unavailable_range(unsigned long spfn, unsigned long=
 epfn,
+					 int zone, int node)
+{
+	return 0;
+}
+#endif
+
 void __meminit __weak memmap_init_zone(struct zone *zone)
 {
 	unsigned long zone_start_pfn =3D zone->zone_start_pfn;
 	unsigned long zone_end_pfn =3D zone_start_pfn + zone->spanned_pages;
 	int i, nid =3D zone_to_nid(zone), zone_id =3D zone_idx(zone);
+	static unsigned long hole_pfn =3D 0;
 	unsigned long start_pfn, end_pfn;
+	u64 pgcnt =3D 0;
=20
 	for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
 		start_pfn =3D clamp(start_pfn, zone_start_pfn, zone_end_pfn);
@@ -6274,7 +6327,29 @@ void __meminit __weak memmap_init_zone(s
 			memmap_init_range(end_pfn - start_pfn, nid,
 					zone_id, start_pfn, zone_end_pfn,
 					MEMINIT_EARLY, NULL, MIGRATE_MOVABLE);
+
+		if (hole_pfn < start_pfn)
+			pgcnt +=3D init_unavailable_range(hole_pfn, start_pfn,
+							zone_id, nid);
+		hole_pfn =3D end_pfn;
 	}
+
+#ifdef CONFIG_SPARSEMEM
+	/*
+	 * Initialize the hole in the range [zone_end_pfn, section_end].
+	 * If zone boundary falls in the middle of a section, this hole
+	 * will be re-initialized during the call to this function for the
+	 * higher zone.
+	 */
+	end_pfn =3D round_up(zone_end_pfn, PAGES_PER_SECTION);
+	if (hole_pfn < end_pfn)
+		pgcnt +=3D init_unavailable_range(hole_pfn, end_pfn,
+						zone_id, nid);
+#endif
+
+	if (pgcnt)
+		pr_info("  %s zone: %lld pages in unavailable ranges\n",
+			zone->name, pgcnt);
 }
=20
 static int zone_batchsize(struct zone *zone)
@@ -7071,88 +7146,6 @@ void __init free_area_init_memoryless_no
 	free_area_init_node(nid);
 }
=20
-#if !defined(CONFIG_FLAT_NODE_MEM_MAP)
-/*
- * Initialize all valid struct pages in the range [spfn, epfn) and mark th=
em
- * PageReserved(). Return the number of struct pages that were initialized.
- */
-static u64 __init init_unavailable_range(unsigned long spfn, unsigned long=
 epfn)
-{
-	unsigned long pfn;
-	u64 pgcnt =3D 0;
-
-	for (pfn =3D spfn; pfn < epfn; pfn++) {
-		if (!pfn_valid(ALIGN_DOWN(pfn, pageblock_nr_pages))) {
-			pfn =3D ALIGN_DOWN(pfn, pageblock_nr_pages)
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
- * may be accessed (for example page_to_pfn() on some configuration access=
es
- * flags). We must explicitly initialize those struct pages.
- *
- * This function also addresses a similar issue where struct pages are left
- * uninitialized because the physical address range is not covered by
- * memblock.memory or memblock.reserved. That could happen when memblock
- * layout is manually configured via memmap=3D, or when the highest physic=
al
- * address (max_pfn) does not end on a section boundary.
- */
-static void __init init_unavailable_mem(void)
-{
-	phys_addr_t start, end;
-	u64 i, pgcnt;
-	phys_addr_t next =3D 0;
-
-	/*
-	 * Loop through unavailable ranges not covered by memblock.memory.
-	 */
-	pgcnt =3D 0;
-	for_each_mem_range(i, &start, &end) {
-		if (next < start)
-			pgcnt +=3D init_unavailable_range(PFN_DOWN(next),
-							PFN_UP(start));
-		next =3D end;
-	}
-
-	/*
-	 * Early sections always have a fully populated memmap for the whole
-	 * section - see pfn_valid(). If the last section has holes at the
-	 * end and that section is marked "online", the memmap will be
-	 * considered initialized. Make sure that memmap has a well defined
-	 * state.
-	 */
-	pgcnt +=3D init_unavailable_range(PFN_DOWN(next),
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
@@ -7576,7 +7569,6 @@ void __init free_area_init(unsigned long
 	/* Initialise every node */
 	mminit_verify_pageflags_layout();
 	setup_nr_node_ids();
-	init_unavailable_mem();
 	for_each_online_node(nid) {
 		pg_data_t *pgdat =3D NODE_DATA(nid);
 		free_area_init_node(nid);
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-page_allocc-refactor-initialization-of-struct-page-for-holes-in-memory-l=
ayout.patch

