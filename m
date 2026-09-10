Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5D1379980
	for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 23:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789081253; cv=none; b=nZ0IQdFUIci56VVlJrGTyRMBneCk/E3TD8mmYMT44Gn/K2yWh7Gm+ZbuPjbrUR8JeL9rRHOefTTNE/UC38V847QpNvK0r8ZWgPwqHBBOKF4hbTzQb40balF0+xnxTOyrmqPcb6b7rxbBiXYunXpgOnrilB7HNELygl/xutXR9ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789081253; c=relaxed/simple;
	bh=uLjWagex9ZNrIy5YxRK1LcTxQK8Hlkz8u8hVfh2RaTs=;
	h=Date:To:From:Subject:Message-Id; b=tlDNGFCeCZft1iGHfKjHMTyhIaFUJnerDwyRuuSEU6ZbTajGNPh/IHbE59Y9YnirK076jyH8t91nS1p9tgKwMvwIPcTECLlRxvnarXNQgVUoKAlG4WBQk7cACHZm0TJWZ4O1t5JEzrYznXmUsHRLKyiSp28WVaU2cgGpewBLOSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D2GreLxb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D2GreLxb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3068D1F000FF;
	Thu, 10 Sep 2026 23:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789081251;
	bh=yAUZdD4tgefS+ELKVh/9wckEM4YUr0RebPlhph2VTr8=;
	h=Date:To:From:Subject;
	b=D2GreLxbO+r7nxOJLt1VjeJQOZItWzkT2GnOQGfTEO8/Z8HiSrbfQuiEo1s01CoUj
	 gwT6EnHjbEz36fpDyfMpd9jq65cYcYGvjynXJWCebfUs7SFLZ5o1cjCPrXF5pkqFur
	 Z7TerDv2/XuKDgQnlsXU3hK6WIKoqK/E6H3qU87s=
Date: Thu, 10 Sep 2026 16:00:50 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hugetlb-switch-hugetlb-to-section-based-vmemmap-optimization.patch removed from -mm tree
Message-Id: <20260910230051.3068D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: switch HugeTLB to section-based vmemmap optimization
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-switch-hugetlb-to-section-based-vmemmap-optimization.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/hugetlb: switch HugeTLB to section-based vmemmap optimization
Date: Tue, 25 Aug 2026 16:46:01 +0800

HugeTLB bootmem vmemmap optimization still carries its own early setup
path, including pre-populating optimized mappings before the generic
sparse-vmemmap code runs.

Now that the section-based vmemmap optimization can derive HugeTLB vmemmap
deduplication from section metadata, HugeTLB only needs to mark the
bootmem huge page range with the appropriate order.  The generic
sparse-vmemmap population path can then allocate and map the shared tail
vmemmap pages without any HugeTLB-specific early population code.

Do that by setting the section order when a bootmem huge page is allocated
and dropping the dedicated pre-HVO helpers and related special-casing.

This removes duplicate early setup logic and switches HugeTLB to the
section-based vmemmap optimization path.

Link: https://lore.kernel.org/20260825084608.47437-11-songmuchun@bytedance.com
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

 include/linux/hugetlb.h |    1 
 include/linux/mm.h      |    3 -
 mm/hugetlb.c            |   30 +-----------
 mm/hugetlb_vmemmap.c    |   90 ++------------------------------------
 mm/hugetlb_vmemmap.h    |   14 ++---
 mm/sparse-vmemmap.c     |   31 -------------
 mm/sparse.h             |   27 +++++++++++
 7 files changed, 42 insertions(+), 154 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-switch-hugetlb-to-section-based-vmemmap-optimization
+++ a/include/linux/hugetlb.h
@@ -171,7 +171,6 @@ struct address_space *hugetlb_folio_mapp
 
 extern int movable_gigantic_pages __read_mostly;
 extern int sysctl_hugetlb_shm_group __read_mostly;
-extern struct list_head huge_boot_pages[MAX_NUMNODES];
 
 void hugetlb_bootmem_struct_page_init(void);
 void hugetlb_bootmem_alloc(void);
