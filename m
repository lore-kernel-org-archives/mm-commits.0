Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DC8CEE49A8
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:42:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbjHUUmj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbjHUUmF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:42:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B72718B
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:41:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A945864467
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:41:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 053CCC433C8;
        Mon, 21 Aug 2023 20:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650462;
        bh=YLNLwR70NJwV1gNz76W43xG9uowBqt62IxzLbth9Mq4=;
        h=Date:To:From:Subject:From;
        b=enDrlQd2YLCQGKmMMYqLWB/rkXvxOyJxCKL0LEP+D34eIXCzm4Q3r/aqGSBAChpFZ
         Lb4k8BJXseurfjBilVeHXCKdcGS4nn9FXGXCLElrYkgC2P7qmljfvuY0hYPhQatwYT
         kCSJkAJ4vgr36GWcXHvg0HzdzCXuSL50FbQokPp4=
Date:   Mon, 21 Aug 2023 13:41:01 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mgorman@techsingularity.net, david@redhat.com,
        baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-use-get_pfnblock_migratetype-to-avoid-extra-page_to_pfn.patch removed from -mm tree
Message-Id: <20230821204102.053CCC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: use get_pfnblock_migratetype to avoid extra page_to_pfn
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-use-get_pfnblock_migratetype-to-avoid-extra-page_to_pfn.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/page_alloc: use get_pfnblock_migratetype to avoid extra page_to_pfn
Date: Fri, 11 Aug 2023 19:59:45 +0800

We have get_pageblock_migratetype and get_pfnblock_migratetype to get
migratetype of page.  get_pfnblock_migratetype accepts both page and pfn
from caller while get_pageblock_migratetype only accept page and get pfn
with page_to_pfn from page.

In case we already record pfn of page, we can simply call
get_pfnblock_migratetype to avoid a page_to_pfn.

Link: https://lkml.kernel.org/r/20230811115945.3423894-3-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-use-get_pfnblock_migratetype-to-avoid-extra-page_to_pfn
+++ a/mm/page_alloc.c
@@ -813,7 +813,7 @@ static inline void __free_one_page(struc
 			 * pageblock isolation could cause incorrect freepage or CMA
 			 * accounting or HIGHATOMIC accounting.
 			 */
-			int buddy_mt = get_pageblock_migratetype(buddy);
+			int buddy_mt = get_pfnblock_migratetype(buddy, buddy_pfn);
 
 			if (migratetype != buddy_mt
 					&& (!migratetype_is_mergeable(migratetype) ||
@@ -889,7 +889,7 @@ int split_free_page(struct page *free_pa
 		goto out;
 	}
 
-	mt = get_pageblock_migratetype(free_page);
+	mt = get_pfnblock_migratetype(free_page, free_page_pfn);
 	if (likely(!is_migrate_isolate(mt)))
 		__mod_zone_freepage_state(zone, -(1UL << order), mt);
 
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


