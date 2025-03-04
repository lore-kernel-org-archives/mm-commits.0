Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B58515ADA6
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 02:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741056585; cv=none; b=Y2yoTZRcusY6WkwygCoNM0rgkLfN1smznuMGTRNImcEqh1DVgBkBurri9x7N6YitTWwhJLPTQ+cQVuBkPZ+2s8JK7E5dTaU8L65VjwtvHC1Qxdq6SA+FfISYU8G/EMHWNnh3ote/0u/4XblNH1YemMj6fvkXZ8pVEcb+WHKWMjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741056585; c=relaxed/simple;
	bh=qiK+/Lw1JkWizedeu42k4f5rjfpCYkdw5kvSJn5ZpmY=;
	h=Date:To:From:Subject:Message-Id; b=QNb5doLbka7cfKYBxJ6cpRKf/8tR52X3keTr+cIb1zc1KWmXR/q9Xvk2hnn317GXq9aXrxb/oqpKn439rias5ZDPS8nPxY8idcLbwLT6WcDf5n5P01R3ujJ+XBB8mk8Cb4resj0O2laLofE2thr/LoPXN2Qj5ABO6lA97dj5jAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JB9OTcYE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JB9OTcYE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01254C4CEE4;
	Tue,  4 Mar 2025 02:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741056585;
	bh=qiK+/Lw1JkWizedeu42k4f5rjfpCYkdw5kvSJn5ZpmY=;
	h=Date:To:From:Subject:From;
	b=JB9OTcYExYL6TMFOXlGN3AyOZDF3SKGAGnOWzQ16yO1WXck1+FWtKthAHJnH8pJdN
	 UjEIAHExvhQLghAYiPU0oGBhFcovoSt0frIohyxoyVz0PW5OcGU/p6aAkCCb+Tu5k+
	 q+O801XFye8qtmp1hQo49MJaaH7tY6x6c1/3780A=
Date: Mon, 03 Mar 2025 18:49:44 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,hannes@cmpxchg.org,gor@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,arnd@arndb.de,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-enable-bootmem-allocation-from-cma-areas.patch added to mm-unstable branch
Message-Id: <20250304024945.01254C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: enable bootmem allocation from CMA areas
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-enable-bootmem-allocation-from-cma-areas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-enable-bootmem-allocation-from-cma-areas.patch

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
Subject: mm/hugetlb: enable bootmem allocation from CMA areas
Date: Fri, 28 Feb 2025 18:29:27 +0000

If hugetlb_cma_only is enabled, we know that hugetlb pages can only be
allocated from CMA.  Now that there is an interface to do early
reservations from a CMA area (returning memblock memory), it can be used
to allocate hugetlb pages from CMA.

This also allows for doing pre-HVO on these pages (if enabled).

Make sure to initialize the page structures and associated data correctly.
Create a flag to signal that a hugetlb page has been allocated from CMA
to make things a little easier.

Some configurations of powerpc have a special hugetlb bootmem allocator,
so introduce a boolean arch_specific_huge_bootmem_alloc that returns true
if such an allocator is present.  In that case, CMA bootmem allocations
can't be used, so check that function before trying.

Link: https://lkml.kernel.org/r/20250228182928.2645936-27-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/book3s/64/hugetlb.h |    6 
 include/linux/hugetlb.h                      |   17 +
 mm/hugetlb.c                                 |  168 +++++++++++++----
 3 files changed, 152 insertions(+), 39 deletions(-)

--- a/arch/powerpc/include/asm/book3s/64/hugetlb.h~mm-hugetlb-enable-bootmem-allocation-from-cma-areas
+++ a/arch/powerpc/include/asm/book3s/64/hugetlb.h
@@ -94,4 +94,10 @@ static inline int check_and_get_huge_psi
 	return mmu_psize;
 }
 
+#define arch_has_huge_bootmem_alloc arch_has_huge_bootmem_alloc
+
+static inline bool arch_has_huge_bootmem_alloc(void)
+{
+	return (firmware_has_feature(FW_FEATURE_LPAR) && !radix_enabled());
+}
 #endif
--- a/include/linux/hugetlb.h~mm-hugetlb-enable-bootmem-allocation-from-cma-areas
+++ a/include/linux/hugetlb.h
@@ -591,6 +591,7 @@ enum hugetlb_page_flags {
 	HPG_freed,
 	HPG_vmemmap_optimized,
 	HPG_raw_hwp_unreliable,
+	HPG_cma,
 	__NR_HPAGEFLAGS,
 };
 
