Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABC04C433E4
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 18:21:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85DFE20786
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 18:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597861266;
	bh=VUryOqtWb485whbP/BB3PZd8sZ5SfqVfyNKWQz+o1GI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=1Qlc+MvZunR0bQMWHWfPnj/MIZRi4PRKdRyrheBRniG5x8dqaAqH2IZLLirti+8nF
	 Zd9KQ/Dp6Dy6lg1qOrExh8+aHXH0WUN1zfg4eI1PtYQKijJf2sSFfUslajmh2HJb7K
	 wTW6NMJVg39oRXLySmbWIS29/b7/WvtQbGfk+OyE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgHSSVG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Aug 2020 14:21:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:43754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726578AbgHSSVD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Aug 2020 14:21:03 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14A0720B1F;
        Wed, 19 Aug 2020 18:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597861261;
        bh=VUryOqtWb485whbP/BB3PZd8sZ5SfqVfyNKWQz+o1GI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=02/62xahRs3s1b1xc/lQyQ9aN+WXOsClPV5WkcQBMiZ/KQfz8YoF1Q/9bg4eHj0F7
         u//CmUvQRc5Zyn3Uv3s2xdq9XX8VnKvLh8yJ0LSzQj4LvIHgOStMlVByov9A/6KoWf
         vry6qkPH3xtl1lRWwox84yyLUeZAdy6cj1fphaWA=
Date:   Wed, 19 Aug 2020 11:21:00 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     bhe@redhat.com, charante@codeaurora.org, dan.j.williams@intel.com,
        david@redhat.com, fenghua.yu@intel.com, logang@deltatee.com,
        mgorman@suse.de, mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        pankaj.gupta.linux@gmail.com, richard.weiyang@linux.alibaba.com,
        rppt@kernel.org, tony.luck@intel.com, walken@google.com,
        willy@infradead.org
Subject:  +
 mm-pass-migratetype-into-memmap_init_zone-and-move_pfn_range_to_zone.patch
 added to -mm tree
Message-ID: <20200819182100.9GWaSTOj0%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: pass migratetype into memmap_init_zone() and move_pfn_range_to_zone()
has been added to the -mm tree.  Its filename is
     mm-pass-migratetype-into-memmap_init_zone-and-move_pfn_range_to_zone.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-pass-migratetype-into-memmap_init_zone-and-move_pfn_range_to_zone.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-pass-migratetype-into-memmap_init_zone-and-move_pfn_range_to_zone.patch

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
Subject: mm: pass migratetype into memmap_init_zone() and move_pfn_range_to_zone()

On the memory onlining path, we want to start with MIGRATE_ISOLATE, to
un-isolate the pages after memory onlining is complete.  Let's allow
passing in the migratetype.

Link: https://lkml.kernel.org/r/20200819175957.28465-10-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Charan Teja Reddy <charante@codeaurora.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/init.c            |    4 ++--
 include/linux/memory_hotplug.h |    3 ++-
 include/linux/mm.h             |    3 ++-
 mm/memory_hotplug.c            |   11 ++++++++---
 mm/memremap.c                  |    3 ++-
 mm/page_alloc.c                |   21 ++++++++++++---------
 6 files changed, 28 insertions(+), 17 deletions(-)

--- a/arch/ia64/mm/init.c~mm-pass-migratetype-into-memmap_init_zone-and-move_pfn_range_to_zone
+++ a/arch/ia64/mm/init.c
@@ -538,7 +538,7 @@ virtual_memmap_init(u64 start, u64 end,
 	if (map_start < map_end)
 		memmap_init_zone((unsigned long)(map_end - map_start),
 				 args->nid, args->zone, page_to_pfn(map_start),
-				 MEMMAP_EARLY, NULL);
+				 MEMMAP_EARLY, NULL, MIGRATE_MOVABLE);
 	return 0;
 }
 
