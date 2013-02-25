From: akpm@linux-foundation.org
Subject: [merged] mm-set-zone-present_pages-to-number-of-existing-pages-in-the-zone.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:51:39 -0800
Message-ID: <20130225205140.05BCD5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:57052 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756687Ab3BYUvl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:51:41 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so158931yen.1
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:51:41 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, chris2553@googlemail.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, maciej.rutecki@gmail.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, rientjes@google.com, rjw@sisk.pl, wency@cn.fujitsu.com, wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: set zone->present_pages to number of existing pages in the zone
has been removed from the -mm tree.  Its filename was
     mm-set-zone-present_pages-to-number-of-existing-pages-in-the-zone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm: set zone->present_pages to number of existing pages in the zone

Now all users of "number of pages managed by the buddy system" have been
converted to use zone->managed_pages, so set zone->present_pages to what
it should be:

	present_pages = spanned_pages - absent_pages;

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Chris Clayton <chris2553@googlemail.com>
Cc: "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-set-zone-present_pages-to-number-of-existing-pages-in-the-zone mm/page_alloc.c
--- a/mm/page_alloc.c~mm-set-zone-present_pages-to-number-of-existing-pages-in-the-zone
+++ a/mm/page_alloc.c
@@ -4650,7 +4650,7 @@ static void __paginginit free_area_init_
 		nr_all_pages += freesize;
 
 		zone->spanned_pages = size;
-		zone->present_pages = freesize;
+		zone->present_pages = realsize;
 		/*
 		 * Set an approximate value for lowmem here, it will be adjusted
 		 * when the bootmem allocator frees pages into the buddy system.
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
linux-next.patch

