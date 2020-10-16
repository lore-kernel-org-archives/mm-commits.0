Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34ED7C43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCA8F2087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817694;
	bh=/GXdQy0i9xoqMZ6zs7xVT9rFtrrZd+wmG75JlbBpekc=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=MvJppH5lYp/+sS98V/903Nz+xHOkesIF53ETnYC5iFAVc/GmOd263xlzXPZSzp6lt
	 jYi4vU77XGdrxHeVGTNOsfSvjBgGL9YYoXXllYOIxG/ZNR1+nIsFE8cFQc4mJlb1WW
	 KRsoD/nYWmwlfEd+rsivhUeMuXpsm5M+qrDQAwRY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732377AbgJPDIO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:08:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:45926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727382AbgJPDIO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:08:14 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F059820878;
        Fri, 16 Oct 2020 03:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817692;
        bh=/GXdQy0i9xoqMZ6zs7xVT9rFtrrZd+wmG75JlbBpekc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=CFpNYS+bqgvkp88B1ZqXOLauMMj+gZJafb1g/rMyZUIdSJFYcsBbR0hy8t7q6DEu6
         7gI3mjkDTwHABmsgWlWY0oMM4t+3vQjf1gvaqdk5lrTd7r4lTYPWwrfpmBHjYr2g3G
         4BF53lWNM8oEliDNuBMcIj9q/ayWI0OWxkVY+QzQ=
Date:   Thu, 15 Oct 2020 20:08:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com, charante@codeaurora.org,
        dan.j.williams@intel.com, david@redhat.com, fenghua.yu@intel.com,
        logang@deltatee.com, mgorman@suse.de, mgorman@techsingularity.net,
        mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        pankaj.gupta.linux@gmail.com, richard.weiyang@linux.alibaba.com,
        rppt@kernel.org, tony.luck@intel.com,
        torvalds@linux-foundation.org, walken@google.com,
        willy@infradead.org
Subject:  [patch 065/156] mm/memory_hotplug: simplify page onlining
Message-ID: <20201016030811.oB--W04MD%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: simplify page onlining

We don't allow to offline memory with holes, all boot memory is online,
and all hotplugged memory cannot have holes.

We can now simplify onlining of pages.  As we only allow to online/offline
full sections and sections always span full MAX_ORDER_NR_PAGES, we can
just process MAX_ORDER - 1 pages without further special handling.

The number of onlined pages simply corresponds to the number of pages we
were requested to online.

While at it, refine the comment regarding the callback not exposing all
pages to the buddy.

Link: https://lkml.kernel.org/r/20200819175957.28465-8-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Charan Teja Reddy <charante@codeaurora.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michel Lespinasse <walken@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   38 ++++++++++----------------------------
 1 file changed, 10 insertions(+), 28 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-simplify-page-onlining
+++ a/mm/memory_hotplug.c
@@ -625,31 +625,22 @@ void generic_online_page(struct page *pa
 }
 EXPORT_SYMBOL_GPL(generic_online_page);
 
-static int online_pages_range(unsigned long start_pfn, unsigned long nr_pages,
-			void *arg)
+static void online_pages_range(unsigned long start_pfn, unsigned long nr_pages)
 {
 	const unsigned long end_pfn = start_pfn + nr_pages;
 	unsigned long pfn;
-	int order;
 
 	/*
-	 * Online the pages. The callback might decide to keep some pages
-	 * PG_reserved (to add them to the buddy later), but we still account
-	 * them as being online/belonging to this zone ("present").
+	 * Online the pages in MAX_ORDER - 1 aligned chunks. The callback might
+	 * decide to not expose all pages to the buddy (e.g., expose them
+	 * later). We account all pages as being online and belonging to this
+	 * zone ("present").
 	 */
-	for (pfn = start_pfn; pfn < end_pfn; pfn += 1ul << order) {
-		order = min(MAX_ORDER - 1, get_order(PFN_PHYS(end_pfn - pfn)));
-		/* __free_pages_core() wants pfns to be aligned to the order */
-		if (WARN_ON_ONCE(!IS_ALIGNED(pfn, 1ul << order)))
-			order = 0;
-		(*online_page_callback)(pfn_to_page(pfn), order);
-	}
+	for (pfn = start_pfn; pfn < end_pfn; pfn += MAX_ORDER_NR_PAGES)
+		(*online_page_callback)(pfn_to_page(pfn), MAX_ORDER - 1);
 
 	/* mark all involved sections as online */
 	online_mem_sections(start_pfn, end_pfn);
-
-	*(unsigned long *)arg += nr_pages;
-	return 0;
 }
 
 /* check which state of node_states will be changed when online memory */
@@ -803,7 +794,6 @@ int __ref online_pages(unsigned long pfn
 		       int online_type, int nid)
 {
 	unsigned long flags;
-	unsigned long onlined_pages = 0;
 	struct zone *zone;
 	int need_zonelists_rebuild = 0;
 	int ret;
@@ -839,19 +829,11 @@ int __ref online_pages(unsigned long pfn
 		setup_zone_pageset(zone);
 	}
 
-	ret = walk_system_ram_range(pfn, nr_pages, &onlined_pages,
-		online_pages_range);
-	if (ret) {
-		/* not a single memory resource was applicable */
-		if (need_zonelists_rebuild)
-			zone_pcp_reset(zone);
-		goto failed_addition;
-	}
-
-	zone->present_pages += onlined_pages;
+	online_pages_range(pfn, nr_pages);
+	zone->present_pages += nr_pages;
 
 	pgdat_resize_lock(zone->zone_pgdat, &flags);
-	zone->zone_pgdat->node_present_pages += onlined_pages;
+	zone->zone_pgdat->node_present_pages += nr_pages;
 	pgdat_resize_unlock(zone->zone_pgdat, &flags);
 
 	/*
_
