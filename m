From: akpm@linux-foundation.org
Subject: [merged]
 mm-thp-pagecache-collapse-free-the-pte-page-table-on-collapse-for-thp-page-cache.patch removed from -mm tree
Date: Wed, 11 Jan 2017 14:27:39 -0800
Message-ID: <5876b15b.wKWVuo0Z36xvO475%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51218 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932220AbdAKW1k (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2017 17:27:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mpe@ellerman.id.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp/pagecache/collapse: free the pte page table on collapse for thp page cache.
has been removed from the -mm tree.  Its filename was
     mm-thp-pagecache-collapse-free-the-pte-page-table-on-collapse-for-thp-page-cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm/thp/pagecache/collapse: free the pte page table on collapse for thp page cache.

With THP page cache, when trying to build a huge page from regular pte
pages, we just clear the pmd entry.  We will take another fault and at
that point we will find the huge page in the radix tree, thereby using the
huge page to complete the page fault

The second fault path will allocate the needed pgtable_t page for archs
like ppc64.  So no need to deposit the same in collapse path.  Depositing
them in the collapse path resulting in a pgtable_t memory leak also giving
errors like "[ 2362.021762] BUG: non-zero nr_ptes on freeing mm: 3"

Fixes: 953c66c2b22a304d ("mm: THP page cache support for ppc64")
Link: http://lkml.kernel.org/r/20161212163428.6780-2-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff -puN mm/khugepaged.c~mm-thp-pagecache-collapse-free-the-pte-page-table-on-collapse-for-thp-page-cache mm/khugepaged.c
--- a/mm/khugepaged.c~mm-thp-pagecache-collapse-free-the-pte-page-table-on-collapse-for-thp-page-cache
+++ a/mm/khugepaged.c
@@ -1242,7 +1242,6 @@ static void retract_page_tables(struct a
 	struct vm_area_struct *vma;
 	unsigned long addr;
 	pmd_t *pmd, _pmd;
-	bool deposited = false;
 
 	i_mmap_lock_write(mapping);
 	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
@@ -1267,26 +1266,10 @@ static void retract_page_tables(struct a
 			spinlock_t *ptl = pmd_lock(vma->vm_mm, pmd);
 			/* assume page table is clear */
 			_pmd = pmdp_collapse_flush(vma, addr, pmd);
-			/*
-			 * now deposit the pgtable for arch that need it
-			 * otherwise free it.
-			 */
-			if (arch_needs_pgtable_deposit()) {
-				/*
-				 * The deposit should be visibile only after
-				 * collapse is seen by others.
-				 */
-				smp_wmb();
-				pgtable_trans_huge_deposit(vma->vm_mm, pmd,
-							   pmd_pgtable(_pmd));
-				deposited = true;
-			}
 			spin_unlock(ptl);
 			up_write(&vma->vm_mm->mmap_sem);
-			if (!deposited) {
-				atomic_long_dec(&vma->vm_mm->nr_ptes);
-				pte_free(vma->vm_mm, pmd_pgtable(_pmd));
-			}
+			atomic_long_dec(&vma->vm_mm->nr_ptes);
+			pte_free(vma->vm_mm, pmd_pgtable(_pmd));
 		}
 	}
 	i_mmap_unlock_write(mapping);
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are


