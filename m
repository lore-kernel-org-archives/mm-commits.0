Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE87B49E134
	for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 23:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789081250; cv=none; b=HaRI+3EDNHnlUqxaUNMbXeLJdjIpzEYKXWI3ByGwGg4ndgQo3CqPLx3EN1nwurLuNwUgWr5ZD9djWgwm5q8ltzCtiCdKDcacvfZ3dBHMhFmMPrRWhfja+blihzYeS4h5nd+u6lzL2+4M6Ca2S8JRi9jmzkB7rX4kbKTTn99HOUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789081250; c=relaxed/simple;
	bh=gtg5XyAKz/TBVroeDgx77ieHTRPPTP4RY003jFBbGE0=;
	h=Date:To:From:Subject:Message-Id; b=gHxh42mTvtxG4r7m2qewR2gHAwY8PVj9R+76OyaoBNzs/L9w5/av9Pd6ojY1xPlxkYcgC8rjKqCIT6VQ9APD899G693NhKGDL4VVqeAQ+Ncc8ONGlQcjRlxwrzHya6RbOAzL2V/OZbZa+qfk1ZpEMBPS9L2rIJUhfWc9wDIMkFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GXXoufhp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GXXoufhp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B1E1F000FF;
	Thu, 10 Sep 2026 23:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789081248;
	bh=5YKOXJTRB7Ibau2iiKCDgRM7a3OtSIlDeJXl624DAlY=;
	h=Date:To:From:Subject;
	b=GXXoufhp6uIQRF8u73IglPN6ii6szn6Uon1rpLWFsS3KSeGbXwR+NgB1tv/krOc+n
	 48iVnbkm5ct/V/LN+S1bIf4GU3lRted6jDEiY3i1Jk0nwtPJ/qkwOSv6y7UIKMYHNR
	 Ezb7JBckFJCiB3oLj8ayu09NBihDUjkHXIBf0p7E=
Date: Thu, 10 Sep 2026 16:00:48 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-sparse-vmemmap-support-section-based-vmemmap-optimization.patch removed from -mm tree
Message-Id: <20260910230048.B2B1E1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse-vmemmap: support section-based vmemmap optimization
has been removed from the -mm tree.  Its filename was
     mm-sparse-vmemmap-support-section-based-vmemmap-optimization.patch

This patch was dropped because an updated version will be issued

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

mm-sparse-initialize-memory-sections-earlier.patch
mm-hugetlb-switch-hugetlb-to-section-based-vmemmap-optimization.patch
mm-sparse-vmemmap-remove-sparsemem_vmemmap_preinit-support.patch
mm-sparse-inline-usemap-allocation-into-sparse_init_nid.patch
mm-sparse-remove-section_map_size.patch
mm-hugetlb-remove-huge_bootmem_hvo.patch
mm-hugetlb-remove-huge_bootmem_cma.patch
mm-hugetlb-localize-struct-huge_bootmem_page.patch
mm-hugetlb-localize-huge_bootmem_zones_valid.patch
mm-sparse-vmemmap-introduce-config_sparsemem_vmemmap_optimization.patch
mm-sparse-vmemmap-factor-out-shared-vmemmap-tail-page-allocation.patch
mm-sparse-vmemmap-open-code-init_compound_tail.patch
mm-sparse-vmemmap-prepare-dax-vmemmap-population-for-section-orders.patch
mm-sparse-vmemmap-set-section-order-for-device-dax.patch
mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages.patch
mm-sparse-vmemmap-move-hvo-helpers-to-a-public-header.patch
powerpc-mm-switch-device-dax-to-shared-tail-vmemmap-pages.patch
mm-sparse-vmemmap-drop-the-extra-tail-page-from-device-dax-reservation.patch
mm-sparse-vmemmap-drop-unused-section_nr_vmemmap_pages-arguments.patch
documentation-mm-update-dax-vmemmap-deduplication-docs.patch

