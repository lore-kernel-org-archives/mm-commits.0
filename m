Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D108C433E6
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 02:11:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 212BC22D49
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 02:11:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbhAQCL1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 16 Jan 2021 21:11:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:41492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727786AbhAQCL1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 16 Jan 2021 21:11:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71F1D22CAD;
        Sun, 17 Jan 2021 02:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610849446;
        bh=CnmqanK2N+flvpq83mPWydj0/BNheX7WRQMUElRPbNI=;
        h=Date:From:To:Subject:From;
        b=s2+rYXh2xTsygDM37bXT+7AkFznOMTo4M4qPlhV+8e/J6XjX3KV4Lmh8b3ICrG5zG
         XjKnpml5Kf5AEn1lgGShEnbmr51PVPeFSLGdS7ahDQ3ubuHLPzkQwiXXxV6qLDi1wr
         06zXKwpBwaVXBy5RwRMRpA6Dr+bUpWpb5FUNimbw=
Date:   Sat, 16 Jan 2021 18:10:46 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, liu.hailong6@zte.com.cn,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-page_alloc-add-a-missing-mm_page_alloc_zone_locked-tracepoint.patch
 removed from -mm tree
Message-ID: <20210117021046.3bdhyj6m_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: add a missing mm_page_alloc_zone_locked() tracepoint
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-add-a-missing-mm_page_alloc_zone_locked-tracepoint.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hailong liu <liu.hailong6@zte.com.cn>
Subject: mm/page_alloc: add a missing mm_page_alloc_zone_locked() tracepoint

The trace point *trace_mm_page_alloc_zone_locked()* in __rmqueue() does
not currently cover all branches.  Add the missing tracepoint and check
the page before do that.

[akpm@linux-foundation.org: use IS_ENABLED() to suppress warning]
Link: https://lkml.kernel.org/r/20201228132901.41523-1-carver4lio@163.com
Signed-off-by: Hailong liu <liu.hailong6@zte.com.cn>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-add-a-missing-mm_page_alloc_zone_locked-tracepoint
+++ a/mm/page_alloc.c
@@ -2862,20 +2862,20 @@ __rmqueue(struct zone *zone, unsigned in
 {
 	struct page *page;
 
-#ifdef CONFIG_CMA
-	/*
-	 * Balance movable allocations between regular and CMA areas by
-	 * allocating from CMA when over half of the zone's free memory
-	 * is in the CMA area.
-	 */
-	if (alloc_flags & ALLOC_CMA &&
-	    zone_page_state(zone, NR_FREE_CMA_PAGES) >
-	    zone_page_state(zone, NR_FREE_PAGES) / 2) {
-		page = __rmqueue_cma_fallback(zone, order);
-		if (page)
-			return page;
+	if (IS_ENABLED(CONFIG_CMA)) {
+		/*
+		 * Balance movable allocations between regular and CMA areas by
+		 * allocating from CMA when over half of the zone's free memory
+		 * is in the CMA area.
+		 */
+		if (alloc_flags & ALLOC_CMA &&
+		    zone_page_state(zone, NR_FREE_CMA_PAGES) >
+		    zone_page_state(zone, NR_FREE_PAGES) / 2) {
+			page = __rmqueue_cma_fallback(zone, order);
+			if (page)
+				goto out;
+		}
 	}
-#endif
 retry:
 	page = __rmqueue_smallest(zone, order, migratetype);
 	if (unlikely(!page)) {
@@ -2886,8 +2886,9 @@ retry:
 								alloc_flags))
 			goto retry;
 	}
-
-	trace_mm_page_alloc_zone_locked(page, order, migratetype);
+out:
+	if (page)
+		trace_mm_page_alloc_zone_locked(page, order, migratetype);
 	return page;
 }
 
_

Patches currently in -mm which might be from liu.hailong6@zte.com.cn are


