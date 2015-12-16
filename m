From: akpm@linux-foundation.org
Subject: + mm-x86-get_user_pages-for-dax-mappings.patch added to -mm tree
Date: Tue, 15 Dec 2015 16:17:20 -0800
Message-ID: <5670ad90.EKrBJWwIhDROL5vZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47339 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932727AbbLPARV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Dec 2015 19:17:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, aarcange@redhat.com, dave.hansen@linux.intel.com, hpa@zytor.com, logang@deltatee.com, mgorman@suse.de, mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, x86: get_user_pages() for dax mappings
has been added to the -mm tree.  Its filename is
     mm-x86-get_user_pages-for-dax-mappings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-x86-get_user_pages-for-dax-mappings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-x86-get_user_pages-for-dax-mappings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm, x86: get_user_pages() for dax mappings

A dax mapping establishes a pte with _PAGE_DEVMAP set when the driver has
established a devm_memremap_pages() mapping, i.e.  when the pfn_t return
from ->direct_access() has PFN_DEV and PFN_MAP set.  Later, when
encountering _PAGE_DEVMAP during a page table walk we lookup and pin a
struct dev_pagemap instance to keep the result of pfn_to_page() valid
until put_page().

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Logan Gunthorpe <logang@deltatee.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/gup.c       |   56 +++++++++++++++++++++++++++-
 include/linux/huge_mm.h |   10 ++++-
 include/linux/mm.h      |   35 ++++++++++++-----
 mm/gup.c                |   18 ++++++++-
 mm/huge_memory.c        |   74 ++++++++++++++++++++++++++++++--------
 mm/swap.c               |   15 +++++++
 6 files changed, 178 insertions(+), 30 deletions(-)

diff -puN arch/x86/mm/gup.c~mm-x86-get_user_pages-for-dax-mappings arch/x86/mm/gup.c
--- a/arch/x86/mm/gup.c~mm-x86-get_user_pages-for-dax-mappings
+++ a/arch/x86/mm/gup.c
@@ -63,6 +63,16 @@ retry:
 #endif
 }
 
+static void undo_dev_pagemap(int *nr, int nr_start, struct page **pages)
+{
+	while ((*nr) - nr_start) {
+		struct page *page = pages[--(*nr)];
+
+		ClearPageReferenced(page);
+		put_page(page);
+	}
+}
+
 /*
  * The performance critical leaf functions are made noinline otherwise gcc
  * inlines everything into a single function which results in too much
@@ -71,7 +81,9 @@ retry:
 static noinline int gup_pte_range(pmd_t pmd, unsigned long addr,
 		unsigned long end, int write, struct page **pages, int *nr)
 {
+	struct dev_pagemap *pgmap = NULL;
 	unsigned long mask;
+	int nr_start = *nr;
 	pte_t *ptep;
 
 	mask = _PAGE_PRESENT|_PAGE_USER;
@@ -89,13 +101,21 @@ static noinline int gup_pte_range(pmd_t
 			return 0;
 		}
 
-		if ((pte_flags(pte) & (mask | _PAGE_SPECIAL)) != mask) {
+		page = pte_page(pte);
+		if (pte_devmap(pte)) {
+			pgmap = get_dev_pagemap(pte_pfn(pte), pgmap);
+			if (unlikely(!pgmap)) {
+				undo_dev_pagemap(nr, nr_start, pages);
+				pte_unmap(ptep);
+				return 0;
+			}
+		} else if ((pte_flags(pte) & (mask | _PAGE_SPECIAL)) != mask) {
 			pte_unmap(ptep);
 			return 0;
 		}
 		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
-		page = pte_page(pte);
 		get_page(page);
+		put_dev_pagemap(pgmap);
 		SetPageReferenced(page);
 		pages[*nr] = page;
 		(*nr)++;
@@ -114,6 +134,32 @@ static inline void get_head_page_multipl
 	SetPageReferenced(page);
 }
 
+static int __gup_device_huge_pmd(pmd_t pmd, unsigned long addr,
+		unsigned long end, struct page **pages, int *nr)
+{
+	int nr_start = *nr;
+	unsigned long pfn = pmd_pfn(pmd);
+	struct dev_pagemap *pgmap = NULL;
+
+	pfn += (addr & ~PMD_MASK) >> PAGE_SHIFT;
+	do {
+		struct page *page = pfn_to_page(pfn);
+
+		pgmap = get_dev_pagemap(pfn, pgmap);
+		if (unlikely(!pgmap)) {
+			undo_dev_pagemap(nr, nr_start, pages);
+			return 0;
+		}
+		SetPageReferenced(page);
+		pages[*nr] = page;
+		get_page(page);
+		put_dev_pagemap(pgmap);
+		(*nr)++;
+		pfn++;
+	} while (addr += PAGE_SIZE, addr != end);
+	return 1;
+}
+
 static noinline int gup_huge_pmd(pmd_t pmd, unsigned long addr,
 		unsigned long end, int write, struct page **pages, int *nr)
 {
@@ -126,9 +172,13 @@ static noinline int gup_huge_pmd(pmd_t p
 		mask |= _PAGE_RW;
 	if ((pmd_flags(pmd) & mask) != mask)
 		return 0;
+
+	VM_BUG_ON(!pfn_valid(pmd_pfn(pmd)));
+	if (pmd_devmap(pmd))
+		return __gup_device_huge_pmd(pmd, addr, end, pages, nr);
+
 	/* hugepages are never "special" */
 	VM_BUG_ON(pmd_flags(pmd) & _PAGE_SPECIAL);
