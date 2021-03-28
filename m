Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D508DC433E0
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 19:32:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A90026191D
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 19:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbhC1Tb0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 15:31:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:52644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230294AbhC1TbZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 15:31:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08B7161969;
        Sun, 28 Mar 2021 19:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616959885;
        bh=TtCkAY6emjfmCyM4mEB/sv5NmgzUis+ff69yfvR7Y90=;
        h=Date:From:To:Subject:From;
        b=nLpxVLLOrEkpY2+6bzJZ/8q78Z3cIyrhlvBzF151GfMpygem9A9CPYtExERmdsuzR
         vh8t1giHZc/QNNhjtyOj93HGvrMPRrhDOfMw4caqHQMfBrwfLAY70Qe6/7JV8aEq0U
         ddcEDTFOF8uiSfVqyRlwKRrdD/RzOJ7Jfi+v4brQ=
Date:   Sun, 28 Mar 2021 12:31:24 -0700
From:   akpm@linux-foundation.org
To:     alexander.duyck@gmail.com, alobakin@pm.me, brouer@redhat.com,
        chuck.lever@oracle.com, davem@davemloft.net, hch@infradead.org,
        ilias.apalodimas@linaro.org, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, vbabka@suse.cz, willy@infradead.org
Subject:  + mm-page_alloc-add-a-bulk-page-allocator.patch added to
 -mm tree
Message-ID: <20210328193124.IfyIGbb85%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: add a bulk page allocator
has been added to the -mm tree.  Its filename is
     mm-page_alloc-add-a-bulk-page-allocator.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-add-a-bulk-page-allocator.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-add-a-bulk-page-allocator.patch

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
Subject: mm/page_alloc: add a bulk page allocator

This patch adds a new page allocator interface via alloc_pages_bulk, and
__alloc_pages_bulk_nodemask.  A caller requests a number of pages to be
allocated and added to a list.

The API is not guaranteed to return the requested number of pages and may
fail if the preferred allocation zone has limited free memory, the cpuset
changes during the allocation or page debugging decides to fail an
allocation.  It's up to the caller to request more pages in batch if
necessary.

Note that this implementation is not very efficient and could be improved
but it would require refactoring.  The intent is to make it available
early to determine what semantics are required by different callers.  Once
the full semantics are nailed down, it can be refactored.

Link: https://lkml.kernel.org/r/20210325114228.27719-3-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Alexander Lobakin <alobakin@pm.me>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: David Miller <davem@davemloft.net>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |   11 +++
 mm/page_alloc.c     |  118 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 129 insertions(+)

--- a/include/linux/gfp.h~mm-page_alloc-add-a-bulk-page-allocator
+++ a/include/linux/gfp.h
@@ -518,6 +518,17 @@ static inline int arch_make_page_accessi
 struct page *__alloc_pages(gfp_t gfp, unsigned int order, int preferred_nid,
 		nodemask_t *nodemask);
 
+int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
+				nodemask_t *nodemask, int nr_pages,
+				struct list_head *list);
+
+/* Bulk allocate order-0 pages */
+static inline unsigned long
+alloc_pages_bulk(gfp_t gfp, unsigned long nr_pages, struct list_head *list)
+{
+	return __alloc_pages_bulk(gfp, numa_mem_id(), NULL, nr_pages, list);
+}
+
 /*
  * Allocate pages, preferring the node given as nid. The node must be valid and
  * online. For more general interface, see alloc_pages_node().
--- a/mm/page_alloc.c~mm-page_alloc-add-a-bulk-page-allocator
+++ a/mm/page_alloc.c
@@ -5001,6 +5001,124 @@ static inline bool prepare_alloc_pages(g
 }
 
 /*
+ * __alloc_pages_bulk - Allocate a number of order-0 pages to a list
+ * @gfp: GFP flags for the allocation
+ * @preferred_nid: The preferred NUMA node ID to allocate from
+ * @nodemask: Set of nodes to allocate from, may be NULL
+ * @nr_pages: The number of pages desired on the list
+ * @page_list: List to store the allocated pages
+ *
+ * This is a batched version of the page allocator that attempts to
+ * allocate nr_pages quickly and add them to a list.
+ *
+ * Returns the number of pages on the list.
+ */
+int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
+			nodemask_t *nodemask, int nr_pages,
+			struct list_head *page_list)
+{
+	struct page *page;
+	unsigned long flags;
+	struct zone *zone;
+	struct zoneref *z;
+	struct per_cpu_pages *pcp;
+	struct list_head *pcp_list;
+	struct alloc_context ac;
+	gfp_t alloc_gfp;
+	unsigned int alloc_flags;
+	int allocated = 0;
+
+	if (WARN_ON_ONCE(nr_pages <= 0))
+		return 0;
+
+	/* Use the single page allocator for one page. */
+	if (nr_pages == 1)
+		goto failed;
+
+	/* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */
+	gfp &= gfp_allowed_mask;
+	alloc_gfp = gfp;
+	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &alloc_gfp, &alloc_flags))
+		return 0;
+	gfp = alloc_gfp;
+
+	/* Find an allowed local zone that meets the high watermark. */
+	for_each_zone_zonelist_nodemask(zone, z, ac.zonelist, ac.highest_zoneidx, ac.nodemask) {
+		unsigned long mark;
+
+		if (cpusets_enabled() && (alloc_flags & ALLOC_CPUSET) &&
+		    !__cpuset_zone_allowed(zone, gfp)) {
+			continue;
+		}
+
+		if (nr_online_nodes > 1 && zone != ac.preferred_zoneref->zone &&
+		    zone_to_nid(zone) != zone_to_nid(ac.preferred_zoneref->zone)) {
+			goto failed;
+		}
+
+		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK) + nr_pages;
+		if (zone_watermark_fast(zone, 0,  mark,
+				zonelist_zone_idx(ac.preferred_zoneref),
+				alloc_flags, gfp)) {
+			break;
+		}
+	}
+
+	/*
+	 * If there are no allowed local zones that meets the watermarks then
+	 * try to allocate a single page and reclaim if necessary.
+	 */
+	if (!zone)
+		goto failed;
+
+	/* Attempt the batch allocation */
+	local_irq_save(flags);
+	pcp = &this_cpu_ptr(zone->pageset)->pcp;
+	pcp_list = &pcp->lists[ac.migratetype];
+
+	while (allocated < nr_pages) {
+		page = __rmqueue_pcplist(zone, ac.migratetype, alloc_flags,
+								pcp, pcp_list);
+		if (!page) {
+			/* Try and get at least one page */
+			if (!allocated)
+				goto failed_irq;
+			break;
+		}
+
+		/*
+		 * Ideally this would be batched but the best way to do
+		 * that cheaply is to first convert zone_statistics to
+		 * be inaccurate per-cpu counter like vm_events to avoid
+		 * a RMW cycle then do the accounting with IRQs enabled.
+		 */
+		__count_zid_vm_events(PGALLOC, zone_idx(zone), 1);
+		zone_statistics(ac.preferred_zoneref->zone, zone);
+
+		prep_new_page(page, 0, gfp, 0);
+		list_add(&page->lru, page_list);
+		allocated++;
+	}
+
+	local_irq_restore(flags);
+
+	return allocated;
+
+failed_irq:
+	local_irq_restore(flags);
+
+failed:
+	page = __alloc_pages(gfp, 0, preferred_nid, nodemask);
+	if (page) {
+		list_add(&page->lru, page_list);
+		allocated = 1;
+	}
+
+	return allocated;
+}
+EXPORT_SYMBOL_GPL(__alloc_pages_bulk);
+
+/*
  * This is the 'heart' of the zoned buddy allocator.
  */
 struct page *__alloc_pages(gfp_t gfp, unsigned int order, int preferred_nid,
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-rename-alloced-to-allocated.patch
mm-page_alloc-add-a-bulk-page-allocator.patch
mm-page_alloc-add-a-bulk-page-allocator-fix.patch
mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator.patch

