From: akpm@linux-foundation.org
Subject: + mm-compaction-trace-compaction-begin-and-end.patch added to -mm tree
Date: Wed, 11 Dec 2013 15:43:07 -0800
Message-ID: <52a8f88b.0dXqTuDx6XGudHYp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50454 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab3LKXnI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Dec 2013 18:43:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, riel@redhat.com, iamjoonsoo.kim@lge.com, mgorman@suse.de

Subject: + mm-compaction-trace-compaction-begin-and-end.patch added to -mm tree
To: mgorman@suse.de,iamjoonsoo.kim@lge.com,riel@redhat.com,vbabka@suse.cz
From: akpm@linux-foundation.org
Date: Wed, 11 Dec 2013 15:43:07 -0800


The patch titled
     Subject: mm: compaction: trace compaction begin and end
has been added to the -mm tree.  Its filename is
     mm-compaction-trace-compaction-begin-and-end.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-trace-compaction-begin-and-end.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-trace-compaction-begin-and-end.patch

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
Subject: mm: compaction: trace compaction begin and end

The broad goal of the series is to improve allocation success rates for
huge pages through memory compaction, while trying not to increase the
compaction overhead.  The original objective was to reintroduce capturing
of high-order pages freed by the compaction, before they are split by
concurrent activity.  However, several bugs and opportunities for simple
improvements were found in the current implementation, mostly through
extra tracepoints (which are however too ugly for now to be considered for
sending).

The patches mostly deal with two mechanisms that reduce compaction
overhead, which is caching the progress of migrate and free scanners, and
marking pageblocks where isolation failed to be skipped during further
scans.

Patch 1 (from mgorman) adds tracepoints that allow calculate time spent in
        compaction and potentially debug scanner pfn values.

Patch 2 encapsulates the some functionality for handling deferred compactions
        for better maintainability, without a functional change
        type is not determined without being actually needed.

Patch 3 fixes a bug where cached scanner pfn's are sometimes reset only after
        they have been read to initialize a compaction run.

Patch 4 fixes a bug where scanners meeting is sometimes not properly detected
        and can lead to multiple compaction attempts quitting early without
        doing any work.

Patch 5 improves the chances of sync compaction to process pageblocks that
        async compaction has skipped due to being !MIGRATE_MOVABLE.

Patch 6 improves the chances of sync direct compaction to actually do anything
        when called after async compaction fails during allocation slowpath.

The impact of patches were validated using mmtests's stress-highalloc
benchmark with mmtests's stress-highalloc benchmark on a x86_64 machine
with 4GB memory.

Due to instability of the results (mostly related to the bugs fixed by
patches 2 and 3), 10 iterations were performed, taking min,mean,max values
for success rates and mean values for time and vmstat-based metrics.

First, the default GFP_HIGHUSER_MOVABLE allocations were tested with the
patches stacked on top of v3.13-rc2.  Patch 2 is OK to serve as baseline
due to no functional changes in 1 and 2.  Comments below.

stress-highalloc
                             3.13-rc2              3.13-rc2              3.13-rc2              3.13-rc2              3.13-rc2
                              2-nothp               3-nothp               4-nothp               5-nothp               6-nothp
Success 1 Min          9.00 (  0.00%)       10.00 (-11.11%)       43.00 (-377.78%)       43.00 (-377.78%)       33.00 (-266.67%)
Success 1 Mean        27.50 (  0.00%)       25.30 (  8.00%)       45.50 (-65.45%)       45.90 (-66.91%)       46.30 (-68.36%)
Success 1 Max         36.00 (  0.00%)       36.00 (  0.00%)       47.00 (-30.56%)       48.00 (-33.33%)       52.00 (-44.44%)
Success 2 Min         10.00 (  0.00%)        8.00 ( 20.00%)       46.00 (-360.00%)       45.00 (-350.00%)       35.00 (-250.00%)
Success 2 Mean        26.40 (  0.00%)       23.50 ( 10.98%)       47.30 (-79.17%)       47.60 (-80.30%)       48.10 (-82.20%)
Success 2 Max         34.00 (  0.00%)       33.00 (  2.94%)       48.00 (-41.18%)       50.00 (-47.06%)       54.00 (-58.82%)
Success 3 Min         65.00 (  0.00%)       63.00 (  3.08%)       85.00 (-30.77%)       84.00 (-29.23%)       85.00 (-30.77%)
Success 3 Mean        76.70 (  0.00%)       70.50 (  8.08%)       86.20 (-12.39%)       85.50 (-11.47%)       86.00 (-12.13%)
Success 3 Max         87.00 (  0.00%)       86.00 (  1.15%)       88.00 ( -1.15%)       87.00 (  0.00%)       87.00 (  0.00%)

            3.13-rc2    3.13-rc2    3.13-rc2    3.13-rc2    3.13-rc2
             2-nothp     3-nothp     4-nothp     5-nothp     6-nothp
