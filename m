Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC7223770A
	for <mm-commits@vger.kernel.org>; Thu,  6 Feb 2025 23:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738884021; cv=none; b=cyorkc/9Y+DG0UtilM4A5wl74K4l0h6IGqRQ3qlBFdUBUmV9cjl2PD5u+RJJ1Ok7F/DNATqVfPUKeWbC0GWnc9S3FEDiAkxF8ugXcQ4k/vrVJ4fgLynaBcALOuPZ4CnftNX1uf7SsNuimp64FYTRXf+0qlrw57Ll49DGn1jDAoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738884021; c=relaxed/simple;
	bh=1JXjCNXfXeMJ5dZoDMxgocXQ22YEn3+By/XzKuEcyrc=;
	h=Date:To:From:Subject:Message-Id; b=NDVuBjHUYVqvQ0unL+65gkYP25aswXvEkbVLtPJ/d0N/zUXeA4+MxCe+HwKL3Qo/vw0pPlQ6HAM5VEerjk0a7kZtLRKUy0jcX3DC+6T5H4caN7xFlK5Vudnkmam4Zt0N7q/T5Dbn9YCsXFLCqJKkg2nqXjXzNBMhKWHOm9nTuEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=10KqGrYr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="10KqGrYr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821C9C4CEDD;
	Thu,  6 Feb 2025 23:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738884021;
	bh=1JXjCNXfXeMJ5dZoDMxgocXQ22YEn3+By/XzKuEcyrc=;
	h=Date:To:From:Subject:From;
	b=10KqGrYrqYqbVu9b3YT3EqlKb+it9SQoV/01nMdnt1Jb/0+0K87hn2kMJuYwvMlCh
	 IhE2dJmkP3v+7MFj56sssCuMAaf+1p3ZZWqH5F6LVM72cU3fcoD4jWe6drzhfDativ
	 g6SDCwwOTANzsLribYRaEYEoJJuV0XHEoQndIJ8M=
Date: Thu, 06 Feb 2025 15:20:20 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yaozhenguo1@gmail.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,gor@linux.ibm.com,dave.hansen@linux.intel.com,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-introduce-interface-for-early-reservations.patch added to mm-unstable branch
Message-Id: <20250206232021.821C9C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/cma: introduce interface for early reservations
has been added to the -mm mm-unstable branch.  Its filename is
     mm-cma-introduce-interface-for-early-reservations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-introduce-interface-for-early-reservations.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Frank van der Linden <fvdl@google.com>
Subject: mm/cma: introduce interface for early reservations
Date: Thu, 6 Feb 2025 18:51:05 +0000

It can be desirable to reserve memory in a CMA area before it is
activated, early in boot.  Such reservations would effectively be memblock
allocations, but they can be returned to the CMA area later.  This
functionality can be used to allow hugetlb bootmem allocations from a
hugetlb CMA area.

A new interface, cma_reserve_early is introduced.  This allows for
pageblock-aligned reservations.  These reservations are skipped during the
initial handoff of pages in a CMA area to the buddy allocator.  The caller
is responsible for making sure that the page structures are set up, and
that the migrate type is set correctly, as with other memblock allocations
that stick around.  If the CMA area fails to activate (because it
intersects with multiple zones), the reserved memory is not given to the
buddy allocator, the caller needs to take care of that.

Link: https://lkml.kernel.org/r/20250206185109.1210657-26-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zhenguo Yao <yaozhenguo1@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c      |   83 +++++++++++++++++++++++++++++++++++++++++++-----
 mm/cma.h      |    8 ++++
 mm/internal.h |   16 +++++++++
 mm/mm_init.c  |    9 +++++
 4 files changed, 109 insertions(+), 7 deletions(-)

