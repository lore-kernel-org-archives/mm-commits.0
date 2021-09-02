Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D8D3C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:59:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18AAD6056B
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:59:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347773AbhIBWAu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 18:00:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347662AbhIBWAu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 18:00:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DCA9603E9;
        Thu,  2 Sep 2021 21:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619991;
        bh=7O+Y7uKtMnoyvQ6qkj/JOV9zunwD4RBXoRgurZK9Q5M=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=SZeM/gcIXMBS5Rt7mam/fIVYvVbbQID+WAao9OLC8S7IfD9BqwvS4Z0nZyKeI1Wyw
         dqd00EgNejTTey4pYIOOhJRCd6Z5HOhAZNGBwB3zpA2Z9wyhH++Xeddc0JtXdPprSo
         as1oMqslCU0ADzrBYeN+8m6/OYrqOuEW3XjuM0Eg=
Date:   Thu, 02 Sep 2021 14:59:50 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexs@kernel.org, apopple@nvidia.com,
        axboe@kernel.dk, david@redhat.com, hannes@cmpxchg.org,
        hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com,
        jhubbard@nvidia.com, linmiaohe@huawei.com, linux-mm@kvack.org,
        mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org,
        shli@fb.com, torvalds@linux-foundation.org, vbabka@suse.cz,
        willy@infradead.org, yuzhao@google.com
Subject:  [patch 186/212] mm/vmscan: add 'else' to remove
 check_pending label
Message-ID: <20210902215950.YUtooNhoK%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/vmscan: add 'else' to remove check_pending label

We could add 'else' to remove the somewhat odd check_pending label to make
code core succinct.

Link: https://lkml.kernel.org/r/20210717065911.61497-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Shaohua Li <shli@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-add-else-to-remove-check_pending-label
+++ a/mm/vmscan.c
@@ -3578,18 +3578,14 @@ static bool throttle_direct_reclaim(gfp_
 	 * blocked waiting on the same lock. Instead, throttle for up to a
 	 * second before continuing.
 	 */
-	if (!(gfp_mask & __GFP_FS)) {
+	if (!(gfp_mask & __GFP_FS))
 		wait_event_interruptible_timeout(pgdat->pfmemalloc_wait,
 			allow_direct_reclaim(pgdat), HZ);
+	else
+		/* Throttle until kswapd wakes the process */
+		wait_event_killable(zone->zone_pgdat->pfmemalloc_wait,
+			allow_direct_reclaim(pgdat));
 
-		goto check_pending;
-	}
-
-	/* Throttle until kswapd wakes the process */
-	wait_event_killable(zone->zone_pgdat->pfmemalloc_wait,
-		allow_direct_reclaim(pgdat));
-
-check_pending:
 	if (fatal_signal_pending(current))
 		return true;
 
_
