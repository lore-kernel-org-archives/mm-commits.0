From: akpm@linux-foundation.org
Subject: + x86-mm-change-tlb_flushall_shift-for-ivybridge.patch added to
 -mm tree
Date: Thu, 09 Jan 2014 14:02:03 -0800
Message-ID: <52cf1c5b.q2IyCH9fQZVNY/nb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52588 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbaAIWCF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jan 2014 17:02:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, riel@redhat.com, mingo@kernel.org, hpa@zytor.com, alex.shi@linaro.org, mgorman@suse.de

Subject: + x86-mm-change-tlb_flushall_shift-for-ivybridge.patch added to -mm tree
To: mgorman@suse.de,alex.shi@linaro.org,hpa@zytor.com,mingo@kernel.org,riel@redhat.com,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Thu, 09 Jan 2014 14:02:03 -0800


The patch titled
     Subject: x86: mm: Change tlb_flushall_shift for IvyBridge
has been added to the -mm tree.  Its filename is
     x86-mm-change-tlb_flushall_shift-for-ivybridge.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-mm-change-tlb_flushall_shift-for-ivybridge.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-mm-change-tlb_flushall_shift-for-ivybridge.patch

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
Subject: x86: mm: Change tlb_flushall_shift for IvyBridge

There was a large performance regression that was bisected to commit
611ae8e3 (x86/tlb: enable tlb flush range support for x86).  This patch
simply changes the default balance point between a local and global flush
for IvyBridge.

In the interest of allowing the tests to be reproduced, this patch was
tested using mmtests 0.15 with the following configurations

	configs/config-global-dhp__tlbflush-performance
	configs/config-global-dhp__scheduler-performance
	configs/config-global-dhp__network-performance

Results are from two machines

Ivybridge   4 threads:  Intel(R) Core(TM) i3-3240 CPU @ 3.40GHz
Ivybridge   8 threads:  Intel(R) Core(TM) i7-3770 CPU @ 3.40GHz

Page fault microbenchmark showed nothing interesting.

Ebizzy was configured to run multiple iterations and threads. Thread counts
ranged from 1 to NR_CPUS*2. For each thread count, it ran 100 iterations and
each iteration lasted 10 seconds.

Ivybridge 4 threads
                    3.13.0-rc7            3.13.0-rc7
                       vanilla           altshift-v3
Mean   1     6395.44 (  0.00%)     6789.09 (  6.16%)
Mean   2     7012.85 (  0.00%)     8052.16 ( 14.82%)
Mean   3     6403.04 (  0.00%)     6973.74 (  8.91%)
Mean   4     6135.32 (  0.00%)     6582.33 (  7.29%)
Mean   5     6095.69 (  0.00%)     6526.68 (  7.07%)
Mean   6     6114.33 (  0.00%)     6416.64 (  4.94%)
Mean   7     6085.10 (  0.00%)     6448.51 (  5.97%)
Mean   8     6120.62 (  0.00%)     6462.97 (  5.59%)

Ivybridge 8 threads
                     3.13.0-rc7            3.13.0-rc7
                        vanilla           altshift-v3
Mean   1      7336.65 (  0.00%)     7787.02 (  6.14%)
Mean   2      8218.41 (  0.00%)     9484.13 ( 15.40%)
Mean   3      7973.62 (  0.00%)     8922.01 ( 11.89%)
Mean   4      7798.33 (  0.00%)     8567.03 (  9.86%)
Mean   5      7158.72 (  0.00%)     8214.23 ( 14.74%)
Mean   6      6852.27 (  0.00%)     7952.45 ( 16.06%)
Mean   7      6774.65 (  0.00%)     7536.35 ( 11.24%)
Mean   8      6510.50 (  0.00%)     6894.05 (  5.89%)
Mean   12     6182.90 (  0.00%)     6661.29 (  7.74%)
Mean   16     6100.09 (  0.00%)     6608.69 (  8.34%)

Ebizzy hits the worst case scenario for TLB range flushing every time and
it shows for these Ivybridge CPUs at least that the default choice is a
poor on.  The patch addresses the problem.

