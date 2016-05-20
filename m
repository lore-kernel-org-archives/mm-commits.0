From: akpm@linux-foundation.org
Subject: [merged] mm-page_alloc-convert-alloc_flags-to-unsigned.patch
 removed from -mm tree
Date: Fri, 20 May 2016 14:06:24 -0700
Message-ID: <573f7c50.repdIVbMw9fbhhIL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47318 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbcETVGZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:06:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, brouer@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: convert alloc_flags to unsigned
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-convert-alloc_flags-to-unsigned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: convert alloc_flags to unsigned

alloc_flags is a bitmask of flags but it is signed which does not
necessarily generate the best code depending on the compiler.  Even
without an impact, it makes more sense that this be unsigned.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |    6 +++---
 include/linux/mmzone.h     |    3 ++-
 mm/compaction.c            |   12 +++++++-----
 mm/internal.h              |    2 +-
 mm/page_alloc.c            |   26 ++++++++++++++------------
 5 files changed, 27 insertions(+), 22 deletions(-)

diff -puN include/linux/compaction.h~mm-page_alloc-convert-alloc_flags-to-unsigned include/linux/compaction.h
--- a/include/linux/compaction.h~mm-page_alloc-convert-alloc_flags-to-unsigned
+++ a/include/linux/compaction.h
@@ -39,12 +39,12 @@ extern int sysctl_compact_unevictable_al
 
 extern int fragmentation_index(struct zone *zone, unsigned int order);
 extern unsigned long try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
-			int alloc_flags, const struct alloc_context *ac,
-			enum migrate_mode mode, int *contended);
+		unsigned int alloc_flags, const struct alloc_context *ac,
+		enum migrate_mode mode, int *contended);
 extern void compact_pgdat(pg_data_t *pgdat, int order);
 extern void reset_isolation_suitable(pg_data_t *pgdat);
 extern unsigned long compaction_suitable(struct zone *zone, int order,
-					int alloc_flags, int classzone_idx);
+		unsigned int alloc_flags, int classzone_idx);
 
 extern void defer_compaction(struct zone *zone, int order);
 extern bool compaction_deferred(struct zone *zone, int order);
