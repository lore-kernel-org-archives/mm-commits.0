From: akpm@linux-foundation.org
Subject: [patch 022/127] mm, compaction: create compact_gap wrapper
Date: Fri, 07 Oct 2016 16:57:53 -0700
Message-ID: <57f83681.TmWg7YUJkDnppxxB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38903 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751068AbcJGX5z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 19:57:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vbabka@suse.cz, iamjoonsoo.kim@lge.com, lstoakes@gmail.com, mgorman@techsingularity.net, mhocko@suse.com, riel@redhat.com, rientjes@google.com

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: create compact_gap wrapper

Compaction uses a watermark gap of (2UL << order) pages at various places
and it's not immediately obvious why.  Abstract it through a compact_gap()
wrapper to create a single place with a thorough explanation.

[vbabka@suse.cz: clarify the comment of compact_gap()]
 Link: http://lkml.kernel.org/r/7b6aed1f-fdf8-2063-9ff4-bbe4de712d37@suse.cz
Link: http://lkml.kernel.org/r/20160810091226.6709-9-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Lorenzo Stoakes <lstoakes@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |   23 +++++++++++++++++++++++
 mm/compaction.c            |    7 +++----
 mm/vmscan.c                |    6 +++---
 3 files changed, 29 insertions(+), 7 deletions(-)

diff -puN include/linux/compaction.h~mm-compaction-create-compact_gap-wrapper include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-create-compact_gap-wrapper
+++ a/include/linux/compaction.h
@@ -58,6 +58,29 @@ enum compact_result {
 
 struct alloc_context; /* in mm/internal.h */
 
+/*
+ * Number of free order-0 pages that should be available above given watermark
+ * to make sure compaction has reasonable chance of not running out of free
+ * pages that it needs to isolate as migration target during its work.
+ */
+static inline unsigned long compact_gap(unsigned int order)
+{
+	/*
+	 * Although all the isolations for migration are temporary, compaction
+	 * free scanner may have up to 1 << order pages on its list and then
+	 * try to split an (order - 1) free page. At that point, a gap of
+	 * 1 << order might not be enough, so it's safer to require twice that
+	 * amount. Note that the number of pages on the list is also
+	 * effectively limited by COMPACT_CLUSTER_MAX, as that's the maximum
+	 * that the migrate scanner can have isolated on migrate list, and free
+	 * scanner is only invoked when the number of isolated free pages is
+	 * lower than that. But it's not worth to complicate the formula here
+	 * as a bigger gap for higher orders than strictly necessary can also
+	 * improve chances of compaction success.
+	 */
+	return 2UL << order;
+}
+
 #ifdef CONFIG_COMPACTION
 extern int sysctl_compact_memory;
 extern int sysctl_compaction_handler(struct ctl_table *table, int write,
diff -puN mm/compaction.c~mm-compaction-create-compact_gap-wrapper mm/compaction.c
--- a/mm/compaction.c~mm-compaction-create-compact_gap-wrapper
+++ a/mm/compaction.c
@@ -1391,11 +1391,10 @@ static enum compact_result __compaction_
 		return COMPACT_SUCCESS;
 
 	/*
-	 * Watermarks for order-0 must be met for compaction. Note the 2UL.
-	 * This is because during migration, copies of pages need to be
-	 * allocated and for a short time, the footprint is higher
+	 * Watermarks for order-0 must be met for compaction to be able to
+	 * isolate free pages for migration targets.
 	 */
-	watermark = low_wmark_pages(zone) + (2UL << order);
+	watermark = low_wmark_pages(zone) + compact_gap(order);
 	if (!__zone_watermark_ok(zone, 0, watermark, classzone_idx,
 				 alloc_flags, wmark_target))
 		return COMPACT_SKIPPED;
diff -puN mm/vmscan.c~mm-compaction-create-compact_gap-wrapper mm/vmscan.c
--- a/mm/vmscan.c~mm-compaction-create-compact_gap-wrapper
+++ a/mm/vmscan.c
@@ -2480,7 +2480,7 @@ static inline bool should_continue_recla
 	 * If we have not reclaimed enough pages for compaction and the
 	 * inactive lists are large enough, continue reclaiming
 	 */
-	pages_for_compaction = (2UL << sc->order);
+	pages_for_compaction = compact_gap(sc->order);
 	inactive_lru_pages = node_page_state(pgdat, NR_INACTIVE_FILE);
 	if (get_nr_swap_pages() > 0)
 		inactive_lru_pages += node_page_state(pgdat, NR_INACTIVE_ANON);
@@ -2612,7 +2612,7 @@ static inline bool compaction_ready(stru
 	 * there is a buffer of free pages available to give compaction
 	 * a reasonable chance of completing and allocating the page
 	 */
-	watermark = high_wmark_pages(zone) + (2UL << sc->order);
+	watermark = high_wmark_pages(zone) + compact_gap(sc->order);
 	watermark_ok = zone_watermark_ok_safe(zone, 0, watermark, sc->reclaim_idx);
 
 	/*
@@ -3169,7 +3169,7 @@ static bool kswapd_shrink_node(pg_data_t
 	 * excessive reclaim. Assume that a process requested a high-order
 	 * can direct reclaim/compact.
 	 */
-	if (sc->order && sc->nr_reclaimed >= 2UL << sc->order)
+	if (sc->order && sc->nr_reclaimed >= compact_gap(sc->order))
 		sc->order = 0;
 
 	return sc->nr_scanned >= sc->nr_to_reclaim;
_
