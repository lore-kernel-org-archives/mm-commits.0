From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-fix-incorrect-isolation-behavior-by-rechecking-migratetype.patch added to -mm tree
Date: Tue, 04 Nov 2014 12:21:56 -0800
Message-ID: <54593564.qLuzNFaSuq0UeRry%akpm__29217.5249931917$1415132529$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47286 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaKDUV4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2014 15:21:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, aneesh.kumar@linux.vnet.ibm.com, b.zolnierkie@samsung.com, gioh.kim@lge.com, hannes@cmpxchg.org, heesub.shin@samsung.com, isimatu.yasuaki@jp.fujitsu.com, kirill.shutemov@linux.intel.com, lauraa@codeaurora.org, m.szyprowski@samsung.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, ritesh.list@gmail.com, stable@vger.kernel.org, tangchen@cn.fujitsu.com, vbabka@suse.cz, wency@cn.fujitsu.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: fix incorrect isolation behavior by rechecking migratetype
has been added to the -mm tree.  Its filename is
     mm-page_alloc-fix-incorrect-isolation-behavior-by-rechecking-migratetype.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-fix-incorrect-isolation-behavior-by-rechecking-migratetype.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-fix-incorrect-isolation-behavior-by-rechecking-migratetype.patch

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
Subject: mm/page_alloc: fix incorrect isolation behavior by rechecking migratetype

Before describing bugs itself, I first explain definition of freepage.

1. pages on buddy list are counted as freepage.
2. pages on isolate migratetype buddy list are *not* counted as freepage.
3. pages on cma buddy list are counted as CMA freepage, too.

Now, I describe problems and related patch.

Patch 1: There is race conditions on getting pageblock migratetype that it
results in misplacement of freepages on buddy list, incorrect freepage
count and un-availability of freepage.

Patch 2: Freepages on pcp list could have stale cached information to
determine migratetype of buddy list to go.  This causes misplacement of
freepages on buddy list and incorrect freepage count.

Patch 4: Merging between freepages on different migratetype of pageblocks
will cause freepages accouting problem.  This patch fixes it.

Without patchset [3], above problem doesn't happens on my CMA allocation
test, because CMA reserved pages aren't used at all.  So there is no
chance for above race.

With patchset [3], I did simple CMA allocation test and get below result.

- Virtual machine, 4 cpus, 1024 MB memory, 256 MB CMA reservation
- run kernel build (make -j16) on background
- 30 times CMA allocation(8MB * 30 = 240MB) attempts in 5 sec interval
- Result: more than 5000 freepage count are missed

With patchset [3] and this patchset, I found that no freepage count are
missed so that I conclude that problems are solved.

On my simple memory offlining test, these problems also occur on that
environment, too.



This patch (of 4):

There are two paths to reach core free function of buddy allocator,
__free_one_page(), one is free_one_page()->__free_one_page() and the other
is free_hot_cold_page()->free_pcppages_bulk()->__free_one_page().  Each
paths has race condition causing serious problems.  At first, this patch
is focused on first type of freepath.  And then, following patch will
solve the problem in second type of freepath.

In the first type of freepath, we got migratetype of freeing page without
holding the zone lock, so it could be racy.  There are two cases of this
race.

1. pages are added to isolate buddy list after restoring orignal
migratetype

CPU1                                   CPU2

get migratetype => return MIGRATE_ISOLATE
call free_one_page() with MIGRATE_ISOLATE

				grab the zone lock
				unisolate pageblock
				release the zone lock

grab the zone lock
call __free_one_page() with MIGRATE_ISOLATE
freepage go into isolate buddy list,
although pageblock is already unisolated

This may cause two problems.  One is that we can't use this page anymore
until next isolation attempt of this pageblock, because freepage is on
isolate buddy list.  The other is that freepage accouting could be wrong
due to merging between different buddy list.  Freepages on isolate buddy
list aren't counted as freepage, but ones on normal buddy list are counted
as freepage.  If merge happens, buddy freepage on normal buddy list is
inevitably moved to isolate buddy list without any consideration of
freepage accouting so it could be incorrect.

2. pages are added to normal buddy list while pageblock is isolated.
It is similar with above case.

This also may cause two problems.  One is that we can't keep these
freepages from being allocated.  Although this pageblock is isolated,
freepage would be added to normal buddy list so that it could be allocated
without any restriction.  And the other problem is same as case 1, that
it, incorrect freepage accouting.

This race condition would be prevented by checking migratetype again with
holding the zone lock.  Because it is somewhat heavy operation and it
isn't needed in common case, we want to avoid rechecking as much as
possible.  So this patch introduce new variable, nr_isolate_pageblock in
struct zone to check if there is isolated pageblock.  With this, we can
avoid to re-check migratetype in common case and do it only if there is
isolated pageblock or migratetype is MIGRATE_ISOLATE.  This solve above
mentioned problems.

