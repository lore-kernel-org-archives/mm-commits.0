Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E15D0C54EBE
	for <mm-commits@archiver.kernel.org>; Mon,  9 Jan 2023 23:45:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234690AbjAIXpT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Jan 2023 18:45:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238073AbjAIXom (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2023 18:44:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3872C33D54
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 15:44:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C94686148C
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 23:44:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C4EC43392;
        Mon,  9 Jan 2023 23:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673307880;
        bh=WPR0V9ovD0oedNBeXYXU2L4Tad1uB9BsFZTSlCjRLjA=;
        h=Date:To:From:Subject:From;
        b=s25zmmsslNVO/uMq+pKS7X6VrFtokAbA3hjVgJjJMdvrRw/hMbvQiq3DijURsCyUF
         4dQH3AJUQkZeUfG62PAeoHwYYAYIXQxOb0QPJqA6xeTuDWbblm1pg9mWXgwj5o9fdK
         LvefC1rrFjQ1LcGcUiaN+ebbuS0Suwilo0rcZ4Uc=
Date:   Mon, 09 Jan 2023 15:44:39 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        thierry.reding@gmail.com, neilb@suse.de, mhocko@suse.com,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-explicitly-record-high-order-atomic-allocations-in-alloc_flags.patch added to mm-unstable branch
Message-Id: <20230109234440.08C4EC43392@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: explicitly record high-order atomic allocations in alloc_flags
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-explicitly-record-high-order-atomic-allocations-in-alloc_flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-explicitly-record-high-order-atomic-allocations-in-alloc_flags.patch

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
Subject: mm/page_alloc: explicitly record high-order atomic allocations in alloc_flags
Date: Mon, 9 Jan 2023 15:16:27 +0000

A high-order ALLOC_HARDER allocation is assumed to be atomic.  While that
is accurate, it changes later in the series.  In preparation, explicitly
record high-order atomic allocations in gfp_to_alloc_flags().  There is a
slight functional change in that OOM handling avoids using high-order
reserve until it has to.

Link: https://lkml.kernel.org/r/20230109151631.24923-4-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    1 +
 mm/page_alloc.c |   29 +++++++++++++++++++++++------
 2 files changed, 24 insertions(+), 6 deletions(-)

--- a/mm/internal.h~mm-page_alloc-explicitly-record-high-order-atomic-allocations-in-alloc_flags
+++ a/mm/internal.h
@@ -771,6 +771,7 @@ unsigned int reclaim_clean_pages_from_li
 #else
 #define ALLOC_NOFRAGMENT	  0x0
 #endif
+#define ALLOC_HIGHATOMIC	0x200 /* Allows access to MIGRATE_HIGHATOMIC */
 #define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
 
 enum ttu_flags;
--- a/mm/page_alloc.c~mm-page_alloc-explicitly-record-high-order-atomic-allocations-in-alloc_flags
+++ a/mm/page_alloc.c
@@ -3721,10 +3721,20 @@ struct page *rmqueue_buddy(struct zone *
 		 * reserved for high-order atomic allocation, so order-0
 		 * request should skip it.
 		 */
-		if (order > 0 && alloc_flags & ALLOC_HARDER)
+		if (alloc_flags & ALLOC_HIGHATOMIC)
 			page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
 		if (!page) {
 			page = __rmqueue(zone, order, migratetype, alloc_flags);
+
+			/*
+			 * If the allocation fails, allow OOM handling access
+			 * to HIGHATOMIC reserves as failing now is worse than
+			 * failing a high-order atomic allocation in the
+			 * future.
+			 */
+			if (!page && (alloc_flags & ALLOC_OOM))
+				page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
+
 			if (!page) {
 				spin_unlock_irqrestore(&zone->lock, flags);
 				return NULL;
@@ -4038,8 +4048,10 @@ bool __zone_watermark_ok(struct zone *z,
 			return true;
 		}
 #endif
-		if (alloc_harder && !free_area_empty(area, MIGRATE_HIGHATOMIC))
+		if ((alloc_flags & (ALLOC_HIGHATOMIC|ALLOC_OOM)) &&
+		    !free_area_empty(area, MIGRATE_HIGHATOMIC)) {
 			return true;
+		}
 	}
 	return false;
 }
@@ -4301,7 +4313,7 @@ try_this_zone:
 			 * If this is a high-order atomic allocation then check
 			 * if the pageblock should be reserved for the future
 			 */
-			if (unlikely(order && (alloc_flags & ALLOC_HARDER)))
+			if (unlikely(alloc_flags & ALLOC_HIGHATOMIC))
 				reserve_highatomic_pageblock(page, zone, order);
 
 			return page;
@@ -4828,7 +4840,7 @@ static void wake_all_kswapds(unsigned in
 }
 
 static inline unsigned int
-gfp_to_alloc_flags(gfp_t gfp_mask)
+gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
 {
 	unsigned int alloc_flags = ALLOC_WMARK_MIN | ALLOC_CPUSET;
 
@@ -4854,8 +4866,13 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 		 * Not worth trying to allocate harder for __GFP_NOMEMALLOC even
 		 * if it can't schedule.
 		 */
-		if (!(gfp_mask & __GFP_NOMEMALLOC))
+		if (!(gfp_mask & __GFP_NOMEMALLOC)) {
 			alloc_flags |= ALLOC_HARDER;
+
+			if (order > 0)
+				alloc_flags |= ALLOC_HIGHATOMIC;
+		}
+
 		/*
 		 * Ignore cpuset mems for GFP_ATOMIC rather than fail, see the
 		 * comment for __cpuset_node_allowed().
@@ -5063,7 +5080,7 @@ restart:
 	 * kswapd needs to be woken up, and to avoid the cost of setting up
 	 * alloc_flags precisely. So we do that now.
 	 */
-	alloc_flags = gfp_to_alloc_flags(gfp_mask);
+	alloc_flags = gfp_to_alloc_flags(gfp_mask, order);
 
 	/*
 	 * We need to recalculate the starting point for the zonelist iterator
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-rename-alloc_high-to-alloc_min_reserve.patch
mm-page_alloc-treat-rt-tasks-similar-to-__gfp_high.patch
mm-page_alloc-explicitly-record-high-order-atomic-allocations-in-alloc_flags.patch
mm-page_alloc-explicitly-define-what-alloc-flags-deplete-min-reserves.patch
mm-page_allocc-allow-__gfp_nofail-requests-deeper-access-to-reserves.patch
mm-page_alloc-give-gfp_atomic-and-non-blocking-allocations-access-to-reserves.patch

