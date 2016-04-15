From: akpm@linux-foundation.org
Subject: + mm-page_alloc-convert-alloc_flags-to-unsigned.patch added to
 -mm tree
Date: Fri, 15 Apr 2016 16:12:01 -0700
Message-ID: <57117541.pXhNKpW6NSyc+3RJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42544 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbcDOXMC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Apr 2016 19:12:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, brouer@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: convert alloc_flags to unsigned
has been added to the -mm tree.  Its filename is
     mm-page_alloc-convert-alloc_flags-to-unsigned.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-convert-alloc_flags-to-unsigned.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-convert-alloc_flags-to-unsigned.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: convert alloc_flags to unsigned

alloc_flags is a bitmask of flags but it is signed which does not
necessarily generate the best code depending on the compiler.  Even
without an impact, it makes more sense that this be unsigned.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
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
@@ -750,7 +750,8 @@ extern struct mutex zonelists_mutex;
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
@@ -1365,7 +1365,8 @@ static int compact_finished(struct zone
  *   COMPACT_CONTINUE - If compaction should run now
  */
 static unsigned long __compaction_suitable(struct zone *zone, int order,
-					int alloc_flags, int classzone_idx)
+					unsigned int alloc_flags,
+					int classzone_idx)
 {
 	int fragindex;
 	unsigned long watermark;
@@ -1410,7 +1411,8 @@ static unsigned long __compaction_suitab
 }
 
 unsigned long compaction_suitable(struct zone *zone, int order,
-					int alloc_flags, int classzone_idx)
+					unsigned int alloc_flags,
+					int classzone_idx)
 {
 	unsigned long ret;
 
@@ -1590,7 +1592,7 @@ out:
 
 static unsigned long compact_zone_order(struct zone *zone, int order,
 		gfp_t gfp_mask, enum migrate_mode mode, int *contended,
-		int alloc_flags, int classzone_idx)
+		unsigned int alloc_flags, int classzone_idx)
 {
 	unsigned long ret;
 	struct compact_control cc = {
@@ -1632,8 +1634,8 @@ int sysctl_extfrag_threshold = 500;
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
@@ -180,7 +180,7 @@ struct compact_control {
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
@@ -2418,7 +2418,8 @@ static inline void zone_statistics(struc
 static inline
 struct page *buffered_rmqueue(struct zone *preferred_zone,
 			struct zone *zone, unsigned int order,
-			gfp_t gfp_flags, int alloc_flags, int migratetype)
+			gfp_t gfp_flags, unsigned int alloc_flags,
+			int migratetype)
 {
 	unsigned long flags;
 	struct page *page;
@@ -2572,12 +2573,13 @@ static inline bool should_fail_alloc_pag
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
@@ -2640,7 +2642,7 @@ static bool __zone_watermark_ok(struct z
 }
 
 bool zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
-		      int classzone_idx, int alloc_flags)
+		      int classzone_idx, unsigned int alloc_flags)
 {
 	return __zone_watermark_ok(z, order, mark, classzone_idx, alloc_flags,
 					zone_page_state(z, NR_FREE_PAGES));
@@ -2984,7 +2986,7 @@ out:
 /* Try memory compaction for high-order allocations before reclaim */
 static struct page *
 __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
-		int alloc_flags, const struct alloc_context *ac,
+		unsigned int alloc_flags, const struct alloc_context *ac,
 		enum migrate_mode mode, int *contended_compaction,
 		bool *deferred_compaction)
 {
@@ -3040,7 +3042,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 #else
 static inline struct page *
 __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
-		int alloc_flags, const struct alloc_context *ac,
+		unsigned int alloc_flags, const struct alloc_context *ac,
 		enum migrate_mode mode, int *contended_compaction,
 		bool *deferred_compaction)
 {
@@ -3080,7 +3082,7 @@ __perform_reclaim(gfp_t gfp_mask, unsign
 /* The really slow allocator path where we enter direct reclaim */
 static inline struct page *
 __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
-		int alloc_flags, const struct alloc_context *ac,
+		unsigned int alloc_flags, const struct alloc_context *ac,
 		unsigned long *did_some_progress)
 {
 	struct page *page = NULL;
@@ -3119,10 +3121,10 @@ static void wake_all_kswapds(unsigned in
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
@@ -3183,7 +3185,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 {
 	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
 	struct page *page = NULL;
-	int alloc_flags;
+	unsigned int alloc_flags;
 	unsigned long pages_reclaimed = 0;
 	unsigned long did_some_progress;
 	enum migrate_mode migration_mode = MIGRATE_ASYNC;
@@ -3375,7 +3377,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
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

mm-page_alloc-only-check-pagecompound-for-high-order-pages.patch
mm-page_alloc-use-new-pageanonhead-helper-in-the-free-page-fast-path.patch
mm-page_alloc-reduce-branches-in-zone_statistics.patch
mm-page_alloc-inline-zone_statistics.patch
mm-page_alloc-inline-the-fast-path-of-the-zonelist-iterator.patch
mm-page_alloc-use-__dec_zone_state-for-order-0-page-allocation.patch
mm-page_alloc-avoid-unnecessary-zone-lookups-during-pageblock-operations.patch
mm-page_alloc-convert-alloc_flags-to-unsigned.patch
mm-page_alloc-convert-nr_fair_skipped-to-bool.patch
mm-page_alloc-remove-unnecessary-local-variable-in-get_page_from_freelist.patch
mm-page_alloc-remove-unnecessary-initialisation-in-get_page_from_freelist.patch
mm-page_alloc-remove-redundant-check-for-empty-zonelist.patch
mm-page_alloc-simplify-last-cpupid-reset.patch
mm-page_alloc-move-might_sleep_if-check-to-the-allocator-slowpath.patch
mm-page_alloc-move-__gfp_hardwall-modifications-out-of-the-fastpath.patch
mm-page_alloc-check-once-if-a-zone-has-isolated-pageblocks.patch
mm-page_alloc-shorten-the-page-allocator-fast-path.patch
mm-page_alloc-reduce-cost-of-fair-zone-allocation-policy-retry.patch
mm-page_alloc-shortcut-watermark-checks-for-order-0-pages.patch
mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice.patch
mm-page_alloc-remove-field-from-alloc_context.patch
mm-page_alloc-check-multiple-page-fields-with-a-single-branch.patch
mm-page_alloc-remove-unnecessary-variable-from-free_pcppages_bulk.patch
mm-page_alloc-inline-pageblock-lookup-in-page-free-fast-paths.patch
mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain.patch
mm-page_alloc-defer-debugging-checks-of-pages-allocated-from-the-pcp.patch

