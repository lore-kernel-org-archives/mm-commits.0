Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1567C07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:18:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C26BC61C98
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:18:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbhGFTVe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:21:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:55348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231753AbhGFTVe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:21:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7145061C7A;
        Tue,  6 Jul 2021 19:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599134;
        bh=CE8T/CrGp9Ny1XEEAhFfJ35sUA3NRkM8vMA+ZWQHIO4=;
        h=Date:From:To:Subject:From;
        b=PR7oy+EzvGCXn49KiVoOZzF7ew5DLjfzbNo1acvlUjeSipK3wRKE5xWKben2aB/aX
         STRouWeu8I4+QqF1OqlSU7Kq7cdyzkA9jh5n0igYLsQU9yMvG9+SytCft4MzNJLtzk
         wEyrLYVFmBtwhTaTaxqYH+JMxcz09zXnNCKGLzV8=
Date:   Tue, 06 Jul 2021 12:18:54 -0700
From:   akpm@linux-foundation.org
To:     mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        vbabka@suse.cz, vvghjk1234@gmail.com
Subject:  [merged]
 mm-compaction-fix-limit-in-fast_isolate_freepages.patch removed from -mm
 tree
Message-ID: <20210706191854.9qugYlzjd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: fix 'limit' in fast_isolate_freepages
has been removed from the -mm tree.  Its filename was
     mm-compaction-fix-limit-in-fast_isolate_freepages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wonhyuk Yang <vvghjk1234@gmail.com>
Subject: mm/compaction: fix 'limit' in fast_isolate_freepages

Because of 'min(1, ...)', fast_isolate_freepages set 'limit' to 0 or 1. 
This takes away the opportunities of find candinate pages.  So, by making
enough scans available, increases the probability of finding the
appropriate freepage.

Tested it on the thpscale and the results are as follows.

                                        5.12.0                 5.12.0
                                      valnilla                patched
Amean     fault-both-1       598.15 (   0.00%)      592.56 (   0.93%)
Amean     fault-both-3      1494.47 (   0.00%)     1514.35 (  -1.33%)
Amean     fault-both-5      2519.48 (   0.00%)     2471.76 (   1.89%)
Amean     fault-both-7      3173.85 (   0.00%)     3079.19 (   2.98%)
Amean     fault-both-12     8063.83 (   0.00%)     7858.29 (   2.55%)
Amean     fault-both-18     8781.20 (   0.00%)     7827.70 *  10.86%*
Amean     fault-both-24    12576.44 (   0.00%)    12250.20 (   2.59%)
Amean     fault-both-30    18503.27 (   0.00%)    17528.11 *   5.27%*
Amean     fault-both-32    16133.69 (   0.00%)    13874.24 *  14.00%*

                                           5.12.0         5.12.0
                                          vanilla        patched
Ops Compaction migrate scanned         6547133.00     5963901.00
Ops Compaction free scanned           32452453.00    26609101.00

                        5.12        5.12
                     vanilla     patched
Duration User          27.99       28.84
Duration System       244.08      236.76
Duration Elapsed       78.27       78.38

Link: https://lkml.kernel.org/r/20210626082443.22547-1-vvghjk1234@gmail.com
Fixes: 5a811889de10f ("mm, compaction: use free lists to quickly locate a migration target")
Signed-off-by: Wonhyuk Yang <vvghjk1234@gmail.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/compaction.c~mm-compaction-fix-limit-in-fast_isolate_freepages
+++ a/mm/compaction.c
@@ -1378,7 +1378,7 @@ static int next_search_order(struct comp
 static unsigned long
 fast_isolate_freepages(struct compact_control *cc)
 {
-	unsigned int limit = min(1U, freelist_scan_limit(cc) >> 1);
+	unsigned int limit = max(1U, freelist_scan_limit(cc) >> 1);
 	unsigned int nr_scanned = 0;
 	unsigned long low_pfn, min_pfn, highest = 0;
 	unsigned long nr_isolated = 0;
@@ -1490,11 +1490,11 @@ fast_isolate_freepages(struct compact_co
 		spin_unlock_irqrestore(&cc->zone->lock, flags);
 
 		/*
-		 * Smaller scan on next order so the total scan ig related
+		 * Smaller scan on next order so the total scan is related
 		 * to freelist_scan_limit.
 		 */
 		if (order_scanned >= limit)
-			limit = min(1U, limit >> 1);
+			limit = max(1U, limit >> 1);
 	}
 
 	if (!page) {
_

Patches currently in -mm which might be from vvghjk1234@gmail.com are


