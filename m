From: akpm@linux-foundation.org
Subject: [merged]
 mm-numa-preserve-pte-write-permissions-across-a-numa-hinting-fault.patch
 removed from -mm tree
Date: Fri, 27 Mar 2015 11:17:08 -0700
Message-ID: <55159ea4.ZL/TRZv22Nk6SO8j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47745 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237AbbC0SRJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Mar 2015 14:17:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aneesh.kumar@linux.vnet.ibm.com, david@fromorbit.com, mingo@kernel.org, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: numa: preserve PTE write permissions across a NUMA hinting fault
has been removed from the -mm tree.  Its filename was
     mm-numa-preserve-pte-write-permissions-across-a-numa-hinting-fault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: numa: preserve PTE write permissions across a NUMA hinting fault

Protecting a PTE to trap a NUMA hinting fault clears the writable bit and
further faults are needed after trapping a NUMA hinting fault to set the
writable bit again.  This patch preserves the writable bit when trapping
NUMA hinting faults.  The impact is obvious from the number of minor
faults trapped during the basis balancing benchmark and the system CPU
usage;

autonumabench
                                           4.0.0-rc4             4.0.0-rc4
                                            baseline              preserve
Time System-NUMA01                  107.13 (  0.00%)      103.13 (  3.73%)
Time System-NUMA01_THEADLOCAL       131.87 (  0.00%)       83.30 ( 36.83%)
Time System-NUMA02                    8.95 (  0.00%)       10.72 (-19.78%)
Time System-NUMA02_SMT                4.57 (  0.00%)        3.99 ( 12.69%)
Time Elapsed-NUMA01                 515.78 (  0.00%)      517.26 ( -0.29%)
Time Elapsed-NUMA01_THEADLOCAL      384.10 (  0.00%)      384.31 ( -0.05%)
Time Elapsed-NUMA02                  48.86 (  0.00%)       48.78 (  0.16%)
Time Elapsed-NUMA02_SMT              47.98 (  0.00%)       48.12 ( -0.29%)

             4.0.0-rc4   4.0.0-rc4
              baseline    preserve
User          44383.95    43971.89
System          252.61      201.24
Elapsed         998.68     1000.94

Minor Faults   2597249     1981230
Major Faults       365         364

There is a similar drop in system CPU usage using Dave Chinner's xfsrepair
workload

                                    4.0.0-rc4             4.0.0-rc4
                                     baseline              preserve
Amean    real-xfsrepair      454.14 (  0.00%)      442.36 (  2.60%)
Amean    syst-xfsrepair      277.20 (  0.00%)      204.68 ( 26.16%)

The patch looks hacky but the alternatives looked worse.  The tidest was
to rewalk the page tables after a hinting fault but it was more complex
than this approach and the performance was worse.  It's not generally safe
to just mark the page writable during the fault if it's a write fault as
it may have been read-only for COW so that approach was discarded.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reported-by: Dave Chinner <david@fromorbit.com>
Tested-by: Dave Chinner <david@fromorbit.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    9 ++++++++-
 mm/memory.c      |    8 +++-----
 mm/mprotect.c    |    3 +++
 3 files changed, 14 insertions(+), 6 deletions(-)

