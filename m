Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9098C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:45:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2FEB6103C
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:45:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234355AbhKKCsm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:48:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:53672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234346AbhKKCsl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:48:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1D2461208;
        Thu, 11 Nov 2021 02:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598753;
        bh=O1drav0eM2L/J+cGhOqsFPJjJIgN7lxubhtxDHGpfI0=;
        h=Date:From:To:Subject:From;
        b=Eb20lHbINCx59ufpGkuOUIIhs0f4NOqjPaHtdgOI2+wLya2+CA09kYQ8Abx6l3iil
         JyuDiVYvp3mLisd9RJYKfYMf4unkZ52mU3am16+OD40Q41qsBYnv/gcaZUgQAWRQ7G
         +muxzz/jT820192DvpshCl88FX97+RP/vXSNBQ2U=
Date:   Wed, 10 Nov 2021 18:45:52 -0800
From:   akpm@linux-foundation.org
To:     adilger.kernel@dilger.ca, corbet@lwn.net, david@fromorbit.com,
        djwong@kernel.org, hannes@cmpxchg.org, mgorman@techsingularity.net,
        mhocko@suse.com, mm-commits@vger.kernel.org, neilb@suse.de,
        riel@surriel.com, tytso@mit.edu, vbabka@suse.cz,
        willy@infradead.org
Subject:  [merged]
 mm-vmscan-centralise-timeout-values-for-reclaim_throttle.patch removed from
 -mm tree
Message-ID: <20211111024552.fnsUHZ2n7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: centralise timeout values for reclaim_throttle
has been removed from the -mm tree.  Its filename was
     mm-vmscan-centralise-timeout-values-for-reclaim_throttle.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/vmscan: centralise timeout values for reclaim_throttle

Neil Brown raised concerns about callers of reclaim_throttle specifying a
timeout value.  The original timeout values to congestion_wait() were
probably pulled out of thin air or copy&pasted from somewhere else.  This
patch centralises the timeout values and selects a timeout based on the
reason for reclaim throttling.  These figures are also pulled out of the
same thin air but better values may be derived

Running a workload that is throttling for inappropriate periods and
tracing mm_vmscan_throttled can be used to pick a more appropriate value. 
Excessive throttling would pick a lower timeout where as excessive CPU
usage in reclaim context would select a larger timeout.  Ideally a large
value would always be used and the wakeups would occur before a timeout
but that requires careful testing.

Link: https://lkml.kernel.org/r/20211022144651.19914-7-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: "Darrick J . Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c     |    2 -
 mm/internal.h       |    3 --
 mm/page-writeback.c |    2 -
 mm/vmscan.c         |   50 +++++++++++++++++++++++++++++++-----------
 4 files changed, 40 insertions(+), 17 deletions(-)

