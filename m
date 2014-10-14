From: akpm@linux-foundation.org
Subject: + mm-memory_hotplug-failure-drain-single-zone-pcplists.patch
 added to -mm tree
Date: Tue, 14 Oct 2014 15:57:00 -0700
Message-ID: <543daa3c.kTYvo37WXs0IA9Yt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47047 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536AbaJNW5B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 18:57:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, isimatu.yasuaki@jp.fujitsu.com, m.szyprowski@samsung.com, mgorman@suse.de, mina86@mina86.com, n-horiguchi@ah.jp.nec.com, qiuxishi@huawei.com, riel@redhat.com, vdavydov@parallels.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memory_hotplug/failure: drain single zone pcplists
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-failure-drain-single-zone-pcplists.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-failure-drain-single-zone-pcplists.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-failure-drain-single-zone-pcplists.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1699,7 +1699,7 @@ repeat:
 	if (drain) {
 		lru_add_drain_all();
 		cond_resched();
-		drain_all_pages(NULL);
+		drain_all_pages(zone);
 	}
 
 	pfn = scan_movable_pages(start_pfn, end_pfn);
@@ -1721,7 +1721,7 @@ repeat:
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
mm-compaction-avoid-premature-range-skip-in-isolate_migratepages_range.patch
mm-introduce-single-zone-pcplists-drain.patch
mm-page_isolation-drain-single-zone-pcplists.patch
mm-cma-drain-single-zone-pcplists.patch
mm-memory_hotplug-failure-drain-single-zone-pcplists.patch

