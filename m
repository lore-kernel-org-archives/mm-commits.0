Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0F96C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 18:20:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFFD0208E4
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 18:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597861258;
	bh=d0LpiOf0kPp7gTKe7zxBvdm5dFdeImReRqyNwv+yfW8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=2vzSGM8GeeraoWoe/ppY8/kBmvZkXAtaIECFgDIafhY19vikx7aZf0PSxUp3uAvgV
	 8v+f7fPpvP5Sf/oDtPAE49sX/IDNiqaybNf0bRc3Ea3sNARkfDuTrPwzBTQJi5bQEl
	 9hg0dZ3Fg+riVi9IpCViSEqYZeEX04eZSqyM36KA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgHSSU5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Aug 2020 14:20:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726578AbgHSSU4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Aug 2020 14:20:56 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E176C20786;
        Wed, 19 Aug 2020 18:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597861255;
        bh=d0LpiOf0kPp7gTKe7zxBvdm5dFdeImReRqyNwv+yfW8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Do2/qrr5KpObuG8YUwp9sknb8LfQtf5NBp998sUQKPKiBaPtFIYbHitLr57Uaftox
         YWzSeuX5xdRGrTbB1WjNyMDRhwK7XVDHep3bAXytmgClfRC2LiPlzPUeIuV1PiQe9G
         z1UlAGbmuLHudiEjxTpI85QvbkwQwPMqZQz96FKE=
Date:   Wed, 19 Aug 2020 11:20:54 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     bhe@redhat.com, charante@codeaurora.org, dan.j.williams@intel.com,
        david@redhat.com, fenghua.yu@intel.com, logang@deltatee.com,
        mgorman@suse.de, mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        pankaj.gupta.linux@gmail.com, richard.weiyang@linux.alibaba.com,
        rppt@kernel.org, tony.luck@intel.com, walken@google.com,
        willy@infradead.org
Subject:  + mm-memory_hotplug-simplify-page-onlining.patch added to
 -mm tree
Message-ID: <20200819182054.yzcK2KI1I%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: simplify page onlining
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-simplify-page-onlining.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-simplify-page-onlining.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-simplify-page-onlining.patch

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
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
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
@@ -617,31 +617,22 @@ void generic_online_page(struct page *pa
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
@@ -795,7 +786,6 @@ int __ref online_pages(unsigned long pfn
 		       int online_type, int nid)
 {
 	unsigned long flags;
-	unsigned long onlined_pages = 0;
 	struct zone *zone;
 	int need_zonelists_rebuild = 0;
 	int ret;
@@ -831,19 +821,11 @@ int __ref online_pages(unsigned long pfn
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

