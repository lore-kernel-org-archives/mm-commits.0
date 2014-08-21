From: akpm@linux-foundation.org
Subject: +
 mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range.patch added to -mm tree
Date: Thu, 21 Aug 2014 15:21:58 -0700
Message-ID: <53f67106.FKTwBZ2ir0z57wa6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:33279 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467AbaHUWWA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Aug 2014 18:22:00 -0400
Received: by mail-ob0-f202.google.com with SMTP id wp18so2073040obc.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Aug 2014 15:21:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, cl@linux.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: move pageblock checks up from isolate_migratepages_range()
has been added to the -mm tree.  Its filename is
     mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range.patch

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
Subject: mm, compaction: move pageblock checks up from isolate_migratepages_range()

isolate_migratepages_range() is the main function of the compaction
scanner, called either on a single pageblock by isolate_migratepages()
during regular compaction, or on an arbitrary range by CMA's
__alloc_contig_migrate_range().  It currently perfoms two pageblock-wide
compaction suitability checks, and because of the CMA callpath, it tracks
if it crossed a pageblock boundary in order to repeat those checks.

However, closer inspection shows that those checks are always true for CMA:
- isolation_suitable() is true because CMA sets cc->ignore_skip_hint to true
- migrate_async_suitable() check is skipped because CMA uses sync compaction

We can therefore move the compaction-specific checks to
isolate_migratepages() and simplify isolate_migratepages_range(). 
Furthermore, we can mimic the freepage scanner family of functions, which
has isolate_freepages_block() function called both by compaction from
isolate_freepages() and by CMA from isolate_freepages_range(), where each
use-case adds own specific glue code.  This allows further code
simplification.

Thus, we rename isolate_migratepages_range() to
isolate_migratepages_block() and limit its functionality to a single
pageblock (or its subset).  For CMA, a new different
isolate_migratepages_range() is created as a CMA-specific wrapper for the
_block() function.  The checks specific to compaction are moved to
isolate_migratepages().  As part of the unification of these two families
of functions, we remove the redundant zone parameter where applicable,
since zone pointer is already passed in cc->zone.

Furthermore, going back to compact_zone() and compact_finished() when
pageblock is found unsuitable (now by isolate_migratepages()) is wasteful
- the checks are meant to skip pageblocks quickly.  The patch therefore
also introduces a simple loop into isolate_migratepages() so that it does
not return immediately on failed pageblock checks, but keeps going until
isolate_migratepages_range() gets called once.  Similarily to
isolate_freepages(), the function periodically checks if it needs to
reschedule or abort async compaction.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |  237 ++++++++++++++++++++++++++--------------------
 mm/internal.h   |    4 
 mm/page_alloc.c |    3 
 3 files changed, 142 insertions(+), 102 deletions(-)

