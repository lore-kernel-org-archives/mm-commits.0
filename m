From: akpm@linux-foundation.org
Subject: + mm-numa-slow-pte-scan-rate-if-migration-failures-occur.patch
 added to -mm tree
Date: Mon, 23 Mar 2015 16:16:01 -0700
Message-ID: <55109eb1.NOXC0eqOth8bpYdJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48658 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246AbbCWXQC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Mar 2015 19:16:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aneesh.kumar@linux.vnet.ibm.com, david@fromorbit.com, mingo@kernel.org, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: numa: slow PTE scan rate if migration failures occur
has been added to the -mm tree.  Its filename is
     mm-numa-slow-pte-scan-rate-if-migration-failures-occur.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-numa-slow-pte-scan-rate-if-migration-failures-occur.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-numa-slow-pte-scan-rate-if-migration-failures-occur.patch

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
Subject: mm: numa: slow PTE scan rate if migration failures occur

Dave Chinner reported the following on https://lkml.org/lkml/2015/3/1/226

  Across the board the 4.0-rc1 numbers are much slower, and the degradation
  is far worse when using the large memory footprint configs. Perf points
  straight at the cause - this is from 4.0-rc1 on the "-o bhash=101073" config:

   -   56.07%    56.07%  [kernel]            [k] default_send_IPI_mask_sequence_phys
      - default_send_IPI_mask_sequence_phys
         - 99.99% physflat_send_IPI_mask
            - 99.37% native_send_call_func_ipi
                 smp_call_function_many
               - native_flush_tlb_others
                  - 99.85% flush_tlb_page
                       ptep_clear_flush
                       try_to_unmap_one
                       rmap_walk
                       try_to_unmap
                       migrate_pages
                       migrate_misplaced_page
                     - handle_mm_fault
                        - 99.73% __do_page_fault
                             trace_do_page_fault
                             do_async_page_fault
                           + async_page_fault
              0.63% native_send_call_func_single_ipi
                 generic_exec_single
                 smp_call_function_single

This is showing excessive migration activity even though excessive
migrations are meant to get throttled.  Normally, the scan rate is tuned
on a per-task basis depending on the locality of faults.  However, if
migrations fail for any reason then the PTE scanner may scan faster if the
faults continue to be remote.  This means there is higher system CPU
overhead and fault trapping at exactly the time we know that migrations
cannot happen.  This patch tracks when migration failures occur and slows
the PTE scanner.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reported-by: Dave Chinner <david@fromorbit.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    9 +++++----
 kernel/sched/fair.c   |    8 ++++++--
 mm/huge_memory.c      |    3 ++-
 mm/memory.c           |    3 ++-
 4 files changed, 15 insertions(+), 8 deletions(-)

diff -puN include/linux/sched.h~mm-numa-slow-pte-scan-rate-if-migration-failures-occur include/linux/sched.h
--- a/include/linux/sched.h~mm-numa-slow-pte-scan-rate-if-migration-failures-occur
+++ a/include/linux/sched.h
@@ -1625,11 +1625,11 @@ struct task_struct {
 
 	/*
 	 * numa_faults_locality tracks if faults recorded during the last
-	 * scan window were remote/local. The task scan period is adapted
-	 * based on the locality of the faults with different weights
-	 * depending on whether they were shared or private faults
+	 * scan window were remote/local or failed to migrate. The task scan
+	 * period is adapted based on the locality of the faults with different
+	 * weights depending on whether they were shared or private faults
 	 */
-	unsigned long numa_faults_locality[2];
+	unsigned long numa_faults_locality[3];
 
 	unsigned long numa_pages_migrated;
 #endif /* CONFIG_NUMA_BALANCING */
@@ -1719,6 +1719,7 @@ struct task_struct {
 #define TNF_NO_GROUP	0x02
 #define TNF_SHARED	0x04
 #define TNF_FAULT_LOCAL	0x08
+#define TNF_MIGRATE_FAIL 0x10
 
 #ifdef CONFIG_NUMA_BALANCING
 extern void task_numa_fault(int last_node, int node, int pages, int flags);
diff -puN kernel/sched/fair.c~mm-numa-slow-pte-scan-rate-if-migration-failures-occur kernel/sched/fair.c
--- a/kernel/sched/fair.c~mm-numa-slow-pte-scan-rate-if-migration-failures-occur
+++ a/kernel/sched/fair.c
@@ -1609,9 +1609,11 @@ static void update_task_scan_period(stru
 	/*
 	 * If there were no record hinting faults then either the task is
 	 * completely idle or all activity is areas that are not of interest
-	 * to automatic numa balancing. Scan slower
+	 * to automatic numa balancing. Related to that, if there were failed
+	 * migration then it implies we are migrating too quickly or the local
+	 * node is overloaded. In either case, scan slower
 	 */
-	if (local + shared == 0) {
+	if (local + shared == 0 || p->numa_faults_locality[2]) {
 		p->numa_scan_period = min(p->numa_scan_period_max,
 			p->numa_scan_period << 1);
 
@@ -2080,6 +2082,8 @@ void task_numa_fault(int last_cpupid, in
 
 	if (migrated)
 		p->numa_pages_migrated += pages;
+	if (flags & TNF_MIGRATE_FAIL)
+		p->numa_faults_locality[2] += pages;
 
 	p->numa_faults[task_faults_idx(NUMA_MEMBUF, mem_node, priv)] += pages;
 	p->numa_faults[task_faults_idx(NUMA_CPUBUF, cpu_node, priv)] += pages;
diff -puN mm/huge_memory.c~mm-numa-slow-pte-scan-rate-if-migration-failures-occur mm/huge_memory.c
--- a/mm/huge_memory.c~mm-numa-slow-pte-scan-rate-if-migration-failures-occur
+++ a/mm/huge_memory.c
@@ -1350,7 +1350,8 @@ int do_huge_pmd_numa_page(struct mm_stru
 	if (migrated) {
 		flags |= TNF_MIGRATED;
 		page_nid = target_nid;
-	}
+	} else
+		flags |= TNF_MIGRATE_FAIL;
 
 	goto out;
 clear_pmdnuma:
diff -puN mm/memory.c~mm-numa-slow-pte-scan-rate-if-migration-failures-occur mm/memory.c
--- a/mm/memory.c~mm-numa-slow-pte-scan-rate-if-migration-failures-occur
+++ a/mm/memory.c
@@ -3103,7 +3103,8 @@ static int do_numa_page(struct mm_struct
 	if (migrated) {
 		page_nid = target_nid;
 		flags |= TNF_MIGRATED;
-	}
+	} else
+		flags |= TNF_MIGRATE_FAIL;
 
 out:
 	if (page_nid != -1)
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-page_alloc-call-kernel_map_pages-in-unset_migrateype_isolate.patch
mm-numa-group-related-processes-based-on-vma-flags-instead-of-page-table-flags.patch
mm-numa-preserve-pte-write-permissions-across-a-numa-hinting-fault.patch
mm-numa-slow-pte-scan-rate-if-migration-failures-occur.patch
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
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

