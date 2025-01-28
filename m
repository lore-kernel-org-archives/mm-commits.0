Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79FD4170A1B
	for <mm-commits@vger.kernel.org>; Tue, 28 Jan 2025 00:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738023028; cv=none; b=sTHQsdL4WbmxIaVJ83XZ/YWinuHlOiOwgZgtScRs9ynGr9xQX8axVRLM0xb4zv75ZbBm+oUW+RjWzXEPPrYbI40xpNnTtu981A2eNWWVnIpVX6eGeQNpUugZJwK9Ao1u4nqQJqHGNQWZ+/8rCML5p/+ashSDdcUCP3EKSwjgrMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738023028; c=relaxed/simple;
	bh=x7U2Eb3y/L27HKan8EnEW4bqdR+48Mnjc+YJcJKY+5c=;
	h=Date:To:From:Subject:Message-Id; b=PHW86OftVyENzq4zGiXiIvwRxubZw3zk517ue1w2xztdrHLE6AUA6V2oFUz6tsSPKnArEVAFVpvmbhdpfZz7c6UwFxel2xDBl8wYqEjmf2b3ypxyLOqCEOCTrzKVunUUFfxsXRtH6n/g6YNXklQugLmwNXLolLaTHHTeuB/Aklo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2ka87NCr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2ka87NCr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34311C4CED2;
	Tue, 28 Jan 2025 00:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738023028;
	bh=x7U2Eb3y/L27HKan8EnEW4bqdR+48Mnjc+YJcJKY+5c=;
	h=Date:To:From:Subject:From;
	b=2ka87NCr/Kcc4fQSh8+5UoIMgIyKv9Mt3IA3L+FlycSHCyQSYiPRCgFjs/tKqRGDP
	 ZSH8KrC8svQ6ohFfAR0/x3a52KE44Wrv8zw9X0iCphGwdb3vtXc0qdVTSUhLVPyhrs
	 TuPG+la9gKzk7wlSgkz/UNaxvyLc15uhMLlKCUeA=
Date: Mon, 27 Jan 2025 16:10:27 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yaozhenguo1@gmail.com,usama.arif@bytedance.com,rppt@kernel.org,roman.gushchin@linux.dev,peterz@infradead.org,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,gor@linux.ibm.com,dave.hansen@linux.intel.com,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-introduce-a-cma-validate-function.patch added to mm-unstable branch
Message-Id: <20250128001028.34311C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/cma: introduce a cma validate function
has been added to the -mm mm-unstable branch.  Its filename is
     mm-cma-introduce-a-cma-validate-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-introduce-a-cma-validate-function.patch

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
Subject: mm/cma: introduce a cma validate function
Date: Mon, 27 Jan 2025 23:22:04 +0000

Define a function to check if a CMA area is valid, which means: do its
ranges not cross any zone boundaries.  Store the result in the newly
created flags for each CMA area, so that multiple calls are dealt with.

This allows for checking the validity of a CMA area early, which is needed
later in order to be able to allocate hugetlb bootmem pages from it with
pre-HVO.

Link: https://lkml.kernel.org/r/20250127232207.3888640-25-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
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

 include/linux/cma.h |    5 +++
 mm/cma.c            |   60 +++++++++++++++++++++++++++++++++---------
 mm/cma.h            |    8 ++++-
 3 files changed, 60 insertions(+), 13 deletions(-)

--- a/include/linux/cma.h~mm-cma-introduce-a-cma-validate-function
+++ a/include/linux/cma.h
@@ -60,6 +60,7 @@ extern void cma_reserve_pages_on_error(s
 #ifdef CONFIG_CMA
 struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp);
 bool cma_free_folio(struct cma *cma, const struct folio *folio);
