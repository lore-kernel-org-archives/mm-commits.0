Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A21B20E023
	for <mm-commits@vger.kernel.org>; Fri, 26 Jun 2026 00:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782434837; cv=none; b=Ax4Y1dtukD4X95sAEtYR650UvuOf6Z+1PO/CxiQiFWckezwcOj9ZW8efAGiZIHJftOQpfbDqwyecOIj9v2VvCCaEzz9LscwWMFITVls+q+AF5bje5Qxf6RZr0C2pATcZAO2POQpPjhQ452Np4gxDZUOWDNEI2/D+vYa51rubSBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782434837; c=relaxed/simple;
	bh=d2qVj96e2Mj1b5JpzxPf3uLMks3SDB6jowGax0wIhRY=;
	h=Date:To:From:Subject:Message-Id; b=InhDly7pP4SI+vSrwMSja0a2Z/HGyiERTQj9/y66B3+Z/yW4qbPB5UhsnrspQqUXVgNwq/UFlc86XKmS6Aqt8YwAoXvMuxVZGNE0pCCtH6cV8Veb1KgJ9QnpDQ7qRlooO/v0HS4mB+HsHi0y1ShO1huMw2t7/WVCltENBlt/yE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KTOTJHK6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KTOTJHK6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46CE21F000E9;
	Fri, 26 Jun 2026 00:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782434836;
	bh=Ukxkk+kQwLkwuxyRGpZ2rA21kBb8TO6WbO1P9qAqJ0Y=;
	h=Date:To:From:Subject;
	b=KTOTJHK6dsmtfvwma60vSrXVYO6k9WsPqjopPxN6+xg0dYNJXndXi840aInSchGUG
	 qqu9yfcUUABPxVdl9zXbS6Pzk8/o9wBazBKRUovScpEo5HEWYtouxb8WPEZI9nMdPg
	 WBiCSXBOZNS02OwCOQ+u6xQVKIXNAKZsLPxbBgck=
Date: Thu, 25 Jun 2026 17:47:15 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_init-simplify-deferred_free_pages-migratetype-init.patch added to mm-new branch
Message-Id: <20260626004716.46CE21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mm_init: simplify deferred_free_pages() migratetype init
has been added to the -mm mm-new branch.  Its filename is
     mm-mm_init-simplify-deferred_free_pages-migratetype-init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_init-simplify-deferred_free_pages-migratetype-init.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/mm_init: simplify deferred_free_pages() migratetype init
Date: Fri, 12 Jun 2026 11:58:49 +0800

deferred_free_pages() open-codes two loops to initialize the pageblock
migratetype for a range of pages.

Replace them with pageblock_migratetype_init_range() to remove the
duplication and make the code clearer (Note that deferred_free_pages() may
be called from atomic context).

Link: https://lore.kernel.org/20260612035903.2468601-6-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

--- a/mm/mm_init.c~mm-mm_init-simplify-deferred_free_pages-migratetype-init
+++ a/mm/mm_init.c
@@ -674,15 +674,15 @@ static inline void fixup_hashdist(void)
 static inline void fixup_hashdist(void) {}
 #endif /* CONFIG_NUMA */
 
-#ifdef CONFIG_ZONE_DEVICE
+#if defined(CONFIG_ZONE_DEVICE) || defined(CONFIG_DEFERRED_STRUCT_PAGE_INIT)
 static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
-		unsigned long nr_pages, int migratetype)
+		unsigned long nr_pages, int migratetype, bool atomic)
 {
 	const unsigned long end = pfn + nr_pages;
 
 	for (pfn = pageblock_align(pfn); pfn < end; pfn += pageblock_nr_pages) {
 		init_pageblock_migratetype(pfn_to_page(pfn), migratetype, false);
-		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
+		if (!atomic && IS_ALIGNED(pfn, PAGES_PER_SECTION))
 			cond_resched();
 	}
 }
@@ -1142,7 +1142,7 @@ void __ref memmap_init_zone_device(struc
 				     compound_nr_pages(pfn, altmap, pgmap));
 	}
 
-	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE);
+	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE, false);
 
 	pr_debug("%s initialised %lu pages in %ums\n", __func__,
 		nr_pages, jiffies_to_msecs(jiffies - start));
@@ -1981,12 +1981,12 @@ static void __init deferred_free_pages(u
 	if (!nr_pages)
 		return;
 
+	pageblock_migratetype_init_range(pfn, nr_pages, mt, true);
+
 	page = pfn_to_page(pfn);
 
 	/* Free a large naturally-aligned chunk if possible */
 	if (nr_pages == MAX_ORDER_NR_PAGES && IS_MAX_ORDER_ALIGNED(pfn)) {
-		for (i = 0; i < nr_pages; i += pageblock_nr_pages)
-			init_pageblock_migratetype(page + i, mt, false);
 		__free_pages_core(page, MAX_PAGE_ORDER, MEMINIT_EARLY);
 		return;
 	}
@@ -1994,11 +1994,8 @@ static void __init deferred_free_pages(u
 	/* Accept chunks smaller than MAX_PAGE_ORDER upfront */
 	accept_memory(PFN_PHYS(pfn), nr_pages * PAGE_SIZE);
 
-	for (i = 0; i < nr_pages; i++, page++, pfn++) {
-		if (pageblock_aligned(pfn))
-			init_pageblock_migratetype(page, mt, false);
-		__free_pages_core(page, 0, MEMINIT_EARLY);
-	}
+	for (i = 0; i < nr_pages; i++)
+		__free_pages_core(page + i, 0, MEMINIT_EARLY);
 }
 
 /* Completion tracking for deferred_init_memmap() threads */
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb-fix-boot-panic-with-config_debug_vm-and-hvo-bootmem-pages.patch
mm-hugetlb_vmemmap-fix-__hugetlb_vmemmap_optimize_folios.patch
powerpc-mm-fix-wrong-addr_pfn-tracking-in-compound-vmemmap-population.patch
mm-hugetlb-initialize-gigantic-bootmem-hugepage-struct-pages-earlier.patch
mm-mm_init-simplify-deferred_free_pages-migratetype-init.patch
mm-sparse-panic-on-memmap-and-usemap-allocation-failure.patch
mm-sparse-move-subsection_map_init-into-sparse_init.patch
mm-mm_init-defer-sparse_init-until-after-zone-initialization.patch
mm-mm_init-defer-hugetlb-reservation-until-after-zone-initialization.patch
mm-mm_init-remove-set_pageblock_order-call-from-sparse_init.patch
mm-sparse-move-sparse_vmemmap_init_nid_late-into-sparse_init_nid.patch
mm-hugetlb_cma-validate-hugetlb-cma-range-by-zone-at-reserve-time.patch
mm-hugetlb-refactor-early-boot-gigantic-hugepage-allocation.patch
mm-hugetlb-free-cross-zone-bootmem-gigantic-pages-after-allocation.patch
mm-hugetlb_vmemmap-move-bootmem-hvo-setup-to-early-init.patch
mm-hugetlb-remove-obsolete-bootmem-cross-zone-checks.patch
mm-sparse-vmemmap-remove-sparse_vmemmap_init_nid_late.patch
mm-hugetlb-remove-unused-bootmem-cma-field.patch
mm-mm_init-fold-__init_page_from_nid-into-__init_deferred_page.patch

