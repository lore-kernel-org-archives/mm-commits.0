Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04BC8C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 31 Dec 2021 21:10:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbhLaVKO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 31 Dec 2021 16:10:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58320 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbhLaVKO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 31 Dec 2021 16:10:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A7A7B81D7A
        for <mm-commits@vger.kernel.org>; Fri, 31 Dec 2021 21:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A4B4C36AEA;
        Fri, 31 Dec 2021 21:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640985011;
        bh=eCydJAVVq+jmgyyGS+Rvi2JTJOavb+huUaMEhv49O6Y=;
        h=Date:From:To:Subject:From;
        b=steKzcw5WdnrO6mFcDnRKBRXPI9gF7CLhJ5C7lSeQkskflNQYqu2hXRv8Tt8ygQ/Q
         qLrHoCJETrCU/XFHxLEgh7S/bbEPNKZygwV6/fJjnzN+3XQ8FJBnQrcCcUUOzlvHOx
         73Unlhq3chVak4rFjtinsYrKOShez+mUgj7X3MOI=
Date:   Fri, 31 Dec 2021 13:10:09 -0800
From:   akpm@linux-foundation.org
To:     vbabka@suse.cz, shakeelb@google.com, riel@surriel.com,
        mhocko@suse.com, hughd@google.com, efault@gmx.de,
        djwong@kernel.org, mgorman@techsingularity.net,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 1/1] mm: vmscan: reduce throttling due to a failure
 to make progress -fix
Message-ID: <20211231211009.5by9X%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm: vmscan: reduce throttling due to a failure to make progress -fix

Hugh Dickins reported the following

	My tmpfs swapping load (tweaked to use huge pages more heavily
	than in real life) is far from being a realistic load: but it was
	notably slowed down by your throttling mods in 5.16-rc, and this
	patch makes it well again - thanks.

	But: it very quickly hit NULL pointer until I changed that last
	line to

        if (first_pgdat)
                consider_reclaim_throttle(first_pgdat, sc);

The likely issue is that huge pages are a major component of the test
workload. When this is the case, first_pgdat may never get set if
compaction is ready to continue due to this check

        if (IS_ENABLED(CONFIG_COMPACTION) &&
            sc->order > PAGE_ALLOC_COSTLY_ORDER &&
            compaction_ready(zone, sc)) {
                sc->compaction_ready = true;
                continue;
        }

If this was true for every zone in the zonelist, first_pgdat would never
get set resulting in a NULL pointer exception.

Link: https://lkml.kernel.org/r/20211209095453.GM3366@techsingularity.net
Fixes: 1b4e3f26f9f75 ("mm: vmscan: Reduce throttling due to a failure to make progress")
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reported-by: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Rik van Riel <riel@surriel.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-reduce-throttling-due-to-a-failure-to-make-progress-fix
+++ a/mm/vmscan.c
@@ -3530,7 +3530,8 @@ static void shrink_zones(struct zonelist
 		shrink_node(zone->zone_pgdat, sc);
 	}
 
-	consider_reclaim_throttle(first_pgdat, sc);
+	if (first_pgdat)
+		consider_reclaim_throttle(first_pgdat, sc);
 
 	/*
 	 * Restore to original mask to avoid the impact on the caller if we
_
