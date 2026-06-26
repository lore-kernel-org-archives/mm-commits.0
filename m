Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C4E26059D
	for <mm-commits@vger.kernel.org>; Fri, 26 Jun 2026 00:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782434858; cv=none; b=QmC2t0eGt0At1TcXG6v//WPD3BG5BRXaNsTPxOMvhdPjFE3QirEPWEQD7HJTvCVrtLs3PA5CYg7JDMOM9YC1TsKcNnFPKm+LFEMxtMv/pCU4DtHGgrs2m7C6qVYxVSHyI3B1aihbsa9sBnYhOLblmNq8hgh51zmPp+NdZKflE1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782434858; c=relaxed/simple;
	bh=i3tS6Pbf6itwnC0FRTjXDpF4ctOiT62mNleyAz6gC28=;
	h=Date:To:From:Subject:Message-Id; b=po9CwJaWq0f/EuhbM9tDDWKO0Ri9iQ+BkOnOAj4iyzQG3j7LJvuFz3x36IjRHgZMEWMBHEv1Zw8z3jUfr8ascABp1Lx3iJV2HwkdkWQ4/Cq2zvijlHUVVCujhLY5EWv8tbq4dbnySaUsVGGfes/REYc+ZNB+nH2YXT4tVX90wAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nOcdVnV2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nOcdVnV2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4F21F000E9;
	Fri, 26 Jun 2026 00:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782434856;
	bh=oW0iwVqqnkE+3UnTqc0E2HT0UKyo8MW/RZViA3ZN15w=;
	h=Date:To:From:Subject;
	b=nOcdVnV2c6UG8rpb6hBPveMEE95NAEhBTmSGjk6SUQw8YP9Js5pP5mV0P5g9JSb5R
	 zCweVDhUFx9rnY22W1o4sm3HU8igXEMK1ERQT1+Qmj5GHJSQIda6MN6S2ExBDDrZwx
	 5HmRqRB9LqnRq6iNzaLQOA8nYVw/YOm0qwWSbscM=
Date: Thu, 25 Jun 2026 17:47:36 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-refactor-early-boot-gigantic-hugepage-allocation.patch added to mm-new branch
Message-Id: <20260626004736.7C4F21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: refactor early boot gigantic hugepage allocation
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-refactor-early-boot-gigantic-hugepage-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-refactor-early-boot-gigantic-hugepage-allocation.patch

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
Subject: mm/hugetlb: refactor early boot gigantic hugepage allocation
Date: Fri, 12 Jun 2026 11:58:57 +0800

The early boot gigantic hugepage allocation helpers currently mix
allocation with huge_bootmem_page setup, and leave part of the
initialization flow in architecture code.

Refactor the interface to return the allocated huge page pointer and move
the huge_bootmem_page setup into the generic hugetlb code.  This makes the
architecture-specific paths focus only on finding memory, while the common
code handles node placement and early page metadata setup in one place.

This also lets powerpc benefit from memblock_reserved_mark_noinit(), which
it did not enable before.

In addition, upcoming cross-zone validation for boot-time gigantic hugetlb
reservation is common logic.  With this refactoring, that logic can stay
in the generic code instead of being duplicated in architecture-specific
paths.

Link: https://lore.kernel.org/20260612035903.2468601-14-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Oscar Salvador (SUSE) <osalvador@suse.de>
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

 arch/powerpc/mm/hugetlbpage.c |   13 +---
 include/linux/hugetlb.h       |   18 +-----
 mm/hugetlb.c                  |   95 ++++++++++++--------------------
 mm/hugetlb_cma.c              |   13 +---
 mm/hugetlb_cma.h              |    8 +-
 mm/internal.h                 |    9 +++
 6 files changed, 64 insertions(+), 92 deletions(-)

--- a/arch/powerpc/mm/hugetlbpage.c~mm-hugetlb-refactor-early-boot-gigantic-hugepage-allocation
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -104,17 +104,14 @@ void __init pseries_add_gpage(u64 addr,
 	}
 }
 
-static int __init pseries_alloc_bootmem_huge_page(struct hstate *hstate)
+static __init void *pseries_alloc_bootmem_huge_page(struct hstate *hstate)
 {
-	struct huge_bootmem_page *m;
+	void *m;
 	if (nr_gpages == 0)
-		return 0;
+		return NULL;
 	m = phys_to_virt(gpage_freearray[--nr_gpages]);
 	gpage_freearray[nr_gpages] = 0;
-	list_add(&m->list, &huge_boot_pages[0]);
-	m->hstate = hstate;
-	m->flags = 0;
-	return 1;
+	return m;
 }
 
 bool __init hugetlb_node_alloc_supported(void)
@@ -124,7 +121,7 @@ bool __init hugetlb_node_alloc_supported
 #endif
 
 