+bool cma_validate_zones(struct cma *cma);
 #else
 static inline struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
 {
@@ -70,6 +71,10 @@ static inline bool cma_free_folio(struct
 {
 	return false;
 }
+static inline bool cma_validate_zones(struct cma *cma)
+{
+	return false;
+}
 #endif
 
 #endif
--- a/mm/cma.c~mm-cma-introduce-a-cma-validate-function
+++ a/mm/cma.c
@@ -99,6 +99,49 @@ static void cma_clear_bitmap(struct cma
 	spin_unlock_irqrestore(&cma->lock, flags);
 }
 
+/*
+ * Check if a CMA area contains no ranges that intersect with
+ * multiple zones. Store the result in the flags in case
+ * this gets called more than once.
+ */
+bool cma_validate_zones(struct cma *cma)
+{
+	int r;
+	unsigned long base_pfn;
+	struct cma_memrange *cmr;
+	bool valid_bit_set;
+
+	/*
+	 * If already validated, return result of previous check.
+	 * Either the valid or invalid bit will be set if this
+	 * check has already been done. If neither is set, the
+	 * check has not been performed yet.
+	 */
+	valid_bit_set = test_bit(CMA_ZONES_VALID, &cma->flags);
+	if (valid_bit_set || test_bit(CMA_ZONES_INVALID, &cma->flags))
+		return valid_bit_set;
+
+	for (r = 0; r < cma->nranges; r++) {
+		cmr = &cma->ranges[r];
+		base_pfn = cmr->base_pfn;
+
+		/*
+		 * alloc_contig_range() requires the pfn range specified
+		 * to be in the same zone. Simplify by forcing the entire
+		 * CMA resv range to be in the same zone.
+		 */
+		WARN_ON_ONCE(!pfn_valid(base_pfn));
+		if (pfn_range_intersects_zones(cma->nid, base_pfn, cmr->count)) {
+			set_bit(CMA_ZONES_INVALID, &cma->flags);
+			return false;
+		}
+	}
+
+	set_bit(CMA_ZONES_VALID, &cma->flags);
+
+	return true;
+}
+
 static void __init cma_activate_area(struct cma *cma)
 {
 	unsigned long pfn, base_pfn;
@@ -113,19 +156,12 @@ static void __init cma_activate_area(str
 			goto cleanup;
 	}
 
+	if (!cma_validate_zones(cma))
+		goto cleanup;
+
 	for (r = 0; r < cma->nranges; r++) {
 		cmr = &cma->ranges[r];
 		base_pfn = cmr->base_pfn;
-
-		/*
-		 * alloc_contig_range() requires the pfn range specified
-		 * to be in the same zone. Simplify by forcing the entire
-		 * CMA resv range to be in the same zone.
-		 */
-		WARN_ON_ONCE(!pfn_valid(base_pfn));
-		if (pfn_range_intersects_zones(cma->nid, base_pfn, cmr->count))
-			goto cleanup;
-
 		for (pfn = base_pfn; pfn < base_pfn + cmr->count;
 		     pfn += pageblock_nr_pages)
 			init_cma_reserved_pageblock(pfn_to_page(pfn));
@@ -145,7 +181,7 @@ cleanup:
 		bitmap_free(cma->ranges[r].bitmap);
 
 	/* Expose all pages to the buddy, they are useless for CMA. */
-	if (!cma->reserve_pages_on_error) {
+	if (!test_bit(CMA_RESERVE_PAGES_ON_ERROR, &cma->flags)) {
 		for (r = 0; r < allocrange; r++) {
 			cmr = &cma->ranges[r];
 			for (pfn = cmr->base_pfn;
@@ -172,7 +208,7 @@ core_initcall(cma_init_reserved_areas);
 
 void __init cma_reserve_pages_on_error(struct cma *cma)
 {
-	cma->reserve_pages_on_error = true;
+	set_bit(CMA_RESERVE_PAGES_ON_ERROR, &cma->flags);
 }
 
 static int __init cma_new_area(const char *name, phys_addr_t size,
--- a/mm/cma.h~mm-cma-introduce-a-cma-validate-function
+++ a/mm/cma.h
@@ -47,11 +47,17 @@ struct cma {
 	/* kobject requires dynamic object */
 	struct cma_kobject *cma_kobj;
 #endif
-	bool reserve_pages_on_error;
+	unsigned long flags;
 	/* NUMA node (NUMA_NO_NODE if unspecified) */
 	int nid;
 };
 
+enum cma_flags {
+	CMA_RESERVE_PAGES_ON_ERROR,
+	CMA_ZONES_VALID,
+	CMA_ZONES_INVALID,
+};
+
 extern struct cma cma_areas[MAX_CMA_AREAS];
 extern unsigned int cma_area_count;
 
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

