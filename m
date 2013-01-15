From: akpm@linux-foundation.org
Subject: + mm-increase-totalram_pages-when-free-pages-allocated-by-bootmem-allocator.patch added to -mm tree
Date: Tue, 15 Jan 2013 13:18:16 -0800
Message-ID: <20130115211817.EAC88200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:38251 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488Ab3AOVSW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Jan 2013 16:18:22 -0500
Received: by mail-lb0-f202.google.com with SMTP id s4so53446lbc.3
        for <mm-commits@vger.kernel.org>; Tue, 15 Jan 2013 13:18:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liuj97@gmail.com, chris2553@googlemail.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, maciej.rutecki@gmail.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, rientjes@google.com, rjw@sisk.pl, wency@cn.fujitsu.com, wujianguo@huawei.com


The patch titled
     Subject: mm: increase totalram_pages when free pages allocated by bootmem allocator
has been added to the -mm tree.  Its filename is
     mm-increase-totalram_pages-when-free-pages-allocated-by-bootmem-allocator.patch

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

x86-fix-the-argument-passed-to-sync_global_pgds.patch
mm-use-zone-present_pages-instead-of-zone-managed_pages-where-appropriate.patch
mm-set-zone-present_pages-to-number-of-existing-pages-in-the-zone.patch
mm-increase-totalram_pages-when-free-pages-allocated-by-bootmem-allocator.patch

