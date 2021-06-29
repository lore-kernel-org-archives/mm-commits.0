Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0E17C11F67
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:40:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A51661D0C
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:40:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbhF2Cmw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:42:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:35158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230152AbhF2Cmv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:42:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3920061D11;
        Tue, 29 Jun 2021 02:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934424;
        bh=syu5K5LPxtj1Z80GiAinCeqLW/tB2nRvNpwLWbAhXso=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=yGx6S40DMnRF+OKPax3TXXyMkdrSDhuhkw4sAJctSniEyuoVaci3CfUy+wWsM5oxg
         00ADqSfFm7ylfas/J+MkZV+EQ3297nPANxU5w99QUkzToHIEFMoC7lXKz8iFP15KGc
         Z1m+KJOwqv4VE+A74XVKCHfujQf4Vu8saQuiSaTs=
Date:   Mon, 28 Jun 2021 19:40:23 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@lst.de, hdanton@sina.com,
        linux-mm@kvack.org, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com,
        oleksiy.avramchenko@sonymobile.com, rostedt@goodmis.org,
        torvalds@linux-foundation.org, urezki@gmail.com,
        willy@infradead.org
Subject:  [patch 136/192] mm/vmalloc: fallback to a single page
 allocator
Message-ID: <20210629024023.GZ5eiZ564%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Uladzislau Rezki <urezki@gmail.com>
Subject: mm/vmalloc: fallback to a single page allocator

Currently for order-0 pages we use a bulk-page allocator to get set of
pages.  From the other hand not allocating all pages is something that
might occur.  In that case we should fallbak to the single-page allocator
trying to get missing pages, because it is more permissive(direct reclaim,
etc).

Introduce a vm_area_alloc_pages() function where the described logic is
implemented.

Link: https://lkml.kernel.org/r/20210521130718.GA17882@pc638.lan
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sonymobile.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   81 +++++++++++++++++++++++++++++++------------------
 1 file changed, 52 insertions(+), 29 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-fallback-to-a-single-page-allocator
+++ a/mm/vmalloc.c
@@ -2758,6 +2758,54 @@ void *vmap_pfn(unsigned long *pfns, unsi
 EXPORT_SYMBOL_GPL(vmap_pfn);
 #endif /* CONFIG_VMAP_PFN */
 
+static inline unsigned int
+vm_area_alloc_pages(gfp_t gfp, int nid,
+		unsigned int order, unsigned long nr_pages, struct page **pages)
+{
+	unsigned int nr_allocated = 0;
+
+	/*
+	 * For order-0 pages we make use of bulk allocator, if
+	 * the page array is partly or not at all populated due
+	 * to fails, fallback to a single page allocator that is
+	 * more permissive.
+	 */
+	if (!order)
+		nr_allocated = alloc_pages_bulk_array_node(
+			gfp, nid, nr_pages, pages);
+	else
+		/*
+		 * Compound pages required for remap_vmalloc_page if
+		 * high-order pages.
+		 */
+		gfp |= __GFP_COMP;
+
+	/* High-order pages or fallback path if "bulk" fails. */
+	while (nr_allocated < nr_pages) {
+		struct page *page;
+		int i;
+
+		page = alloc_pages_node(nid, gfp, order);
+		if (unlikely(!page))
+			break;
+
+		/*
+		 * Careful, we allocate and map page-order pages, but
+		 * tracking is done per PAGE_SIZE page so as to keep the
+		 * vm_struct APIs independent of the physical/mapped size.
+		 */
+		for (i = 0; i < (1U << order); i++)
+			pages[nr_allocated + i] = page + i;
+
+		if (gfpflags_allow_blocking(gfp))
+			cond_resched();
+
+		nr_allocated += 1U << order;
+	}
+
+	return nr_allocated;
+}
+
 static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 				 pgprot_t prot, unsigned int page_shift,
 				 int node)
@@ -2790,37 +2838,11 @@ static void *__vmalloc_area_node(struct
 		return NULL;
 	}
 
-	area->nr_pages = 0;
 	set_vm_area_page_order(area, page_shift - PAGE_SHIFT);
 	page_order = vm_area_page_order(area);
 
-	if (!page_order) {
-		area->nr_pages = alloc_pages_bulk_array_node(
-			gfp_mask, node, nr_small_pages, area->pages);
-	} else {
-		/*
-		 * Careful, we allocate and map page_order pages, but tracking is done
-		 * per PAGE_SIZE page so as to keep the vm_struct APIs independent of
-		 * the physical/mapped size.
-		 */
-		while (area->nr_pages < nr_small_pages) {
-			struct page *page;
-			int i;
-
-			/* Compound pages required for remap_vmalloc_page */
-			page = alloc_pages_node(node, gfp_mask | __GFP_COMP, page_order);
-			if (unlikely(!page))
-				break;
-
-			for (i = 0; i < (1U << page_order); i++)
-				area->pages[area->nr_pages + i] = page + i;
-
-			if (gfpflags_allow_blocking(gfp_mask))
-				cond_resched();
-
-			area->nr_pages += 1U << page_order;
-		}
-	}
+	area->nr_pages = vm_area_alloc_pages(gfp_mask, node,
+		page_order, nr_small_pages, area->pages);
 
 	atomic_long_add(area->nr_pages, &nr_vmalloc_pages);
 
@@ -2835,7 +2857,8 @@ static void *__vmalloc_area_node(struct
 		goto fail;
 	}
 
-	if (vmap_pages_range(addr, addr + size, prot, area->pages, page_shift) < 0) {
+	if (vmap_pages_range(addr, addr + size, prot, area->pages,
+			page_shift) < 0) {
 		warn_alloc(gfp_mask, NULL,
 			"vmalloc error: size %lu, failed to map pages",
 			area->nr_pages * PAGE_SIZE);
_
