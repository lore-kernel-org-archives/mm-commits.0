Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 686C0C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:45:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AD4761284
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:45:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234354AbhKKCsf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:48:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:53588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234355AbhKKCsf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:48:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AEA56103C;
        Thu, 11 Nov 2021 02:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598747;
        bh=W4NG4ct9Vh1DSVgWQJGTM8FQ8SJLoWHiNbscFPNNJC4=;
        h=Date:From:To:Subject:From;
        b=cXYhp8C10aFmhGILvXW958iqpWEqS1FNz81hoPt06Mn7MxmxxQ1RorrjKfRf2aIv1
         xrBpaW5Dju94AvM/KRbMbHbjFZlna0wUZS4UmPEOD3lnWiakPixy/TjIb8ZLf+Epns
         mec50CQkbcn0dMHuy15LdNbNAY1DWQElhjVOBHdg=
Date:   Wed, 10 Nov 2021 18:45:46 -0800
From:   akpm@linux-foundation.org
To:     adilger.kernel@dilger.ca, corbet@lwn.net, david@fromorbit.com,
        djwong@kernel.org, hannes@cmpxchg.org, mgorman@techsingularity.net,
        mhocko@suse.com, mm-commits@vger.kernel.org, neilb@suse.de,
        riel@surriel.com, tytso@mit.edu, vbabka@suse.cz,
        willy@infradead.org
Subject:  [merged]
 mm-writeback-throttle-based-on-page-writeback-instead-of-congestion.patch
 removed from -mm tree
Message-ID: <20211111024546.WUZoc68-X%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/writeback: throttle based on page writeback instead of congestion
has been removed from the -mm tree.  Its filename was
     mm-writeback-throttle-based-on-page-writeback-instead-of-congestion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from mgorman@techsingularity.net are


