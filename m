Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D58BC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 19:25:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 746DF610EA
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 19:25:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233939AbhJVT2M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 22 Oct 2021 15:28:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233564AbhJVT2M (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 22 Oct 2021 15:28:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BE5F6109D;
        Fri, 22 Oct 2021 19:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634930754;
        bh=m2Abjc2eE9ymd4lBgr20bGG1kY8uNIvbpvTqSlGYCGI=;
        h=Date:From:To:Subject:From;
        b=TlLfiem/pIM4Jyek4c503c+j4p+hM1Qt/PCkVQePBsQqMF6DK73FN3Ut0gXXV+KKV
         WzwU4EVfmuP2dVqoPG3KpmBtENlEqYX3o80IutoMAuyTI8n/RZ7hC2Qov2lKz7ZhyG
         QYpmFOloIzm4bOjA8+A7jHRlPJnYyrZsFP7Elmx8=
Date:   Fri, 22 Oct 2021 12:25:53 -0700
From:   akpm@linux-foundation.org
To:     adilger.kernel@dilger.ca, corbet@lwn.net, david@fromorbit.com,
        djwong@kernel.org, hannes@cmpxchg.org, mgorman@techsingularity.net,
        mhocko@suse.com, mm-commits@vger.kernel.org, neilb@suse.de,
        riel@surriel.com, tytso@mit.edu, vbabka@suse.cz,
        willy@infradead.org
Subject:  +
 mm-vmscan-centralise-timeout-values-for-reclaim_throttle.patch added to -mm
 tree
Message-ID: <20211022192553.6P-Pt7PUH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: centralise timeout values for reclaim_throttle
has been added to the -mm tree.  Its filename is
     mm-vmscan-centralise-timeout-values-for-reclaim_throttle.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-centralise-timeout-values-for-reclaim_throttle.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-centralise-timeout-values-for-reclaim_throttle.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2325,7 +2349,7 @@ shrink_inactive_list(unsigned long nr_to
 
 		/* wait a bit for the reclaimer. */
 		stalled = true;
-		reclaim_throttle(pgdat, VMSCAN_THROTTLE_ISOLATED, HZ/10);
+		reclaim_throttle(pgdat, VMSCAN_THROTTLE_ISOLATED);
 
 		/* We are about to die and free our memory. Return now. */
 		if (fatal_signal_pending(current))
@@ -3257,7 +3281,7 @@ again:
 		 * until some pages complete writeback.
 		 */
 		if (sc->nr.immediate)
-			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK, HZ/10);
+			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
 	}
 
 	/*
@@ -3281,7 +3305,7 @@ again:
 	if (!current_is_kswapd() && current_may_throttle() &&
 	    !sc->hibernation_mode &&
 	    test_bit(LRUVEC_CONGESTED, &target_lruvec->flags))
-		reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK, HZ/10);
+		reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
 
 	if (should_continue_reclaim(pgdat, sc->nr_reclaimed - nr_reclaimed,
 				    sc))
@@ -3353,7 +3377,7 @@ static void consider_reclaim_throttle(pg
 
 	/* Throttle if making no progress at high prioities. */
 	if (sc->priority < DEF_PRIORITY - 2)
-		reclaim_throttle(pgdat, VMSCAN_THROTTLE_NOPROGRESS, HZ/10);
+		reclaim_throttle(pgdat, VMSCAN_THROTTLE_NOPROGRESS);
 }
 
 /*
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-vmscan-throttle-reclaim-until-some-writeback-completes-if-congested.patch
mm-vmscan-throttle-reclaim-and-compaction-when-too-may-pages-are-isolated.patch
mm-vmscan-throttle-reclaim-when-no-progress-is-being-made.patch
mm-writeback-throttle-based-on-page-writeback-instead-of-congestion.patch
mm-page_alloc-remove-the-throttling-logic-from-the-page-allocator.patch
mm-vmscan-centralise-timeout-values-for-reclaim_throttle.patch
mm-vmscan-increase-the-timeout-if-page-reclaim-is-not-making-progress.patch
mm-vmscan-delay-waking-of-tasks-throttled-on-noprogress.patch

