From: akpm@linux-foundation.org
Subject: + mm-update-mmu_gather-range-correctly.patch added to -mm tree
Date: Wed, 26 Oct 2016 16:36:04 -0700
Message-ID: <58113de4.YWyW63IDTJjaeeOU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41427 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932887AbcJZXgF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Oct 2016 19:36:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, dan.j.williams@intel.com, kirill@shutemov.name, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: update mmu_gather range correctly
has been added to the -mm tree.  Its filename is
     mm-update-mmu_gather-range-correctly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-update-mmu_gather-range-correctly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-update-mmu_gather-range-correctly.patch

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
Subject: mm: update mmu_gather range correctly

We use __tlb_adjust_range to update range convered by mmu_gather struct. 
We later use the 'start' and 'end' to do a mmu_notifier_invalidate_range
in tlb_flush_mmu_tlbonly().  Update the 'end' correctly in
__tlb_adjust_range so that we call mmu_notifier_invalidate_range with the
correct range values.

W.r.t to tlbflush, this should not have any impact, because a flush with
correct start address will flush tlb mapping for the range.

Also add comment w.r.t updating the range when we free pagetable pages. 
For now we don't support a range based page table cache flush.

Link: http://lkml.kernel.org/r/20161026084839.27299-3-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/tlb.h |   43 +++++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 12 deletions(-)

diff -puN include/asm-generic/tlb.h~mm-update-mmu_gather-range-correctly include/asm-generic/tlb.h
--- a/include/asm-generic/tlb.h~mm-update-mmu_gather-range-correctly
+++ a/include/asm-generic/tlb.h
@@ -125,10 +125,11 @@ extern bool __tlb_remove_page_size(struc
 				   int page_size);
 
 static inline void __tlb_adjust_range(struct mmu_gather *tlb,
-				      unsigned long address)
+				      unsigned long address,
+				      unsigned int range_size)
 {
 	tlb->start = min(tlb->start, address);
-	tlb->end = max(tlb->end, address + PAGE_SIZE);
+	tlb->end = max(tlb->end, address + range_size);
 	/*
 	 * Track the last address with which we adjusted the range. This
 	 * will be used later to adjust again after a mmu_flush due to
@@ -153,7 +154,7 @@ static inline void tlb_remove_page_size(
 	if (__tlb_remove_page_size(tlb, page, page_size)) {
 		tlb_flush_mmu(tlb);
 		tlb->page_size = page_size;
-		__tlb_adjust_range(tlb, tlb->addr);
+		__tlb_adjust_range(tlb, tlb->addr, page_size);
 		__tlb_remove_page_size(tlb, page, page_size);
 	}
 }
@@ -177,7 +178,7 @@ static inline bool __tlb_remove_pte_page
 	/* active->nr should be zero when we call this */
 	VM_BUG_ON_PAGE(tlb->active->nr, page);
 	tlb->page_size = PAGE_SIZE;
-	__tlb_adjust_range(tlb, tlb->addr);
+	__tlb_adjust_range(tlb, tlb->addr, PAGE_SIZE);
 	return __tlb_remove_page(tlb, page);
 }
 
@@ -215,7 +216,7 @@ static inline bool __tlb_remove_pte_page
  */
 #define tlb_remove_tlb_entry(tlb, ptep, address)		\
 	do {							\
-		__tlb_adjust_range(tlb, address);		\
+		__tlb_adjust_range(tlb, address, PAGE_SIZE);	\
 		__tlb_remove_tlb_entry(tlb, ptep, address);	\
 	} while (0)
 
@@ -227,29 +228,47 @@ static inline bool __tlb_remove_pte_page
 #define __tlb_remove_pmd_tlb_entry(tlb, pmdp, address) do {} while (0)
 #endif
 
-#define tlb_remove_pmd_tlb_entry(tlb, pmdp, address)		\
-	do {							\
-		__tlb_adjust_range(tlb, address);		\
-		__tlb_remove_pmd_tlb_entry(tlb, pmdp, address);	\
+#define tlb_remove_pmd_tlb_entry(tlb, pmdp, address)			\
+	do {								\
+		__tlb_adjust_range(tlb, address, HPAGE_PMD_SIZE);	\
+		__tlb_remove_pmd_tlb_entry(tlb, pmdp, address);		\
 	} while (0)
 
+/*
+ * For things like page tables caches (ie caching addresses "inside" the
+ * page tables, like x86 does), for legacy reasons, flushing an
+ * individual page had better flush the page table caches behind it. This
+ * is definitely how x86 works, for example. And if you have an
+ * architected non-legacy page table cache (which I'm not aware of
+ * anybody actually doing), you're going to have some architecturally
+ * explicit flushing for that, likely *separate* from a regular TLB entry
+ * flush, and thus you'd need more than just some range expansion..
+ *
+ * So if we ever find an architecture
+ * that would want something that odd, I think it is up to that
+ * architecture to do its own odd thing, not cause pain for others
+ * http://lkml.kernel.org/r/CA+55aFzBggoXtNXQeng5d_mRoDnaMBE5Y+URs+PHR67nUpMtaw@mail.gmail.com
+ *
+ * For now w.r.t page table cache, mark the range_size as PAGE_SIZE
+ */
+
 #define pte_free_tlb(tlb, ptep, address)			\
 	do {							\
-		__tlb_adjust_range(tlb, address);		\
+		__tlb_adjust_range(tlb, address, PAGE_SIZE);	\
 		__pte_free_tlb(tlb, ptep, address);		\
 	} while (0)
 
 #ifndef __ARCH_HAS_4LEVEL_HACK
 #define pud_free_tlb(tlb, pudp, address)			\
 	do {							\
-		__tlb_adjust_range(tlb, address);		\
+		__tlb_adjust_range(tlb, address, PAGE_SIZE);	\
 		__pud_free_tlb(tlb, pudp, address);		\
 	} while (0)
 #endif
 
 #define pmd_free_tlb(tlb, pmdp, address)			\
 	do {							\
-		__tlb_adjust_range(tlb, address);		\
+		__tlb_adjust_range(tlb, address, PAGE_SIZE);	\
 		__pmd_free_tlb(tlb, pmdp, address);		\
 	} while (0)
 
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

mm-hugetlb-use-the-right-pte-val-for-compare-in-hugetlb_cow.patch
mm-hugetlb-use-huge_pte_lock-instead-of-opencoding-the-lock.patch
mm-use-the-correct-page-size-when-removing-the-page.patch
mm-update-mmu_gather-range-correctly.patch
mm-hugetlb-add-tlb_remove_hugetlb_entry-for-handling-hugetlb-pages.patch
mm-add-tlb_remove_check_page_size_change-to-track-page-size-change.patch
mm-remove-the-page-size-change-check-in-tlb_remove_page.patch