diff -puN mm/compaction.c~mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range mm/compaction.c
--- a/mm/compaction.c~mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range
+++ a/mm/compaction.c
@@ -132,7 +132,7 @@ void reset_isolation_suitable(pg_data_t
  */
 static void update_pageblock_skip(struct compact_control *cc,
 			struct page *page, unsigned long nr_isolated,
-			bool set_unsuitable, bool migrate_scanner)
+			bool migrate_scanner)
 {
 	struct zone *zone = cc->zone;
 	unsigned long pfn;
@@ -146,12 +146,7 @@ static void update_pageblock_skip(struct
 	if (nr_isolated)
 		return;
 
-	/*
-	 * Only skip pageblocks when all forms of compaction will be known to
-	 * fail in the near future.
-	 */
-	if (set_unsuitable)
-		set_pageblock_skip(page);
+	set_pageblock_skip(page);
 
 	pfn = page_to_pfn(page);
 
@@ -180,7 +175,7 @@ static inline bool isolation_suitable(st
 
 static void update_pageblock_skip(struct compact_control *cc,
 			struct page *page, unsigned long nr_isolated,
-			bool set_unsuitable, bool migrate_scanner)
+			bool migrate_scanner)
 {
 }
 #endif /* CONFIG_COMPACTION */
@@ -348,8 +343,7 @@ isolate_fail:
 
 	/* Update the pageblock-skip if the whole pageblock was scanned */
 	if (blockpfn == end_pfn)
-		update_pageblock_skip(cc, valid_page, total_isolated, true,
-				      false);
+		update_pageblock_skip(cc, valid_page, total_isolated, false);
 
 	count_compact_events(COMPACTFREE_SCANNED, nr_scanned);
 	if (total_isolated)
@@ -454,40 +448,34 @@ static bool too_many_isolated(struct zon
 }
 
 /**
- * isolate_migratepages_range() - isolate all migrate-able pages in range.
- * @zone:	Zone pages are in.
+ * isolate_migratepages_block() - isolate all migrate-able pages within
+ *				  a single pageblock
  * @cc:		Compaction control structure.
- * @low_pfn:	The first PFN of the range.
- * @end_pfn:	The one-past-the-last PFN of the range.
- * @unevictable: true if it allows to isolate unevictable pages
+ * @low_pfn:	The first PFN to isolate
+ * @end_pfn:	The one-past-the-last PFN to isolate, within same pageblock
+ * @isolate_mode: Isolation mode to be used.
  *
  * Isolate all pages that can be migrated from the range specified by
- * [low_pfn, end_pfn).  Returns zero if there is a fatal signal
- * pending), otherwise PFN of the first page that was not scanned
- * (which may be both less, equal to or more then end_pfn).
- *
- * Assumes that cc->migratepages is empty and cc->nr_migratepages is
- * zero.
+ * [low_pfn, end_pfn). The range is expected to be within same pageblock.
+ * Returns zero if there is a fatal signal pending, otherwise PFN of the
+ * first page that was not scanned (which may be both less, equal to or more
+ * than end_pfn).
  *
- * Apart from cc->migratepages and cc->nr_migratetypes this function
- * does not modify any cc's fields, in particular it does not modify
- * (or read for that matter) cc->migrate_pfn.
- */
-unsigned long
-isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
-		unsigned long low_pfn, unsigned long end_pfn, bool unevictable)
+ * The pages are isolated on cc->migratepages list (not required to be empty),
+ * and cc->nr_migratepages is updated accordingly. The cc->migrate_pfn field
+ * is neither read nor updated.
+ */
+static unsigned long
+isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
+			unsigned long end_pfn, isolate_mode_t isolate_mode)
 {
-	unsigned long last_pageblock_nr = 0, pageblock_nr;
+	struct zone *zone = cc->zone;
 	unsigned long nr_scanned = 0, nr_isolated = 0;
 	struct list_head *migratelist = &cc->migratepages;
 	struct lruvec *lruvec;
 	unsigned long flags;
 	bool locked = false;
 	struct page *page = NULL, *valid_page = NULL;
-	bool set_unsuitable = true;
-	const isolate_mode_t mode = (cc->mode == MIGRATE_ASYNC ?
-					ISOLATE_ASYNC_MIGRATE : 0) |
-				    (unevictable ? ISOLATE_UNEVICTABLE : 0);
 
 	/*
 	 * Ensure that there are not too many pages isolated from the LRU
@@ -518,19 +506,6 @@ isolate_migratepages_range(struct zone *
 			}
 		}
 
-		/*
-		 * migrate_pfn does not necessarily start aligned to a
-		 * pageblock. Ensure that pfn_valid is called when moving
-		 * into a new MAX_ORDER_NR_PAGES range in case of large
-		 * memory holes within the zone
-		 */
-		if ((low_pfn & (MAX_ORDER_NR_PAGES - 1)) == 0) {
-			if (!pfn_valid(low_pfn)) {
-				low_pfn += MAX_ORDER_NR_PAGES - 1;
-				continue;
-			}
-		}
-
 		if (!pfn_valid_within(low_pfn))
 			continue;
 		nr_scanned++;
@@ -548,28 +523,6 @@ isolate_migratepages_range(struct zone *
 		if (!valid_page)
 			valid_page = page;
 
-		/* If isolation recently failed, do not retry */
-		pageblock_nr = low_pfn >> pageblock_order;
-		if (last_pageblock_nr != pageblock_nr) {
-			int mt;
-
-			last_pageblock_nr = pageblock_nr;
-			if (!isolation_suitable(cc, page))
-				goto next_pageblock;
-
-			/*
-			 * For async migration, also only scan in MOVABLE
-			 * blocks. Async migration is optimistic to see if
-			 * the minimum amount of work satisfies the allocation
-			 */
-			mt = get_pageblock_migratetype(page);
-			if (cc->mode == MIGRATE_ASYNC &&
-			    !migrate_async_suitable(mt)) {
-				set_unsuitable = false;
-				goto next_pageblock;
-			}
-		}
-
 		/*
 		 * Skip if free. page_order cannot be used without zone->lock
 		 * as nothing prevents parallel allocations or buddy merging.
@@ -604,8 +557,11 @@ isolate_migratepages_range(struct zone *
 		 */
 		if (PageTransHuge(page)) {
 			if (!locked)
-				goto next_pageblock;
-			low_pfn += (1 << compound_order(page)) - 1;
+				low_pfn = ALIGN(low_pfn + 1,
+						pageblock_nr_pages) - 1;
+			else
+				low_pfn += (1 << compound_order(page)) - 1;
+
 			continue;
 		}
 
@@ -635,7 +591,7 @@ isolate_migratepages_range(struct zone *
 		lruvec = mem_cgroup_page_lruvec(page, zone);
 
 		/* Try isolate the page */
-		if (__isolate_lru_page(page, mode) != 0)
+		if (__isolate_lru_page(page, isolate_mode) != 0)
 			continue;
 
 		VM_BUG_ON_PAGE(PageTransCompound(page), page);
@@ -654,11 +610,6 @@ isolate_success:
 			++low_pfn;
 			break;
 		}
-
-		continue;
-
-next_pageblock:
-		low_pfn = ALIGN(low_pfn + 1, pageblock_nr_pages) - 1;
 	}
 
 	acct_isolated(zone, locked, cc);
@@ -671,8 +622,7 @@ next_pageblock:
 	 * if the whole pageblock was scanned without isolating any page.
 	 */
 	if (low_pfn == end_pfn)
-		update_pageblock_skip(cc, valid_page, nr_isolated,
-				      set_unsuitable, true);
+		update_pageblock_skip(cc, valid_page, nr_isolated, true);
 
 	trace_mm_compaction_isolate_migratepages(nr_scanned, nr_isolated);
 
@@ -683,15 +633,62 @@ next_pageblock:
 	return low_pfn;
 }
 
+/**
+ * isolate_migratepages_range() - isolate migrate-able pages in a PFN range
+ * @cc:        Compaction control structure.
+ * @start_pfn: The first PFN to start isolating.
+ * @end_pfn:   The one-past-last PFN.
+ *
+ * Returns zero if isolation fails fatally due to e.g. pending signal.
+ * Otherwise, function returns one-past-the-last PFN of isolated page
+ * (which may be greater than end_pfn if end fell in a middle of a THP page).
+ */
+unsigned long
+isolate_migratepages_range(struct compact_control *cc, unsigned long start_pfn,
+							unsigned long end_pfn)
+{
+	unsigned long pfn, block_end_pfn;
+
+	/* Scan block by block. First and last block may be incomplete */
+	pfn = start_pfn;
+	block_end_pfn = ALIGN(pfn + 1, pageblock_nr_pages);
+
+	for (; pfn < end_pfn; pfn = block_end_pfn,
+				block_end_pfn += pageblock_nr_pages) {
+
+		block_end_pfn = min(block_end_pfn, end_pfn);
+
+		/* Skip whole pageblock in case of a memory hole */
+		if (!pfn_valid(pfn))
+			continue;
+
+		pfn = isolate_migratepages_block(cc, pfn, block_end_pfn,
+							ISOLATE_UNEVICTABLE);
+
+		/*
+		 * In case of fatal failure, release everything that might
+		 * have been isolated in the previous iteration, and signal
+		 * the failure back to caller.
+		 */
+		if (!pfn) {
+			putback_movable_pages(&cc->migratepages);
+			cc->nr_migratepages = 0;
+			break;
+		}
+	}
+
+	return pfn;
+}
+
 #endif /* CONFIG_COMPACTION || CONFIG_CMA */
 #ifdef CONFIG_COMPACTION
 /*
  * Based on information in the current compact_control, find blocks
  * suitable for isolating free pages from and then isolate them.
  */
