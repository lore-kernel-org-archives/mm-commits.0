From: akpm@linux-foundation.org
Subject: + mm-hugetlb-introduce-set_huge_swap_pte_at-helper-v4.patch added to -mm tree
Date: Wed, 24 May 2017 14:58:43 -0700
Message-ID: <59260213.5xS0uqkuvLMdhP8K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46566 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1036120AbdEXV6o (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 May 2017 17:58:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: punit.agrawal@arm.com, aneesh.kumar@linux.vnet.ibm.com, mike.kravetz@oracle.com, steve.capper@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-introduce-set_huge_swap_pte_at-helper-v4
has been added to the -mm tree.  Its filename is
     mm-hugetlb-introduce-set_huge_swap_pte_at-helper-v4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-introduce-set_huge_swap_pte_at-helper-v4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-introduce-set_huge_swap_pte_at-helper-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