-	VM_BUG_ON(!pfn_valid(pmd_pfn(pmd)));
 
 	refs = 0;
 	head = pmd_page(pmd);
diff -puN include/linux/huge_mm.h~mm-x86-get_user_pages-for-dax-mappings include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-x86-get_user_pages-for-dax-mappings
+++ a/include/linux/huge_mm.h
@@ -38,7 +38,6 @@ extern int change_huge_pmd(struct vm_are
 			int prot_numa);
 int vmf_insert_pfn_pmd(struct vm_area_struct *, unsigned long addr, pmd_t *,
 			pfn_t pfn, bool write);
-
 enum transparent_hugepage_flag {
 	TRANSPARENT_HUGEPAGE_FLAG,
 	TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
@@ -55,6 +54,9 @@ enum transparent_hugepage_flag {
 #define HPAGE_PMD_NR (1<<HPAGE_PMD_ORDER)
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+struct page *follow_devmap_pmd(struct vm_area_struct *vma, unsigned long addr,
+		pmd_t *pmd, int flags);
+
 #define HPAGE_PMD_SHIFT PMD_SHIFT
 #define HPAGE_PMD_SIZE	((1UL) << HPAGE_PMD_SHIFT)
 #define HPAGE_PMD_MASK	(~(HPAGE_PMD_SIZE - 1))
@@ -205,6 +207,12 @@ static inline bool is_huge_zero_page(str
 	return false;
 }
 
+
+static inline struct page *follow_devmap_pmd(struct vm_area_struct *vma,
+		unsigned long addr, pmd_t *pmd, int flags)
+{
+	return NULL;
+}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #endif /* _LINUX_HUGE_MM_H */
diff -puN include/linux/mm.h~mm-x86-get_user_pages-for-dax-mappings include/linux/mm.h
--- a/include/linux/mm.h~mm-x86-get_user_pages-for-dax-mappings
+++ a/include/linux/mm.h
@@ -472,16 +472,7 @@ static inline int page_count(struct page
 	return atomic_read(&compound_head(page)->_count);
 }
 
-static inline void get_page(struct page *page)
-{
-	page = compound_head(page);
-	/*
-	 * Getting a normal page or the head of a compound page
-	 * requires to already have an elevated page->_count.
-	 */
-	VM_BUG_ON_PAGE(atomic_read(&page->_count) <= 0, page);
-	atomic_inc(&page->_count);
-}
+extern bool __get_page_tail(struct page *page);
 
 static inline struct page *virt_to_head_page(const void *x)
 {
@@ -774,6 +765,11 @@ struct dev_pagemap {
 void *devm_memremap_pages(struct device *dev, struct resource *res,
 		struct percpu_ref *ref, struct vmem_altmap *altmap);
 struct dev_pagemap *find_dev_pagemap(resource_size_t phys);
+
+static inline bool is_zone_device_page(const struct page *page)
+{
+	return page_zonenum(page) == ZONE_DEVICE;
+}
 #else
 static inline void *devm_memremap_pages(struct device *dev,
 		struct resource *res, struct percpu_ref *ref,
@@ -792,6 +788,11 @@ static inline struct dev_pagemap *find_d
 {
 	return NULL;
 }
+
+static inline bool is_zone_device_page(const struct page *page)
+{
+	return false;
+}
 #endif
 
 #if defined(CONFIG_SPARSEMEM_VMEMMAP) && defined(CONFIG_ZONE_DEVICE)
@@ -842,6 +843,20 @@ static inline void put_dev_pagemap(struc
 		percpu_ref_put(pgmap->ref);
 }
 
+static inline void get_page(struct page *page)
+{
+	if (is_zone_device_page(page))
+		percpu_ref_get(page->pgmap->ref);
+
+	page = compound_head(page);
+	/*
+	 * Getting a normal page or the head of a compound page
+	 * requires to already have an elevated page->_count.
+	 */
+	VM_BUG_ON_PAGE(atomic_read(&page->_count) <= 0, page);
+	atomic_inc(&page->_count);
+}
+
 #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
 #define SECTION_IN_PAGE_FLAGS
 #endif
diff -puN mm/gup.c~mm-x86-get_user_pages-for-dax-mappings mm/gup.c
--- a/mm/gup.c~mm-x86-get_user_pages-for-dax-mappings
+++ a/mm/gup.c
@@ -98,7 +98,16 @@ retry:
 	}
 
 	page = vm_normal_page(vma, address, pte);
-	if (unlikely(!page)) {
+	if (!page && pte_devmap(pte) && (flags & FOLL_GET)) {
+		/*
+		 * Only return device mapping pages in the FOLL_GET case since
+		 * they are only valid while holding the pgmap reference.
+		 */
+		if (get_dev_pagemap(pte_pfn(pte), NULL))
+			page = pte_page(pte);
+		else
+			goto no_page;
+	} else if (unlikely(!page)) {
 		if (flags & FOLL_DUMP) {
 			/* Avoid special (like zero) pages in core dumps */
 			page = ERR_PTR(-EFAULT);
@@ -237,6 +246,13 @@ struct page *follow_page_mask(struct vm_
 	}
 	if ((flags & FOLL_NUMA) && pmd_protnone(*pmd))
 		return no_page_table(vma, flags);
+	if (pmd_devmap(*pmd)) {
+		ptl = pmd_lock(mm, pmd);
+		page = follow_devmap_pmd(vma, address, pmd, flags);
+		spin_unlock(ptl);
+		if (page)
+			return page;
+	}
 	if (likely(!pmd_trans_huge(*pmd)))
 		return follow_page_pte(vma, address, pmd, flags);
 
diff -puN mm/huge_memory.c~mm-x86-get_user_pages-for-dax-mappings mm/huge_memory.c
--- a/mm/huge_memory.c~mm-x86-get_user_pages-for-dax-mappings
+++ a/mm/huge_memory.c
@@ -1002,6 +1002,63 @@ int vmf_insert_pfn_pmd(struct vm_area_st
 	return VM_FAULT_NOPAGE;
 }
 
+static void touch_pmd(struct vm_area_struct *vma, unsigned long addr,
+		pmd_t *pmd)
+{
+	pmd_t _pmd;
+
+	/*
+	 * We should set the dirty bit only for FOLL_WRITE but for now
+	 * the dirty bit in the pmd is meaningless.  And if the dirty
+	 * bit will become meaningful and we'll only set it with
+	 * FOLL_WRITE, an atomic set_bit will be required on the pmd to
+	 * set the young bit, instead of the current set_pmd_at.
+	 */
+	_pmd = pmd_mkyoung(pmd_mkdirty(*pmd));
+	if (pmdp_set_access_flags(vma, addr & HPAGE_PMD_MASK,
+				pmd, _pmd,  1))
+		update_mmu_cache_pmd(vma, addr, pmd);
+}
+
+struct page *follow_devmap_pmd(struct vm_area_struct *vma, unsigned long addr,
+		pmd_t *pmd, int flags)
+{
+	unsigned long pfn = pmd_pfn(*pmd);
+	struct mm_struct *mm = vma->vm_mm;
+	struct dev_pagemap *pgmap;
+	struct page *page;
+
+	assert_spin_locked(pmd_lockptr(mm, pmd));
+
+	if (flags & FOLL_WRITE && !pmd_write(*pmd))
+		return NULL;
+
+	if (pmd_present(*pmd) && pmd_devmap(*pmd))
+		/* pass */;
+	else
+		return NULL;
+
+	if (flags & FOLL_TOUCH)
+		touch_pmd(vma, addr, pmd);
+
+	/*
+	 * device mapped pages can only be returned if the
+	 * caller will manage the page reference count.
+	 */
+	if (!(flags & FOLL_GET))
+		return ERR_PTR(-EEXIST);
+
+	pfn += (addr & ~PMD_MASK) >> PAGE_SHIFT;
+	pgmap = get_dev_pagemap(pfn, NULL);
+	if (!pgmap)
+		return ERR_PTR(-EFAULT);
+	page = pfn_to_page(pfn);
+	get_page(page);
+	put_dev_pagemap(pgmap);
+
+	return page;
+}
+
 int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		  pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
 		  struct vm_area_struct *vma)
@@ -1359,21 +1416,8 @@ struct page *follow_trans_huge_pmd(struc
 
 	page = pmd_page(*pmd);
 	VM_BUG_ON_PAGE(!PageHead(page), page);
-	if (flags & FOLL_TOUCH) {
-		pmd_t _pmd;
-		/*
-		 * We should set the dirty bit only for FOLL_WRITE but
-		 * for now the dirty bit in the pmd is meaningless.
-		 * And if the dirty bit will become meaningful and
-		 * we'll only set it with FOLL_WRITE, an atomic
-		 * set_bit will be required on the pmd to set the
-		 * young bit, instead of the current set_pmd_at.
-		 */
-		_pmd = pmd_mkyoung(pmd_mkdirty(*pmd));
-		if (pmdp_set_access_flags(vma, addr & HPAGE_PMD_MASK,
-					  pmd, _pmd,  1))
-			update_mmu_cache_pmd(vma, addr, pmd);
-	}
+	if (flags & FOLL_TOUCH)
+		touch_pmd(vma, addr, pmd);
 	if ((flags & FOLL_MLOCK) && (vma->vm_flags & VM_LOCKED)) {
 		/*
 		 * We don't mlock() pte-mapped THPs. This way we can avoid
diff -puN mm/swap.c~mm-x86-get_user_pages-for-dax-mappings mm/swap.c
--- a/mm/swap.c~mm-x86-get_user_pages-for-dax-mappings
+++ a/mm/swap.c
@@ -90,10 +90,25 @@ static void __put_compound_page(struct p
 	(*dtor)(page);
 }
 
+static bool put_device_page(struct page *page)
+{
+	/*
+	 * ZONE_DEVICE pages are never "onlined" so their reference
+	 * counts never reach zero.  They are always owned by a device
+	 * driver, not the mm core.  I.e. the page is 'idle' when the
+	 * count is 1.
+	 */
+	VM_BUG_ON_PAGE(atomic_read(&page->_count) == 1, page);
+	put_dev_pagemap(page->pgmap);
+	return atomic_dec_return(&page->_count) == 1;
+}
+
 void __put_page(struct page *page)
 {
 	if (unlikely(PageCompound(page)))
 		__put_compound_page(page);
+	else if (is_zone_device_page(page))
+		put_device_page(page);
 	else
 		__put_single_page(page);
 }
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

scatterlist-fix-sg_phys-masking.patch
pmem-dax-clean-up-clear_pmem.patch
dax-increase-granularity-of-dax_clear_blocks-operations.patch
dax-guarantee-page-aligned-results-from-bdev_direct_access.patch
dax-fix-lifetime-of-in-kernel-dax-mappings-with-dax_map_atomic.patch
dax-fix-lifetime-of-in-kernel-dax-mappings-with-dax_map_atomic-v3.patch
um-kill-pfn_t.patch
kvm-rename-pfn_t-to-kvm_pfn_t.patch
mm-dax-pmem-introduce-pfn_t.patch
mm-dax-pmem-introduce-pfn_t-v3.patch
mm-introduce-find_dev_pagemap.patch
x86-mm-introduce-vmem_altmap-to-augment-vmemmap_populate.patch
libnvdimm-pfn-pmem-allocate-memmap-array-in-persistent-memory.patch
avr32-convert-to-asm-generic-memory_modelh.patch
hugetlb-fix-compile-error-on-tile.patch
frv-fix-compiler-warning-from-definition-of-__pmd.patch
x86-mm-introduce-_page_devmap.patch
mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t.patch
mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t.patch
list-introduce-list_del_poison.patch
libnvdimm-pmem-move-request_queue-allocation-earlier-in-probe.patch
mm-dax-pmem-introduce-getput_dev_pagemap-for-dax-gup.patch
mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd.patch
mm-x86-get_user_pages-for-dax-mappings.patch
dax-provide-diagnostics-for-pmd-mapping-failures.patch
dax-re-enable-dax-pmd-mappings.patch

