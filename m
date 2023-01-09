Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37802C67871
	for <mm-commits@archiver.kernel.org>; Mon,  9 Jan 2023 23:45:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238046AbjAIXpS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Jan 2023 18:45:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238068AbjAIXoj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2023 18:44:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400FE63C9
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 15:44:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED9DBB810A5
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 23:44:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F9DC433EF;
        Mon,  9 Jan 2023 23:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673307875;
        bh=Felewd8/5JWMUxzC1luO7odfSo2+ufhhnircreoAxC8=;
        h=Date:To:From:Subject:From;
        b=TooiaHcTykX0RuDd6KoRZ8214YtuqmxJJ6J1jcI81iSMzaj8AJN1HoLJrpOEn5HG7
         b+EUmEI03ltHRPvclQv858kfW1ExIseYJAqpnBDM0h0cB5pELwnA7kMosZqAaEnLsJ
         FbPXWjRC2Ugjm1hLKMD6L7nnJwm0mem3Sy9x6cMY=
Date:   Mon, 09 Jan 2023 15:44:34 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        thierry.reding@gmail.com, neilb@suse.de, mhocko@suse.com,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-rename-alloc_high-to-alloc_min_reserve.patch added to mm-unstable branch
Message-Id: <20230109234435.94F9DC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: rename ALLOC_HIGH to ALLOC_MIN_RESERVE
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-rename-alloc_high-to-alloc_min_reserve.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-rename-alloc_high-to-alloc_min_reserve.patch

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
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: rename ALLOC_HIGH to ALLOC_MIN_RESERVE
Date: Mon, 9 Jan 2023 15:16:25 +0000

Patch series "Discard __GFP_ATOMIC", v2.

Neil's patch was residing in mm-unstable as commit 2fafb4fe8f7a ("mm:
discard __GFP_ATOMIC") for a long time and recently brought up again. 
Most recently, I was worried that __GFP_HIGH allocations could use
high-order atomic reserves which is unintentional but there was no
response so lets revisit -- this series reworks how min reserves are used,
protects highorder reserves and then finishes with Neil's patch with very
minor modifications so it fits on top.

There was a review discussion on renaming __GFP_DIRECT_RECLAIM to
__GFP_ALLOW_BLOCKING but I didn't think it was that big an issue and is
ortogonal to the removal of __GFP_ATOMIC.

There were some concerns about how the gfp flags affect the min reserves
but it never reached a solid conclusion so I made my own attempt.

The series tries to iron out some of the details on how reserves are used.
ALLOC_HIGH becomes ALLOC_MIN_RESERVE and ALLOC_HARDER becomes
ALLOC_NON_BLOCK and documents how the reserves are affected.  For example,
ALLOC_NON_BLOCK (no direct reclaim) on its own allows 25% of the min
reserve.  ALLOC_MIN_RESERVE (__GFP_HIGH) allows 50% and both combined
allows deeper access again.  ALLOC_OOM allows access to 75%.

High-order atomic allocations are explicitly handled with the caveat that
no __GFP_ATOMIC flag means that any high-order allocation that specifies
GFP_HIGH and cannot enter direct reclaim will be treated as if it was
GFP_ATOMIC.


This patch (of 7):

__GFP_HIGH aliases to ALLOC_HIGH but the name does not really hint what it
means.  As ALLOC_HIGH is internal to the allocator, rename it to
ALLOC_MIN_RESERVE to document that the min reserves can be depleted.

Link: https://lkml.kernel.org/r/20230109151631.24923-1-mgorman@techsingularity.net
Link: https://lkml.kernel.org/r/20230109151631.24923-2-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    4 +++-
 mm/page_alloc.c |    8 ++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

--- a/mm/internal.h~mm-page_alloc-rename-alloc_high-to-alloc_min_reserve
+++ a/mm/internal.h
@@ -761,7 +761,9 @@ unsigned int reclaim_clean_pages_from_li
 #endif
 
 #define ALLOC_HARDER		 0x10 /* try to alloc harder */
-#define ALLOC_HIGH		 0x20 /* __GFP_HIGH set */
+#define ALLOC_MIN_RESERVE	 0x20 /* __GFP_HIGH set. Allow access to 50%
+				       * of the min watermark.
+				       */
 #define ALLOC_CPUSET		 0x40 /* check for correct cpuset */
 #define ALLOC_CMA		 0x80 /* allow allocations from CMA areas */
 #ifdef CONFIG_ZONE_DMA32
--- a/mm/page_alloc.c~mm-page_alloc-rename-alloc_high-to-alloc_min_reserve
+++ a/mm/page_alloc.c
@@ -3991,7 +3991,7 @@ bool __zone_watermark_ok(struct zone *z,
 	/* free_pages may go negative - that's OK */
 	free_pages -= __zone_watermark_unusable_free(z, order, alloc_flags);
 
-	if (alloc_flags & ALLOC_HIGH)
+	if (alloc_flags & ALLOC_MIN_RESERVE)
 		min -= min / 2;
 
 	if (unlikely(alloc_harder)) {
@@ -4833,18 +4833,18 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 	unsigned int alloc_flags = ALLOC_WMARK_MIN | ALLOC_CPUSET;
 
 	/*
-	 * __GFP_HIGH is assumed to be the same as ALLOC_HIGH
+	 * __GFP_HIGH is assumed to be the same as ALLOC_MIN_RESERVE
 	 * and __GFP_KSWAPD_RECLAIM is assumed to be the same as ALLOC_KSWAPD
 	 * to save two branches.
 	 */
-	BUILD_BUG_ON(__GFP_HIGH != (__force gfp_t) ALLOC_HIGH);
+	BUILD_BUG_ON(__GFP_HIGH != (__force gfp_t) ALLOC_MIN_RESERVE);
 	BUILD_BUG_ON(__GFP_KSWAPD_RECLAIM != (__force gfp_t) ALLOC_KSWAPD);
 
 	/*
 	 * The caller may dip into page reserves a bit more if the caller
 	 * cannot run direct reclaim, or if the caller has realtime scheduling
 	 * policy or is asking for __GFP_HIGH memory.  GFP_ATOMIC requests will
-	 * set both ALLOC_HARDER (__GFP_ATOMIC) and ALLOC_HIGH (__GFP_HIGH).
+	 * set both ALLOC_HARDER (__GFP_ATOMIC) and ALLOC_MIN_RESERVE(__GFP_HIGH).
 	 */
 	alloc_flags |= (__force int)
 		(gfp_mask & (__GFP_HIGH | __GFP_KSWAPD_RECLAIM));
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-rename-alloc_high-to-alloc_min_reserve.patch
mm-page_alloc-treat-rt-tasks-similar-to-__gfp_high.patch
mm-page_alloc-explicitly-record-high-order-atomic-allocations-in-alloc_flags.patch
mm-page_alloc-explicitly-define-what-alloc-flags-deplete-min-reserves.patch
mm-page_allocc-allow-__gfp_nofail-requests-deeper-access-to-reserves.patch
mm-page_alloc-give-gfp_atomic-and-non-blocking-allocations-access-to-reserves.patch

