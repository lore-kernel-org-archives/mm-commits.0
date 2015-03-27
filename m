From: akpm@linux-foundation.org
Subject: [merged]
 mm-numa-mark-huge-ptes-young-when-clearing-numa-hinting-faults.patch
 removed from -mm tree
Date: Fri, 27 Mar 2015 11:17:14 -0700
Message-ID: <55159eaa.pie6AazzaxucCfXw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47757 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbbC0SRP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Mar 2015 14:17:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aneesh.kumar@linux.vnet.ibm.com, david@fromorbit.com, mingo@kernel.org, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: numa: mark huge PTEs young when clearing NUMA hinting faults
has been removed from the -mm tree.  Its filename was
     mm-numa-mark-huge-ptes-young-when-clearing-numa-hinting-faults.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1358,6 +1358,7 @@ clear_pmdnuma:
 	BUG_ON(!PageLocked(page));
 	was_writable = pmd_write(pmd);
 	pmd = pmd_modify(pmd, vma->vm_page_prot);
+	pmd = pmd_mkyoung(pmd);
 	if (was_writable)
 		pmd = pmd_mkwrite(pmd);
 	set_pmd_at(mm, haddr, pmdp, pmd);
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
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
mm-consolidate-all-page-flags-helpers-in-linux-page-flagsh.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
allow-compaction-of-unevictable-pages.patch
mm-change-deactivate_page-with-deactivate_file_page.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-move-lazy-free-pages-to-inactive-list.patch
kernelh-implement-div_round_closest_ull.patch
cpuidle-menu-use-div_round_closest_ull.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

