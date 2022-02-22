Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E22C7C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 02:26:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbiBVC1H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 21:27:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiBVC1H (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 21:27:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA3C24580
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 18:26:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A5D3614E9
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 02:26:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22A1C340E9;
        Tue, 22 Feb 2022 02:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645496801;
        bh=1zvUCoNG4ubBTEjI8kAUdrjZbltMnluwrXZTuU96qLo=;
        h=Date:To:From:Subject:From;
        b=sFE+shJYZ7mhv7+OMc929ukGsIJoPnL/f1WWqWNxT74Xrz4VyjH2ldcDFD8KkRLvS
         H6VtKyijo2Ime5RxE1k6N+HuaVVDtt3FYdJYMnnNHksKUJwlSbaeSvXd3CbAQOg6+k
         uiIiaxT47KPkZDPa8zFvXuKLb2Gb0pQk51QjdNBw=
Date:   Mon, 21 Feb 2022 18:26:41 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mhocko@kernel.org,
        dave.hansen@linux.intel.com, brouer@redhat.com, aaron.lu@intel.com,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-do-not-prefetch-buddies-during-bulk-free.patch added to -mm tree
Message-Id: <20220222022641.D22A1C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: do not prefetch buddies during bulk free
has been added to the -mm tree.  Its filename is
     mm-page_alloc-do-not-prefetch-buddies-during-bulk-free.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-do-not-prefetch-buddies-during-bulk-free.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-do-not-prefetch-buddies-during-bulk-free.patch

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
Cc: Aaron Lu <aaron.lu@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   24 ------------------------
 1 file changed, 24 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-do-not-prefetch-buddies-during-bulk-free
+++ a/mm/page_alloc.c
@@ -1432,15 +1432,6 @@ static bool bulkfree_pcp_prepare(struct
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
@@ -1453,7 +1444,6 @@ static void free_pcppages_bulk(struct zo
 	int min_pindex = 0;
 	int max_pindex = NR_PCP_LISTS - 1;
 	unsigned int order;
-	int prefetch_nr = READ_ONCE(pcp->batch);
 	bool isolated_pageblocks;
 	struct page *page;
 
@@ -1508,20 +1498,6 @@ static void free_pcppages_bulk(struct zo
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

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-fetch-the-correct-pcp-buddy-during-bulk-free.patch
mm-page_alloc-track-range-of-active-pcp-lists-during-bulk-free.patch
mm-page_alloc-simplify-how-many-pages-are-selected-per-pcp-list-during-bulk-free.patch
mm-page_alloc-drain-the-requested-list-first-during-bulk-free.patch
mm-page_alloc-free-pages-in-a-single-pass-during-bulk-free.patch
mm-page_alloc-limit-number-of-high-order-pages-on-pcp-during-bulk-free.patch
mm-page_alloc-do-not-prefetch-buddies-during-bulk-free.patch

