From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 =?US-ASCII?Q?mmpage=5Falloccma-conditionally-prefer-cma-pageblocks-for-m?=
 =?US-ASCII?Q?ovable-allocations.patch?= added to -mm tree
Date: Sat, 07 Mar 2020 14:39:08 -0800
Message-ID: <20200307223908.jqx6jkxmv%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726300AbgCGWjJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 7 Mar 2020 17:39:09 -0500
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, cai@lca.pw, guro@fb.com, mgorman@techsingularity.net, mm-commits@vger.kernel.org, riel@surriel.com, vbabka@suse.cz


The patch titled
     Subject:  mm,page_alloc,cma: conditionally prefer cma pageblocks for movable allocations
has been added to the -mm tree.  Its filename is
     mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject:  mm,page_alloc,cma: conditionally prefer cma pageblocks for movable allocations

Currently a cma area is barely used by the page allocator because it's
used only as a fallback from movable, however kswapd tries hard to make
sure that the fallback path isn't used.

This results in a system evicting memory and pushing data into swap, while
lots of CMA memory is still available.  This happens despite the fact that
alloc_contig_range is perfectly capable of moving any movable allocations
out of the way of an allocation.

To effectively use the cma area let's alter the rules: if the zone has
more free cma pages than the half of total free pages in the zone, use cma
pageblocks first and fallback to movable blocks in the case of failure.

Link: http://lkml.kernel.org/r/20200306150102.3e77354b@imladris.surriel.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Signed-off-by: Rik van Riel <riel@surriel.com>
Co-developed-by: Rik van Riel <riel@surriel.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/mm/page_alloc.c~mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations
+++ a/mm/page_alloc.c
@@ -2713,6 +2713,18 @@ __rmqueue(struct zone *zone, unsigned in
 {
 	struct page *page;
 
+	/*
+	 * Balance movable allocations between regular and CMA areas by
+	 * allocating from CMA when over half of the zone's free memory
+	 * is in the CMA area.
+	 */
+	if (migratetype == MIGRATE_MOVABLE &&
+	    zone_page_state(zone, NR_FREE_CMA_PAGES) >
+	    zone_page_state(zone, NR_FREE_PAGES) / 2) {
+		page = __rmqueue_cma_fallback(zone, order);
+		if (page)
+			return page;
+	}
 retry:
 	page = __rmqueue_smallest(zone, order, migratetype);
 	if (unlikely(!page)) {
_

Patches currently in -mm which might be from guro@fb.com are

mm-fork-fix-kernel_stack-memcg-stats-for-various-stack-implementations.patch
mm-memcg-slab-introduce-mem_cgroup_from_obj.patch
mm-memcg-slab-introduce-mem_cgroup_from_obj-v2.patch
mm-kmem-cleanup-__memcg_kmem_charge_memcg-arguments.patch
mm-kmem-cleanup-memcg_kmem_uncharge_memcg-arguments.patch
mm-kmem-rename-memcg_kmem_uncharge-into-memcg_kmem_uncharge_page.patch
mm-kmem-switch-to-nr_pages-in-__memcg_kmem_charge_memcg.patch
mm-memcg-slab-cache-page-number-in-memcg_uncharge_slab.patch
mm-kmem-rename-__memcg_kmem_uncharge_memcg-to-__memcg_kmem_uncharge.patch
mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations.patch
