Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04317C433EF
	for <mm-commits@archiver.kernel.org>; Sat,  5 Mar 2022 00:34:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbiCEAex (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Mar 2022 19:34:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiCEAew (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2022 19:34:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CCFBA88BB
        for <mm-commits@vger.kernel.org>; Fri,  4 Mar 2022 16:34:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F34E8B82A4D
        for <mm-commits@vger.kernel.org>; Sat,  5 Mar 2022 00:34:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4DFC340E9;
        Sat,  5 Mar 2022 00:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646440440;
        bh=fKVLsqwChHXn/zkMCV3NM3OnXO25rClHuD4A6H6HYX0=;
        h=Date:To:From:Subject:From;
        b=0BPSTMyMUMSXd93mbTbNX3hUCdMK08kfNbrvC32U15bzgaeGSblwPhCBNobcbDKvp
         7zvZktsEqiZprL3qarnlv/HC4qg1Wqiu8AeUy2zSSMAeAWpixJ7ZY2tF979MMK/ebb
         IOCIoH+2SPvdPZIsqQQQh5hunr+pttqL6wKYtUwI=
Date:   Fri, 04 Mar 2022 16:33:59 -0800
To:     mm-commits@vger.kernel.org, weixugc@google.com, vbabka@suse.cz,
        shakeelb@google.com, rientjes@google.com, mhocko@kernel.org,
        mgorman@techsingularity.net, hughd@google.com, gthelen@google.com,
        edumazet@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-call-check_new_pages-while-zone-spinlock-is-not-held.patch added to -mm tree
Message-Id: <20220305003400.8B4DFC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: call check_new_pages() while zone spinlock is not held
has been added to the -mm tree.  Its filename is
     mm-page_alloc-call-check_new_pages-while-zone-spinlock-is-not-held.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-call-check_new_pages-while-zone-spinlock-is-not-held.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-call-check_new_pages-while-zone-spinlock-is-not-held.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-call-check_new_pages-while-zone-spinlock-is-not-held
+++ a/mm/page_alloc.c
@@ -3668,10 +3668,10 @@ struct page *rmqueue(struct zone *prefer
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
@@ -3683,15 +3683,15 @@ struct page *rmqueue(struct zone *prefer
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

mm-page_alloc-call-check_new_pages-while-zone-spinlock-is-not-held.patch