-static void isolate_freepages(struct zone *zone,
-				struct compact_control *cc)
+static void isolate_freepages(struct compact_control *cc)
 {
+	struct zone *zone = cc->zone;
 	struct page *page;
 	unsigned long block_start_pfn;	/* start of current pageblock */
 	unsigned long block_end_pfn;	/* end of current pageblock */
@@ -809,7 +806,7 @@ static struct page *compaction_alloc(str
 	 */
 	if (list_empty(&cc->freepages)) {
 		if (!cc->contended)
-			isolate_freepages(cc->zone, cc);
+			isolate_freepages(cc);
 
 		if (list_empty(&cc->freepages))
 			return NULL;
@@ -843,34 +840,81 @@ typedef enum {
 } isolate_migrate_t;
 
 /*
- * Isolate all pages that can be migrated from the block pointed to by
- * the migrate scanner within compact_control.
+ * Isolate all pages that can be migrated from the first suitable block,
+ * starting at the block pointed to by the migrate scanner pfn within
+ * compact_control.
  */
 static isolate_migrate_t isolate_migratepages(struct zone *zone,
 					struct compact_control *cc)
 {
 	unsigned long low_pfn, end_pfn;
+	struct page *page;
+	const isolate_mode_t isolate_mode =
+		(cc->mode == MIGRATE_ASYNC ? ISOLATE_ASYNC_MIGRATE : 0);
 
-	/* Do not scan outside zone boundaries */
-	low_pfn = max(cc->migrate_pfn, zone->zone_start_pfn);
+	/*
+	 * Start at where we last stopped, or beginning of the zone as
+	 * initialized by compact_zone()
+	 */
+	low_pfn = cc->migrate_pfn;
 
 	/* Only scan within a pageblock boundary */
 	end_pfn = ALIGN(low_pfn + 1, pageblock_nr_pages);
 
-	/* Do not cross the free scanner or scan within a memory hole */
-	if (end_pfn > cc->free_pfn || !pfn_valid(low_pfn)) {
-		cc->migrate_pfn = end_pfn;
-		return ISOLATE_NONE;
-	}
+	/*
+	 * Iterate over whole pageblocks until we find the first suitable.
+	 * Do not cross the free scanner.
+	 */
+	for (; end_pfn <= cc->free_pfn;
+			low_pfn = end_pfn, end_pfn += pageblock_nr_pages) {
+
+		/*
+		 * This can potentially iterate a massively long zone with
+		 * many pageblocks unsuitable, so periodically check if we
+		 * need to schedule, or even abort async compaction.
+		 */
+		if (!(low_pfn % (SWAP_CLUSTER_MAX * pageblock_nr_pages))
+						&& compact_should_abort(cc))
+			break;
 
-	/* Perform the isolation */
-	low_pfn = isolate_migratepages_range(zone, cc, low_pfn, end_pfn, false);
-	if (!low_pfn || cc->contended)
-		return ISOLATE_ABORT;
+		/* Skip whole pageblock in case of a memory hole */
+		if (!pfn_valid(low_pfn))
+			continue;
+
+		page = pfn_to_page(low_pfn);
+
+		/* If isolation recently failed, do not retry */
+		if (!isolation_suitable(cc, page))
+			continue;
 
+		/*
+		 * For async compaction, also only scan in MOVABLE blocks.
+		 * Async compaction is optimistic to see if the minimum amount
+		 * of work satisfies the allocation.
+		 */
+		if (cc->mode == MIGRATE_ASYNC &&
+		    !migrate_async_suitable(get_pageblock_migratetype(page)))
+			continue;
+
+		/* Perform the isolation */
+		low_pfn = isolate_migratepages_block(cc, low_pfn, end_pfn,
+								isolate_mode);
+
+		if (!low_pfn || cc->contended)
+			return ISOLATE_ABORT;
+
+		/*
+		 * Either we isolated something and proceed with migration. Or
+		 * we failed and compact_zone should decide if we should
+		 * continue or not.
+		 */
+		break;
+	}
+
+	/* Record where migration scanner will be restarted */
 	cc->migrate_pfn = low_pfn;
 
-	return ISOLATE_SUCCESS;
+	return cc->nr_migratepages ? ISOLATE_SUCCESS : ISOLATE_NONE;
 }
 
 static int compact_finished(struct zone *zone,
@@ -1043,9 +1087,6 @@ static int compact_zone(struct zone *zon
 			;
 		}
 
-		if (!cc->nr_migratepages)
-			continue;
-
 		err = migrate_pages(&cc->migratepages, compaction_alloc,
 				compaction_free, (unsigned long)cc, cc->mode,
 				MR_COMPACTION);
diff -puN mm/internal.h~mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range mm/internal.h
--- a/mm/internal.h~mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range
+++ a/mm/internal.h
@@ -154,8 +154,8 @@ unsigned long
 isolate_freepages_range(struct compact_control *cc,
 			unsigned long start_pfn, unsigned long end_pfn);
 unsigned long
-isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
-	unsigned long low_pfn, unsigned long end_pfn, bool unevictable);
+isolate_migratepages_range(struct compact_control *cc,
+			   unsigned long low_pfn, unsigned long end_pfn);
 
 #endif
 
diff -puN mm/page_alloc.c~mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range
+++ a/mm/page_alloc.c
@@ -6291,8 +6291,7 @@ static int __alloc_contig_migrate_range(
 
 		if (list_empty(&cc->migratepages)) {
 			cc->nr_migratepages = 0;
-			pfn = isolate_migratepages_range(cc->zone, cc,
-							 pfn, end, true);
+			pfn = isolate_migratepages_range(cc, pfn, end);
 			if (!pfn) {
 				ret = -EINTR;
 				break;
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_alloc-determine-migratetype-only-once.patch
mm-thp-dont-hold-mmap_sem-in-khugepaged-when-allocating-thp.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone.patch
mm-compaction-do-not-count-compact_stall-if-all-zones-skipped-compaction.patch
mm-compaction-do-not-recheck-suitable_migration_target-under-lock.patch
mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range.patch
mm-compaction-reduce-zone-checking-frequency-in-the-migration-scanner.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched.patch
mm-compaction-periodically-drop-lock-and-restore-irqs-in-scanners.patch
mm-compaction-skip-rechecks-when-lock-was-already-held.patch
mm-compaction-remember-position-within-pageblock-in-free-pages-scanner.patch
mm-compaction-skip-buddy-pages-by-their-order-in-the-migrate-scanner.patch
mm-rename-allocflags_to_migratetype-for-clarity.patch
mm-compaction-pass-gfp-mask-to-compact_control.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch

