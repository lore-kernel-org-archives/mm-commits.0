Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D186C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jan 2021 00:03:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33B9264D99
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jan 2021 00:03:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbhA1ACy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Jan 2021 19:02:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:50006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231162AbhA1ACt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 Jan 2021 19:02:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F321164DCE;
        Thu, 28 Jan 2021 00:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611792128;
        bh=6iVEZJQLAbO7FAeHzix9C3ebQwQIldGYue24hJtoQZY=;
        h=Date:From:To:Subject:From;
        b=BggfBarniiDCexHb3wC13s4TbVPQ8FC0IEToGn2g6II9554veoak7+BjLfFZENv5f
         bCu7MVfIx1uCjWJnP82IqNbMztu/qtPxBOiRJn7htqjqB9MAm+yG4DO26hJb2VUVRm
         sQqjr0DdCBRvpU+cYcCCei6ZrvSdyqO9/3hz4N2w=
Date:   Wed, 27 Jan 2021 16:02:07 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@kernel.org, mm-commits@vger.kernel.org,
        osalvador@suse.de, peterz@infradead.org,
        richard.weiyang@linux.alibaba.com, rppt@kernel.org,
        tglx@linutronix.de, ziy@nvidia.com
Subject:  +
 =?US-ASCII?Q?mm-page=5Falloc-count-cma-pages-per-zone-and-print-them-in?=
 =?US-ASCII?Q?-proc-zoneinfo.patch?= added to -mm tree
Message-ID: <20210128000207.W42zrnfel%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: count CMA pages per zone and print them in /proc/zoneinfo
has been added to the -mm tree.  Its filename is
     mm-page_alloc-count-cma-pages-per-zone-and-print-them-in-proc-zoneinfo.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-count-cma-pages-per-zone-and-print-them-in-proc-zoneinfo.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-count-cma-pages-per-zone-and-print-them-in-proc-zoneinfo.patch

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
Subject: mm/page_alloc: count CMA pages per zone and print them in /proc/zoneinfo

Let's count the number of CMA pages per zone and print them in
/proc/zoneinfo.

Having access to the total number of CMA pages per zone is helpful for
debugging purposes to know where exactly the CMA pages ended up, and to
figure out how many pages of a zone might behave differently (e.g., like
ZONE_MOVABLE) - even after some of these pages might already have been
allocated.

For now, we are only able to get the global nr+free cma pages from
/proc/meminfo and the free cma pages per zone from /proc/zoneinfo.

Note: Track/print that information even without CONFIG_CMA, similar to
"nr_free_cma" in /proc/zoneinfo.  This is different to /proc/meminfo -
maybe we want to make that consistent in the future (however, changing
/proc/zoneinfo output might uglify the code a bit).

Link: https://lkml.kernel.org/r/20210127101813.6370-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    4 ++++
 mm/page_alloc.c        |    1 +
 mm/vmstat.c            |    6 ++++--
 3 files changed, 9 insertions(+), 2 deletions(-)

--- a/include/linux/mmzone.h~mm-page_alloc-count-cma-pages-per-zone-and-print-them-in-proc-zoneinfo
+++ a/include/linux/mmzone.h
@@ -503,6 +503,9 @@ struct zone {
 	 * bootmem allocator):
 	 *	managed_pages = present_pages - reserved_pages;
 	 *
+	 * cma pages is present pages that are assigned for CMA use
+	 * (MIGRATE_CMA).
+	 *
 	 * So present_pages may be used by memory hotplug or memory power
 	 * management logic to figure out unmanaged pages by checking
 	 * (present_pages - managed_pages). And managed_pages should be used
@@ -527,6 +530,7 @@ struct zone {
 	atomic_long_t		managed_pages;
 	unsigned long		spanned_pages;
 	unsigned long		present_pages;
+	unsigned long		cma_pages;
 
 	const char		*name;
 
--- a/mm/page_alloc.c~mm-page_alloc-count-cma-pages-per-zone-and-print-them-in-proc-zoneinfo
+++ a/mm/page_alloc.c
@@ -2168,6 +2168,7 @@ void __init init_cma_reserved_pageblock(
 	}
 
 	adjust_managed_page_count(page, pageblock_nr_pages);
+	page_zone(page)->cma_pages += pageblock_nr_pages;
 }
 #endif
 
--- a/mm/vmstat.c~mm-page_alloc-count-cma-pages-per-zone-and-print-them-in-proc-zoneinfo
+++ a/mm/vmstat.c
@@ -1637,14 +1637,16 @@ static void zoneinfo_show_print(struct s
 		   "\n        high     %lu"
 		   "\n        spanned  %lu"
 		   "\n        present  %lu"
-		   "\n        managed  %lu",
+		   "\n        managed  %lu"
+		   "\n        cma      %lu",
 		   zone_page_state(zone, NR_FREE_PAGES),
 		   min_wmark_pages(zone),
 		   low_wmark_pages(zone),
 		   high_wmark_pages(zone),
 		   zone->spanned_pages,
 		   zone->present_pages,
-		   zone_managed_pages(zone));
+		   zone_managed_pages(zone),
+		   zone->cma_pages);
 
 	seq_printf(m,
 		   "\n        protection: (%ld",
_

Patches currently in -mm which might be from david@redhat.com are

video-fbdev-acornfb-remove-free_unused_pages.patch
mm-simplify-free_highmem_page-and-free_reserved_page.patch
mm-cma-expose-all-pages-to-the-buddy-if-activation-of-an-area-fails.patch
mm-page_alloc-count-cma-pages-per-zone-and-print-them-in-proc-zoneinfo.patch
mm-memory_hotplug-memhp_merge_resource-mhp_merge_resource.patch

