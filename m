Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6F6AC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 19:25:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFFA9610FF
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 19:25:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234141AbhJVT2J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 22 Oct 2021 15:28:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:44196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233564AbhJVT2H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 22 Oct 2021 15:28:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6A34610D0;
        Fri, 22 Oct 2021 19:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634930749;
        bh=TmHZRkx5+3u81/VOUOYNFiU9jHrb627iESBpspjTBO8=;
        h=Date:From:To:Subject:From;
        b=yHsENeLWa5SQ95le2qE2SLjowB+V9JLAu2rFJEG8UNQZPg4pEGNqgZWK1avkA9A2l
         THsgnxb6vLVTSM9aw7U0hYEMTI9EiLk6g3sROErkgadlW2JI8dQK9kAdrNK8PR+PCM
         fKvc9R/J700GGfD6M0yVSemc42ty38pKa8qSPn8Y=
Date:   Fri, 22 Oct 2021 12:25:48 -0700
From:   akpm@linux-foundation.org
To:     adilger.kernel@dilger.ca, corbet@lwn.net, david@fromorbit.com,
        djwong@kernel.org, hannes@cmpxchg.org, mgorman@techsingularity.net,
        mhocko@suse.com, mm-commits@vger.kernel.org, neilb@suse.de,
        riel@surriel.com, tytso@mit.edu, vbabka@suse.cz,
        willy@infradead.org
Subject:  +
 mm-writeback-throttle-based-on-page-writeback-instead-of-congestion.patch
 added to -mm tree
Message-ID: <20211022192548.VnlY1L6lm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/writeback: throttle based on page writeback instead of congestion
has been added to the -mm tree.  Its filename is
     mm-writeback-throttle-based-on-page-writeback-instead-of-congestion.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-writeback-throttle-based-on-page-writeback-instead-of-congestion.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-writeback-throttle-based-on-page-writeback-instead-of-congestion.patch

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

mm-vmscan-throttle-reclaim-until-some-writeback-completes-if-congested.patch
mm-vmscan-throttle-reclaim-and-compaction-when-too-may-pages-are-isolated.patch
mm-vmscan-throttle-reclaim-when-no-progress-is-being-made.patch
mm-writeback-throttle-based-on-page-writeback-instead-of-congestion.patch
mm-page_alloc-remove-the-throttling-logic-from-the-page-allocator.patch
mm-vmscan-centralise-timeout-values-for-reclaim_throttle.patch
mm-vmscan-increase-the-timeout-if-page-reclaim-is-not-making-progress.patch
mm-vmscan-delay-waking-of-tasks-throttled-on-noprogress.patch

