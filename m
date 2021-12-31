Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92785C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 31 Dec 2021 21:07:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231778AbhLaVHU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 31 Dec 2021 16:07:20 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:32992 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231782AbhLaVHU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 31 Dec 2021 16:07:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCD2B61827
        for <mm-commits@vger.kernel.org>; Fri, 31 Dec 2021 21:07:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE75EC36AEA;
        Fri, 31 Dec 2021 21:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640984839;
        bh=IolvMSuA69W9h5EJf00OPoPlcipq56SdCMNxLoWpwbg=;
        h=Date:From:To:Subject:From;
        b=h85GEmWE/IlrVOPBy2QL5+BL8NQCInRVRsuB2dg57fAqxkdzad9eKSgUepjPddPl5
         hLRhK+BSCVtP+cEYeBPGgYn1x2W7inZzCbmEt71TwJy3CfZV08Mi7Ak9aabSzbGCIs
         tG/73ggDsykyqb4xwgHro9QD82ngqu5GeZkLEgoA=
Date:   Fri, 31 Dec 2021 13:07:18 -0800
From:   akpm@linux-foundation.org
To:     djwong@kernel.org, efault@gmx.de, hakavlad@inbox.lv,
        hughd@google.com, lkp@intel.com, mgorman@techsingularity.net,
        mhocko@suse.com, mm-commits@vger.kernel.org, riel@surriel.com,
        shakeelb@google.com, vbabka@suse.cz
Subject:  [merged]
 mm-vmscan-reduce-throttling-due-to-a-failure-to-make-progress.patch removed
 from -mm tree
Message-ID: <20211231210718.-Vxta2vPe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: reduce throttling due to a failure to make progress
has been removed from the -mm tree.  Its filename was
     mm-vmscan-reduce-throttling-due-to-a-failure-to-make-progress.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm: vmscan: reduce throttling due to a failure to make progress

Mike Galbraith, Alexey Avramov and Darrick Wong all reported similar
problems due to reclaim throttling for excessive lengths of time.  In
Alexey's case, a memory hog that should go OOM quickly stalls for several
minutes before stalling.  In Mike and Darrick's cases, a small memcg
environment stalled excessively even though the system had enough memory
overall.

