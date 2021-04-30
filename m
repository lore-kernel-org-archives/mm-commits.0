Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C00BFC433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:02:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DF44613F8
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:02:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhD3GC7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:02:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229834AbhD3GC4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:02:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F35C61450;
        Fri, 30 Apr 2021 06:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762525;
        bh=5bQ8vEdpJY0j+P84Wk50qeboPPjLYNYEQ2Ju+zF3no4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=oFTkn8dHU6TGpFqdM0k0XAqy/aBHUIFrUwsNF5kHCil1vXwT19YOWBO1V1oWjJuPv
         BgcgmzSuq934pryp536QZk1+qDBQ/3x5Rnlm3VYsDIkcVuZV5l4DInyd4mlFknEDj0
         NFW72B4FdIKJPUf86U/h2K5IHfJPNYKbxfgIKBjM=
Date:   Thu, 29 Apr 2021 23:02:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexander.duyck@gmail.com,
        alobakin@pm.me, brouer@redhat.com, chuck.lever@oracle.com,
        davem@davemloft.net, hch@infradead.org,
        ilias.apalodimas@linaro.org, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org
Subject:  [patch 173/178] net: page_pool: refactor dma_map into own
 function page_pool_dma_map
Message-ID: <20210430060204.kBNHq0tld%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