--- a/include/linux/mm.h~mm-hugetlb-switch-hugetlb-to-section-based-vmemmap-optimization
+++ a/include/linux/mm.h
@@ -5159,9 +5159,6 @@ int vmemmap_populate_hugepages(unsigned
 			       int node, struct vmem_altmap *altmap);
 int vmemmap_populate(unsigned long start, unsigned long end, int node,
 		struct vmem_altmap *altmap);
-int vmemmap_populate_hvo(unsigned long start, unsigned long end,
-			 unsigned int order, struct zone *zone,
-			 unsigned long headsize);
 void vmemmap_wrprotect_hvo(unsigned long start, unsigned long end, int node,
 			  unsigned long headsize);
 void vmemmap_populate_print_last(void);
--- a/mm/hugetlb.c~mm-hugetlb-switch-hugetlb-to-section-based-vmemmap-optimization
+++ a/mm/hugetlb.c
@@ -52,6 +52,7 @@
 #include "hugetlb_cma.h"
 #include "hugetlb_internal.h"
 #include "mm_init.h"
+#include "sparse.h"
 #include <linux/page-isolation.h>
 
 int hugetlb_max_hstate __read_mostly;
@@ -59,7 +60,7 @@ unsigned int default_hstate_idx;
 struct hstate hstates[HUGE_MAX_HSTATE];
 
 __initdata nodemask_t hugetlb_bootmem_nodes;
-__initdata struct list_head huge_boot_pages[MAX_NUMNODES];
+static struct list_head huge_boot_pages[MAX_NUMNODES] __initdata;
 
 /*
  * Due to ordering constraints across the init code for various
@@ -3161,6 +3162,7 @@ static bool __init alloc_bootmem_huge_pa
 	} else {
 		list_add_tail(&m->list, &huge_boot_pages[nid]);
 		m->flags |= HUGE_BOOTMEM_ZONES_VALID;
+		hugetlb_vmemmap_optimize_bootmem_page(m);
 		/*
 		 * Only initialize the head struct page in memmap_init_reserved_pages,
 		 * rest of the struct pages will be initialized by the HugeTLB
@@ -3321,6 +3323,7 @@ static void __init gather_bootmem_preall
 			 * this folio.
 			 */
 			folio_set_hugetlb_vmemmap_optimized(folio);
+		section_set_order_range(folio_pfn(folio), folio_nr_pages(folio), 0);
 
 		if (hugetlb_bootmem_page_earlycma(m))
 			folio_set_hugetlb_cma(folio);
@@ -3364,31 +3367,6 @@ void __init hugetlb_bootmem_struct_page_
 		.max_threads	= num_node_state(N_MEMORY),
 		.numa_aware	= true,
 	};
-#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
-	struct zone *zone;
-
-	for_each_zone(zone) {
-		for (int i = 0; i < VMEMMAP_OPTIMIZATION_NR_ORDERS; i++) {
-			struct page *tail, *p;
-			unsigned int order;
-
-			tail = zone->vmemmap_tails[i];
-			if (!tail)
-				continue;
-
-			order = i + VMEMMAP_OPTIMIZATION_MIN_ORDER;
-			p = page_to_virt(tail);
-			/*
-			 * prep_and_add_bootmem_folios() can access pageblock
-			 * flags on bootmem HugeTLB pages, so initialize the
-			 * shared tail struct pages here before bootmem folios
-			 * start using them.
-			 */
-			for (int j = 0; j < PAGE_SIZE / sizeof(struct page); j++)
-				init_compound_tail(p + j, NULL, order, zone);
-		}
-	}
-#endif
 
 	padata_do_multithreaded(&job);
 }
--- a/mm/hugetlb_vmemmap.c~mm-hugetlb-switch-hugetlb-to-section-based-vmemmap-optimization
+++ a/mm/hugetlb_vmemmap.c
@@ -18,8 +18,7 @@
 
 #include <asm/tlbflush.h>
 #include "hugetlb_vmemmap.h"
