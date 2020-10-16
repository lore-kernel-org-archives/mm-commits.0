Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C75EC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:50:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1564A21655
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881418;
	bh=mad+PhPbbqzRHnOJQhbotonpg+8DvrpkhBhiCBog8LI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=jK0JnU/TuF36+4qdjvKlCY2iwPs+MW8cT2aXnOQ44L7CXQhKYP7l9yQ+2tGvHwnQB
	 UGkDjS5hp9mR0E0PUf0JzddfmD9zddFCbFyevtbr4SkWQDspwH5KHV86lBvO3+jUxs
	 cERpvEc17x90665m/0wK4qQPUc0gWD1pYGVXU0RY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392735AbgJPUuR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:50:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392725AbgJPUuR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:50:17 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B8572145D;
        Fri, 16 Oct 2020 20:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881416;
        bh=mad+PhPbbqzRHnOJQhbotonpg+8DvrpkhBhiCBog8LI=;
        h=Date:From:To:Subject:From;
        b=DMzymaVLLQh331wWjfGt1mkkaUH+GGrvKUf/dvP//uUa0Z+o3NwU/ChDCWuD9PV9V
         wc3yI3MDLJxcjK5QZ6ivIHYNfQ1XBThGSMACzP1TG27ThLONK1Aas5Ajuvbgx0gkab
         V/JuLfHAFgB6Wc3ULDd5q65sgE7r26V7Atxs6aHc=
Date:   Fri, 16 Oct 2020 13:50:14 -0700
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, charante@codeaurora.org, dan.j.williams@intel.com,
        david@redhat.com, fenghua.yu@intel.com, logang@deltatee.com,
        mgorman@suse.de, mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        pankaj.gupta.linux@gmail.com, richard.weiyang@linux.alibaba.com,
        rppt@kernel.org, tony.luck@intel.com, walken@google.com,
        willy@infradead.org
Subject:  [merged] mm-memory_hotplug-simplify-page-offlining.patch
 removed from -mm tree
Message-ID: <20201016205014.UfCLFEoo4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: simplify page offlining
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-simplify-page-offlining.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: simplify page offlining

We make sure that we cannot have any memory holes right at the beginning
of offline_pages().  We no longer need walk_system_ram_range() and can
call test_pages_isolated() and __offline_isolated_pages() directly.

offlined_pages always corresponds to nr_pages, so we can simplify that.

[akpm@linux-foundation.org: patch conflict resolution]
Link: https://lkml.kernel.org/r/20200819175957.28465-4-david@redhat.com
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

 mm/memory_hotplug.c |   44 +++++++++---------------------------------
 1 file changed, 10 insertions(+), 34 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-simplify-page-offlining
+++ a/mm/memory_hotplug.c
@@ -1384,28 +1384,6 @@ do_migrate_range(unsigned long start_pfn
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
@@ -1492,7 +1470,7 @@ static int count_system_ram_pages_cb(uns
 int __ref offline_pages(unsigned long start_pfn, unsigned long nr_pages)
 {
 	const unsigned long end_pfn = start_pfn + nr_pages;
-	unsigned long pfn, system_ram_pages = 0, offlined_pages = 0;
+	unsigned long pfn, system_ram_pages = 0;
 	int ret, node, nr_isolate_pageblock;
 	unsigned long flags;
 	struct zone *zone;
@@ -1590,9 +1568,7 @@ int __ref offline_pages(unsigned long st
 			reason = "failure to dissolve huge pages";
 			goto failed_removal_isolated;
 		}
-		/* check again */
-		ret = walk_system_ram_range(start_pfn, end_pfn - start_pfn,
-					    NULL, check_pages_isolated_cb);
+
 		/*
 		 * per-cpu pages are drained in start_isolate_page_range, but if
 		 * there are still pages that are not free, make sure that we
@@ -1605,15 +1581,15 @@ int __ref offline_pages(unsigned long st
 		 * because has_unmovable_pages explicitly checks for
 		 * PageBuddy on freed pages on other zones.
 		 */
+		ret = test_pages_isolated(start_pfn, end_pfn, MEMORY_OFFLINE);
 		if (ret)
 			drain_all_pages(zone);
 	} while (ret);
 
-	/* Ok, all of our target is isolated.
-	   We cannot do rollback at this point. */
-	walk_system_ram_range(start_pfn, end_pfn - start_pfn,
-			      &offlined_pages, offline_isolated_pages_cb);
-	pr_info("Offlined Pages %ld\n", offlined_pages);
+	/* Mark all sections offline and remove free pages from the buddy. */
+	__offline_isolated_pages(start_pfn, end_pfn);
+	pr_info("Offlined Pages %ld\n", nr_pages);
+
 	/*
 	 * Onlining will reset pagetype flags and makes migrate type
 	 * MOVABLE, so just need to decrease the number of isolated
@@ -1624,11 +1600,11 @@ int __ref offline_pages(unsigned long st
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