@@ -650,6 +651,7 @@ HPAGEFLAG(Temporary, temporary)
 HPAGEFLAG(Freed, freed)
 HPAGEFLAG(VmemmapOptimized, vmemmap_optimized)
 HPAGEFLAG(RawHwpUnreliable, raw_hwp_unreliable)
+HPAGEFLAG(Cma, cma)
 
 #ifdef CONFIG_HUGETLB_PAGE
 
@@ -678,14 +680,18 @@ struct hstate {
 	char name[HSTATE_NAME_LEN];
 };
 
+struct cma;
+
 struct huge_bootmem_page {
 	struct list_head list;
 	struct hstate *hstate;
 	unsigned long flags;
+	struct cma *cma;
 };
 
 #define HUGE_BOOTMEM_HVO		0x0001
 #define HUGE_BOOTMEM_ZONES_VALID	0x0002
+#define HUGE_BOOTMEM_CMA		0x0004
 
 bool hugetlb_bootmem_page_zones_valid(int nid, struct huge_bootmem_page *m);
 
@@ -824,6 +830,17 @@ static inline pte_t arch_make_huge_pte(p
 }
 #endif
 
+#ifndef arch_has_huge_bootmem_alloc
+/*
+ * Some architectures do their own bootmem allocation, so they can't use
+ * early CMA allocation.
+ */
+static inline bool arch_has_huge_bootmem_alloc(void)
+{
+	return false;
+}
+#endif
+
 static inline struct hstate *folio_hstate(struct folio *folio)
 {
 	VM_BUG_ON_FOLIO(!folio_test_hugetlb(folio), folio);
--- a/mm/hugetlb.c~mm-hugetlb-enable-bootmem-allocation-from-cma-areas
+++ a/mm/hugetlb.c
@@ -131,8 +131,10 @@ static void hugetlb_free_folio(struct fo
 #ifdef CONFIG_CMA
 	int nid = folio_nid(folio);
 
-	if (cma_free_folio(hugetlb_cma[nid], folio))
+	if (folio_test_hugetlb_cma(folio)) {
+		WARN_ON_ONCE(!cma_free_folio(hugetlb_cma[nid], folio));
 		return;
+	}
 #endif
 	folio_put(folio);
 }
@@ -1508,6 +1510,9 @@ retry:
 					break;
 			}
 		}
+
+		if (folio)
+			folio_set_hugetlb_cma(folio);
 	}
 #endif
 	if (!folio) {
@@ -3182,6 +3187,86 @@ out_end_reservation:
 	return ERR_PTR(-ENOSPC);
 }
 
+static bool __init hugetlb_early_cma(struct hstate *h)
+{
+	if (arch_has_huge_bootmem_alloc())
+		return false;
+
+	return (hstate_is_gigantic(h) && hugetlb_cma_only);
+}
+
+static __init void *alloc_bootmem(struct hstate *h, int nid, bool node_exact)
+{
+	struct huge_bootmem_page *m;
+	unsigned long flags;
+	struct cma *cma;
+	int listnode = nid;
+
+#ifdef CONFIG_CMA
+	if (hugetlb_early_cma(h)) {
+		flags = HUGE_BOOTMEM_CMA;
+		cma = hugetlb_cma[nid];
+		m = cma_reserve_early(cma, huge_page_size(h));
+		if (!m) {
+			int node;
+
+			if (node_exact)
+				return NULL;
+			for_each_online_node(node) {
+				cma = hugetlb_cma[node];
+				if (!cma || node == nid)
+					continue;
+				m = cma_reserve_early(cma, huge_page_size(h));
+				if (m) {
+					listnode = node;
+					break;
+				}
+			}
+		}
+	} else
+#endif
+	{
+		flags = 0;
+		cma = NULL;
+		if (node_exact)
+			m = memblock_alloc_exact_nid_raw(huge_page_size(h),
+				huge_page_size(h), 0,
+				MEMBLOCK_ALLOC_ACCESSIBLE, nid);
+		else {
+			m = memblock_alloc_try_nid_raw(huge_page_size(h),
+				huge_page_size(h), 0,
+				MEMBLOCK_ALLOC_ACCESSIBLE, nid);
+			/*
+			 * For pre-HVO to work correctly, pages need to be on
+			 * the list for the node they were actually allocated
+			 * from. That node may be different in the case of
+			 * fallback by memblock_alloc_try_nid_raw. So,
+			 * extract the actual node first.
+			 */
+			if (m)
+				listnode = early_pfn_to_nid(PHYS_PFN(virt_to_phys(m)));
+		}
+	}
+
+	if (m) {
+		/*
+		 * Use the beginning of the huge page to store the
+		 * huge_bootmem_page struct (until gather_bootmem
+		 * puts them into the mem_map).
+		 *
+		 * Put them into a private list first because mem_map
+		 * is not up yet.
+		 */
+		INIT_LIST_HEAD(&m->list);
+		list_add(&m->list, &huge_boot_pages[listnode]);
+		m->hstate = h;
+		m->flags = flags;
+		m->cma = cma;
+	}
+
+	return m;
+}
+
 int alloc_bootmem_huge_page(struct hstate *h, int nid)
 	__attribute__ ((weak, alias("__alloc_bootmem_huge_page")));
 int __alloc_bootmem_huge_page(struct hstate *h, int nid)