Next was a tlbflush microbenchmark written by Alex Shi at
http://marc.info/?l=linux-kernel&m=133727348217113 .  It measures access
costs while the TLB is being flushed.  The expectation is that if there
are always full TLB flushes that the benchmark would suffer and it
benefits from range flushing

There are 320 iterations of the test per thread count.  The number of
entries is randomly selected with a min of 1 and max of 512.  To ensure a
reasonably even spread of entries, the full range is broken up into 8
sections and a random number selected within that section.

iteration 1, random number between 0-64
iteration 2, random number between 64-128 etc

This is still a very weak methodology.  When you do not know what are
typical ranges, random is a reasonable choice but it can be easily argued
that the opimisation was for smaller ranges and an even spread is not
representative of any workload that matters.  To improve this, we'd need
to know the probability distribution of TLB flush range sizes for a set of
workloads that are considered "common", build a synthetic trace and feed
that into this benchmark.  Even that is not perfect because it would not
account for the time between flushes but there are limits of what can be
reasonably done and still be doing something useful.  If a representative
synthetic trace is provided then this benchmark could be revisited and the
shift values retuned.

Ivybridge 4 threads
                        3.13.0-rc7            3.13.0-rc7
                           vanilla           altshift-v3
Mean       1       10.50 (  0.00%)       10.50 (  0.03%)
Mean       2       17.59 (  0.00%)       17.18 (  2.34%)
Mean       3       22.98 (  0.00%)       21.74 (  5.41%)
Mean       5       47.13 (  0.00%)       46.23 (  1.92%)
Mean       8       43.30 (  0.00%)       42.56 (  1.72%)

Ivybridge 8 threads
                         3.13.0-rc7            3.13.0-rc7
                            vanilla           altshift-v3
Mean       1         9.45 (  0.00%)        9.36 (  0.93%)
Mean       2         9.37 (  0.00%)        9.70 ( -3.54%)
Mean       3         9.36 (  0.00%)        9.29 (  0.70%)
Mean       5        14.49 (  0.00%)       15.04 ( -3.75%)
Mean       8        41.08 (  0.00%)       38.73 (  5.71%)
Mean       13       32.04 (  0.00%)       31.24 (  2.49%)
Mean       16       40.05 (  0.00%)       39.04 (  2.51%)

For both CPUs, average access time is reduced which is good as this is the
benchmark that was used to tune the shift values in the first place albeit
it is now known *how* the benchmark was used.

The scheduler benchmarks were somewhat inconclusive.  They showed gains
and losses and makes me reconsider how stable those benchmarks really are
or if something else might be interfering with the test results recently.

Network benchmarks were inconclusive.  Almost all results were flat except
for netperf-udp tests on the 4 thread machine.  These results were
unstable and showed large variations between reboots.  It is unknown if
this is a recent problems but I've noticed before that netperf-udp results
tend to vary.

Based on these results, changing the default for Ivybridge seems like a
logical choice.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Alex Shi <alex.shi@linaro.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H Peter Anvin <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/intel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kernel/cpu/intel.c~x86-mm-change-tlb_flushall_shift-for-ivybridge arch/x86/kernel/cpu/intel.c
--- a/arch/x86/kernel/cpu/intel.c~x86-mm-change-tlb_flushall_shift-for-ivybridge
+++ a/arch/x86/kernel/cpu/intel.c
@@ -628,7 +628,7 @@ static void intel_tlb_flushall_shift_set
 		tlb_flushall_shift = 5;
 		break;
 	case 0x63a: /* Ivybridge */
