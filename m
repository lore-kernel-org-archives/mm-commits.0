From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-move-freepage-counting-logic-to-__free_one_page.patch added
 to -mm tree
Date: Tue, 04 Nov 2014 12:22:02 -0800
Message-ID: <5459356a.NqdYho+UAyNlIGk4%akpm__1449.87487369708$1415132533$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47319 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaKDUWC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2014 15:22:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, aneesh.kumar@linux.vnet.ibm.com, b.zolnierkie@samsung.com, gioh.kim@lge.com, hannes@cmpxchg.org, heesub.shin@samsung.com, isimatu.yasuaki@jp.fujitsu.com, kirill.shutemov@linux.intel.com, lauraa@codeaurora.org, m.szyprowski@samsung.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, ritesh.list@gmail.com, stable@vger.kernel.org, tangchen@cn.fujitsu.com, vbabka@suse.cz, wency@cn.fujitsu.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: move freepage counting logic to __free_one_page()
has been added to the -mm tree.  Its filename is
     mm-page_alloc-move-freepage-counting-logic-to-__free_one_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-move-freepage-counting-logic-to-__free_one_page.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-move-freepage-counting-logic-to-__free_one_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/page_alloc: move freepage counting logic to __free_one_page()

All the caller of __free_one_page() has similar freepage counting logic,
so we can move it to __free_one_page().  This reduce line of code and help
future maintenance.  This is also preparation step for "mm/page_alloc:
restrict max order of merging on isolated pageblock" which fix the
freepage counting problem on freepage with more than pageblock order.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Heesub Shin <heesub.shin@samsung.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Gioh Kim <gioh.kim@lge.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-move-freepage-counting-logic-to-__free_one_page mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-move-freepage-counting-logic-to-__free_one_page
+++ a/mm/page_alloc.c
@@ -577,6 +577,8 @@ static inline void __free_one_page(struc
 			return;
 
 	VM_BUG_ON(migratetype == -1);
+	if (!is_migrate_isolate(migratetype))
+		__mod_zone_freepage_state(zone, 1 << order, migratetype);
 
 	page_idx = pfn & ((1 << MAX_ORDER) - 1);
 
@@ -715,14 +717,9 @@ static void free_pcppages_bulk(struct zo
 			/* must delete as __free_one_page list manipulates */
 			list_del(&page->lru);
 			mt = get_freepage_migratetype(page);
-			if (unlikely(has_isolate_pageblock(zone))) {
+			if (unlikely(has_isolate_pageblock(zone)))
 				mt = get_pageblock_migratetype(page);
-				if (is_migrate_isolate(mt))
-					goto skip_counting;
-			}
-			__mod_zone_freepage_state(zone, 1, mt);
 
-skip_counting:
 			/* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
 			__free_one_page(page, page_to_pfn(page), zone, 0, mt);
 			trace_mm_page_pcpu_drain(page, 0, mt);
@@ -745,12 +742,7 @@ static void free_one_page(struct zone *z
 	if (unlikely(has_isolate_pageblock(zone) ||
 		is_migrate_isolate(migratetype))) {
 		migratetype = get_pfnblock_migratetype(page, pfn);
-		if (is_migrate_isolate(migratetype))
-			goto skip_counting;
 	}
-	__mod_zone_freepage_state(zone, 1 << order, migratetype);
-
-skip_counting:
 	__free_one_page(page, pfn, zone, order, migratetype);
 	spin_unlock(&zone->lock);
 }
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-compaction-skip-the-range-until-proper-target-pageblock-is-met.patch
mm-page_alloc-fix-incorrect-isolation-behavior-by-rechecking-migratetype.patch
mm-page_alloc-add-freepage-on-isolate-pageblock-to-correct-buddy-list.patch
mm-page_alloc-move-freepage-counting-logic-to-__free_one_page.patch
mm-page_alloc-restrict-max-order-of-merging-on-isolated-pageblock.patch
mm-slab-slub-coding-style-whitespaces-and-tabs-mixture.patch
slab-print-slabinfo-header-in-seq-show.patch
mm-introduce-single-zone-pcplists-drain.patch
mm-page_isolation-drain-single-zone-pcplists.patch
mm-cma-drain-single-zone-pcplists.patch
mm-memory_hotplug-failure-drain-single-zone-pcplists.patch
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking.patch
mm-compaction-simplify-deferred-compaction.patch
mm-compaction-defer-only-on-compact_complete.patch
mm-compaction-always-update-cached-scanner-positions.patch
mm-compaction-more-focused-lru-and-pcplists-draining.patch
memcg-use-generic-slab-iterators-for-showing-slabinfo.patch
zsmalloc-merge-size_class-to-reduce-fragmentation.patch
slab-fix-cpuset-check-in-fallback_alloc.patch
slub-fix-cpuset-check-in-get_any_partial.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch
mm-cma-split-cma-reserved-in-dmesg-log.patch
fs-proc-include-cma-info-in-proc-meminfo.patch
page-owners-correct-page-order-when-to-free-page.patch

