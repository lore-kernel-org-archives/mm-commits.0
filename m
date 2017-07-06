From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-hugetlb-introduce-set_huge_swap_pte_at-helper-v41.patch removed from -mm tree
Date: Thu, 06 Jul 2017 15:19:53 -0700
Message-ID: <595eb789.RDjWaWde1wBwUQpC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33138 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752717AbdGFWTy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:19:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: punit.agrawal@arm.com, aneesh.kumar@linux.vnet.ibm.com, mike.kravetz@oracle.com, steve.capper@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-introduce-set_huge_swap_pte_at-helper-v41
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-introduce-set_huge_swap_pte_at-helper-v41.patch

This patch was dropped because it was folded into mm-hugetlb-introduce-set_huge_swap_pte_at-helper.patch

------------------------------------------------------
From: Punit Agrawal <punit.agrawal@arm.com>
Subject: mm-hugetlb-introduce-set_huge_swap_pte_at-helper-v41

Add an empty definition for set_huge_swap_pte_at() when
CONFIG_HUGETLB_PAGE is disabled.

Link: http://lkml.kernel.org/r/20170525171331.31469-1-punit.agrawal@arm.com
Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Acked-by: Steve Capper <steve.capper@arm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff -puN include/linux/hugetlb.h~mm-hugetlb-introduce-set_huge_swap_pte_at-helper-v41 include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-introduce-set_huge_swap_pte_at-helper-v41
+++ a/include/linux/hugetlb.h
@@ -445,14 +445,6 @@ static inline pte_t arch_make_huge_pte(p
 }
 #endif
 
-#ifndef set_huge_swap_pte_at
-static inline void set_huge_swap_pte_at(struct mm_struct *mm, unsigned long addr,
-					pte_t *ptep, pte_t pte, unsigned long sz)
-{
-	set_huge_pte_at(mm, addr, ptep, pte);
-}
-#endif
-
 static inline struct hstate *page_hstate(struct page *page)
 {
 	VM_BUG_ON_PAGE(!PageHuge(page), page);
@@ -524,6 +516,14 @@ static inline void hugetlb_count_sub(lon
 {
 	atomic_long_sub(l, &mm->hugetlb_usage);
 }
+
+#ifndef set_huge_swap_pte_at
+static inline void set_huge_swap_pte_at(struct mm_struct *mm, unsigned long addr,
+					pte_t *ptep, pte_t pte, unsigned long sz)
+{
+	set_huge_pte_at(mm, addr, ptep, pte);
+}
+#endif
 #else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 #define alloc_huge_page(v, a, r) NULL
@@ -573,6 +573,11 @@ static inline void hugetlb_report_usage(
 static inline void hugetlb_count_sub(long l, struct mm_struct *mm)
 {
 }
+
+static inline void set_huge_swap_pte_at(struct mm_struct *mm, unsigned long addr,
+					pte_t *ptep, pte_t pte, unsigned long sz)
+{
+}
 #endif	/* CONFIG_HUGETLB_PAGE */
 
 static inline spinlock_t *huge_pte_lock(struct hstate *h,
_

Patches currently in -mm which might be from punit.agrawal@arm.com are

mm-gup-ensure-real-head-page-is-ref-counted-when-using-hugepages.patch
mm-hugetlb-add-size-parameter-to-huge_pte_offset.patch
mm-hugetlb-allow-architectures-to-override-huge_pte_clear.patch
mm-hugetlb-introduce-set_huge_swap_pte_at-helper.patch
mm-rmap-use-correct-helper-when-poisoning-hugepages.patch