@@ -3191,22 +3276,15 @@ int __alloc_bootmem_huge_page(struct hst
 
 	/* do node specific alloc */
 	if (nid != NUMA_NO_NODE) {
-		m = memblock_alloc_exact_nid_raw(huge_page_size(h), huge_page_size(h),
-				0, MEMBLOCK_ALLOC_ACCESSIBLE, nid);
+		m = alloc_bootmem(h, node, true);
 		if (!m)
 			return 0;
 		goto found;
 	}
+
 	/* allocate from next node when distributing huge pages */
 	for_each_node_mask_to_alloc(&h->next_nid_to_alloc, nr_nodes, node, &node_states[N_ONLINE]) {
-		m = memblock_alloc_try_nid_raw(
-				huge_page_size(h), huge_page_size(h),
-				0, MEMBLOCK_ALLOC_ACCESSIBLE, node);
-		/*
-		 * Use the beginning of the huge page to store the
-		 * huge_bootmem_page struct (until gather_bootmem
-		 * puts them into the mem_map).
-		 */
+		m = alloc_bootmem(h, node, false);
 		if (!m)
 			return 0;
 		goto found;
@@ -3224,21 +3302,6 @@ found:
 	memblock_reserved_mark_noinit(virt_to_phys((void *)m + PAGE_SIZE),
 		huge_page_size(h) - PAGE_SIZE);
 
-	/*
-	 * Put them into a private list first because mem_map is not up yet.
-	 *
-	 * For pre-HVO to work correctly, pages need to be on the list for
-	 * the node they were actually allocated from. That node may be
-	 * different in the case of fallback by memblock_alloc_try_nid_raw.
-	 * So, extract the actual node first.
-	 */
-	if (nid == NUMA_NO_NODE)
-		node = early_pfn_to_nid(PHYS_PFN(virt_to_phys(m)));
-
-	INIT_LIST_HEAD(&m->list);
-	list_add(&m->list, &huge_boot_pages[node]);
-	m->hstate = h;
-	m->flags = 0;
 	return 1;
 }
 
@@ -3279,13 +3342,25 @@ static void __init hugetlb_folio_init_vm
 	prep_compound_head((struct page *)folio, huge_page_order(h));
 }
 
+static bool __init hugetlb_bootmem_page_prehvo(struct huge_bootmem_page *m)
+{
+	return m->flags & HUGE_BOOTMEM_HVO;
+}
+
+static bool __init hugetlb_bootmem_page_earlycma(struct huge_bootmem_page *m)
+{
+	return m->flags & HUGE_BOOTMEM_CMA;
+}
+
 /*
  * memblock-allocated pageblocks might not have the migrate type set
  * if marked with the 'noinit' flag. Set it to the default (MIGRATE_MOVABLE)
- * here.
+ * here, or MIGRATE_CMA if this was a page allocated through an early CMA
+ * reservation.
  *
- * Note that this will not write the page struct, it is ok (and necessary)
- * to do this on vmemmap optimized folios.
+ * In case of vmemmap optimized folios, the tail vmemmap pages are mapped
+ * read-only, but that's ok - for sparse vmemmap this does not write to
+ * the page structure.
  */
 static void __init hugetlb_bootmem_init_migratetype(struct folio *folio,
 							  struct hstate *h)
