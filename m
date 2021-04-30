Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5337C43462
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:01:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 988426145D
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:01:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhD3GCh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:02:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229591AbhD3GCh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:02:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20DAD613AD;
        Fri, 30 Apr 2021 06:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762509;
        bh=uRAbYwKt66avZqxCkr1cGJi2RmJEMuw/XxjHHp6OrUQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=YuO6/QbKC/CejxJUdxkdo5S0Wn2DtTIYV0zmTCiZ1dwUf98cVymF5ZdRJnLVpp116
         c1HrdrKFxg+ZjoJbjLL6U6xp058rXDLoStnV81l5//CAB9/rDW/oukrkEGGtbcRMKm
         NcUuwmtkw6wcKgdHtmHXKrkbTks6HMu5q8D8e5go=
Date:   Thu, 29 Apr 2021 23:01:48 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexander.duyck@gmail.com,
        alobakin@pm.me, brouer@redhat.com, chuck.lever@oracle.com,
        davem@davemloft.net, hch@infradead.org,
        ilias.apalodimas@linaro.org, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org
Subject:  [patch 168/178] mm/page_alloc: add an array-based
 interface to the bulk page allocator
Message-ID: <20210430060148.Ty_I2pch5%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: add an array-based interface to the bulk page allocator

The proposed callers for the bulk allocator store pages from the bulk
allocator in an array.  This patch adds an array-based interface to the
API to avoid multiple list iterations.  The page list interface is
preserved to avoid requiring all users of the bulk API to allocate and
manage enough storage to store the pages.

[akpm@linux-foundation.org: remove now unused local `allocated']
Link: https://lkml.kernel.org/r/20210325114228.27719-4-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Alexander Lobakin <alobakin@pm.me>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: David Miller <davem@davemloft.net>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |   13 +++++++--
 mm/page_alloc.c     |   60 ++++++++++++++++++++++++++++++------------
 2 files changed, 54 insertions(+), 19 deletions(-)

--- a/include/linux/gfp.h~mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator
+++ a/include/linux/gfp.h
@@ -520,13 +520,20 @@ struct page *__alloc_pages(gfp_t gfp, un
 
 unsigned long __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 				nodemask_t *nodemask, int nr_pages,
-				struct list_head *list);
+				struct list_head *page_list,
+				struct page **page_array);
 
 /* Bulk allocate order-0 pages */
 static inline unsigned long
-alloc_pages_bulk(gfp_t gfp, unsigned long nr_pages, struct list_head *list)
+alloc_pages_bulk_list(gfp_t gfp, unsigned long nr_pages, struct list_head *list)
 {
-	return __alloc_pages_bulk(gfp, numa_mem_id(), NULL, nr_pages, list);
+	return __alloc_pages_bulk(gfp, numa_mem_id(), NULL, nr_pages, list, NULL);
+}
+
+static inline unsigned long
+alloc_pages_bulk_array(gfp_t gfp, unsigned long nr_pages, struct page **page_array)
+{
+	return __alloc_pages_bulk(gfp, numa_mem_id(), NULL, nr_pages, NULL, page_array);
 }
 
 /*
--- a/mm/page_alloc.c~mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator
+++ a/mm/page_alloc.c
@@ -5007,21 +5007,29 @@ static inline bool prepare_alloc_pages(g
 }
 
 /*
- * __alloc_pages_bulk - Allocate a number of order-0 pages to a list
+ * __alloc_pages_bulk - Allocate a number of order-0 pages to a list or array
  * @gfp: GFP flags for the allocation
  * @preferred_nid: The preferred NUMA node ID to allocate from
  * @nodemask: Set of nodes to allocate from, may be NULL
- * @nr_pages: The number of pages desired on the list
- * @page_list: List to store the allocated pages
+ * @nr_pages: The number of pages desired on the list or array
+ * @page_list: Optional list to store the allocated pages
+ * @page_array: Optional array to store the pages
  *
  * This is a batched version of the page allocator that attempts to
- * allocate nr_pages quickly and add them to a list.
+ * allocate nr_pages quickly. Pages are added to page_list if page_list
+ * is not NULL, otherwise it is assumed that the page_array is valid.
  *
- * Returns the number of pages on the list.
+ * For lists, nr_pages is the number of pages that should be allocated.
+ *
+ * For arrays, only NULL elements are populated with pages and nr_pages
+ * is the maximum number of pages that will be stored in the array.
+ *
+ * Returns the number of pages on the list or array.
  */
 unsigned long __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 			nodemask_t *nodemask, int nr_pages,
-			struct list_head *page_list)
+			struct list_head *page_list,
+			struct page **page_array)
 {
 	struct page *page;
 	unsigned long flags;
@@ -5032,13 +5040,20 @@ unsigned long __alloc_pages_bulk(gfp_t g
 	struct alloc_context ac;
 	gfp_t alloc_gfp;
 	unsigned int alloc_flags = ALLOC_WMARK_LOW;
-	int allocated = 0;
+	int nr_populated = 0;
 
 	if (WARN_ON_ONCE(nr_pages <= 0))
 		return 0;
 
+	/*
+	 * Skip populated array elements to determine if any pages need
+	 * to be allocated before disabling IRQs.
+	 */
+	while (page_array && page_array[nr_populated] && nr_populated < nr_pages)
+		nr_populated++;
+
 	/* Use the single page allocator for one page. */
-	if (nr_pages == 1)
+	if (nr_pages - nr_populated == 1)
 		goto failed;
 
 	/* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */
@@ -5082,12 +5097,19 @@ unsigned long __alloc_pages_bulk(gfp_t g
 	pcp = &this_cpu_ptr(zone->pageset)->pcp;
 	pcp_list = &pcp->lists[ac.migratetype];
 
-	while (allocated < nr_pages) {
+	while (nr_populated < nr_pages) {
+
+		/* Skip existing pages */
+		if (page_array && page_array[nr_populated]) {
+			nr_populated++;
+			continue;
+		}
+
 		page = __rmqueue_pcplist(zone, ac.migratetype, alloc_flags,
 								pcp, pcp_list);
 		if (!page) {
 			/* Try and get at least one page */
-			if (!allocated)
+			if (!nr_populated)
 				goto failed_irq;
 			break;
 		}
@@ -5102,13 +5124,16 @@ unsigned long __alloc_pages_bulk(gfp_t g
 		zone_statistics(ac.preferred_zoneref->zone, zone);
 
 		prep_new_page(page, 0, gfp, 0);
-		list_add(&page->lru, page_list);
-		allocated++;
+		if (page_list)
+			list_add(&page->lru, page_list);
+		else
+			page_array[nr_populated] = page;
+		nr_populated++;
 	}
 
 	local_irq_restore(flags);
 
-	return allocated;
+	return nr_populated;
 
 failed_irq:
 	local_irq_restore(flags);
@@ -5116,11 +5141,14 @@ failed_irq:
 failed:
 	page = __alloc_pages(gfp, 0, preferred_nid, nodemask);
 	if (page) {
-		list_add(&page->lru, page_list);
-		allocated = 1;
+		if (page_list)
+			list_add(&page->lru, page_list);
+		else
+			page_array[nr_populated] = page;
+		nr_populated++;
 	}
 
-	return allocated;
+	return nr_populated;
 }
 EXPORT_SYMBOL_GPL(__alloc_pages_bulk);
 
_