Changes from v3:
Add one more check in free_one_page() that checks whether migratetype is
MIGRATE_ISOLATE or not. Without this, abovementioned case 1 could happens.

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

 include/linux/mmzone.h         |    9 +++++++++
 include/linux/page-isolation.h |    8 ++++++++
 mm/page_alloc.c                |   11 +++++++++--
 mm/page_isolation.c            |    2 ++
 4 files changed, 28 insertions(+), 2 deletions(-)

diff -puN include/linux/mmzone.h~mm-page_alloc-fix-incorrect-isolation-behavior-by-rechecking-migratetype include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-page_alloc-fix-incorrect-isolation-behavior-by-rechecking-migratetype
+++ a/include/linux/mmzone.h
@@ -431,6 +431,15 @@ struct zone {
 	 */
 	int			nr_migrate_reserve_block;
 
+#ifdef CONFIG_MEMORY_ISOLATION
+	/*
+	 * Number of isolated pageblock. It is used to solve incorrect
+	 * freepage counting problem due to racy retrieving migratetype
+	 * of pageblock. Protected by zone->lock.
+	 */
+	unsigned long		nr_isolate_pageblock;
+#endif
+
 #ifdef CONFIG_MEMORY_HOTPLUG
 	/* see spanned/present_pages for more description */
 	seqlock_t		span_seqlock;
diff -puN include/linux/page-isolation.h~mm-page_alloc-fix-incorrect-isolation-behavior-by-rechecking-migratetype include/linux/page-isolation.h
--- a/include/linux/page-isolation.h~mm-page_alloc-fix-incorrect-isolation-behavior-by-rechecking-migratetype
+++ a/include/linux/page-isolation.h
@@ -2,6 +2,10 @@
 #define __LINUX_PAGEISOLATION_H
 
 #ifdef CONFIG_MEMORY_ISOLATION
+static inline bool has_isolate_pageblock(struct zone *zone)
+{
+	return zone->nr_isolate_pageblock;
+}
 static inline bool is_migrate_isolate_page(struct page *page)
 {
 	return get_pageblock_migratetype(page) == MIGRATE_ISOLATE;
@@ -11,6 +15,10 @@ static inline bool is_migrate_isolate(in
 	return migratetype == MIGRATE_ISOLATE;
 }
 #else
+static inline bool has_isolate_pageblock(struct zone *zone)
+{
+	return false;
+}
 static inline bool is_migrate_isolate_page(struct page *page)
 {
 	return false;
diff -puN mm/page_alloc.c~mm-page_alloc-fix-incorrect-isolation-behavior-by-rechecking-migratetype mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-fix-incorrect-isolation-behavior-by-rechecking-migratetype
+++ a/mm/page_alloc.c
@@ -739,9 +739,16 @@ static void free_one_page(struct zone *z
 	if (nr_scanned)
 		__mod_zone_page_state(zone, NR_PAGES_SCANNED, -nr_scanned);
 
+	if (unlikely(has_isolate_pageblock(zone) ||
+		is_migrate_isolate(migratetype))) {
+		migratetype = get_pfnblock_migratetype(page, pfn);
+		if (is_migrate_isolate(migratetype))
+			goto skip_counting;
+	}
+	__mod_zone_freepage_state(zone, 1 << order, migratetype);
+
+skip_counting:
 	__free_one_page(page, pfn, zone, order, migratetype);
-	if (unlikely(!is_migrate_isolate(migratetype)))
-		__mod_zone_freepage_state(zone, 1 << order, migratetype);
 	spin_unlock(&zone->lock);
 }
 
diff -puN mm/page_isolation.c~mm-page_alloc-fix-incorrect-isolation-behavior-by-rechecking-migratetype mm/page_isolation.c
--- a/mm/page_isolation.c~mm-page_alloc-fix-incorrect-isolation-behavior-by-rechecking-migratetype
+++ a/mm/page_isolation.c
@@ -60,6 +60,7 @@ out:
 		int migratetype = get_pageblock_migratetype(page);
 
 		set_pageblock_migratetype(page, MIGRATE_ISOLATE);
+		zone->nr_isolate_pageblock++;
 		nr_pages = move_freepages_block(zone, page, MIGRATE_ISOLATE);
 
 		__mod_zone_freepage_state(zone, -nr_pages, migratetype);
@@ -83,6 +84,7 @@ void unset_migratetype_isolate(struct pa
 	nr_pages = move_freepages_block(zone, page, migratetype);
 	__mod_zone_freepage_state(zone, nr_pages, migratetype);
 	set_pageblock_migratetype(page, migratetype);
+	zone->nr_isolate_pageblock--;
 out:
 	spin_unlock_irqrestore(&zone->lock, flags);
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

