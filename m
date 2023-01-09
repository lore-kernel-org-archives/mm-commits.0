Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2513C5479D
	for <mm-commits@archiver.kernel.org>; Mon,  9 Jan 2023 23:45:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237888AbjAIXpx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Jan 2023 18:45:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237902AbjAIXot (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2023 18:44:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1A83FA18
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 15:44:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A903861497
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 23:44:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DABF0C433D2;
        Mon,  9 Jan 2023 23:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673307886;
        bh=PnGJqONzOC1eJVobsNtvCCy4KbvOGBvnr0znAuXIiE8=;
        h=Date:To:From:Subject:From;
        b=P8pl7RFKnqQdVd6J3gLgosSndnl2+/6R66fIP+Af95fGrtPs809ZgUceyTXDTWGu2
         UUHDgq5LQxEszUO/20wGtncwZEWwAAQ53RV2FPyhD8fpPU49OoboUEHB6J7278kTXK
         WgxxmyEElxHHGi5us54azBDgQA6LBzoFwA53PObI=
Date:   Mon, 09 Jan 2023 15:44:46 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        thierry.reding@gmail.com, neilb@suse.de, mhocko@suse.com,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-give-gfp_atomic-and-non-blocking-allocations-access-to-reserves.patch added to mm-unstable branch
Message-Id: <20230109234446.DABF0C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: give GFP_ATOMIC and non-blocking allocations access to reserves
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-give-gfp_atomic-and-non-blocking-allocations-access-to-reserves.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-give-gfp_atomic-and-non-blocking-allocations-access-to-reserves.patch

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
Subject: mm/page_alloc: give GFP_ATOMIC and non-blocking allocations access to reserves
Date: Mon, 9 Jan 2023 15:16:30 +0000

Explicit GFP_ATOMIC allocations get flagged ALLOC_HARDER which is a bit
vague.  In preparation for removing __GFP_ATOMIC, give GFP_ATOMIC and
other non-blocking allocation requests equal access to reserve.  Rename
ALLOC_HARDER to ALLOC_NON_BLOCK to make it more clear what the flag means.

Link: https://lkml.kernel.org/r/20230109151631.24923-7-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    7 +++++--
 mm/page_alloc.c |   23 +++++++++++++----------
 2 files changed, 18 insertions(+), 12 deletions(-)

--- a/mm/internal.h~mm-page_alloc-give-gfp_atomic-and-non-blocking-allocations-access-to-reserves
+++ a/mm/internal.h
@@ -760,7 +760,10 @@ unsigned int reclaim_clean_pages_from_li
 #define ALLOC_OOM		ALLOC_NO_WATERMARKS
 #endif
 
-#define ALLOC_HARDER		 0x10 /* try to alloc harder */
+#define ALLOC_NON_BLOCK		 0x10 /* Caller cannot block. Allow access
+				       * to 25% of the min watermark or
+				       * 62.5% if __GFP_HIGH is set.
+				       */
 #define ALLOC_MIN_RESERVE	 0x20 /* __GFP_HIGH set. Allow access to 50%
 				       * of the min watermark.
 				       */
@@ -775,7 +778,7 @@ unsigned int reclaim_clean_pages_from_li
 #define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
 
 /* Flags that allow allocations below the min watermark. */
-#define ALLOC_RESERVES (ALLOC_HARDER|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
+#define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
 
 enum ttu_flags;
 struct tlbflush_unmap_batch;
--- a/mm/page_alloc.c~mm-page_alloc-give-gfp_atomic-and-non-blocking-allocations-access-to-reserves
+++ a/mm/page_alloc.c
@@ -4014,7 +4014,7 @@ bool __zone_watermark_ok(struct zone *z,
 		 * if it cannot get memory quickly, particularly if it's
 		 * also __GFP_HIGH.
 		 */
-		if (alloc_flags & ALLOC_HARDER)
+		if (alloc_flags & ALLOC_NON_BLOCK)
 			min -= min / 4;
 
 		/*
@@ -4866,28 +4866,30 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsig
 	 * The caller may dip into page reserves a bit more if the caller
 	 * cannot run direct reclaim, or if the caller has realtime scheduling
 	 * policy or is asking for __GFP_HIGH memory.  GFP_ATOMIC requests will
-	 * set both ALLOC_HARDER (__GFP_ATOMIC) and ALLOC_MIN_RESERVE(__GFP_HIGH).
+	 * set both ALLOC_NON_BLOCK and ALLOC_MIN_RESERVE(__GFP_HIGH).
 	 */
 	alloc_flags |= (__force int)
 		(gfp_mask & (__GFP_HIGH | __GFP_KSWAPD_RECLAIM));
 
-	if (gfp_mask & __GFP_ATOMIC) {
+	if (!(gfp_mask & __GFP_DIRECT_RECLAIM)) {
 		/*
 		 * Not worth trying to allocate harder for __GFP_NOMEMALLOC even
 		 * if it can't schedule.
 		 */
 		if (!(gfp_mask & __GFP_NOMEMALLOC)) {
-			alloc_flags |= ALLOC_HARDER;
+			alloc_flags |= ALLOC_NON_BLOCK;
 
 			if (order > 0)
 				alloc_flags |= ALLOC_HIGHATOMIC;
 		}
 
 		/*
-		 * Ignore cpuset mems for GFP_ATOMIC rather than fail, see the
-		 * comment for __cpuset_node_allowed().
+		 * Ignore cpuset mems for non-blocking __GFP_HIGH (probably
+		 * GFP_ATOMIC) rather than fail, see the comment for
+		 * __cpuset_node_allowed().
 		 */
-		alloc_flags &= ~ALLOC_CPUSET;
+		if (alloc_flags & ALLOC_MIN_RESERVE)
+			alloc_flags &= ~ALLOC_CPUSET;
 	} else if (unlikely(rt_task(current)) && in_task())
 		alloc_flags |= ALLOC_MIN_RESERVE;
 
@@ -5319,11 +5321,12 @@ nopage:
 
 		/*
 		 * Help non-failing allocations by giving them access to memory
-		 * reserves but do not use ALLOC_NO_WATERMARKS because this
+		 * reserves normally used for high priority non-blocking
+		 * allocations but do not use ALLOC_NO_WATERMARKS because this
 		 * could deplete whole memory reserves which would just make
-		 * the situation worse
+		 * the situation worse.
 		 */
-		page = __alloc_pages_cpuset_fallback(gfp_mask, order, ALLOC_MIN_RESERVE|ALLOC_HARDER, ac);
+		page = __alloc_pages_cpuset_fallback(gfp_mask, order, ALLOC_MIN_RESERVE|ALLOC_NON_BLOCK, ac);
 		if (page)
 			goto got_pg;
 
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-rename-alloc_high-to-alloc_min_reserve.patch
mm-page_alloc-treat-rt-tasks-similar-to-__gfp_high.patch
mm-page_alloc-explicitly-record-high-order-atomic-allocations-in-alloc_flags.patch
mm-page_alloc-explicitly-define-what-alloc-flags-deplete-min-reserves.patch
mm-page_allocc-allow-__gfp_nofail-requests-deeper-access-to-reserves.patch
mm-page_alloc-give-gfp_atomic-and-non-blocking-allocations-access-to-reserves.patch

