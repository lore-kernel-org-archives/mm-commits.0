From: akpm@linux-foundation.org
Subject: + mm-page_isolation-drain-single-zone-pcplists.patch added to -mm tree
Date: Tue, 14 Oct 2014 15:56:58 -0700
Message-ID: <543daa3a.x7rx3doz4W0i39rd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47025 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434AbaJNW47 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 18:56:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, isimatu.yasuaki@jp.fujitsu.com, m.szyprowski@samsung.com, mgorman@suse.de, mina86@mina86.com, n-horiguchi@ah.jp.nec.com, qiuxishi@huawei.com, riel@redhat.com, vdavydov@parallels.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_isolation: drain single zone pcplists
has been added to the -mm tree.  Its filename is
     mm-page_isolation-drain-single-zone-pcplists.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_isolation-drain-single-zone-pcplists.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_isolation-drain-single-zone-pcplists.patch

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
Subject: mm, page_isolation: drain single zone pcplists

When setting MIGRATETYPE_ISOLATE on a pageblock, pcplists are drained to
have a better chance that all pages will be successfully isolated and not
left in the per-cpu caches.  Since isolation is always concerned with a
single zone, we can reduce the pcplists drain to the single zone, which is
now possible.

The change should make memory isolation faster and not disturbing
unrelated pcplists anymore.

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

 mm/page_isolation.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_isolation.c~mm-page_isolation-drain-single-zone-pcplists mm/page_isolation.c
--- a/mm/page_isolation.c~mm-page_isolation-drain-single-zone-pcplists
+++ a/mm/page_isolation.c
@@ -67,7 +67,7 @@ out:
 
 	spin_unlock_irqrestore(&zone->lock, flags);
 	if (!ret)
-		drain_all_pages(NULL);
+		drain_all_pages(zone);
 	return ret;
 }
 
_

Patches currently in -mm which might be from vbabka@suse.cz are

origin.patch
mm-compaction-avoid-premature-range-skip-in-isolate_migratepages_range.patch
mm-introduce-single-zone-pcplists-drain.patch
mm-page_isolation-drain-single-zone-pcplists.patch
mm-cma-drain-single-zone-pcplists.patch
mm-memory_hotplug-failure-drain-single-zone-pcplists.patch

