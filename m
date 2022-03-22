Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0585C4167B
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:44:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236260AbiCVVpt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236466AbiCVVp1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:45:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D3E13E11
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:43:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84E286149F
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:43:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21E5C340F2;
        Tue, 22 Mar 2022 21:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985428;
        bh=yE+foT6ycZIEk/yhItCMeIRV6Fxl6kJtyoQy1cLNBEk=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=ffogBE1QK8ATvyueuaFksTTTwu4dRNHj4FJejOEvNp6ApwYgykUo99Pvt6dTvQGBA
         viiYylbFAgnPBQucj5tvdxjmH9RsijQDHxQOjlSS0h/UY6RVGSjPhBGDnLMmfTUgaS
         aP7RVk2XtqnLcDGRFNTeAB3OpoyG7kubpDO4ssOY=
Date:   Tue, 22 Mar 2022 14:43:48 -0700
To:     vbabka@suse.cz, mhocko@kernel.org, dave.hansen@linux.intel.com,
        brouer@redhat.com, aaron.lu@intel.com, mgorman@techsingularity.net,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 104/227] mm/page_alloc: do not prefetch buddies during bulk free
Message-Id: <20220322214348.D21E5C340F2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: do not prefetch buddies during bulk free

free_pcppages_bulk() has taken two passes through the pcp lists since
commit 0a5f4e5b4562 ("mm/free_pcppages_bulk: do not hold lock when picking
pages to free") due to deferring the cost of selecting PCP lists until the
zone lock is held.

As the list processing now takes place under the zone lock, it's less
clear that this will always benefit for two reasons.

1. There is a guaranteed cost to calculating the buddy which definitely
   has to be calculated again. However, as the zone lock is held and
   there is no deferring of buddy merging, there is no guarantee that the
   prefetch will have completed when the second buddy calculation takes
   place and buddies are being merged.  With or without the prefetch, there
   may be further stalls depending on how many pages get merged. In other
   words, a stall due to merging is inevitable and at best only one stall
   might be avoided at the cost of calculating the buddy location twice.

2. As the zone lock is held, prefetch_nr makes less sense as once
   prefetch_nr expires, the cache lines of interest have already been
   merged.

The main concern is that there is a definite cost to calculating the buddy
location early for the prefetch and it is a "maybe win" depending on
whether the CPU prefetch logic and memory is fast enough.  Remove the
prefetch logic on the basis that reduced instructions in a path is always
a saving where as the prefetch might save one memory stall depending on
the CPU and memory.

In most cases, this has marginal benefit as the calculations are a small
part of the overall freeing of pages.  However, it was detectable on at
least one machine.

                              5.17.0-rc3             5.17.0-rc3
                    mm-highpcplimit-v2r1     mm-noprefetch-v1r1
Min       elapsed      630.00 (   0.00%)      610.00 (   3.17%)
Amean     elapsed      639.00 (   0.00%)      623.00 *   2.50%*
Max       elapsed      660.00 (   0.00%)      660.00 (   0.00%)

Link: https://lkml.kernel.org/r/20220221094119.15282-2-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Suggested-by: Aaron Lu <aaron.lu@intel.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Aaron Lu <aaron.lu@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   24 ------------------------
 1 file changed, 24 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-do-not-prefetch-buddies-during-bulk-free
+++ a/mm/page_alloc.c
@@ -1429,15 +1429,6 @@ static bool bulkfree_pcp_prepare(struct
 }
 #endif /* CONFIG_DEBUG_VM */
 
-static inline void prefetch_buddy(struct page *page, unsigned int order)
-{
-	unsigned long pfn = page_to_pfn(page);
-	unsigned long buddy_pfn = __find_buddy_pfn(pfn, order);
-	struct page *buddy = page + (buddy_pfn - pfn);
-
-	prefetch(buddy);
-}
-
 /*
  * Frees a number of pages from the PCP lists
  * Assumes all pages on list are in same zone.
@@ -1450,7 +1441,6 @@ static void free_pcppages_bulk(struct zo
 	int min_pindex = 0;
 	int max_pindex = NR_PCP_LISTS - 1;
 	unsigned int order;
-	int prefetch_nr = READ_ONCE(pcp->batch);
 	bool isolated_pageblocks;
 	struct page *page;
 
@@ -1505,20 +1495,6 @@ static void free_pcppages_bulk(struct zo
 			if (bulkfree_pcp_prepare(page))
 				continue;
 
-			/*
-			 * We are going to put the page back to the global
-			 * pool, prefetch its buddy to speed up later access
-			 * under zone->lock. It is believed the overhead of
-			 * an additional test and calculating buddy_pfn here
-			 * can be offset by reduced memory latency later. To
-			 * avoid excessive prefetching due to large count, only
-			 * prefetch buddy for the first pcp->batch nr of pages.
-			 */
-			if (prefetch_nr) {
-				prefetch_buddy(page, order);
-				prefetch_nr--;
-			}
-
 			/* MIGRATE_ISOLATE page should not go to pcplists */
 			VM_BUG_ON_PAGE(is_migrate_isolate(mt), page);
 			/* Pageblock could have been isolated meanwhile */
_
