Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6BDBC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:45:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAD0E61415
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:45:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbhEHWqs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:46:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:57156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229647AbhEHWqr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:46:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0C08613C5;
        Sat,  8 May 2021 22:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513945;
        bh=mMLMCIB6Ck94b4OHCxEfbS896mqRW2TLHl87BIcWepM=;
        h=Date:From:To:Subject:From;
        b=KaSV7us7VJZtTwi9o952OO1k3vrAr03GIrSMe3Rh7My5Fr2U4pNP3HwmYKso36sOb
         fZMahkmko9S2cEWurZCVrotfL53kCXRQNga7NwH5wyay9bFqS5CcJW50IqZfadNUk2
         d6jqbEyo6w1Asq/MI4ntLpfiOmF2A/EFJOWr98vk=
Date:   Sat, 08 May 2021 15:45:44 -0700
From:   akpm@linux-foundation.org
To:     alexander.duyck@gmail.com, alobakin@pm.me, brouer@redhat.com,
        chuck.lever@oracle.com, davem@davemloft.net, hch@infradead.org,
        ilias.apalodimas@linaro.org, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, vbabka@suse.cz, willy@infradead.org
Subject:  [merged]
 net-page_pool-refactor-dma_map-into-own-function-page_pool_dma_map.patch
 removed from -mm tree
Message-ID: <20210508224544.IpBjxfWu2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: net: page_pool: refactor dma_map into own function page_pool_dma_map
has been removed from the -mm tree.  Its filename was
     net-page_pool-refactor-dma_map-into-own-function-page_pool_dma_map.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: net: page_pool: refactor dma_map into own function page_pool_dma_map

In preparation for next patch, move the dma mapping into its own function,
as this will make it easier to follow the changes.

[ilias.apalodimas: make page_pool_dma_map return boolean]
Link: https://lkml.kernel.org/r/20210325114228.27719-9-mgorman@techsingularity.net
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Reviewed-by: Alexander Lobakin <alobakin@pm.me>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: David Miller <davem@davemloft.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/page_pool.c |   45 +++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 19 deletions(-)

--- a/net/core/page_pool.c~net-page_pool-refactor-dma_map-into-own-function-page_pool_dma_map
+++ a/net/core/page_pool.c
@@ -180,14 +180,37 @@ static void page_pool_dma_sync_for_devic
 					 pool->p.dma_dir);
 }
 
+static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
+{
+	dma_addr_t dma;
+
+	/* Setup DMA mapping: use 'struct page' area for storing DMA-addr
+	 * since dma_addr_t can be either 32 or 64 bits and does not always fit
+	 * into page private data (i.e 32bit cpu with 64bit DMA caps)
+	 * This mapping is kept for lifetime of page, until leaving pool.
+	 */
+	dma = dma_map_page_attrs(pool->p.dev, page, 0,
+				 (PAGE_SIZE << pool->p.order),
+				 pool->p.dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
+	if (dma_mapping_error(pool->p.dev, dma))
+		return false;
+
+	page->dma_addr = dma;
+
+	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
+		page_pool_dma_sync_for_device(pool, page, pool->p.max_len);
+
+	return true;
+}
+
 /* slow path */
 noinline
 static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 						 gfp_t _gfp)
 {
+	unsigned int pp_flags = pool->p.flags;
 	struct page *page;
 	gfp_t gfp = _gfp;
-	dma_addr_t dma;
 
 	/* We could always set __GFP_COMP, and avoid this branch, as
 	 * prep_new_page() can handle order-0 with __GFP_COMP.
@@ -211,30 +234,14 @@ static struct page *__page_pool_alloc_pa
 	if (!page)
 		return NULL;
 
-	if (!(pool->p.flags & PP_FLAG_DMA_MAP))
-		goto skip_dma_map;
-
-	/* Setup DMA mapping: use 'struct page' area for storing DMA-addr
-	 * since dma_addr_t can be either 32 or 64 bits and does not always fit
-	 * into page private data (i.e 32bit cpu with 64bit DMA caps)
-	 * This mapping is kept for lifetime of page, until leaving pool.
-	 */
-	dma = dma_map_page_attrs(pool->p.dev, page, 0,
-				 (PAGE_SIZE << pool->p.order),
-				 pool->p.dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
-	if (dma_mapping_error(pool->p.dev, dma)) {
+	if ((pp_flags & PP_FLAG_DMA_MAP) &&
+	    unlikely(!page_pool_dma_map(pool, page))) {
 		put_page(page);
 		return NULL;
 	}
-	page->dma_addr = dma;
 
-	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
-		page_pool_dma_sync_for_device(pool, page, pool->p.max_len);
-
-skip_dma_map:
 	/* Track how many pages are held 'in-flight' */
 	pool->pages_state_hold_cnt++;
-
 	trace_page_pool_state_hold(pool, page, pool->pages_state_hold_cnt);
 
 	/* When page just alloc'ed is should/must have refcnt 1. */
_

Patches currently in -mm which might be from brouer@redhat.com are


