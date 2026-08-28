Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B7C2F5337
	for <mm-commits@vger.kernel.org>; Fri, 28 Aug 2026 04:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787890890; cv=none; b=E0QSgDT/tAFylr5ApcPh20L9A3yrONEUctqIlHSK21pHgne5i+rHKKyYYelbOmT/ggTmD6BiTRSEetTFvZcaQf70IRxCT2YZlZeLn8AuNjEbsCquhAfpzHYXw5PLhZ3Cw18U3Dpj+vBzNhvFkOqtWAyb9CP7VQeUSMJt+2my0F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787890890; c=relaxed/simple;
	bh=BKVfWIvp25+/PI1aYotxGYiaPPh9g6TZDnqRroPvFco=;
	h=Date:To:From:Subject:Message-Id; b=d1IhOFI8JByks36fyvL9/3Lpq0O5aMY5bUpu684rPOqtE7ibazH7RwrHUaOgFYroufE34kTmVwwPeh6DIsSgvJcvlRfEx4VtnhpMU5nE2/c2mpCtgkqiZsZI8Pg+XWeS4rLB/wPxvQKJYfswxdtGL8oHRmjbr16bqjjgk0osook=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ANaQfUdn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ANaQfUdn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 604931F00A3A;
	Fri, 28 Aug 2026 04:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787890888;
	bh=hVz1TI3yFQZYmLUZ5TyAIAJmV8fqgao1CVrVMxbiBrg=;
	h=Date:To:From:Subject;
	b=ANaQfUdnErpWBmPNpiH+K9SMThvGtx9UPsHnO8qjb7SMzT/RZdocsac4dQy9ujcBH
	 EGd/4wEUnJ+V2nHcm13HlVoK58gHpc5I2lrTzRtfbyyrrsgmoQeSZ1StpRL0GpWDor
	 be97Qt4Av/dZY2+ZvPtrVJZPSgT1Nwxy7kAIIhd0=
Date: Thu, 27 Aug 2026 21:21:27 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-vmemmap-support-section-based-vmemmap-optimization.patch added to mm-new branch
Message-Id: <20260828042128.604931F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/sparse-vmemmap: support section-based vmemmap optimization
has been added to the -mm mm-new branch.  Its filename is
     mm-sparse-vmemmap-support-section-based-vmemmap-optimization.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-vmemmap-support-section-based-vmemmap-optimization.patch

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
Subject: mm/sparse-vmemmap: support section-based vmemmap optimization
Date: Tue, 25 Aug 2026 16:45:59 +0800

Teach sparse-vmemmap population code to use the compound page order when
deciding whether a vmemmap page can be optimized.

With this information, the common sparse-vmemmap population path can
allocate or reuse shared tail vmemmap pages directly instead of relying on
HugeTLB-specific handling.

This centralizes vmemmap optimization logic in the sparse-vmemmap code,
based on section metadata, and prepares for sharing the same mechanism
across different users of vmemmap optimization, including HugeTLB and DAX.

Link: https://lore.kernel.org/20260825084608.47437-9-songmuchun@bytedance.com
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

 mm/sparse-vmemmap.c |   46 ++++++++++++++++++++++++++++++++++--------
 mm/sparse.c         |    4 +--
 mm/sparse.h         |    7 ++++++
 3 files changed, 47 insertions(+), 10 deletions(-)

--- a/mm/sparse.c~mm-sparse-vmemmap-support-section-based-vmemmap-optimization
+++ a/mm/sparse.c
@@ -305,8 +305,8 @@ static void __init sparse_init_nid(int n
 							nid, NULL, NULL);
 			if (!map)
 				panic("Failed to allocate memmap for section %lu\n", pnum);
-			memmap_boot_pages_add(DIV_ROUND_UP(PAGES_PER_SECTION * sizeof(struct page),
-							   PAGE_SIZE));
+			memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
+								       NULL, NULL));
 			sparse_init_early_section(nid, map, pnum, 0);
 		}
 	}