@@ -3294,9 +3369,13 @@ static void __init hugetlb_bootmem_init_
 
 	WARN_ON_ONCE(!pageblock_aligned(folio_pfn(folio)));
 
-	for (i = 0; i < nr_pages; i += pageblock_nr_pages)
-		set_pageblock_migratetype(folio_page(folio, i),
+	for (i = 0; i < nr_pages; i += pageblock_nr_pages) {
+		if (folio_test_hugetlb_cma(folio))
+			init_cma_pageblock(folio_page(folio, i));
+		else
+			set_pageblock_migratetype(folio_page(folio, i),
 					  MIGRATE_MOVABLE);
+	}
 }
 
 static void __init prep_and_add_bootmem_folios(struct hstate *h,
@@ -3342,10 +3421,16 @@ bool __init hugetlb_bootmem_page_zones_v
 		return true;
 	}
 
+	if (hugetlb_bootmem_page_earlycma(m)) {
+		valid = cma_validate_zones(m->cma);
+		goto out;
+	}
+
 	start_pfn = virt_to_phys(m) >> PAGE_SHIFT;
 
 	valid = !pfn_range_intersects_zones(nid, start_pfn,
 			pages_per_huge_page(m->hstate));
+out:
 	if (!valid)
 		hstate_boot_nrinvalid[hstate_index(m->hstate)]++;
 
@@ -3374,11 +3459,6 @@ static void __init hugetlb_bootmem_free_
 	}
 }
 
-static bool __init hugetlb_bootmem_page_prehvo(struct huge_bootmem_page *m)
-{
-	return (m->flags & HUGE_BOOTMEM_HVO);
-}
-
 /*
  * Put bootmem huge pages into the standard lists after mem_map is up.
  * Note: This only applies to gigantic (order > MAX_PAGE_ORDER) pages.
@@ -3428,14 +3508,21 @@ static void __init gather_bootmem_preall
 			 */
 			folio_set_hugetlb_vmemmap_optimized(folio);
 
+		if (hugetlb_bootmem_page_earlycma(m))
+			folio_set_hugetlb_cma(folio);
+
 		list_add(&folio->lru, &folio_list);
 
 		/*
 		 * We need to restore the 'stolen' pages to totalram_pages
 		 * in order to fix confusing memory reports from free(1) and
 		 * other side-effects, like CommitLimit going negative.
+		 *
+		 * For CMA pages, this is done in init_cma_pageblock
+		 * (via hugetlb_bootmem_init_migratetype), so skip it here.
 		 */
-		adjust_managed_page_count(page, pages_per_huge_page(h));
+		if (!folio_test_hugetlb_cma(folio))
+			adjust_managed_page_count(page, pages_per_huge_page(h));
 		cond_resched();
 	}
 
@@ -3620,8 +3707,11 @@ static void __init hugetlb_hstate_alloc_
 {
 	unsigned long allocated;
 
-	/* skip gigantic hugepages allocation if hugetlb_cma enabled */
-	if (hstate_is_gigantic(h) && hugetlb_cma_size) {
+	/*
+	 * Skip gigantic hugepages allocation if early CMA
+	 * reservations are not available.
+	 */
+	if (hstate_is_gigantic(h) && hugetlb_cma_size && !hugetlb_early_cma(h)) {
 		pr_warn_once("HugeTLB: hugetlb_cma is enabled, skip boot time allocation\n");
 		return;
 	}
_

Patches currently in -mm which might be from fvdl@google.com are

mm-cma-export-total-and-free-number-of-pages-for-cma-areas.patch
mm-cma-support-multiple-contiguous-ranges-if-requested.patch
mm-cma-introduce-cma_intersects-function.patch
mm-hugetlb-use-cma_declare_contiguous_multi.patch
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
x86-mm-set-arch_want_hugetlb_vmemmap_preinit.patch
mm-cma-simplify-zone-intersection-check.patch
mm-cma-introduce-a-cma-validate-function.patch
mm-cma-introduce-interface-for-early-reservations.patch
mm-hugetlb-add-hugetlb_cma_only-cmdline-option.patch
mm-hugetlb-enable-bootmem-allocation-from-cma-areas.patch
mm-hugetlb-move-hugetlb-cma-code-in-to-its-own-file.patch

