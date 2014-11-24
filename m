From: akpm@linux-foundation.org
Subject: +
 mm-page_owner-correct-owner-information-for-early-allocated-pages.patch
 added to -mm tree
Date: Mon, 24 Nov 2014 14:58:41 -0800
Message-ID: <5473b821.YZg9jOeZ7SVZXbJ0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56661 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbaKXW6T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Nov 2014 17:58:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, dave@sr71.net, hannes@cmpxchg.org, jungsoo.son@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_owner: correct owner information for early allocated pages
has been added to the -mm tree.  Its filename is
     mm-page_owner-correct-owner-information-for-early-allocated-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_owner-correct-owner-information-for-early-allocated-pages.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_owner-correct-owner-information-for-early-allocated-pages.patch

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
Subject: mm/page_owner: correct owner information for early allocated pages

Extended memory to store page owner information is initialized some time
later than that page allocator starts.  Until initialization, many pages
can be allocated and they have no owner information.  This make debugging
using page owner harder, so some fixup will be helpful.

This patch fixes up this situation by setting fake owner information
immediately after page extension is initialized.  Information doesn't tell
the right owner, but, at least, it can tell whether page is allocated or
not, more correctly.

On my testing, this patch catches 13343 early allocated pages, although
they are mostly allocated from page extension feature.  Anyway, after
then, there is no page left that it is allocated and has no page owner
flag.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Dave Hansen <dave@sr71.net>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Jungsoo Son <jungsoo.son@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   93 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 91 insertions(+), 2 deletions(-)

diff -puN mm/page_owner.c~mm-page_owner-correct-owner-information-for-early-allocated-pages mm/page_owner.c
--- a/mm/page_owner.c~mm-page_owner-correct-owner-information-for-early-allocated-pages
+++ a/mm/page_owner.c
@@ -10,6 +10,8 @@
 static bool page_owner_disabled = true;
 bool page_owner_inited __read_mostly;
 
+static void init_early_allocated_pages(void);
+
 static int early_page_owner_param(char *buf)
 {
 	if (!buf)
@@ -36,6 +38,7 @@ static void init_page_owner(void)
 		return;
 
 	page_owner_inited = true;
+	init_early_allocated_pages();
 }
 
 struct page_ext_operations page_owner_ops = {
@@ -184,8 +187,8 @@ read_page_owner(struct file *file, char 
 		page_ext = lookup_page_ext(page);
 
 		/*
-		 * Pages allocated before initialization of page_owner are
-		 * non-buddy and have no page_owner info.
+		 * Some pages could be missed by concurrent allocation or free,
+		 * because we don't hold the zone lock.
 		 */
 		if (!test_bit(PAGE_EXT_OWNER, &page_ext->flags))
 			continue;
@@ -199,6 +202,92 @@ read_page_owner(struct file *file, char 
 	return 0;
 }
 
+static void init_pages_in_zone(pg_data_t *pgdat, struct zone *zone)
+{
+	struct page *page;
+	struct page_ext *page_ext;
+	unsigned long pfn = zone->zone_start_pfn, block_end_pfn;
+	unsigned long end_pfn = pfn + zone->spanned_pages;
+	unsigned long count = 0;
+
+	/* Scan block by block. First and last block may be incomplete */
+	pfn = zone->zone_start_pfn;
+
+	/*
+	 * Walk the zone in pageblock_nr_pages steps. If a page block spans
+	 * a zone boundary, it will be double counted between zones. This does
+	 * not matter as the mixed block count will still be correct
+	 */
+	for (; pfn < end_pfn; ) {
+		if (!pfn_valid(pfn)) {
+			pfn = ALIGN(pfn + 1, MAX_ORDER_NR_PAGES);
+			continue;
+		}
+
+		block_end_pfn = ALIGN(pfn + 1, pageblock_nr_pages);
+		block_end_pfn = min(block_end_pfn, end_pfn);
+
+		page = pfn_to_page(pfn);
+
+		for (; pfn < block_end_pfn; pfn++) {
+			if (!pfn_valid_within(pfn))
+				continue;
+
+			page = pfn_to_page(pfn);
+
+			/*
+			 * We are safe to check buddy flag and order, because
+			 * this is init stage and only single thread runs.
+			 */
+			if (PageBuddy(page)) {
+				pfn += (1UL << page_order(page)) - 1;
+				continue;
+			}
+
+			if (PageReserved(page))
+				continue;
+
+			page_ext = lookup_page_ext(page);
+
+			/* Maybe overraping zone */
+			if (test_bit(PAGE_EXT_OWNER, &page_ext->flags))
+				continue;
+
+			/* Found early allocated page */
+			set_page_owner(page, 0, 0);
+			count++;
+		}
+	}
+
+	pr_info("Node %d, zone %8s: page owner found early allocated %lu pages\n",
+		pgdat->node_id, zone->name, count);
+}
+
+static void init_zones_in_node(pg_data_t *pgdat)
+{
+	struct zone *zone;
+	struct zone *node_zones = pgdat->node_zones;
+	unsigned long flags;
+
+	for (zone = node_zones; zone - node_zones < MAX_NR_ZONES; ++zone) {
+		if (!populated_zone(zone))
+			continue;
+
+		spin_lock_irqsave(&zone->lock, flags);
+		init_pages_in_zone(pgdat, zone);
+		spin_unlock_irqrestore(&zone->lock, flags);
+	}
+}
+
+static void init_early_allocated_pages(void)
+{
+	pg_data_t *pgdat;
+
+	drain_all_pages(NULL);
+	for_each_online_pgdat(pgdat)
+		init_zones_in_node(pgdat);
+}
+
 static const struct file_operations proc_page_owner_operations = {
 	.read		= read_page_owner,
 };
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
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking-fix.patch
mm-compaction-simplify-deferred-compaction.patch
mm-compaction-defer-only-on-compact_complete.patch
mm-compaction-always-update-cached-scanner-positions.patch
mm-compaction-always-update-cached-scanner-positions-fix.patch
mm-compaction-more-focused-lru-and-pcplists-draining.patch
mm-compaction-more-focused-lru-and-pcplists-draining-fix.patch
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
mm-page_alloc-store-updated-page-migratetype-to-avoid-misusing-stale-value.patch
mm-page_alloc-store-updated-page-migratetype-to-avoid-misusing-stale-value-fix.patch
include-linux-kmemleakh-needs-slabh.patch
mm-page_ext-resurrect-struct-page-extending-code-for-debugging.patch
mm-debug-pagealloc-prepare-boottime-configurable-on-off.patch
mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable.patch
mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation.patch
stacktrace-introduce-snprint_stack_trace-for-buffer-output.patch
mm-page_owner-keep-track-of-page-owners.patch
mm-page_owner-correct-owner-information-for-early-allocated-pages.patch
documentation-add-new-page_owner-document.patch
zsmalloc-merge-size_class-to-reduce-fragmentation.patch
slab-fix-cpuset-check-in-fallback_alloc.patch
slub-fix-cpuset-check-in-get_any_partial.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch
mm-cma-split-cma-reserved-in-dmesg-log.patch
fs-proc-include-cma-info-in-proc-meminfo.patch
page-owners-correct-page-order-when-to-free-page.patch

