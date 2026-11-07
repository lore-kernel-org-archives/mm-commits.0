Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794023393;
	b=S8K8pUDZYjT7YFtZIrRh8NGQTS2JGeipjrQRIr1qjW3YmVkwWu4IxZE+k1GL/0G9NfdA
	 EhHdJrdGAdR+AcEK1q/umnYLIfDdMnrLIqD/ggEvLylmt8lXtheJXRYnjhCBvscpUt5ET
	 5ybmeJ3bRMvY27pibffgu0pIMj4El36USWtRLZQ6WxitctRd7dKDlRtAkkKXsxaZEE3xU
	 gpGnGpzKWjwsO0GRHj7tR6ew1vpD2UohBI+fGDfri3/y829RGgPdZifBfQcEUSQpHBeaG
	 ix+rC9RikfKXLE49Sk3k9WBS3VrSRyOET/8ZBsca6vsqCVauEhnP2LLHDeuszCvyAhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794023393;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=KECMAYLmoH1sRsI5iXbW2k+KB0bBhnshIjKPTnMRhYw=;
	b=rn8TPLiFrHnx8+74/u/QlR4oduihKfW/foj/pO7bc9X5RyRsbCZzRCSSEwPziHPQHcXk
	 8pIuGIGkWYw1GJJYDOwMEo/jRWY45XUbClhzuZ2rK1T+oWx4U5MHQGtv2wj6XS2wnsmGQ
	 jVR3TbPbu7STdjXYMYZRYQR9Uz/3ptyNaVh2WsXqpVX2O8tAuT9vV5+LEEyCGAZdHJZWi
	 uKrBfycylRTVnGT3PsGsw6HM76btUAbfILvJW+N1lYMKQFOgbInkUfS+J0CxLTaOuWhF4
	 9QOz6uaLuG9AMPylRl1N3FF2yQeyPoYT/7sAVJPK+ZZWhtfMgXxLnxgzK8d+exxsdGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="BL/q4d3+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A74606A32D
	for <mm-commits@vger.kernel.org>; Sat,  7 Nov 2026 03:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=BL/q4d3+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B16C21F0089F;
	Sat,  7 Nov 2026 03:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794023392;
	bh=KECMAYLmoH1sRsI5iXbW2k+KB0bBhnshIjKPTnMRhYw=;
	h=Date:To:From:Subject;
	b=BL/q4d3+9ajQFp6oiR3NP/a4Bo5/cfGGJ1+4ZwoPrqFEwn+tKLsHkYkRobOC/jKBD
	 j4CBNpudJj43f5TBogC6vLIDdD3ZOLCGJj/MoEvjN8LD/f13/JWpx6SM/JQTk57GEn
	 f/iHL0KMka7nYC5nH5HiIcSP03V4vn0H6UXwmQeM=
Date: Fri, 06 Nov 2026 19:49:52 -0800
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hugetlb_vmemmap-simplify-shared-tail-page-handling.patch removed from -mm tree
Message-Id: <20261107034952.B16C21F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: hugetlb_vmemmap: simplify shared tail page handling
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-simplify-shared-tail-page-handling.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Muchun Song <muchun.song@linux.dev>
Subject: mm: hugetlb_vmemmap: simplify shared tail page handling
Date: Wed, 04 Nov 2026 10:35:05 +0800

The remap walker currently carries a shared tail page selected by its
caller, even though the optimize and restore callbacks can derive the same
information from the folio being processed.  This adds redundant state to
the walker and couples its interface to caller-side preparation.

Derive the shared mapping state in the callbacks instead, keeping the
mapping policy with the PTE being processed and simplifying the remap
interface.

No functional change intended.

Link: https://lore.kernel.org/20261104023510.260766-8-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
  Link: https://lore.kernel.org/20261103224659.2865b9ff27d09994949edd78@linux-foundation.org
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: James Houghton <jthoughton@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
---

 include/linux/vmemmap-optimization.h |    6 +
 mm/hugetlb_vmemmap.c                 |   93 +++++++++++--------------
 mm/mm_init.c                         |    6 -
 mm/sparse-vmemmap.c                  |    7 +
 4 files changed, 52 insertions(+), 60 deletions(-)

