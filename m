Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E5A9C43381
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:08:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AE3864F08
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:08:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235172AbhBXUH6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:07:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:59454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235211AbhBXUHU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:07:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D2ED64F0F;
        Wed, 24 Feb 2021 20:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197178;
        bh=NkZ36CXExD/jG4Elx6ZSK/DhOKkW17k04iCAoMGaVlQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=CPT/Kp9sLndW2VjRIbABZ2bmDdiRchOZd52CmlJSVrdBe7clEySwdB2yHQMA1DkgP
         kstT4qWoG1mZ5WcHRB3Fu9cB1RxgSzCE1EhuoZUmqeKCh8m+1PLKWDvSpS9dwNiosg
         wCjdQEy8lKZpXLf0D0Oqw2c1QdK9mrx1H9DWhqqQ=
Date:   Wed, 24 Feb 2021 12:06:17 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com, david@redhat.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org
Subject:  [patch 104/173] mm: simplify parater of function
 memmap_init_zone()
Message-ID: <20210224200617.MCRE7bWj9%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Baoquan He <bhe@redhat.com>
Subject: mm: simplify parater of function memmap_init_zone()

As David suggested, simply passing 'struct zone *zone' is enough.  We can
get all needed information from 'struct zone*' easily.

Link: https://lkml.kernel.org/r/20210122135956.5946-4-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/init.c |   12 +++++++-----
 include/linux/mm.h  |    3 +--
 mm/page_alloc.c     |   24 +++++++++++-------------
 3 files changed, 19 insertions(+), 20 deletions(-)

--- a/arch/ia64/mm/init.c~mm-simplify-parater-of-function-memmap_init_zone
+++ a/arch/ia64/mm/init.c
@@ -542,12 +542,14 @@ virtual_memmap_init(u64 start, u64 end,
 	return 0;
 }
 
-void __meminit
-memmap_init_zone(unsigned long size, int nid, unsigned long zone,
-	     unsigned long start_pfn)
+void __meminit memmap_init_zone(struct zone *zone)
 {
+	int nid = zone_to_nid(zone), zone_id = zone_idx(zone);
+	unsigned long start_pfn = zone->zone_start_pfn;
+	unsigned long size = zone->spanned_pages;
+
 	if (!vmem_map) {
-		memmap_init_range(size, nid, zone, start_pfn, start_pfn + size,
+		memmap_init_range(size, nid, zone_id, start_pfn, start_pfn + size,
 				 MEMINIT_EARLY, NULL, MIGRATE_MOVABLE);
 	} else {
 		struct page *start;
@@ -557,7 +559,7 @@ memmap_init_zone(unsigned long size, int
 		args.start = start;
 		args.end = start + size;
 		args.nid = nid;
-		args.zone = zone;
+		args.zone = zone_id;
 
 		efi_memmap_walk(virtual_memmap_init, &args);
 	}
--- a/include/linux/mm.h~mm-simplify-parater-of-function-memmap_init_zone
+++ a/include/linux/mm.h
@@ -2408,8 +2408,7 @@ extern void set_dma_reserve(unsigned lon
 extern void memmap_init_range(unsigned long, int, unsigned long,
 		unsigned long, unsigned long, enum meminit_context,
 		struct vmem_altmap *, int migratetype);
-extern void memmap_init_zone(unsigned long size, int nid,
-		unsigned long zone, unsigned long range_start_pfn);
+extern void memmap_init_zone(struct zone *zone);
 extern void setup_per_zone_wmarks(void);
 extern int __meminit init_per_zone_wmark_min(void);
 extern void mem_init(void);
--- a/mm/page_alloc.c~mm-simplify-parater-of-function-memmap_init_zone
+++ a/mm/page_alloc.c
@@ -6258,23 +6258,21 @@ static void __meminit zone_init_free_lis
 	}
 }
 
-void __meminit __weak memmap_init_zone(unsigned long size, int nid,
-				  unsigned long zone,
-				  unsigned long range_start_pfn)
+void __meminit __weak memmap_init_zone(struct zone *zone)
 {
+	unsigned long zone_start_pfn = zone->zone_start_pfn;
+	unsigned long zone_end_pfn = zone_start_pfn + zone->spanned_pages;
+	int i, nid = zone_to_nid(zone), zone_id = zone_idx(zone);
 	unsigned long start_pfn, end_pfn;
-	unsigned long range_end_pfn = range_start_pfn + size;
-	int i;
 
 	for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
-		start_pfn = clamp(start_pfn, range_start_pfn, range_end_pfn);
-		end_pfn = clamp(end_pfn, range_start_pfn, range_end_pfn);
+		start_pfn = clamp(start_pfn, zone_start_pfn, zone_end_pfn);
+		end_pfn = clamp(end_pfn, zone_start_pfn, zone_end_pfn);
 
-		if (end_pfn > start_pfn) {
-			size = end_pfn - start_pfn;
-			memmap_init_range(size, nid, zone, start_pfn, range_end_pfn,
-					 MEMINIT_EARLY, NULL, MIGRATE_MOVABLE);
-		}
+		if (end_pfn > start_pfn)
+			memmap_init_range(end_pfn - start_pfn, nid,
+					zone_id, start_pfn, zone_end_pfn,
+					MEMINIT_EARLY, NULL, MIGRATE_MOVABLE);
 	}
 }
 
@@ -6982,7 +6980,7 @@ static void __init free_area_init_core(s
 		set_pageblock_order();
 		setup_usemap(pgdat, zone, zone_start_pfn, size);
 		init_currently_empty_zone(zone, zone_start_pfn, size);
-		memmap_init_zone(size, nid, j, zone_start_pfn);
+		memmap_init_zone(zone);
 	}
 }
 
_
