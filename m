Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B12CC433DB
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 22:31:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AB2A6193E
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 22:31:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbhC1Was (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 18:30:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:47348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229656AbhC1WaV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 18:30:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E92A86192F;
        Sun, 28 Mar 2021 22:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616970621;
        bh=NHjWNFlvMt2VW5vl62HBPUxQUyycB2sMwIcxdYYJWug=;
        h=Date:From:To:Subject:From;
        b=MFz/pz/27GBGTBsApGZ8fh6Wnh0JFPgju8leTakgive98G/f9uwLnTMk/LWNAeLN2
         PLSfNPAKKds+6wIqYEuKFW7x9PkXwZYqJHVSZ49Bj4rn8qgy9q/k00rUffj7PWSNWf
         sPVFq5fXnYIaifK5f+rbSFO57X+3dqObWVdx6CSI=
Date:   Sun, 28 Mar 2021 15:30:20 -0700
From:   akpm@linux-foundation.org
To:     alexander.duyck@gmail.com, alobakin@pm.me, brouer@redhat.com,
        chuck.lever@oracle.com, davem@davemloft.net, hch@infradead.org,
        ilias.apalodimas@linaro.org, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, vbabka@suse.cz, willy@infradead.org
Subject:  +
 mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator.patch
 added to -mm tree
Message-ID: <20210328223020.tlEcefyyu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: add an array-based interface to the bulk page allocator
has been added to the -mm tree.  Its filename is
     mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator.patch

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
Subject: mm/page_alloc: add an array-based interface to the bulk page allocator

The proposed callers for the bulk allocator store pages from the bulk
allocator in an array.  This patch adds an array-based interface to the
API to avoid multiple list iterations.  The page list interface is
preserved to avoid requiring all users of the bulk API to allocate and
manage enough storage to store the pages.

Link: https://lkml.kernel.org/r/20210325114228.27719-4-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Alexander Lobakin <alobakin@pm.me>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: David Miller <davem@davemloft.net>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
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
@@ -5001,21 +5001,29 @@ static inline bool prepare_alloc_pages(g
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
@@ -5026,13 +5034,20 @@ unsigned long __alloc_pages_bulk(gfp_t g
 	struct alloc_context ac;
 	gfp_t alloc_gfp;
 	unsigned int alloc_flags;
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
@@ -5076,12 +5091,19 @@ unsigned long __alloc_pages_bulk(gfp_t g
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
@@ -5096,13 +5118,16 @@ unsigned long __alloc_pages_bulk(gfp_t g
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
@@ -5110,11 +5135,14 @@ failed_irq:
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

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-rename-alloced-to-allocated.patch
mm-page_alloc-add-a-bulk-page-allocator.patch
mm-page_alloc-add-a-bulk-page-allocator-fix.patch
mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator.patch

