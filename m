Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BCEDC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:43:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236304AbiCVVo4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236207AbiCVVox (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:44:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 369F41B7B4
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:43:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6936B81DAD
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:43:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 737AFC340EC;
        Tue, 22 Mar 2022 21:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985401;
        bh=JbxjnACt75jLJ1na1EB5yAF54JD2P6L7KwOtRJMAY78=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=RAXwG0t4EXQ2J8tNHurQmNhTnwvRa2eh1l/H8FF8gY8m61cR0ukWzfVPRCfIyCTdk
         7Khhrc2gq//r072gYTT9NpqX3gvljKFSW/fpu0u2FMxAjwk/El2NRGkSxvaim4sISr
         xX8VyHfVt2JPw420GWj+TKww8ZPjli+2sX5xqwg8=
Date:   Tue, 22 Mar 2022 14:43:20 -0700
To:     ziy@nvidia.com, vbabka@suse.cz, robin.murphy@arm.com,
        robh+dt@kernel.org, paulus@samba.org, m.szyprowski@samsung.com,
        mst@redhat.com, mpe@ellerman.id.au, minchan@kernel.org,
        iommu@lists.linux-foundation.org, hch@lst.de,
        frowand.list@gmail.com, benh@kernel.crashing.org,
        aneesh.kumar@linux.ibm.com, david@redhat.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 095/227] mm: enforce pageblock_order < MAX_ORDER
Message-Id: <20220322214321.737AFC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: mm: enforce pageblock_order < MAX_ORDER

Some places in the kernel don't really expect pageblock_order >=
MAX_ORDER, and it looks like this is only possible in corner cases:

1) CONFIG_DEFERRED_STRUCT_PAGE_INIT we'll end up freeing pageblock_order
   pages via __free_pages_core(), which cannot possibly work.

2) find_zone_movable_pfns_for_nodes() will roundup the ZONE_MOVABLE
   start PFN to MAX_ORDER_NR_PAGES. Consequently with a bigger
   pageblock_order, we could have a single pageblock partially managed by
   two zones.

3) compaction code runs into __fragmentation_index() with order
   >= MAX_ORDER, when checking WARN_ON_ONCE(order >= MAX_ORDER). [1]

4) mm/page_reporting.c won't be reporting any pages with default
   page_reporting_order == pageblock_order, as we'll be skipping the
   reporting loop inside page_reporting_process_zone().

5) __rmqueue_fallback() will never be able to steal with
   ALLOC_NOFRAGMENT.

pageblock_order >= MAX_ORDER is weird either way: it's a pure optimization
for making alloc_contig_range(), as used for allcoation of gigantic pages,
a little more reliable to succeed.  However, if there is demand for
somewhat reliable allocation of gigantic pages, affected setups should be
using CMA or boottime allocations instead.

So let's make sure that pageblock_order < MAX_ORDER and simplify.

[1] https://lkml.kernel.org/r/87r189a2ks.fsf@linux.ibm.com

Link: https://lkml.kernel.org/r/20220214174132.219303-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Frank Rowand <frowand.list@gmail.com>
Cc: John Garry via iommu <iommu@lists.linux-foundation.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_mem.c     |    9 ++------
 include/linux/cma.h             |    3 --
 include/linux/pageblock-flags.h |    7 ++++--
 mm/Kconfig                      |    3 ++
 mm/page_alloc.c                 |   32 +++++++-----------------------
 5 files changed, 20 insertions(+), 34 deletions(-)

--- a/drivers/virtio/virtio_mem.c~mm-enforce-pageblock_order-max_order
+++ a/drivers/virtio/virtio_mem.c
@@ -2476,13 +2476,10 @@ static int virtio_mem_init_hotplug(struc
 				      VIRTIO_MEM_DEFAULT_OFFLINE_THRESHOLD);
 
 	/*
-	 * We want subblocks to span at least MAX_ORDER_NR_PAGES and
-	 * pageblock_nr_pages pages. This:
-	 * - Is required for now for alloc_contig_range() to work reliably -
-	 *   it doesn't properly handle smaller granularity on ZONE_NORMAL.
+	 * TODO: once alloc_contig_range() works reliably with pageblock
+	 * granularity on ZONE_NORMAL, use pageblock_nr_pages instead.
 	 */
-	sb_size = max_t(uint64_t, MAX_ORDER_NR_PAGES,
-			pageblock_nr_pages) * PAGE_SIZE;
+	sb_size = PAGE_SIZE * MAX_ORDER_NR_PAGES;
 	sb_size = max_t(uint64_t, vm->device_block_size, sb_size);
 
 	if (sb_size < memory_block_size_bytes() && !force_bbm) {
--- a/include/linux/cma.h~mm-enforce-pageblock_order-max_order
+++ a/include/linux/cma.h
@@ -25,8 +25,7 @@
  * -- can deal with only some pageblocks of a higher-order page being
  *  MIGRATE_CMA, we can use pageblock_nr_pages.
  */
-#define CMA_MIN_ALIGNMENT_PAGES max_t(phys_addr_t, MAX_ORDER_NR_PAGES, \
-				      pageblock_nr_pages)
+#define CMA_MIN_ALIGNMENT_PAGES MAX_ORDER_NR_PAGES
 #define CMA_MIN_ALIGNMENT_BYTES (PAGE_SIZE * CMA_MIN_ALIGNMENT_PAGES)
 
 struct cma;
