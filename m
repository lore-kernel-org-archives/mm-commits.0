From: akpm@linux-foundation.org
Subject: [merged] mm-huge_memory-use-zap_deposited_table-more.patch
 removed from -mm tree
Date: Tue, 09 May 2017 11:04:19 -0700
Message-ID: <20170509180419.pBAS5N2bo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35592 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751838AbdEISEU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 14:04:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, arbab@linux.vnet.ibm.com, bsingharora@gmail.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, oohall@gmail.com


The patch titled
     Subject: mm/huge_memory.c: use zap_deposited_table() more
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-use-zap_deposited_table-more.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Oliver O'Halloran" <oohall@gmail.com>
Subject: mm/huge_memory.c: use zap_deposited_table() more

Depending on the flags of the PMD being zapped there may or may not be a
deposited pgtable to be freed.  In two of the three cases this is open
coded while the third uses the zap_deposited_table() helper.  This patch
converts the others to use the helper to clean things up a bit.

Link: http://lkml.kernel.org/r/20170411174233.21902-2-oohall@gmail.com
Cc: Reza Arbab <arbab@linux.vnet.ibm.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: linux-nvdimm@ml01.01.org
Cc: Oliver O'Halloran <oohall@gmail.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN mm/huge_memory.c~mm-huge_memory-use-zap_deposited_table-more mm/huge_memory.c
--- a/mm/huge_memory.c~mm-huge_memory-use-zap_deposited_table-more
+++ a/mm/huge_memory.c
@@ -1615,8 +1615,7 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 		if (is_huge_zero_pmd(orig_pmd))
 			tlb_remove_page_size(tlb, pmd_page(orig_pmd), HPAGE_PMD_SIZE);
 	} else if (is_huge_zero_pmd(orig_pmd)) {
-		pte_free(tlb->mm, pgtable_trans_huge_withdraw(tlb->mm, pmd));
-		atomic_long_dec(&tlb->mm->nr_ptes);
+		zap_deposited_table(tlb->mm, pmd);
 		spin_unlock(ptl);
 		tlb_remove_page_size(tlb, pmd_page(orig_pmd), HPAGE_PMD_SIZE);
 	} else {
@@ -1625,10 +1624,7 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 		VM_BUG_ON_PAGE(page_mapcount(page) < 0, page);
 		VM_BUG_ON_PAGE(!PageHead(page), page);
 		if (PageAnon(page)) {
-			pgtable_t pgtable;
-			pgtable = pgtable_trans_huge_withdraw(tlb->mm, pmd);
-			pte_free(tlb->mm, pgtable);
-			atomic_long_dec(&tlb->mm->nr_ptes);
+			zap_deposited_table(tlb->mm, pmd);
 			add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
 		} else {
 			if (arch_needs_pgtable_deposit())
_

Patches currently in -mm which might be from oohall@gmail.com are


