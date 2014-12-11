From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory_hotplug-failure-drain-single-zone-pcplists.patch removed from -mm tree
Date: Thu, 11 Dec 2014 10:56:23 -0800
Message-ID: <5489e8d7.XSNaitZB1PnjTFRP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45152 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757813AbaLKS4Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:56:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, isimatu.yasuaki@jp.fujitsu.com, m.szyprowski@samsung.com, mgorman@suse.de, mina86@mina86.com, n-horiguchi@ah.jp.nec.com, qiuxishi@huawei.com, riel@redhat.com, vdavydov@parallels.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memory_hotplug/failure: drain single zone pcplists
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-failure-drain-single-zone-pcplists.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, memory_hotplug/failure: drain single zone pcplists

Memory hotplug and failure mechanisms have several places where pcplists
are drained so that pages are returned to the buddy allocator and can be
e.g.  prepared for offlining.  This is always done in the context of a
single zone, we can reduce the pcplists drain to the single zone, which is
now possible.

The change should make memory offlining due to hotremove or failure faster
and not disturbing unrelated pcplists anymore.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ++--
 mm/memory_hotplug.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/memory-failure.c~mm-memory_hotplug-failure-drain-single-zone-pcplists mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory_hotplug-failure-drain-single-zone-pcplists
+++ a/mm/memory-failure.c
@@ -233,7 +233,7 @@ void shake_page(struct page *p, int acce
 		lru_add_drain_all();
 		if (PageLRU(p))
 			return;
-		drain_all_pages(NULL);
+		drain_all_pages(page_zone(p));
 		if (PageLRU(p) || is_free_buddy_page(p))
 			return;
 	}
@@ -1661,7 +1661,7 @@ static int __soft_offline_page(struct pa
 			if (!is_free_buddy_page(page))
 				lru_add_drain_all();
 			if (!is_free_buddy_page(page))
-				drain_all_pages(NULL);
+				drain_all_pages(page_zone(page));
 			SetPageHWPoison(page);
 			if (!is_free_buddy_page(page))
 				pr_info("soft offline: %#lx: page leaked\n",
diff -puN mm/memory_hotplug.c~mm-memory_hotplug-failure-drain-single-zone-pcplists mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-failure-drain-single-zone-pcplists
+++ a/mm/memory_hotplug.c
@@ -1725,7 +1725,7 @@ repeat:
 	if (drain) {
 		lru_add_drain_all();
 		cond_resched();
-		drain_all_pages(NULL);
+		drain_all_pages(zone);
 	}
 
 	pfn = scan_movable_pages(start_pfn, end_pfn);
@@ -1747,7 +1747,7 @@ repeat:
 	lru_add_drain_all();
 	yield();
 	/* drain pcp pages, this is synchronous. */
-	drain_all_pages(NULL);
+	drain_all_pages(zone);
 	/*
 	 * dissolve free hugepages in the memory block before doing offlining
 	 * actually in order to make hugetlbfs's object counting consistent.
_

Patches currently in -mm which might be from vbabka@suse.cz are

origin.patch
mm-debug-pagealloc-cleanup-page-guard-code.patch