-#include "internal.h"
-#include "mm_init.h"
+#include "sparse.h"
 
 /**
  * struct vmemmap_remap_walk - walk vmemmap page table
@@ -706,95 +705,18 @@ void hugetlb_vmemmap_optimize_bootmem_fo
 	__hugetlb_vmemmap_optimize_folios(h, folio_list, true);
 }
 
-#ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
-
-/* Return true of a bootmem allocated HugeTLB page should be pre-HVO-ed */
-static bool vmemmap_should_optimize_bootmem_page(struct huge_bootmem_page *m)
+void __init hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m)
 {
-	unsigned long section_size, psize, pmd_vmemmap_size;
-	phys_addr_t paddr;
-
-	if (!READ_ONCE(vmemmap_optimize_enabled))
-		return false;
-
-	if (!hugetlb_vmemmap_optimizable(m->hstate))
-		return false;
-
-	psize = huge_page_size(m->hstate);
-	paddr = virt_to_phys(m);
-
-	/*
-	 * Pre-HVO only works if the bootmem huge page
-	 * is aligned to the section size.
-	 */
-	section_size = (1UL << PA_SECTION_SHIFT);
-	if (!IS_ALIGNED(paddr, section_size) ||
-	    !IS_ALIGNED(psize, section_size))
-		return false;
-
-	/*
-	 * The pre-HVO code does not deal with splitting PMDS,
-	 * so the bootmem page must be aligned to the number
-	 * of base pages that can be mapped with one vmemmap PMD.
-	 */
-	pmd_vmemmap_size = (PMD_SIZE / (sizeof(struct page))) << PAGE_SHIFT;
-	if (!IS_ALIGNED(paddr, pmd_vmemmap_size) ||
-	    !IS_ALIGNED(psize, pmd_vmemmap_size))
-		return false;
-
-	return true;
-}
-
-/*
- * Initialize memmap section for a gigantic page, HVO-style.
- */
-void __init hugetlb_vmemmap_init_early(int nid)
-{
-	unsigned long psize, paddr, section_size;
-	unsigned long ns, i, pnum, pfn, nr_pages;
-	unsigned long start, end;
-	struct huge_bootmem_page *m = NULL;
-	void *map;
+	struct hstate *h = m->hstate;
+	unsigned long pfn = PHYS_PFN(__pa(m));
 
 	if (!READ_ONCE(vmemmap_optimize_enabled))
 		return;
 
-	section_size = (1UL << PA_SECTION_SHIFT);
-
-	list_for_each_entry(m, &huge_boot_pages[nid], list) {
-		struct zone *zone;
-
-		if (!vmemmap_should_optimize_bootmem_page(m))
-			continue;
-
-		nr_pages = pages_per_huge_page(m->hstate);
-		psize = nr_pages << PAGE_SHIFT;
-		paddr = virt_to_phys(m);
-		pfn = PHYS_PFN(paddr);
-		map = pfn_to_page(pfn);
-		start = (unsigned long)map;
-		end = start + hugetlb_vmemmap_size(m->hstate);
-		zone = pfn_to_zone(pfn, nid);
-
-		if (vmemmap_populate_hvo(start, end, huge_page_order(m->hstate),
-					 zone, HUGETLB_VMEMMAP_RESERVE_SIZE))
-			panic("Failed to allocate memmap for HugeTLB page\n");
-		memmap_boot_pages_add(DIV_ROUND_UP(HUGETLB_VMEMMAP_RESERVE_SIZE, PAGE_SIZE));
-
-		pnum = pfn_to_section_nr(pfn);
-		ns = psize / section_size;
-
-		for (i = 0; i < ns; i++) {
-			sparse_init_early_section(nid, map, pnum,
-					SECTION_IS_VMEMMAP_PREINIT);
-			map += section_map_size();
-			pnum++;
-		}
-
+	section_set_order_range(pfn, pages_per_huge_page(h), huge_page_order(h));
+	if (vmemmap_optimizable_order(pfn_to_section_order(pfn)))
 		m->flags |= HUGE_BOOTMEM_HVO;
-	}
 }