User         6437.72     6459.76     5960.32     5974.55     6019.67
System       1049.65     1049.09     1029.32     1031.47     1032.31
Elapsed      1856.77     1874.48     1949.97     1994.22     1983.15

                              3.13-rc2    3.13-rc2    3.13-rc2    3.13-rc2    3.13-rc2
                               2-nothp     3-nothp     4-nothp     5-nothp     6-nothp
Minor Faults                 253952267   254581900   250030122   250507333   250157829
Major Faults                       420         407         506         530         530
Swap Ins                             4           9           9           6           6
Swap Outs                          398         375         345         346         333
Direct pages scanned            197538      189017      298574      287019      299063
Kswapd pages scanned           1809843     1801308     1846674     1873184     1861089
Kswapd pages reclaimed         1806972     1798684     1844219     1870509     1858622
Direct pages reclaimed          197227      188829      298380      286822      298835
Kswapd efficiency                  99%         99%         99%         99%         99%
Kswapd velocity                953.382     970.449     952.243     934.569     922.286
Direct efficiency                  99%         99%         99%         99%         99%
Direct velocity                104.058     101.832     153.961     143.200     148.205
Percentage direct scans             9%          9%         13%         13%         13%
Zone normal velocity           347.289     359.676     348.063     339.933     332.983
Zone dma32 velocity            710.151     712.605     758.140     737.835     737.507
Zone dma velocity                0.000       0.000       0.000       0.000       0.000
Page writes by reclaim         557.600     429.000     353.600     426.400     381.800
Page writes file                   159          53           7          79          48
Page writes anon                   398         375         345         346         333
Page reclaim immediate             825         644         411         575         420
Sector Reads                   2781750     2769780     2878547     2939128     2910483
Sector Writes                 12080843    12083351    12012892    12002132    12010745
Page rescued immediate               0           0           0           0           0
Slabs scanned                  1575654     1545344     1778406     1786700     1794073
Direct inode steals               9657       10037       15795       14104       14645
Kswapd inode steals              46857       46335       50543       50716       51796
Kswapd skipped wait                  0           0           0           0           0
THP fault alloc                     97          91          81          71          77
THP collapse alloc                 456         506         546         544         565
THP splits                           6           5           5           4           4
THP fault fallback                   0           1           0           0           0
THP collapse fail                   14          14          12          13          12
Compaction stalls                 1006         980        1537        1536        1548
Compaction success                 303         284         562         559         578
Compaction failures                702         696         974         976         969
Page migrate success           1177325     1070077     3927538     3781870     3877057
Page migrate failure                 0           0           0           0           0
Compaction pages isolated      2547248     2306457     8301218     8008500     8200674
Compaction migrate scanned    42290478    38832618   153961130   154143900   159141197
Compaction free scanned       89199429    79189151   356529027   351943166   356326727
Compaction cost                   1566        1426        5312        5156        5294
NUMA PTE updates                     0           0           0           0           0
NUMA hint faults                     0           0           0           0           0
NUMA hint local faults               0           0           0           0           0
NUMA hint local percent            100         100         100         100         100
NUMA pages migrated                  0           0           0           0           0
AutoNUMA cost                        0           0           0           0           0


Observations:

