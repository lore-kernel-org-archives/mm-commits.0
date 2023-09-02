Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABEB0C71153
	for <mm-commits@archiver.kernel.org>; Sat,  2 Sep 2023 22:38:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235066AbjIBWif (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 2 Sep 2023 18:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjIBWif (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 2 Sep 2023 18:38:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E2B1A7
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 15:38:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B814A60EE9
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 22:38:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA25C433C8;
        Sat,  2 Sep 2023 22:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693694311;
        bh=ghawwxtUOiUCBLv4uJBUAmXkhj31MXMgSs2uN85tnpI=;
        h=Date:To:From:Subject:From;
        b=P1htQ7s1EemrKPsd5F4Fe1A6TtXt8PjhevQrMq5zR9HB4I8/DyJi4oe9aius8/myI
         0eOZ0fAAXqzmhW7V74wFIraHtIJjsWjFgDzdoLPABgfxADupIPcUrXChh/7ugKGMfN
         ujUqrpetlV5tdPBKdl8n64h3G4BIKZAJK3fhCVCM=
Date:   Sat, 02 Sep 2023 15:38:30 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mgorman@techsingularity.net, david@redhat.com,
        baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-correctly-return-failure-with-bogus-compound_order-in-strict-mode.patch added to mm-unstable branch
Message-Id: <20230902223831.1BA25C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: correctly return failure with bogus compound_order in strict mode
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-correctly-return-failure-with-bogus-compound_order-in-strict-mode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-correctly-return-failure-with-bogus-compound_order-in-strict-mode.patch

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

mm-compaction-use-correct-list-in-move_freelist_head-tail.patch
mm-compaction-call-list_is_first-last-more-intuitively-in-move_freelist_head-tail.patch
mm-compaction-correctly-return-failure-with-bogus-compound_order-in-strict-mode.patch
mm-compaction-remove-repeat-compact_blockskip_flush-check-in-reset_isolation_suitable.patch
mm-compaction-improve-comment-of-is_via_compact_memory.patch
mm-compaction-factor-out-code-to-test-if-we-should-run-compaction-for-target-order.patch

