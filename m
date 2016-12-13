From: akpm@linux-foundation.org
Subject: [patch 041/123] mm/hugetlb: add tlb_remove_hugetlb_entry for
 handling hugetlb pages
Date: Mon, 12 Dec 2016 16:42:37 -0800
Message-ID: <584f43fd./suloATUFUj2Z50w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40958 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752425AbcLMAmj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:42:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, dan.j.williams@intel.com, kirill@shutemov.name, ross.zwisler@linux.intel.com

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
@@ -3336,7 +3336,7 @@ void __unmap_hugepage_range(struct mmu_g
 		}
 
 		pte = huge_ptep_get_and_clear(mm, address, ptep);
-		tlb_remove_tlb_entry(tlb, ptep, address);
+		tlb_remove_huge_tlb_entry(h, tlb, ptep, address);
 		if (huge_pte_dirty(pte))
 			set_page_dirty(page);
 
_
