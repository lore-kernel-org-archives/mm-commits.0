Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB7CFC433DB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:36:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BA5364F29
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:36:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhBYTgs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:36:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:41172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234854AbhBYTfE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:35:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A56AB64FBB;
        Thu, 25 Feb 2021 19:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280727;
        bh=EKinlxvREuyH/iajQTNkwXj+oQsGtcNf2krxPh7a8a8=;
        h=Date:From:To:Subject:From;
        b=i/wcH7eYYRgO61VydofoHmpFpLsyF07YEuKGrRAP5HaxWCOXhMzEpc/ZLWD++evsx
         PHxID+LWkNn9qEY3IpIiautvUe+uipNaoSyN6j2pXZ3u/51bfT3Xv2mDsYxyU933F4
         YfIJuRSTMAjcxwYGz8pa6SYoXRDK+19ONu6+jVTI=
Date:   Thu, 25 Feb 2021 11:18:47 -0800
From:   akpm@linux-foundation.org
To:     mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        vbabka@suse.cz, vvghjk1234@gmail.com
Subject:  [merged]
 mm-compactoin-fix-misbehaviors-of-fast_find_migrateblock.patch removed from
 -mm tree
Message-ID: <20210225191847.z_IRVJH8V%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: fix misbehaviors of fast_find_migrateblock()
has been removed from the -mm tree.  Its filename was
     mm-compactoin-fix-misbehaviors-of-fast_find_migrateblock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wonhyuk Yang <vvghjk1234@gmail.com>
Subject: mm/compaction: fix misbehaviors of fast_find_migrateblock()

In the fast_find_migrateblock(), it iterates ocer the freelist to find the
proper pageblock.  But there are some misbehaviors.

First, if the page we found is equal to cc->migrate_pfn, it is considered
that we didn't find a suitable pageblock.  Secondly, if the loop was
terminated because order is less than PAGE_ALLOC_COSTLY_ORDER, it could be
considered that we found a suitable one.  Thirdly, if the skip bit is set
on the page block and we goto continue, it doesn't check nr_scanned. 
Fourthly, if the page block's skip bit is set, it checks that page block
is the last of list, which is unnecessary.

Link: https://lkml.kernel.org/r/20210128130411.6125-1-vvghjk1234@gmail.com
Fixes: 70b44595eafe9 ("mm, compaction: use free lists to quickly locate a migration source")
Signed-off-by: Wonhyuk Yang <vvghjk1234@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

--- a/mm/compaction.c~mm-compactoin-fix-misbehaviors-of-fast_find_migrateblock
+++ a/mm/compaction.c
@@ -1698,6 +1698,7 @@ static unsigned long fast_find_migratebl
 	unsigned long pfn = cc->migrate_pfn;
 	unsigned long high_pfn;
 	int order;
+	bool found_block = false;
 
 	/* Skip hints are relied on to avoid repeats on the fast search */
 	if (cc->ignore_skip_hint)
@@ -1740,7 +1741,7 @@ static unsigned long fast_find_migratebl
 	high_pfn = pageblock_start_pfn(cc->migrate_pfn + distance);
 
 	for (order = cc->order - 1;
-	     order >= PAGE_ALLOC_COSTLY_ORDER && pfn == cc->migrate_pfn && nr_scanned < limit;
+	     order >= PAGE_ALLOC_COSTLY_ORDER && !found_block && nr_scanned < limit;
 	     order--) {
 		struct free_area *area = &cc->zone->free_area[order];
 		struct list_head *freelist;
@@ -1755,7 +1756,11 @@ static unsigned long fast_find_migratebl
 		list_for_each_entry(freepage, freelist, lru) {
 			unsigned long free_pfn;
 
-			nr_scanned++;
+			if (nr_scanned++ >= limit) {
+				move_freelist_tail(freelist, freepage);
+				break;
+			}
+
 			free_pfn = page_to_pfn(freepage);
 			if (free_pfn < high_pfn) {
 				/*
@@ -1764,12 +1769,8 @@ static unsigned long fast_find_migratebl
 				 * the list assumes an entry is deleted, not
 				 * reordered.
 				 */
-				if (get_pageblock_skip(freepage)) {
-					if (list_is_last(freelist, &freepage->lru))
-						break;
-
+				if (get_pageblock_skip(freepage))
 					continue;
-				}
 
 				/* Reorder to so a future search skips recent pages */
 				move_freelist_tail(freelist, freepage);
@@ -1777,15 +1778,10 @@ static unsigned long fast_find_migratebl
 				update_fast_start_pfn(cc, free_pfn);
 				pfn = pageblock_start_pfn(free_pfn);
 				cc->fast_search_fail = 0;
+				found_block = true;
 				set_pageblock_skip(freepage);
 				break;
 			}
-
-			if (nr_scanned >= limit) {
-				cc->fast_search_fail++;
-				move_freelist_tail(freelist, freepage);
-				break;
-			}
 		}
 		spin_unlock_irqrestore(&cc->zone->lock, flags);
 	}
@@ -1796,9 +1792,10 @@ static unsigned long fast_find_migratebl
 	 * If fast scanning failed then use a cached entry for a page block
 	 * that had free pages as the basis for starting a linear scan.
 	 */
-	if (pfn == cc->migrate_pfn)
+	if (!found_block) {
+		cc->fast_search_fail++;
 		pfn = reinit_migrate_pfn(cc);
-
+	}
 	return pfn;
 }
 
_

Patches currently in -mm which might be from vvghjk1234@gmail.com are