-		tlb_flushall_shift = 1;
+		tlb_flushall_shift = 2;
 		break;
 	default:
 		tlb_flushall_shift = 6;
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-remove-bug_on-from-mlock_vma_page.patch
x86-mm-account-for-tlb-flushes-only-when-debugging.patch
x86-mm-clean-up-inconsistencies-when-flushing-tlb-ranges.patch
x86-mm-eliminate-redundant-page-table-walk-during-tlb-range-flushing.patch
x86-mm-change-tlb_flushall_shift-for-ivybridge.patch
mm-x86-revisit-tlb_flushall_shift-tuning-for-page-flushes-except-on-ivybridge.patch
mm-hugetlbfs-add-some-vm_bug_ons-to-catch-non-hugetlbfs-pages.patch
mm-hugetlb-use-get_page_foll-in-follow_hugetlb_page.patch
mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path.patch
mm-thp-optimize-compound_trans_huge.patch
mm-tail-page-refcounting-optimization-for-slab-and-hugetlbfs.patch
mm-hugetlbfs-use-__compound_tail_refcounted-in-__get_page_tail-too.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-hugetlbc-defer-pageheadhuge-symbol-export.patch
mm-thp-__get_page_tail_foll-can-use-get_huge_page_tail.patch
mm-thp-turn-compound_head-into-bug_onpagetail-in-get_huge_page_tail.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch
mm-call-mmu-notifiers-when-copying-a-hugetlb-page-range.patch
mm-show_mem-remove-show_mem_filter_page_count.patch
mm-show_mem-remove-show_mem_filter_page_count-fix.patch
memblock-numa-introduce-flags-field-into-memblock.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions.patch
memblock-make-memblock_set_node-support-different-memblock_type.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock.patch
acpi-numa-mem_hotplug-mark-all-nodes-the-kernel-resides-un-hotpluggable.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed.patch
x86-numa-acpi-memory-hotplug-make-movable_node-have-higher-priority.patch
mm-rmap-recompute-pgoff-for-huge-page.patch
mm-rmap-factor-nonlinear-handling-out-of-try_to_unmap_file.patch
mm-rmap-factor-lock-function-out-of-rmap_walk_anon.patch
mm-rmap-make-rmap_walk-to-get-the-rmap_walk_control-argument.patch
mm-rmap-extend-rmap_walk_xxx-to-cope-with-different-cases.patch
mm-rmap-use-rmap_walk-in-try_to_unmap.patch
mm-rmap-use-rmap_walk-in-try_to_munlock.patch
mm-rmap-use-rmap_walk-in-page_referenced.patch
mm-rmap-use-rmap_walk-in-page_referenced-fix.patch
mm-rmap-use-rmap_walk-in-page_mkclean.patch
mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim.patch
mm-numa-make-numa-migrate-related-functions-static.patch
mm-numa-limit-scope-of-lock-for-numa-migrate-rate-limiting.patch
mm-numa-trace-tasks-that-fail-migration-due-to-rate-limiting.patch
mm-numa-do-not-automatically-migrate-ksm-pages.patch
sched-add-tracepoints-related-to-numa-task-migration.patch
sched-add-tracepoints-related-to-numa-task-migration-fix.patch
mm-compaction-trace-compaction-begin-and-end.patch
mm-compaction-encapsulate-defer-reset-logic.patch
mm-compaction-reset-cached-scanner-pfns-before-reading-them.patch
mm-compaction-detect-when-scanners-meet-in-isolate_freepages.patch
mm-compaction-do-not-mark-unmovable-pageblocks-as-skipped-in-async-compaction.patch
mm-compaction-reset-scanner-positions-immediately-when-they-meet.patch
mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure.patch
mm-migrate-add-comment-about-permanent-failure-path.patch
mm-migrate-correct-failure-handling-if-hugepage_migration_support.patch
mm-migrate-remove-putback_lru_pages-fix-comment-on-putback_movable_pages.patch
mm-migrate-remove-unused-function-fail_migrate_page.patch
mm-munlock-fix-potential-race-with-thp-page-split.patch
numa-add-a-sysctl-for-numa_balancing.patch
numa-add-a-sysctl-for-numa_balancing-fix.patch
linux-next.patch
mm-migratec-fix-set-cpupid-on-page-migration-twice-against-thp.patch
mm-migratec-fix-setting-of-cpupid-on-page-migration-twice-against-normal-page.patch
zsmalloc-move-it-under-mm.patch
zram-promote-zram-from-staging.patch

