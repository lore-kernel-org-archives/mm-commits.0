Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3169BC433DB
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jan 2021 02:49:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F20E1206A1
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jan 2021 02:49:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbhA0Csj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Jan 2021 21:48:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:59472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404292AbhAZTkb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 26 Jan 2021 14:40:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DD1420DD4;
        Tue, 26 Jan 2021 19:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611689990;
        bh=XXaaOEiAFDhfSXf6PYS/tfDyJI8G2TLNRNXrN04gkGc=;
        h=Date:From:To:Subject:From;
        b=1o1qAkbLvaA8k43u/WRn4N0iR2HdbJ50eKfVeenM3LlLrkq8ewjqUvR7HZ2Gc9cof
         Q+5FddyC2yvEP1gzZVY/kRpoDzx5xdBK5Ht6ADKVeVngI32gCcK9ji02JtG1Ajo+nA
         vIheYveplsA9F7ufq2T1QYPcYvdUl9g4Vw9I6kGs=
Date:   Tue, 26 Jan 2021 11:39:49 -0800
From:   akpm@linux-foundation.org
To:     mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        vbabka@suse.cz, vvghjk1234@gmail.com
Subject:  [to-be-updated]
 mm-compactoin-fix-edge-case-of-fast_find_migrateblock.patch removed from
 -mm tree
Message-ID: <20210126193949.efy12Briy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: fix edge case of fast_find_migrateblock()
has been removed from the -mm tree.  Its filename was
     mm-compactoin-fix-edge-case-of-fast_find_migrateblock.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Wonhyuk Yang <vvghjk1234@gmail.com>
Subject: mm/compaction: fix edge case of fast_find_migrateblock()

In the fast_find_migrateblock(), It iterate freelist to find proper
pageblock.  But there are two edge cases.  First, if the page we found is
equal to cc->migrate_pfn, it is considered that we didn't found suitable
pageblock.  Second, if the loop was terminated because order is less than
PAGE_ALLOC_COSTLY_ORDER, it could be considered that we found suitable
one.

Link: https://lkml.kernel.org/r/20210123154320.24278-1-vvghjk1234@gmail.com
Fixes: 70b44595eafe9 ("mm, compaction: use free lists to quickly locate a migration source")
Signed-off-by: Wonhyuk Yang <vvghjk1234@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/compaction.c~mm-compactoin-fix-edge-case-of-fast_find_migrateblock
+++ a/mm/compaction.c
@@ -1739,8 +1739,8 @@ static unsigned long fast_find_migratebl
 		distance >>= 2;
 	high_pfn = pageblock_start_pfn(cc->migrate_pfn + distance);
 
-	for (order = cc->order - 1;
-	     order >= PAGE_ALLOC_COSTLY_ORDER && pfn == cc->migrate_pfn && nr_scanned < limit;
+	for (order = cc->order - 1, pfn = high_pfn;
+	     order >= PAGE_ALLOC_COSTLY_ORDER && pfn == high_pfn && nr_scanned < limit;
 	     order--) {
 		struct free_area *area = &cc->zone->free_area[order];
 		struct list_head *freelist;
@@ -1782,7 +1782,6 @@ static unsigned long fast_find_migratebl
 			}
 
 			if (nr_scanned >= limit) {
-				cc->fast_search_fail++;
 				move_freelist_tail(freelist, freepage);
 				break;
 			}
@@ -1796,9 +1795,10 @@ static unsigned long fast_find_migratebl
 	 * If fast scanning failed then use a cached entry for a page block
 	 * that had free pages as the basis for starting a linear scan.
 	 */
-	if (pfn == cc->migrate_pfn)
+	if (pfn == high_pfn) {
+		cc->fast_search_fail++;
 		pfn = reinit_migrate_pfn(cc);
-
+	}
 	return pfn;
 }
 
_

Patches currently in -mm which might be from vvghjk1234@gmail.com are


