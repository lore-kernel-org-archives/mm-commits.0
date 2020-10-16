Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47923C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:46:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 054F820897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816388;
	bh=HhrPWNbZuu84+8WflS8aa24Fkmn+aOD/qfwEh0QkDzU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=RdNolRMo/TGCn5j38YtEJjNOj9c0HDmo/SyJt9StKTrAwHJUpUim7E3GR9Y46ixF9
	 dshTb347ApAbLYLoOwtJ47Fu/DqZ/3wvIDffVrZXTqbhYM3TmqInbShe3yENVBIg81
	 PnCJ6Ap9HVRH7diGym1vvh5PmWSm4ZCvCSRbyGl4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404330AbgJPCq1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:46:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731896AbgJPCq0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:46:26 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 822852087D;
        Fri, 16 Oct 2020 02:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816385;
        bh=HhrPWNbZuu84+8WflS8aa24Fkmn+aOD/qfwEh0QkDzU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Zug42lOdG7MdXUrt78Z6ELjwWJHywcF9clWZ5dbPWxGmQnq8i8HKLtx332QK2K3sH
         z6FsaCQlpvlwyV0Lu5NyCKj6FRYgTnJVCI+tz0eqGGhUSbvAYM9rd0CAKmxDCGESvg
         Z6KHZhb5mY749mUgd6B/ecFCQKjSrtYm6iTvCCzU=
Date:   Thu, 15 Oct 2020 19:46:23 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexander.h.duyck@linux.intel.com,
        cheloha@linux.ibm.com, dave.hansen@intel.com, david@redhat.com,
        haiyangz@microsoft.com, kys@microsoft.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, osalvador@suse.de,
        pankaj.gupta.linux@gmail.com, richard.weiyang@linux.alibaba.com,
        rppt@kernel.org, sthemmin@microsoft.com,
        torvalds@linux-foundation.org, vbabka@suse.cz, wei.liu@kernel.org,
        willy@infradead.org
Subject:  [patch 081/156] mm/page_alloc: move pages to tail in
 move_to_free_list()
Message-ID: <20201016024623.nWqdKkX7m%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
