From: akpm@linux-foundation.org
Subject: [alternative-merged] mm-fix-a-regression-with-highmem-introduced-by-changeset-7f1290f2f2a4d.patch removed from -mm tree
Date: Thu, 15 Nov 2012 11:25:20 -0800
Message-ID: <20121115192521.F1D5A200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:58349 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768768Ab2KOTZZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Nov 2012 14:25:25 -0500
Received: by mail-we0-f202.google.com with SMTP id x43so135228wey.1
        for <mm-commits@vger.kernel.org>; Thu, 15 Nov 2012 11:25:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiang.liu@huawei.com, chris2553@googlemail.com, kamezawa.hiroyu@jp.fujitsu.com, maciej.rutecki@gmail.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, rjw@sisk.pl, wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix a regression with HIGHMEM
has been removed from the -mm tree.  Its filename was
     mm-fix-a-regression-with-highmem-introduced-by-changeset-7f1290f2f2a4d.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Jiang Liu <jiang.liu@huawei.com>
Subject: mm: fix a regression with HIGHMEM

Changeset 7f1290f2f2 ("mm: fix-up zone present pages") tried to fix a
issue when calculating zone->present_pages, but it causes a regression to
32bit systems with HIGHMEM.  With that changeset,
reset_zone_present_pages() resets all zone->present_pages to zero, and
fixup_zone_present_pages() is called to recalculate zone->present_pages
when the boot allocator frees core memory pages into the buddy allocator. 
Because highmem pages are not freed by bootmem allocator, all highmem
zones' present_pages becomes zero.

Actually there's no need to recalculate present_pages for the highmem zone
because the bootmem allocator never allocates pages from it.  So fix the
regression by skipping highmem in function reset_zone_present_pages() and
fixup_zone_present_pages().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Reported-by: Maciej Rutecki <maciej.rutecki@gmail.com>
Tested-by: Maciej Rutecki <maciej.rutecki@gmail.com>
Tested-by: Chris Clayton <chris2553@googlemail.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-fix-a-regression-with-highmem-introduced-by-changeset-7f1290f2f2a4d mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-a-regression-with-highmem-introduced-by-changeset-7f1290f2f2a4d
+++ a/mm/page_alloc.c
@@ -6108,7 +6108,8 @@ void reset_zone_present_pages(void)
 	for_each_node_state(nid, N_HIGH_MEMORY) {
 		for (i = 0; i < MAX_NR_ZONES; i++) {
 			z = NODE_DATA(nid)->node_zones + i;
-			z->present_pages = 0;
+			if (!is_highmem(z))
+				z->present_pages = 0;
 		}
 	}
 }
@@ -6123,10 +6124,11 @@ void fixup_zone_present_pages(int nid, u
 
 	for (i = 0; i < MAX_NR_ZONES; i++) {
 		z = NODE_DATA(nid)->node_zones + i;
+		if (is_highmem(z))
+			continue;
+
 		zone_start_pfn = z->zone_start_pfn;
 		zone_end_pfn = zone_start_pfn + z->spanned_pages;
