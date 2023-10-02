Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33A9FE748E9
	for <mm-commits@archiver.kernel.org>; Mon,  2 Oct 2023 15:55:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238275AbjJBPzq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 2 Oct 2023 11:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238280AbjJBPzp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 2 Oct 2023 11:55:45 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763EAD8
        for <mm-commits@vger.kernel.org>; Mon,  2 Oct 2023 08:55:42 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42E9C433CC;
        Mon,  2 Oct 2023 15:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696262141;
        bh=6/khGoOEdsLeW0SpA3OjAQfs/8ANRDPonmmjh4vFhdY=;
        h=Date:To:From:Subject:From;
        b=bHT9/Sbtj5bwRzBLdI4fpm/vqoxMYSUphU/aNqPccyRup1YFK7ZQmHt5M2UcyU4v8
         3XqS+RjkSTyV9f8wSZzuAMORLIFSfhN9McHkl7rMVfL/Q5B4ZeJCa4BX77CW6YYVQR
         bCg+wybL042Z47OEYet+TUdEHa/6b4y7jRX8du6A=
Date:   Mon, 02 Oct 2023 08:55:40 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, rppt@kernel.org,
        muchun.song@linux.dev, mike.kravetz@oracle.com, david@redhat.com,
        yajun.deng@linux.dev, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-pass-page-count-and-reserved-to-__init_single_page.patch removed from -mm tree
Message-Id: <20231002155541.B42E9C433CC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: pass page count and reserved to __init_single_page
has been removed from the -mm tree.  Its filename was
     mm-pass-page-count-and-reserved-to-__init_single_page.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Yajun Deng <yajun.deng@linux.dev>
Subject: mm: pass page count and reserved to __init_single_page
Date: Thu, 28 Sep 2023 16:33:01 +0800

Patch series "mm: Don't set and reset page count in MEMINIT_EARLY", v4.

__init_single_page would set page count and __free_pages_core would reset
it.  A lot of pages don't need to do this when in MEMINIT_EARLY context. 
It's unnecessary and time-consuming.

The 1st patch is to pass page count and reserved to __init_single_page. 
It's in preparation for the 2nd patch, it didn't change anything.

The 2nd patch only set page count for the reserved region, not all of the
region.


This patch (of 2):

When we init a single page, we need to mark that page reserved when it is
reserved.  And some pages need to reset page count, such as compound
pages.

Introduce enum init_page_flags, the caller will init page count and mark
page reserved by passing INIT_PAGE_COUNT and INIT_PAGE_RESERVED.

Link: https://lkml.kernel.org/r/20230928083302.386202-1-yajun.deng@linux.dev
Link: https://lkml.kernel.org/r/20230928083302.386202-2-yajun.deng@linux.dev
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c  |    2 +-
 mm/internal.h |    8 +++++++-
 mm/mm_init.c  |   24 +++++++++++++-----------
 3 files changed, 21 insertions(+), 13 deletions(-)

--- a/mm/hugetlb.c~mm-pass-page-count-and-reserved-to-__init_single_page
+++ a/mm/hugetlb.c
@@ -3208,7 +3208,7 @@ static void __init hugetlb_folio_init_ta
 	for (pfn = head_pfn + start_page_number; pfn < end_pfn; pfn++) {
 		struct page *page = pfn_to_page(pfn);
 
-		__init_single_page(page, pfn, zone, nid);
+		__init_single_page(page, pfn, zone, nid, INIT_PAGE_COUNT);
 		prep_compound_tail((struct page *)folio, pfn - head_pfn);
 		ret = page_ref_freeze(page, 1);
 		VM_BUG_ON(!ret);
--- a/mm/internal.h~mm-pass-page-count-and-reserved-to-__init_single_page
+++ a/mm/internal.h
@@ -1209,8 +1209,14 @@ struct vma_prepare {
 	struct vm_area_struct *remove2;
 };
 
+enum init_page_flags {
+	INIT_PAGE_COUNT    = (1 << 0),
+	INIT_PAGE_RESERVED = (1 << 1),
+};
+
 void __meminit __init_single_page(struct page *page, unsigned long pfn,
-				unsigned long zone, int nid);
+				  unsigned long zone, int nid,
+				  enum init_page_flags flags);
 
 /* shrinker related functions */
 unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