diff -puN include/linux/mmzone.h~mm-page_alloc-convert-alloc_flags-to-unsigned include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-page_alloc-convert-alloc_flags-to-unsigned
+++ a/include/linux/mmzone.h
@@ -747,7 +747,8 @@ extern struct mutex zonelists_mutex;
 void build_all_zonelists(pg_data_t *pgdat, struct zone *zone);
 void wakeup_kswapd(struct zone *zone, int order, enum zone_type classzone_idx);
 bool zone_watermark_ok(struct zone *z, unsigned int order,
-		unsigned long mark, int classzone_idx, int alloc_flags);
+		unsigned long mark, int classzone_idx,
+		unsigned int alloc_flags);
 bool zone_watermark_ok_safe(struct zone *z, unsigned int order,
 		unsigned long mark, int classzone_idx);
 enum memmap_context {
diff -puN mm/compaction.c~mm-page_alloc-convert-alloc_flags-to-unsigned mm/compaction.c
--- a/mm/compaction.c~mm-page_alloc-convert-alloc_flags-to-unsigned
+++ a/mm/compaction.c
@@ -1313,7 +1313,8 @@ static int compact_finished(struct zone
  *   COMPACT_CONTINUE - If compaction should run now
  */
 static unsigned long __compaction_suitable(struct zone *zone, int order,
-					int alloc_flags, int classzone_idx)
+					unsigned int alloc_flags,
+					int classzone_idx)
 {
 	int fragindex;
 	unsigned long watermark;
@@ -1358,7 +1359,8 @@ static unsigned long __compaction_suitab
 }
 
 unsigned long compaction_suitable(struct zone *zone, int order,
-					int alloc_flags, int classzone_idx)
+					unsigned int alloc_flags,
+					int classzone_idx)
 {
 	unsigned long ret;
 
@@ -1530,7 +1532,7 @@ out:
 
 static unsigned long compact_zone_order(struct zone *zone, int order,
 		gfp_t gfp_mask, enum migrate_mode mode, int *contended,
-		int alloc_flags, int classzone_idx)
+		unsigned int alloc_flags, int classzone_idx)
 {
 	unsigned long ret;
 	struct compact_control cc = {
@@ -1571,8 +1573,8 @@ int sysctl_extfrag_threshold = 500;
  * This is the main entry point for direct page compaction.
  */
 unsigned long try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
-			int alloc_flags, const struct alloc_context *ac,
-			enum migrate_mode mode, int *contended)
+		unsigned int alloc_flags, const struct alloc_context *ac,
+		enum migrate_mode mode, int *contended)
 {
 	int may_enter_fs = gfp_mask & __GFP_FS;
 	int may_perform_io = gfp_mask & __GFP_IO;
diff -puN mm/internal.h~mm-page_alloc-convert-alloc_flags-to-unsigned mm/internal.h
--- a/mm/internal.h~mm-page_alloc-convert-alloc_flags-to-unsigned
+++ a/mm/internal.h
@@ -175,7 +175,7 @@ struct compact_control {
 	bool direct_compaction;		/* False from kcompactd or /proc/... */
 	int order;			/* order a direct compactor needs */
 	const gfp_t gfp_mask;		/* gfp mask of a direct compactor */
-	const int alloc_flags;		/* alloc flags of a direct compactor */
+	const unsigned int alloc_flags;	/* alloc flags of a direct compactor */
 	const int classzone_idx;	/* zone index of a direct compactor */
 	struct zone *zone;
 	int contended;			/* Signal need_sched() or lock
diff -puN mm/page_alloc.c~mm-page_alloc-convert-alloc_flags-to-unsigned mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-convert-alloc_flags-to-unsigned
+++ a/mm/page_alloc.c
@@ -1525,7 +1525,7 @@ static inline bool free_pages_prezeroed(
 }
 
 static int prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags,
-								int alloc_flags)
+							unsigned int alloc_flags)
 {
 	int i;
 	bool poisoned = true;
@@ -2391,7 +2391,8 @@ static inline void zone_statistics(struc
 static inline
 struct page *buffered_rmqueue(struct zone *preferred_zone,
 			struct zone *zone, unsigned int order,
-			gfp_t gfp_flags, int alloc_flags, int migratetype)
+			gfp_t gfp_flags, unsigned int alloc_flags,
+			int migratetype)
 {
 	unsigned long flags;
 	struct page *page;
@@ -2545,12 +2546,13 @@ static inline bool should_fail_alloc_pag
  * to check in the allocation paths if no pages are free.
  */
 static bool __zone_watermark_ok(struct zone *z, unsigned int order,
-			unsigned long mark, int classzone_idx, int alloc_flags,
+			unsigned long mark, int classzone_idx,
+			unsigned int alloc_flags,
 			long free_pages)
 {
 	long min = mark;
 	int o;
-	const int alloc_harder = (alloc_flags & ALLOC_HARDER);
+	const bool alloc_harder = (alloc_flags & ALLOC_HARDER);
 
 	/* free_pages may go negative - that's OK */
 	free_pages -= (1 << order) - 1;
@@ -2613,7 +2615,7 @@ static bool __zone_watermark_ok(struct z
 }
 
 bool zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
-		      int classzone_idx, int alloc_flags)
+		      int classzone_idx, unsigned int alloc_flags)
 {
 	return __zone_watermark_ok(z, order, mark, classzone_idx, alloc_flags,
 					zone_page_state(z, NR_FREE_PAGES));
@@ -2957,7 +2959,7 @@ out:
 /* Try memory compaction for high-order allocations before reclaim */
 static struct page *
 __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
-		int alloc_flags, const struct alloc_context *ac,
+		unsigned int alloc_flags, const struct alloc_context *ac,
 		enum migrate_mode mode, int *contended_compaction,
 		bool *deferred_compaction)
 {
@@ -3013,7 +3015,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 #else
 static inline struct page *
 __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
-		int alloc_flags, const struct alloc_context *ac,
+		unsigned int alloc_flags, const struct alloc_context *ac,
 		enum migrate_mode mode, int *contended_compaction,
 		bool *deferred_compaction)
 {
@@ -3053,7 +3055,7 @@ __perform_reclaim(gfp_t gfp_mask, unsign
 /* The really slow allocator path where we enter direct reclaim */
 static inline struct page *
 __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
-		int alloc_flags, const struct alloc_context *ac,
+		unsigned int alloc_flags, const struct alloc_context *ac,
 		unsigned long *did_some_progress)
 {
 	struct page *page = NULL;
@@ -3092,10 +3094,10 @@ static void wake_all_kswapds(unsigned in
 		wakeup_kswapd(zone, order, zone_idx(ac->preferred_zone));
 }
 
-static inline int
+static inline unsigned int
 gfp_to_alloc_flags(gfp_t gfp_mask)
 {
-	int alloc_flags = ALLOC_WMARK_MIN | ALLOC_CPUSET;
+	unsigned int alloc_flags = ALLOC_WMARK_MIN | ALLOC_CPUSET;
 
 	/* __GFP_HIGH is assumed to be the same as ALLOC_HIGH to save a branch. */
 	BUILD_BUG_ON(__GFP_HIGH != (__force gfp_t) ALLOC_HIGH);
@@ -3156,7 +3158,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 {
 	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
 	struct page *page = NULL;
-	int alloc_flags;
+	unsigned int alloc_flags;
 	unsigned long pages_reclaimed = 0;
 	unsigned long did_some_progress;
 	enum migrate_mode migration_mode = MIGRATE_ASYNC;
@@ -3348,7 +3350,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	struct zoneref *preferred_zoneref;
 	struct page *page = NULL;
 	unsigned int cpuset_mems_cookie;
-	int alloc_flags = ALLOC_WMARK_LOW|ALLOC_FAIR;
+	unsigned int alloc_flags = ALLOC_WMARK_LOW|ALLOC_FAIR;
 	gfp_t alloc_mask; /* The gfp_t that was actually used for allocation */
 	struct alloc_context ac = {
 		.high_zoneidx = gfp_zone(gfp_mask),
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