diff -puN mm/huge_memory.c~mm-numa-preserve-pte-write-permissions-across-a-numa-hinting-fault mm/huge_memory.c
--- a/mm/huge_memory.c~mm-numa-preserve-pte-write-permissions-across-a-numa-hinting-fault
+++ a/mm/huge_memory.c
@@ -1260,6 +1260,7 @@ int do_huge_pmd_numa_page(struct mm_stru
 	int target_nid, last_cpupid = -1;
 	bool page_locked;
 	bool migrated = false;
+	bool was_writable;
 	int flags = 0;
 
 	/* A PROT_NONE fault should not end up here */
@@ -1354,7 +1355,10 @@ int do_huge_pmd_numa_page(struct mm_stru
 	goto out;
 clear_pmdnuma:
 	BUG_ON(!PageLocked(page));
+	was_writable = pmd_write(pmd);
 	pmd = pmd_modify(pmd, vma->vm_page_prot);
+	if (was_writable)
+		pmd = pmd_mkwrite(pmd);
 	set_pmd_at(mm, haddr, pmdp, pmd);
 	update_mmu_cache_pmd(vma, addr, pmdp);
 	unlock_page(page);
@@ -1478,6 +1482,7 @@ int change_huge_pmd(struct vm_area_struc
 
 	if (__pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
 		pmd_t entry;
+		bool preserve_write = prot_numa && pmd_write(*pmd);
 		ret = 1;
 
 		/*
@@ -1493,9 +1498,11 @@ int change_huge_pmd(struct vm_area_struc
 		if (!prot_numa || !pmd_protnone(*pmd)) {
 			entry = pmdp_get_and_clear_notify(mm, addr, pmd);
 			entry = pmd_modify(entry, newprot);
+			if (preserve_write)
+				entry = pmd_mkwrite(entry);
 			ret = HPAGE_PMD_NR;
 			set_pmd_at(mm, addr, pmd, entry);
-			BUG_ON(pmd_write(entry));
+			BUG_ON(!preserve_write && pmd_write(entry));
 		}
 		spin_unlock(ptl);
 	}
diff -puN mm/memory.c~mm-numa-preserve-pte-write-permissions-across-a-numa-hinting-fault mm/memory.c
--- a/mm/memory.c~mm-numa-preserve-pte-write-permissions-across-a-numa-hinting-fault
+++ a/mm/memory.c
@@ -3035,6 +3035,7 @@ static int do_numa_page(struct mm_struct
 	int last_cpupid;
 	int target_nid;
 	bool migrated = false;
+	bool was_writable = pte_write(pte);
 	int flags = 0;
 
 	/* A PROT_NONE fault should not end up here */
@@ -3059,6 +3060,8 @@ static int do_numa_page(struct mm_struct
 	/* Make it present again */
 	pte = pte_modify(pte, vma->vm_page_prot);
 	pte = pte_mkyoung(pte);
+	if (was_writable)
+		pte = pte_mkwrite(pte);
 	set_pte_at(mm, addr, ptep, pte);
 	update_mmu_cache(vma, addr, ptep);
 
@@ -3075,11 +3078,6 @@ static int do_numa_page(struct mm_struct
 	 * to it but pte_write gets cleared during protection updates and
 	 * pte_dirty has unpredictable behaviour between PTE scan updates,
 	 * background writeback, dirty balancing and application behaviour.
-	 *
-	 * TODO: Note that the ideal here would be to avoid a situation where a
-	 * NUMA fault is taken immediately followed by a write fault in
-	 * some cases which would have lower overhead overall but would be
-	 * invasive as the fault paths would need to be unified.
 	 */
 	if (!(vma->vm_flags & VM_WRITE))
 		flags |= TNF_NO_GROUP;
diff -puN mm/mprotect.c~mm-numa-preserve-pte-write-permissions-across-a-numa-hinting-fault mm/mprotect.c
--- a/mm/mprotect.c~mm-numa-preserve-pte-write-permissions-across-a-numa-hinting-fault
+++ a/mm/mprotect.c
@@ -75,6 +75,7 @@ static unsigned long change_pte_range(st
 		oldpte = *pte;
 		if (pte_present(oldpte)) {
 			pte_t ptent;
+			bool preserve_write = prot_numa && pte_write(oldpte);
 
 			/*
 			 * Avoid trapping faults against the zero or KSM
@@ -94,6 +95,8 @@ static unsigned long change_pte_range(st
 
 			ptent = ptep_modify_prot_start(mm, addr, pte);
 			ptent = pte_modify(ptent, newprot);
+			if (preserve_write)
+				ptent = pte_mkwrite(ptent);
 
 			/* Avoid taking write faults for known dirty pages */
 			if (dirty_accountable && pte_dirty(ptent) &&
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

