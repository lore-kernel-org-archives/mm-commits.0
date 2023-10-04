Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8474AE7C4F4
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:17:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233619AbjJDURb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232977AbjJDUR3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:17:29 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F033C6
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:17:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C70C433C8;
        Wed,  4 Oct 2023 20:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450645;
        bh=kZN/SH/TktqtNqFuoT04uB0HUEU99n+59Q+52ptMCiQ=;
        h=Date:To:From:Subject:From;
        b=SzwToXRxVroB7VDzmZzIENiOVyeFgmsaQ6eAJPu+daNWOj2016/ZDwmVgjBhqsy64
         yqZUSFe6JnQEtXHNAiCUvCoPkE59Df4JaBwfdoBiAi2EjM9RZvqy8Q7dgU5hQmwnB1
         GTrZ0ge/Ie1Iqyjk3Vl/d1xz0VNVwBZZYfcUMhPI=
Date:   Wed, 04 Oct 2023 13:17:24 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mgorman@techsingularity.net, david@redhat.com,
        baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-correctly-return-failure-with-bogus-compound_order-in-strict-mode.patch removed from -mm tree
Message-Id: <20231004201725.91C70C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/compaction: correctly return failure with bogus compound_order in strict mode
has been removed from the -mm tree.  Its filename was
     mm-compaction-correctly-return-failure-with-bogus-compound_order-in-strict-mode.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/compaction: correctly return failure with bogus compound_order in strict mode
Date: Fri, 1 Sep 2023 23:51:38 +0800

In strict mode, we should return 0 if there is any hole in pageblock.  If
we successfully isolated pages at beginning at pageblock and then have a
bogus compound_order outside pageblock in next page.  We will abort search
loop with blockpfn > end_pfn.  Although we will limit blockpfn to end_pfn,
we will treat it as a successful isolation in strict mode as blockpfn is
not < end_pfn and return partial isolated pages.  Then
isolate_freepages_range may success unexpectly with hole in isolated
range.

Link: https://lkml.kernel.org/r/20230901155141.249860-4-shikemeng@huaweicloud.com
Fixes: 9fcd6d2e052e ("mm, compaction: skip compound pages by order in free scanner")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/compaction.c~mm-compaction-correctly-return-failure-with-bogus-compound_order-in-strict-mode
+++ a/mm/compaction.c
@@ -626,11 +626,12 @@ static unsigned long isolate_freepages_b
 		if (PageCompound(page)) {
 			const unsigned int order = compound_order(page);
 
-			if (likely(order <= MAX_ORDER)) {
+			if (blockpfn + (1UL << order) <= end_pfn) {
 				blockpfn += (1UL << order) - 1;
 				page += (1UL << order) - 1;
 				nr_scanned += (1UL << order) - 1;
 			}
+
 			goto isolate_fail;
 		}
 
@@ -678,8 +679,7 @@ isolate_fail:
 		spin_unlock_irqrestore(&cc->zone->lock, flags);
 
 	/*
-	 * There is a tiny chance that we have read bogus compound_order(),
-	 * so be careful to not go outside of the pageblock.
+	 * Be careful to not go outside of the pageblock.
 	 */
 	if (unlikely(blockpfn > end_pfn))
 		blockpfn = end_pfn;
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-page_alloc-correct-start-page-when-guard-page-debug-is-enabled.patch
mm-page_alloc-remove-unnecessary-check-in-break_down_buddy_pages.patch
mm-page_alloc-remove-unnecessary-next_page-in-break_down_buddy_pages.patch

