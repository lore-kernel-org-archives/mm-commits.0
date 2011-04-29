From: akpm@linux-foundation.org
Subject: [merged] mm-check-if-pte-is-already-allocated-during-page-fault.patch removed from -mm tree
Date: Fri, 29 Apr 2011 12:47:05 -0700
Message-ID: <201104291941.p3TJfaNw011462__11965.952118817$1304106406$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58211 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760905Ab1D2Tqb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Apr 2011 15:46:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aarcange@redhat.com, hannes@cmpxchg.org, minchan.kim@gmail.com, raziebe@gmail.com, riel@redhat.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mm: check if PTE is already allocated during page fault
has been removed from the -mm tree.  Its filename was
     mm-check-if-pte-is-already-allocated-during-page-fault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: check if PTE is already allocated during page fault
From: Mel Gorman <mgorman@suse.de>

With transparent hugepage support, handle_mm_fault() has to be careful
that a normal PMD has been established before handling a PTE fault.  To
achieve this, it used __pte_alloc() directly instead of pte_alloc_map as
pte_alloc_map is unsafe to run against a huge PMD.  pte_offset_map() is
called once it is known the PMD is safe.

pte_alloc_map() is smart enough to check if a PTE is already present
before calling __pte_alloc but this check was lost.  As a consequence,
PTEs may be allocated unnecessarily and the page table lock taken.  Thi
useless PTE does get cleaned up but it's a performance hit which is
visible in page_test from aim9.

This patch simply re-adds the check normally done by pte_alloc_map to
check if the PTE needs to be allocated before taking the page table lock. 
The effect is noticable in page_test from aim9.

AIM9
                2.6.38-vanilla 2.6.38-checkptenone
creat-clo      446.10 ( 0.00%)   424.47 (-5.10%)
page_test       38.10 ( 0.00%)    42.04 ( 9.37%)
brk_test        52.45 ( 0.00%)    51.57 (-1.71%)
exec_test      382.00 ( 0.00%)   456.90 (16.39%)
fork_test       60.11 ( 0.00%)    67.79 (11.34%)
MMTests Statistics: duration
Total Elapsed Time (seconds)                611.90    612.22

(While this affects 2.6.38, it is a performance rather than a functional
bug and normally outside the rules -stable.  While the big performance
differences are to a microbench, the difference in fork and exec
performance may be significant enough that -stable wants to consider the
patch)

Reported-by: Raz Ben Yehuda <raziebe@gmail.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@kernel.org>		[2.6.38.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~mm-check-if-pte-is-already-allocated-during-page-fault mm/memory.c
--- a/mm/memory.c~mm-check-if-pte-is-already-allocated-during-page-fault
+++ a/mm/memory.c
@@ -3396,7 +3396,7 @@ int handle_mm_fault(struct mm_struct *mm
 	 * run pte_offset_map on the pmd, if an huge pmd could
 	 * materialize from under us from a different thread.
 	 */
-	if (unlikely(__pte_alloc(mm, vma, pmd, address)))
+	if (unlikely(pmd_none(*pmd)) && __pte_alloc(mm, vma, pmd, address))
 		return VM_FAULT_OOM;
 	/* if an huge pmd materialized from under us just retry later */
 	if (unlikely(pmd_trans_huge(*pmd)))
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch

