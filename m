From: akpm@linux-foundation.org
Subject: [patch 066/126] mm/mmu_gather: track page size with mmu gather
 and force flush if page size change
Date: Tue, 26 Jul 2016 15:24:12 -0700
Message-ID: <5797e30c.Bl5Z96a3sW4rTekE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56851 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758335AbcGZWYO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:24:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, benh@kernel.crashing.org, hughd@google.com, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, minchan.kim@gmail.com, mpe@ellerman.id.au, rientjes@google.com, vbabka@suse.cz

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm/mmu_gather: track page size with mmu gather and force flush if page size change

This allows an arch which needs to do special handing with respect to
different page size when flushing tlb to implement the same in mmu gather.

Link: http://lkml.kernel.org/r/1465049193-22197-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/tlb.h  |   12 ++++++++++++
 arch/ia64/include/asm/tlb.h |   12 ++++++++++++
 arch/s390/include/asm/tlb.h |   13 +++++++++++++
 arch/sh/include/asm/tlb.h   |   12 ++++++++++++
 arch/um/include/asm/tlb.h   |   12 ++++++++++++
 include/asm-generic/tlb.h   |   27 +++++++++++++++++++++------
 mm/huge_memory.c            |    2 +-
 mm/hugetlb.c                |    2 +-
 mm/memory.c                 |   10 +++++++++-
 9 files changed, 93 insertions(+), 9 deletions(-)

diff -puN arch/arm/include/asm/tlb.h~mm-mmu_gather-track-page-size-with-mmu-gather-and-force-flush-if-page-size-change arch/arm/include/asm/tlb.h
--- a/arch/arm/include/asm/tlb.h~mm-mmu_gather-track-page-size-with-mmu-gather-and-force-flush-if-page-size-change
+++ a/arch/arm/include/asm/tlb.h
@@ -225,12 +225,24 @@ static inline void tlb_remove_page(struc
 	}
 }
 
+static inline bool __tlb_remove_page_size(struct mmu_gather *tlb,
+					  struct page *page, int page_size)
+{
+	return __tlb_remove_page(tlb, page);
+}
+
 static inline bool __tlb_remove_pte_page(struct mmu_gather *tlb,
 					 struct page *page)
 {
 	return __tlb_remove_page(tlb, page);
 }
 
+static inline void tlb_remove_page_size(struct mmu_gather *tlb,
+					struct page *page, int page_size)
+{
+	return tlb_remove_page(tlb, page);
+}
+
 static inline void __pte_free_tlb(struct mmu_gather *tlb, pgtable_t pte,
 	unsigned long addr)
 {
diff -puN arch/ia64/include/asm/tlb.h~mm-mmu_gather-track-page-size-with-mmu-gather-and-force-flush-if-page-size-change arch/ia64/include/asm/tlb.h
--- a/arch/ia64/include/asm/tlb.h~mm-mmu_gather-track-page-size-with-mmu-gather-and-force-flush-if-page-size-change
+++ a/arch/ia64/include/asm/tlb.h
@@ -242,12 +242,24 @@ static inline void tlb_remove_page(struc
 	}
 }
 
+static inline bool __tlb_remove_page_size(struct mmu_gather *tlb,
+					  struct page *page, int page_size)
+{
+	return __tlb_remove_page(tlb, page);
+}
+
 static inline bool __tlb_remove_pte_page(struct mmu_gather *tlb,
 					 struct page *page)
 {
 	return __tlb_remove_page(tlb, page);
 }
 
