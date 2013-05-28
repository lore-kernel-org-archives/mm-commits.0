From: akpm@linux-foundation.org
Subject: [merged]
 mm-thp-use-pmd_populate-to-update-the-pmd-with-pgtable_t-pointer.patch
 removed from -mm tree
Date: Tue, 28 May 2013 12:36:57 -0700
Message-ID: <51a50759.tbz6eVSLHGGxBVOk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60430 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab3E1Tg6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 15:36:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, hughd@google.com, benh@kernel.crashing.org, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com

Subject: [merged] mm-thp-use-pmd_populate-to-update-the-pmd-with-pgtable_t-pointer.patch removed from -mm tree
To: aneesh.kumar@linux.vnet.ibm.com,aarcange@redhat.com,benh@kernel.crashing.org,hughd@google.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 12:36:57 -0700


The patch titled
     Subject: mm/THP: use pmd_populate() to update the pmd with pgtable_t pointer
has been removed from the -mm tree.  Its filename was
     mm-thp-use-pmd_populate-to-update-the-pmd-with-pgtable_t-pointer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm/THP: use pmd_populate() to update the pmd with pgtable_t pointer

We should not use set_pmd_at to update pmd_t with pgtable_t pointer. 
set_pmd_at is used to set pmd with huge pte entries and architectures like
ppc64, clear few flags from the pte when saving a new entry.  Without this
change we observe bad pte errors like below on ppc64 with THP enabled.

BUG: Bad page map in process ld mm=0xc000001ee39f4780 pte:7fc3f37848000001 pmd:c000001ec0000000

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN mm/huge_memory.c~mm-thp-use-pmd_populate-to-update-the-pmd-with-pgtable_t-pointer mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-use-pmd_populate-to-update-the-pmd-with-pgtable_t-pointer
+++ a/mm/huge_memory.c
@@ -2325,7 +2325,12 @@ static void collapse_huge_page(struct mm
 		pte_unmap(pte);
 		spin_lock(&mm->page_table_lock);
 		BUG_ON(!pmd_none(*pmd));
-		set_pmd_at(mm, address, pmd, _pmd);
+		/*
+		 * We can only use set_pmd_at when establishing
+		 * hugepmds and never for establishing regular pmds that
+		 * points to regular pagetables. Use pmd_populate for that
+		 */
+		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
 		spin_unlock(&mm->page_table_lock);
 		anon_vma_unlock_write(vma->anon_vma);
 		goto out;
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

mm-thp-use-the-right-function-when-updating-access-flags.patch
mm-thp-add-pmd-args-to-pgtable-deposit-and-withdraw-apis.patch
mm-thp-withdraw-the-pgtable-after-pmdp-related-operations.patch
mm-thp-withdraw-the-pgtable-after-pmdp-related-operations-fix.patch
mm-thp-dont-use-hpage_shift-in-transparent-hugepage-code.patch
mm-thp-deposit-the-transpare-huge-pgtable-before-set_pmd.patch

