From: akpm@linux-foundation.org
Subject: +
 mm-add-tlb_remove_check_page_size_change-to-track-page-size-change.patch
 added to -mm tree
Date: Wed, 26 Oct 2016 16:36:09 -0700
Message-ID: <58113de9.Qao71tWWS4XH5lye%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41436 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933434AbcJZXgP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Oct 2016 19:36:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, dan.j.williams@intel.com, kirill@shutemov.name, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add tlb_remove_check_page_size_change to track page size change
has been added to the -mm tree.  Its filename is
     mm-add-tlb_remove_check_page_size_change-to-track-page-size-change.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-tlb_remove_check_page_size_change-to-track-page-size-change.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-tlb_remove_check_page_size_change-to-track-page-size-change.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm: add tlb_remove_check_page_size_change to track page size change

With commit e77b0852b551 ("mm/mmu_gather: track page size with mmu gather
and force flush if page size change") we added the ability to force a tlb
flush when the page size change in a mmu_gather loop.  We did that by
checking for a page size change every time we added a page to mmu_gather
for lazy flush/remove.  We can improve that by moving the page size change
check early and not doing it every time we add a page.

This also helps us to do tlb flush when invalidating a range covering dax
mapping.  W.r.t dax mapping we don't have a backing struct page and hence
we don't call tlb_remove_page, which earlier forced the tlb flush on page
size change.  Moving the page size change check earlier means we will do
the same even for dax mapping.

We also avoid doing this check on architecture other than powerpc.

In a later patch we will remove page size check from tlb_remove_page().

Link: http://lkml.kernel.org/r/20161026084839.27299-5-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/tlb.h     |    6 ++++++
 arch/ia64/include/asm/tlb.h    |    6 ++++++
 arch/powerpc/include/asm/tlb.h |   16 ++++++++++++++++
 arch/s390/include/asm/tlb.h    |    6 ++++++
 arch/sh/include/asm/tlb.h      |    6 ++++++
 arch/um/include/asm/tlb.h      |    6 ++++++
 include/asm-generic/tlb.h      |   16 ++++++++++++++++
 mm/huge_memory.c               |    4 ++++
 mm/hugetlb.c                   |    5 +++++
 mm/madvise.c                   |    1 +
 mm/memory.c                    |    7 ++++++-
 11 files changed, 78 insertions(+), 1 deletion(-)

diff -puN arch/arm/include/asm/tlb.h~mm-add-tlb_remove_check_page_size_change-to-track-page-size-change arch/arm/include/asm/tlb.h
--- a/arch/arm/include/asm/tlb.h~mm-add-tlb_remove_check_page_size_change-to-track-page-size-change
+++ a/arch/arm/include/asm/tlb.h
@@ -286,5 +286,11 @@ tlb_remove_pmd_tlb_entry(struct mmu_gath
 
 #define tlb_migrate_finish(mm)		do { } while (0)
 
+#define tlb_remove_check_page_size_change tlb_remove_check_page_size_change
+static inline void tlb_remove_check_page_size_change(struct mmu_gather *tlb,
+						     unsigned int page_size)
+{
+}
+
 #endif /* CONFIG_MMU */
 #endif
diff -puN arch/ia64/include/asm/tlb.h~mm-add-tlb_remove_check_page_size_change-to-track-page-size-change arch/ia64/include/asm/tlb.h
--- a/arch/ia64/include/asm/tlb.h~mm-add-tlb_remove_check_page_size_change-to-track-page-size-change
+++ a/arch/ia64/include/asm/tlb.h
@@ -286,6 +286,12 @@ do {							\
 #define tlb_remove_huge_tlb_entry(h, tlb, ptep, address)	\
 	tlb_remove_tlb_entry(tlb, ptep, address)
 
+#define tlb_remove_check_page_size_change tlb_remove_check_page_size_change
+static inline void tlb_remove_check_page_size_change(struct mmu_gather *tlb,
+						     unsigned int page_size)
+{
+}
+
 #define pte_free_tlb(tlb, ptep, address)		\
 do {							\
 	tlb->need_flush = 1;				\
diff -puN arch/powerpc/include/asm/tlb.h~mm-add-tlb_remove_check_page_size_change-to-track-page-size-change arch/powerpc/include/asm/tlb.h
--- a/arch/powerpc/include/asm/tlb.h~mm-add-tlb_remove_check_page_size_change-to-track-page-size-change
+++ a/arch/powerpc/include/asm/tlb.h
@@ -28,6 +28,7 @@
 #define tlb_start_vma(tlb, vma)	do { } while (0)
 #define tlb_end_vma(tlb, vma)	do { } while (0)
 #define __tlb_remove_tlb_entry	__tlb_remove_tlb_entry
+#define tlb_remove_check_page_size_change tlb_remove_check_page_size_change
 
 extern void tlb_flush(struct mmu_gather *tlb);
 
@@ -46,6 +47,21 @@ static inline void __tlb_remove_tlb_entr
 #endif
 }
 
+static inline void tlb_remove_check_page_size_change(struct mmu_gather *tlb,
+						     unsigned int page_size)
+{
+	if (!tlb->page_size)
+		tlb->page_size = page_size;
+	else if (tlb->page_size != page_size) {
+		tlb_flush_mmu(tlb);
+		/*
+		 * update the page size after flush for the new
+		 * mmu_gather.
+		 */
+		tlb->page_size = page_size;
+	}
+}
+
 #ifdef CONFIG_SMP
 static inline int mm_is_core_local(struct mm_struct *mm)
 {
diff -puN arch/s390/include/asm/tlb.h~mm-add-tlb_remove_check_page_size_change-to-track-page-size-change arch/s390/include/asm/tlb.h
--- a/arch/s390/include/asm/tlb.h~mm-add-tlb_remove_check_page_size_change-to-track-page-size-change
+++ a/arch/s390/include/asm/tlb.h
@@ -165,4 +165,10 @@ static inline void pud_free_tlb(struct m
 #define tlb_remove_huge_tlb_entry(h, tlb, ptep, address)	\
 	tlb_remove_tlb_entry(tlb, ptep, address)
 
+#define tlb_remove_check_page_size_change tlb_remove_check_page_size_change
+static inline void tlb_remove_check_page_size_change(struct mmu_gather *tlb,
+						     unsigned int page_size)
+{
+}
+
 #endif /* _S390_TLB_H */
diff -puN arch/sh/include/asm/tlb.h~mm-add-tlb_remove_check_page_size_change-to-track-page-size-change arch/sh/include/asm/tlb.h
--- a/arch/sh/include/asm/tlb.h~mm-add-tlb_remove_check_page_size_change-to-track-page-size-change
+++ a/arch/sh/include/asm/tlb.h
@@ -130,6 +130,12 @@ static inline void tlb_remove_page_size(
 	return tlb_remove_page(tlb, page);
 }
 
+#define tlb_remove_check_page_size_change tlb_remove_check_page_size_change
+static inline void tlb_remove_check_page_size_change(struct mmu_gather *tlb,
+						     unsigned int page_size)
+{
+}
+
 #define pte_free_tlb(tlb, ptep, addr)	pte_free((tlb)->mm, ptep)
 #define pmd_free_tlb(tlb, pmdp, addr)	pmd_free((tlb)->mm, pmdp)
 #define pud_free_tlb(tlb, pudp, addr)	pud_free((tlb)->mm, pudp)
diff -puN arch/um/include/asm/tlb.h~mm-add-tlb_remove_check_page_size_change-to-track-page-size-change arch/um/include/asm/tlb.h
--- a/arch/um/include/asm/tlb.h~mm-add-tlb_remove_check_page_size_change-to-track-page-size-change
+++ a/arch/um/include/asm/tlb.h
@@ -144,6 +144,12 @@ static inline void tlb_remove_page_size(
 #define tlb_remove_huge_tlb_entry(h, tlb, ptep, address)	\
 	tlb_remove_tlb_entry(tlb, ptep, address)
 
+#define tlb_remove_check_page_size_change tlb_remove_check_page_size_change
+static inline void tlb_remove_check_page_size_change(struct mmu_gather *tlb,
+						     unsigned int page_size)
+{
+}
+
 #define pte_free_tlb(tlb, ptep, addr) __pte_free_tlb(tlb, ptep, addr)
 
 #define pud_free_tlb(tlb, pudp, addr) __pud_free_tlb(tlb, pudp, addr)
diff -puN include/asm-generic/tlb.h~mm-add-tlb_remove_check_page_size_change-to-track-page-size-change include/asm-generic/tlb.h
--- a/include/asm-generic/tlb.h~mm-add-tlb_remove_check_page_size_change-to-track-page-size-change
+++ a/include/asm-generic/tlb.h
@@ -182,6 +182,22 @@ static inline bool __tlb_remove_pte_page
 	return __tlb_remove_page(tlb, page);
 }
 
+#ifndef tlb_remove_check_page_size_change
+#define tlb_remove_check_page_size_change tlb_remove_check_page_size_change
+static inline void tlb_remove_check_page_size_change(struct mmu_gather *tlb,
+						     unsigned int page_size)
+{
+	/*
+	 * We don't care about page size change, just update
+	 * mmu_gather page size here so that debug checks
+	 * doesn't throw false warning.
+	 */
+#ifdef CONFIG_DEBUG_VM
+	tlb->page_size = page_size;
+#endif
+}
+#endif
+
 /*
  * In the case of tlb vma handling, we can optimise these away in the
  * case where we're doing a full MM flush.  When we're doing a munmap,
diff -puN mm/huge_memory.c~mm-add-tlb_remove_check_page_size_change-to-track-page-size-change mm/huge_memory.c
--- a/mm/huge_memory.c~mm-add-tlb_remove_check_page_size_change-to-track-page-size-change
+++ a/mm/huge_memory.c
@@ -1322,6 +1322,8 @@ bool madvise_free_huge_pmd(struct mmu_ga
 	struct mm_struct *mm = tlb->mm;
 	bool ret = false;
 
+	tlb_remove_check_page_size_change(tlb, HPAGE_PMD_SIZE);
+
 	ptl = pmd_trans_huge_lock(pmd, vma);
 	if (!ptl)
 		goto out_unlocked;
@@ -1383,6 +1385,8 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 	pmd_t orig_pmd;
 	spinlock_t *ptl;
 
+	tlb_remove_check_page_size_change(tlb, HPAGE_PMD_SIZE);
+
 	ptl = __pmd_trans_huge_lock(pmd, vma);
 	if (!ptl)
 		return 0;
diff -puN mm/hugetlb.c~mm-add-tlb_remove_check_page_size_change-to-track-page-size-change mm/hugetlb.c
--- a/mm/hugetlb.c~mm-add-tlb_remove_check_page_size_change-to-track-page-size-change
+++ a/mm/hugetlb.c
@@ -3222,6 +3222,11 @@ void __unmap_hugepage_range(struct mmu_g
 	BUG_ON(start & ~huge_page_mask(h));
 	BUG_ON(end & ~huge_page_mask(h));
 
+	/*
+	 * This is a hugetlb vma, all the pte entries should point
+	 * to huge page.
+	 */
+	tlb_remove_check_page_size_change(tlb, sz);
 	tlb_start_vma(tlb, vma);
 	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
 	address = start;
diff -puN mm/madvise.c~mm-add-tlb_remove_check_page_size_change-to-track-page-size-change mm/madvise.c
--- a/mm/madvise.c~mm-add-tlb_remove_check_page_size_change-to-track-page-size-change
+++ a/mm/madvise.c
@@ -281,6 +281,7 @@ static int madvise_free_pte_range(pmd_t
 	if (pmd_trans_unstable(pmd))
 		return 0;
 
+	tlb_remove_check_page_size_change(tlb, PAGE_SIZE);
 	orig_pte = pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
 	arch_enter_lazy_mmu_mode();
 	for (; addr != end; pte++, addr += PAGE_SIZE) {
diff -puN mm/memory.c~mm-add-tlb_remove_check_page_size_change-to-track-page-size-change mm/memory.c
--- a/mm/memory.c~mm-add-tlb_remove_check_page_size_change-to-track-page-size-change
+++ a/mm/memory.c
@@ -528,7 +528,11 @@ void free_pgd_range(struct mmu_gather *t
 		end -= PMD_SIZE;
 	if (addr > end - 1)
 		return;
-
+	/*
+	 * We add page table cache pages with PAGE_SIZE,
+	 * (see pte_free_tlb()), flush the tlb if we need
+	 */
+	tlb_remove_check_page_size_change(tlb, PAGE_SIZE);
 	pgd = pgd_offset(tlb->mm, addr);
 	do {
 		next = pgd_addr_end(addr, end);
@@ -1120,6 +1124,7 @@ static unsigned long zap_pte_range(struc
 	swp_entry_t entry;
 	struct page *pending_page = NULL;
 
+	tlb_remove_check_page_size_change(tlb, PAGE_SIZE);
 again:
 	init_rss_vec(rss);
 	start_pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

mm-hugetlb-use-the-right-pte-val-for-compare-in-hugetlb_cow.patch
mm-hugetlb-use-huge_pte_lock-instead-of-opencoding-the-lock.patch
mm-use-the-correct-page-size-when-removing-the-page.patch
mm-update-mmu_gather-range-correctly.patch
mm-hugetlb-add-tlb_remove_hugetlb_entry-for-handling-hugetlb-pages.patch
mm-add-tlb_remove_check_page_size_change-to-track-page-size-change.patch
mm-remove-the-page-size-change-check-in-tlb_remove_page.patch

