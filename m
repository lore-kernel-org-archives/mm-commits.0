From: akpm@linux-foundation.org
Subject: + mm-change-the-interface-for-__tlb_remove_page-v3.patch added to -mm tree
Date: Wed, 08 Jun 2016 13:58:46 -0700
Message-ID: <57588706.jE/3aNEc67gnd2P1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36168 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbcFHU6s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jun 2016 16:58:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, benh@kernel.crashing.org, hughd@google.com, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, minchan.kim@gmail.com, mpe@ellerman.id.au, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-change-the-interface-for-__tlb_remove_page-v3
has been added to the -mm tree.  Its filename is
     mm-change-the-interface-for-__tlb_remove_page-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-change-the-interface-for-__tlb_remove_page-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-change-the-interface-for-__tlb_remove_page-v3.patch

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
Subject: mm-change-the-interface-for-__tlb_remove_page-v3

Link: http://lkml.kernel.org/r/1465049193-22197-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com
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

 arch/arm/include/asm/tlb.h  |    6 ++++++
 arch/ia64/include/asm/tlb.h |    6 ++++++
 arch/s390/include/asm/tlb.h |    5 +++++
 arch/sh/include/asm/tlb.h   |    6 ++++++
 arch/um/include/asm/tlb.h   |    6 ++++++
 include/asm-generic/tlb.h   |   34 +++++++++++++++++++++-------------
 mm/memory.c                 |    3 +--
 7 files changed, 51 insertions(+), 15 deletions(-)

diff -puN arch/arm/include/asm/tlb.h~mm-change-the-interface-for-__tlb_remove_page-v3 arch/arm/include/asm/tlb.h
--- a/arch/arm/include/asm/tlb.h~mm-change-the-interface-for-__tlb_remove_page-v3
+++ a/arch/arm/include/asm/tlb.h
@@ -225,6 +225,12 @@ static inline void tlb_remove_page(struc
 	}
 }
 
+static inline bool __tlb_remove_pte_page(struct mmu_gather *tlb,
+					 struct page *page)
+{
+	return __tlb_remove_page(tlb, page);
+}
+
 static inline void __pte_free_tlb(struct mmu_gather *tlb, pgtable_t pte,
 	unsigned long addr)
 {
diff -puN arch/ia64/include/asm/tlb.h~mm-change-the-interface-for-__tlb_remove_page-v3 arch/ia64/include/asm/tlb.h
--- a/arch/ia64/include/asm/tlb.h~mm-change-the-interface-for-__tlb_remove_page-v3
+++ a/arch/ia64/include/asm/tlb.h
@@ -242,6 +242,12 @@ static inline void tlb_remove_page(struc
 	}
 }
 
