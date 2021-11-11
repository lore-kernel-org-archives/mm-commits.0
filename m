Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2246DC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:45:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 010266113B
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:45:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbhKKCso (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:48:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:53712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234346AbhKKCso (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:48:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92CCE60F46;
        Thu, 11 Nov 2021 02:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598756;
        bh=3OpxqKJ7EnhRXgM5L8LSF9CCplSK/ozoDCXjMMSozPI=;
        h=Date:From:To:Subject:From;
        b=PS6uyObPdYKlqAljAldH6fUL3ZEHWWhjrjvXgrWNaki9wLaWupYZW53XRpsX+yIdi
         L1zaAqKGG36v/pTVfLZoTuaCVShL4y9gpG37BdJf/wIbxDZur5JNQHoUSE4oAmYMDL
         sm6PKBjCOvwsGTzHMYbjsKtoTL6uE7LNo8LjxXd4=
Date:   Wed, 10 Nov 2021 18:45:55 -0800
From:   akpm@linux-foundation.org
To:     adilger.kernel@dilger.ca, corbet@lwn.net, david@fromorbit.com,
        djwong@kernel.org, hannes@cmpxchg.org, mgorman@techsingularity.net,
        mhocko@suse.com, mm-commits@vger.kernel.org, neilb@suse.de,
        riel@surriel.com, tytso@mit.edu, vbabka@suse.cz,
        willy@infradead.org
Subject:  [merged]
 mm-vmscan-increase-the-timeout-if-page-reclaim-is-not-making-progress.patch
 removed from -mm tree
Message-ID: <20211111024555.jJoGQpoGg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: increase the timeout if page reclaim is not making progress
has been removed from the -mm tree.  Its filename was
     mm-vmscan-increase-the-timeout-if-page-reclaim-is-not-making-progress.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


