Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FD59C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:42:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D1F36126A
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:42:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233688AbhKEUp3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:45:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:40106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233055AbhKEUpT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:45:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58F956124F;
        Fri,  5 Nov 2021 20:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144959;
        bh=b6483NYSqR3dKYJJj84fbe6Ur/a/+uYhb4Hz8lG2ymI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=HwD5rm9Qd6o28YSqqHLnwKhP4SsLGPlmuQB5wuaLGU9LmJowMfPBnjQowgmUDg4y5
         d1pIiLB0h9oFILdNse1zC3vw8Z1wJJayu4CYj6yYh+c+IUwQINH1MaqDQrh2gGSXls
         bcF4fRN3Y3Y81cSstEdtlDzgc8tDUx3Tevb+x10w=
Date:   Fri, 05 Nov 2021 13:42:38 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adilger.kernel@dilger.ca, akpm@linux-foundation.org,
        corbet@lwn.net, david@fromorbit.com, djwong@kernel.org,
        hannes@cmpxchg.org, linux-mm@kvack.org,
        mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, neilb@suse.de, riel@surriel.com,
        torvalds@linux-foundation.org, tytso@mit.edu, vbabka@suse.cz,
        willy@infradead.org
Subject:  [patch 153/262] mm/page_alloc: remove the throttling
 logic from the page allocator
Message-ID: <20211105204238.5PGt0tLHK%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