--- a/mm/sparse.h~mm-sparse-vmemmap-support-section-based-vmemmap-optimization
+++ a/mm/sparse.h
@@ -111,8 +111,15 @@ static inline void sparse_init(void) {}
  */
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 void sparse_init_subsection_map(void);
+int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
 #else
 static inline void sparse_init_subsection_map(void) {}
+static inline int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+{
+	return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
+}
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
 #endif /* __MM_SPARSE_H */
--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-support-section-based-vmemmap-optimization
+++ a/mm/sparse-vmemmap.c
@@ -148,8 +148,7 @@ void __meminit vmemmap_verify(pte_t *pte
 			start, end - 1);
 }
 
-#ifdef CONFIG_MEMORY_HOTPLUG
-static int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
+int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
 		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	const struct mem_section *ms = __pfn_to_section(pfn);
@@ -175,7 +174,6 @@ static int __meminit section_nr_vmemmap_
 
 	return 0;
 }
-#endif
 
 static void * __meminit vmemmap_alloc_block_zero(unsigned long size, int node)
 {
@@ -215,19 +213,44 @@ static __meminit struct page *vmemmap_ge
 
 	return tail;
 }
+#else
+static inline struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
+{
+	return NULL;
+}
 #endif
 
+static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
+					 struct vmem_altmap *altmap)
+{
+	struct zone *zone;
+	struct page *page;
+	const unsigned int order = pfn_to_section_order(pfn);
+
+	if (!vmemmap_optimizable_pfn(pfn))
+		return vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
+
+	zone = pfn_to_zone(pfn, node);
+	page = vmemmap_get_tail(order, zone);
+	if (!page)
+		return NULL;
+
+	return page_address(page);
+}
+
 static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
 				       struct vmem_altmap *altmap,
 				       unsigned long ptpfn, unsigned long flags)
 {
 	pte_t *pte = pte_offset_kernel(pmd, addr);
+	unsigned long pfn = page_to_pfn((struct page *)addr);
+
 	if (pte_none(ptep_get(pte))) {
 		pte_t entry;
-		void *p;
 
 		if (ptpfn == (unsigned long)-1) {
-			p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
+			void *p = vmemmap_alloc_pte(pfn, node, altmap);
+
 			if (!p)
 				return NULL;
 			ptpfn = PHYS_PFN(__pa(p));
@@ -246,7 +269,8 @@ static pte_t * __meminit vmemmap_pte_pop
 		}
 		entry = pfn_pte(ptpfn, PAGE_KERNEL);
 		set_pte_at(&init_mm, addr, pte, entry);
-	}
+	} else if (WARN_ON_ONCE(vmemmap_optimizable_pfn(pfn)))
+		return NULL;
 	return pte;
 }
 
@@ -435,6 +459,9 @@ int __meminit vmemmap_populate_hugepages
 	pmd_t *pmd;
 
 	for (addr = start; addr < end; addr = next) {
+		unsigned long pfn = page_to_pfn((struct page *)addr);
+		const struct mem_section *ms = __pfn_to_section(pfn);
+
 		next = pmd_addr_end(addr, end);
 
 		pgd = vmemmap_pgd_populate(addr, node);
@@ -450,7 +477,7 @@ int __meminit vmemmap_populate_hugepages
 			return -ENOMEM;
 
 		pmd = pmd_offset(pud, addr);
-		if (pmd_none(pmdp_get(pmd))) {
+		if (pmd_none(pmdp_get(pmd)) && !section_vmemmap_optimizable(ms)) {
 			void *p;
 
 			p = vmemmap_alloc_block_buf(PMD_SIZE, node, altmap);
@@ -468,8 +495,11 @@ int __meminit vmemmap_populate_hugepages
 				 */
 				return -ENOMEM;
 			}
-		} else if (vmemmap_check_pmd(pmd, node, addr, next))
+		} else if (vmemmap_check_pmd(pmd, node, addr, next)) {
+			if (WARN_ON_ONCE(section_vmemmap_optimizable(ms)))
+				return -EOPNOTSUPP;
 			continue;
+		}
 		if (vmemmap_populate_basepages(addr, next, node, altmap))
 			return -ENOMEM;
 	}
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

