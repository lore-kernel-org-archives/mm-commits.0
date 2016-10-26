From: akpm@linux-foundation.org
Subject: + mm-use-the-correct-page-size-when-removing-the-page.patch added to -mm tree
Date: Wed, 26 Oct 2016 16:36:02 -0700
Message-ID: <58113de2.A0AYWcjodd+uJRE+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41421 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932887AbcJZXgJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Oct 2016 19:36:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, dan.j.williams@intel.com, kirill@shutemov.name, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use the correct page size when removing the page
has been added to the -mm tree.  Its filename is
     mm-use-the-correct-page-size-when-removing-the-page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-the-correct-page-size-when-removing-the-page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-the-correct-page-size-when-removing-the-page.patch

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
Subject: mm: use the correct page size when removing the page

We are removing a pmd hugepage here. Use the correct page size.

Link: http://lkml.kernel.org/r/20161026084839.27299-2-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/huge_memory.c~mm-use-the-correct-page-size-when-removing-the-page mm/huge_memory.c
--- a/mm/huge_memory.c~mm-use-the-correct-page-size-when-removing-the-page
+++ a/mm/huge_memory.c
@@ -1398,12 +1398,12 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 	if (vma_is_dax(vma)) {
 		spin_unlock(ptl);
 		if (is_huge_zero_pmd(orig_pmd))
-			tlb_remove_page(tlb, pmd_page(orig_pmd));
+			tlb_remove_page_size(tlb, pmd_page(orig_pmd), HPAGE_PMD_SIZE);
 	} else if (is_huge_zero_pmd(orig_pmd)) {
 		pte_free(tlb->mm, pgtable_trans_huge_withdraw(tlb->mm, pmd));
 		atomic_long_dec(&tlb->mm->nr_ptes);
 		spin_unlock(ptl);
-		tlb_remove_page(tlb, pmd_page(orig_pmd));
+		tlb_remove_page_size(tlb, pmd_page(orig_pmd), HPAGE_PMD_SIZE);
 	} else {
 		struct page *page = pmd_page(orig_pmd);
 		page_remove_rmap(page, true);
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

mm-hugetlb-use-the-right-pte-val-for-compare-in-hugetlb_cow.patch
mm-hugetlb-use-huge_pte_lock-instead-of-opencoding-the-lock.patch
mm-use-the-correct-page-size-when-removing-the-page.patch
mm-update-mmu_gather-range-correctly.patch
mm-hugetlb-add-tlb_remove_hugetlb_entry-for-handling-hugetlb-pages.patch
mm-add-tlb_remove_check_page_size_change-to-track-page-size-change.patch
mm-remove-the-page-size-change-check-in-tlb_remove_page.patch

