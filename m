Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794023628;
	b=deip5ZIkl7E7pzVEV3k+E/k7zcy6HBVnMpd2cbhYkCtCC7CiD1zbkZIVsFcjfgvM7CGO
	 scGWOVa9NU+h3ks0iXIQ/JEXobxSlVBADOKWBxtLKF7pTVX1GLhlR7b55+PrwiZT9XBFn
	 Tj+vwd/6fVVURgR0LuPcL05Y2mhao1w+Bwo4OthipqvUnonuRwbKzbKtDgF/xJv1w/owX
	 l33u4R7nyJpGzGoSAnMdpJYjjKjU2ifQNG1uAgc/RSujrUpGGA3z302PV+AbfZkrPulSu
	 U9Ru5E+TqIHyfDcMxCC9+7L9+EqQUxTG1cynIuMXZyTP8ZlgNBMovQNO52itWdZNoJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794023628;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=SDyaT7BtrgBfS/Uhe8Dlb+RX9xGAc+xEkjHYZXXGi94=;
	b=0wMEvV3rBaGV5oRyniCngWXedU3OiRKTkQu203nEFIXi86ZIuxDwfJYtA+5XoRPaOYTH
	 E5j2Q9kb4eQ0P+TVxDA85H2Ddtamb1HO1feARNvPyvujAtI/1As5lj5gBPcZ3qkzlBfyh
	 lFCj4XljOYszapP8d6fvAnHdyU01K949aeJAEY+XxtQzaG3SjjZ+YAjqsByXr1tO8m1Ug
	 wVioA4v5loybxLpGLkrMB5hytXCEiM9CdcPuqGKuWnJOZdJtUuoXHdnoaBua/ihX5oGZX
	 aYh+gMAaf3gtxxChmGlIYZ8jDXLfaQAtNIYdIGkXozr9TGMSSG28icrOWz3Uzi0u9RQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=AvNvUWd9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E7E606A32F
	for <mm-commits@vger.kernel.org>; Sat,  7 Nov 2026 03:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=AvNvUWd9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E9E1F008A1;
	Sat,  7 Nov 2026 03:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794023627;
	bh=SDyaT7BtrgBfS/Uhe8Dlb+RX9xGAc+xEkjHYZXXGi94=;
	h=Date:To:From:Subject;
	b=AvNvUWd92EnirM+GccTGxK4HHLsSLMJTFLQKOkhy5pW7pVWjGrt8pJb0UGtgz+6Za
	 WxhSXTPcLmSW+DLhOoAAXJngJxUR+VwdZ5zxax8kUj3cI0kpDMARxXSfKH3bJR2URF
	 0kwCoLA7jR48xPD5T5gaxnnAMM5+Qhxq61ziyzaQ=
Date: Fri, 06 Nov 2026 19:53:46 -0800
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-simplify-shared-tail-page-handling.patch added to mm-unstable branch
Message-Id: <20261107035347.08E9E1F008A1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: hugetlb_vmemmap: simplify shared tail page handling
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-simplify-shared-tail-page-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-simplify-shared-tail-page-handling.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Muchun Song <muchun.song@linux.dev>
Subject: mm: hugetlb_vmemmap: simplify shared tail page handling
Date: Sat, 07 Nov 2026 10:27:51 +0800

The remap walker currently carries a shared tail page selected by its
caller, even though the optimize and restore callbacks can derive the
same information from the folio being processed.  This adds redundant
state to the walker and couples its interface to caller-side preparation.

Derive the shared mapping state in the callbacks instead, keeping the
mapping policy with the PTE being processed and simplifying the remap
interface.

No functional change intended.

Link: https://lore.kernel.org/20261107022756.77731-9-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: James Houghton <jthoughton@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Yili Zhang <zhangyili01@baidu.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
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
@@ -498,7 +491,6 @@ static int __hugetlb_vmemmap_optimize_fo
 					    unsigned long flags)
 {
 	unsigned long vmemmap_start, vmemmap_end;
-	struct page *vmemmap_tail;
 	gfp_t gfp_mask = GFP_KERNEL | __GFP_NOWARN;
 	int nid, ret = 0;
 
@@ -509,9 +501,6 @@ static int __hugetlb_vmemmap_optimize_fo
 		return ret;
 
 	nid = folio_nid(folio);
-	vmemmap_tail = vmemmap_shared_tail_page(h->order, folio_zone(folio));
-	if (!vmemmap_tail)
-		return -ENOMEM;
 
 	/*
 	 * Very Subtle
@@ -540,7 +529,7 @@ static int __hugetlb_vmemmap_optimize_fo
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
mm-hugetlb_vmemmap-remove-hugetlb-specific-vmemmap-optimization-macros.patch
mm-hugetlb_vmemmap-unify-vmemmap_splitremap_no_tlb_flush.patch
mm-hugetlb_vmemmap-simplify-vmemmap-head-page-handling.patch
mm-hugetlb_vmemmap-generalize-vmemmap-page-allocation.patch
mm-hugetlb_vmemmap-unify-writable-vmemmap-page-preparation.patch
mm-hugetlb_vmemmap-rename-vmemmap_remap_pte-to-vmemmap_optimize_pte.patch
mm-hugetlb_vmemmap-simplify-shared-tail-page-handling.patch
mm-hugetlb_vmemmap-move-alloc_vmemmap_page_list-next-to-its-free-helper.patch
mm-hugetlb_vmemmap-make-vmemmap-optimization-folio-oriented.patch
mm-hugetlb_vmemmap-make-vmemmap-restoration-folio-oriented.patch
mm-hugetlb_vmemmap-unify-vmemmap-range-restoration.patch
mm-hugetlb_vmemmap-make-vmemmap-pte-conversion-folio-oriented.patch
mm-hugetlb-fix-validation-of-unsupported-hugetlb-orders.patch

