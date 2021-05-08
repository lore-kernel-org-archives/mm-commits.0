Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C44FC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:45:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 722A961402
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:45:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbhEHWqc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:46:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhEHWqa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:46:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE27A613C5;
        Sat,  8 May 2021 22:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513927;
        bh=Jcc9xtJCliAYJ7yb2QylXnqb+XTJNE0XhWT7cTkYw/A=;
        h=Date:From:To:Subject:From;
        b=pexRuKRKn5YXMKoyKH8+QVGLnmoFovQEnzk/tyaXmOJTf1gu3v6tqrDRrDQTg0sG/
         aL6H0Kt7yZdB6bqPrnr4AI69Ag3rP8dA6JUbApLmmxfe15nRGjYg0b2qLL6km2t1+d
         dB7a3yynoKFeUkCM53SuNWws7fVNSOFlUqFz1K8U=
Date:   Sat, 08 May 2021 15:45:26 -0700
From:   akpm@linux-foundation.org
To:     alexander.duyck@gmail.com, alobakin@pm.me, brouer@redhat.com,
        chuck.lever@oracle.com, colin.king@canonical.com,
        davem@davemloft.net, hch@infradead.org,
        ilias.apalodimas@linaro.org, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, vbabka@suse.cz, willy@infradead.org
Subject:  [merged] mm-page_alloc-add-a-bulk-page-allocator.patch
 removed from -mm tree
Message-ID: <20210508224526.zH5tTZcTt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: add a bulk page allocator
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-add-a-bulk-page-allocator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[mgorman@techsingularity.net: fix alloc_pages_bulk() return type, per Matthew]
  Link: https://lkml.kernel.org/r/20210325123713.GQ3697@techsingularity.net
[mgorman@techsingularity.net: fix uninit var warning]
  Link: https://lkml.kernel.org/r/20210330114847.GX3697@techsingularity.net
[mgorman@techsingularity.net: fix comment, per Vlastimil]
  Link: https://lkml.kernel.org/r/20210412110255.GV3697@techsingularity.net
Link: https://lkml.kernel.org/r/20210325114228.27719-3-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Alexander Lobakin <alobakin@pm.me>
Tested-by: Colin Ian King <colin.king@canonical.com>
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
 
+unsigned long __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
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
@@ -5007,6 +5007,124 @@ static inline bool prepare_alloc_pages(g
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
+unsigned long __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
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
+	unsigned int alloc_flags = ALLOC_WMARK_LOW;
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
+	/* Find an allowed local zone that meets the low watermark. */
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