@@ -548,7 +548,7 @@ memmap_init (unsigned long size, int nid
 {
 	if (!vmem_map) {
 		memmap_init_zone(size, nid, zone, start_pfn, MEMMAP_EARLY,
-				NULL);
+				 NULL, MIGRATE_MOVABLE);
 	} else {
 		struct page *start;
 		struct memmap_init_callback_data args;
--- a/include/linux/memory_hotplug.h~mm-pass-migratetype-into-memmap_init_zone-and-move_pfn_range_to_zone
+++ a/include/linux/memory_hotplug.h
@@ -346,7 +346,8 @@ extern int add_memory_resource(int nid,
 extern int add_memory_driver_managed(int nid, u64 start, u64 size,
 				     const char *resource_name);
 extern void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
-		unsigned long nr_pages, struct vmem_altmap *altmap);
+				   unsigned long nr_pages,
+				   struct vmem_altmap *altmap, int migratetype);
 extern void remove_pfn_range_from_zone(struct zone *zone,
 				       unsigned long start_pfn,
 				       unsigned long nr_pages);
--- a/include/linux/mm.h~mm-pass-migratetype-into-memmap_init_zone-and-move_pfn_range_to_zone
+++ a/include/linux/mm.h
@@ -2425,7 +2425,8 @@ extern int __meminit __early_pfn_to_nid(
 
 extern void set_dma_reserve(unsigned long new_dma_reserve);
 extern void memmap_init_zone(unsigned long, int, unsigned long, unsigned long,
-		enum memmap_context, struct vmem_altmap *);
+			    enum memmap_context, struct vmem_altmap *,
+			    int migratetype);
 extern void setup_per_zone_wmarks(void);
 extern int __meminit init_per_zone_wmark_min(void);
 extern void mem_init(void);
--- a/mm/memory_hotplug.c~mm-pass-migratetype-into-memmap_init_zone-and-move_pfn_range_to_zone
+++ a/mm/memory_hotplug.c
@@ -693,9 +693,14 @@ static void __meminit resize_pgdat_range
  * Associate the pfn range with the given zone, initializing the memmaps
  * and resizing the pgdat/zone data to span the added pages. After this
  * call, all affected pages are PG_reserved.
+ *
+ * All aligned pageblocks are initialized to the specified migratetype
+ * (usually MIGRATE_MOVABLE). Besides setting the migratetype, no related
+ * zone stats (e.g., nr_isolate_pageblock) are touched.
  */
 void __ref move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
-		unsigned long nr_pages, struct vmem_altmap *altmap)
+				  unsigned long nr_pages,
+				  struct vmem_altmap *altmap, int migratetype)
 {
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	int nid = pgdat->node_id;
@@ -720,7 +725,7 @@ void __ref move_pfn_range_to_zone(struct
 	 * are reserved so nobody should be touching them so we should be safe
 	 */
 	memmap_init_zone(nr_pages, nid, zone_idx(zone), start_pfn,
-			MEMMAP_HOTPLUG, altmap);
+			 MEMMAP_HOTPLUG, altmap, migratetype);
 
 	set_zone_contiguous(zone);
 }
@@ -800,7 +805,7 @@ int __ref online_pages(unsigned long pfn
 
 	/* associate pfn range with the zone */
 	zone = zone_for_pfn_range(online_type, nid, pfn, nr_pages);
-	move_pfn_range_to_zone(zone, pfn, nr_pages, NULL);
+	move_pfn_range_to_zone(zone, pfn, nr_pages, NULL, MIGRATE_MOVABLE);
 
 	arg.start_pfn = pfn;
 	arg.nr_pages = nr_pages;
--- a/mm/memremap.c~mm-pass-migratetype-into-memmap_init_zone-and-move_pfn_range_to_zone
+++ a/mm/memremap.c
@@ -342,7 +342,8 @@ void *memremap_pages(struct dev_pagemap
 
 		zone = &NODE_DATA(nid)->node_zones[ZONE_DEVICE];
 		move_pfn_range_to_zone(zone, PHYS_PFN(res->start),
-				PHYS_PFN(resource_size(res)), params.altmap);
+				       PHYS_PFN(resource_size(res)),
+				       params.altmap, MIGRATE_MOVABLE);
 	}
 
 	mem_hotplug_done();
--- a/mm/page_alloc.c~mm-pass-migratetype-into-memmap_init_zone-and-move_pfn_range_to_zone
+++ a/mm/page_alloc.c
@@ -5973,10 +5973,15 @@ overlap_memmap_init(unsigned long zone,
  * Initially all pages are reserved - free ones are freed
  * up by memblock_free_all() once the early boot process is
  * done. Non-atomic initialization, single-pass.
+ *
+ * All aligned pageblocks are initialized to the specified migratetype
+ * (usually MIGRATE_MOVABLE). Besides setting the migratetype, no related
+ * zone stats (e.g., nr_isolate_pageblock) are touched.
  */
 void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
-		unsigned long start_pfn, enum memmap_context context,
-		struct vmem_altmap *altmap)
+				unsigned long start_pfn,
+				enum memmap_context context,
+				struct vmem_altmap *altmap, int migratetype)
 {
 	unsigned long pfn, end_pfn = start_pfn + size;
 	struct page *page;
@@ -6020,14 +6025,12 @@ void __meminit memmap_init_zone(unsigned
 			__SetPageReserved(page);
 
 		/*
-		 * Mark the block movable so that blocks are reserved for
-		 * movable at startup. This will force kernel allocations
-		 * to reserve their blocks rather than leaking throughout
-		 * the address space during boot when many long-lived
-		 * kernel allocations are made.
+		 * Usually, we want to mark the pageblock MIGRATE_MOVABLE,
+		 * such that unmovable allocations won't be scattered all
+		 * over the place during system boot.
 		 */
 		if (IS_ALIGNED(pfn, pageblock_nr_pages)) {
-			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
+			set_pageblock_migratetype(page, migratetype);
 			cond_resched();
 		}
 		pfn++;
@@ -6127,7 +6130,7 @@ void __meminit __weak memmap_init(unsign
 		if (end_pfn > start_pfn) {
 			size = end_pfn - start_pfn;
 			memmap_init_zone(size, nid, zone, start_pfn,
-					 MEMMAP_EARLY, NULL);
+					 MEMMAP_EARLY, NULL, MIGRATE_MOVABLE);
 		}
 	}
 }
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