+static inline void tlb_remove_page_size(struct mmu_gather *tlb,
+					struct page *page, int page_size)
+{
+	return tlb_remove_page(tlb, page);
+}
+
 /*
  * Remove TLB entry for PTE mapped at virtual address ADDRESS.  This is called for any
  * PTE, not just those pointing to (normal) physical memory.
diff -puN arch/s390/include/asm/tlb.h~mm-mmu_gather-track-page-size-with-mmu-gather-and-force-flush-if-page-size-change arch/s390/include/asm/tlb.h
--- a/arch/s390/include/asm/tlb.h~mm-mmu_gather-track-page-size-with-mmu-gather-and-force-flush-if-page-size-change
+++ a/arch/s390/include/asm/tlb.h
@@ -98,11 +98,24 @@ static inline void tlb_remove_page(struc
 	free_page_and_swap_cache(page);
 }
 
+static inline bool __tlb_remove_page_size(struct mmu_gather *tlb,
+					  struct page *page, int page_size)
+{
+	return __tlb_remove_page(tlb, page);
+}
+
 static inline bool __tlb_remove_pte_page(struct mmu_gather *tlb,
 					 struct page *page)
 {
 	return __tlb_remove_page(tlb, page);
 }
+
+static inline void tlb_remove_page_size(struct mmu_gather *tlb,
+					struct page *page, int page_size)
+{
+	return tlb_remove_page(tlb, page);
+}
+
 /*
  * pte_free_tlb frees a pte table and clears the CRSTE for the
  * page table from the tlb.
diff -puN arch/sh/include/asm/tlb.h~mm-mmu_gather-track-page-size-with-mmu-gather-and-force-flush-if-page-size-change arch/sh/include/asm/tlb.h
--- a/arch/sh/include/asm/tlb.h~mm-mmu_gather-track-page-size-with-mmu-gather-and-force-flush-if-page-size-change
+++ a/arch/sh/include/asm/tlb.h
@@ -109,12 +109,24 @@ static inline void tlb_remove_page(struc
 	__tlb_remove_page(tlb, page);
 }
 
+static inline bool __tlb_remove_page_size(struct mmu_gather *tlb,
+					  struct page *page, int page_size)
+{
+	return __tlb_remove_page(tlb, page);
+}
+
 static inline bool __tlb_remove_pte_page(struct mmu_gather *tlb,
 					 struct page *page)
 {
 	return __tlb_remove_page(tlb, page);
 }
 
+static inline void tlb_remove_page_size(struct mmu_gather *tlb,
+					struct page *page, int page_size)
+{
+	return tlb_remove_page(tlb, page);
+}
+
 #define pte_free_tlb(tlb, ptep, addr)	pte_free((tlb)->mm, ptep)
 #define pmd_free_tlb(tlb, pmdp, addr)	pmd_free((tlb)->mm, pmdp)
 #define pud_free_tlb(tlb, pudp, addr)	pud_free((tlb)->mm, pudp)
diff -puN arch/um/include/asm/tlb.h~mm-mmu_gather-track-page-size-with-mmu-gather-and-force-flush-if-page-size-change arch/um/include/asm/tlb.h
--- a/arch/um/include/asm/tlb.h~mm-mmu_gather-track-page-size-with-mmu-gather-and-force-flush-if-page-size-change
+++ a/arch/um/include/asm/tlb.h
@@ -110,12 +110,24 @@ static inline void tlb_remove_page(struc
 	__tlb_remove_page(tlb, page);
 }
 
+static inline bool __tlb_remove_page_size(struct mmu_gather *tlb,
+					  struct page *page, int page_size)
+{
+	return __tlb_remove_page(tlb, page);
+}
+
 static inline bool __tlb_remove_pte_page(struct mmu_gather *tlb,
 					 struct page *page)
 {
 	return __tlb_remove_page(tlb, page);
 }
 
+static inline void tlb_remove_page_size(struct mmu_gather *tlb,
+					struct page *page, int page_size)
+{
+	return tlb_remove_page(tlb, page);
+}
+
 /**
  * tlb_remove_tlb_entry - remember a pte unmapping for later tlb invalidation.
  *
diff -puN include/asm-generic/tlb.h~mm-mmu_gather-track-page-size-with-mmu-gather-and-force-flush-if-page-size-change include/asm-generic/tlb.h
--- a/include/asm-generic/tlb.h~mm-mmu_gather-track-page-size-with-mmu-gather-and-force-flush-if-page-size-change
+++ a/include/asm-generic/tlb.h
@@ -112,6 +112,7 @@ struct mmu_gather {
 	 * that that we can adjust the range after the flush
 	 */
 	unsigned long addr;
+	int page_size;
 };
 
 #define HAVE_GENERIC_MMU_GATHER
@@ -120,7 +121,8 @@ void tlb_gather_mmu(struct mmu_gather *t
 void tlb_flush_mmu(struct mmu_gather *tlb);
 void tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start,
 							unsigned long end);
-bool __tlb_remove_page(struct mmu_gather *tlb, struct page *page);
+extern bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page,
+				   int page_size);
 
 static inline void __tlb_adjust_range(struct mmu_gather *tlb,
 				      unsigned long address)
