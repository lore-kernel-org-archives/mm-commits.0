Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6430C43460
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:02:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 868B76145A
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:02:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbhD3GC7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:02:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230182AbhD3GC7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:02:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D5A7613F8;
        Fri, 30 Apr 2021 06:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762528;
        bh=fPdvncJP0agq1rIvryzTJQFD91D1vkqIo6qPhvcV/lo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=BBVVmGhZVVPJci3hUQj4Yu+u3pQSHapSvAzl1Mt7UR2o5sXYQfYFsVFGoh8nDZhkS
         mSSq+WiizitesgCrrMOaV6ShC6w67vF1x7u6eLli6xGFJvMRjDXnw/Neo5l4/oSEL9
         jSLT5KRVOVdJkxBVhg2Bro68k/CfRJnyhKb6nnZs=
Date:   Thu, 29 Apr 2021 23:02:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexander.duyck@gmail.com,
        alobakin@pm.me, brouer@redhat.com, chuck.lever@oracle.com,
        davem@davemloft.net, hch@infradead.org,
        ilias.apalodimas@linaro.org, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org
Subject:  [patch 174/178] net: page_pool: use alloc_pages_bulk in
 refill code path
Message-ID: <20210430060207.-5KDbzAuy%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: net: page_pool: use alloc_pages_bulk in refill code path

There are cases where the page_pool need to refill with pages from the
page allocator.  Some workloads cause the page_pool to release pages
instead of recycling these pages.

For these workload it can improve performance to bulk alloc pages from the
page-allocator to refill the alloc cache.

For XDP-redirect workload with 100G mlx5 driver (that use page_pool)
redirecting xdp_frame packets into a veth, that does XDP_PASS to create an
SKB from the xdp_frame, which then cannot return the page to the
page_pool.

Performance results under GitHub xdp-project[1]:
 [1] https://github.com/xdp-project/xdp-project/blob/master/areas/mem/page_pool06_alloc_pages_bulk.org

Mel: The patch "net: page_pool: convert to use alloc_pages_bulk_array
variant" was squashed with this patch. From the test page, the array
variant was superior with one of the test results as follows.

	Kernel		XDP stats       CPU     pps           Delta
	Baseline	XDP-RX CPU      total   3,771,046       n/a
	List		XDP-RX CPU      total   3,940,242    +4.49%
	Array		XDP-RX CPU      total   4,249,224   +12.68%

Link: https://lkml.kernel.org/r/20210325114228.27719-10-mgorman@techsingularity.net
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Alexander Lobakin <alobakin@pm.me>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: David Miller <davem@davemloft.net>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/net/page_pool.h |    2 
 net/core/page_pool.c    |   82 +++++++++++++++++++++++++-------------
 2 files changed, 57 insertions(+), 27 deletions(-)

--- a/include/net/page_pool.h~net-page_pool-use-alloc_pages_bulk-in-refill-code-path
+++ a/include/net/page_pool.h
@@ -65,7 +65,7 @@
 #define PP_ALLOC_CACHE_REFILL	64
 struct pp_alloc_cache {
 	u32 count;
-	void *cache[PP_ALLOC_CACHE_SIZE];
+	struct page *cache[PP_ALLOC_CACHE_SIZE];
 };
 
 struct page_pool_params {
--- a/net/core/page_pool.c~net-page_pool-use-alloc_pages_bulk-in-refill-code-path
+++ a/net/core/page_pool.c
@@ -203,38 +203,17 @@ static bool page_pool_dma_map(struct pag
 	return true;
 }
 
-/* slow path */
-noinline
-static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
-						 gfp_t _gfp)
+static struct page *__page_pool_alloc_page_order(struct page_pool *pool,
+						 gfp_t gfp)
 {
-	unsigned int pp_flags = pool->p.flags;
 	struct page *page;
-	gfp_t gfp = _gfp;
 
-	/* We could always set __GFP_COMP, and avoid this branch, as
-	 * prep_new_page() can handle order-0 with __GFP_COMP.
-	 */
-	if (pool->p.order)
-		gfp |= __GFP_COMP;
-
-	/* FUTURE development:
-	 *
-	 * Current slow-path essentially falls back to single page
-	 * allocations, which doesn't improve performance.  This code
-	 * need bulk allocation support from the page allocator code.
-	 */
-
-	/* Cache was empty, do real allocation */
-#ifdef CONFIG_NUMA
+	gfp |= __GFP_COMP;
 	page = alloc_pages_node(pool->p.nid, gfp, pool->p.order);
-#else
-	page = alloc_pages(gfp, pool->p.order);
-#endif
-	if (!page)
+	if (unlikely(!page))
 		return NULL;
 
-	if ((pp_flags & PP_FLAG_DMA_MAP) &&
+	if ((pool->p.flags & PP_FLAG_DMA_MAP) &&
 	    unlikely(!page_pool_dma_map(pool, page))) {
 		put_page(page);
 		return NULL;
@@ -243,6 +222,57 @@ static struct page *__page_pool_alloc_pa
 	/* Track how many pages are held 'in-flight' */
 	pool->pages_state_hold_cnt++;
 	trace_page_pool_state_hold(pool, page, pool->pages_state_hold_cnt);
+	return page;
+}
+
+/* slow path */
+noinline
+static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
+						 gfp_t gfp)
+{
+	const int bulk = PP_ALLOC_CACHE_REFILL;
+	unsigned int pp_flags = pool->p.flags;
+	unsigned int pp_order = pool->p.order;
+	struct page *page;
+	int i, nr_pages;
+
+	/* Don't support bulk alloc for high-order pages */
+	if (unlikely(pp_order))
+		return __page_pool_alloc_page_order(pool, gfp);
+
+	/* Unnecessary as alloc cache is empty, but guarantees zero count */
+	if (unlikely(pool->alloc.count > 0))
+		return pool->alloc.cache[--pool->alloc.count];
+
+	/* Mark empty alloc.cache slots "empty" for alloc_pages_bulk_array */
+	memset(&pool->alloc.cache, 0, sizeof(void *) * bulk);
+
+	nr_pages = alloc_pages_bulk_array(gfp, bulk, pool->alloc.cache);
+	if (unlikely(!nr_pages))
+		return NULL;
+
+	/* Pages have been filled into alloc.cache array, but count is zero and
+	 * page element have not been (possibly) DMA mapped.
+	 */
+	for (i = 0; i < nr_pages; i++) {
+		page = pool->alloc.cache[i];
+		if ((pp_flags & PP_FLAG_DMA_MAP) &&
+		    unlikely(!page_pool_dma_map(pool, page))) {
+			put_page(page);
+			continue;
+		}
+		pool->alloc.cache[pool->alloc.count++] = page;
+		/* Track how many pages are held 'in-flight' */
+		pool->pages_state_hold_cnt++;
+		trace_page_pool_state_hold(pool, page,
+					   pool->pages_state_hold_cnt);
+	}
+
+	/* Return last page */
+	if (likely(pool->alloc.count > 0))
+		page = pool->alloc.cache[--pool->alloc.count];
+	else
+		page = NULL;
 
 	/* When page just alloc'ed is should/must have refcnt 1. */
 	return page;
_
