Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FBCA170A1B
	for <mm-commits@vger.kernel.org>; Tue, 28 Jan 2025 00:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738023037; cv=none; b=QmQ98TpE94HXthHiI6cGSPnMATgFTB+yG/43LAy2enFMepkczg/FJxvJF+NdtxJ7IJk8IMinRnjqY8GZ6hW2h5tqxacWizBTZt90wrlmss9Jnoe4iur9MhpzZaQGYwiEdJpgJ6vjAGk5PC1I8R9t1vmzRj30/dg1AkpWmi2Z6+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738023037; c=relaxed/simple;
	bh=VbqSUz0iJbmpoiMsxkGaCNbDbKjdu84OIyYzHT+dUyw=;
	h=Date:To:From:Subject:Message-Id; b=iOfMqDuSZxIpPvBPR3mKcaB9LdV9IRGsE8xbf1TBVpPWeIPVFkvFvPXiEd4JGuI5MRVU5p6Uub3lhAveH3EVy00n+MOqGG2nKOmFx70u4N3/G8DdHXLMXWbVup6gV0y+BUXw3IP8p3bgXpOOp6iRfg6Yg523OqQmsB3wjHcp23c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=quFVUJbk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="quFVUJbk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0696DC4CED2;
	Tue, 28 Jan 2025 00:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738023037;
	bh=VbqSUz0iJbmpoiMsxkGaCNbDbKjdu84OIyYzHT+dUyw=;
	h=Date:To:From:Subject:From;
	b=quFVUJbkmVtJ1wU4R4qX2GyAv9HGxJesO5X9X6/wHsgJ3ni9o977/xK9FhvBYQXzJ
	 h40EB8iTriEtzhE9DL6IlgfkpXzNIdVMKYQ2yqmwmfDXl7sjfjZd5D3rkGy2LAc1lj
	 QWqywzgDtMPK5UIjsJMi70OcN4EoanfOeThTCtJ4=
Date: Mon, 27 Jan 2025 16:10:36 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yaozhenguo1@gmail.com,usama.arif@bytedance.com,rppt@kernel.org,roman.gushchin@linux.dev,peterz@infradead.org,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,gor@linux.ibm.com,dave.hansen@linux.intel.com,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-enable-bootmem-allocation-from-cma-areas.patch added to mm-unstable branch
Message-Id: <20250128001037.0696DC4CED2@smtp.kernel.org>
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
Date: Mon, 27 Jan 2025 23:22:07 +0000

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

Link: https://lkml.kernel.org/r/20250127232207.3888640-28-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Usama Arif <usama.arif@bytedance.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zhenguo Yao <yaozhenguo1@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/hugetlbpage.c |    5 +
 include/linux/hugetlb.h       |    7 +
 mm/hugetlb.c                  |  135 ++++++++++++++++++++++++--------
 3 files changed, 114 insertions(+), 33 deletions(-)

--- a/arch/powerpc/mm/hugetlbpage.c~mm-hugetlb-enable-bootmem-allocation-from-cma-areas
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -121,6 +121,11 @@ bool __init hugetlb_node_alloc_supported
 {
 	return false;
 }
+
+bool __init arch_specific_huge_bootmem_alloc(struct hstate *h)
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
 
@@ -711,6 +717,7 @@ bool __init hugetlb_node_alloc_supported
 
 void __init hugetlb_add_hstate(unsigned order);
 bool __init arch_hugetlb_valid_size(unsigned long size);
+bool __init arch_specific_huge_bootmem_alloc(struct hstate *h);
 struct hstate *size_to_hstate(unsigned long size);
 
 #ifndef HUGE_MAX_HSTATE
--- a/mm/hugetlb.c~mm-hugetlb-enable-bootmem-allocation-from-cma-areas
+++ a/mm/hugetlb.c
@@ -61,7 +61,7 @@ static struct cma *hugetlb_cma[MAX_NUMNO
 static unsigned long hugetlb_cma_size_in_node[MAX_NUMNODES] __initdata;
 #endif
 static bool hugetlb_cma_only;
-static unsigned long hugetlb_cma_size __initdata;
+static unsigned long hugetlb_cma_size;
 
 __initdata struct list_head huge_boot_pages[MAX_NUMNODES];
 __initdata unsigned long hstate_boot_nrinvalid[HUGE_MAX_HSTATE];
@@ -132,8 +132,10 @@ static void hugetlb_free_folio(struct fo
 #ifdef CONFIG_CMA
 	int nid = folio_nid(folio);
 
-	if (cma_free_folio(hugetlb_cma[nid], folio))
+	if (folio_test_hugetlb_cma(folio)) {
+		WARN_ON(!cma_free_folio(hugetlb_cma[nid], folio));
 		return;
+	}
 #endif
 	folio_put(folio);
 }
@@ -1509,6 +1511,9 @@ retry:
 					break;
 			}
 		}
+
+		if (folio)
+			folio_set_hugetlb_cma(folio);
 	}
 #endif
 	if (!folio) {
@@ -3175,6 +3180,63 @@ out_end_reservation:
 	return ERR_PTR(-ENOSPC);
 }
 
