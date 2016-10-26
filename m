From: akpm@linux-foundation.org
Subject: + mm-remove-the-page-size-change-check-in-tlb_remove_page.patch
 added to -mm tree
Date: Wed, 26 Oct 2016 16:36:13 -0700
Message-ID: <58113ded.cMzubjA4Qsn/bMSb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41444 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933434AbcJZXgO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Oct 2016 19:36:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, dan.j.williams@intel.com, kirill@shutemov.name, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove the page size change check in tlb_remove_page
has been added to the -mm tree.  Its filename is
     mm-remove-the-page-size-change-check-in-tlb_remove_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-the-page-size-change-check-in-tlb_remove_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-the-page-size-change-check-in-tlb_remove_page.patch

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
Subject: mm: remove the page size change check in tlb_remove_page

Now that we check for page size change early in the loop, we can partially
revert e9d55e157034a ("mm: change the interface for __tlb_remove_page").

This simplies the code much, by removing the need to track the last
address with which we adjusted the range.  We also go back to the older
way of filling the mmu_gather array, ie, we add an entry and then check
whether the gather batch is full.

Link: http://lkml.kernel.org/r/20161026084839.27299-6-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/tlb.h  |   13 +++----------
 arch/ia64/include/asm/tlb.h |   16 ++++------------
 arch/s390/include/asm/tlb.h |    6 ------
 arch/sh/include/asm/tlb.h   |    6 ------
 arch/um/include/asm/tlb.h   |    6 ------
 include/asm-generic/tlb.h   |   28 ++--------------------------
 mm/memory.c                 |   21 ++++++---------------
 7 files changed, 15 insertions(+), 81 deletions(-)

