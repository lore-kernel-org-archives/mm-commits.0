Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EBD9C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 17 Feb 2022 01:27:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbiBQB1Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Feb 2022 20:27:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbiBQB1V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Feb 2022 20:27:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23B9C2E7E
        for <mm-commits@vger.kernel.org>; Wed, 16 Feb 2022 17:27:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F07961CAC
        for <mm-commits@vger.kernel.org>; Thu, 17 Feb 2022 01:27:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD014C004E1;
        Thu, 17 Feb 2022 01:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645061227;
        bh=SwqgJYPOMEPTFnBF9nLrxggrtKVkR5YBdzjqlbKMJ+Q=;
        h=Date:To:From:Subject:From;
        b=t+Rwv1rLrGCnTw/NFmNMwWklUgNprr2o2HMTjEX85dWCBcBFFIfELWiqDCKiJ8hOU
         ZA8gnvroTpyo8krq3hiZbCoY6K7mQ8Aeqke9zWXorwBhz9oA/QroIH9KEMq5Od0+b2
         vMLFtaepcB01T99mB73lRuCObCdBQoneIPsr/bJs=
Date:   Wed, 16 Feb 2022 17:27:06 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mhocko@kernel.org,
        dave.hansen@linux.intel.com, brouer@redhat.com, aaron.lu@intel.com,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-simplify-how-many-pages-are-selected-per-pcp-list-during-bulk-free.patch added to -mm tree
Message-Id: <20220217012706.DD014C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: simplify how many pages are selected per pcp list during bulk free
has been added to the -mm tree.  Its filename is
     mm-page_alloc-simplify-how-many-pages-are-selected-per-pcp-list-during-bulk-free.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-simplify-how-many-pages-are-selected-per-pcp-list-during-bulk-free.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-simplify-how-many-pages-are-selected-per-pcp-list-during-bulk-free.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: simplify how many pages are selected per pcp list during bulk free

free_pcppages_bulk() selects pages to free by round-robining between
lists.  Originally this was to evenly shrink pages by migratetype but
uneven freeing is inevitable due to high pages.  Simplify list selection
by starting with a list that definitely has pages on it in
free_unref_page_commit() and for drain, it does not matter where draining
starts as all pages are removed.

Link: https://lkml.kernel.org/r/20220217002227.5739-4-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Aaron Lu <aaron.lu@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   34 +++++++++++-----------------------
 1 file changed, 11 insertions(+), 23 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-simplify-how-many-pages-are-selected-per-pcp-list-during-bulk-free
+++ a/mm/page_alloc.c
@@ -1447,13 +1447,11 @@ static inline void prefetch_buddy(struct
  * count is the number of pages to free.
  */
 static void free_pcppages_bulk(struct zone *zone, int count,
-					struct per_cpu_pages *pcp)
+					struct per_cpu_pages *pcp,
+					int pindex)
 {
-	int pindex = 0;
 	int min_pindex = 0;
 	int max_pindex = NR_PCP_LISTS - 1;
-	int batch_free = 0;
-	int nr_freed = 0;
 	unsigned int order;
 	int prefetch_nr = READ_ONCE(pcp->batch);
 	bool isolated_pageblocks;
@@ -1467,16 +1465,10 @@ static void free_pcppages_bulk(struct zo
 	count = min(pcp->count, count);
 	while (count > 0) {
 		struct list_head *list;
+		int nr_pages;
 
-		/*
-		 * Remove pages from lists in a round-robin fashion. A
-		 * batch_free count is maintained that is incremented when an
-		 * empty list is encountered.  This is so more pages are freed
-		 * off fuller lists instead of spinning excessively around empty
-		 * lists
-		 */
+		/* Remove pages from lists in a round-robin fashion. */
 		do {
-			batch_free++;
 			if (++pindex > max_pindex)
 				pindex = min_pindex;
 			list = &pcp->lists[pindex];
@@ -1489,18 +1481,15 @@ static void free_pcppages_bulk(struct zo
 				min_pindex++;
 		} while (1);
 
-		/* This is the only non-empty list. Free them all. */
-		if (batch_free >= max_pindex - min_pindex)
-			batch_free = count;
-
 		order = pindex_to_order(pindex);
+		nr_pages = 1 << order;
 		BUILD_BUG_ON(MAX_ORDER >= (1<<NR_PCP_ORDER_WIDTH));
 		do {
 			page = list_last_entry(list, struct page, lru);
 			/* must delete to avoid corrupting pcp list */
 			list_del(&page->lru);
-			nr_freed += 1 << order;
-			count -= 1 << order;
+			count -= nr_pages;
+			pcp->count -= nr_pages;
 
 			if (bulkfree_pcp_prepare(page))
 				continue;
@@ -1524,9 +1513,8 @@ static void free_pcppages_bulk(struct zo
 				prefetch_buddy(page, order);
 				prefetch_nr--;
 			}
-		} while (count > 0 && --batch_free && !list_empty(list));
+		} while (count > 0 && !list_empty(list));
 	}
-	pcp->count -= nr_freed;
 
 	/*
 	 * local_lock_irq held so equivalent to spin_lock_irqsave for
@@ -3133,7 +3121,7 @@ void drain_zone_pages(struct zone *zone,
 	batch = READ_ONCE(pcp->batch);
 	to_drain = min(pcp->count, batch);
 	if (to_drain > 0)
-		free_pcppages_bulk(zone, to_drain, pcp);
+		free_pcppages_bulk(zone, to_drain, pcp, 0);
 	local_unlock_irqrestore(&pagesets.lock, flags);
 }
 #endif
@@ -3154,7 +3142,7 @@ static void drain_pages_zone(unsigned in
 
 	pcp = per_cpu_ptr(zone->per_cpu_pageset, cpu);
 	if (pcp->count)
-		free_pcppages_bulk(zone, pcp->count, pcp);
+		free_pcppages_bulk(zone, pcp->count, pcp, 0);
 
 	local_unlock_irqrestore(&pagesets.lock, flags);
 }
@@ -3435,7 +3423,7 @@ static void free_unref_page_commit(struc
 	if (pcp->count >= high) {
 		int batch = READ_ONCE(pcp->batch);
 
-		free_pcppages_bulk(zone, nr_pcp_free(pcp, high, batch), pcp);
+		free_pcppages_bulk(zone, nr_pcp_free(pcp, high, batch), pcp, pindex);
 	}
 }
 
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-fetch-the-correct-pcp-buddy-during-bulk-free.patch
mm-page_alloc-track-range-of-active-pcp-lists-during-bulk-free.patch
mm-page_alloc-simplify-how-many-pages-are-selected-per-pcp-list-during-bulk-free.patch
mm-page_alloc-drain-the-requested-list-first-during-bulk-free.patch
mm-page_alloc-free-pages-in-a-single-pass-during-bulk-free.patch
mm-page_alloc-limit-number-of-high-order-pages-on-pcp-during-bulk-free.patch

