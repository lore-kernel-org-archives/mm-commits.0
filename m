From: akpm@linux-foundation.org
Subject: + mm-hugetlb-introduce-set_huge_swap_pte_at-helper-v41.patch
 added to -mm tree
Date: Thu, 25 May 2017 15:30:00 -0700
Message-ID: <59275ae8.qsXCDB9sMPkwGuLd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44058 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1946174AbdEYWaB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2017 18:30:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: punit.agrawal@arm.com, aneesh.kumar@linux.vnet.ibm.com, mike.kravetz@oracle.com, steve.capper@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-introduce-set_huge_swap_pte_at-helper-v41
has been added to the -mm tree.  Its filename is
     mm-hugetlb-introduce-set_huge_swap_pte_at-helper-v41.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-introduce-set_huge_swap_pte_at-helper-v41.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-introduce-set_huge_swap_pte_at-helper-v41.patch

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

mm-migrate-fix-ref-count-handling-when-hugepage_migration_supported.patch
mm-gup-ensure-real-head-page-is-ref-counted-when-using-hugepages.patch
mm-hugetlb-add-size-parameter-to-huge_pte_offset.patch
mm-hugetlb-allow-architectures-to-override-huge_pte_clear.patch
mm-hugetlb-introduce-set_huge_swap_pte_at-helper.patch
mm-hugetlb-introduce-set_huge_swap_pte_at-helper-v4.patch
mm-hugetlb-introduce-set_huge_swap_pte_at-helper-v41.patch
mm-rmap-use-correct-helper-when-poisoning-hugepages.patch