- The "Success 3" line is allocation success rate with system idle
  (phases 1 and 2 are with background interference).  I used to get stable
  values around 85% with vanilla 3.11.  The lower min and mean values came
  with 3.12.  This was bisected to commit 81c0a2bb ("mm: page_alloc: fair
  zone allocator policy") As explained in comment for patch 3, I don't
  think the commit is wrong, but that it makes the effect of compaction
  bugs worse.  From patch 3 onwards, the results are OK and match the 3.11
  results.

- Patch 4 also clearly helps phases 1 and 2, and exceeds any results
  I've seen with 3.11 (I didn't measure it that thoroughly then, but it
  was never above 40%).

- Compaction cost and number of scanned pages is higher, especially due
  to patch 4.  However, keep in mind that patches 3 and 4 fix existing
  bugs in the current design of compaction overhead mitigation, they do
  not change it.  If overhead is found unacceptable, then it should be
  decreased differently (and consistently, not due to random conditions)
  than the current implementation does.  In contrast, patches 5 and 6
  (which are not strictly bug fixes) do not increase the overhead (but
  also not success rates).  This might be a limitation of the
  stress-highalloc benchmark as it's quite uniform.

Another set of results is when configuring stress-highalloc t allocate
with similar flags as THP uses:
 (GFP_HIGHUSER_MOVABLE|__GFP_NOMEMALLOC|__GFP_NORETRY|__GFP_NO_KSWAPD)

stress-highalloc
                             3.13-rc2              3.13-rc2              3.13-rc2              3.13-rc2              3.13-rc2
                                2-thp                 3-thp                 4-thp                 5-thp                 6-thp
Success 1 Min          2.00 (  0.00%)        7.00 (-250.00%)       18.00 (-800.00%)       19.00 (-850.00%)       26.00 (-1200.00%)
Success 1 Mean        19.20 (  0.00%)       17.80 (  7.29%)       29.20 (-52.08%)       29.90 (-55.73%)       32.80 (-70.83%)
Success 1 Max         27.00 (  0.00%)       29.00 ( -7.41%)       35.00 (-29.63%)       36.00 (-33.33%)       37.00 (-37.04%)
Success 2 Min          3.00 (  0.00%)        8.00 (-166.67%)       21.00 (-600.00%)       21.00 (-600.00%)       32.00 (-966.67%)
Success 2 Mean        19.30 (  0.00%)       17.90 (  7.25%)       32.20 (-66.84%)       32.60 (-68.91%)       35.70 (-84.97%)
Success 2 Max         27.00 (  0.00%)       30.00 (-11.11%)       36.00 (-33.33%)       37.00 (-37.04%)       39.00 (-44.44%)
Success 3 Min         62.00 (  0.00%)       62.00 (  0.00%)       85.00 (-37.10%)       75.00 (-20.97%)       64.00 ( -3.23%)
Success 3 Mean        66.30 (  0.00%)       65.50 (  1.21%)       85.60 (-29.11%)       83.40 (-25.79%)       83.50 (-25.94%)
Success 3 Max         70.00 (  0.00%)       69.00 (  1.43%)       87.00 (-24.29%)       86.00 (-22.86%)       87.00 (-24.29%)

            3.13-rc2    3.13-rc2    3.13-rc2    3.13-rc2    3.13-rc2
               2-thp       3-thp       4-thp       5-thp       6-thp
User         6547.93     6475.85     6265.54     6289.46     6189.96
System       1053.42     1047.28     1043.23     1042.73     1038.73
Elapsed      1835.43     1821.96     1908.67     1912.74     1956.38

                              3.13-rc2    3.13-rc2    3.13-rc2    3.13-rc2    3.13-rc2
                                 2-thp       3-thp       4-thp       5-thp       6-thp
Minor Faults                 256805673   253106328   253222299   249830289   251184418
Major Faults                       395         375         423         434         448
Swap Ins                            12          10          10          12           9
Swap Outs                          530         537         487         455         415
Direct pages scanned             71859       86046      153244      152764      190713
Kswapd pages scanned           1900994     1870240     1898012     1892864     1880520
Kswapd pages reclaimed         1897814     1867428     1894939     1890125     1877924
Direct pages reclaimed           71766       85908      153167      152643      190600
Kswapd efficiency                  99%         99%         99%         99%         99%
Kswapd velocity               1029.000    1067.782    1000.091     991.049     951.218
Direct efficiency                  99%         99%         99%         99%         99%
Direct velocity                 38.897      49.127      80.747      79.983      96.468
Percentage direct scans             3%          4%          7%          7%          9%
Zone normal velocity           351.377     372.494     348.910     341.689     335.310
Zone dma32 velocity            716.520     744.414     731.928     729.343     712.377
Zone dma velocity                0.000       0.000       0.000       0.000       0.000
Page writes by reclaim         669.300     604.000     545.700     538.900     429.900
Page writes file                   138          66          58          83          14
Page writes anon                   530         537         487         455         415
Page reclaim immediate             806         655         772         548         517
Sector Reads                   2711956     2703239     2811602     2818248     2839459
Sector Writes                 12163238    12018662    12038248    11954736    11994892
Page rescued immediate               0           0           0           0           0
Slabs scanned                  1385088     1388364     1507968     1513292     1558656
Direct inode steals               1739        2564        4622        5496        6007
Kswapd inode steals              47461       46406       47804       48013       48466
Kswapd skipped wait                  0           0           0           0           0
THP fault alloc                    110          82          84          69          70
THP collapse alloc                 445         482         467         462         539
THP splits                           6           5           4           5           3
THP fault fallback                   3           0           0           0           0
THP collapse fail                   15          14          14          14          13
Compaction stalls                  659         685        1033        1073        1111
Compaction success                 222         225         410         427         456
Compaction failures                436         460         622         646         655
Page migrate success            446594      439978     1085640     1095062     1131716
Page migrate failure                 0           0           0           0           0
Compaction pages isolated      1029475     1013490     2453074     2482698     2565400
Compaction migrate scanned     9955461    11344259    24375202    27978356    30494204
Compaction free scanned       27715272    28544654    80150615    82898631    85756132
Compaction cost                    552         555        1344        1379        1436
NUMA PTE updates                     0           0           0           0           0
NUMA hint faults                     0           0           0           0           0
NUMA hint local faults               0           0           0           0           0
NUMA hint local percent            100         100         100         100         100
NUMA pages migrated                  0           0           0           0           0
AutoNUMA cost                        0           0           0           0           0

There are some differences from the previous results for THP-like allocations:

- Here, the bad result for unpatched kernel in phase 3 is much more
  consistent to be between 65-70% and not related to the "regression" in
  3.12.  Still there is the improvement from patch 4 onwards, which brings
  it on par with simple GFP_HIGHUSER_MOVABLE allocations.

- Compaction costs have increased, but nowhere near as much as the
  non-THP case.  Again, the patches should be worth the gained
  determininsm.

- Patches 5 and 6 somewhat increase the number of migrate-scanned pages.
   This is most likely due to __GFP_NO_KSWAPD flag, which means the cached
  pfn's and pageblock skip bits are not reset by kswapd that often (at
  least in phase 3 where no concurrent activity would wake up kswapd) and
  the patches thus help the sync-after-async compaction.  It doesn't
  however show that the sync compaction would help so much with success
  rates, which can be again seen as a limitation of the benchmark
  scenario.




This patch (of 6):

Add two tracepoints for compaction begin and end of a zone.  Using this it
is possible to calculate how much time a workload is spending within
compaction and potentially debug problems related to cached pfns for
scanning.  In combination with the direct reclaim and slab trace points it
should be possible to estimate most allocation-related overhead for a
workload.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/compaction.h |   42 ++++++++++++++++++++++++++++
 mm/compaction.c                   |    4 ++
 2 files changed, 46 insertions(+)

diff -puN include/trace/events/compaction.h~mm-compaction-trace-compaction-begin-and-end include/trace/events/compaction.h
--- a/include/trace/events/compaction.h~mm-compaction-trace-compaction-begin-and-end
+++ a/include/trace/events/compaction.h
@@ -67,6 +67,48 @@ TRACE_EVENT(mm_compaction_migratepages,
 		__entry->nr_failed)
 );
 
+TRACE_EVENT(mm_compaction_begin,
+	TP_PROTO(unsigned long zone_start, unsigned long migrate_start,
+		unsigned long free_start, unsigned long zone_end),
+
+	TP_ARGS(zone_start, migrate_start, free_start, zone_end),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, zone_start)
+		__field(unsigned long, migrate_start)
+		__field(unsigned long, free_start)
+		__field(unsigned long, zone_end)
+	),
+
+	TP_fast_assign(
+		__entry->zone_start = zone_start;
+		__entry->migrate_start = migrate_start;
+		__entry->free_start = free_start;
+		__entry->zone_end = zone_end;
+	),
+
+	TP_printk("zone_start=%lu migrate_start=%lu free_start=%lu zone_end=%lu",
+		__entry->zone_start,
+		__entry->migrate_start,
+		__entry->free_start,
+		__entry->zone_end)
+);
+
+TRACE_EVENT(mm_compaction_end,
+	TP_PROTO(int status),
+
+	TP_ARGS(status),
+
+	TP_STRUCT__entry(
+		__field(int, status)
+	),
+
+	TP_fast_assign(
+		__entry->status = status;
+	),
+
+	TP_printk("status=%d", __entry->status)
+);
 
 #endif /* _TRACE_COMPACTION_H */
 
diff -puN mm/compaction.c~mm-compaction-trace-compaction-begin-and-end mm/compaction.c
--- a/mm/compaction.c~mm-compaction-trace-compaction-begin-and-end
+++ a/mm/compaction.c
@@ -966,6 +966,8 @@ static int compact_zone(struct zone *zon
 	if (compaction_restarting(zone, cc->order) && !current_is_kswapd())
 		__reset_isolation_suitable(zone);
 
+	trace_mm_compaction_begin(start_pfn, cc->migrate_pfn, cc->free_pfn, end_pfn);
+
 	migrate_prep_local();
 
 	while ((ret = compact_finished(zone, cc)) == COMPACT_CONTINUE) {
@@ -1011,6 +1013,8 @@ out:
 	cc->nr_freepages -= release_freepages(&cc->freepages);
 	VM_BUG_ON(cc->nr_freepages != 0);
 
+	trace_mm_compaction_end(ret);
+
 	return ret;
 }
 
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-numa-serialise-parallel-get_user_page-against-thp-migration.patch
mm-numa-call-mmu-notifiers-on-thp-migration.patch
mm-clear-pmd_numa-before-invalidating.patch
mm-numa-do-not-clear-pmd-during-pte-update-scan.patch
mm-numa-do-not-clear-pte-for-pte_numa-update.patch
mm-numa-ensure-anon_vma-is-locked-to-prevent-parallel-thp-splits.patch
mm-numa-avoid-unnecessary-work-on-the-failure-path.patch
sched-numa-skip-inaccessible-vmas.patch
mm-numa-clear-numa-hinting-information-on-mprotect.patch
mm-numa-avoid-unnecessary-disruption-of-numa-hinting-during-migration.patch
mm-fix-tlb-flush-race-between-migration-and-change_protection_range.patch
mm-fix-tlb-flush-race-between-migration-and-change_protection_range-fix.patch
mm-numa-guarantee-that-tlb_flush_pending-updates-are-visible-before-page-table-updates.patch
mm-numa-defer-tlb-flush-for-thp-migration-as-long-as-possible.patch
mm-page_alloc-exclude-unreclaimable-allocations-from-zone-fairness-policy.patch
mm-hugetlbfs-add-some-vm_bug_ons-to-catch-non-hugetlbfs-pages.patch
mm-hugetlb-use-get_page_foll-in-follow_hugetlb_page.patch
mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path.patch
mm-thp-optimize-compound_trans_huge.patch
mm-tail-page-refcounting-optimization-for-slab-and-hugetlbfs.patch
mm-hugetlbfs-use-__compound_tail_refcounted-in-__get_page_tail-too.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-hugetlbc-defer-pageheadhuge-symbol-export.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch
mm-call-mmu-notifiers-when-copying-a-hugetlb-page-range.patch
mm-show_mem-remove-show_mem_filter_page_count.patch
x86-get-pg_data_ts-memory-from-other-node.patch
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
linux-next.patch