--- a/mm/mm_init.c~mm-pass-page-count-and-reserved-to-__init_single_page
+++ a/mm/mm_init.c
@@ -557,11 +557,11 @@ out:
 }
 
 void __meminit __init_single_page(struct page *page, unsigned long pfn,
-				unsigned long zone, int nid)
+				  unsigned long zone, int nid,
+				  enum init_page_flags flags)
 {
 	mm_zero_struct_page(page);
 	set_page_links(page, zone, nid, pfn);
-	init_page_count(page);
 	page_mapcount_reset(page);
 	page_cpupid_reset_last(page);
 	page_kasan_tag_reset(page);
@@ -572,6 +572,10 @@ void __meminit __init_single_page(struct
 	if (!is_highmem_idx(zone))
 		set_page_address(page, __va(pfn << PAGE_SHIFT));
 #endif
+	if (flags & INIT_PAGE_COUNT)
+		init_page_count(page);
+	if (flags & INIT_PAGE_RESERVED)
+		__SetPageReserved(page);
 }
 
 #ifdef CONFIG_NUMA
@@ -714,7 +718,7 @@ static void __meminit init_reserved_page
 		if (zone_spans_pfn(zone, pfn))
 			break;
 	}
-	__init_single_page(pfn_to_page(pfn), pfn, zid, nid);
+	__init_single_page(pfn_to_page(pfn), pfn, zid, nid, INIT_PAGE_COUNT);
 }
 #else
 static inline void pgdat_set_deferred_range(pg_data_t *pgdat) {}
@@ -821,8 +825,8 @@ static void __init init_unavailable_rang
 			pfn = pageblock_end_pfn(pfn) - 1;
 			continue;
 		}
-		__init_single_page(pfn_to_page(pfn), pfn, zone, node);
-		__SetPageReserved(pfn_to_page(pfn));
+		__init_single_page(pfn_to_page(pfn), pfn, zone, node,
+				   INIT_PAGE_COUNT | INIT_PAGE_RESERVED);
 		pgcnt++;
 	}
 
@@ -884,7 +888,7 @@ void __meminit memmap_init_range(unsigne
 		}
 
 		page = pfn_to_page(pfn);
-		__init_single_page(page, pfn, zone, nid);
+		__init_single_page(page, pfn, zone, nid, INIT_PAGE_COUNT);
 		if (context == MEMINIT_HOTPLUG)
 			__SetPageReserved(page);
 
@@ -967,9 +971,6 @@ static void __ref __init_zone_device_pag
 					  unsigned long zone_idx, int nid,
 					  struct dev_pagemap *pgmap)
 {
-
-	__init_single_page(page, pfn, zone_idx, nid);
-
 	/*
 	 * Mark page reserved as it will need to wait for onlining
 	 * phase for it to be fully associated with a zone.
@@ -977,7 +978,8 @@ static void __ref __init_zone_device_pag
 	 * We can use the non-atomic __set_bit operation for setting
 	 * the flag as we are still initializing the pages.
 	 */
-	__SetPageReserved(page);
+	__init_single_page(page, pfn, zone_idx, nid,
+			   INIT_PAGE_COUNT | INIT_PAGE_RESERVED);
 
 	/*
 	 * ZONE_DEVICE pages union ->lru with a ->pgmap back pointer
@@ -2058,7 +2060,7 @@ static unsigned long  __init deferred_in
 		} else {
 			page++;
 		}
-		__init_single_page(page, pfn, zid, nid);
+		__init_single_page(page, pfn, zid, nid, INIT_PAGE_COUNT);
 		nr_pages++;
 	}
 	return (nr_pages);
_

Patches currently in -mm which might be from yajun.deng@linux.dev are

mm-mm_initc-remove-redundant-pr_info-when-node-is-memoryless.patch
mm-init-page-count-in-reserve_bootmem_region-when-meminit_early.patch