Commit 69392a403f49 ("mm/vmscan: throttle reclaim when no progress is
being made") introduced the problem although commit a19594ca4a8b
("mm/vmscan: increase the timeout if page reclaim is not making progress")
made it worse.  Systems at or near an OOM state that cannot be recovered
must reach OOM quickly and memcg should kill tasks if a memcg is near OOM.

To address this, only stall for the first zone in the zonelist, reduce the
timeout to 1 tick for VMSCAN_THROTTLE_NOPROGRESS and only stall if the
scan control nr_reclaimed is 0, kswapd is still active and there were
excessive pages pending for writeback.  If kswapd has stopped reclaiming
due to excessive failures, do not stall at all so that OOM triggers
relatively quickly.  Similarly, if an LRU is simply congested, only
lightly throttle similar to NOPROGRESS.

Alexey's original case was the most straight forward

	for i in {1..3}; do tail /dev/zero; done

On vanilla 5.16-rc1, this test stalled heavily, after the patch the test
completes in a few seconds similar to 5.15.

Alexey's second test case added watching a youtube video while tail runs
10 times.  On 5.15, playback only jitters slightly, 5.16-rc1 stalls a lot
with lots of frames missing and numerous audio glitches.  With this patch
applies, the video plays similarly to 5.15.

Link: https://lore.kernel.org/r/99e779783d6c7fce96448a3402061b9dc1b3b602.camel@gmx.de
Link: https://lore.kernel.org/r/20211124011954.7cab9bb4@mail.inbox.lv
Link: https://lore.kernel.org/r/20211022144651.19914-1-mgorman@techsingularity.net

[lkp@intel.com: Fix W=1 build warning]
Fixes: 69392a403f49 ("mm/vmscan: throttle reclaim when no progress is being made")
Link: https://lkml.kernel.org/r/20211202150614.22440-1-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reported-by: kernel test robot <lkp@intel.com>
Reported-and-tested-by: Alexey Avramov <hakavlad@inbox.lv>
Reported-and-tested-by: Mike Galbraith <efault@gmx.de>
Reported-and-tested-by: Darrick J. Wong <djwong@kernel.org>
Tested-by: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h        |    1 
 include/trace/events/vmscan.h |    4 +-
 mm/vmscan.c                   |   64 +++++++++++++++++++++++++++-----
 3 files changed, 59 insertions(+), 10 deletions(-)

--- a/include/linux/mmzone.h~mm-vmscan-reduce-throttling-due-to-a-failure-to-make-progress
+++ a/include/linux/mmzone.h
@@ -277,6 +277,7 @@ enum vmscan_throttle_state {
 	VMSCAN_THROTTLE_WRITEBACK,
 	VMSCAN_THROTTLE_ISOLATED,
 	VMSCAN_THROTTLE_NOPROGRESS,
+	VMSCAN_THROTTLE_CONGESTED,
 	NR_VMSCAN_THROTTLE,
 };
 
--- a/include/trace/events/vmscan.h~mm-vmscan-reduce-throttling-due-to-a-failure-to-make-progress
+++ a/include/trace/events/vmscan.h
@@ -30,12 +30,14 @@
 #define _VMSCAN_THROTTLE_WRITEBACK	(1 << VMSCAN_THROTTLE_WRITEBACK)
 #define _VMSCAN_THROTTLE_ISOLATED	(1 << VMSCAN_THROTTLE_ISOLATED)
 #define _VMSCAN_THROTTLE_NOPROGRESS	(1 << VMSCAN_THROTTLE_NOPROGRESS)
+#define _VMSCAN_THROTTLE_CONGESTED	(1 << VMSCAN_THROTTLE_CONGESTED)
 
 #define show_throttle_flags(flags)						\
 	(flags) ? __print_flags(flags, "|",					\
 		{_VMSCAN_THROTTLE_WRITEBACK,	"VMSCAN_THROTTLE_WRITEBACK"},	\
 		{_VMSCAN_THROTTLE_ISOLATED,	"VMSCAN_THROTTLE_ISOLATED"},	\
-		{_VMSCAN_THROTTLE_NOPROGRESS,	"VMSCAN_THROTTLE_NOPROGRESS"}	\
+		{_VMSCAN_THROTTLE_NOPROGRESS,	"VMSCAN_THROTTLE_NOPROGRESS"},	\
+		{_VMSCAN_THROTTLE_CONGESTED,	"VMSCAN_THROTTLE_CONGESTED"}	\
 		) : "VMSCAN_THROTTLE_NONE"
 
 
--- a/mm/vmscan.c~mm-vmscan-reduce-throttling-due-to-a-failure-to-make-progress
+++ a/mm/vmscan.c
@@ -1021,6 +1021,39 @@ static void handle_write_error(struct ad
 	unlock_page(page);
 }
 
+static bool skip_throttle_noprogress(pg_data_t *pgdat)
+{
+	int reclaimable = 0, write_pending = 0;
+	int i;
+
+	/*
+	 * If kswapd is disabled, reschedule if necessary but do not
+	 * throttle as the system is likely near OOM.
+	 */
+	if (pgdat->kswapd_failures >= MAX_RECLAIM_RETRIES)
+		return true;
+
+	/*
+	 * If there are a lot of dirty/writeback pages then do not
+	 * throttle as throttling will occur when the pages cycle
+	 * towards the end of the LRU if still under writeback.
+	 */
+	for (i = 0; i < MAX_NR_ZONES; i++) {
+		struct zone *zone = pgdat->node_zones + i;
+
+		if (!populated_zone(zone))
+			continue;
+
+		reclaimable += zone_reclaimable_pages(zone);
+		write_pending += zone_page_state_snapshot(zone,
+						  NR_ZONE_WRITE_PENDING);
+	}
+	if (2 * write_pending <= reclaimable)
+		return true;
+
+	return false;
+}
+
 void reclaim_throttle(pg_data_t *pgdat, enum vmscan_throttle_state reason)
 {
 	wait_queue_head_t *wqh = &pgdat->reclaim_wait[reason];
@@ -1056,8 +1089,16 @@ void reclaim_throttle(pg_data_t *pgdat,
 		}
 
 		break;
+	case VMSCAN_THROTTLE_CONGESTED:
+		fallthrough;
 	case VMSCAN_THROTTLE_NOPROGRESS:
-		timeout = HZ/2;
+		if (skip_throttle_noprogress(pgdat)) {
+			cond_resched();
+			return;
+		}
+
+		timeout = 1;
+
 		break;
 	case VMSCAN_THROTTLE_ISOLATED:
 		timeout = HZ/50;
@@ -3321,7 +3362,7 @@ again:
 	if (!current_is_kswapd() && current_may_throttle() &&
 	    !sc->hibernation_mode &&
 	    test_bit(LRUVEC_CONGESTED, &target_lruvec->flags))
-		reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
+		reclaim_throttle(pgdat, VMSCAN_THROTTLE_CONGESTED);
 
 	if (should_continue_reclaim(pgdat, sc->nr_reclaimed - nr_reclaimed,
 				    sc))
@@ -3386,16 +3427,16 @@ static void consider_reclaim_throttle(pg
 	}
 
 	/*
-	 * Do not throttle kswapd on NOPROGRESS as it will throttle on
-	 * VMSCAN_THROTTLE_WRITEBACK if there are too many pages under
-	 * writeback and marked for immediate reclaim at the tail of
-	 * the LRU.
+	 * Do not throttle kswapd or cgroup reclaim on NOPROGRESS as it will
+	 * throttle on VMSCAN_THROTTLE_WRITEBACK if there are too many pages
+	 * under writeback and marked for immediate reclaim at the tail of the
+	 * LRU.
 	 */
-	if (current_is_kswapd())
+	if (current_is_kswapd() || cgroup_reclaim(sc))
 		return;
 
 	/* Throttle if making no progress at high prioities. */
-	if (sc->priority < DEF_PRIORITY - 2)
+	if (sc->priority == 1 && !sc->nr_reclaimed)
 		reclaim_throttle(pgdat, VMSCAN_THROTTLE_NOPROGRESS);
 }
 
@@ -3415,6 +3456,7 @@ static void shrink_zones(struct zonelist
 	unsigned long nr_soft_scanned;
 	gfp_t orig_mask;
 	pg_data_t *last_pgdat = NULL;
+	pg_data_t *first_pgdat = NULL;
 
 	/*
 	 * If the number of buffer_heads in the machine exceeds the maximum
@@ -3478,14 +3520,18 @@ static void shrink_zones(struct zonelist
 			/* need some check for avoid more shrink_zone() */
 		}
 
+		if (!first_pgdat)
+			first_pgdat = zone->zone_pgdat;
+
 		/* See comment about same check for global reclaim above */
 		if (zone->zone_pgdat == last_pgdat)
 			continue;
 		last_pgdat = zone->zone_pgdat;
 		shrink_node(zone->zone_pgdat, sc);
-		consider_reclaim_throttle(zone->zone_pgdat, sc);
 	}
 
+	consider_reclaim_throttle(first_pgdat, sc);
+
 	/*
 	 * Restore to original mask to avoid the impact on the caller if we
 	 * promoted it to __GFP_HIGHMEM.
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-vmscan-reduce-throttling-due-to-a-failure-to-make-progress-fix.patch

