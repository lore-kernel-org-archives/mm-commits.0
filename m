From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-add-freepage-on-isolate-pageblock-to-correct-buddy-list.patch removed from -mm tree
Date: Mon, 17 Nov 2014 12:50:38 -0800
Message-ID: <546a5f9e.PPz3Okgw08K8V7aM%akpm__16543.5161594816$1416257456$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50975 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbaKQUuk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Nov 2014 15:50:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, aneesh.kumar@linux.vnet.ibm.com, b.zolnierkie@samsung.com, gioh.kim@lge.com, hannes@cmpxchg.org, heesub.shin@samsung.com, isimatu.yasuaki@jp.fujitsu.com, kirill@shutemov.name, lauraa@codeaurora.org, m.szyprowski@samsung.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, ritesh.list@gmail.com, stable@vger.kernel.org, tangchen@cn.fujitsu.com, vbabka@suse.cz, wency@cn.fujitsu.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: add freepage on isolate pageblock to correct buddy list
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-add-freepage-on-isolate-pageblock-to-correct-buddy-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
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

mm-slab-slub-coding-style-whitespaces-and-tabs-mixture.patch
slab-print-slabinfo-header-in-seq-show.patch
mm-slab-reverse-iteration-on-find_mergeable.patch
mm-slub-fix-format-mismatches-in-slab_err-callers.patch
slab-improve-checking-for-invalid-gfp_flags.patch
slab-replace-smp_read_barrier_depends-with-lockless_dereference.patch
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
mm-embed-the-memcg-pointer-directly-into-struct-page.patch
mm-embed-the-memcg-pointer-directly-into-struct-page-fix.patch
mm-page_cgroup-rename-file-to-mm-swap_cgroupc.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix-2.patch
lib-bitmap-added-alignment-offset-for-bitmap_find_next_zero_area.patch
mm-cma-align-to-physical-address-not-cma-region-position.patch
mm-debug-pagealloc-cleanup-page-guard-code.patch
zsmalloc-merge-size_class-to-reduce-fragmentation.patch
slab-fix-cpuset-check-in-fallback_alloc.patch
slub-fix-cpuset-check-in-get_any_partial.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch
mm-cma-split-cma-reserved-in-dmesg-log.patch
fs-proc-include-cma-info-in-proc-meminfo.patch
page-owners-correct-page-order-when-to-free-page.patch

