From: akpm@linux-foundation.org
Subject: +
 revert-mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages.patch added to -mm tree
Date: Fri, 13 Sep 2013 14:00:35 -0700
Message-ID: <52337cf3.3gK2/E3+qDG5ZW7O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38344 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab3IMVAg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 17:00:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, liwanp@linux.vnet.ibm.com, liuj97@gmail.com, kosaki.motohiro@jp.fujitsu.com, b.zolnierkie@samsung.com, jy0922.shim@samsung.com

Subject: + revert-mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages.patch added to -mm tree
To: jy0922.shim@samsung.com,b.zolnierkie@samsung.com,kosaki.motohiro@jp.fujitsu.com,liuj97@gmail.com,liwanp@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 14:00:35 -0700


The patch titled
     Subject: revert "mm/memory-hotplug: fix lowmem count overflow when offline pages"
has been added to the -mm tree.  Its filename is
     revert-mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/revert-mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/revert-mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: revert "mm/memory-hotplug: fix lowmem count overflow when offline pages"

This reverts commit cea27eb2a202 ("mm/memory-hotplug: fix lowmem count
overflow when offline pages").

The fixed bug by commit cea27eb was fixed to another way by commit 3dcc057
("mm: correctly update zone->managed_pages").  The commit 3dcc057 enhances
memory_hotplug.c to adjust totalhigh_pages when hot-removing memory, for
details please refer to:
http://marc.info/?l=linux-mm&m=136957578620221&w=2

So, if not revert commit cea27eb, currently causes duplicated decreasing
of totalhigh_pages.

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN mm/page_alloc.c~revert-mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages mm/page_alloc.c
--- a/mm/page_alloc.c~revert-mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages
+++ a/mm/page_alloc.c
@@ -6366,10 +6366,6 @@ __offline_isolated_pages(unsigned long s
 		list_del(&page->lru);
 		rmv_page_order(page);
 		zone->free_area[order].nr_free--;
-#ifdef CONFIG_HIGHMEM
-		if (PageHighMem(page))
-			totalhigh_pages -= 1 << order;
-#endif
 		for (i = 0; i < (1 << order); i++)
 			SetPageReserved((page+i));
 		pfn += (1 << order);
_

Patches currently in -mm which might be from jy0922.shim@samsung.com are

origin.patch
revert-mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages.patch