-int __init alloc_bootmem_huge_page(struct hstate *h, int nid)
+void *__init arch_alloc_bootmem_huge_page(struct hstate *h, int nid)
 {
 
 #ifdef CONFIG_PPC_BOOK3S_64
--- a/include/linux/hugetlb.h~mm-hugetlb-refactor-early-boot-gigantic-hugepage-allocation
+++ a/include/linux/hugetlb.h
@@ -674,19 +674,11 @@ struct hstate {
 	char name[HSTATE_NAME_LEN];
 };
 
-struct cma;
-
-struct huge_bootmem_page {
-	struct list_head list;
-	struct hstate *hstate;
-	unsigned long flags;
-	struct cma *cma;
-};
-
 #define HUGE_BOOTMEM_HVO		0x0001
 #define HUGE_BOOTMEM_ZONES_VALID	0x0002
 #define HUGE_BOOTMEM_CMA		0x0004
 
+struct huge_bootmem_page;
 bool hugetlb_bootmem_page_zones_valid(int nid, struct huge_bootmem_page *m);
 
 int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list);
@@ -706,8 +698,8 @@ void restore_reserve_on_error(struct hst
 				unsigned long address, struct folio *folio);
 
 /* arch callback */
-int __init __alloc_bootmem_huge_page(struct hstate *h, int nid);
-int __init alloc_bootmem_huge_page(struct hstate *h, int nid);
+void *__init __alloc_bootmem_huge_page(struct hstate *h, int nid);
+void *__init arch_alloc_bootmem_huge_page(struct hstate *h, int nid);
 bool __init hugetlb_node_alloc_supported(void);
 
 void __init hugetlb_add_hstate(unsigned order);
@@ -1138,9 +1130,9 @@ alloc_hugetlb_folio_nodemask(struct hsta
 	return NULL;
 }
 
-static inline int __alloc_bootmem_huge_page(struct hstate *h)
+static inline void *__alloc_bootmem_huge_page(struct hstate *h, int nid)
 {
-	return 0;
+	return NULL;
 }
 
 static inline struct hstate *hstate_file(struct file *f)
