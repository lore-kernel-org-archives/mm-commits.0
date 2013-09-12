From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-fix-numa-reclaim-balance-problem-in-kswapd.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:42:55 -0700
Message-ID: <5232193f.dlWgNrwl6I5jJHnv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58060 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab3ILTm4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:42:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zcalusic@bitsync.net, riel@redhat.com, paul.bollee@gmail.com, mgorman@suse.de, aarcange@redhat.com, hannes@cmpxchg.org

Subject: [merged] mm-vmscan-fix-numa-reclaim-balance-problem-in-kswapd.patch removed from -mm tree
To: hannes@cmpxchg.org,aarcange@redhat.com,mgorman@suse.de,paul.bollee@gmail.com,riel@redhat.com,zcalusic@bitsync.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:42:55 -0700


The patch titled
     Subject: mm: vmscan: fix numa reclaim balance problem in kswapd
has been removed from the -mm tree.  Its filename was
     mm-vmscan-fix-numa-reclaim-balance-problem-in-kswapd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmscan: fix numa reclaim balance problem in kswapd

The way the page allocator interacts with kswapd creates aging imbalances,
where the amount of time a userspace page gets in memory under reclaim
pressure is dependent on which zone, which node the allocator took the
page frame from.

#1 fixes missed kswapd wakeups on NUMA systems, which lead to some
   nodes falling behind for a full reclaim cycle relative to the other
   nodes in the system

#3 fixes an interaction where kswapd and a continuous stream of page
   allocations keep the preferred zone of a task between the high and
   low watermark (allocations succeed + kswapd does not go to sleep)
   indefinitely, completely underutilizing the lower zones and
   thrashing on the preferred zone

These patches are the aging fairness part of the thrash-detection based
file LRU balancing.  Andrea recommended to submit them separately as they
are bugfixes in their own right.

The following test ran a foreground workload (memcachetest) with
background IO of various sizes on a 4 node 8G system (similar results were
observed with single-node 4G systems):

parallelio
                                               BAS                    FAIRALLO
                                              BASE                   FAIRALLOC
Ops memcachetest-0M              5170.00 (  0.00%)           5283.00 (  2.19%)
Ops memcachetest-791M            4740.00 (  0.00%)           5293.00 ( 11.67%)
Ops memcachetest-2639M           2551.00 (  0.00%)           4950.00 ( 94.04%)
Ops memcachetest-4487M           2606.00 (  0.00%)           3922.00 ( 50.50%)
Ops io-duration-0M                  0.00 (  0.00%)              0.00 (  0.00%)
Ops io-duration-791M               55.00 (  0.00%)             18.00 ( 67.27%)
Ops io-duration-2639M             235.00 (  0.00%)            103.00 ( 56.17%)
Ops io-duration-4487M             278.00 (  0.00%)            173.00 ( 37.77%)
Ops swaptotal-0M                    0.00 (  0.00%)              0.00 (  0.00%)
Ops swaptotal-791M             245184.00 (  0.00%)              0.00 (  0.00%)
Ops swaptotal-2639M            468069.00 (  0.00%)         108778.00 ( 76.76%)
Ops swaptotal-4487M            452529.00 (  0.00%)          76623.00 ( 83.07%)
Ops swapin-0M                       0.00 (  0.00%)              0.00 (  0.00%)
Ops swapin-791M                108297.00 (  0.00%)              0.00 (  0.00%)
Ops swapin-2639M               169537.00 (  0.00%)          50031.00 ( 70.49%)
Ops swapin-4487M               167435.00 (  0.00%)          34178.00 ( 79.59%)
Ops minorfaults-0M            1518666.00 (  0.00%)        1503993.00 (  0.97%)
Ops minorfaults-791M          1676963.00 (  0.00%)        1520115.00 (  9.35%)
Ops minorfaults-2639M         1606035.00 (  0.00%)        1799717.00 (-12.06%)
Ops minorfaults-4487M         1612118.00 (  0.00%)        1583825.00 (  1.76%)
Ops majorfaults-0M                  6.00 (  0.00%)              0.00 (  0.00%)
Ops majorfaults-791M            13836.00 (  0.00%)             10.00 ( 99.93%)
Ops majorfaults-2639M           22307.00 (  0.00%)           6490.00 ( 70.91%)
Ops majorfaults-4487M           21631.00 (  0.00%)           4380.00 ( 79.75%)

                 BAS    FAIRALLO
                BASE   FAIRALLOC
User          287.78      460.97
System       2151.67     3142.51
Elapsed      9737.00     8879.34

                                   BAS    FAIRALLO
                                  BASE   FAIRALLOC
