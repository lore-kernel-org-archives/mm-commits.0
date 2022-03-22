Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C35AC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:44:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbiCVVp3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236393AbiCVVpW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:45:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4759213F2C
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:43:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF5DEB81DB5
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:43:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B20C340EC;
        Tue, 22 Mar 2022 21:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985416;
        bh=oTGU3v+FDaYpYNMTFZCrhPgnhnewJiycMKKjLxSu9UU=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=w23Cyq1+EgB/5f5QLoQy7WpBKbgeT+xcpWc9zaWc8A9DZ4uCvUSig2l54Hce2lU7p
         lxmVG1ncXorc9wcKMux3+u2AuNQip0ZNvR8xkrF3V9EsqpMsah0XAJqJSOxoKv5ejV
         bVPjb9TRKj9RgdRKBzTu+2D5zYxbl5EREcV+DNZw=
Date:   Tue, 22 Mar 2022 14:43:36 -0700
To:     vbabka@suse.cz, mhocko@kernel.org, dave.hansen@linux.intel.com,
        brouer@redhat.com, aaron.lu@intel.com, mgorman@techsingularity.net,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 100/227] mm/page_alloc: simplify how many pages are selected per pcp list during bulk free
Message-Id: <20220322214336.94B20C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
Tested-by: Aaron Lu <aaron.lu@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   34 +++++++++++-----------------------
 1 file changed, 11 insertions(+), 23 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-simplify-how-many-pages-are-selected-per-pcp-list-during-bulk-free
+++ a/mm/page_alloc.c
@@ -1444,13 +1444,11 @@ static inline void prefetch_buddy(struct
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
@@ -1464,16 +1462,10 @@ static void free_pcppages_bulk(struct zo
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
@@ -1486,18 +1478,15 @@ static void free_pcppages_bulk(struct zo
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
@@ -1521,9 +1510,8 @@ static void free_pcppages_bulk(struct zo
 				prefetch_buddy(page, order);
 				prefetch_nr--;
 			}
-		} while (count > 0 && --batch_free && !list_empty(list));
+		} while (count > 0 && !list_empty(list));
 	}
-	pcp->count -= nr_freed;
 
 	/*
 	 * local_lock_irq held so equivalent to spin_lock_irqsave for
@@ -3077,7 +3065,7 @@ void drain_zone_pages(struct zone *zone,
 	batch = READ_ONCE(pcp->batch);
 	to_drain = min(pcp->count, batch);
 	if (to_drain > 0)
-		free_pcppages_bulk(zone, to_drain, pcp);
+		free_pcppages_bulk(zone, to_drain, pcp, 0);
 	local_unlock_irqrestore(&pagesets.lock, flags);
 }
 #endif
@@ -3098,7 +3086,7 @@ static void drain_pages_zone(unsigned in
 
 	pcp = per_cpu_ptr(zone->per_cpu_pageset, cpu);
 	if (pcp->count)
-		free_pcppages_bulk(zone, pcp->count, pcp);
+		free_pcppages_bulk(zone, pcp->count, pcp, 0);
 
 	local_unlock_irqrestore(&pagesets.lock, flags);
 }
@@ -3379,7 +3367,7 @@ static void free_unref_page_commit(struc
 	if (pcp->count >= high) {
 		int batch = READ_ONCE(pcp->batch);
 
-		free_pcppages_bulk(zone, nr_pcp_free(pcp, high, batch), pcp);
+		free_pcppages_bulk(zone, nr_pcp_free(pcp, high, batch), pcp, pindex);
 	}
 }
 
_