+/*
+ * Some architectures do their own bootmem allocation, so they can't use
+ * early CMA allocation. So, allow for this function to be redefined.
+ */
+bool __init __attribute((weak))
+arch_specific_huge_bootmem_alloc(struct hstate *h)
+{
+	return false;
+}
+
+static bool __init hugetlb_early_cma(struct hstate *h)
+{
+	if (arch_specific_huge_bootmem_alloc(h))
+		return false;
+
+	return (hstate_is_gigantic(h) && hugetlb_cma_size && hugetlb_cma_only);
+}
+
+static __init void *alloc_bootmem(struct hstate *h, int nid)
+{
+	struct huge_bootmem_page *m;
+	unsigned long flags;
+	struct cma *cma;
+
+#ifdef CONFIG_CMA
+	if (hugetlb_early_cma(h)) {
+		flags = HUGE_BOOTMEM_CMA;
+		cma = hugetlb_cma[nid];
+		m = cma_reserve_early(cma, huge_page_size(h));
+	} else
+#endif
+	{
+		flags = 0;
+		cma = NULL;
+		m = memblock_alloc_try_nid_raw(huge_page_size(h),
+			huge_page_size(h), 0, MEMBLOCK_ALLOC_ACCESSIBLE, nid);
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
+		list_add(&m->list, &huge_boot_pages[nid]);
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
@@ -3184,17 +3246,14 @@ int __alloc_bootmem_huge_page(struct hst
 
 	/* do node specific alloc */
 	if (nid != NUMA_NO_NODE) {
-		m = memblock_alloc_try_nid_raw(huge_page_size(h), huge_page_size(h),
-				0, MEMBLOCK_ALLOC_ACCESSIBLE, nid);
+		m = alloc_bootmem(h, node);
 		if (!m)
 			return 0;
 		goto found;
 	}
 	/* allocate from next node when distributing huge pages */
 	for_each_node_mask_to_alloc(&h->next_nid_to_alloc, nr_nodes, node, &node_states[N_ONLINE]) {
-		m = memblock_alloc_try_nid_raw(
-				huge_page_size(h), huge_page_size(h),
-				0, MEMBLOCK_ALLOC_ACCESSIBLE, node);
+		m = alloc_bootmem(h, node);
 		if (m)
 			break;
 	}
@@ -3203,7 +3262,6 @@ int __alloc_bootmem_huge_page(struct hst
 		return 0;
 
 found:
-
 	/*
 	 * Only initialize the head struct page in memmap_init_reserved_pages,
 	 * rest of the struct pages will be initialized by the HugeTLB
@@ -3213,18 +3271,6 @@ found:
 	 */
 	memblock_reserved_mark_noinit(virt_to_phys((void *)m + PAGE_SIZE),
 		huge_page_size(h) - PAGE_SIZE);
-	/*
-	 * Use the beginning of the huge page to store the
-	 * huge_bootmem_page struct (until gather_bootmem
-	 * puts them into the mem_map).
-	 *
-	 * Put them into a private list first because mem_map
-	 * is not up yet.
-	 */
-	INIT_LIST_HEAD(&m->list);
-	list_add(&m->list, &huge_boot_pages[node]);
-	m->hstate = h;
-	m->flags = 0;
 	return 1;
 }
 
@@ -3265,13 +3311,25 @@ static void __init hugetlb_folio_init_vm
 	prep_compound_head((struct page *)folio, huge_page_order(h));
 }
 
+static bool __init hugetlb_bootmem_page_prehvo(struct huge_bootmem_page *m)
+{
+	return (m->flags & HUGE_BOOTMEM_HVO);
+}
+
+static bool __init hugetlb_bootmem_page_earlycma(struct huge_bootmem_page *m)
+{
+	return (m->flags & HUGE_BOOTMEM_CMA);
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
@@ -3280,9 +3338,13 @@ static void __init hugetlb_bootmem_init_
 
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
@@ -3319,7 +3381,7 @@ bool __init hugetlb_bootmem_page_zones_v
 					     struct huge_bootmem_page *m)
 {
 	unsigned long start_pfn;
-	bool valid;
+	bool valid = false;
 
 	if (m->flags & HUGE_BOOTMEM_ZONES_VALID) {
 		/*
@@ -3328,10 +3390,16 @@ bool __init hugetlb_bootmem_page_zones_v
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
 
@@ -3360,11 +3428,6 @@ static void __init hugetlb_bootmem_free_
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
@@ -3414,6 +3477,9 @@ static void __init gather_bootmem_preall
 			 */
 			folio_set_hugetlb_vmemmap_optimized(folio);
 
+		if (hugetlb_bootmem_page_earlycma(m))
+			folio_set_hugetlb_cma(folio);
+
 		list_add(&folio->lru, &folio_list);
 
 		/*
@@ -3606,8 +3672,11 @@ static void __init hugetlb_hstate_alloc_
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

