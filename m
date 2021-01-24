Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61C21C433E0
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:53:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22995229F0
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbhAXBxq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 23 Jan 2021 20:53:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:50890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726433AbhAXBxp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 23 Jan 2021 20:53:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 493C8229F0;
        Sun, 24 Jan 2021 01:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611453184;
        bh=Wckkrxw1oD5uaTvog6acmX8IevqCDamwJ69AnRYcX60=;
        h=Date:From:To:Subject:From;
        b=MEmehutXJgpwMP+Qf0bsuGyCz0THSm0FDXrEfJykFjWp7JlXchxj26XClBEMOF+gM
         ik6SfpKYFFu4KQlWenPUPQipdWYKx5eUpSymlFzsHqsy1uq+gV8D+WFhM6nFzNv2LE
         EcycecDJWlUcRY/kJ2YAhQzWCqFiJLTkXf7+8bUs=
Date:   Sat, 23 Jan 2021 17:53:03 -0800
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, david@redhat.com, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com
Subject:  + mm-rename-memmap_init-and-memmap_init_zone.patch added
 to -mm tree
Message-ID: <20210124015303.kAwRmP9w3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rename memmap_init() and memmap_init_zone()
has been added to the -mm tree.  Its filename is
     mm-rename-memmap_init-and-memmap_init_zone.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-rename-memmap_init-and-memmap_init_zone.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-rename-memmap_init-and-memmap_init_zone.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -535,18 +535,18 @@ virtual_memmap_init(u64 start, u64 end,
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
@@ -2439,10 +2439,10 @@ extern int __meminit early_pfn_to_nid(un
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
@@ -6119,7 +6119,7 @@ overlap_memmap_init(unsigned long zone,
  * (usually MIGRATE_MOVABLE). Besides setting the migratetype, no related
  * zone stats (e.g., nr_isolate_pageblock) are touched.
  */
-void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
+void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone,
 		unsigned long start_pfn, unsigned long zone_end_pfn,
 		enum meminit_context context,
 		struct vmem_altmap *altmap, int migratetype)
@@ -6256,7 +6256,7 @@ static void __meminit zone_init_free_lis
 	}
 }
 
-void __meminit __weak memmap_init(unsigned long size, int nid,
+void __meminit __weak memmap_init_zone(unsigned long size, int nid,
 				  unsigned long zone,
 				  unsigned long range_start_pfn)
 {
@@ -6270,7 +6270,7 @@ void __meminit __weak memmap_init(unsign
 
 		if (end_pfn > start_pfn) {
 			size = end_pfn - start_pfn;
-			memmap_init_zone(size, nid, zone, start_pfn, range_end_pfn,
+			memmap_init_range(size, nid, zone, start_pfn, range_end_pfn,
 					 MEMINIT_EARLY, NULL, MIGRATE_MOVABLE);
 		}
 	}
@@ -6980,7 +6980,7 @@ static void __init free_area_init_core(s
 		set_pageblock_order();
 		setup_usemap(pgdat, zone, zone_start_pfn, size);
 		init_currently_empty_zone(zone, zone_start_pfn, size);
-		memmap_init(size, nid, j, zone_start_pfn);
+		memmap_init_zone(size, nid, j, zone_start_pfn);
 	}
 }
 
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-fix-prototype-warning-from-kernel-test-robot.patch
mm-rename-memmap_init-and-memmap_init_zone.patch
mm-simplify-parater-of-function-memmap_init_zone.patch
mm-simplify-parameter-of-setup_usemap.patch
mm-remove-unneeded-local-variable-in-free_area_init_core.patch

