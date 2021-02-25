Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFB84C433E6
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:31:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8E1364F45
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:31:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234704AbhBYTbV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:31:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:38378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234660AbhBYT2Q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:28:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85C9364F84;
        Thu, 25 Feb 2021 19:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280566;
        bh=/RMZBFzr4MIQbo5I4xeQxB1Xurky9nEt0sQBRTBAZlI=;
        h=Date:From:To:Subject:From;
        b=CsXUBWbyurJzAjZMLFE/C2XDsmdDRua6fbfcx1+/wv2EBYU7o+qxWkUMeWC59vXQv
         1te+YJmyRRz+ZA2irmeyTQEF0FHlFLS5jXzo38fMtbWZ7lE2wmM+3wHvgN61eacEuq
         /atWkCRGqhRq7kFPJhuHedZL+62C5z1pvbvLdwTU=
Date:   Thu, 25 Feb 2021 11:16:06 -0800
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, david@redhat.com, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com
Subject:  [merged] mm-rename-memmap_init-and-memmap_init_zone.patch
 removed from -mm tree
Message-ID: <20210225191606.eZ17rhkLF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rename memmap_init() and memmap_init_zone()
has been removed from the -mm tree.  Its filename was
     mm-rename-memmap_init-and-memmap_init_zone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm: rename memmap_init() and memmap_init_zone()

The current memmap_init_zone() only handles memory region inside one zone,
actually memmap_init() does the memmap init of one zone.  So rename both
of them accordingly.

Link: https://lkml.kernel.org/r/20210122135956.5946-3-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/init.c |    6 +++---
 include/linux/mm.h  |    4 ++--
 mm/memory_hotplug.c |    2 +-
 mm/page_alloc.c     |    8 ++++----
 4 files changed, 10 insertions(+), 10 deletions(-)

--- a/arch/ia64/mm/init.c~mm-rename-memmap_init-and-memmap_init_zone
+++ a/arch/ia64/mm/init.c
@@ -536,18 +536,18 @@ virtual_memmap_init(u64 start, u64 end,
 		    / sizeof(struct page));
 
 	if (map_start < map_end)
-		memmap_init_zone((unsigned long)(map_end - map_start),
+		memmap_init_range((unsigned long)(map_end - map_start),
 				 args->nid, args->zone, page_to_pfn(map_start), page_to_pfn(map_end),
 				 MEMINIT_EARLY, NULL, MIGRATE_MOVABLE);
 	return 0;
 }
 
 void __meminit
-memmap_init (unsigned long size, int nid, unsigned long zone,
+memmap_init_zone(unsigned long size, int nid, unsigned long zone,
 	     unsigned long start_pfn)
 {
 	if (!vmem_map) {
-		memmap_init_zone(size, nid, zone, start_pfn, start_pfn + size,
+		memmap_init_range(size, nid, zone, start_pfn, start_pfn + size,
 				 MEMINIT_EARLY, NULL, MIGRATE_MOVABLE);
 	} else {
 		struct page *start;
--- a/include/linux/mm.h~mm-rename-memmap_init-and-memmap_init_zone
+++ a/include/linux/mm.h
@@ -2405,10 +2405,10 @@ extern int __meminit early_pfn_to_nid(un
 #endif
 
 extern void set_dma_reserve(unsigned long new_dma_reserve);
-extern void memmap_init_zone(unsigned long, int, unsigned long,
+extern void memmap_init_range(unsigned long, int, unsigned long,
 		unsigned long, unsigned long, enum meminit_context,
 		struct vmem_altmap *, int migratetype);
-extern void memmap_init(unsigned long size, int nid,
+extern void memmap_init_zone(unsigned long size, int nid,
 		unsigned long zone, unsigned long range_start_pfn);
 extern void setup_per_zone_wmarks(void);
 extern int __meminit init_per_zone_wmark_min(void);
--- a/mm/memory_hotplug.c~mm-rename-memmap_init-and-memmap_init_zone
+++ a/mm/memory_hotplug.c
@@ -713,7 +713,7 @@ void __ref move_pfn_range_to_zone(struct
 	 * expects the zone spans the pfn range. All the pages in the range
 	 * are reserved so nobody should be touching them so we should be safe
 	 */
-	memmap_init_zone(nr_pages, nid, zone_idx(zone), start_pfn, 0,
+	memmap_init_range(nr_pages, nid, zone_idx(zone), start_pfn, 0,
 			 MEMINIT_HOTPLUG, altmap, migratetype);
 
 	set_zone_contiguous(zone);
--- a/mm/page_alloc.c~mm-rename-memmap_init-and-memmap_init_zone
+++ a/mm/page_alloc.c
@@ -6121,7 +6121,7 @@ overlap_memmap_init(unsigned long zone,
  * (usually MIGRATE_MOVABLE). Besides setting the migratetype, no related
  * zone stats (e.g., nr_isolate_pageblock) are touched.
  */
-void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
+void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone,
 		unsigned long start_pfn, unsigned long zone_end_pfn,
 		enum meminit_context context,
 		struct vmem_altmap *altmap, int migratetype)
@@ -6258,7 +6258,7 @@ static void __meminit zone_init_free_lis
 	}
 }
 
-void __meminit __weak memmap_init(unsigned long size, int nid,
+void __meminit __weak memmap_init_zone(unsigned long size, int nid,
 				  unsigned long zone,
 				  unsigned long range_start_pfn)
 {
@@ -6272,7 +6272,7 @@ void __meminit __weak memmap_init(unsign
 
 		if (end_pfn > start_pfn) {
 			size = end_pfn - start_pfn;
-			memmap_init_zone(size, nid, zone, start_pfn, range_end_pfn,
+			memmap_init_range(size, nid, zone, start_pfn, range_end_pfn,
 					 MEMINIT_EARLY, NULL, MIGRATE_MOVABLE);
 		}
 	}
@@ -6982,7 +6982,7 @@ static void __init free_area_init_core(s
 		set_pageblock_order();
 		setup_usemap(pgdat, zone, zone_start_pfn, size);
 		init_currently_empty_zone(zone, zone_start_pfn, size);
-		memmap_init(size, nid, j, zone_start_pfn);
+		memmap_init_zone(size, nid, j, zone_start_pfn);
 	}
 }
 
_

Patches currently in -mm which might be from bhe@redhat.com are


