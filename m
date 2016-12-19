From: akpm@linux-foundation.org
Subject: +
 mm-thp-pagecache-only-withdraw-page-table-after-a-successful-deposit.patch
 added to -mm tree
Date: Mon, 19 Dec 2016 14:17:27 -0800
Message-ID: <58585c77.WH9+Ic6rCGejbO4G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42946 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754323AbcLSWQ2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2016 17:16:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mpe@ellerman.id.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp/pagecache: only withdraw page table after a successful deposit
has been added to the -mm tree.  Its filename is
     mm-thp-pagecache-only-withdraw-page-table-after-a-successful-deposit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-pagecache-only-withdraw-page-table-after-a-successful-deposit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-pagecache-only-withdraw-page-table-after-a-successful-deposit.patch

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

mm-thp-pagecache-only-withdraw-page-table-after-a-successful-deposit.patch
mm-thp-pagecache-collapse-free-the-pte-page-table-on-collapse-for-thp-page-cache.patch

