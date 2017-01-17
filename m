From: akpm@linux-foundation.org
Subject: + mm-vmscan-consider-eligible-zones-in-get_scan_count.patch added to -mm tree
Date: Tue, 17 Jan 2017 13:18:02 -0800
Message-ID: <587e8a0a.xyQgx27hM8UcwuIL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40582 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751186AbdAQVSD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2017 16:18:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, mgorman@suse.de, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: consider eligible zones in get_scan_count
has been added to the -mm tree.  Its filename is
     mm-vmscan-consider-eligible-zones-in-get_scan_count.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-consider-eligible-zones-in-get_scan_count.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-consider-eligible-zones-in-get_scan_count.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, vmscan: consider eligible zones in get_scan_count

get_scan_count() considers the whole node LRU size when

- doing SCAN_FILE due to many page cache inactive pages
- calculating the number of pages to scan

In both cases this might lead to unexpected behavior especially on 32b
systems where we can expect lowmem memory pressure very often.

A large highmem zone can easily distort SCAN_FILE heuristic because there
might be only few file pages from the eligible zones on the node lru and
we would still enforce file lru scanning which can lead to trashing while
we could still scan anonymous pages.

The later use of lruvec_lru_size can be problematic as well.  Especially
when there are not many pages from the eligible zones.  We would have to
skip over many pages to find anything to reclaim but shrink_node_memcg
would only reduce the remaining number to scan by SWAP_CLUSTER_MAX at
maximum.  Therefore we can end up going over a large LRU many times
without actually having chance to reclaim much if anything at all.  The
closer we are out of memory on lowmem zone the worse the problem will be.

Fix this by filtering out all the ineligible zones when calculating the
lru size for both paths and consider only sc->reclaim_idx zones.

Link: http://lkml.kernel.org/r/20170117103702.28542-3-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-consider-eligible-zones-in-get_scan_count mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-consider-eligible-zones-in-get_scan_count
+++ a/mm/vmscan.c
@@ -2233,7 +2233,7 @@ static void get_scan_count(struct lruvec
 	 * system is under heavy pressure.
 	 */
 	if (!inactive_list_is_low(lruvec, true, sc, false) &&
-	    lruvec_lru_size(lruvec, LRU_INACTIVE_FILE, MAX_NR_ZONES) >> sc->priority) {
+	    lruvec_lru_size(lruvec, LRU_INACTIVE_FILE, sc->reclaim_idx) >> sc->priority) {
 		scan_balance = SCAN_FILE;
 		goto out;
 	}
@@ -2300,7 +2300,7 @@ out:
 			unsigned long size;
 			unsigned long scan;
 
-			size = lruvec_lru_size(lruvec, lru, MAX_NR_ZONES);
+			size = lruvec_lru_size(lruvec, lru, sc->reclaim_idx);
 			scan = size >> sc->priority;
 
 			if (!scan && pass && force_scan)
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-throttle-show_mem-from-warn_alloc.patch
mm-trace-extract-compaction_status-and-zone_type-to-a-common-header.patch
oom-trace-add-oom-detection-tracepoints.patch
oom-trace-add-compaction-retry-tracepoint.patch
mm-vmscan-remove-unused-mm_vmscan_memcg_isolate.patch
mm-vmscan-add-active-list-aging-tracepoint.patch
mm-vmscan-add-active-list-aging-tracepoint-update.patch
mm-vmscan-show-the-number-of-skipped-pages-in-mm_vmscan_lru_isolate.patch
mm-vmscan-show-lru-name-in-mm_vmscan_lru_isolate-tracepoint.patch
mm-vmscan-extract-shrink_page_list-reclaim-counters-into-a-struct.patch
mm-vmscan-enhance-mm_vmscan_lru_shrink_inactive-tracepoint.patch
mm-vmscan-add-mm_vmscan_inactive_list_is_low-tracepoint.patch
trace-vmscan-postprocess-sync-with-tracepoints-updates.patch
mm-vmscan-do-not-count-freed-pages-as-pgdeactivate.patch
mm-vmscan-cleanup-lru-size-claculations.patch
mm-vmscan-consider-eligible-zones-in-get_scan_count.patch
revert-mm-bail-out-in-shrink_inactive_list.patch