@@ -145,23 +147,36 @@ static inline void __tlb_reset_range(str
 	}
 }
 
+static inline void tlb_remove_page_size(struct mmu_gather *tlb,
+					struct page *page, int page_size)
+{
+	if (__tlb_remove_page_size(tlb, page, page_size)) {
+		tlb_flush_mmu(tlb);
+		tlb->page_size = page_size;
+		__tlb_adjust_range(tlb, tlb->addr);
+		__tlb_remove_page_size(tlb, page, page_size);
+	}
+}
+
+static bool __tlb_remove_page(struct mmu_gather *tlb, struct page *page)
+{
+	return __tlb_remove_page_size(tlb, page, PAGE_SIZE);
+}
+
 /* tlb_remove_page
  *	Similar to __tlb_remove_page but will call tlb_flush_mmu() itself when
  *	required.
  */
 static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
 {
-	if (__tlb_remove_page(tlb, page)) {
-		tlb_flush_mmu(tlb);
-		__tlb_adjust_range(tlb, tlb->addr);
-		__tlb_remove_page(tlb, page);
-	}
+	return tlb_remove_page_size(tlb, page, PAGE_SIZE);
 }
 
 static inline bool __tlb_remove_pte_page(struct mmu_gather *tlb, struct page *page)
 {
 	/* active->nr should be zero when we call this */
 	VM_BUG_ON_PAGE(tlb->active->nr, page);
+	tlb->page_size = PAGE_SIZE;
 	__tlb_adjust_range(tlb, tlb->addr);
 	return __tlb_remove_page(tlb, page);
 }
diff -puN mm/huge_memory.c~mm-mmu_gather-track-page-size-with-mmu-gather-and-force-flush-if-page-size-change mm/huge_memory.c
--- a/mm/huge_memory.c~mm-mmu_gather-track-page-size-with-mmu-gather-and-force-flush-if-page-size-change
+++ a/mm/huge_memory.c
@@ -1689,7 +1689,7 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 		pte_free(tlb->mm, pgtable_trans_huge_withdraw(tlb->mm, pmd));
 		atomic_long_dec(&tlb->mm->nr_ptes);
 		spin_unlock(ptl);
-		tlb_remove_page(tlb, page);
+		tlb_remove_page_size(tlb, page, HPAGE_PMD_SIZE);
 	}
 	return 1;
 }
diff -puN mm/hugetlb.c~mm-mmu_gather-track-page-size-with-mmu-gather-and-force-flush-if-page-size-change mm/hugetlb.c
--- a/mm/hugetlb.c~mm-mmu_gather-track-page-size-with-mmu-gather-and-force-flush-if-page-size-change
+++ a/mm/hugetlb.c
@@ -3250,7 +3250,7 @@ void __unmap_hugepage_range(struct mmu_g
 		page_remove_rmap(page, true);
 
 		spin_unlock(ptl);
-		tlb_remove_page(tlb, page);
+		tlb_remove_page_size(tlb, page, huge_page_size(h));
 		/*
 		 * Bail out after unmapping reference page if supplied
 		 */
diff -puN mm/memory.c~mm-mmu_gather-track-page-size-with-mmu-gather-and-force-flush-if-page-size-change mm/memory.c
--- a/mm/memory.c~mm-mmu_gather-track-page-size-with-mmu-gather-and-force-flush-if-page-size-change
+++ a/mm/memory.c
@@ -233,6 +233,7 @@ void tlb_gather_mmu(struct mmu_gather *t
 #ifdef CONFIG_HAVE_RCU_TABLE_FREE
 	tlb->batch = NULL;
 #endif
+	tlb->page_size = 0;
 
 	__tlb_reset_range(tlb);
 }
@@ -294,12 +295,19 @@ void tlb_finish_mmu(struct mmu_gather *t
  *	When out of page slots we must call tlb_flush_mmu().
  *returns true if the caller should flush.
  */
-bool __tlb_remove_page(struct mmu_gather *tlb, struct page *page)
+bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page, int page_size)
 {
 	struct mmu_gather_batch *batch;
 
 	VM_BUG_ON(!tlb->end);
 
+	if (!tlb->page_size)
+		tlb->page_size = page_size;
+	else {
+		if (page_size != tlb->page_size)
+			return true;
+	}
+
 	batch = tlb->active;
 	if (batch->nr == batch->max) {
 		if (!tlb_next_batch(tlb))
_
