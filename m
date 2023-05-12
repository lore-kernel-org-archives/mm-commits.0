Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40CE1C77B7F
	for <mm-commits@archiver.kernel.org>; Fri, 12 May 2023 03:41:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239786AbjELDlY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 May 2023 23:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239562AbjELDlX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 11 May 2023 23:41:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF074C3F
        for <mm-commits@vger.kernel.org>; Thu, 11 May 2023 20:41:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E7E964EA4
        for <mm-commits@vger.kernel.org>; Fri, 12 May 2023 03:41:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFA53C4339B;
        Fri, 12 May 2023 03:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683862881;
        bh=a7OvMtSTQj8Z8rqFsf5WkPPr2ixQw9zAp3gM7dQGw0Q=;
        h=Date:To:From:Subject:From;
        b=RWClw4BGEvcEs7BxosaPA8BCik7u6eiquDD/tkKSH1+RNqwWMPDLjDUl2usF468UC
         bUm1YXoxLlHBSfK42tnTZLvK6u+ULEVGlsYtcRQ0GtHPZyT7Vas81yOLk7W54vuqk0
         y7v2rTlQpos6xmkZLyzP4kxm+72xA/SYiVB6bdUc=
Date:   Thu, 11 May 2023 20:41:20 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mhocko@suse.com,
        mgorman@techsingularity.net, dvyukov@google.com, cai@lca.pw,
        penguin-kernel@I-love.SAKURA.ne.jp, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-dont-wake-up-kswapd-from-rmqueue-unless-__gfp_kswapd_reclaim-is-specified.patch added to mm-unstable branch
Message-Id: <20230512034121.CFA53C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: don't wake up kswapd from rmqueue() unless __GFP_KSWAPD_RECLAIM is specified
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-dont-wake-up-kswapd-from-rmqueue-unless-__gfp_kswapd_reclaim-is-specified.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-dont-wake-up-kswapd-from-rmqueue-unless-__gfp_kswapd_reclaim-is-specified.patch

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
Subject: mm/page_alloc: don't wake up kswapd from rmqueue() unless __GFP_KSWAPD_RECLAIM is specified
Date: Thu, 11 May 2023 22:47:36 +0900

Commit 73444bc4d8f9 ("mm, page_alloc: do not wake kswapd with zone lock
held") moved wakeup_kswapd() from steal_suitable_fallback() to rmqueue()
using ZONE_BOOSTED_WATERMARK flag.  But since zone->flags is a shared
variable, a thread doing !__GFP_KSWAPD_RECLAIM allocation request might
observe this flag being set immediately after another thread doing
__GFP_KSWAPD_RECLAIM allocation request set this flag.

Link: https://lkml.kernel.org/r/6d6fb601-6100-92b9-cea3-e7ebacc7693a@I-love.SAKURA.ne.jp
Fixes: 73444bc4d8f9 ("mm, page_alloc: do not wake kswapd with zone lock held")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Qian Cai <cai@lca.pw>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-dont-wake-up-kswapd-from-rmqueue-unless-__gfp_kswapd_reclaim-is-specified
+++ a/mm/page_alloc.c
@@ -3052,7 +3052,8 @@ struct page *rmqueue(struct zone *prefer
 
 out:
 	/* Separate test+clear to avoid unnecessary atomics */
-	if (unlikely(test_bit(ZONE_BOOSTED_WATERMARK, &zone->flags))) {
+	if (unlikely(test_bit(ZONE_BOOSTED_WATERMARK, &zone->flags))
+	    && (alloc_flags & ALLOC_KSWAPD)) {
 		clear_bit(ZONE_BOOSTED_WATERMARK, &zone->flags);
 		wakeup_kswapd(zone, 0, 0, zone_idx(zone));
 	}
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

mm-page_alloc-dont-wake-up-kswapd-from-rmqueue-unless-__gfp_kswapd_reclaim-is-specified.patch

