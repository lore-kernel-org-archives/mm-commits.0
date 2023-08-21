Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6915EE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:41:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjHUUlD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbjHUUk1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBFC6E64
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DCCE64B19
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6B9C433C8;
        Mon, 21 Aug 2023 20:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650399;
        bh=lta4GeKC22zXBCumaNUgfgl8wyoGOTyGTTapMVNSSxY=;
        h=Date:To:From:Subject:From;
        b=WXbyOAGWpL7bbiKuDU+GgJ4zQxdyx5PwkpnAz2Vy2UHiamZaPK0wNNhbXeu7gPQ0B
         z39T+S4hglJGY1nAQfKrdc1H4H4KnfqQh39iSbVq48mCrdGm6HS9JXM4Vj+qaxRTXq
         W9VqRnMzVWOrTURr9CCoVMbXeFjPlA0V3wvqShng=
Date:   Mon, 21 Aug 2023 13:39:59 -0700
To:     mm-commits@vger.kernel.org, shikemeng@huawei.com,
        mgorman@techsingularity.net, david@redhat.com,
        baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-set-compact_cached_free_pfn-correctly-in-update_pageblock_skip.patch removed from -mm tree
Message-Id: <20230821203959.CF6B9C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/compaction: set compact_cached_free_pfn correctly in update_pageblock_skip
has been removed from the -mm tree.  Its filename was
     mm-compaction-set-compact_cached_free_pfn-correctly-in-update_pageblock_skip.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/compaction: set compact_cached_free_pfn correctly in update_pageblock_skip
Date: Thu, 3 Aug 2023 17:48:58 +0800

Patch series "Fixes and cleanups to compaction", v2.

This series contains random fixes and cleanups to free page isolation in
compaction.  This is based on another compact series[1].  More details can
be found in respective patches.


This patch (of 4):

We will set skip to page block of block_start_pfn, it's more reasonable to
set compact_cached_free_pfn to page block before the block_start_pfn.

Link: https://lkml.kernel.org/r/20230803094901.2915942-1-shikemeng@huaweicloud.com
Link: https://lkml.kernel.org/r/20230803094901.2915942-2-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Kemeng Shi <shikemeng@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-set-compact_cached_free_pfn-correctly-in-update_pageblock_skip
+++ a/mm/compaction.c
@@ -1717,7 +1717,8 @@ static void isolate_freepages(struct com
 
 		/* Update the skip hint if the full pageblock was scanned */
 		if (isolate_start_pfn == block_end_pfn)
-			update_pageblock_skip(cc, page, block_start_pfn);
+			update_pageblock_skip(cc, page, block_start_pfn -
+					      pageblock_nr_pages);
 
 		/* Are enough freepages isolated? */
 		if (cc->nr_freepages >= cc->nr_migratepages) {
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


