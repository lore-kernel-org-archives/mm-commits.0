From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-add-freepage-on-isolate-pageblock-to-correct-buddy-list.patch added to -mm tree
Date: Tue, 04 Nov 2014 12:21:59 -0800
Message-ID: <54593567.2aA0g3DTcRC1uNGH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47305 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaKDUV7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2014 15:21:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, aneesh.kumar@linux.vnet.ibm.com, b.zolnierkie@samsung.com, gioh.kim@lge.com, hannes@cmpxchg.org, heesub.shin@samsung.com, isimatu.yasuaki@jp.fujitsu.com, kirill.shutemov@linux.intel.com, lauraa@codeaurora.org, m.szyprowski@samsung.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, ritesh.list@gmail.com, stable@vger.kernel.org, tangchen@cn.fujitsu.com, vbabka@suse.cz, wency@cn.fujitsu.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: add freepage on isolate pageblock to correct buddy list
has been added to the -mm tree.  Its filename is
     mm-page_alloc-add-freepage-on-isolate-pageblock-to-correct-buddy-list.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-add-freepage-on-isolate-pageblock-to-correct-buddy-list.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-add-freepage-on-isolate-pageblock-to-correct-buddy-list.patch

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
Subject: mm/page_alloc: add freepage on isolate pageblock to correct buddy list

In free_pcppages_bulk(), we use cached migratetype of freepage to
determine type of buddy list where freepage will be added.  This
information is stored when freepage is added to pcp list, so if isolation
of pageblock of this freepage begins after storing, this cached
information could be stale.  In other words, it has original migratetype
rather than MIGRATE_ISOLATE.

There are two problems caused by this stale information.  One is that we
can't keep these freepages from being allocated.  Although this pageblock
is isolated, freepage will be added to normal buddy list so that it could
be allocated without any restriction.  And the other problem is incorrect
freepage accounting.  Freepages on isolate pageblock should not be counted
for number of freepage.

Following is the code snippet in free_pcppages_bulk().

/* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
__free_one_page(page, page_to_pfn(page), zone, 0, mt);
trace_mm_page_pcpu_drain(page, 0, mt);
if (likely(!is_migrate_isolate_page(page))) {
	__mod_zone_page_state(zone, NR_FREE_PAGES, 1);
	if (is_migrate_cma(mt))
		__mod_zone_page_state(zone, NR_FREE_CMA_PAGES, 1);
}

As you can see above snippet, current code already handle second problem,
incorrect freepage accounting, by re-fetching pageblock migratetype
through is_migrate_isolate_page(page).  But, because this re-fetched
information isn't used for __free_one_page(), first problem would not be
solved.  This patch try to solve this situation to re-fetch pageblock
migratetype before __free_one_page() and to use it for __free_one_page().

In addition to move up position of this re-fetch, this patch use
optimization technique, re-fetching migratetype only if there is isolate
pageblock.  Pageblock isolation is rare event, so we can avoid re-fetching
in common case with this optimization.

This patch also correct migratetype of the tracepoint output.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Heesub Shin <heesub.shin@samsung.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Gioh Kim <gioh.kim@lge.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-add-freepage-on-isolate-pageblock-to-correct-buddy-list mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-add-freepage-on-isolate-pageblock-to-correct-buddy-list
+++ a/mm/page_alloc.c
@@ -715,14 +715,17 @@ static void free_pcppages_bulk(struct zo
 			/* must delete as __free_one_page list manipulates */
 			list_del(&page->lru);
 			mt = get_freepage_migratetype(page);
+			if (unlikely(has_isolate_pageblock(zone))) {
+				mt = get_pageblock_migratetype(page);
+				if (is_migrate_isolate(mt))
+					goto skip_counting;
+			}
+			__mod_zone_freepage_state(zone, 1, mt);
+
+skip_counting:
 			/* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
 			__free_one_page(page, page_to_pfn(page), zone, 0, mt);
 			trace_mm_page_pcpu_drain(page, 0, mt);
-			if (likely(!is_migrate_isolate_page(page))) {
-				__mod_zone_page_state(zone, NR_FREE_PAGES, 1);
-				if (is_migrate_cma(mt))
-					__mod_zone_page_state(zone, NR_FREE_CMA_PAGES, 1);
-			}
 		} while (--to_free && --batch_free && !list_empty(list));
 	}
 	spin_unlock(&zone->lock);
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

