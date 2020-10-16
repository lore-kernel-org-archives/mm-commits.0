Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E8FFC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:51:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28A2921D40
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881508;
	bh=KrpqddOryd3YRfpPrctugvlsN33NapUVc0aqZMgAFbU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=zGRFTHAVVpMb3CSf065r4j1TvFVy5jYUa3GB73f5SKYS4W2JVqJp4d+P9F/aurOIs
	 k06nachjTkqUQyXq9bxx+GMBn4w8hV3xW2OW9+JgJbd0RmkOwAp+z/JnBVADsevlKL
	 n0N0/shfjfjSa82WzlQeoN2Ns5jwzah3yc3FUt5g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406481AbgJPUvr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:51:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:40380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406479AbgJPUvr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:51:47 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40CF5216C4;
        Fri, 16 Oct 2020 20:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881505;
        bh=KrpqddOryd3YRfpPrctugvlsN33NapUVc0aqZMgAFbU=;
        h=Date:From:To:Subject:From;
        b=dCv4VEztK8et1B65dIhk20t+Qbj8RiMdPzp0Yeud8nO8cPOyJeZmhKbQkADNKEuFd
         o6Sx21mjatcytf6xERfUE6RaXA2cFv7qaBODp6xUNhD5DgzqKOTZ4PUhKXmQ2j6EDJ
         UH3cqZ4FuHgYqtVW6wAV6eKHvFu5NdrovJxOLEPQ=
Date:   Fri, 16 Oct 2020 13:51:43 -0700
From:   akpm@linux-foundation.org
To:     alexander.h.duyck@linux.intel.com, cheloha@linux.ibm.com,
        dave.hansen@intel.com, david@redhat.com, haiyangz@microsoft.com,
        kys@microsoft.com, mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, osalvador@suse.de,
        pankaj.gupta.linux@gmail.com, richard.weiyang@linux.alibaba.com,
        rppt@kernel.org, sthemmin@microsoft.com, vbabka@suse.cz,
        wei.liu@kernel.org, willy@infradead.org
Subject:  [merged]
 mm-page_alloc-move-pages-to-tail-in-move_to_free_list.patch removed from
 -mm tree
Message-ID: <20201016205143.eOW_T257H%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: move pages to tail in move_to_free_list()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-move-pages-to-tail-in-move_to_free_list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/page_alloc: move pages to tail in move_to_free_list()

Whenever we move pages between freelists via move_to_free_list()/
move_freepages_block(), we don't actually touch the pages:
1. Page isolation doesn't actually touch the pages, it simply isolates
   pageblocks and moves all free pages to the MIGRATE_ISOLATE freelist.
   When undoing isolation, we move the pages back to the target list.
2. Page stealing (steal_suitable_fallback()) moves free pages directly
   between lists without touching them.
3. reserve_highatomic_pageblock()/unreserve_highatomic_pageblock() moves
   free pages directly between freelists without touching them.

We already place pages to the tail of the freelists when undoing isolation
via __putback_isolated_page(), let's do it in any case (e.g., if order <=
pageblock_order) and document the behavior. To simplify, let's move the
pages to the tail for all move_to_free_list()/move_freepages_block() users.

In 2., the target list is empty, so there should be no change.  In 3., we
might observe a change, however, highatomic is more concerned about
allocations succeeding than cache hotness - if we ever realize this change
degrades a workload, we can special-case this instance and add a proper
comment.

This change results in all pages getting onlined via online_pages() to be
placed to the tail of the freelist.

Link: https://lkml.kernel.org/r/20201005121534.15649-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Reviewed-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Scott Cheloha <cheloha@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c     |   10 +++++++---
 mm/page_isolation.c |    5 +++++
 2 files changed, 12 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-move-pages-to-tail-in-move_to_free_list
+++ a/mm/page_alloc.c
@@ -901,13 +901,17 @@ static inline void add_to_free_list_tail
 	area->nr_free++;
 }
 
-/* Used for pages which are on another list */
+/*
+ * Used for pages which are on another list. Move the pages to the tail
+ * of the list - so the moved pages won't immediately be considered for
+ * allocation again (e.g., optimization for memory onlining).
+ */
 static inline void move_to_free_list(struct page *page, struct zone *zone,
 				     unsigned int order, int migratetype)
 {
 	struct free_area *area = &zone->free_area[order];
 
-	list_move(&page->lru, &area->free_list[migratetype]);
+	list_move_tail(&page->lru, &area->free_list[migratetype]);
 }
 
 static inline void del_page_from_free_list(struct page *page, struct zone *zone,
@@ -2340,7 +2344,7 @@ static inline struct page *__rmqueue_cma
 #endif
 
 /*
- * Move the free pages in a range to the free lists of the requested type.
+ * Move the free pages in a range to the freelist tail of the requested type.
  * Note that start_page and end_pages are not aligned on a pageblock
  * boundary. If alignment is required, use move_freepages_block()
  */
--- a/mm/page_isolation.c~mm-page_alloc-move-pages-to-tail-in-move_to_free_list
+++ a/mm/page_isolation.c
@@ -106,6 +106,11 @@ static void unset_migratetype_isolate(st
 	 * If we isolate freepage with more than pageblock_order, there
 	 * should be no freepage in the range, so we could avoid costly
 	 * pageblock scanning for freepage moving.
+	 *
+	 * We didn't actually touch any of the isolated pages, so place them
+	 * to the tail of the freelist. This is an optimization for memory
+	 * onlining - just onlined memory won't immediately be considered for
+	 * allocation.
 	 */
 	if (!isolated_page) {
 		nr_pages = move_freepages_block(zone, page, migratetype, NULL);
_

Patches currently in -mm which might be from david@redhat.com are