-#endif
 
 static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
 	{
--- a/mm/hugetlb_vmemmap.h~mm-hugetlb-switch-hugetlb-to-section-based-vmemmap-optimization
+++ a/mm/hugetlb_vmemmap.h
@@ -9,8 +9,7 @@
 #ifndef _LINUX_HUGETLB_VMEMMAP_H
 #define _LINUX_HUGETLB_VMEMMAP_H
 #include <linux/hugetlb.h>
-#include <linux/io.h>
-#include <linux/memblock.h>
+#include "internal.h"
 
 /*
  * Reserve one vmemmap page, all vmemmap addresses are mapped to it. See
@@ -27,10 +26,7 @@ long hugetlb_vmemmap_restore_folios(cons
 void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio);
 void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list);
 void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h, struct list_head *folio_list);
-#ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
-void hugetlb_vmemmap_init_early(int nid);
-#endif
-
+void hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m);
 
 static inline unsigned int hugetlb_vmemmap_size(const struct hstate *h)
 {
@@ -76,13 +72,13 @@ static inline void hugetlb_vmemmap_optim
 {
 }
 
-static inline void hugetlb_vmemmap_init_early(int nid)
+static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate *h)
 {
+	return 0;
 }
 
-static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate *h)
+static inline void hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m)
 {
-	return 0;
 }
 #endif /* CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP */
 
--- a/mm/sparse.h~mm-hugetlb-switch-hugetlb-to-section-based-vmemmap-optimization
+++ a/mm/sparse.h
@@ -16,6 +16,24 @@ static inline unsigned int section_order
 	return section->order;
 }
 
+static inline void section_set_order(struct mem_section *section, unsigned int order)
+{
+	VM_WARN_ON(section_order(section) && order && section_order(section) != order);
+	section->order = order;
+}
+
+static inline void section_set_order_range(unsigned long pfn, unsigned long nr_pages,
+					   unsigned int order)
+{
+	unsigned long section_nr = pfn_to_section_nr(pfn);
+
+	if (!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION))
+		return;
+
+	for (unsigned long i = 0; i < nr_pages / PAGES_PER_SECTION; i++)
+		section_set_order(__nr_to_section(section_nr + i), order);
+}
+
 static inline unsigned int pfn_to_section_order(unsigned long pfn)
 {
 	return section_order(__pfn_to_section(pfn));
@@ -26,6 +44,15 @@ static inline unsigned int section_order
 	return 0;
 }
 
+static inline void section_set_order(struct mem_section *section, unsigned int order)
+{
+}
+
+static inline void section_set_order_range(unsigned long pfn, unsigned long nr_pages,
+					   unsigned int order)
+{
+}
+
 static inline unsigned int pfn_to_section_order(unsigned long pfn)
 {
 	return 0;
--- a/mm/sparse-vmemmap.c~mm-hugetlb-switch-hugetlb-to-section-based-vmemmap-optimization
+++ a/mm/sparse-vmemmap.c
@@ -32,8 +32,6 @@
 #include <asm/dma.h>
 #include <asm/tlbflush.h>
 
-#include "hugetlb_vmemmap.h"
-
 /*
  * Flags for vmemmap_populate_range and friends.
  */
@@ -404,34 +402,6 @@ void vmemmap_wrprotect_hvo(unsigned long
 	}
 }
 
-#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
-int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
-				       unsigned int order, struct zone *zone,
-				       unsigned long headsize)
-{
-	unsigned long maddr;
-	struct page *tail;
-	pte_t *pte;
-	int node = zone_to_nid(zone);
-
-	tail = vmemmap_get_tail(order, zone);
-	if (!tail)
-		return -ENOMEM;
-
-	for (maddr = addr; maddr < addr + headsize; maddr += PAGE_SIZE) {
-		pte = vmemmap_populate_address(maddr, node, NULL, -1, 0);
-		if (!pte)
-			return -ENOMEM;
-	}
-
-	/*
-	 * Reuse the last page struct page mapped above for the rest.
-	 */
-	return vmemmap_populate_range(maddr, end, node, NULL,
-				      page_to_pfn(tail), 0);
-}
-#endif
-
 void __weak __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
 				      unsigned long addr, unsigned long next)
 {
@@ -634,7 +604,6 @@ struct page * __meminit __populate_secti
  */
 void __init sparse_vmemmap_init_nid_early(int nid)
 {
-	hugetlb_vmemmap_init_early(nid);
 }
 #endif
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

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

