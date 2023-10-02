Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90217E743C3
	for <mm-commits@archiver.kernel.org>; Mon,  2 Oct 2023 15:55:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238280AbjJBPzr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 2 Oct 2023 11:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238297AbjJBPzq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 2 Oct 2023 11:55:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69215E9
        for <mm-commits@vger.kernel.org>; Mon,  2 Oct 2023 08:55:43 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3310C433C7;
        Mon,  2 Oct 2023 15:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696262143;
        bh=RbSgWr0FE+HqLDH654IGHSXo2ZkGagSs41FerLOM4rM=;
        h=Date:To:From:Subject:From;
        b=BSQlAzGK3/A5OuiaeYzdmNf5rxHdxJugd7pYC6dIgCyaEJJZ4Ydu0ZqLlqMGu9Lsy
         YiHvoNVlJsKOVupFcnKLjyL0TfVT8+RcuxwmsnS8q35R//7p2uyHX+dxQf+vuQ+HWS
         Xc/lEJIiGMqOVvxRbpHb268pg/AF3p3ciLj2Pnwo=
Date:   Mon, 02 Oct 2023 08:55:42 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, rppt@kernel.org,
        muchun.song@linux.dev, mike.kravetz@oracle.com, david@redhat.com,
        yajun.deng@linux.dev, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-init-page-count-in-reserve_bootmem_region-when-meminit_early.patch removed from -mm tree
Message-Id: <20231002155542.E3310C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: init page count in reserve_bootmem_region when MEMINIT_EARLY
has been removed from the -mm tree.  Its filename was
     mm-init-page-count-in-reserve_bootmem_region-when-meminit_early.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Yajun Deng <yajun.deng@linux.dev>
Subject: mm: init page count in reserve_bootmem_region when MEMINIT_EARLY
Date: Thu, 28 Sep 2023 16:33:02 +0800

memmap_init_range() would init page count of all pages, but the free pages
count would be reset in __free_pages_core().  There are opposite
operations.  It's unnecessary and time-consuming when it's MEMINIT_EARLY
context.

Init page count in reserve_bootmem_region when in MEMINIT_EARLY context,
and check the page count before reset it.

At the same time, the INIT_LIST_HEAD in reserve_bootmem_region isn't
need, as it already done in __init_single_page.

The following data was tested on an x86 machine with 190GB of RAM.

before:
free_low_memory_core_early()    341ms

after:
free_low_memory_core_early()    285ms

Link: https://lkml.kernel.org/r/20230928083302.386202-3-yajun.deng@linux.dev
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c    |   18 +++++++++++++-----
 mm/page_alloc.c |   20 ++++++++++++--------
 2 files changed, 25 insertions(+), 13 deletions(-)

--- a/mm/mm_init.c~mm-init-page-count-in-reserve_bootmem_region-when-meminit_early
+++ a/mm/mm_init.c
@@ -718,7 +718,7 @@ static void __meminit init_reserved_page
 		if (zone_spans_pfn(zone, pfn))
 			break;
 	}
-	__init_single_page(pfn_to_page(pfn), pfn, zid, nid, INIT_PAGE_COUNT);
+	__init_single_page(pfn_to_page(pfn), pfn, zid, nid, 0);
 }
 #else
 static inline void pgdat_set_deferred_range(pg_data_t *pgdat) {}
@@ -756,8 +756,8 @@ void __meminit reserve_bootmem_region(ph
 
 			init_reserved_page(start_pfn, nid);
 
-			/* Avoid false-positive PageTail() */
-			INIT_LIST_HEAD(&page->lru);
+			/* Init page count for reserved region */
+			init_page_count(page);
 
 			/*
 			 * no need for atomic set_bit because the struct
@@ -888,9 +888,17 @@ void __meminit memmap_init_range(unsigne
 		}
 
 		page = pfn_to_page(pfn);
-		__init_single_page(page, pfn, zone, nid, INIT_PAGE_COUNT);
-		if (context == MEMINIT_HOTPLUG)
+
+		/* If the context is MEMINIT_EARLY, we will init page count and
+		 * mark page reserved in reserve_bootmem_region, the free region
+		 * wouldn't have page count and we will check the pages count
+		 * in __free_pages_core.
+		 */
+		__init_single_page(page, pfn, zone, nid, 0);
+		if (context == MEMINIT_HOTPLUG) {
+			init_page_count(page);
 			__SetPageReserved(page);
+		}
 
 		/*
 		 * Usually, we want to mark the pageblock MIGRATE_MOVABLE,
--- a/mm/page_alloc.c~mm-init-page-count-in-reserve_bootmem_region-when-meminit_early
+++ a/mm/page_alloc.c
@@ -1289,18 +1289,22 @@ void __free_pages_core(struct page *page
 	unsigned int loop;
 
 	/*
-	 * When initializing the memmap, __init_single_page() sets the refcount
-	 * of all pages to 1 ("allocated"/"not free"). We have to set the
-	 * refcount of all involved pages to 0.
+	 * When initializing the memmap, memmap_init_range sets the refcount
+	 * of all pages to 1 ("reserved" and "free") in hotplug context. We
+	 * have to set the refcount of all involved pages to 0. Otherwise,
+	 * we don't do it, as reserve_bootmem_region only set the refcount on
+	 * reserve region ("reserved") in early context.
 	 */
-	prefetchw(p);
-	for (loop = 0; loop < (nr_pages - 1); loop++, p++) {
-		prefetchw(p + 1);
+	if (page_count(page)) {
+		prefetchw(p);
+		for (loop = 0; loop < (nr_pages - 1); loop++, p++) {
+			prefetchw(p + 1);
+			__ClearPageReserved(p);
+			set_page_count(p, 0);
+		}
 		__ClearPageReserved(p);
 		set_page_count(p, 0);
 	}
-	__ClearPageReserved(p);
-	set_page_count(p, 0);
 
 	atomic_long_add(nr_pages, &page_zone(page)->managed_pages);
 
_

Patches currently in -mm which might be from yajun.deng@linux.dev are

mm-mm_initc-remove-redundant-pr_info-when-node-is-memoryless.patch

