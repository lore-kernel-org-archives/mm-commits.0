From: akpm@linux-foundation.org
Subject: +
 mm-numa-mark-huge-ptes-young-when-clearing-numa-hinting-faults.patch added
 to -mm tree
Date: Wed, 11 Mar 2015 16:05:55 -0700
Message-ID: <5500ca53.zcN7NqtJMB/tlzjb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53557 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbbCKXF4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Mar 2015 19:05:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aneesh.kumar@linux.vnet.ibm.com, david@fromorbit.com, mingo@kernel.org, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: numa: mark huge PTEs young when clearing NUMA hinting faults
has been added to the -mm tree.  Its filename is
     mm-numa-mark-huge-ptes-young-when-clearing-numa-hinting-faults.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-numa-mark-huge-ptes-young-when-clearing-numa-hinting-faults.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-numa-mark-huge-ptes-young-when-clearing-numa-hinting-faults.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: numa: mark huge PTEs young when clearing NUMA hinting faults

Base PTEs are marked young when the NUMA hinting information is cleared
but the same does not happen for huge pages which this patch addresses. 
Note that migrated pages are not marked young as the base page migration
code does not assume that migrated pages have been referenced.  This could
be addressed but beyond the scope of this series which is aimed at Dave
Chinners shrink workload that is unlikely to be affected by this issue.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/huge_memory.c~mm-numa-mark-huge-ptes-young-when-clearing-numa-hinting-faults mm/huge_memory.c
--- a/mm/huge_memory.c~mm-numa-mark-huge-ptes-young-when-clearing-numa-hinting-faults
+++ a/mm/huge_memory.c
@@ -1359,6 +1359,7 @@ int do_huge_pmd_numa_page(struct mm_stru
 clear_pmdnuma:
 	BUG_ON(!PageLocked(page));
 	pmd = pmd_modify(pmd, vma->vm_page_prot);
+	pmd = pmd_mkyoung(pmd);
 	set_pmd_at(mm, haddr, pmdp, pmd);
 	update_mmu_cache_pmd(vma, addr, pmdp);
 	unlock_page(page);
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-thp-return-the-correct-value-for-change_huge_pmd.patch
mm-numa-do-not-clear-ptes-or-pmds-for-numa-hinting-faults.patch
mm-numa-mark-huge-ptes-young-when-clearing-numa-hinting-faults.patch
cxgb4-drop-__gfp_nofail-allocation.patch
jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
mm-cma-change-fallback-behaviour-for-cma-freepage.patch
mm-page_alloc-factor-out-fallback-freepage-checking.patch
mm-compaction-enhance-compaction-finish-condition.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
mm-refactor-do_wp_page-extract-the-reuse-case.patch
mm-refactor-do_wp_page-rewrite-the-unlock-flow.patch
mm-refactor-do_wp_page-extract-the-page-copy-flow.patch
mm-refactor-do_wp_page-handling-of-shared-vma-into-a-function.patch
mm-remove-gfp_thisnode.patch
mm-thp-really-limit-transparent-hugepage-allocation-to-local-node.patch
kernel-cpuset-remove-exception-for-__gfp_thisnode.patch
mm-clarify-__gfp_nofail-deprecation-status.patch
sparc-clarify-__gfp_nofail-allocation.patch
mm-numa-remove-migrate_ratelimited.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

