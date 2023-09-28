Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13B71E732E9
	for <mm-commits@archiver.kernel.org>; Thu, 28 Sep 2023 16:25:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbjI1QZE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Sep 2023 12:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbjI1QZD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Sep 2023 12:25:03 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6481B0
        for <mm-commits@vger.kernel.org>; Thu, 28 Sep 2023 09:25:01 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 307D0C433C7;
        Thu, 28 Sep 2023 16:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695918301;
        bh=Pa6r+n/9+y/ugreBzaT2xv46lGb7d12W5+JxBrPcQS4=;
        h=Date:To:From:Subject:From;
        b=DrEbbv+5Y0FJudkBRguB/UnXYF49Ub4AlCCPFKj+fAFh4WQDV99A5AT5C5YjELz4e
         F8oXm8q95t2+daXAcxlUdNfBsaQO8WDOVElolnBSUTcOOvs+wy1uMb+vVwbfJEDgLc
         Xre7wdsXFrB0uG0yL5QoJrZV3DqFIkxQa1IkdwXs=
Date:   Thu, 28 Sep 2023 09:25:00 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, rppt@kernel.org,
        muchun.song@linux.dev, mike.kravetz@oracle.com, david@redhat.com,
        yajun.deng@linux.dev, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pass-page-count-and-reserved-to-__init_single_page.patch added to mm-unstable branch
Message-Id: <20230928162501.307D0C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: pass page count and reserved to __init_single_page
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pass-page-count-and-reserved-to-__init_single_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pass-page-count-and-reserved-to-__init_single_page.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
@@ -3064,7 +3064,7 @@ static void __init hugetlb_folio_init_ta
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
mm-pass-page-count-and-reserved-to-__init_single_page.patch
mm-init-page-count-in-reserve_bootmem_region-when-meminit_early.patch

