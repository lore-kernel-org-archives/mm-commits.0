Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FD18C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:40:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbjBCGke (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:40:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232463AbjBCGj3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:39:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF50C8EB4D
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:37:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B0EFB82985
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:37:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04AC2C433D2;
        Fri,  3 Feb 2023 06:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406220;
        bh=IfuCWJXJOwVeRYt0oBZrArgYY9f5rcigy1MRM/mF+OY=;
        h=Date:To:From:Subject:From;
        b=aKURumTpr/GecgLbsiRg8CodeZrZ7rXddVJ6pcY4CaVOsOnHIJ3aaql72hsDz9NcM
         7oEYdRmsCnhiW0EApR2/wf27s61Sa3F+MaQuYPPPbtebFixuxyHf1JQYmy/U2okEwk
         7x5KUI/Gv9ojq8jB/SEsCxSWK/GAS5V4xdWu3yl4=
Date:   Thu, 02 Feb 2023 22:36:59 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        thierry.reding@gmail.com, neilb@suse.de, mhocko@suse.com,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-explicitly-define-how-__gfp_high-non-blocking-allocations-accesses-reserves.patch removed from -mm tree
Message-Id: <20230203063700.04AC2C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: explicitly define how __GFP_HIGH non-blocking allocations accesses reserves
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-explicitly-define-how-__gfp_high-non-blocking-allocations-accesses-reserves.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: explicitly define how __GFP_HIGH non-blocking allocations accesses reserves
Date: Fri, 13 Jan 2023 11:12:16 +0000

GFP_ATOMIC allocations get flagged ALLOC_HARDER which is a vague
description.  In preparation for the removal of GFP_ATOMIC redefine
__GFP_ATOMIC to simply mean non-blocking and renaming ALLOC_HARDER to
ALLOC_NON_BLOCK accordingly.  __GFP_HIGH is required for access to
reserves but non-blocking is granted more access.  For example, GFP_NOWAIT
is non-blocking but has no special access to reserves.  A __GFP_NOFAIL
blocking allocation is granted access similar to __GFP_HIGH if the only
alternative is an OOM kill.

Link: https://lkml.kernel.org/r/20230113111217.14134-6-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: NeilBrown <neilb@suse.de>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/internal.h~mm-page_alloc-explicitly-define-how-__gfp_high-non-blocking-allocations-accesses-reserves
+++ a/mm/internal.h
@@ -778,7 +778,10 @@ unsigned int reclaim_clean_pages_from_li
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
@@ -793,7 +796,7 @@ unsigned int reclaim_clean_pages_from_li
 #define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
 
 /* Flags that allow allocations below the min watermark. */
-#define ALLOC_RESERVES (ALLOC_HARDER|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
+#define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
 
 enum ttu_flags;
 struct tlbflush_unmap_batch;
--- a/mm/page_alloc.c~mm-page_alloc-explicitly-define-how-__gfp_high-non-blocking-allocations-accesses-reserves
+++ a/mm/page_alloc.c
@@ -4007,18 +4007,19 @@ bool __zone_watermark_ok(struct zone *z,
 		 * __GFP_HIGH allows access to 50% of the min reserve as well
 		 * as OOM.
 		 */
-		if (alloc_flags & ALLOC_MIN_RESERVE)
+		if (alloc_flags & ALLOC_MIN_RESERVE) {
 			min -= min / 2;
 
-		/*
-		 * Non-blocking allocations can access some of the reserve
-		 * with more access if also __GFP_HIGH. The reasoning is that
-		 * a non-blocking caller may incur a more severe penalty
-		 * if it cannot get memory quickly, particularly if it's
-		 * also __GFP_HIGH.
-		 */
-		if (alloc_flags & ALLOC_HARDER)
-			min -= min / 4;
+			/*
+			 * Non-blocking allocations (e.g. GFP_ATOMIC) can
+			 * access more reserves than just __GFP_HIGH. Other
+			 * non-blocking allocations requests such as GFP_NOWAIT
+			 * or (GFP_KERNEL & ~__GFP_DIRECT_RECLAIM) do not get
+			 * access to the min reserve.
+			 */
+			if (alloc_flags & ALLOC_NON_BLOCK)
+				min -= min / 4;
+		}
 
 		/*
 		 * OOM victims can try even harder than the normal reserve
@@ -4869,28 +4870,30 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsig
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
 
@@ -5321,12 +5324,13 @@ nopage:
 		WARN_ON_ONCE_GFP(costly_order, gfp_mask);
 
 		/*
-		 * Help non-failing allocations by giving them access to memory
-		 * reserves but do not use ALLOC_NO_WATERMARKS because this
+		 * Help non-failing allocations by giving some access to memory
+		 * reserves normally used for high priority non-blocking
+		 * allocations but do not use ALLOC_NO_WATERMARKS because this
 		 * could deplete whole memory reserves which would just make
-		 * the situation worse
+		 * the situation worse.
 		 */
-		page = __alloc_pages_cpuset_fallback(gfp_mask, order, ALLOC_HARDER, ac);
+		page = __alloc_pages_cpuset_fallback(gfp_mask, order, ALLOC_MIN_RESERVE, ac);
 		if (page)
 			goto got_pg;
 
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