--- a/mm/hugetlb.c~mm-hugetlb-refactor-early-boot-gigantic-hugepage-allocation
+++ a/mm/hugetlb.c
@@ -3027,79 +3027,58 @@ out_end_reservation:
 
 static __init void *alloc_bootmem(struct hstate *h, int nid, bool node_exact)
 {
-	struct huge_bootmem_page *m;
-	int listnode = nid;
-
 	if (hugetlb_early_cma(h))
-		m = hugetlb_cma_alloc_bootmem(h, &listnode, node_exact);
-	else {
-		if (node_exact)
-			m = memblock_alloc_exact_nid_raw(huge_page_size(h),
+		return hugetlb_cma_alloc_bootmem(h, nid, node_exact);
+
+	if (node_exact)
+		return memblock_alloc_exact_nid_raw(huge_page_size(h),
 				huge_page_size(h), 0,
 				MEMBLOCK_ALLOC_ACCESSIBLE, nid);
-		else {
-			m = memblock_alloc_try_nid_raw(huge_page_size(h),
+
+	return memblock_alloc_try_nid_raw(huge_page_size(h),
 				huge_page_size(h), 0,
 				MEMBLOCK_ALLOC_ACCESSIBLE, nid);
-			/*
-			 * For pre-HVO to work correctly, pages need to be on
-			 * the list for the node they were actually allocated
-			 * from. That node may be different in the case of
-			 * fallback by memblock_alloc_try_nid_raw. So,
-			 * extract the actual node first.
-			 */
-			if (m)
-				listnode = early_pfn_to_nid(PHYS_PFN(__pa(m)));
-		}
-
-		if (m) {
-			m->flags = 0;
-			m->cma = NULL;
-		}
-	}
-
-	if (m) {
-		/*
-		 * Use the beginning of the huge page to store the
-		 * huge_bootmem_page struct (until gather_bootmem
-		 * puts them into the mem_map).
-		 *
-		 * Put them into a private list first because mem_map
-		 * is not up yet.
-		 */
-		INIT_LIST_HEAD(&m->list);
-		list_add(&m->list, &huge_boot_pages[listnode]);
-		m->hstate = h;
-	}
-
-	return m;
 }
 
-int alloc_bootmem_huge_page(struct hstate *h, int nid)
+void *__init arch_alloc_bootmem_huge_page(struct hstate *h, int nid)
 	__attribute__ ((weak, alias("__alloc_bootmem_huge_page")));
-int __alloc_bootmem_huge_page(struct hstate *h, int nid)
+void *__init __alloc_bootmem_huge_page(struct hstate *h, int nid)
 {
-	struct huge_bootmem_page *m = NULL; /* initialize for clang */
 	int nr_nodes, node = nid;
 
 	/* do node specific alloc */
-	if (nid != NUMA_NO_NODE) {
-		m = alloc_bootmem(h, node, true);
-		if (!m)
-			return 0;
-		goto found;
-	}
+	if (nid != NUMA_NO_NODE)
+		return alloc_bootmem(h, node, true);
 
 	/* allocate from next node when distributing huge pages */
 	for_each_node_mask_to_alloc(&h->next_nid_to_alloc, nr_nodes, node,
-				    &hugetlb_bootmem_nodes) {
-		m = alloc_bootmem(h, node, false);
-		if (!m)
-			return 0;
-		goto found;
-	}
+				    &hugetlb_bootmem_nodes)
+		return alloc_bootmem(h, node, false);
 
-found:
+	return NULL;
+}
+
+static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
+{
+	struct huge_bootmem_page *m = arch_alloc_bootmem_huge_page(h, nid);
+
+	if (!m)
+		return false;
+
+	nid = early_pfn_to_nid(PHYS_PFN(__pa(m)));
+	/*
+	 * Use the beginning of the huge page to store the huge_bootmem_page
+	 * struct (until gather_bootmem puts them into the mem_map).
+	 *
+	 * Put them into a private list first because mem_map is not up yet.
+	 */
+	INIT_LIST_HEAD(&m->list);
+	list_add(&m->list, &huge_boot_pages[nid]);
+	m->hstate = h;
+	if (!hugetlb_early_cma(h)) {
+		m->cma = NULL;
+		m->flags = 0;
+	}
 
 	/*
 	 * Only initialize the head struct page in memmap_init_reserved_pages,
@@ -3111,7 +3090,7 @@ found:
 	memblock_reserved_mark_noinit(__pa((void *)m + PAGE_SIZE),
 		huge_page_size(h) - PAGE_SIZE);
 
-	return 1;
+	return true;
 }
 
 /* Initialize [start_page:end_page_number] tail struct pages of a hugepage */
--- a/mm/hugetlb_cma.c~mm-hugetlb-refactor-early-boot-gigantic-hugepage-allocation
+++ a/mm/hugetlb_cma.c
@@ -56,14 +56,13 @@ struct folio *hugetlb_cma_alloc_frozen_f
 	return folio;
 }
 
-struct huge_bootmem_page * __init
-hugetlb_cma_alloc_bootmem(struct hstate *h, int *nid, bool node_exact)
+void * __init hugetlb_cma_alloc_bootmem(struct hstate *h, int nid, bool node_exact)
 {
 	struct cma *cma;
 	struct huge_bootmem_page *m;
-	int node = *nid;
+	int node;
 
-	cma = hugetlb_cma[*nid];
+	cma = hugetlb_cma[nid];
 	m = cma_reserve_early(cma, huge_page_size(h));
 	if (!m) {
 		if (node_exact)
@@ -71,13 +70,11 @@ hugetlb_cma_alloc_bootmem(struct hstate
 
 		for_each_node_mask(node, hugetlb_bootmem_nodes) {
 			cma = hugetlb_cma[node];
-			if (!cma || node == *nid)
+			if (!cma || node == nid)
 				continue;
 			m = cma_reserve_early(cma, huge_page_size(h));
-			if (m) {
-				*nid = node;
+			if (m)
 				break;
-			}
 		}
 	}
 
--- a/mm/hugetlb_cma.h~mm-hugetlb-refactor-early-boot-gigantic-hugepage-allocation
+++ a/mm/hugetlb_cma.h
@@ -6,8 +6,7 @@
 void hugetlb_cma_free_frozen_folio(struct folio *folio);
 struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
 				      int nid, nodemask_t *nodemask);
-struct huge_bootmem_page *hugetlb_cma_alloc_bootmem(struct hstate *h, int *nid,
-						    bool node_exact);
+void *hugetlb_cma_alloc_bootmem(struct hstate *h, int nid, bool node_exact);
 bool hugetlb_cma_exclusive_alloc(void);
 unsigned long hugetlb_cma_total_size(void);
 void hugetlb_cma_validate_params(void);
@@ -23,9 +22,8 @@ static inline struct folio *hugetlb_cma_
 	return NULL;
 }
 
-static inline
-struct huge_bootmem_page *hugetlb_cma_alloc_bootmem(struct hstate *h, int *nid,
-						    bool node_exact)
+static inline void *hugetlb_cma_alloc_bootmem(struct hstate *h, int nid,
+					      bool node_exact)
 {
 	return NULL;
 }
--- a/mm/internal.h~mm-hugetlb-refactor-early-boot-gigantic-hugepage-allocation
+++ a/mm/internal.h
@@ -23,6 +23,15 @@
 #include "vma.h"
 
 struct folio_batch;
+struct hstate;
+struct cma;
+
+struct huge_bootmem_page {
+	struct list_head list;
+	struct hstate *hstate;
+	unsigned long flags;
+	struct cma *cma;
+};
 
 /*
  * Maintains state across a page table move. The operation assumes both source
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

