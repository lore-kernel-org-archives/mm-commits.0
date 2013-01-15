From: akpm@linux-foundation.org
Subject: + mm-set-zone-present_pages-to-number-of-existing-pages-in-the-zone.patch added to -mm tree
Date: Tue, 15 Jan 2013 13:18:14 -0800
Message-ID: <20130115211814.6DBB65A4201@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:52821 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488Ab3AOVSQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Jan 2013 16:18:16 -0500
Received: by mail-yh0-f73.google.com with SMTP id 47so74712yhr.2
        for <mm-commits@vger.kernel.org>; Tue, 15 Jan 2013 13:18:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liuj97@gmail.com, chris2553@googlemail.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, maciej.rutecki@gmail.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, rientjes@google.com, rjw@sisk.pl, wency@cn.fujitsu.com, wujianguo@huawei.com


The patch titled
     Subject: mm: set zone->present_pages to number of existing pages in the zone
has been added to the -mm tree.  Its filename is
     mm-set-zone-present_pages-to-number-of-existing-pages-in-the-zone.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -4644,7 +4644,7 @@ static void __paginginit free_area_init_
 		nr_all_pages += freesize;
 
 		zone->spanned_pages = size;
-		zone->present_pages = freesize;
+		zone->present_pages = realsize;
 		/*
 		 * Set an approximate value for lowmem here, it will be adjusted
 		 * when the bootmem allocator frees pages into the buddy system.
_

Patches currently in -mm which might be from liuj97@gmail.com are

x86-fix-the-argument-passed-to-sync_global_pgds.patch
mm-use-zone-present_pages-instead-of-zone-managed_pages-where-appropriate.patch
mm-set-zone-present_pages-to-number-of-existing-pages-in-the-zone.patch
mm-increase-totalram_pages-when-free-pages-allocated-by-bootmem-allocator.patch

