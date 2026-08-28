Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92E73B27FF
	for <mm-commits@vger.kernel.org>; Fri, 28 Aug 2026 04:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787890888; cv=none; b=D8sNllzElSWsiv2BZ5NmdUA0e0buVy7/vwOvlPVyic6A97sAedRdSmHF8yFpqC6fpF0fcMSq0kZNcFPvUC/wuN/jp/UV3tUPevabh+MHx0YCC+cTKPEJN3wrgI7bY9t7ke+LDQHNu8vf8W5jKjbGzZJyJL6biDjAppdzE6tnIxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787890888; c=relaxed/simple;
	bh=Nk+Q4sfhGyd4X5NXWGx13a6CHtpzb4EIeSdXb3+ArOg=;
	h=Date:To:From:Subject:Message-Id; b=P31fh4XF3S8FjLZushC+MCF73sB1qy9b5J8yRDAOXTTaB14FZi2u77XOZxwQWZbTalYTSV1IovgWlhC9TiV7oUI9ug5sQY4ClLlINC8C2y8CnJnni6GKvbGxLeq5FsLSdA/MVeUNSpeUen/Vd3QaHZkw5KfEYB4SPf43TNll6Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y9IEXQi/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y9IEXQi/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 339EE1F000E9;
	Fri, 28 Aug 2026 04:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787890886;
	bh=/qpiyXBiZWTQ5BTdwVzfazsPy6/37BTWiF+WqMmqH2c=;
	h=Date:To:From:Subject;
	b=y9IEXQi/4jqssErOb7uC9pZn6ghwreutMNPr/ctlvifsilvlWInKvK2tNEb1kU6g/
	 gWb7WH2SOV/h3DaAPTaznHipjcZ86YV1XUZJdcxnvR9M/0aMEfzqdfyyEsiQMWj+Lf
	 VnmicDKzuK3oaIPdPtwRGsoqm15XBvH9mck9uEWU=
Date: Thu, 27 Aug 2026 21:21:25 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-vmemmap-move-helpers-ahead-of-future-callers.patch added to mm-new branch
Message-Id: <20260828042126.339EE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/sparse-vmemmap: move helpers ahead of future callers
has been added to the -mm mm-new branch.  Its filename is
     mm-sparse-vmemmap-move-helpers-ahead-of-future-callers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-vmemmap-move-helpers-ahead-of-future-callers.patch

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
Subject: mm/sparse-vmemmap: move helpers ahead of future callers
Date: Tue, 25 Aug 2026 16:45:58 +0800

Prepare for section-based vmemmap optimization by moving helpers that
follow-up changes will use.  vmemmap_get_tail() will be called from the
PTE population path.  section_nr_vmemmap_pages() will be made visible
outside the memory hotplug code and called from sparse_init_nid().

Move vmemmap_alloc_block_zero() together with vmemmap_get_tail(), since
the tail helper depends on it.  Move section_nr_vmemmap_pages() earlier
into its own CONFIG_MEMORY_HOTPLUG block.  That lets the later patch
change its visibility and callers without also moving the function body.

No functional change is intended.

Link: https://lore.kernel.org/20260825084608.47437-8-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse-vmemmap.c |  134 +++++++++++++++++++++---------------------
 1 file changed, 69 insertions(+), 65 deletions(-)

--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-move-helpers-ahead-of-future-callers
+++ a/mm/sparse-vmemmap.c
@@ -148,6 +148,75 @@ void __meminit vmemmap_verify(pte_t *pte
 			start, end - 1);
 }
 
+#ifdef CONFIG_MEMORY_HOTPLUG
+static int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+{
+	const struct mem_section *ms = __pfn_to_section(pfn);
+	const int order = pgmap ? pgmap->vmemmap_shift : section_order(ms);
+	const int vmemmap_pages = pgmap ? VMEMMAP_RESERVE_NR : VMEMMAP_OPTIMIZATION_PAGES;
+	const unsigned long pages_per_compound = 1UL << order;
+
+	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION));
+	VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);
+
+	if (!vmemmap_can_optimize(altmap, pgmap) && !section_vmemmap_optimizable(ms))
+		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
+
+	if (order < PFN_SECTION_SHIFT) {
+		VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_compound));
+		return vmemmap_pages * nr_pages / pages_per_compound;
+	}
+
+	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
+
+	if (IS_ALIGNED(pfn, pages_per_compound))
+		return vmemmap_pages;
+
+	return 0;
+}
+#endif
+
+static void * __meminit vmemmap_alloc_block_zero(unsigned long size, int node)
+{
+	void *p = vmemmap_alloc_block(size, node);
+
+	if (!p)
+		return NULL;
+	memset(p, 0, size);
+
+	return p;
+}
+
+#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
+{
+	struct page *p, *tail;
+	unsigned int idx;
+	int node = zone_to_nid(zone);
+
+	if (WARN_ON_ONCE(order < VMEMMAP_OPTIMIZATION_MIN_ORDER))
+		return NULL;
+	if (WARN_ON_ONCE(order > MAX_FOLIO_ORDER))
+		return NULL;
+
+	idx = order - VMEMMAP_OPTIMIZATION_MIN_ORDER;
+	tail = zone->vmemmap_tails[idx];
+	if (tail)
+		return tail;
+	p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
+	if (!p)
+		return NULL;
+	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
+		init_compound_tail(p + i, NULL, order, zone);
+
+	tail = virt_to_page(p);
+	zone->vmemmap_tails[idx] = tail;
+
+	return tail;
+}
+#endif
+
 static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
 				       struct vmem_altmap *altmap,
 				       unsigned long ptpfn, unsigned long flags)
