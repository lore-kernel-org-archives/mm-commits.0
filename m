From: akpm@linux-foundation.org
Subject: [folded] thp-mremap-support-and-tlb-optimization-fix-fix-fix.patch removed from -mm tree
Date: Mon, 31 Oct 2011 16:43:50 -0700
Message-ID: <201110312343.p9VNhoRR018911@hpaq14.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:42336 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab1JaXnz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 31 Oct 2011 19:43:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp-mremap-support-and-tlb-optimization-fix-fix-fix
has been removed from the -mm tree.  Its filename was
     thp-mremap-support-and-tlb-optimization-fix-fix-fix.patch

This patch was dropped because it was folded into thp-mremap-support-and-tlb-optimization.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: thp-mremap-support-and-tlb-optimization-fix-fix-fix



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/huge_memory.c~thp-mremap-support-and-tlb-optimization-fix-fix-fix mm/huge_memory.c
--- a/mm/huge_memory.c~thp-mremap-support-and-tlb-optimization-fix-fix-fix
+++ a/mm/huge_memory.c
@@ -1064,7 +1064,7 @@ int move_huge_pmd(struct vm_area_struct 
 
 	if ((old_addr & ~HPAGE_PMD_MASK) ||
 	    (new_addr & ~HPAGE_PMD_MASK) ||
-	    (old_addr + HPAGE_PMD_SIZE) > old_end ||
+	    old_end - old_addr < HPAGE_PMD_SIZE ||
 	    (new_vma->vm_flags & VM_NOHUGEPAGE))
 		goto out;
 
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
mm-compaction-trivial-clean-up-in-acct_isolated.patch
mm-change-isolate-mode-from-define-to-bitwise-type.patch
mm-compaction-make-isolate_lru_page-filter-aware.patch
mm-zone_reclaim-make-isolate_lru_page-filter-aware.patch
mm-migration-clean-up-unmap_and_move.patch
mremap-check-for-overflow-using-deltas.patch
mremap-avoid-sending-one-ipi-per-page.patch
thp-mremap-support-and-tlb-optimization.patch
mm-mempolicyc-quiet-sparse-noise.patch
mm-huge_memoryc-quiet-sparse-noise.patch
vmscan-limit-direct-reclaim-for-higher-order-allocations.patch
vmscan-limit-direct-reclaim-for-higher-order-allocations-fix.patch
vmscan-abort-reclaim-compaction-if-compaction-can-proceed.patch
mm-huge_memory-fix-copying-user-highpage.patch
mm-huge_memory-fix-typo-when-updating-mmu-cache.patch

