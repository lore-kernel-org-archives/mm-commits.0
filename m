From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-add-tlb_remove_hugetlb_entry-for-handling-hugetlb-pages.patch
 added to -mm tree
Date: Wed, 26 Oct 2016 16:36:06 -0700
Message-ID: <58113de6.8/oCbBmSHTLteia8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41433 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934849AbcJZXgH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Oct 2016 19:36:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, dan.j.williams@intel.com, kirill@shutemov.name, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: add tlb_remove_hugetlb_entry for handling hugetlb pages
has been added to the -mm tree.  Its filename is
     mm-hugetlb-add-tlb_remove_hugetlb_entry-for-handling-hugetlb-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-add-tlb_remove_hugetlb_entry-for-handling-hugetlb-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-add-tlb_remove_hugetlb_entry-for-handling-hugetlb-pages.patch

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
Subject: mm/hugetlb: add tlb_remove_hugetlb_entry for handling hugetlb pages

This add tlb_remove_hugetlb_entry similar to tlb_remove_pmd_tlb_entry.

Link: http://lkml.kernel.org/r/20161026084839.27299-4-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/tlb.h  |    2 ++
 arch/ia64/include/asm/tlb.h |    3 +++
 arch/s390/include/asm/tlb.h |    2 ++
 arch/sh/include/asm/tlb.h   |    3 +++
 arch/um/include/asm/tlb.h   |    3 +++
 include/asm-generic/tlb.h   |    6 ++++++
 mm/hugetlb.c                |    2 +-
 7 files changed, 20 insertions(+), 1 deletion(-)

diff -puN arch/arm/include/asm/tlb.h~mm-hugetlb-add-tlb_remove_hugetlb_entry-for-handling-hugetlb-pages arch/arm/include/asm/tlb.h
--- a/arch/arm/include/asm/tlb.h~mm-hugetlb-add-tlb_remove_hugetlb_entry-for-handling-hugetlb-pages
+++ a/arch/arm/include/asm/tlb.h
@@ -186,6 +186,8 @@ tlb_remove_tlb_entry(struct mmu_gather *
 	tlb_add_flush(tlb, addr);
 }
 
+#define tlb_remove_huge_tlb_entry(h, tlb, ptep, address)	\
+	tlb_remove_tlb_entry(tlb, ptep, address)
 /*
  * In the case of tlb vma handling, we can optimise these away in the
  * case where we're doing a full MM flush.  When we're doing a munmap,
diff -puN arch/ia64/include/asm/tlb.h~mm-hugetlb-add-tlb_remove_hugetlb_entry-for-handling-hugetlb-pages arch/ia64/include/asm/tlb.h
--- a/arch/ia64/include/asm/tlb.h~mm-hugetlb-add-tlb_remove_hugetlb_entry-for-handling-hugetlb-pages
+++ a/arch/ia64/include/asm/tlb.h
@@ -283,6 +283,9 @@ do {							\
 	__tlb_remove_tlb_entry(tlb, ptep, addr);	\
 } while (0)
 
+#define tlb_remove_huge_tlb_entry(h, tlb, ptep, address)	\
+	tlb_remove_tlb_entry(tlb, ptep, address)
+
 #define pte_free_tlb(tlb, ptep, address)		\
 do {							\
 	tlb->need_flush = 1;				\
diff -puN arch/s390/include/asm/tlb.h~mm-hugetlb-add-tlb_remove_hugetlb_entry-for-handling-hugetlb-pages arch/s390/include/asm/tlb.h
--- a/arch/s390/include/asm/tlb.h~mm-hugetlb-add-tlb_remove_hugetlb_entry-for-handling-hugetlb-pages
+++ a/arch/s390/include/asm/tlb.h
@@ -162,5 +162,7 @@ static inline void pud_free_tlb(struct m
 #define tlb_remove_tlb_entry(tlb, ptep, addr)	do { } while (0)
 #define tlb_remove_pmd_tlb_entry(tlb, pmdp, addr)	do { } while (0)
 #define tlb_migrate_finish(mm)			do { } while (0)
+#define tlb_remove_huge_tlb_entry(h, tlb, ptep, address)	\
+	tlb_remove_tlb_entry(tlb, ptep, address)
 
 #endif /* _S390_TLB_H */
diff -puN arch/sh/include/asm/tlb.h~mm-hugetlb-add-tlb_remove_hugetlb_entry-for-handling-hugetlb-pages arch/sh/include/asm/tlb.h
--- a/arch/sh/include/asm/tlb.h~mm-hugetlb-add-tlb_remove_hugetlb_entry-for-handling-hugetlb-pages
+++ a/arch/sh/include/asm/tlb.h
@@ -65,6 +65,9 @@ tlb_remove_tlb_entry(struct mmu_gather *
 		tlb->end = address + PAGE_SIZE;
 }
 
+#define tlb_remove_huge_tlb_entry(h, tlb, ptep, address)	\
+	tlb_remove_tlb_entry(tlb, ptep, address)
+
 /*
  * In the case of tlb vma handling, we can optimise these away in the
  * case where we're doing a full MM flush.  When we're doing a munmap,
diff -puN arch/um/include/asm/tlb.h~mm-hugetlb-add-tlb_remove_hugetlb_entry-for-handling-hugetlb-pages arch/um/include/asm/tlb.h
--- a/arch/um/include/asm/tlb.h~mm-hugetlb-add-tlb_remove_hugetlb_entry-for-handling-hugetlb-pages
+++ a/arch/um/include/asm/tlb.h
@@ -141,6 +141,9 @@ static inline void tlb_remove_page_size(
 		__tlb_remove_tlb_entry(tlb, ptep, address);	\
 	} while (0)
 
+#define tlb_remove_huge_tlb_entry(h, tlb, ptep, address)	\
+	tlb_remove_tlb_entry(tlb, ptep, address)
+
 #define pte_free_tlb(tlb, ptep, addr) __pte_free_tlb(tlb, ptep, addr)
 
 #define pud_free_tlb(tlb, pudp, addr) __pud_free_tlb(tlb, pudp, addr)
diff -puN include/asm-generic/tlb.h~mm-hugetlb-add-tlb_remove_hugetlb_entry-for-handling-hugetlb-pages include/asm-generic/tlb.h
--- a/include/asm-generic/tlb.h~mm-hugetlb-add-tlb_remove_hugetlb_entry-for-handling-hugetlb-pages
+++ a/include/asm-generic/tlb.h
@@ -220,6 +220,12 @@ static inline bool __tlb_remove_pte_page
 		__tlb_remove_tlb_entry(tlb, ptep, address);	\
 	} while (0)
 
+#define tlb_remove_huge_tlb_entry(h, tlb, ptep, address)	     \
+	do {							     \
+		__tlb_adjust_range(tlb, address, huge_page_size(h)); \
+		__tlb_remove_tlb_entry(tlb, ptep, address);	     \
+	} while (0)
+
 /**
  * tlb_remove_pmd_tlb_entry - remember a pmd mapping for later tlb invalidation
  * This is a nop so far, because only x86 needs it.
diff -puN mm/hugetlb.c~mm-hugetlb-add-tlb_remove_hugetlb_entry-for-handling-hugetlb-pages mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-add-tlb_remove_hugetlb_entry-for-handling-hugetlb-pages
+++ a/mm/hugetlb.c
@@ -3272,7 +3272,7 @@ void __unmap_hugepage_range(struct mmu_g
 		}
 
 		pte = huge_ptep_get_and_clear(mm, address, ptep);
-		tlb_remove_tlb_entry(tlb, ptep, address);
+		tlb_remove_huge_tlb_entry(h, tlb, ptep, address);
 		if (huge_pte_dirty(pte))
 			set_page_dirty(page);
 
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

mm-hugetlb-use-the-right-pte-val-for-compare-in-hugetlb_cow.patch
mm-hugetlb-use-huge_pte_lock-instead-of-opencoding-the-lock.patch
mm-use-the-correct-page-size-when-removing-the-page.patch
mm-update-mmu_gather-range-correctly.patch
mm-hugetlb-add-tlb_remove_hugetlb_entry-for-handling-hugetlb-pages.patch
mm-add-tlb_remove_check_page_size_change-to-track-page-size-change.patch
mm-remove-the-page-size-change-check-in-tlb_remove_page.patch