--- a/mm/compaction.c~mm-vmscan-centralise-timeout-values-for-reclaim_throttle
+++ a/mm/compaction.c
@@ -828,7 +828,7 @@ isolate_migratepages_block(struct compac
 		if (cc->mode == MIGRATE_ASYNC)
 			return -EAGAIN;
 
-		reclaim_throttle(pgdat, VMSCAN_THROTTLE_ISOLATED, HZ/10);
+		reclaim_throttle(pgdat, VMSCAN_THROTTLE_ISOLATED);
 
 		if (fatal_signal_pending(current))
 			return -EINTR;
--- a/mm/internal.h~mm-vmscan-centralise-timeout-values-for-reclaim_throttle
+++ a/mm/internal.h
@@ -130,8 +130,7 @@ extern unsigned long highest_memmap_pfn;
  */
 extern int isolate_lru_page(struct page *page);
 extern void putback_lru_page(struct page *page);
-extern void reclaim_throttle(pg_data_t *pgdat, enum vmscan_throttle_state reason,
-								long timeout);
+extern void reclaim_throttle(pg_data_t *pgdat, enum vmscan_throttle_state reason);
 
 /*
  * in mm/rmap.c:
--- a/mm/page-writeback.c~mm-vmscan-centralise-timeout-values-for-reclaim_throttle
+++ a/mm/page-writeback.c
@@ -2374,7 +2374,7 @@ int do_writepages(struct address_space *
 		 * guess as any.
 		 */
 		reclaim_throttle(NODE_DATA(numa_node_id()),
-			VMSCAN_THROTTLE_WRITEBACK, HZ/50);
+			VMSCAN_THROTTLE_WRITEBACK);
 	}
 	/*
 	 * Usually few pages are written by now from those we've just submitted
--- a/mm/vmscan.c~mm-vmscan-centralise-timeout-values-for-reclaim_throttle
+++ a/mm/vmscan.c
@@ -1006,12 +1006,10 @@ static void handle_write_error(struct ad
 	unlock_page(page);
 }
 
-void reclaim_throttle(pg_data_t *pgdat, enum vmscan_throttle_state reason,
-							long timeout)
+void reclaim_throttle(pg_data_t *pgdat, enum vmscan_throttle_state reason)
 {
 	wait_queue_head_t *wqh = &pgdat->reclaim_wait[reason];
-	long ret;
-	bool acct_writeback = (reason == VMSCAN_THROTTLE_WRITEBACK);
+	long timeout, ret;
 	DEFINE_WAIT(wait);
 
 	/*
@@ -1023,17 +1021,43 @@ void reclaim_throttle(pg_data_t *pgdat,
 	    current->flags & (PF_IO_WORKER|PF_KTHREAD))
 		return;
 
-	if (acct_writeback &&
-	    atomic_inc_return(&pgdat->nr_writeback_throttled) == 1) {
-		WRITE_ONCE(pgdat->nr_reclaim_start,
-			node_page_state(pgdat, NR_THROTTLED_WRITTEN));
+	/*
+	 * These figures are pulled out of thin air.
+	 * VMSCAN_THROTTLE_ISOLATED is a transient condition based on too many
+	 * parallel reclaimers which is a short-lived event so the timeout is
+	 * short. Failing to make progress or waiting on writeback are
+	 * potentially long-lived events so use a longer timeout. This is shaky
+	 * logic as a failure to make progress could be due to anything from
+	 * writeback to a slow device to excessive references pages at the tail
+	 * of the inactive LRU.
+	 */
+	switch(reason) {
+	case VMSCAN_THROTTLE_WRITEBACK:
+		timeout = HZ/10;
+
+		if (atomic_inc_return(&pgdat->nr_writeback_throttled) == 1) {
+			WRITE_ONCE(pgdat->nr_reclaim_start,
+				node_page_state(pgdat, NR_THROTTLED_WRITTEN));
+		}
+
+		break;
+	case VMSCAN_THROTTLE_NOPROGRESS:
+		timeout = HZ/10;
+		break;
+	case VMSCAN_THROTTLE_ISOLATED:
+		timeout = HZ/50;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		timeout = HZ;
+		break;
 	}
 
 	prepare_to_wait(wqh, &wait, TASK_UNINTERRUPTIBLE);
 	ret = schedule_timeout(timeout);
 	finish_wait(wqh, &wait);
 
-	if (acct_writeback)
+	if (reason == VMSCAN_THROTTLE_WRITEBACK)
 		atomic_dec(&pgdat->nr_writeback_throttled);
 
 	trace_mm_vmscan_throttled(pgdat->node_id, jiffies_to_usecs(timeout),
@@ -2318,7 +2342,7 @@ shrink_inactive_list(unsigned long nr_to
 
 		/* wait a bit for the reclaimer. */
 		stalled = true;
-		reclaim_throttle(pgdat, VMSCAN_THROTTLE_ISOLATED, HZ/10);
+		reclaim_throttle(pgdat, VMSCAN_THROTTLE_ISOLATED);
 
 		/* We are about to die and free our memory. Return now. */
 		if (fatal_signal_pending(current))
@@ -3250,7 +3274,7 @@ again:
 		 * until some pages complete writeback.
 		 */
 		if (sc->nr.immediate)
-			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK, HZ/10);
+			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
 	}
 
 	/*
@@ -3274,7 +3298,7 @@ again:
 	if (!current_is_kswapd() && current_may_throttle() &&
 	    !sc->hibernation_mode &&
 	    test_bit(LRUVEC_CONGESTED, &target_lruvec->flags))
-		reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK, HZ/10);
+		reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
 
 	if (should_continue_reclaim(pgdat, sc->nr_reclaimed - nr_reclaimed,
 				    sc))
@@ -3346,7 +3370,7 @@ static void consider_reclaim_throttle(pg
 
 	/* Throttle if making no progress at high prioities. */
 	if (sc->priority < DEF_PRIORITY - 2)
-		reclaim_throttle(pgdat, VMSCAN_THROTTLE_NOPROGRESS, HZ/10);
+		reclaim_throttle(pgdat, VMSCAN_THROTTLE_NOPROGRESS);
 }
 
 /*
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


