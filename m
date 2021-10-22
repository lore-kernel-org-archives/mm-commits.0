Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAAA7C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 19:25:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CA7D610FF
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 19:25:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234061AbhJVT2P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 22 Oct 2021 15:28:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:44364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233564AbhJVT2P (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 22 Oct 2021 15:28:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B432610D0;
        Fri, 22 Oct 2021 19:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634930757;
        bh=1hU2FUqhCxp4HIhd+GY4rRJqbrMOQZF8OO8AtJvTVmA=;
        h=Date:From:To:Subject:From;
        b=qZVKS0Akwur9926i6NVwS6uktoRp+kblirUk8G+E1aFVVxN7xsrNOB6Z68rH3xUVk
         bp2sFaqW3jhAqdMz0gkAx1xax+86u+H19Jv15+/CUqYt7OxHBJhYQux4W7R8zXBJ/3
         iM17uN06KwA5N1KyDi3DQG+PxyckCWCp+hQ6DA+A=
Date:   Fri, 22 Oct 2021 12:25:56 -0700
From:   akpm@linux-foundation.org
To:     adilger.kernel@dilger.ca, corbet@lwn.net, david@fromorbit.com,
        djwong@kernel.org, hannes@cmpxchg.org, mgorman@techsingularity.net,
        mhocko@suse.com, mm-commits@vger.kernel.org, neilb@suse.de,
        riel@surriel.com, tytso@mit.edu, vbabka@suse.cz,
        willy@infradead.org
Subject:  +
 mm-vmscan-increase-the-timeout-if-page-reclaim-is-not-making-progress.patch
 added to -mm tree
Message-ID: <20211022192556.gVzKDPY4q%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: increase the timeout if page reclaim is not making progress
has been added to the -mm tree.  Its filename is
     mm-vmscan-increase-the-timeout-if-page-reclaim-is-not-making-progress.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-increase-the-timeout-if-page-reclaim-is-not-making-progress.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-increase-the-timeout-if-page-reclaim-is-not-making-progress.patch

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
Subject: mm/vmscan: increase the timeout if page reclaim is not making progress

Tracing of the stutterp workload showed the following delays

      1 usect_delayed=124000 reason=VMSCAN_THROTTLE_NOPROGRESS
      1 usect_delayed=128000 reason=VMSCAN_THROTTLE_NOPROGRESS
      1 usect_delayed=176000 reason=VMSCAN_THROTTLE_NOPROGRESS
      1 usect_delayed=536000 reason=VMSCAN_THROTTLE_NOPROGRESS
      1 usect_delayed=544000 reason=VMSCAN_THROTTLE_NOPROGRESS
      1 usect_delayed=556000 reason=VMSCAN_THROTTLE_NOPROGRESS
      1 usect_delayed=624000 reason=VMSCAN_THROTTLE_NOPROGRESS
      1 usect_delayed=716000 reason=VMSCAN_THROTTLE_NOPROGRESS
      1 usect_delayed=772000 reason=VMSCAN_THROTTLE_NOPROGRESS
      2 usect_delayed=512000 reason=VMSCAN_THROTTLE_NOPROGRESS
     16 usect_delayed=120000 reason=VMSCAN_THROTTLE_NOPROGRESS
     53 usect_delayed=116000 reason=VMSCAN_THROTTLE_NOPROGRESS
    116 usect_delayed=112000 reason=VMSCAN_THROTTLE_NOPROGRESS
   5907 usect_delayed=108000 reason=VMSCAN_THROTTLE_NOPROGRESS
  71741 usect_delayed=104000 reason=VMSCAN_THROTTLE_NOPROGRESS

All the throttling hit the full timeout and then there was wakeup delays
meaning that the wakeups are premature as no other reclaimer such as
kswapd has made progress.  This patch increases the maximum timeout.

Link: https://lkml.kernel.org/r/20211022144651.19914-8-mgorman@techsingularity.net
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

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-increase-the-timeout-if-page-reclaim-is-not-making-progress
+++ a/mm/vmscan.c
@@ -1042,7 +1042,7 @@ void reclaim_throttle(pg_data_t *pgdat,
 
 		break;
 	case VMSCAN_THROTTLE_NOPROGRESS:
-		timeout = HZ/10;
+		timeout = HZ/2;
 		break;
 	case VMSCAN_THROTTLE_ISOLATED:
 		timeout = HZ/50;
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