@@ -181,17 +250,6 @@ static pte_t * __meminit vmemmap_pte_pop
 	return pte;
 }
 
-static void * __meminit vmemmap_alloc_block_zero(unsigned long size, int node)
-{
-	void *p = vmemmap_alloc_block(size, node);
-
-	if (!p)
-		return NULL;
-	memset(p, 0, size);
-
-	return p;
-}
-
 static pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
 {
 	pmd_t *pmd = pmd_offset(pud, addr);
@@ -323,33 +381,6 @@ void vmemmap_wrprotect_hvo(unsigned long
 }
 
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
-static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
-{
-	struct page *p, *tail;
-	unsigned int idx;
-	int node = zone_to_nid(zone);
-
-	if (WARN_ON_ONCE(order < VMEMMAP_OPTIMIZATION_MIN_ORDER))
-		return NULL;
-	if (WARN_ON_ONCE(order > MAX_FOLIO_ORDER))
-		return NULL;
-
-	idx = order - VMEMMAP_OPTIMIZATION_MIN_ORDER;
-	tail = zone->vmemmap_tails[idx];
-	if (tail)
-		return tail;
-	p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
-	if (!p)
-		return NULL;
-	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
-		init_compound_tail(p + i, NULL, order, zone);
-
-	tail = virt_to_page(p);
-	zone->vmemmap_tails[idx] = tail;
-
-	return tail;
-}
-
 int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
 				       unsigned int order, struct zone *zone,
 				       unsigned long headsize)
@@ -646,33 +677,6 @@ void offline_mem_sections(unsigned long
 	}
 }
 
-static int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
-{
-	const struct mem_section *ms = __pfn_to_section(pfn);
-	const int order = pgmap ? pgmap->vmemmap_shift : section_order(ms);
-	const int vmemmap_pages = pgmap ? VMEMMAP_RESERVE_NR : VMEMMAP_OPTIMIZATION_PAGES;
-	const unsigned long pages_per_compound = 1UL << order;
-
-	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION));
-	VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);
-
-	if (!vmemmap_can_optimize(altmap, pgmap) && !section_vmemmap_optimizable(ms))
-		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
-
-	if (order < PFN_SECTION_SHIFT) {
-		VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_compound));
-		return vmemmap_pages * nr_pages / pages_per_compound;
-	}
-
-	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
-
-	if (IS_ALIGNED(pfn, pages_per_compound))
-		return vmemmap_pages;
-
-	return 0;
-}
-
 static struct page * __meminit populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap)
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-sparse-relax-struct-mem_section-size-constraints.patch
mm-sparse-vmemmap-rename-hvo-order-macros.patch
mm-mm_init-skip-initializing-shared-vmemmap-tail-pages.patch
mm-sparse-vmemmap-initialize-shared-tail-vmemmap-pages-on-allocation.patch
mm-sparse-vmemmap-support-section-based-vmemmap-accounting.patch
mm-mm_init-factor-out-pfn_to_zone.patch
mm-sparse-vmemmap-move-helpers-ahead-of-future-callers.patch
mm-sparse-vmemmap-support-section-based-vmemmap-optimization.patch
mm-sparse-initialize-memory-sections-earlier.patch
mm-hugetlb-switch-hugetlb-to-section-based-vmemmap-optimization.patch
mm-sparse-vmemmap-remove-sparsemem_vmemmap_preinit-support.patch
mm-sparse-inline-usemap-allocation-into-sparse_init_nid.patch
mm-sparse-remove-section_map_size.patch
mm-hugetlb-remove-huge_bootmem_hvo.patch
mm-hugetlb-remove-huge_bootmem_cma.patch
mm-hugetlb-localize-struct-huge_bootmem_page.patch
mm-hugetlb-localize-huge_bootmem_zones_valid.patch