--- a/mm/cma.c~mm-cma-introduce-interface-for-early-reservations
+++ a/mm/cma.c
@@ -144,9 +144,10 @@ bool cma_validate_zones(struct cma *cma)
 
 static void __init cma_activate_area(struct cma *cma)
 {
-	unsigned long pfn, base_pfn;
+	unsigned long pfn, end_pfn;
 	int allocrange, r;
 	struct cma_memrange *cmr;
+	unsigned long bitmap_count, count;
 
 	for (allocrange = 0; allocrange < cma->nranges; allocrange++) {
 		cmr = &cma->ranges[allocrange];
@@ -161,8 +162,13 @@ static void __init cma_activate_area(str
 
 	for (r = 0; r < cma->nranges; r++) {
 		cmr = &cma->ranges[r];
-		base_pfn = cmr->base_pfn;
-		for (pfn = base_pfn; pfn < base_pfn + cmr->count;
+		if (cmr->early_pfn != cmr->base_pfn) {
+			count = cmr->early_pfn - cmr->base_pfn;
+			bitmap_count = cma_bitmap_pages_to_bits(cma, count);
+			bitmap_set(cmr->bitmap, 0, bitmap_count);
+		}
+
+		for (pfn = cmr->early_pfn; pfn < cmr->base_pfn + cmr->count;
 		     pfn += pageblock_nr_pages)
 			init_cma_reserved_pageblock(pfn_to_page(pfn));
 	}
@@ -173,6 +179,7 @@ static void __init cma_activate_area(str
 	INIT_HLIST_HEAD(&cma->mem_head);
 	spin_lock_init(&cma->mem_head_lock);
 #endif
+	set_bit(CMA_ACTIVATED, &cma->flags);
 
 	return;
 
@@ -184,9 +191,8 @@ cleanup:
 	if (!test_bit(CMA_RESERVE_PAGES_ON_ERROR, &cma->flags)) {
 		for (r = 0; r < allocrange; r++) {
 			cmr = &cma->ranges[r];
-			for (pfn = cmr->base_pfn;
-			     pfn < cmr->base_pfn + cmr->count;
-			     pfn++)
+			end_pfn = cmr->base_pfn + cmr->count;
+			for (pfn = cmr->early_pfn; pfn < end_pfn; pfn++)
 				free_reserved_page(pfn_to_page(pfn));
 		}
 	}
@@ -290,6 +296,7 @@ int __init cma_init_reserved_mem(phys_ad
 		return ret;
 
 	cma->ranges[0].base_pfn = PFN_DOWN(base);
+	cma->ranges[0].early_pfn = PFN_DOWN(base);
 	cma->ranges[0].count = cma->count;
 	cma->nranges = 1;
 	cma->nid = NUMA_NO_NODE;
@@ -509,6 +516,7 @@ int __init cma_declare_contiguous_multi(
 		    nr, (u64)mlp->base, (u64)mlp->base + size);
 		cmrp = &cma->ranges[nr++];
 		cmrp->base_pfn = PHYS_PFN(mlp->base);
+		cmrp->early_pfn = cmrp->base_pfn;
 		cmrp->count = size >> PAGE_SHIFT;
 
 		sizeleft -= size;
@@ -540,7 +548,6 @@ out:
 		pr_info("Reserved %lu MiB in %d range%s\n",
 			(unsigned long)total_size / SZ_1M, nr,
 			nr > 1 ? "s" : "");
-
 	return ret;
 }
 
@@ -1034,3 +1041,65 @@ bool cma_intersects(struct cma *cma, uns
 
 	return false;
 }
+
+/*
+ * Very basic function to reserve memory from a CMA area that has not
+ * yet been activated. This is expected to be called early, when the
+ * system is single-threaded, so there is no locking. The alignment
+ * checking is restrictive - only pageblock-aligned areas
+ * (CMA_MIN_ALIGNMENT_BYTES) may be reserved through this function.
+ * This keeps things simple, and is enough for the current use case.
+ *
+ * The CMA bitmaps have not yet been allocated, so just start
+ * reserving from the bottom up, using a PFN to keep track
+ * of what has been reserved. Unreserving is not possible.
+ *
+ * The caller is responsible for initializing the page structures
+ * in the area properly, since this just points to memblock-allocated
+ * memory. The caller should subsequently use init_cma_pageblock to
+ * set the migrate type and CMA stats  the pageblocks that were reserved.
+ *
+ * If the CMA area fails to activate later, memory obtained through
+ * this interface is not handed to the page allocator, this is
+ * the responsibility of the caller (e.g. like normal memblock-allocated
+ * memory).
+ */
+void __init *cma_reserve_early(struct cma *cma, unsigned long size)
+{
+	int r;
+	struct cma_memrange *cmr;
+	unsigned long available;
+	void *ret = NULL;
+
+	if (!cma || !cma->count)
+		return NULL;
+	/*
+	 * Can only be called early in init.
+	 */
+	if (test_bit(CMA_ACTIVATED, &cma->flags))
+		return NULL;
+
+	if (!IS_ALIGNED(size, CMA_MIN_ALIGNMENT_BYTES))
+		return NULL;
+
+	if (!IS_ALIGNED(size, (PAGE_SIZE << cma->order_per_bit)))
+		return NULL;
+
+	size >>= PAGE_SHIFT;
+
+	if (size > cma->available_count)
+		return NULL;
+
+	for (r = 0; r < cma->nranges; r++) {
+		cmr = &cma->ranges[r];
+		available = cmr->count - (cmr->early_pfn - cmr->base_pfn);
+		if (size <= available) {
+			ret = phys_to_virt(PFN_PHYS(cmr->early_pfn));
+			cmr->early_pfn += size;
+			cma->available_count -= size;
+			return ret;
+		}
+	}
+
+	return ret;
+}
--- a/mm/cma.h~mm-cma-introduce-interface-for-early-reservations
+++ a/mm/cma.h
@@ -16,9 +16,16 @@ struct cma_kobject {
  * and the total amount of memory requested, while smaller than the total
  * amount of memory available, is large enough that it doesn't fit in a
  * single physical memory range because of memory holes.
+ *
+ * Fields:
+ *   @base_pfn: physical address of range
+ *   @early_pfn: first PFN not reserved through cma_reserve_early
+ *   @count: size of range
+ *   @bitmap: bitmap of allocated (1 << order_per_bit)-sized chunks.
  */
 struct cma_memrange {
 	unsigned long base_pfn;
+	unsigned long early_pfn;
 	unsigned long count;
 	unsigned long *bitmap;
 #ifdef CONFIG_CMA_DEBUGFS
@@ -58,6 +65,7 @@ enum cma_flags {
 	CMA_RESERVE_PAGES_ON_ERROR,
 	CMA_ZONES_VALID,
 	CMA_ZONES_INVALID,
+	CMA_ACTIVATED,
 };
 
 extern struct cma cma_areas[MAX_CMA_AREAS];
--- a/mm/internal.h~mm-cma-introduce-interface-for-early-reservations
+++ a/mm/internal.h
@@ -846,6 +846,22 @@ void init_cma_reserved_pageblock(struct
 
 #endif /* CONFIG_COMPACTION || CONFIG_CMA */
 
+struct cma;
+
+#ifdef CONFIG_CMA
+void *cma_reserve_early(struct cma *cma, unsigned long size);
+void init_cma_pageblock(struct page *page);
+#else
+static inline void *cma_reserve_early(struct cma *cma, unsigned long size)
+{
+	return NULL;
+}
+static inline void init_cma_pageblock(struct page *page)
+{
+}
+#endif
+
+
 int find_suitable_fallback(struct free_area *area, unsigned int order,
 			int migratetype, bool only_stealable, bool *can_steal);
 
--- a/mm/mm_init.c~mm-cma-introduce-interface-for-early-reservations
+++ a/mm/mm_init.c
@@ -2276,6 +2276,15 @@ void __init init_cma_reserved_pageblock(
 	adjust_managed_page_count(page, pageblock_nr_pages);
 	page_zone(page)->cma_pages += pageblock_nr_pages;
 }
+/*
+ * Similar to above, but only set the migrate type and stats.
+ */
+void __init init_cma_pageblock(struct page *page)
+{
+	set_pageblock_migratetype(page, MIGRATE_CMA);
+	adjust_managed_page_count(page, pageblock_nr_pages);
+	page_zone(page)->cma_pages += pageblock_nr_pages;
+}
 #endif
 
 void set_zone_contiguous(struct zone *zone)
_

Patches currently in -mm which might be from fvdl@google.com are

mm-cma-export-total-and-free-number-of-pages-for-cma-areas.patch
mm-cma-support-multiple-contiguous-ranges-if-requested.patch
mm-cma-introduce-cma_intersects-function.patch
mm-hugetlb-use-cma_declare_contiguous_multi.patch
mm-hugetlb-fix-round-robin-bootmem-allocation.patch
mm-hugetlb-remove-redundant-__clearpagereserved.patch
mm-hugetlb-use-online-nodes-for-bootmem-allocation.patch
mm-hugetlb-convert-cmdline-parameters-from-setup-to-early.patch
x86-mm-make-register_page_bootmem_memmap-handle-pte-mappings.patch
mm-bootmem_info-export-register_page_bootmem_memmap.patch
mm-sparse-allow-for-alternate-vmemmap-section-init-at-boot.patch
mm-hugetlb-set-migratetype-for-bootmem-folios.patch
mm-define-__init_reserved_page_zone-function.patch
mm-hugetlb-check-bootmem-pages-for-zone-intersections.patch
mm-sparse-add-vmemmap__hvo-functions.patch
mm-hugetlb-deal-with-multiple-calls-to-hugetlb_bootmem_alloc.patch
mm-hugetlb-move-huge_boot_pages-list-init-to-hugetlb_bootmem_alloc.patch
mm-hugetlb-add-pre-hvo-framework.patch
mm-hugetlb_vmemmap-fix-hugetlb_vmemmap_restore_folios-definition.patch
mm-hugetlb-do-pre-hvo-for-bootmem-allocated-pages.patch
x86-setup-call-hugetlb_bootmem_alloc-early.patch
x86-mm-set-arch_want_sparsemem_vmemmap_preinit.patch
mm-cma-simplify-zone-intersection-check.patch
mm-cma-introduce-a-cma-validate-function.patch
mm-cma-introduce-interface-for-early-reservations.patch
mm-hugetlb-add-hugetlb_cma_only-cmdline-option.patch
mm-hugetlb-enable-bootmem-allocation-from-cma-areas.patch
mm-hugetlb-move-hugetlb-cma-code-in-to-its-own-file.patch

