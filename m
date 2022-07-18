Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 030DAC43334
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:18:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbiGRAST (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233184AbiGRARm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:17:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF0CA13D19
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:17:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 955AAB80EE9
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:17:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39842C341CA;
        Mon, 18 Jul 2022 00:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103437;
        bh=Wfh1KtHlxq9Ly5Ve+fc8L+gdewB2dn31PY9xQQ8mQyc=;
        h=Date:To:From:Subject:From;
        b=exumSosm5jL0mx26CWm94irPL3vCtiK9E8zi3Ujfy4kb1F0f7dVMZMKCMs01RiOZJ
         FrVYseNVqLwmixcmT5BC3sjF+oUso1RqMr+nnLloUNlr+Tq6zvyfuzEjoFftVI0Gzv
         3On0uVSKsGt3Cbl28K7OlFuTM1pIvNXmWlM1j5A4=
Date:   Sun, 17 Jul 2022 17:17:16 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, vbabka@suse.cz,
        nsaenzju@redhat.com, mtosatti@redhat.com, m.szyprowski@samsung.com,
        minchan@kernel.org, mhocko@kernel.org, hughd@google.com,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-remove-mistaken-page-==-null-check-in-rmqueue.patch removed from -mm tree
Message-Id: <20220718001717.39842C341CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: remove mistaken page == NULL check in rmqueue
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-mistaken-page-==-null-check-in-rmqueue.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: remove mistaken page == NULL check in rmqueue
Date: Fri, 24 Jun 2022 13:54:20 +0100

If a page allocation fails, the ZONE_BOOSTER_WATERMARK should be tested,
cleared and kswapd woken whether the allocation attempt was via the PCP or
directly via the buddy list.

Remove the page == NULL so the ZONE_BOOSTED_WATERMARK bit is checked
unconditionally.  As it is unlikely that ZONE_BOOSTED_WATERMARK is set,
mark the branch accordingly.

Link: https://lkml.kernel.org/r/20220624125423.6126-5-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Yu Zhao <yuzhao@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-mistaken-page-==-null-check-in-rmqueue
+++ a/mm/page_alloc.c
@@ -3781,12 +3781,10 @@ struct page *rmqueue(struct zone *prefer
 
 	page = rmqueue_buddy(preferred_zone, zone, order, alloc_flags,
 							migratetype);
-	if (unlikely(!page))
-		return NULL;
 
 out:
 	/* Separate test+clear to avoid unnecessary atomics */
-	if (test_bit(ZONE_BOOSTED_WATERMARK, &zone->flags)) {
+	if (unlikely(test_bit(ZONE_BOOSTED_WATERMARK, &zone->flags))) {
 		clear_bit(ZONE_BOOSTED_WATERMARK, &zone->flags);
 		wakeup_kswapd(zone, 0, 0, zone_idx(zone));
 	}
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