Minor Faults                  53721925    57188551
Major Faults                    392195       15157
Swap Ins                       2994854      112770
Swap Outs                      4907092      134982
Direct pages scanned                 0       41824
Kswapd pages scanned          32975063     8128269
Kswapd pages reclaimed         6323069     7093495
Direct pages reclaimed               0       41824
Kswapd efficiency                  19%         87%
Kswapd velocity               3386.573     915.414
Direct efficiency                 100%        100%
Direct velocity                  0.000       4.710
Percentage direct scans             0%          0%
Zone normal velocity          2011.338     550.661
Zone dma32 velocity           1365.623     369.221
Zone dma velocity                9.612       0.242
Page writes by reclaim    18732404.000  614807.000
Page writes file              13825312      479825
Page writes anon               4907092      134982
Page reclaim immediate           85490        5647
Sector Reads                  12080532      483244
Sector Writes                 88740508    65438876
Page rescued immediate               0           0
Slabs scanned                    82560       12160
Direct inode steals                  0           0
Kswapd inode steals              24401       40013
Kswapd skipped wait                  0           0
THP fault alloc                      6           8
THP collapse alloc                5481        5812
THP splits                          75          22
THP fault fallback                   0           0
THP collapse fail                    0           0
Compaction stalls                    0          54
Compaction success                   0          45
Compaction failures                  0           9
Page migrate success            881492       82278
Page migrate failure                 0           0
Compaction pages isolated            0       60334
Compaction migrate scanned           0       53505
Compaction free scanned              0     1537605
Compaction cost                    914          86
NUMA PTE updates              46738231    41988419
NUMA hint faults              31175564    24213387
NUMA hint local faults        10427393     6411593
NUMA pages migrated             881492       55344
AutoNUMA cost                   156221      121361

The overall runtime was reduced, throughput for both the foreground
workload as well as the background IO improved, major faults, swapping and
reclaim activity shrunk significantly, reclaim efficiency more than
quadrupled.



This patch:

When the page allocator fails to get a page from all zones in its given
zonelist, it wakes up the per-node kswapds for all zones that are at their
low watermark.

However, with a system under load the free pages in a zone can fluctuate
enough that the allocation fails but the kswapd wakeup is also skipped
while the zone is still really close to the low watermark.

When one node misses a wakeup like this, it won't be aged before all the
other node's zones are down to their low watermarks again.  And skipping a
full aging cycle is an obvious fairness problem.

Kswapd runs until the high watermarks are restored, so it should also be
woken when the high watermarks are not met.  This ages nodes more equally
and creates a safety margin for the page counter fluctuation.

By using zone_balanced(), it will now check, in addition to the watermark,
if compaction requires more order-0 pages to create a higher order page.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Paul Bolle <paul.bollee@gmail.com>
Tested-by: Zlatko Calusic <zcalusic@bitsync.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-vmscan-fix-numa-reclaim-balance-problem-in-kswapd mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-fix-numa-reclaim-balance-problem-in-kswapd
+++ a/mm/vmscan.c
@@ -3237,7 +3237,7 @@ void wakeup_kswapd(struct zone *zone, in
 	}
 	if (!waitqueue_active(&pgdat->kswapd_wait))
 		return;
-	if (zone_watermark_ok_safe(zone, order, low_wmark_pages(zone), 0, 0))
+	if (zone_balanced(zone, order, 0, 0))
 		return;
 
 	trace_mm_vmscan_wakeup_kswapd(pgdat->node_id, zone_idx(zone), order);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
memcg-remove-redundant-code-in-mem_cgroup_force_empty_write.patch
memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
memcg-get-rid-of-soft-limit-tree-infrastructure.patch
vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
memcg-enhance-memcg-iterator-to-support-predicates.patch
memcg-enhance-memcg-iterator-to-support-predicates-fix.patch
memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch
memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
memcg-track-all-children-over-limit-in-the-root.patch
memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
arch-mm-remove-obsolete-init-oom-protection.patch
arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom.patch
arch-mm-pass-userspace-fault-flag-to-generic-fault-handler.patch
x86-finish-user-fault-error-path-with-fatal-signal.patch
mm-memcg-enable-memcg-oom-killer-only-for-user-faults.patch
mm-memcg-rework-and-document-oom-waiting-and-wakeup.patch
mm-memcg-do-not-trap-chargers-with-full-callstack-on-oom.patch
memcg-remove-memcg_nr_file_mapped.patch
memcg-check-for-proper-lock-held-in-mem_cgroup_update_page_stat.patch
memcg-add-per-cgroup-writeback-pages-accounting.patch
memcg-document-cgroup-dirty-writeback-memory-statistics.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch

