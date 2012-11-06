From: akpm@linux-foundation.org
Subject: + mm-fix-a-regression-with-highmem-introduced-by-changeset-7f1290f2f2a4d.patch added to -mm tree
Date: Tue, 06 Nov 2012 12:43:35 -0800
Message-ID: <20121106204335.D39B6100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:60247 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab2KFUnh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2012 15:43:37 -0500
Received: by mail-yh0-f74.google.com with SMTP id 10so92402yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Nov 2012 12:43:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jiang.liu@huawei.com, chris2553@googlemail.com, kamezawa.hiroyu@jp.fujitsu.com, maciej.rutecki@gmail.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, rjw@sisk.pl, wujianguo@huawei.com


The patch titled
     Subject: mm: fix a regression with HIGHMEM
has been added to the -mm tree.  Its filename is
     mm-fix-a-regression-with-highmem-introduced-by-changeset-7f1290f2f2a4d.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
