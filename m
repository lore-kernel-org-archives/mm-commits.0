Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA6CCC7EE25
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:33:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232862AbjFIXdh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232870AbjFIXcw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:32:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8947D49D5
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:30:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57D2063EB7
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:30:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC2BAC433EF;
        Fri,  9 Jun 2023 23:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353400;
        bh=pN5v4g69bdk3WawtWn+3FgOK7WBtTFworP0Klprv8j0=;
        h=Date:To:From:Subject:From;
        b=gfbmonGxxnCE+NPZJ8hHl3YAbK7U2GHLfge1ZdZcGZka5jQWlEG1y7exJcLbhxrlf
         MbJgDdBWY1eA9nUv9DCJDDKz0HVx5RMGQWvrgNLAyiUAtvRoiiJ1plh8kN9J8/M1aC
         mtlUb2gfNZZy7NnY/Gwvdg5cfv9rT0KtqQ5nKB1Y=
Date:   Fri, 09 Jun 2023 16:30:00 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com, vbabka@suse.cz,
        mgorman@techsingularity.net, penguin-kernel@I-love.SAKURA.ne.jp,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-dont-wake-kswapd-from-rmqueue-unless-__gfp_kswapd_reclaim-is-specified.patch removed from -mm tree
Message-Id: <20230609233000.AC2BAC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: don't wake kswapd from rmqueue() unless __GFP_KSWAPD_RECLAIM is specified
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-dont-wake-kswapd-from-rmqueue-unless-__gfp_kswapd_reclaim-is-specified.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: mm/page_alloc: don't wake kswapd from rmqueue() unless __GFP_KSWAPD_RECLAIM is specified
Date: Sun, 14 May 2023 09:28:56 +0900

Commit 73444bc4d8f9 ("mm, page_alloc: do not wake kswapd with zone lock
held") moved wakeup_kswapd() from steal_suitable_fallback() to rmqueue()
using ZONE_BOOSTED_WATERMARK flag.

Only allocation contexts that include ALLOC_KSWAPD (which corresponds to
__GFP_KSWAPD_RECLAIM) should wake kswapd, for callers are supposed to
remove __GFP_KSWAPD_RECLAIM if trying to hold pgdat->kswapd_wait has a
risk of deadlock.  But since zone->flags is a shared variable, a thread
doing !__GFP_KSWAPD_RECLAIM allocation request might observe this flag
being set immediately after another thread doing __GFP_KSWAPD_RECLAIM
allocation request set this flag, causing possibility of deadlock.

Link: https://lkml.kernel.org/r/c3c3dacf-dd3b-77c9-f96a-d0982b4b2a4f@I-love.SAKURA.ne.jp
Fixes: 73444bc4d8f9 ("mm, page_alloc: do not wake kswapd with zone lock held")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-dont-wake-kswapd-from-rmqueue-unless-__gfp_kswapd_reclaim-is-specified
+++ a/mm/page_alloc.c
@@ -2827,7 +2827,8 @@ struct page *rmqueue(struct zone *prefer
 
 out:
 	/* Separate test+clear to avoid unnecessary atomics */
-	if (unlikely(test_bit(ZONE_BOOSTED_WATERMARK, &zone->flags))) {
+	if ((alloc_flags & ALLOC_KSWAPD) &&
+	    unlikely(test_bit(ZONE_BOOSTED_WATERMARK, &zone->flags))) {
 		clear_bit(ZONE_BOOSTED_WATERMARK, &zone->flags);
 		wakeup_kswapd(zone, 0, 0, zone_idx(zone));
 	}
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

kasankmsan-remove-__gfp_kswapd_reclaim-usage-from-kasan-kmsan.patch

