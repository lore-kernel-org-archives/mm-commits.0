Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DB96C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5863A61208
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:45:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234362AbhKKCsj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:48:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:53632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234346AbhKKCsi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:48:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4BF861108;
        Thu, 11 Nov 2021 02:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598750;
        bh=wB6R/Gc0HuwhukGoiprRzQcIms31f8bVCpo6nD2E5hA=;
        h=Date:From:To:Subject:From;
        b=0cCAHzixYWOjNX0wrf1iwZy2KQlInP3vM85RjMwlchV51QqGjtRH+OLAmGPeTiTc9
         v3ex8YwhS6PabJ+lTCHcH+Xg3AgeZ2lCUD2MzHjtYzUldC6dP7kcbU8IY3699zDaOO
         uSzdpSZKvX8Zg0uBNKC+2De/wuopKKTWJK8fEOq0=
Date:   Wed, 10 Nov 2021 18:45:49 -0800
From:   akpm@linux-foundation.org
To:     adilger.kernel@dilger.ca, corbet@lwn.net, david@fromorbit.com,
        djwong@kernel.org, hannes@cmpxchg.org, mgorman@techsingularity.net,
        mhocko@suse.com, mm-commits@vger.kernel.org, neilb@suse.de,
        riel@surriel.com, tytso@mit.edu, vbabka@suse.cz,
        willy@infradead.org
Subject:  [merged]
 mm-page_alloc-remove-the-throttling-logic-from-the-page-allocator.patch
 removed from -mm tree
Message-ID: <20211111024549.aGzmzFapx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: remove the throttling logic from the page allocator
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-the-throttling-logic-from-the-page-allocator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: remove the throttling logic from the page allocator

The page allocator stalls based on the number of pages that are waiting
for writeback to start but this should now be redundant. 
shrink_inactive_list() will wake flusher threads if the LRU tail are
unqueued dirty pages so the flusher should be active.  If it fails to make
progress due to pages under writeback not being completed quickly then it
should stall on VMSCAN_THROTTLE_WRITEBACK.

Link: https://lkml.kernel.org/r/20211022144651.19914-6-mgorman@techsingularity.net
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

 mm/page_alloc.c |   21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-the-throttling-logic-from-the-page-allocator
+++ a/mm/page_alloc.c
@@ -4791,30 +4791,11 @@ should_reclaim_retry(gfp_t gfp_mask, uns
 		trace_reclaim_retry_zone(z, order, reclaimable,
 				available, min_wmark, *no_progress_loops, wmark);
 		if (wmark) {
-			/*
-			 * If we didn't make any progress and have a lot of
-			 * dirty + writeback pages then we should wait for
-			 * an IO to complete to slow down the reclaim and
-			 * prevent from pre mature OOM
-			 */
-			if (!did_some_progress) {
-				unsigned long write_pending;
-
-				write_pending = zone_page_state_snapshot(zone,
-							NR_ZONE_WRITE_PENDING);
-
-				if (2 * write_pending > reclaimable) {
-					congestion_wait(BLK_RW_ASYNC, HZ/10);
-					return true;
-				}
-			}
-
 			ret = true;
-			goto out;
+			break;
 		}
 	}
 
-out:
 	/*
 	 * Memory allocation/reclaim might be called from a WQ context and the
 	 * current implementation of the WQ concurrency control doesn't
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


