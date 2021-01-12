Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65017C433E0
	for <mm-commits@archiver.kernel.org>; Tue, 12 Jan 2021 00:58:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3329E22D5B
	for <mm-commits@archiver.kernel.org>; Tue, 12 Jan 2021 00:58:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbhALA6F (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Jan 2021 19:58:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:50404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727261AbhALA6E (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 11 Jan 2021 19:58:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C333225AB;
        Tue, 12 Jan 2021 00:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610413042;
        bh=UR3DwJeZmXHLAdrV2MbY/62dm22TAskumpQ6BqzTp6A=;
        h=Date:From:To:Subject:From;
        b=dEHkkx9EVAS41GWGP1yr9Jfe5hm47sHR9b0/W6Mb0nFIN9hmy5sd75D3cLkEkrukQ
         rnSu7qfdTJKknpIbVTMuSgduIti4IupIfS/sYc/9w+71xopBoGU2l0SKbPngPvQJBL
         gEEebGb8JOEzwHv3OvOdSzl8VpkyHszSJeIYi8zQ=
Date:   Mon, 11 Jan 2021 16:57:21 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, bhe@redhat.com, bp@alien8.de, cai@lca.pw,
        david@redhat.com, hpa@zytor.com, mgorman@suse.de,
        mhocko@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com, tglx@linutronix.de, vbabka@suse.cz
Subject:  +
 mm-fix-initialization-of-struct-page-for-holes-in-memory-layout.patch added
 to -mm tree
Message-ID: <20210112005721.Cm8vR-dsB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix initialization of struct page for holes in memory layout
has been added to the -mm tree.  Its filename is
     mm-fix-initialization-of-struct-page-for-holes-in-memory-layout.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fix-initialization-of-struct-page-for-holes-in-memory-layout.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-initialization-of-struct-page-for-holes-in-memory-layout.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm: fix initialization of struct page for holes in memory layout

There could be struct pages that are not backed by actual physical memory.
This can happen when the actual memory bank is not a multiple of
SECTION_SIZE or when an architecture does not register memory holes
reserved by the firmware as memblock.memory.

Such pages are currently initialized using init_unavailable_mem() function
that iterates through PFNs in holes in memblock.memory and if there is a
struct page corresponding to a PFN, the fields if this page are set to
default values and the page is marked as Reserved.

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

Update init_unavailable_mem() to use zone constraints defined by an
architecture to properly setup the zone link and use node ID of the
adjacent range in memblock.memory to set the node link.

Link: https://lkml.kernel.org/r/20210111194017.22696-3-rppt@kernel.org
Fixes: 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions rather that check each PFN")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reported-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qian Cai <cai@lca.pw>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   84 +++++++++++++++++++++++++++-------------------
 1 file changed, 50 insertions(+), 34 deletions(-)

--- a/mm/page_alloc.c~mm-fix-initialization-of-struct-page-for-holes-in-memory-layout
+++ a/mm/page_alloc.c
@@ -7077,23 +7077,26 @@ void __init free_area_init_memoryless_no
  * Initialize all valid struct pages in the range [spfn, epfn) and mark them
  * PageReserved(). Return the number of struct pages that were initialized.
  */
-static u64 __init init_unavailable_range(unsigned long spfn, unsigned long epfn)
+static u64 __init init_unavailable_range(unsigned long spfn, unsigned long epfn,
+					 int zone, int nid)
 {
-	unsigned long pfn;
+	unsigned long pfn, zone_spfn, zone_epfn;
 	u64 pgcnt = 0;
 
+	zone_spfn = arch_zone_lowest_possible_pfn[zone];
+	zone_epfn = arch_zone_highest_possible_pfn[zone];
+
+	spfn = clamp(spfn, zone_spfn, zone_epfn);
+	epfn = clamp(epfn, zone_spfn, zone_epfn);
+
 	for (pfn = spfn; pfn < epfn; pfn++) {
 		if (!pfn_valid(ALIGN_DOWN(pfn, pageblock_nr_pages))) {
 			pfn = ALIGN_DOWN(pfn, pageblock_nr_pages)
 				+ pageblock_nr_pages - 1;
 			continue;
 		}
-		/*
-		 * Use a fake node/zone (0) for now. Some of these pages
-		 * (in memblock.reserved but not in memblock.memory) will
-		 * get re-initialized via reserve_bootmem_region() later.
-		 */
-		__init_single_page(pfn_to_page(pfn), pfn, 0, 0);
+
+		__init_single_page(pfn_to_page(pfn), pfn, zone, nid);
 		__SetPageReserved(pfn_to_page(pfn));
 		pgcnt++;
 	}
@@ -7102,51 +7105,64 @@ static u64 __init init_unavailable_range
 }
 
 /*
- * Only struct pages that are backed by physical memory are zeroed and
- * initialized by going through __init_single_page(). But, there are some
- * struct pages which are reserved in memblock allocator and their fields
- * may be accessed (for example page_to_pfn() on some configuration accesses
- * flags). We must explicitly initialize those struct pages.
+ * Only struct pages that correspond to ranges defined by memblock.memory
+ * are zeroed and initialized by going through __init_single_page() during
+ * memmap_init().
  *
- * This function also addresses a similar issue where struct pages are left
- * uninitialized because the physical address range is not covered by
- * memblock.memory or memblock.reserved. That could happen when memblock
- * layout is manually configured via memmap=, or when the highest physical
- * address (max_pfn) does not end on a section boundary.
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
+ * - zone link is set accorging to the architecture constrains
+ * - node is set to node id of the next populated region except for the
+ *   trailing hole where last node id is used
  */
-static void __init init_unavailable_mem(void)
+static void __init init_zone_unavailable_mem(int zone)
 {
-	phys_addr_t start, end;
-	u64 i, pgcnt;
-	phys_addr_t next = 0;
+	unsigned long start, end;
+	int i, nid;
+	u64 pgcnt;
+	unsigned long next = 0;
 
 	/*
-	 * Loop through unavailable ranges not covered by memblock.memory.
+	 * Loop through holes in memblock.memory and initialize struct
+	 * pages corresponding to these holes
 	 */
 	pgcnt = 0;
-	for_each_mem_range(i, &start, &end) {
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, &nid) {
 		if (next < start)
-			pgcnt += init_unavailable_range(PFN_DOWN(next),
-							PFN_UP(start));
+			pgcnt += init_unavailable_range(next, start, zone, nid);
 		next = end;
 	}
 
 	/*
-	 * Early sections always have a fully populated memmap for the whole
-	 * section - see pfn_valid(). If the last section has holes at the
-	 * end and that section is marked "online", the memmap will be
-	 * considered initialized. Make sure that memmap has a well defined
-	 * state.
+	 * Last section may surpass the actual end of memory (e.g. we can
+	 * have 1Gb section and 512Mb of RAM pouplated).
+	 * Make sure that memmap has a well defined state in this case.
 	 */
-	pgcnt += init_unavailable_range(PFN_DOWN(next),
-					round_up(max_pfn, PAGES_PER_SECTION));
+	end = round_up(max_pfn, PAGES_PER_SECTION);
+	pgcnt += init_unavailable_range(next, end, zone, nid);
 
 	/*
 	 * Struct pages that do not have backing memory. This could be because
 	 * firmware is using some of this memory, or for some other reasons.
 	 */
 	if (pgcnt)
-		pr_info("Zeroed struct page in unavailable ranges: %lld pages", pgcnt);
+		pr_info("Zone %s: zeroed struct page in unavailable ranges: %lld pages", zone_names[zone], pgcnt);
+}
+
+static void __init init_unavailable_mem(void)
+{
+	int zone;
+
+	for (zone = 0; zone < ZONE_MOVABLE; zone++)
+		init_zone_unavailable_mem(zone);
 }
 #else
 static inline void __init init_unavailable_mem(void)
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

x86-setup-dont-remove-e820_type_ram-for-pfn-0.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout.patch
mm-add-definition-of-pmd_page_order.patch
mmap-make-mlock_future_check-global.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages.patch
set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
secretmem-use-pmd-size-pages-to-amortize-direct-map-fragmentation.patch
secretmem-add-memcg-accounting.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch

