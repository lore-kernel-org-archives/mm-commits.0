From: akpm@linux-foundation.org
Subject: [alternative-merged]
 mm-compaction-adapt-isolation_suitable-flushing-to-kcompactd.patch removed
 from -mm tree
Date: Wed, 09 Mar 2016 10:58:42 -0800
Message-ID: <56e07262.fs6jnsZx5XoB7AvW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39067 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326AbcCIS6n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Mar 2016 13:58:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, aarcange@redhat.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@suse.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: adapt isolation_suitable flushing to kcompactd
has been removed from the -mm tree.  Its filename was
     mm-compaction-adapt-isolation_suitable-flushing-to-kcompactd.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: adapt isolation_suitable flushing to kcompactd

Compaction maintains a pageblock_skip bitmap to record pageblocks where
isolation recently failed.  This bitmap can be reset by three ways:

1) direct compaction is restarting after going through the full deferred cycle

2) kswapd goes to sleep, and some other direct compaction has previously
    finished scanning the whole zone and set zone->compact_blockskip_flush.
    Note that a successful direct compaction clears this flag.

3) compaction was invoked manually via trigger in /proc

The case 2) is somewhat fuzzy to begin with, but after introducing
kcompactd we should update it.  The check for direct compaction in 1), and
to set the flush flag in 2) use current_is_kswapd(), which doesn't work
for kcompactd.  Thus, this patch adds bool direct_compaction to
compact_control to use in 2).  For the case 1) we remove the check
completely - unlike the former kswapd compaction, kcompactd does use the
deferred compaction functionality, so flushing tied to restarting from
deferred compaction makes sense here.

Note that when kswapd goes to sleep, kcompactd is woken up, so it will see
the flushed pageblock_skip bits.  This is different from when the former
kswapd compaction observed the bits and I believe it makes more sense. 
Kcompactd can afford to be more thorough than a direct compaction trying
to limit allocation latency, or kswapd whose primary goal is to reclaim.

To sum up, after this patch, the pageblock_skip flushing makes intuitively
more sense for kcompactd.  Practially, the differences are minimal. 
Stress-highalloc With order-9 allocations without direct
reclaim/compaction:

stress-highalloc
                        4.5-rc1+before         4.5-rc1+after
                             -nodirect             -nodirect
Success 1 Min          3.00 (  0.00%)        5.00 (-66.67%)
Success 1 Mean         4.00 (  0.00%)        6.20 (-55.00%)
Success 1 Max          6.00 (  0.00%)        7.00 (-16.67%)
Success 2 Min          3.00 (  0.00%)        5.00 (-66.67%)
Success 2 Mean         4.20 (  0.00%)        6.40 (-52.38%)
Success 2 Max          6.00 (  0.00%)        7.00 (-16.67%)
Success 3 Min         63.00 (  0.00%)       62.00 (  1.59%)
Success 3 Mean        64.60 (  0.00%)       63.80 (  1.24%)
Success 3 Max         67.00 (  0.00%)       65.00 (  2.99%)

User                          3088.82       3181.09
System                        1142.01       1158.25
Elapsed                       1780.91       1799.37

                            4.5-rc1+before  4.5-rc1+after
                                 -nodirect   -nodirect
Direct pages scanned                31429       32797
Kswapd pages scanned              2185293     2202613
Kswapd pages reclaimed            2134389     2143524
Direct pages reclaimed              31234       32545
Percentage direct scans                1%          1%
THP fault alloc                       614         612
THP collapse alloc                    324         316
THP splits                              0           0
THP fault fallback                    730         778
THP collapse fail                      14          16
Compaction stalls                     959        1007
Compaction success                     69          67
Compaction failures                   890         939
Page migrate success               662054      721374
Page migrate failure                32846       23469
Compaction pages isolated         1370326     1479924
Compaction migrate scanned        7025772     8812554
Compaction free scanned          73302642    84327916
Compaction cost                       762         838

With direct reclaim/compaction:

stress-highalloc
                        4.5-rc1+before         4.5-rc1+after
                               -direct               -direct
Success 1 Min          6.00 (  0.00%)        9.00 (-50.00%)
Success 1 Mean         8.40 (  0.00%)       10.00 (-19.05%)
Success 1 Max         13.00 (  0.00%)       11.00 ( 15.38%)
Success 2 Min          6.00 (  0.00%)        9.00 (-50.00%)
Success 2 Mean         8.60 (  0.00%)       10.00 (-16.28%)
Success 2 Max         12.00 (  0.00%)       11.00 (  8.33%)
Success 3 Min         75.00 (  0.00%)       74.00 (  1.33%)
Success 3 Mean        75.60 (  0.00%)       75.20 (  0.53%)
Success 3 Max         76.00 (  0.00%)       76.00 (  0.00%)

User                          3258.62       3246.04
System                        1177.92       1172.29
Elapsed                       1837.02       1836.76

                            4.5-rc1+before  4.5-rc1+after
                                   -direct     -direct
Direct pages scanned               108854      120966
Kswapd pages scanned              2131589     2135012
Kswapd pages reclaimed            2090937     2108388
Direct pages reclaimed             108699      120577
Percentage direct scans                4%          5%
THP fault alloc                       567         652
THP collapse alloc                    326         354
THP splits                              0           0
THP fault fallback                    805         793
THP collapse fail                      18          16
Compaction stalls                    2070        2025
Compaction success                    527         518
Compaction failures                  1543        1507
Page migrate success              2423657     2360608
Page migrate failure                28790       40852
Compaction pages isolated         4916017     4802025
Compaction migrate scanned       19370264    21750613
Compaction free scanned         360662356   344372001
Compaction cost                      2745        2694

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   10 +++++-----
 mm/internal.h   |    1 +
 2 files changed, 6 insertions(+), 5 deletions(-)

diff -puN mm/compaction.c~mm-compaction-adapt-isolation_suitable-flushing-to-kcompactd mm/compaction.c
--- a/mm/compaction.c~mm-compaction-adapt-isolation_suitable-flushing-to-kcompactd
+++ a/mm/compaction.c
@@ -1191,11 +1191,11 @@ static int __compact_finished(struct zon
 
 		/*
 		 * Mark that the PG_migrate_skip information should be cleared
-		 * by kswapd when it goes to sleep. kswapd does not set the
+		 * by kswapd when it goes to sleep. kcompactd does not set the
 		 * flag itself as the decision to be clear should be directly
 		 * based on an allocation request.
 		 */
-		if (!current_is_kswapd())
+		if (cc->direct_compaction)
 			zone->compact_blockskip_flush = true;
 
 		return COMPACT_COMPLETE;
@@ -1338,10 +1338,9 @@ static int compact_zone(struct zone *zon
 
 	/*
 	 * Clear pageblock skip if there were failures recently and compaction
-	 * is about to be retried after being deferred. kswapd does not do
-	 * this reset as it'll reset the cached information when going to sleep.
+	 * is about to be retried after being deferred.
 	 */
-	if (compaction_restarting(zone, cc->order) && !current_is_kswapd())
+	if (compaction_restarting(zone, cc->order))
 		__reset_isolation_suitable(zone);
 
 	/*
@@ -1477,6 +1476,7 @@ static unsigned long compact_zone_order(
 		.mode = mode,
 		.alloc_flags = alloc_flags,
 		.classzone_idx = classzone_idx,
+		.direct_compaction = true,
 	};
 	INIT_LIST_HEAD(&cc.freepages);
 	INIT_LIST_HEAD(&cc.migratepages);
diff -puN mm/internal.h~mm-compaction-adapt-isolation_suitable-flushing-to-kcompactd mm/internal.h
--- a/mm/internal.h~mm-compaction-adapt-isolation_suitable-flushing-to-kcompactd
+++ a/mm/internal.h
@@ -177,6 +177,7 @@ struct compact_control {
 	unsigned long last_migrated_pfn;/* Not yet flushed page being freed */
 	enum migrate_mode mode;		/* Async or sync migration mode */
 	bool ignore_skip_hint;		/* Scan blocks even if marked skip */
+	bool direct_compaction;		/* False from kcompactd or /proc/... */
 	int order;			/* order a direct compactor needs */
 	const gfp_t gfp_mask;		/* gfp mask of a direct compactor */
 	const int alloc_flags;		/* alloc flags of a direct compactor */
_

Patches currently in -mm which might be from vbabka@suse.cz are

tracepoints-move-trace_print_flags-definitions-to-tracepoint-defsh.patch
mm-tracing-make-show_gfp_flags-up-to-date.patch
tools-perf-make-gfp_compact_table-up-to-date.patch
mm-tracing-unify-mm-flags-handling-in-tracepoints-and-printk.patch
mm-printk-introduce-new-format-string-for-flags.patch
mm-printk-introduce-new-format-string-for-flags-fix.patch
mm-debug-replace-dump_flags-with-the-new-printk-formats.patch
mm-page_alloc-print-symbolic-gfp_flags-on-allocation-failure.patch
mm-oom-print-symbolic-gfp_flags-in-oom-warning.patch
mm-page_owner-print-migratetype-of-page-and-pageblock-symbolic-flags.patch
mm-page_owner-convert-page_owner_inited-to-static-key.patch
mm-page_owner-copy-page-owner-info-during-migration.patch
mm-page_owner-track-and-print-last-migrate-reason.patch
mm-page_owner-dump-page-owner-info-from-dump_page.patch
mm-debug-move-bad-flags-printing-to-bad_page.patch
mm-slb-print-gfp_flags-as-strings-in-slab_out_of_memory.patch
mm-kswapd-remove-bogus-check-of-balance_classzone_idx.patch
mm-compaction-introduce-kcompactd.patch
mm-compaction-introduce-kcompactd-fix-3.patch
mm-memory-hotplug-small-cleanup-in-online_pages.patch
mm-tracing-refresh-__def_vmaflag_names-fix.patch
mm-use-radix_tree_iter_retry-fix.patch

