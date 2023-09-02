Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AD0DC83F2C
	for <mm-commits@archiver.kernel.org>; Sat,  2 Sep 2023 22:18:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235031AbjIBWSG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 2 Sep 2023 18:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbjIBWSD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 2 Sep 2023 18:18:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68B44CE0
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 15:18:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 346DFB80881
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 22:17:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2524C433C8;
        Sat,  2 Sep 2023 22:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693693077;
        bh=BE4AybiCagkoJ9LC2T87pW3Kz89BEX+xcBOEHw/h23I=;
        h=Date:To:From:Subject:From;
        b=UktudVepnefLTOuHBypt2cED7YrunTH53x8eGDWWpgDwOSBmU+wElItizzk6xARJy
         WwJhxvkMZwyeH5Xb3RKZ8nCbJJS3iElJzSknD7y3T8RfsEb/0OvSHVcGmZHFVgRH70
         fH5FGNUCih/1UxfArM3EymVA02TsYF4sOiIE/1nw=
Date:   Sat, 02 Sep 2023 15:17:57 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        pasha.tatashin@soleen.com, mgorman@techsingularity.net,
        linmiaohe@huawei.com, iamjoonsoo.kim@lge.com, david@redhat.com,
        hannes@cmpxchg.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-remove-stale-cma-guard-code.patch removed from -mm tree
Message-Id: <20230902221757.D2524C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: page_alloc: remove stale CMA guard code
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-stale-cma-guard-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: remove stale CMA guard code
Date: Thu, 24 Aug 2023 11:38:21 -0400

In the past, movable allocations could be disallowed from CMA through
PF_MEMALLOC_PIN.  As CMA pages are funneled through the MOVABLE pcplist,
this required filtering that cornercase during allocations, such that
pinnable allocations wouldn't accidentally get a CMA page.

However, since 8e3560d963d2 ("mm: honor PF_MEMALLOC_PIN for all movable
pages"), PF_MEMALLOC_PIN automatically excludes __GFP_MOVABLE.  Once
again, MOVABLE implies CMA is allowed.

Remove the stale filtering code.  Also remove a stale comment that was
introduced as part of the filtering code, because the filtering let
order-0 pages fall through to the buddy allocator.  See 1d91df85f399
("mm/page_alloc: handle a missing case for memalloc_nocma_{save/restore}
APIs") for context.  The comment's been obsolete since the introduction of
the explicit ALLOC_HIGHATOMIC flag in eb2e2b425c69 ("mm/page_alloc:
explicitly record high-order atomic allocations in alloc_flags").

Link: https://lkml.kernel.org/r/20230824153821.243148-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-stale-cma-guard-code
+++ a/mm/page_alloc.c
@@ -2641,12 +2641,6 @@ struct page *rmqueue_buddy(struct zone *
 	do {
 		page = NULL;
 		spin_lock_irqsave(&zone->lock, flags);
-		/*
-		 * order-0 request can reach here when the pcplist is skipped
-		 * due to non-CMA allocation context. HIGHATOMIC area is
-		 * reserved for high-order atomic allocation, so order-0
-		 * request should skip it.
-		 */
 		if (alloc_flags & ALLOC_HIGHATOMIC)
 			page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
 		if (!page) {
@@ -2780,17 +2774,10 @@ struct page *rmqueue(struct zone *prefer
 	WARN_ON_ONCE((gfp_flags & __GFP_NOFAIL) && (order > 1));
 
 	if (likely(pcp_allowed_order(order))) {
-		/*
-		 * MIGRATE_MOVABLE pcplist could have the pages on CMA area and
-		 * we need to skip it when CMA area isn't allowed.
-		 */
-		if (!IS_ENABLED(CONFIG_CMA) || alloc_flags & ALLOC_CMA ||
-				migratetype != MIGRATE_MOVABLE) {
-			page = rmqueue_pcplist(preferred_zone, zone, order,
-					migratetype, alloc_flags);
-			if (likely(page))
-				goto out;
-		}
+		page = rmqueue_pcplist(preferred_zone, zone, order,
+				       migratetype, alloc_flags);
+		if (likely(page))
+			goto out;
 	}
 
 	page = rmqueue_buddy(preferred_zone, zone, order, alloc_flags,
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

memcontrol-ensure-memcg-acquired-by-id-is-properly-set-up.patch

