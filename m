Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F258C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:33:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355543AbiCYBe5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357520AbiCYBdP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C559EBF95D
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E6F6B82726
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EBA0C340EC;
        Fri, 25 Mar 2022 01:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171894;
        bh=aBwGkOudQGYtloe/CQ0TRIBlQ53SF8utHqOx0kzOhpA=;
        h=Date:To:From:Subject:From;
        b=b8qZDpONq22M2MVP1hCaO2pTzLUrXVmQVX8bQ7hrta9s7oYnAqsOyl/EWBCa7yQv4
         an+Sfcp91SBW3Nzk+gzUI/Ej0Vt/tpk57x3zDTuB1IR0R6f9IFPAen4EsvmkmQ/Glg
         hdRvZ0+0Y+zQCuHoNOYWqVtkSlPvfYOXY0Vvnz0U=
Date:   Thu, 24 Mar 2022 18:31:33 -0700
To:     mm-commits@vger.kernel.org, weixugc@google.com, vbabka@suse.cz,
        shakeelb@google.com, rientjes@google.com, mhocko@kernel.org,
        mgorman@techsingularity.net, hughd@google.com, gthelen@google.com,
        edumazet@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-page_alloc-call-check_new_pages-while-zone-spinlock-is-not-held.patch removed from -mm tree
Message-Id: <20220325013134.2EBA0C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: call check_new_pages() while zone spinlock is not held
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-call-check_new_pages-while-zone-spinlock-is-not-held.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Eric Dumazet <edumazet@google.com>
Subject: mm/page_alloc: call check_new_pages() while zone spinlock is not held

For high order pages not using pcp, rmqueue() is currently calling the
costly check_new_pages() while zone spinlock is held, and hard irqs
masked.

This is not needed, we can release the spinlock sooner to reduce zone
spinlock contention.

Note that after this patch, we call __mod_zone_freepage_state() before
deciding to leak the page because it is in bad state.

Link: https://lkml.kernel.org/r/20220304170215.1868106-1-eric.dumazet@gmail.com
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-call-check_new_pages-while-zone-spinlock-is-not-held
+++ a/mm/page_alloc.c
@@ -3665,10 +3665,10 @@ struct page *rmqueue(struct zone *prefer
 	 * allocate greater than order-1 page units with __GFP_NOFAIL.
 	 */
 	WARN_ON_ONCE((gfp_flags & __GFP_NOFAIL) && (order > 1));
-	spin_lock_irqsave(&zone->lock, flags);
 
 	do {
 		page = NULL;
+		spin_lock_irqsave(&zone->lock, flags);
 		/*
 		 * order-0 request can reach here when the pcplist is skipped
 		 * due to non-CMA allocation context. HIGHATOMIC area is
@@ -3680,15 +3680,15 @@ struct page *rmqueue(struct zone *prefer
 			if (page)
 				trace_mm_page_alloc_zone_locked(page, order, migratetype);
 		}
-		if (!page)
+		if (!page) {
 			page = __rmqueue(zone, order, migratetype, alloc_flags);
-	} while (page && check_new_pages(page, order));
-	if (!page)
-		goto failed;
-
-	__mod_zone_freepage_state(zone, -(1 << order),
-				  get_pcppage_migratetype(page));
-	spin_unlock_irqrestore(&zone->lock, flags);
+			if (!page)
+				goto failed;
+		}
+		__mod_zone_freepage_state(zone, -(1 << order),
+					  get_pcppage_migratetype(page));
+		spin_unlock_irqrestore(&zone->lock, flags);
+	} while (check_new_pages(page, order));
 
 	__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
 	zone_statistics(preferred_zone, zone, 1);
_

Patches currently in -mm which might be from edumazet@google.com are


