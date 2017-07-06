From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-hugetlb-introduce-set_huge_swap_pte_at-helper-v4.patch removed from -mm
 tree
Date: Thu, 06 Jul 2017 15:19:46 -0700
Message-ID: <595eb782.J5190opGDb/vRxS0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33126 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753035AbdGFWTr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:19:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: punit.agrawal@arm.com, aneesh.kumar@linux.vnet.ibm.com, mike.kravetz@oracle.com, steve.capper@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-introduce-set_huge_swap_pte_at-helper-v4
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-introduce-set_huge_swap_pte_at-helper-v4.patch

This patch was dropped because it was folded into mm-hugetlb-introduce-set_huge_swap_pte_at-helper.patch

------------------------------------------------------
From: Punit Agrawal <punit.agrawal@arm.com>
Subject: mm-hugetlb-introduce-set_huge_swap_pte_at-helper-v4

Link: http://lkml.kernel.org/r/20170524115409.31309-8-punit.agrawal@arm.com
Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Acked-by: Steve Capper <steve.capper@arm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   11 ++++++++---
 mm/hugetlb.c            |    6 ------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff -puN include/linux/hugetlb.h~mm-hugetlb-introduce-set_huge_swap_pte_at-helper-v4 include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-introduce-set_huge_swap_pte_at-helper-v4
+++ a/include/linux/hugetlb.h
@@ -158,9 +158,6 @@ unsigned long hugetlb_change_protection(
 		unsigned long address, unsigned long end, pgprot_t newprot);
 
 bool is_hugetlb_entry_migration(pte_t pte);
-
-void set_huge_swap_pte_at(struct mm_struct *mm, unsigned long addr,
-			  pte_t *ptep, pte_t pte, unsigned long sz);
 #else /* !CONFIG_HUGETLB_PAGE */
 
 static inline void reset_vma_resv_huge_pages(struct vm_area_struct *vma)
@@ -448,6 +445,14 @@ static inline pte_t arch_make_huge_pte(p
 }
 #endif
 
+#ifndef set_huge_swap_pte_at
+static inline void set_huge_swap_pte_at(struct mm_struct *mm, unsigned long addr,
+					pte_t *ptep, pte_t pte, unsigned long sz)
+{
+	set_huge_pte_at(mm, addr, ptep, pte);
+}
+#endif
+
 static inline struct hstate *page_hstate(struct page *page)
 {
 	VM_BUG_ON_PAGE(!PageHuge(page), page);
diff -puN mm/hugetlb.c~mm-hugetlb-introduce-set_huge_swap_pte_at-helper-v4 mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-introduce-set_huge_swap_pte_at-helper-v4
+++ a/mm/hugetlb.c
@@ -3224,12 +3224,6 @@ static int is_hugetlb_entry_hwpoisoned(p
 		return 0;
 }
 
-void __weak set_huge_swap_pte_at(struct mm_struct *mm, unsigned long addr,
-				 pte_t *ptep, pte_t pte, unsigned long sz)
-{
-	set_huge_pte_at(mm, addr, ptep, pte);
-}
