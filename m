From: akpm@linux-foundation.org
Subject: [merged] vmscan-add-block-plug-for-page-reclaim.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:08:06 -0700
Message-ID: <201111012108.pA1L86Np015875@hpaq5.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:28550 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab1KAVIN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:08:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohua.li@intel.com, axboe@kernel.dk, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan: add block plug for page reclaim
has been removed from the -mm tree.  Its filename was
     vmscan-add-block-plug-for-page-reclaim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Shaohua Li <shaohua.li@intel.com>
Subject: vmscan: add block plug for page reclaim

per-task block plug can reduce block queue lock contention and increase
request merge.  Currently page reclaim doesn't support it.  I originally
thought page reclaim doesn't need it, because kswapd thread count is
limited and file cache write is done at flusher mostly.

When I test a workload with heavy swap in a 4-node machine, each CPU is
doing direct page reclaim and swap.  This causes block queue lock
contention.  In my test, without below patch, the CPU utilization is about
2% ~ 7%.  With the patch, the CPU utilization is about 1% ~ 3%.  Disk
throughput isn't changed.  This should improve normal kswapd write and
file cache write too (increase request merge for example), but might not
be so obvious as I explain above.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/vmscan.c~vmscan-add-block-plug-for-page-reclaim mm/vmscan.c
--- a/mm/vmscan.c~vmscan-add-block-plug-for-page-reclaim
+++ a/mm/vmscan.c
@@ -2005,12 +2005,14 @@ static void shrink_zone(int priority, st
 	enum lru_list l;
 	unsigned long nr_reclaimed, nr_scanned;
 	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
+	struct blk_plug plug;
 
 restart:
 	nr_reclaimed = 0;
 	nr_scanned = sc->nr_scanned;
 	get_scan_count(zone, sc, nr, priority);
 
+	blk_start_plug(&plug);
 	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
 					nr[LRU_INACTIVE_FILE]) {
 		for_each_evictable_lru(l) {
@@ -2034,6 +2036,7 @@ restart:
 		if (nr_reclaimed >= nr_to_reclaim && priority < DEF_PRIORITY)
 			break;
 	}
+	blk_finish_plug(&plug);
 	sc->nr_reclaimed += nr_reclaimed;
 
 	/*
_

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
linux-next.patch
x86-tlb-flush-avoid-superflous-leave_mm.patch
block-avoid-unnecessary-plug-list-flush.patch
block-add-missed-trace_block_plug.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
intel_idle-fix-api-misuse.patch
intel_idle-disable-auto_demotion-for-hotplugged-cpus.patch