--- a/include/linux/pageblock-flags.h~mm-enforce-pageblock_order-max_order
+++ a/include/linux/pageblock-flags.h
@@ -37,8 +37,11 @@ extern unsigned int pageblock_order;
 
 #else /* CONFIG_HUGETLB_PAGE_SIZE_VARIABLE */
 
-/* Huge pages are a constant size */
-#define pageblock_order		HUGETLB_PAGE_ORDER
+/*
+ * Huge pages are a constant size, but don't exceed the maximum allocation
+ * granularity.
+ */
+#define pageblock_order		min_t(unsigned int, HUGETLB_PAGE_ORDER, MAX_ORDER - 1)
 
 #endif /* CONFIG_HUGETLB_PAGE_SIZE_VARIABLE */
 
--- a/mm/Kconfig~mm-enforce-pageblock_order-max_order
+++ a/mm/Kconfig
@@ -262,6 +262,9 @@ config HUGETLB_PAGE_SIZE_VARIABLE
 	  HUGETLB_PAGE_ORDER when there are multiple HugeTLB page sizes available
 	  on a platform.
 
+	  Note that the pageblock_order cannot exceed MAX_ORDER - 1 and will be
+	  clamped down to MAX_ORDER - 1.
+
 config CONTIG_ALLOC
 	def_bool (MEMORY_ISOLATION && COMPACTION) || CMA
 
--- a/mm/page_alloc.c~mm-enforce-pageblock_order-max_order
+++ a/mm/page_alloc.c
@@ -1072,14 +1072,12 @@ static inline void __free_one_page(struc
 		int migratetype, fpi_t fpi_flags)
 {
 	struct capture_control *capc = task_capc(zone);
+	unsigned int max_order = pageblock_order;
 	unsigned long buddy_pfn;
 	unsigned long combined_pfn;
-	unsigned int max_order;
 	struct page *buddy;
 	bool to_tail;
 
-	max_order = min_t(unsigned int, MAX_ORDER - 1, pageblock_order);
-
 	VM_BUG_ON(!zone_is_initialized(zone));
 	VM_BUG_ON_PAGE(page->flags & PAGE_FLAGS_CHECK_AT_PREP, page);
 
@@ -2259,19 +2257,8 @@ void __init init_cma_reserved_pageblock(
 	} while (++p, --i);
 
 	set_pageblock_migratetype(page, MIGRATE_CMA);
-
-	if (pageblock_order >= MAX_ORDER) {
-		i = pageblock_nr_pages;
-		p = page;
-		do {
-			set_page_refcounted(p);
-			__free_pages(p, MAX_ORDER - 1);
-			p += MAX_ORDER_NR_PAGES;
-		} while (i -= MAX_ORDER_NR_PAGES);
-	} else {
-		set_page_refcounted(page);
-		__free_pages(page, pageblock_order);
-	}
+	set_page_refcounted(page);
+	__free_pages(page, pageblock_order);
 
 	adjust_managed_page_count(page, pageblock_nr_pages);
 	page_zone(page)->cma_pages += pageblock_nr_pages;
@@ -7382,16 +7369,15 @@ static inline void setup_usemap(struct z
 /* Initialise the number of pages represented by NR_PAGEBLOCK_BITS */
 void __init set_pageblock_order(void)
 {
-	unsigned int order;
+	unsigned int order = MAX_ORDER - 1;
 
 	/* Check that pageblock_nr_pages has not already been setup */
 	if (pageblock_order)
 		return;
 
-	if (HPAGE_SHIFT > PAGE_SHIFT)
+	/* Don't let pageblocks exceed the maximum allocation granularity. */
+	if (HPAGE_SHIFT > PAGE_SHIFT && HUGETLB_PAGE_ORDER < order)
 		order = HUGETLB_PAGE_ORDER;
-	else
-		order = MAX_ORDER - 1;
 
 	/*
 	 * Assume the largest contiguous order of interest is a huge page.
@@ -8979,14 +8965,12 @@ struct page *has_unmovable_pages(struct
 #ifdef CONFIG_CONTIG_ALLOC
 static unsigned long pfn_max_align_down(unsigned long pfn)
 {
-	return pfn & ~(max_t(unsigned long, MAX_ORDER_NR_PAGES,
-			     pageblock_nr_pages) - 1);
+	return ALIGN_DOWN(pfn, MAX_ORDER_NR_PAGES);
 }
 
 static unsigned long pfn_max_align_up(unsigned long pfn)
 {
-	return ALIGN(pfn, max_t(unsigned long, MAX_ORDER_NR_PAGES,
-				pageblock_nr_pages));
+	return ALIGN(pfn, MAX_ORDER_NR_PAGES);
 }
 
 #if defined(CONFIG_DYNAMIC_DEBUG) || \
_
