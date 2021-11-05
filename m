Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF224C4332F
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:42:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCD786126A
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:42:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233708AbhKEUpa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:45:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:40250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233677AbhKEUp0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:45:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F4FA6127A;
        Fri,  5 Nov 2021 20:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144966;
        bh=qAtNb1UtwO11oGQLWQsynswt809Y6PArBjBPkNKUvj8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZJQiOQQPFe8Cv17p9K6vdp6NdV7uGhjRPWXvL4/p1jjsIDzX3aJnpIsF1IWl+jufP
         iuirKqPnPzKRNyQWaDxHRnY4j24Wdj3uNS4lJ8hsnhfyc/ATlv62C5eWCxL2VmH7N+
         Zmysvk97Zx/IgR9AyB/AZQRsCMGYoYM+rDorJpZA=
Date:   Fri, 05 Nov 2021 13:42:45 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adilger.kernel@dilger.ca, akpm@linux-foundation.org,
        corbet@lwn.net, david@fromorbit.com, djwong@kernel.org,
        hannes@cmpxchg.org, linux-mm@kvack.org,
        mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, neilb@suse.de, riel@surriel.com,
        torvalds@linux-foundation.org, tytso@mit.edu, vbabka@suse.cz,
        willy@infradead.org
Subject:  [patch 155/262] mm/vmscan: increase the timeout if page
 reclaim is not making progress
Message-ID: <20211105204245.WSzho92J2%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
