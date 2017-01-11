From: akpm@linux-foundation.org
Subject: [merged]
 mm-thp-pagecache-only-withdraw-page-table-after-a-successful-deposit.patch
 removed from -mm tree
Date: Wed, 11 Jan 2017 14:27:32 -0800
Message-ID: <5876b154.T7nSNUnESGgc95Sr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51198 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932220AbdAKW1d (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2017 17:27:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mpe@ellerman.id.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp/pagecache: only withdraw page table after a successful deposit
has been removed from the -mm tree.  Its filename was
     mm-thp-pagecache-only-withdraw-page-table-after-a-successful-deposit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm/thp/pagecache: only withdraw page table after a successful deposit

The current code wrongly called withdraw in the error path.  But we
haven't depoisted the page table yet in the only error path in that
function.  So for now remove that withdraw completely.  If we take that
"out:" branch, we should have vmf->prealloc_pte already pointing to the
allocated page table.

Fixes: 953c66c2b22a304d ("mm: THP page cache support for ppc64")
Link: http://lkml.kernel.org/r/20161212163428.6780-1-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Reported-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN mm/memory.c~mm-thp-pagecache-only-withdraw-page-table-after-a-successful-deposit mm/memory.c
--- a/mm/memory.c~mm-thp-pagecache-only-withdraw-page-table-after-a-successful-deposit
+++ a/mm/memory.c
@@ -3008,13 +3008,6 @@ static int do_set_pmd(struct vm_fault *v
 	ret = 0;
 	count_vm_event(THP_FILE_MAPPED);
 out:
-	/*
-	 * If we are going to fallback to pte mapping, do a
-	 * withdraw with pmd lock held.
-	 */
-	if (arch_needs_pgtable_deposit() && ret == VM_FAULT_FALLBACK)
-		vmf->prealloc_pte = pgtable_trans_huge_withdraw(vma->vm_mm,
-								vmf->pmd);
 	spin_unlock(vmf->ptl);
 	return ret;
 }
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are


