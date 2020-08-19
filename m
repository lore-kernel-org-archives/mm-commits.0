Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8F4AC433E1
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 18:20:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 964C620758
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 18:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597861244;
	bh=8A9tExD/S4dvPSY38XcM5BxFfpPhL32wJ43tdMb14lc=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=qSKzsG5WElB9TodRQIi9Pn71A54F3fuq+gLg9f4kdMZ0pjIboAyHhqJ5DWVpoIYNt
	 GmQpLjK8FgGTve38Qw8jjqwgjKAPPTPi+ziWg/UZxeivawrHa5g9GV8pYRh57fJj/5
	 7j1YMPjAtzZWuZZOrnAVQlkXx6t/8V/g4vzCw/6E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgHSSUo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Aug 2020 14:20:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726578AbgHSSUn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Aug 2020 14:20:43 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1292420882;
        Wed, 19 Aug 2020 18:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597861242;
        bh=8A9tExD/S4dvPSY38XcM5BxFfpPhL32wJ43tdMb14lc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=uhL7tduTvwyc9285uGx02gP1uWRdcNX0oBZ00iKOchc7/APEOi6TiebSfSS/hO+xv
         n3iv+nt2G0rUBViz+2KkRZf6XnefnnNyogJoo8eLDzFOXNKx1IUbZQxX3BhLk+hvE0
         RXc4IBdE6b3MZUrb6+euSUjJXCgZLEa2gIqjo+9A=
Date:   Wed, 19 Aug 2020 11:20:41 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     bhe@redhat.com, charante@codeaurora.org, dan.j.williams@intel.com,
        david@redhat.com, fenghua.yu@intel.com, logang@deltatee.com,
        mgorman@suse.de, mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        pankaj.gupta.linux@gmail.com, richard.weiyang@linux.alibaba.com,
        rppt@kernel.org, tony.luck@intel.com, walken@google.com,
        willy@infradead.org
Subject:  + mm-memory_hotplug-simplify-page-offlining.patch added
 to -mm tree
Message-ID: <20200819182041.DBjhaI-SU%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: simplify page offlining
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-simplify-page-offlining.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-simplify-page-offlining.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-simplify-page-offlining.patch

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
Subject: mm/memory_hotplug: simplify page offlining

We make sure that we cannot have any memory holes right at the beginning
of offline_pages().  We no longer need walk_system_ram_range() and can
call test_pages_isolated() and __offline_isolated_pages() directly.

offlined_pages always corresponds to nr_pages, so we can simplify that.

Link: https://lkml.kernel.org/r/20200819175957.28465-4-david@redhat.com
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

 mm/memory_hotplug.c |   46 +++++++++---------------------------------
 1 file changed, 10 insertions(+), 36 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-simplify-page-offlining
+++ a/mm/memory_hotplug.c
@@ -1375,28 +1375,6 @@ do_migrate_range(unsigned long start_pfn
 	return ret;
 }
 
-/* Mark all sections offline and remove all free pages from the buddy. */
-static int
-offline_isolated_pages_cb(unsigned long start, unsigned long nr_pages,
-			void *data)
-{
-	unsigned long *offlined_pages = (unsigned long *)data;
-
-	*offlined_pages += __offline_isolated_pages(start, start + nr_pages);
-	return 0;
-}
-
-/*
- * Check all pages in range, recorded as memory resource, are isolated.
- */
-static int
-check_pages_isolated_cb(unsigned long start_pfn, unsigned long nr_pages,
-			void *data)
-{
-	return test_pages_isolated(start_pfn, start_pfn + nr_pages,
-				   MEMORY_OFFLINE);
-}
-
 static int __init cmdline_parse_movable_node(char *p)
 {
 	movable_node_enabled = true;
@@ -1483,7 +1461,7 @@ static int count_system_ram_pages_cb(uns
 int __ref offline_pages(unsigned long start_pfn, unsigned long nr_pages)
 {
 	const unsigned long end_pfn = start_pfn + nr_pages;
-	unsigned long pfn, system_ram_pages = 0, offlined_pages = 0;
+	unsigned long pfn, system_ram_pages = 0;
 	int ret, node, nr_isolate_pageblock;
 	unsigned long flags;
 	struct zone *zone;
@@ -1581,16 +1559,12 @@ int __ref offline_pages(unsigned long st
 			reason = "failure to dissolve huge pages";
 			goto failed_removal_isolated;
 		}
-		/* check again */
-		ret = walk_system_ram_range(start_pfn, end_pfn - start_pfn,
-					    NULL, check_pages_isolated_cb);
-	} while (ret);
-
-	/* Ok, all of our target is isolated.
-	   We cannot do rollback at this point. */
-	walk_system_ram_range(start_pfn, end_pfn - start_pfn,
-			      &offlined_pages, offline_isolated_pages_cb);
-	pr_info("Offlined Pages %ld\n", offlined_pages);
+	} while (test_pages_isolated(start_pfn, end_pfn, MEMORY_OFFLINE));
+
+	/* Mark all sections offline and remove free pages from the buddy. */
+	__offline_isolated_pages(start_pfn, end_pfn);
+	pr_info("Offlined Pages %ld\n", nr_pages);
+
 	/*
 	 * Onlining will reset pagetype flags and makes migrate type
 	 * MOVABLE, so just need to decrease the number of isolated
@@ -1601,11 +1575,11 @@ int __ref offline_pages(unsigned long st
 	spin_unlock_irqrestore(&zone->lock, flags);
 
 	/* removal success */
-	adjust_managed_page_count(pfn_to_page(start_pfn), -offlined_pages);
-	zone->present_pages -= offlined_pages;
+	adjust_managed_page_count(pfn_to_page(start_pfn), -nr_pages);
+	zone->present_pages -= nr_pages;
 
 	pgdat_resize_lock(zone->zone_pgdat, &flags);
-	zone->zone_pgdat->node_present_pages -= offlined_pages;
+	zone->zone_pgdat->node_present_pages -= nr_pages;
 	pgdat_resize_unlock(zone->zone_pgdat, &flags);
 
 	init_per_zone_wmark_min();
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

