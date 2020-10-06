Return-Path: <SRS0=SqaX=DN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F9C5C41604
	for <mm-commits@archiver.kernel.org>; Tue,  6 Oct 2020 04:57:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A65820782
	for <mm-commits@archiver.kernel.org>; Tue,  6 Oct 2020 04:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601960245;
	bh=jNDgjem52mgt/qyb3I4QTN0+m9AlMv9pdwSNTRMTnVU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=VSFudrzfU5DQ8pZ08s0vypd75SJZKOZXa0qeUVieA+pBgwwwJX5YOjvaH4k1dDg7U
	 N/Jp80kiRuwQSUquieA0axbB83RKLvqHofQQQiT8Sd1/9/1jXUJu9riT6FAA6RfFXI
	 5wN+wES06D1xnIZB4hHazAvjH2HyYx4nA00s/+K0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbgJFE5Y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Oct 2020 00:57:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:42552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbgJFE5Y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Oct 2020 00:57:24 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C2C8208C3;
        Tue,  6 Oct 2020 04:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601960243;
        bh=jNDgjem52mgt/qyb3I4QTN0+m9AlMv9pdwSNTRMTnVU=;
        h=Date:From:To:Subject:From;
        b=QyIOjIki92rwp6YHmHnX4PVc6cXWzwOg+RF+V+AVzvBshXYh9FyWun0FNKeoO9T10
         TpXuV+I7/y9y4BrZt1RAiiVmJdBFRI23ts4c6Bv/P0ujDIx2XtowshsjfJ3vLd8hbY
         UbxxWcixA7pUf3Su/g4UZxqr4ebya8a3S6TYKkv4=
Date:   Mon, 05 Oct 2020 21:57:21 -0700
From:   akpm@linux-foundation.org
To:     alexander.h.duyck@linux.intel.com, cheloha@linux.ibm.com,
        dave.hansen@intel.com, david@redhat.com, haiyangz@microsoft.com,
        kys@microsoft.com, mgorman@techsingularity.net, mhocko@kernel.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        osalvador@suse.de, pankaj.gupta.linux@gmail.com,
        richard.weiyang@linux.alibaba.com, rppt@kernel.org,
        sthemmin@microsoft.com, vbabka@suse.cz, wei.liu@kernel.org,
        willy@infradead.org
Subject:  +
 mm-page_alloc-move-pages-to-tail-in-move_to_free_list.patch added to -mm
 tree
Message-ID: <20201006045721.0WBozzWGR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: move pages to tail in move_to_free_list()
has been added to the -mm tree.  Its filename is
     mm-page_alloc-move-pages-to-tail-in-move_to_free_list.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-move-pages-to-tail-in-move_to_free_list.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-move-pages-to-tail-in-move_to_free_list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
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

mm-page_alloc-tweak-comments-in-has_unmovable_pages.patch
mm-page_isolation-exit-early-when-pageblock-is-isolated-in-set_migratetype_isolate.patch
mm-page_isolation-drop-warn_on_once-in-set_migratetype_isolate.patch
mm-page_isolation-cleanup-set_migratetype_isolate.patch
virtio-mem-dont-special-case-zone_movable.patch
mm-document-semantics-of-zone_movable.patch
mm-memory_hotplug-inline-__offline_pages-into-offline_pages.patch
mm-memory_hotplug-enforce-section-granularity-when-onlining-offlining.patch
mm-memory_hotplug-simplify-page-offlining.patch
mm-page_alloc-simplify-__offline_isolated_pages.patch
mm-memory_hotplug-drop-nr_isolate_pageblock-in-offline_pages.patch
mm-page_isolation-simplify-return-value-of-start_isolate_page_range.patch
mm-memory_hotplug-simplify-page-onlining.patch
mm-page_alloc-drop-stale-pageblock-comment-in-memmap_init_zone.patch
mm-pass-migratetype-into-memmap_init_zone-and-move_pfn_range_to_zone.patch
mm-memory_hotplug-mark-pageblocks-migrate_isolate-while-onlining-memory.patch
kernel-resource-make-release_mem_region_adjustable-never-fail.patch
kernel-resource-move-and-rename-ioresource_mem_driver_managed.patch
mm-memory_hotplug-guard-more-declarations-by-config_memory_hotplug.patch
mm-memory_hotplug-prepare-passing-flags-to-add_memory-and-friends.patch
mm-memory_hotplug-memhp_merge_resource-to-specify-merging-of-system-ram-resources.patch
virtio-mem-try-to-merge-system-ram-resources.patch
xen-balloon-try-to-merge-system-ram-resources.patch
hv_balloon-try-to-merge-system-ram-resources.patch
kernel-resource-make-iomem_resource-implicit-in-release_mem_region_adjustable.patch
mm-page_alloc-convert-report-flag-of-__free_one_page-to-a-proper-flag.patch
mm-page_alloc-place-pages-to-tail-in-__putback_isolated_page.patch
mm-page_alloc-move-pages-to-tail-in-move_to_free_list.patch
mm-page_alloc-place-pages-to-tail-in-__free_pages_core.patch
mm-memory_hotplug-update-comment-regarding-zone-shuffling.patch

