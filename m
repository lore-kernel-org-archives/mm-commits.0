From: akpm@linux-foundation.org
Subject: +
 mm-compaction-add-per-zone-migration-pfn-cache-for-async-compaction.patch
 added to -mm tree
Date: Wed, 07 May 2014 14:20:48 -0700
Message-ID: <536aa3b0.0Gxl2X3vYmsey3Yq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57586 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbaEGVUt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2014 17:20:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, n-horiguchi@ah.jp.nec.com, mgorman@suse.de, gthelen@google.com, rientjes@google.com

Subject: + mm-compaction-add-per-zone-migration-pfn-cache-for-async-compaction.patch added to -mm tree
To: rientjes@google.com,gthelen@google.com,mgorman@suse.de,n-horiguchi@ah.jp.nec.com,vbabka@suse.cz
From: akpm@linux-foundation.org
Date: Wed, 07 May 2014 14:20:48 -0700


The patch titled
     Subject: mm, compaction: add per-zone migration pfn cache for async compaction
has been added to the -mm tree.  Its filename is
     mm-compaction-add-per-zone-migration-pfn-cache-for-async-compaction.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-add-per-zone-migration-pfn-cache-for-async-compaction.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-add-per-zone-migration-pfn-cache-for-async-compaction.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, compaction: add per-zone migration pfn cache for async compaction

Each zone has a cached migration scanner pfn for memory compaction so that
subsequent calls to memory compaction can start where the previous call
left off.

Currently, the compaction migration scanner only updates the per-zone
cached pfn when pageblocks were not skipped for async compaction.  This
creates a dependency on calling sync compaction to avoid having subsequent
calls to async compaction from scanning an enormous amount of non-MOVABLE
pageblocks each time it is called.  On large machines, this could be
potentially very expensive.

This patch adds a per-zone cached migration scanner pfn only for async
compaction.  It is updated everytime a pageblock has been scanned in its
entirety and when no pages from it were successfully isolated.  The cached
migration scanner pfn for sync compaction is updated only when called for
sync compaction.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    5 +-
 mm/compaction.c        |   66 +++++++++++++++++++++++----------------
 2 files changed, 43 insertions(+), 28 deletions(-)

diff -puN include/linux/mmzone.h~mm-compaction-add-per-zone-migration-pfn-cache-for-async-compaction include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-compaction-add-per-zone-migration-pfn-cache-for-async-compaction
+++ a/include/linux/mmzone.h
@@ -360,9 +360,10 @@ struct zone {
 	/* Set to true when the PG_migrate_skip bits should be cleared */
 	bool			compact_blockskip_flush;
 
-	/* pfns where compaction scanners should start */
+	/* pfn where compaction free scanner should start */
 	unsigned long		compact_cached_free_pfn;
-	unsigned long		compact_cached_migrate_pfn;
+	/* pfn where async and sync compaction migration scanner should start */
+	unsigned long		compact_cached_migrate_pfn[2];
 #endif
 #ifdef CONFIG_MEMORY_HOTPLUG
 	/* see spanned/present_pages for more description */
diff -puN mm/compaction.c~mm-compaction-add-per-zone-migration-pfn-cache-for-async-compaction mm/compaction.c
--- a/mm/compaction.c~mm-compaction-add-per-zone-migration-pfn-cache-for-async-compaction
+++ a/mm/compaction.c
@@ -89,7 +89,8 @@ static void __reset_isolation_suitable(s
 	unsigned long end_pfn = zone_end_pfn(zone);
 	unsigned long pfn;
 
-	zone->compact_cached_migrate_pfn = start_pfn;
+	zone->compact_cached_migrate_pfn[0] = start_pfn;
+	zone->compact_cached_migrate_pfn[1] = start_pfn;
 	zone->compact_cached_free_pfn = end_pfn;
 	zone->compact_blockskip_flush = false;
 
@@ -131,9 +132,10 @@ void reset_isolation_suitable(pg_data_t
  */
 static void update_pageblock_skip(struct compact_control *cc,
 			struct page *page, unsigned long nr_isolated,
-			bool migrate_scanner)
+			bool set_unsuitable, bool migrate_scanner)
 {
 	struct zone *zone = cc->zone;
+	unsigned long pfn;
 
 	if (cc->ignore_skip_hint)
 		return;
@@ -141,20 +143,31 @@ static void update_pageblock_skip(struct
 	if (!page)
 		return;
 
-	if (!nr_isolated) {
-		unsigned long pfn = page_to_pfn(page);
+	if (nr_isolated)
+		return;
+
+	/*
+	 * Only skip pageblocks when all forms of compaction will be known to
+	 * fail in the near future.
+	 */
+	if (set_unsuitable)
 		set_pageblock_skip(page);
 
-		/* Update where compaction should restart */
-		if (migrate_scanner) {
-			if (!cc->finished_update_migrate &&
-			    pfn > zone->compact_cached_migrate_pfn)
-				zone->compact_cached_migrate_pfn = pfn;
-		} else {
-			if (!cc->finished_update_free &&
-			    pfn < zone->compact_cached_free_pfn)
-				zone->compact_cached_free_pfn = pfn;
-		}
+	pfn = page_to_pfn(page);
+
+	/* Update where async and sync compaction should restart */
+	if (migrate_scanner) {
+		if (cc->finished_update_migrate)
+			return;
+		if (pfn > zone->compact_cached_migrate_pfn[0])
+			zone->compact_cached_migrate_pfn[0] = pfn;
+		if (cc->sync && pfn > zone->compact_cached_migrate_pfn[1])
+			zone->compact_cached_migrate_pfn[1] = pfn;
+	} else {
+		if (cc->finished_update_free)
+			return;
+		if (pfn < zone->compact_cached_free_pfn)
+			zone->compact_cached_free_pfn = pfn;
 	}
 }
 #else
@@ -166,7 +179,7 @@ static inline bool isolation_suitable(st
 
 static void update_pageblock_skip(struct compact_control *cc,
 			struct page *page, unsigned long nr_isolated,
-			bool migrate_scanner)
+			bool set_unsuitable, bool migrate_scanner)
 {
 }
 #endif /* CONFIG_COMPACTION */
@@ -320,7 +333,8 @@ isolate_fail:
 
 	/* Update the pageblock-skip if the whole pageblock was scanned */
 	if (blockpfn == end_pfn)
-		update_pageblock_skip(cc, valid_page, total_isolated, false);
+		update_pageblock_skip(cc, valid_page, total_isolated, true,
+				      false);
 
 	count_compact_events(COMPACTFREE_SCANNED, nr_scanned);
 	if (total_isolated)
@@ -455,7 +469,7 @@ isolate_migratepages_range(struct zone *
 	unsigned long flags;
 	bool locked = false;
 	struct page *page = NULL, *valid_page = NULL;
-	bool skipped_async_unsuitable = false;
+	bool set_unsuitable = true;
 	const isolate_mode_t mode = (!cc->sync ? ISOLATE_ASYNC_MIGRATE : 0) |
 				    (unevictable ? ISOLATE_UNEVICTABLE : 0);
 
@@ -532,8 +546,7 @@ isolate_migratepages_range(struct zone *
 			 */
 			mt = get_pageblock_migratetype(page);
 			if (!cc->sync && !migrate_async_suitable(mt)) {
-				cc->finished_update_migrate = true;
-				skipped_async_unsuitable = true;
+				set_unsuitable = false;
 				goto next_pageblock;
 			}
 		}
@@ -637,11 +650,10 @@ next_pageblock:
 	/*
 	 * Update the pageblock-skip information and cached scanner pfn,
 	 * if the whole pageblock was scanned without isolating any page.
-	 * This is not done when pageblock was skipped due to being unsuitable
-	 * for async compaction, so that eventual sync compaction can try.
 	 */
-	if (low_pfn == end_pfn && !skipped_async_unsuitable)
-		update_pageblock_skip(cc, valid_page, nr_isolated, true);
+	if (low_pfn == end_pfn)
+		update_pageblock_skip(cc, valid_page, nr_isolated,
+				      set_unsuitable, true);
 
 	trace_mm_compaction_isolate_migratepages(nr_scanned, nr_isolated);
 
@@ -865,7 +877,8 @@ static int compact_finished(struct zone
 	/* Compaction run completes if the migrate and free scanner meet */
 	if (cc->free_pfn <= cc->migrate_pfn) {
 		/* Let the next compaction start anew. */
-		zone->compact_cached_migrate_pfn = zone->zone_start_pfn;
+		zone->compact_cached_migrate_pfn[0] = zone->zone_start_pfn;
+		zone->compact_cached_migrate_pfn[1] = zone->zone_start_pfn;
 		zone->compact_cached_free_pfn = zone_end_pfn(zone);
 
 		/*
@@ -990,7 +1003,7 @@ static int compact_zone(struct zone *zon
 	 * information on where the scanners should start but check that it
 	 * is initialised by ensuring the values are within zone boundaries.
 	 */
-	cc->migrate_pfn = zone->compact_cached_migrate_pfn;
+	cc->migrate_pfn = zone->compact_cached_migrate_pfn[cc->sync];
 	cc->free_pfn = zone->compact_cached_free_pfn;
 	if (cc->free_pfn < start_pfn || cc->free_pfn > end_pfn) {
 		cc->free_pfn = end_pfn & ~(pageblock_nr_pages-1);
@@ -998,7 +1011,8 @@ static int compact_zone(struct zone *zon
 	}
 	if (cc->migrate_pfn < start_pfn || cc->migrate_pfn > end_pfn) {
 		cc->migrate_pfn = start_pfn;
-		zone->compact_cached_migrate_pfn = cc->migrate_pfn;
+		zone->compact_cached_migrate_pfn[0] = cc->migrate_pfn;
+		zone->compact_cached_migrate_pfn[1] = cc->migrate_pfn;
 	}
 
 	trace_mm_compaction_begin(start_pfn, cc->migrate_pfn, cc->free_pfn, end_pfn);
_

Patches currently in -mm which might be from rientjes@google.com are

mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control.patch
mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control-fix.patch
hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch
hugetlb-add-hstate_is_gigantic.patch
hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch
hugetlb-move-helpers-up-in-the-file.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
mem-hotplug-implement-get-put_online_mems.patch
slab-get_online_mems-for-kmem_cache_createdestroyshrink.patch
mm-debug-make-bad_range-output-more-usable-and-readable.patch
memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch
mm-migration-add-destination-page-freeing-callback.patch
mm-compaction-return-failed-migration-target-pages-back-to-freelist.patch
mm-compaction-add-per-zone-migration-pfn-cache-for-async-compaction.patch
mm-compaction-embed-migration-mode-in-compact_control.patch
mm-thp-avoid-excessive-compaction-latency-during-fault.patch
mm-compaction-terminate-async-compaction-when-rescheduling.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

