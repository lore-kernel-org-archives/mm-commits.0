From: akpm@linux-foundation.org
Subject: [merged] mm-increase-totalram_pages-when-free-pages-allocated-by-bootmem-allocator.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:51:43 -0800
Message-ID: <20130225205143.B6FE131C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:34085 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759666Ab3BYUvp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:51:45 -0500
Received: by mail-qe0-f73.google.com with SMTP id 3so70353qea.4
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:51:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, chris2553@googlemail.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, maciej.rutecki@gmail.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, rientjes@google.com, rjw@sisk.pl, wency@cn.fujitsu.com, wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: increase totalram_pages when free pages allocated by bootmem allocator
has been removed from the -mm tree.  Its filename was
     mm-increase-totalram_pages-when-free-pages-allocated-by-bootmem-allocator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm: increase totalram_pages when free pages allocated by bootmem allocator

Function put_page_bootmem() is used to free pages allocated by bootmem
allocator, so it should increase totalram_pages when freeing pages into
the buddy system.

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

 mm/memory_hotplug.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/memory_hotplug.c~mm-increase-totalram_pages-when-free-pages-allocated-by-bootmem-allocator mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-increase-totalram_pages-when-free-pages-allocated-by-bootmem-allocator
+++ a/mm/memory_hotplug.c
@@ -124,6 +124,7 @@ void __ref put_page_bootmem(struct page 
 		mutex_lock(&ppb_lock);
 		__free_pages_bootmem(page, 0);
 		mutex_unlock(&ppb_lock);
+		totalram_pages++;
 	}
 
 }
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
linux-next.patch

