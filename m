From: akpm@linux-foundation.org
Subject: + mm-call-vma_adjust_trans_huge-only-for-thp-enabled-vma.patch
 added to -mm tree
Date: Thu, 27 Feb 2014 13:24:29 -0800
Message-ID: <530fad0d.IAquZsFjzKfCrTSq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39408 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaB0VYa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Feb 2014 16:24:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sasha.levin@oracle.com, n-horiguchi@ah.jp.nec.com

Subject: + mm-call-vma_adjust_trans_huge-only-for-thp-enabled-vma.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com,sasha.levin@oracle.com
From: akpm@linux-foundation.org
Date: Thu, 27 Feb 2014 13:24:29 -0800


The patch titled
     Subject: mm: call vma_adjust_trans_huge() only for thp-enabled vma
has been added to the -mm tree.  Its filename is
     mm-call-vma_adjust_trans_huge-only-for-thp-enabled-vma.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-call-vma_adjust_trans_huge-only-for-thp-enabled-vma.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-call-vma_adjust_trans_huge-only-for-thp-enabled-vma.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: call vma_adjust_trans_huge() only for thp-enabled vma

vma_adjust() is called also for vma(VM_HUGETLB) and it could happen that
we happen to try to split hugetlbfs hugepage.  So exclude the possibility.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/mmap.c~mm-call-vma_adjust_trans_huge-only-for-thp-enabled-vma mm/mmap.c
--- a/mm/mmap.c~mm-call-vma_adjust_trans_huge-only-for-thp-enabled-vma
+++ a/mm/mmap.c
@@ -772,7 +772,8 @@ again:			remove_next = 1 + (end > next->
 		}
 	}
 
-	vma_adjust_trans_huge(vma, start, end, adjust_next);
+	if (transparent_hugepage_enabled(vma))
+		vma_adjust_trans_huge(vma, start, end, adjust_next);
 
 	anon_vma = vma->anon_vma;
 	if (!anon_vma && adjust_next)
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
mm-hugetlb-unify-region-structure-handling.patch
mm-hugetlb-improve-cleanup-resv_map-parameters.patch
mm-hugetlb-fix-race-in-region-tracking.patch
mm-hugetlb-remove-resv_map_put.patch
mm-hugetlb-use-vma_resv_map-map-types.patch
mm-hugetlb-improve-page-fault-scalability.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
madvise-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-call-vma_adjust_trans_huge-only-for-thp-enabled-vma.patch
mm-rename-__do_fault-do_fault.patch
mm-do_fault-extract-to-call-vm_ops-do_fault-to-separate-function.patch
mm-introduce-do_read_fault.patch
mm-introduce-do_cow_fault.patch
mm-introduce-do_shared_fault-and-drop-do_fault.patch
mm-consolidate-code-to-call-vm_ops-page_mkwrite.patch
mm-consolidate-code-to-call-vm_ops-page_mkwrite-fix.patch
mm-consolidate-code-to-setup-pte.patch

