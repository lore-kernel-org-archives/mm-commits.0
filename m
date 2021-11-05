Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18D74C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:42:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 037C561284
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:42:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233521AbhKEUp3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:45:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:40046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233716AbhKEUpR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:45:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0338161244;
        Fri,  5 Nov 2021 20:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144956;
        bh=9XDyNz+ALPkfGq63s6Ydkx70208Aq7xhLnT620tqUcU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=RCjDvp3JZ9a26sWX6vS+Gxz056PN2jFC57lfIHmxJjqFCqsaHofn3H4Zds/j23kQt
         S0T4ffFn6EtaoiSfB2SlaL7+oI2u1E4z84O2XECt2dRCnE9oduU9yPKvXR78k2qM0t
         ouxvIB5hAwvhZwONyfYN1FO8EN4CZPZ4Vpn0YZhU=
Date:   Fri, 05 Nov 2021 13:42:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adilger.kernel@dilger.ca, akpm@linux-foundation.org,
        corbet@lwn.net, david@fromorbit.com, djwong@kernel.org,
        hannes@cmpxchg.org, linux-mm@kvack.org,
        mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, neilb@suse.de, riel@surriel.com,
        torvalds@linux-foundation.org, tytso@mit.edu, vbabka@suse.cz,
        willy@infradead.org
Subject:  [patch 152/262] mm/writeback: throttle based on page
 writeback instead of congestion
Message-ID: <20211105204235.GNTkEv6QI%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/writeback: throttle based on page writeback instead of congestion

do_writepages throttles on congestion if the writepages() fails due to a
lack of memory but congestion_wait() is partially broken as the congestion
state is not updated for all BDIs.

This patch stalls waiting for a number of pages to complete writeback that
located on the local node.  The main weakness is that there is no
correlation between the location of the inode's pages and locality but
that is still better than congestion_wait.

Link: https://lkml.kernel.org/r/20211022144651.19914-5-mgorman@techsingularity.net
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

 mm/page-writeback.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/mm/page-writeback.c~mm-writeback-throttle-based-on-page-writeback-instead-of-congestion
+++ a/mm/page-writeback.c
@@ -2366,8 +2366,15 @@ int do_writepages(struct address_space *
 			ret = generic_writepages(mapping, wbc);
 		if ((ret != -ENOMEM) || (wbc->sync_mode != WB_SYNC_ALL))
 			break;
-		cond_resched();
-		congestion_wait(BLK_RW_ASYNC, HZ/50);
+
+		/*
+		 * Lacking an allocation context or the locality or writeback
+		 * state of any of the inode's pages, throttle based on
+		 * writeback activity on the local node. It's as good a
+		 * guess as any.
+		 */
+		reclaim_throttle(NODE_DATA(numa_node_id()),
+			VMSCAN_THROTTLE_WRITEBACK, HZ/50);
 	}
 	/*
 	 * Usually few pages are written by now from those we've just submitted
_