+static inline bool __tlb_remove_pte_page(struct mmu_gather *tlb,
+					 struct page *page)
+{
+	return __tlb_remove_page(tlb, page);
+}
+
 /*
  * Remove TLB entry for PTE mapped at virtual address ADDRESS.  This is called for any
  * PTE, not just those pointing to (normal) physical memory.
diff -puN arch/s390/include/asm/tlb.h~mm-change-the-interface-for-__tlb_remove_page-v3 arch/s390/include/asm/tlb.h
--- a/arch/s390/include/asm/tlb.h~mm-change-the-interface-for-__tlb_remove_page-v3
+++ a/arch/s390/include/asm/tlb.h
@@ -98,6 +98,11 @@ static inline void tlb_remove_page(struc
 	free_page_and_swap_cache(page);
 }
 
+static inline bool __tlb_remove_pte_page(struct mmu_gather *tlb,
+					 struct page *page)
+{
+	return __tlb_remove_page(tlb, page);
+}
 /*
  * pte_free_tlb frees a pte table and clears the CRSTE for the
  * page table from the tlb.
diff -puN arch/sh/include/asm/tlb.h~mm-change-the-interface-for-__tlb_remove_page-v3 arch/sh/include/asm/tlb.h
--- a/arch/sh/include/asm/tlb.h~mm-change-the-interface-for-__tlb_remove_page-v3
+++ a/arch/sh/include/asm/tlb.h
@@ -109,6 +109,12 @@ static inline void tlb_remove_page(struc
 	__tlb_remove_page(tlb, page);
 }
 
+static inline bool __tlb_remove_pte_page(struct mmu_gather *tlb,
+					 struct page *page)
+{
+	return __tlb_remove_page(tlb, page);
+}
+
 #define pte_free_tlb(tlb, ptep, addr)	pte_free((tlb)->mm, ptep)
 #define pmd_free_tlb(tlb, pmdp, addr)	pmd_free((tlb)->mm, pmdp)
 #define pud_free_tlb(tlb, pudp, addr)	pud_free((tlb)->mm, pudp)
diff -puN arch/um/include/asm/tlb.h~mm-change-the-interface-for-__tlb_remove_page-v3 arch/um/include/asm/tlb.h
--- a/arch/um/include/asm/tlb.h~mm-change-the-interface-for-__tlb_remove_page-v3
+++ a/arch/um/include/asm/tlb.h
@@ -110,6 +110,12 @@ static inline void tlb_remove_page(struc
 	__tlb_remove_page(tlb, page);
 }
 
+static inline bool __tlb_remove_pte_page(struct mmu_gather *tlb,
+					 struct page *page)
+{
+	return __tlb_remove_page(tlb, page);
+}
+
 /**
  * tlb_remove_tlb_entry - remember a pte unmapping for later tlb invalidation.
  *
diff -puN include/asm-generic/tlb.h~mm-change-the-interface-for-__tlb_remove_page-v3 include/asm-generic/tlb.h
--- a/include/asm-generic/tlb.h~mm-change-the-interface-for-__tlb_remove_page-v3
+++ a/include/asm-generic/tlb.h
@@ -122,19 +122,6 @@ void tlb_finish_mmu(struct mmu_gather *t
 							unsigned long end);
 bool __tlb_remove_page(struct mmu_gather *tlb, struct page *page);
 
-/* tlb_remove_page
- *	Similar to __tlb_remove_page but will call tlb_flush_mmu() itself when
- *	required.
- */
-static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
-{
-	if (__tlb_remove_page(tlb, page)) {
-		tlb_flush_mmu(tlb);
-		__tlb_adjust_range(tlb, tlb->addr);
-		__tlb_remove_page(tlb, page);
-	}
-}
-
 static inline void __tlb_adjust_range(struct mmu_gather *tlb,
 				      unsigned long address)
 {
@@ -158,6 +145,27 @@ static inline void __tlb_reset_range(str
 	}
 }
 
+/* tlb_remove_page
+ *	Similar to __tlb_remove_page but will call tlb_flush_mmu() itself when
+ *	required.
+ */
+static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
+{
+	if (__tlb_remove_page(tlb, page)) {
+		tlb_flush_mmu(tlb);
+		__tlb_adjust_range(tlb, tlb->addr);
+		__tlb_remove_page(tlb, page);
+	}
+}
+
+static inline bool __tlb_remove_pte_page(struct mmu_gather *tlb, struct page *page)
+{
+	/* active->nr should be zero when we call this */
+	VM_BUG_ON_PAGE(tlb->active->nr, page);
+	__tlb_adjust_range(tlb, tlb->addr);
+	return __tlb_remove_page(tlb, page);
+}
+
 /*
  * In the case of tlb vma handling, we can optimise these away in the
  * case where we're doing a full MM flush.  When we're doing a munmap,
diff -puN mm/memory.c~mm-change-the-interface-for-__tlb_remove_page-v3 mm/memory.c
--- a/mm/memory.c~mm-change-the-interface-for-__tlb_remove_page-v3
+++ a/mm/memory.c
@@ -1207,8 +1207,7 @@ again:
 		tlb_flush_mmu_free(tlb);
 		if (pending_page) {
 			/* remove the page with new size */
-			__tlb_adjust_range(tlb, tlb->addr);
-			__tlb_remove_page(tlb, pending_page);
+			__tlb_remove_pte_page(tlb, pending_page);
 			pending_page = NULL;
 		}
 		if (addr != end)
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

mm-debug-add-vm_warn-which-maps-to-warn.patch
powerpc-mm-check-for-irq-disabled-only-if-debug_vm-is-enabled.patch
mm-hugetlb-simplify-hugetlb-unmap.patch
mm-change-the-interface-for-__tlb_remove_page.patch
mm-change-the-interface-for-__tlb_remove_page-v3.patch
mm-mmu_gather-track-page-size-with-mmu-gather-and-force-flush-if-page-size-change.patch