--- a/include/linux/vmemmap-optimization.h~mm-hugetlb_vmemmap-simplify-shared-tail-page-handling
+++ a/include/linux/vmemmap-optimization.h
@@ -91,11 +91,13 @@ static inline struct page *vmemmap_share
 }
 #endif /* CONFIG_VMEMMAP_OPTIMIZATION */
 
-static inline bool vmemmap_optimizable_pfn(unsigned long pfn)
+static inline bool vmemmap_optimizable_pfn(unsigned long pfn, unsigned int order)
 {
-	const unsigned int order = pfn_to_section_compound_order(pfn);
 	const unsigned long nr_pages = 1UL << order;
 
+	if (!IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION))
+		return false;
+
 	if (!is_power_of_2(sizeof(struct page)))
 		return false;
 
--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-simplify-shared-tail-page-handling
+++ a/mm/hugetlb_vmemmap.c
@@ -25,21 +25,17 @@
  *
  * @remap_pte:		called for each lowest-level entry (PTE).
  * @nr_walked:		the number of walked pte.
- * @vmemmap_tail:	the page to be installed as non-first in the vmemmap range
  * @vmemmap_pages:	list supplying replacement pages for the remap and
  *			receiving displaced backing pages for the caller to free.
  * @flags:		used to modify behavior in vmemmap page table walking
  *			operations.
  */
 struct vmemmap_remap_walk {
-	void			(*remap_pte)(pte_t *pte, unsigned long addr,
+	int			(*remap_pte)(pte_t *pte, unsigned long addr,
 					     struct vmemmap_remap_walk *walk);
-
 	unsigned long		nr_walked;
-	struct page		*vmemmap_tail;
 	struct list_head	*vmemmap_pages;
 
-
 /* Defer safely batchable TLB flushes to the caller. */
 #define VMEMMAP_DEFER_TLB_FLUSH	BIT(0)
 	unsigned long		flags;
@@ -140,12 +136,14 @@ static int vmemmap_pmd_entry(pmd_t *pmd,
 static int vmemmap_pte_entry(pte_t *pte, unsigned long addr,
 			     unsigned long next, struct mm_walk *walk)
 {
+	int ret;
 	struct vmemmap_remap_walk *vmemmap_walk = walk->private;
 
-	vmemmap_walk->remap_pte(pte, addr, vmemmap_walk);
-	vmemmap_walk->nr_walked++;
+	ret = vmemmap_walk->remap_pte(pte, addr, vmemmap_walk);
+	if (!ret)
+		vmemmap_walk->nr_walked++;
 
-	return 0;
+	return ret;
 }
 
 static const struct mm_walk_ops vmemmap_remap_ops = {
@@ -213,53 +211,53 @@ static struct page *vmemmap_dup_page_fro
 	return dst;
 }
 
-static void vmemmap_optimize_pte(pte_t *pte, unsigned long addr,
-		struct vmemmap_remap_walk *walk)
+static inline struct page *folio_vmemmap_shared_tail_page(const struct folio *folio)
 {
-	struct page *page = pte_page(ptep_get(pte));
-	pte_t entry;
-
-	/* Remapping the head page requires r/w */
-	if (unlikely(walk->nr_walked == 0)) {
-		struct page *head;
+	return vmemmap_shared_tail_page(folio_order(folio), folio_zone(folio));
+}
 
-		VM_WARN_ON_ONCE(!PageHead((const struct page *)addr));
+static int vmemmap_optimize_pte(pte_t *pte, unsigned long addr,
+		struct vmemmap_remap_walk *walk)
+{
+	const struct page *page = (const struct page *)addr;
+	const struct folio *folio = page_folio(page);
+	struct page *src = pte_page(ptep_get(pte)), *dst;
 
-		head = vmemmap_dup_page_from_list(page, walk->vmemmap_pages);
-		entry = mk_pte(head, PAGE_KERNEL);
+	if (likely(vmemmap_optimizable_pfn(page_to_pfn(page), folio_order(folio)))) {
+		dst = folio_vmemmap_shared_tail_page(folio);
+		if (!dst)
+			return -ENOMEM;
 	} else {
-		VM_WARN_ON_ONCE(!PageTail((const struct page *)addr));
-
-		/*
-		 * Map the shared tail page writable. A lockless get that read
-		 * a non-zero refcount before the remap can still do its
-		 * cmpxchg after it. The refcount is zero, so the cmpxchg
-		 * fails and leaves the page unchanged.
-		 */
-		entry = mk_pte(walk->vmemmap_tail, PAGE_KERNEL);
+		dst = vmemmap_dup_page_from_list(src, walk->vmemmap_pages);
 	}
 
-	list_add(&page->lru, walk->vmemmap_pages);
-	set_pte_at(&init_mm, addr, pte, entry);
+	list_add(&src->lru, walk->vmemmap_pages);
+	/*
+	 * Map the shared tail page writable intentionally. A lockless get that
+	 * read a non-zero refcount before the remap can still do its cmpxchg
+	 * after it. The refcount is zero, so the cmpxchg fails and leaves the
+	 * page unchanged.
+	 */
+	set_pte_at(&init_mm, addr, pte, mk_pte(dst, PAGE_KERNEL));
+
+	return 0;
 }
 
-static void vmemmap_restore_pte(pte_t *pte, unsigned long addr,
-				struct vmemmap_remap_walk *walk)
+static int vmemmap_restore_pte(pte_t *pte, unsigned long addr,
+		struct vmemmap_remap_walk *walk)
 {
+	const struct page *page = (const struct page *)addr;
+	const struct folio *folio = page_folio(page);
 	struct page *src = pte_page(ptep_get(pte)), *dst;
 
-	/*
-	 * When rolling back vmemmap_remap_free(), keep the copied head page
-	 * mapping and restore only PTEs currently pointing at the shared tail
-	 * page.
-	 */
-	if (walk->vmemmap_tail && walk->vmemmap_tail != src)
-		return;
-
-	VM_WARN_ON_ONCE(PageHead((const struct page *)addr));
+	if (unlikely(!vmemmap_optimizable_pfn(page_to_pfn(page), folio_order(folio))))
+		return 0;
 
+	VM_WARN_ON_ONCE(folio_vmemmap_shared_tail_page(folio) != src);
 	dst = vmemmap_dup_page_from_list(src, walk->vmemmap_pages);
 	set_pte_at(&init_mm, addr, pte, mk_pte(dst, PAGE_KERNEL));
+
+	return 0;
 }
 
 /**
@@ -287,7 +285,6 @@ static int vmemmap_remap_split(unsigned
  *		to remap.
  * @end:	end address of the vmemmap virtual address range that we want to
  *		remap.
- * @vmemmap_tail: the page to be installed as non-first in the vmemmap range
  * @vmemmap_pages: input/output list whose first entry supplies the new backing
  *		page for @start; replaced backing pages are added to the list for
  *		the caller to free.
@@ -296,14 +293,11 @@ static int vmemmap_remap_split(unsigned
  * Return: %0 on success, negative error code otherwise.
  */
 static int vmemmap_remap_free(unsigned long start, unsigned long end,
-			      struct page *vmemmap_tail,
-			      struct list_head *vmemmap_pages,
-			      unsigned long flags)
+		struct list_head *vmemmap_pages, unsigned long flags)
 {
 	int ret;
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= vmemmap_optimize_pte,
-		.vmemmap_tail	= vmemmap_tail,
 		.vmemmap_pages	= vmemmap_pages,
 		.flags		= flags,
 	};
@@ -321,7 +315,6 @@ static int vmemmap_remap_free(unsigned l
 	 */
 	walk = (struct vmemmap_remap_walk) {
 		.remap_pte	= vmemmap_restore_pte,
-		.vmemmap_tail	= vmemmap_tail,
 		.vmemmap_pages	= vmemmap_pages,
 		.flags		= 0,
 	};
@@ -496,7 +489,6 @@ static int __hugetlb_vmemmap_optimize_fo
 					    unsigned long flags)
 {
 	unsigned long vmemmap_start, vmemmap_end;
-	struct page *vmemmap_tail;
 	int nid, ret = 0;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
@@ -506,9 +498,6 @@ static int __hugetlb_vmemmap_optimize_fo
 		return ret;
 
 	nid = folio_nid(folio);
-	vmemmap_tail = vmemmap_shared_tail_page(h->order, folio_zone(folio));
-	if (!vmemmap_tail)
-		return -ENOMEM;
 
 	/*
 	 * Very Subtle
@@ -537,7 +526,7 @@ static int __hugetlb_vmemmap_optimize_fo
 	 * they can be freed by the caller.
 	 */
 	ret = vmemmap_remap_free(vmemmap_start, vmemmap_end,
-				 vmemmap_tail, vmemmap_pages, flags);
+				 vmemmap_pages, flags);
 out:
 	if (ret)
 		folio_clear_hugetlb_vmemmap_optimized(folio);
--- a/mm/mm_init.c~mm-hugetlb_vmemmap-simplify-shared-tail-page-handling
+++ a/mm/mm_init.c
@@ -914,6 +914,8 @@ void __meminit memmap_init_range(unsigne
 #endif
 
 	for (pfn = start_pfn; pfn < end_pfn; ) {
+		const unsigned int order = pfn_to_section_compound_order(pfn);
+
 		/*
 		 * There can be holes in boot-time mem_map[]s handed to this
 		 * function.  They do not exist on hotplugged memory.
@@ -929,9 +931,7 @@ void __meminit memmap_init_range(unsigne
 		 * Vmemmap-optimizable PFNs are backed by shared tail struct pages,
 		 * which have already been initialized during vmemmap population.
 		 */
-		if (vmemmap_optimizable_pfn(pfn)) {
-			const unsigned int order = pfn_to_section_compound_order(pfn);
-
+		if (vmemmap_optimizable_pfn(pfn, order)) {
 			pfn = min(ALIGN(pfn, 1UL << order), end_pfn);
 			continue;
 		}
--- a/mm/sparse-vmemmap.c~mm-hugetlb_vmemmap-simplify-shared-tail-page-handling
+++ a/mm/sparse-vmemmap.c
@@ -241,7 +241,7 @@ static __meminit void *vmemmap_alloc_pte
 	struct page *page;
 	const unsigned int order = pfn_to_section_compound_order(pfn);
 
-	if (!vmemmap_optimizable_pfn(pfn))
+	if (!vmemmap_optimizable_pfn(pfn, order))
 		return vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
 
 	/*
@@ -286,6 +286,7 @@ static pte_t * __meminit vmemmap_pte_pop
 {
 	pte_t *pte = pte_offset_kernel(pmd, addr);
 	unsigned long pfn = page_to_pfn((struct page *)addr);
+	const unsigned int order = pfn_to_section_compound_order(pfn);
 
 	if (pte_none(ptep_get(pte))) {
 		pte_t entry;
@@ -296,10 +297,10 @@ static pte_t * __meminit vmemmap_pte_pop
 
 		entry = pfn_pte(PHYS_PFN(__pa(p)), PAGE_KERNEL);
 		/* Map the shared tail page as read-only to catch illegal writes. */
-		if (vmemmap_optimizable_pfn(pfn))
+		if (vmemmap_optimizable_pfn(pfn, order))
 			entry = pte_wrprotect(entry);
 		set_pte_at(&init_mm, addr, pte, entry);
-	} else if (WARN_ON_ONCE(vmemmap_optimizable_pfn(pfn)))
+	} else if (WARN_ON_ONCE(vmemmap_optimizable_pfn(pfn, order)))
 		return NULL;
 	return pte;
 }
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-fix-missing-page-table-destructor-in-pagetable_free.patch
riscv-mm-fix-hotplug-page-table-destructor-handling.patch
riscv-mm-fix-missing-destructor-for-hotplug-pud-tables.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch
mm-sparse-vmemmap-map-shared-vmemmap-tail-pages-as-read-only.patch
powerpc-mm-map-shared-vmemmap-tail-pages-as-read-only.patch
mm-hugetlb_vmemmap-remove-vmemmap_wrprotect_hvo.patch
mm-hugetlb_vmemmap-remove-hugetlb_vmemmap_optimize_bootmem_folios.patch
mm-generalize-kernel-pte-table-allocation.patch
mm-generalize-pmd-page-table-allocation.patch
mm-generalize-pud-page-table-allocation.patch
mm-remove-pagetable_dtor_free.patch
mm-remove-redundant-pagetable_dtor-calls.patch
mm-hugetlb_vmemmap-move-alloc_vmemmap_page_list-next-to-its-free-helper.patch
mm-hugetlb_vmemmap-make-vmemmap-optimization-folio-oriented.patch
mm-hugetlb_vmemmap-make-vmemmap-restoration-folio-oriented.patch
mm-hugetlb_vmemmap-unify-vmemmap-range-restoration.patch
mm-hugetlb_vmemmap-make-vmemmap-pte-conversion-folio-oriented.patch
mm-hugetlb-fix-validation-of-unsupported-hugetlb-orders.patch

