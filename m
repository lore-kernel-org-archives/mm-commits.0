From: akpm@linux-foundation.org
Subject: + mm-thp-return-the-correct-value-for-change_huge_pmd.patch added to -mm tree
Date: Wed, 11 Mar 2015 15:29:52 -0700
Message-ID: <5500c1e0.OiomCjyMdOFJ9+8P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51705 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbbCKW3x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Mar 2015 18:29:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aneesh.kumar@linux.vnet.ibm.com, david@fromorbit.com, mingo@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: return the correct value for change_huge_pmd
has been added to the -mm tree.  Its filename is
     mm-thp-return-the-correct-value-for-change_huge_pmd.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-return-the-correct-value-for-change_huge_pmd.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-return-the-correct-value-for-change_huge_pmd.patch

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
Subject: mm: thp: return the correct value for change_huge_pmd

The wrong value is being returned by change_huge_pmd since commit
10c1045f28e8 ("mm: numa: avoid unnecessary TLB flushes when setting NUMA
hinting entries") which allows a fallthrough that tries to adjust
non-existent PTEs.  This patch corrects it.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reported-by: Dave Chinner <david@fromorbit.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-return-the-correct-value-for-change_huge_pmd mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-return-the-correct-value-for-change_huge_pmd
+++ a/mm/huge_memory.c
@@ -1482,6 +1482,7 @@ int change_huge_pmd(struct vm_area_struc
 
 	if (__pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
 		pmd_t entry;
+		ret = 1;
 
 		/*
 		 * Avoid trapping faults against the zero page. The read-only
@@ -1490,11 +1491,10 @@ int change_huge_pmd(struct vm_area_struc
 		 */
 		if (prot_numa && is_huge_zero_pmd(*pmd)) {
 			spin_unlock(ptl);
-			return 0;
+			return ret;
 		}
 
 		if (!prot_numa || !pmd_protnone(*pmd)) {
-			ret = 1;
 			entry = pmdp_get_and_clear_notify(mm, addr, pmd);
 			entry = pmd_modify(entry, newprot);
 			ret = HPAGE_PMD_NR;
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-thp-return-the-correct-value-for-change_huge_pmd.patch
mm-numa-do-not-clear-ptes-or-pmds-for-numa-hinting-faults.patch
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
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

