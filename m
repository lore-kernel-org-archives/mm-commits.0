Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C58AEC433E6
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 00:39:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93C7F22AAB
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 00:39:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbhAXAjY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 23 Jan 2021 19:39:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:42708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbhAXAjY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 23 Jan 2021 19:39:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F34E7225AC;
        Sun, 24 Jan 2021 00:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611448723;
        bh=+hC47nH3mCB+d8QJjW+uNVXTmeNkpkjyTSe0KdamQ60=;
        h=Date:From:To:Subject:From;
        b=a0KV2jdVmBYq6cNaRUVnzkLH8cvEyY9uzQhN/GRccM0q8bD6IL/r6LSl5GzWygCjF
         BgzUZ78KJZh85iWNgZ0m0TWlP/kXFiFYZY/6IJGs7pOsjem86tYvdAelFGl/jS9siQ
         frDASJa/cvlmT5sLbhpWhYIBM5gxUCs0dhzo/GfE=
Date:   Sat, 23 Jan 2021 16:38:42 -0800
From:   akpm@linux-foundation.org
To:     mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        Vbabka@suse.cz, vvghjk1234@gmail.com
Subject:  +
 mm-compactoin-fix-edge-case-of-fast_find_migrateblock.patch added to -mm
 tree
Message-ID: <20210124003842.gk3BJOmCj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: fix edge case of fast_find_migrateblock()
has been added to the -mm tree.  Its filename is
     mm-compactoin-fix-edge-case-of-fast_find_migrateblock.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-compactoin-fix-edge-case-of-fast_find_migrateblock.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-compactoin-fix-edge-case-of-fast_find_migrateblock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <Vbabka@suse.cz>
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

mm-compactoin-fix-edge-case-of-fast_find_migrateblock.patch

