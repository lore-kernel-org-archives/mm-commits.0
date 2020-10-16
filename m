Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C61D0C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:50:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72133216C4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881442;
	bh=tILzd79AtNbk0fM5ku88QMP2+tNpcUGvcuO/t0FwTSY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ib/lxe23kBPnjvWSBvRXnbJSCoVITcGqlnR8RMZRDAFo0K5sACr392Kfs6sUB6jJp
	 A8zKO6mY4Fe8g2U4RMxdJHuVtu4D5d9l71l+GOGFYm79gbMxPkoYFiAd/VLUwsQt2Y
	 UyWtxK/VSwZxPdXHwcS51uwJ25lYYnuy6ZVWMQ2k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392741AbgJPUum (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:50:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:39502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392725AbgJPUul (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:50:41 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29F2B20878;
        Fri, 16 Oct 2020 20:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881441;
        bh=tILzd79AtNbk0fM5ku88QMP2+tNpcUGvcuO/t0FwTSY=;
        h=Date:From:To:Subject:From;
        b=kGokEPch4fb13vzVqDr+mp0Y8ku7UpH0e2pvpp/rrLJyP8qO2RwHXewaqzIjJjrZF
         PoLj7XZZb2mSvgPAjssnm+D6UJlyXlBaZmX1WqdfKHHIyY1a4Nle4D+vxGQZmsO2MF
         tKHZbi0MykcPRvSk591w05H7Ffw4iljqfsq+2EEY=
Date:   Fri, 16 Oct 2020 13:50:38 -0700
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, charante@codeaurora.org, dan.j.williams@intel.com,
        david@redhat.com, fenghua.yu@intel.com, logang@deltatee.com,
        mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        pankaj.gupta.linux@gmail.com, richard.weiyang@linux.alibaba.com,
        rppt@kernel.org, tony.luck@intel.com, walken@google.com,
        willy@infradead.org
Subject:  [merged]
 mm-pass-migratetype-into-memmap_init_zone-and-move_pfn_range_to_zone.patch
 removed from -mm tree
Message-ID: <20201016205038.ibUL9MJuN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: pass migratetype into memmap_init_zone() and move_pfn_range_to_zone()
has been removed from the -mm tree.  Its filename was
     mm-pass-migratetype-into-memmap_init_zone-and-move_pfn_range_to_zone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: pass migratetype into memmap_init_zone() and move_pfn_range_to_zone()

On the memory onlining path, we want to start with MIGRATE_ISOLATE, to
un-isolate the pages after memory onlining is complete.  Let's allow
passing in the migratetype.

Link: https://lkml.kernel.org/r/20200819175957.28465-10-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Charan Teja Reddy <charante@codeaurora.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/init.c            |    4 ++--
 include/linux/memory_hotplug.h |    3 ++-
 include/linux/mm.h             |    2 +-
 mm/memory_hotplug.c            |   11 ++++++++---
 mm/memremap.c                  |    3 ++-
 mm/page_alloc.c                |   21 ++++++++++++---------
 6 files changed, 27 insertions(+), 17 deletions(-)

--- a/arch/ia64/mm/init.c~mm-pass-migratetype-into-memmap_init_zone-and-move_pfn_range_to_zone
+++ a/arch/ia64/mm/init.c
@@ -537,7 +537,7 @@ virtual_memmap_init(u64 start, u64 end,
 	if (map_start < map_end)
 		memmap_init_zone((unsigned long)(map_end - map_start),
 				 args->nid, args->zone, page_to_pfn(map_start),
-				 MEMINIT_EARLY, NULL);
+				 MEMINIT_EARLY, NULL, MIGRATE_MOVABLE);
 	return 0;
 }
 
@@ -547,7 +547,7 @@ memmap_init (unsigned long size, int nid
 {
 	if (!vmem_map) {
 		memmap_init_zone(size, nid, zone, start_pfn,
-				 MEMINIT_EARLY, NULL);
+				 MEMINIT_EARLY, NULL, MIGRATE_MOVABLE);
 	} else {
 		struct page *start;
 		struct memmap_init_callback_data args;
--- a/include/linux/memory_hotplug.h~mm-pass-migratetype-into-memmap_init_zone-and-move_pfn_range_to_zone
+++ a/include/linux/memory_hotplug.h
@@ -351,7 +351,8 @@ extern int add_memory_resource(int nid,
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
@@ -2440,7 +2440,7 @@ extern int __meminit __early_pfn_to_nid(
 
 extern void set_dma_reserve(unsigned long new_dma_reserve);
 extern void memmap_init_zone(unsigned long, int, unsigned long, unsigned long,
-		enum meminit_context, struct vmem_altmap *);
+		enum meminit_context, struct vmem_altmap *, int migratetype);
 extern void setup_per_zone_wmarks(void);
 extern int __meminit init_per_zone_wmark_min(void);
 extern void mem_init(void);
--- a/mm/memory_hotplug.c~mm-pass-migratetype-into-memmap_init_zone-and-move_pfn_range_to_zone
+++ a/mm/memory_hotplug.c
@@ -701,9 +701,14 @@ static void __meminit resize_pgdat_range
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
@@ -728,7 +733,7 @@ void __ref move_pfn_range_to_zone(struct
 	 * are reserved so nobody should be touching them so we should be safe
 	 */
 	memmap_init_zone(nr_pages, nid, zone_idx(zone), start_pfn,
-			 MEMINIT_HOTPLUG, altmap);
+			 MEMINIT_HOTPLUG, altmap, migratetype);
 
 	set_zone_contiguous(zone);
 }
@@ -808,7 +813,7 @@ int __ref online_pages(unsigned long pfn
 
 	/* associate pfn range with the zone */
 	zone = zone_for_pfn_range(online_type, nid, pfn, nr_pages);
-	move_pfn_range_to_zone(zone, pfn, nr_pages, NULL);
+	move_pfn_range_to_zone(zone, pfn, nr_pages, NULL, MIGRATE_MOVABLE);
 
 	arg.start_pfn = pfn;
 	arg.nr_pages = nr_pages;
--- a/mm/memremap.c~mm-pass-migratetype-into-memmap_init_zone-and-move_pfn_range_to_zone
+++ a/mm/memremap.c
@@ -266,7 +266,8 @@ static int pagemap_range(struct dev_page
 
 		zone = &NODE_DATA(nid)->node_zones[ZONE_DEVICE];
 		move_pfn_range_to_zone(zone, PHYS_PFN(range->start),
-				PHYS_PFN(range_len(range)), params->altmap);
+				PHYS_PFN(range_len(range)), params->altmap,
+				MIGRATE_MOVABLE);
 	}
 
 	mem_hotplug_done();
--- a/mm/page_alloc.c~mm-pass-migratetype-into-memmap_init_zone-and-move_pfn_range_to_zone
+++ a/mm/page_alloc.c
@@ -5990,10 +5990,15 @@ overlap_memmap_init(unsigned long zone,
  * Initially all pages are reserved - free ones are freed
  * up by memblock_free_all() once the early boot process is
  * done. Non-atomic initialization, single-pass.
+ *
+ * All aligned pageblocks are initialized to the specified migratetype
+ * (usually MIGRATE_MOVABLE). Besides setting the migratetype, no related
+ * zone stats (e.g., nr_isolate_pageblock) are touched.
  */
 void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
-		unsigned long start_pfn, enum meminit_context context,
-		struct vmem_altmap *altmap)
+		unsigned long start_pfn,
+		enum meminit_context context,
+		struct vmem_altmap *altmap, int migratetype)
 {
 	unsigned long pfn, end_pfn = start_pfn + size;
 	struct page *page;
@@ -6037,14 +6042,12 @@ void __meminit memmap_init_zone(unsigned
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
@@ -6144,7 +6147,7 @@ void __meminit __weak memmap_init(unsign
 		if (end_pfn > start_pfn) {
 			size = end_pfn - start_pfn;
 			memmap_init_zone(size, nid, zone, start_pfn,
-					 MEMINIT_EARLY, NULL);
+					 MEMINIT_EARLY, NULL, MIGRATE_MOVABLE);
 		}
 	}
 }
_

Patches currently in -mm which might be from david@redhat.com are