diff -puN arch/arm/include/asm/tlb.h~mm-remove-the-page-size-change-check-in-tlb_remove_page arch/arm/include/asm/tlb.h
--- a/arch/arm/include/asm/tlb.h~mm-remove-the-page-size-change-check-in-tlb_remove_page
+++ a/arch/arm/include/asm/tlb.h
@@ -213,18 +213,17 @@ tlb_end_vma(struct mmu_gather *tlb, stru
 
 static inline bool __tlb_remove_page(struct mmu_gather *tlb, struct page *page)
 {
+	tlb->pages[tlb->nr++] = page;
+	VM_WARN_ON(tlb->nr > tlb->max);
 	if (tlb->nr == tlb->max)
 		return true;
-	tlb->pages[tlb->nr++] = page;
 	return false;
 }
 
 static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
 {
-	if (__tlb_remove_page(tlb, page)) {
+	if (__tlb_remove_page(tlb, page))
 		tlb_flush_mmu(tlb);
-		__tlb_remove_page(tlb, page);
-	}
 }
 
 static inline bool __tlb_remove_page_size(struct mmu_gather *tlb,
@@ -232,12 +231,6 @@ static inline bool __tlb_remove_page_siz
 {
 	return __tlb_remove_page(tlb, page);
 }
-
-static inline bool __tlb_remove_pte_page(struct mmu_gather *tlb,
-					 struct page *page)
-{
-	return __tlb_remove_page(tlb, page);
-}
 
 static inline void tlb_remove_page_size(struct mmu_gather *tlb,
 					struct page *page, int page_size)
diff -puN arch/ia64/include/asm/tlb.h~mm-remove-the-page-size-change-check-in-tlb_remove_page arch/ia64/include/asm/tlb.h
--- a/arch/ia64/include/asm/tlb.h~mm-remove-the-page-size-change-check-in-tlb_remove_page
+++ a/arch/ia64/include/asm/tlb.h
@@ -207,15 +207,15 @@ tlb_finish_mmu(struct mmu_gather *tlb, u
  */
 static inline bool __tlb_remove_page(struct mmu_gather *tlb, struct page *page)
 {
-	if (tlb->nr == tlb->max)
-		return true;
-
 	tlb->need_flush = 1;
 
 	if (!tlb->nr && tlb->pages == tlb->local)
 		__tlb_alloc_page(tlb);
 
 	tlb->pages[tlb->nr++] = page;
+	VM_WARN_ON(tlb->nr > tlb->max);
+	if (tlb->nr == tlb->max)
+		return true;
 	return false;
 }
 
@@ -236,10 +236,8 @@ static inline void tlb_flush_mmu(struct
 
 static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
 {
-	if (__tlb_remove_page(tlb, page)) {
+	if (__tlb_remove_page(tlb, page))
 		tlb_flush_mmu(tlb);
-		__tlb_remove_page(tlb, page);
-	}
 }
 
 static inline bool __tlb_remove_page_size(struct mmu_gather *tlb,
@@ -247,12 +245,6 @@ static inline bool __tlb_remove_page_siz
 {
 	return __tlb_remove_page(tlb, page);
 }
-
-static inline bool __tlb_remove_pte_page(struct mmu_gather *tlb,
-					 struct page *page)
-{
-	return __tlb_remove_page(tlb, page);
-}
 
 static inline void tlb_remove_page_size(struct mmu_gather *tlb,
 					struct page *page, int page_size)
diff -puN arch/s390/include/asm/tlb.h~mm-remove-the-page-size-change-check-in-tlb_remove_page arch/s390/include/asm/tlb.h
--- a/arch/s390/include/asm/tlb.h~mm-remove-the-page-size-change-check-in-tlb_remove_page
+++ a/arch/s390/include/asm/tlb.h
@@ -104,12 +104,6 @@ static inline bool __tlb_remove_page_siz
 	return __tlb_remove_page(tlb, page);
 }
 
-static inline bool __tlb_remove_pte_page(struct mmu_gather *tlb,
-					 struct page *page)
-{
-	return __tlb_remove_page(tlb, page);
-}
-
 static inline void tlb_remove_page_size(struct mmu_gather *tlb,
 					struct page *page, int page_size)
 {
diff -puN arch/sh/include/asm/tlb.h~mm-remove-the-page-size-change-check-in-tlb_remove_page arch/sh/include/asm/tlb.h
--- a/arch/sh/include/asm/tlb.h~mm-remove-the-page-size-change-check-in-tlb_remove_page
+++ a/arch/sh/include/asm/tlb.h
@@ -118,12 +118,6 @@ static inline bool __tlb_remove_page_siz
 	return __tlb_remove_page(tlb, page);
 }
 
-static inline bool __tlb_remove_pte_page(struct mmu_gather *tlb,
-					 struct page *page)
-{
-	return __tlb_remove_page(tlb, page);
-}
-
 static inline void tlb_remove_page_size(struct mmu_gather *tlb,
 					struct page *page, int page_size)
 {
diff -puN arch/um/include/asm/tlb.h~mm-remove-the-page-size-change-check-in-tlb_remove_page arch/um/include/asm/tlb.h
--- a/arch/um/include/asm/tlb.h~mm-remove-the-page-size-change-check-in-tlb_remove_page
+++ a/arch/um/include/asm/tlb.h
@@ -116,12 +116,6 @@ static inline bool __tlb_remove_page_siz
 	return __tlb_remove_page(tlb, page);
 }
 
-static inline bool __tlb_remove_pte_page(struct mmu_gather *tlb,
-					 struct page *page)
-{
-	return __tlb_remove_page(tlb, page);
-}
-
 static inline void tlb_remove_page_size(struct mmu_gather *tlb,
 					struct page *page, int page_size)
 {
diff -puN include/asm-generic/tlb.h~mm-remove-the-page-size-change-check-in-tlb_remove_page include/asm-generic/tlb.h
--- a/include/asm-generic/tlb.h~mm-remove-the-page-size-change-check-in-tlb_remove_page
+++ a/include/asm-generic/tlb.h
@@ -107,11 +107,6 @@ struct mmu_gather {
 	struct mmu_gather_batch	local;
 	struct page		*__pages[MMU_GATHER_BUNDLE];
 	unsigned int		batch_count;
-	/*
-	 * __tlb_adjust_range  will track the new addr here,
-	 * that that we can adjust the range after the flush
-	 */
-	unsigned long addr;
 	int page_size;
 };
 
@@ -130,12 +125,6 @@ static inline void __tlb_adjust_range(st
 {
 	tlb->start = min(tlb->start, address);
 	tlb->end = max(tlb->end, address + range_size);
-	/*
-	 * Track the last address with which we adjusted the range. This
-	 * will be used later to adjust again after a mmu_flush due to
-	 * failed __tlb_remove_page
-	 */
-	tlb->addr = address;
 }
 
 static inline void __tlb_reset_range(struct mmu_gather *tlb)
@@ -151,15 +140,11 @@ static inline void __tlb_reset_range(str
 static inline void tlb_remove_page_size(struct mmu_gather *tlb,
 					struct page *page, int page_size)
 {
-	if (__tlb_remove_page_size(tlb, page, page_size)) {
+	if (__tlb_remove_page_size(tlb, page, page_size))
 		tlb_flush_mmu(tlb);
-		tlb->page_size = page_size;
-		__tlb_adjust_range(tlb, tlb->addr, page_size);
-		__tlb_remove_page_size(tlb, page, page_size);
-	}
 }
 
-static bool __tlb_remove_page(struct mmu_gather *tlb, struct page *page)
+static inline bool __tlb_remove_page(struct mmu_gather *tlb, struct page *page)
 {
 	return __tlb_remove_page_size(tlb, page, PAGE_SIZE);
 }
@@ -173,15 +158,6 @@ static inline void tlb_remove_page(struc
 	return tlb_remove_page_size(tlb, page, PAGE_SIZE);
 }
 
-static inline bool __tlb_remove_pte_page(struct mmu_gather *tlb, struct page *page)
-{
-	/* active->nr should be zero when we call this */
-	VM_BUG_ON_PAGE(tlb->active->nr, page);
-	tlb->page_size = PAGE_SIZE;
-	__tlb_adjust_range(tlb, tlb->addr, PAGE_SIZE);
-	return __tlb_remove_page(tlb, page);
-}
-
 #ifndef tlb_remove_check_page_size_change
 #define tlb_remove_check_page_size_change tlb_remove_check_page_size_change
 static inline void tlb_remove_check_page_size_change(struct mmu_gather *tlb,
diff -puN mm/memory.c~mm-remove-the-page-size-change-check-in-tlb_remove_page mm/memory.c
--- a/mm/memory.c~mm-remove-the-page-size-change-check-in-tlb_remove_page
+++ a/mm/memory.c
@@ -300,15 +300,14 @@ bool __tlb_remove_page_size(struct mmu_g
 	struct mmu_gather_batch *batch;
 
 	VM_BUG_ON(!tlb->end);
-
-	if (!tlb->page_size)
-		tlb->page_size = page_size;
-	else {
-		if (page_size != tlb->page_size)
-			return true;
-	}
+	VM_WARN_ON(tlb->page_size != page_size);
 
 	batch = tlb->active;
+	/*
+	 * Add the page and check if we are full. If so
+	 * force a flush.
+	 */
+	batch->pages[batch->nr++] = page;
 	if (batch->nr == batch->max) {
 		if (!tlb_next_batch(tlb))
 			return true;
@@ -316,7 +315,6 @@ bool __tlb_remove_page_size(struct mmu_g
 	}
 	VM_BUG_ON_PAGE(batch->nr > batch->max, page);
 
-	batch->pages[batch->nr++] = page;
 	return false;
 }
 
@@ -1122,7 +1120,6 @@ static unsigned long zap_pte_range(struc
 	pte_t *start_pte;
 	pte_t *pte;
 	swp_entry_t entry;
-	struct page *pending_page = NULL;
 
 	tlb_remove_check_page_size_change(tlb, PAGE_SIZE);
 again:
@@ -1177,7 +1174,6 @@ again:
 				print_bad_pte(vma, addr, ptent, page);
 			if (unlikely(__tlb_remove_page(tlb, page))) {
 				force_flush = 1;
-				pending_page = page;
 				addr += PAGE_SIZE;
 				break;
 			}
@@ -1218,11 +1214,6 @@ again:
 	if (force_flush) {
 		force_flush = 0;
 		tlb_flush_mmu_free(tlb);
-		if (pending_page) {
-			/* remove the page with new size */
-			__tlb_remove_pte_page(tlb, pending_page);
-			pending_page = NULL;
-		}
 		if (addr != end)
 			goto again;
 	}
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

mm-hugetlb-use-the-right-pte-val-for-compare-in-hugetlb_cow.patch
mm-hugetlb-use-huge_pte_lock-instead-of-opencoding-the-lock.patch
mm-use-the-correct-page-size-when-removing-the-page.patch
mm-update-mmu_gather-range-correctly.patch
mm-hugetlb-add-tlb_remove_hugetlb_entry-for-handling-hugetlb-pages.patch
mm-add-tlb_remove_check_page_size_change-to-track-page-size-change.patch
mm-remove-the-page-size-change-check-in-tlb_remove_page.patch

