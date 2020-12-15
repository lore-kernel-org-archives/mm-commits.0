Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78ED0C2BBCA
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:13:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B16D224DE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:13:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbgLODNp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:13:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:41410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728101AbgLODNZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:13:25 -0500
Date:   Mon, 14 Dec 2020 19:12:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001935;
        bh=kuFCS14SHNFqv70fqSszNsxLoZwwR5iNZZ7SXGOk7nc=;
        h=From:To:Subject:In-Reply-To:From;
        b=Pcy+i7mGmeq5m63NMDKunUjbCi/0/gHsvLzbSJTWo0XvgyJhZlYXOR1HsyyfqJLSw
         TTHvZ0a1o3xrU71ER+RVASy5wx74A446RWK3sDFClbtNixT0qAqdCUqyyntQU/iswW
         X2oGEYosqixQsPRH+aaPUbwOm0buCOo3/yRIBB2g=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hannes@cmpxchg.org, linux-mm@kvack.org,
        mgorman@suse.de, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 152/200] mm: don't wake kswapd prematurely when
 watermark boosting is disabled
Message-ID: <20201215031215.ZzmH0glWr%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: don't wake kswapd prematurely when watermark boosting is disabled

On 2-node NUMA hosts we see bursts of kswapd reclaim and subsequent
pressure spikes and stalls from cache refaults while there is plenty of
free memory in the system.

Usually, kswapd is woken up when all eligible nodes in an allocation are
full.  But the code related to watermark boosting can wake kswapd on one
full node while the other one is mostly empty.  This may be justified to
fight fragmentation, but is currently unconditionally done whether
watermark boosting is occurring or not.

In our case, many of our workloads' throughput scales with available
memory, and pure utilization is a more tangible concern than trends around
longer-term fragmentation.  As a result we generally disable watermark
boosting.

Wake kswapd only woken when watermark boosting is requested.

Link: https://lkml.kernel.org/r/20201020175833.397286-1-hannes@cmpxchg.org
Fixes: 1c30844d2dfe ("mm: reclaim small amounts of memory when an external fragmentation event occurs")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/mm/page_alloc.c~mm-dont-wake-kswapd-prematurely-when-watermark-boosting-is-disabled
+++ a/mm/page_alloc.c
@@ -2482,12 +2482,12 @@ static bool can_steal_fallback(unsigned
 	return false;
 }
 
-static inline void boost_watermark(struct zone *zone)
+static inline bool boost_watermark(struct zone *zone)
 {
 	unsigned long max_boost;
 
 	if (!watermark_boost_factor)
-		return;
+		return false;
 	/*
 	 * Don't bother in zones that are unlikely to produce results.
 	 * On small machines, including kdump capture kernels running
@@ -2495,7 +2495,7 @@ static inline void boost_watermark(struc
 	 * memory situation immediately.
 	 */
 	if ((pageblock_nr_pages * 4) > zone_managed_pages(zone))
-		return;
+		return false;
 
 	max_boost = mult_frac(zone->_watermark[WMARK_HIGH],
 			watermark_boost_factor, 10000);
@@ -2509,12 +2509,14 @@ static inline void boost_watermark(struc
 	 * boosted watermark resulting in a hang.
 	 */
 	if (!max_boost)
-		return;
+		return false;
 
 	max_boost = max(pageblock_nr_pages, max_boost);
 
 	zone->watermark_boost = min(zone->watermark_boost + pageblock_nr_pages,
 		max_boost);
+
+	return true;
 }
 
 /*
@@ -2552,8 +2554,7 @@ static void steal_suitable_fallback(stru
 	 * likelihood of future fallbacks. Wake kswapd now as the node
 	 * may be balanced overall and kswapd will not wake naturally.
 	 */
-	boost_watermark(zone);
-	if (alloc_flags & ALLOC_KSWAPD)
+	if (boost_watermark(zone) && (alloc_flags & ALLOC_KSWAPD))
 		set_bit(ZONE_BOOSTED_WATERMARK, &zone->flags);
 
 	/* We are not allowed to try stealing from the whole block */
_
