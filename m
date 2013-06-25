From: akpm@linux-foundation.org
Subject: [merged]
 mm-thp-withdraw-the-pgtable-after-pmdp-related-operations.patch removed
 from -mm tree
Date: Tue, 25 Jun 2013 12:23:00 -0700
Message-ID: <51c9ee14.l1KOXLmuzZB4dOD8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42237 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab3FYTXB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jun 2013 15:23:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, david@gibson.dropbear.id.au, benh@kernel.crashing.org, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com

Subject: [merged] mm-thp-withdraw-the-pgtable-after-pmdp-related-operations.patch removed from -mm tree
To: aneesh.kumar@linux.vnet.ibm.com,aarcange@redhat.com,benh@kernel.crashing.org,david@gibson.dropbear.id.au,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 25 Jun 2013 12:23:00 -0700


The patch titled
     Subject: mm/THP: withdraw the pgtable after pmdp related operations
has been removed from the -mm tree.  Its filename was
     mm-thp-withdraw-the-pgtable-after-pmdp-related-operations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm/THP: withdraw the pgtable after pmdp related operations

For architectures like ppc64 we look at deposited pgtable when calling
pmdp_get_and_clear.  So do the pgtable_trans_huge_withdraw after finishing
pmdp related operations.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN mm/huge_memory.c~mm-thp-withdraw-the-pgtable-after-pmdp-related-operations mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-withdraw-the-pgtable-after-pmdp-related-operations
+++ a/mm/huge_memory.c
@@ -1360,9 +1360,15 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 		struct page *page;
 		pgtable_t pgtable;
 		pmd_t orig_pmd;
-		pgtable = pgtable_trans_huge_withdraw(tlb->mm, pmd);
+		/*
+		 * For architectures like ppc64 we look at deposited pgtable
+		 * when calling pmdp_get_and_clear. So do the
+		 * pgtable_trans_huge_withdraw after finishing pmdp related
+		 * operations.
+		 */
 		orig_pmd = pmdp_get_and_clear(tlb->mm, addr, pmd);
 		tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
+		pgtable = pgtable_trans_huge_withdraw(tlb->mm, pmd);
 		if (is_huge_zero_pmd(orig_pmd)) {
 			tlb->mm->nr_ptes--;
 			spin_unlock(&tlb->mm->page_table_lock);
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

linux-next.patch
mm-thp-dont-use-hpage_shift-in-transparent-hugepage-code-define-hpage_pmd_-constants-as-build_bug-if-thp.patch

