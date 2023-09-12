Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6137CA0EF2
	for <mm-commits@archiver.kernel.org>; Tue, 12 Sep 2023 16:04:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236142AbjILQEc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Sep 2023 12:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235340AbjILQEb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Sep 2023 12:04:31 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0805110DE
        for <mm-commits@vger.kernel.org>; Tue, 12 Sep 2023 09:04:28 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 967BFC433C8;
        Tue, 12 Sep 2023 16:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694534667;
        bh=jzn3QrWbUN2/y6ClZJ5F+vaR36oIRW1GGd3SRuhPSEI=;
        h=Date:To:From:Subject:From;
        b=jR8UCIc+YVNya6zg5YM6tz1AuqH5RqgAU1Cmllzwuk2VY1q0MJLV+8kKbQR87YLzL
         sK4qKVwzOzNVEcYaPLOMB6a5g6cEudTA//aK7m3WbgXf3bT4TIs8AVuqfc27/P2rES
         Yr4F+kSWiw0MyFFnm8YnEg2lbRwrLqTW3wfOEDME=
Date:   Tue, 12 Sep 2023 09:04:26 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com,
        wangkefeng.wang@huawei.com, vbabka@suse.cz,
        mgorman@techsingularity.net, linmiaohe@huawei.com,
        hannes@cmpxchg.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] mm-page_alloc-remove-pcppage-migratetype-caching-fix.patch removed from -mm tree
Message-Id: <20230912160427.967BFC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-page_alloc-remove-pcppage-migratetype-caching-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-pcppage-migratetype-caching-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-remove-pcppage-migratetype-caching-fix
Date: Mon Sep 11 02:40:43 PM PDT 2023

fix free_unref_page()

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-pcppage-migratetype-caching-fix
+++ a/mm/page_alloc.c
@@ -2429,7 +2429,7 @@ void free_unref_page(struct page *page,
 		 * must be rechecked.
 		 */
 		free_one_page(zone, page, pfn, order,
-			      get_pcppage_migratetype(page), FPI_NONE);
+			      get_pfnblock_migratetype(page, pfn), FPI_NONE);
 	}
 	pcp_trylock_finish(UP_flags);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch

