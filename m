Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44A3FC77B73
	for <mm-commits@archiver.kernel.org>; Wed, 31 May 2023 21:38:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbjEaViw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 May 2023 17:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbjEaVig (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 May 2023 17:38:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB37E58
        for <mm-commits@vger.kernel.org>; Wed, 31 May 2023 14:38:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F385363F53
        for <mm-commits@vger.kernel.org>; Wed, 31 May 2023 21:36:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5102FC433D2;
        Wed, 31 May 2023 21:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685569019;
        bh=lLsvXLyX8jEFLRHC4j8LUn5UPlRgmiADim4S8Ypvjng=;
        h=Date:To:From:Subject:From;
        b=Kw6fvgCWNYkPTW4GoZjUBW8n67BTcBB0xrpsOQcwklAQNzbp1kHff0/7U7JclTRat
         szV/VLoUSXR6N6vvbrUAhjSF3ZFKf9C01i1TRfYA//brESOZ2Ud8//8m/FME+4ofvf
         vR4q+RmzKuI09TSFIugQaqsorjYBXW9gj6EwvlTY=
Date:   Wed, 31 May 2023 14:36:58 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com, vbabka@suse.cz,
        mgorman@techsingularity.net, penguin-kernel@I-love.SAKURA.ne.jp,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-dont-wake-kswapd-from-rmqueue-unless-__gfp_kswapd_reclaim-is-specified.patch added to mm-unstable branch
Message-Id: <20230531213659.5102FC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: don't wake kswapd from rmqueue() unless __GFP_KSWAPD_RECLAIM is specified
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-dont-wake-kswapd-from-rmqueue-unless-__gfp_kswapd_reclaim-is-specified.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-dont-wake-kswapd-from-rmqueue-unless-__gfp_kswapd_reclaim-is-specified.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
@@ -2863,7 +2863,8 @@ struct page *rmqueue(struct zone *prefer
 
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

workingset-refactor-lru-refault-to-expose-refault-recency-check-fix.patch
kasankmsan-remove-__gfp_kswapd_reclaim-usage-from-kasan-kmsan.patch
mm-page_alloc-dont-wake-kswapd-from-rmqueue-unless-__gfp_kswapd_reclaim-is-specified.patch
debugobjects-turn-off-debug_objects_enabled-from-debug_objects_oom.patch

