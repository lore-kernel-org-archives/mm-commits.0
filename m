From: akpm@linux-foundation.org
Subject: + mm-compaction-simplify-deferred-compaction.patch added to -mm
 tree
Date: Wed, 15 Oct 2014 13:50:06 -0700
Message-ID: <543eddfe.rwOGuPCmlT33oFpI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37138 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbaJOUuH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Oct 2014 16:50:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, cl@linux.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: simplify deferred compaction
has been added to the -mm tree.  Its filename is
     mm-compaction-simplify-deferred-compaction.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-simplify-deferred-compaction.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-simplify-deferred-compaction.patch

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
Subject: mm, compaction: simplify deferred compaction

Since commit 53853e2d2bfb7 ("mm, compaction: defer each zone individually
instead of preferred zone"), compaction is deferred for each zone where
sync direct compaction fails, and reset where it succeeds.  However, it
was observed that for DMA zone compaction often appeared to succeed while
subsequent allocation attempt would not, due to different outcome of
watermark check.  In order to properly defer compaction in this zone, the
candidate zone has to be passed back to __alloc_pages_direct_compact() and
compaction deferred in the zone after the allocation attempt fails.

The large source of mismatch between watermark check in compaction and
allocation was the lack of alloc_flags and classzone_idx values in
compaction, which has been fixed in the previous patch.  So with this
problem fixed, we can simplify the code by removing the candidate_zone
parameter and deferring in __alloc_pages_direct_compact().

After this patch, the compaction activity during stress-highalloc
benchmark is still somewhat increased, but it's negligible compared to the
increase that occurred without the better watermark checking.  This
suggests that it is still possible to apparently succeed in compaction but
fail to allocate, possibly due to parallel allocation activity.

Suggested-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |    6 ++----
 mm/compaction.c            |    5 +----
 mm/page_alloc.c            |   12 +-----------
 3 files changed, 4 insertions(+), 19 deletions(-)

diff -puN include/linux/compaction.h~mm-compaction-simplify-deferred-compaction include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-simplify-deferred-compaction
+++ a/include/linux/compaction.h
@@ -33,8 +33,7 @@ extern int fragmentation_index(struct zo
 extern unsigned long try_to_compact_pages(struct zonelist *zonelist,
 			int order, gfp_t gfp_mask, nodemask_t *mask,
 			enum migrate_mode mode, int *contended,
-			int alloc_flags, int classzone_idx,
-			struct zone **candidate_zone);
+			int alloc_flags, int classzone_idx);
 extern void compact_pgdat(pg_data_t *pgdat, int order);
 extern void reset_isolation_suitable(pg_data_t *pgdat);
 extern unsigned long compaction_suitable(struct zone *zone, int order,
@@ -105,8 +104,7 @@ static inline bool compaction_restarting
 static inline unsigned long try_to_compact_pages(struct zonelist *zonelist,
 			int order, gfp_t gfp_mask, nodemask_t *nodemask,
 			enum migrate_mode mode, int *contended,
-			int alloc_flags, int classzone_idx,
-			struct zone **candidate_zone)
+			int alloc_flags, int classzone_idx);
 {
 	return COMPACT_CONTINUE;
 }
diff -puN mm/compaction.c~mm-compaction-simplify-deferred-compaction mm/compaction.c
--- a/mm/compaction.c~mm-compaction-simplify-deferred-compaction
+++ a/mm/compaction.c
@@ -1279,15 +1279,13 @@ int sysctl_extfrag_threshold = 500;
  * @mode: The migration mode for async, sync light, or sync migration
  * @contended: Return value that determines if compaction was aborted due to
  *	       need_resched() or lock contention
- * @candidate_zone: Return the zone where we think allocation should succeed
  *
  * This is the main entry point for direct page compaction.
  */
 unsigned long try_to_compact_pages(struct zonelist *zonelist,
 			int order, gfp_t gfp_mask, nodemask_t *nodemask,
 			enum migrate_mode mode, int *contended,
-			int alloc_flags, int classzone_idx,
-			struct zone **candidate_zone)
+			int alloc_flags, int classzone_idx)
 {
 	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
 	int may_enter_fs = gfp_mask & __GFP_FS;
@@ -1324,7 +1322,6 @@ unsigned long try_to_compact_pages(struc
 		/* If a normal allocation would succeed, stop compacting */
 		if (zone_watermark_ok(zone, order, low_wmark_pages(zone),
 					classzone_idx, alloc_flags)) {
-			*candidate_zone = zone;
 			/*
 			 * We think the allocation will succeed in this zone,
 			 * but it is not certain, hence the false. The caller
diff -puN mm/page_alloc.c~mm-compaction-simplify-deferred-compaction mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-simplify-deferred-compaction
+++ a/mm/page_alloc.c
@@ -2331,7 +2331,6 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	int classzone_idx, int migratetype, enum migrate_mode mode,
 	int *contended_compaction, bool *deferred_compaction)
 {
-	struct zone *last_compact_zone = NULL;
 	unsigned long compact_result;
 	struct page *page;
 
@@ -2342,8 +2341,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	compact_result = try_to_compact_pages(zonelist, order, gfp_mask,
 						nodemask, mode,
 						contended_compaction,
-						alloc_flags, classzone_idx,
-						&last_compact_zone);
+						alloc_flags, classzone_idx);
 	current->flags &= ~PF_MEMALLOC;
 
 	switch (compact_result) {
@@ -2381,14 +2379,6 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	}
 
 	/*
-	 * last_compact_zone is where try_to_compact_pages thought allocation
-	 * should succeed, so it did not defer compaction. But here we know
-	 * that it didn't succeed, so we do the defer.
-	 */
-	if (last_compact_zone && mode != MIGRATE_ASYNC)
-		defer_compaction(last_compact_zone, order);
