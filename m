From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:06:39 -0700
Message-ID: <20121009180640.1A51320004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:53420 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2JISGn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:06:43 -0400
Received: by mail-la0-f74.google.com with SMTP id j13so309095lah.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:06:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, minchan@kernel.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: scale number of pages reclaimed by reclaim/compaction based on failures
has been removed from the -mm tree.  Its filename was
     mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: vmscan: scale number of pages reclaimed by reclaim/compaction based on failures

If allocation fails after compaction then compaction may be deferred for a
number of allocation attempts.  If there are subsequent failures,
compact_defer_shift is increased to defer for longer periods.  This patch
uses that information to scale the number of pages reclaimed with
compact_defer_shift until allocations succeed again.  The rationale is
that reclaiming the normal number of pages still allowed compaction to
fail and its success depends on the number of pages.  If it's failing,
reclaim more pages until it succeeds again.

Note that this is not implying that VM reclaim is not reclaiming enough
pages or that its logic is broken.  try_to_free_pages() always asks for
SWAP_CLUSTER_MAX pages to be reclaimed regardless of order and that is
what it does.  Direct reclaim stops normally with this check.

	if (sc->nr_reclaimed >= sc->nr_to_reclaim)
		goto out;

should_continue_reclaim delays when that check is made until a minimum
number of pages for reclaim/compaction are reclaimed.  It is possible that
this patch could instead set nr_to_reclaim in try_to_free_pages() and
drive it from there but that's behaves differently and not necessarily for
the better.  If driven from do_try_to_free_pages(), it is also possible
that priorities will rise.  When they reach DEF_PRIORITY-2, it will also
start stalling and setting pages for immediate reclaim which is more
disruptive than not desirable in this case.  That is a more wide-reaching
change that could cause another regression related to THP requests causing
interactive jitter.

[akpm@linux-foundation.org: fix build]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff -puN mm/vmscan.c~mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures
+++ a/mm/vmscan.c
@@ -1729,6 +1729,28 @@ static bool in_reclaim_compaction(struct
 	return false;
 }
 
+#ifdef CONFIG_COMPACTION
+/*
+ * If compaction is deferred for sc->order then scale the number of pages
+ * reclaimed based on the number of consecutive allocation failures
+ */
+static unsigned long scale_for_compaction(unsigned long pages_for_compaction,
+			struct lruvec *lruvec, struct scan_control *sc)
+{
+	struct zone *zone = lruvec_zone(lruvec);
+
+	if (zone->compact_order_failed <= sc->order)
+		pages_for_compaction <<= zone->compact_defer_shift;
+	return pages_for_compaction;
+}
+#else
+static unsigned long scale_for_compaction(unsigned long pages_for_compaction,
+			struct lruvec *lruvec, struct scan_control *sc)
+{
+	return pages_for_compaction;
+}
+#endif
+
 /*
  * Reclaim/compaction is used for high-order allocation requests. It reclaims
  * order-0 pages before compacting the zone. should_continue_reclaim() returns
@@ -1776,6 +1798,9 @@ static inline bool should_continue_recla
 	 * inactive lists are large enough, continue reclaiming
 	 */
 	pages_for_compaction = (2UL << sc->order);
+
+	pages_for_compaction = scale_for_compaction(pages_for_compaction,
+						    lruvec, sc);
 	inactive_lru_pages = get_lru_size(lruvec, LRU_INACTIVE_FILE);
 	if (nr_swap_pages > 0)
 		inactive_lru_pages += get_lru_size(lruvec, LRU_INACTIVE_ANON);
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch

