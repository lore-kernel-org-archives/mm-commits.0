From: akpm@linux-foundation.org
Subject: + mm-compaction-do-not-count-migratepages-when-unnecessary.patch
 added to -mm tree
Date: Wed, 07 May 2014 14:22:41 -0700
Message-ID: <536aa421.xgy6j0yOy71/yoho%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57615 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbaEGVWn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2014 17:22:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, riel@redhat.com, n-horiguchi@ah.jp.nec.com, minchan@kernel.org, mina86@mina86.com, mgorman@suse.de, iamjoonsoo.kim@lge.com, cl@linux.com, b.zolnierkie@samsung.com, vbabka@suse.cz

Subject: + mm-compaction-do-not-count-migratepages-when-unnecessary.patch added to -mm tree
To: vbabka@suse.cz,b.zolnierkie@samsung.com,cl@linux.com,iamjoonsoo.kim@lge.com,mgorman@suse.de,mina86@mina86.com,minchan@kernel.org,n-horiguchi@ah.jp.nec.com,riel@redhat.com,rientjes@google.com
From: akpm@linux-foundation.org
Date: Wed, 07 May 2014 14:22:41 -0700


The patch titled
     Subject: mm/compaction: do not count migratepages when unnecessary
has been added to the -mm tree.  Its filename is
     mm-compaction-do-not-count-migratepages-when-unnecessary.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-do-not-count-migratepages-when-unnecessary.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-do-not-count-migratepages-when-unnecessary.patch

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
Subject: mm/compaction: do not count migratepages when unnecessary

During compaction, update_nr_listpages() has been used to count remaining
non-migrated and free pages after a call to migrage_pages().  The
freepages counting has become unneccessary, and it turns out that
migratepages counting is also unnecessary in most cases.

The only situation when it's needed to count cc->migratepages is when
migrate_pages() returns with a negative error code.  Otherwise, the
non-negative return value is the number of pages that were not migrated,
which is exactly the count of remaining pages in the cc->migratepages
list.

Furthermore, any non-zero count is only interesting for the tracepoint of
mm_compaction_migratepages events, because after that all remaining
unmigrated pages are put back and their count is set to 0.

This patch therefore removes update_nr_listpages() completely, and changes
the tracepoint definition so that the manual counting is done only when
the tracepoint is enabled, and only when migrate_pages() returns a
negative error code.

Furthermore, migrate_pages() and the tracepoints won't be called when
there's nothing to migrate.  This potentially avoids some wasted cycles
and reduces the volume of uninteresting mm_compaction_migratepages events
where "nr_migrated=0 nr_failed=0".  In the stress-highalloc mmtest, this
was about 75% of the events.  The mm_compaction_isolate_migratepages event
is better for determining that nothing was isolated for migration, and
this one was just duplicating the info.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/compaction.h |   26 +++++++++++++++++++----
 mm/compaction.c                   |   31 ++++++----------------------
 2 files changed, 29 insertions(+), 28 deletions(-)

diff -puN include/trace/events/compaction.h~mm-compaction-do-not-count-migratepages-when-unnecessary include/trace/events/compaction.h
--- a/include/trace/events/compaction.h~mm-compaction-do-not-count-migratepages-when-unnecessary
+++ a/include/trace/events/compaction.h
@@ -5,7 +5,9 @@
 #define _TRACE_COMPACTION_H
 
 #include <linux/types.h>
+#include <linux/list.h>
 #include <linux/tracepoint.h>
+#include <linux/mm_types.h>
 #include <trace/events/gfpflags.h>
 
 DECLARE_EVENT_CLASS(mm_compaction_isolate_template,
@@ -47,10 +49,11 @@ DEFINE_EVENT(mm_compaction_isolate_templ
 
 TRACE_EVENT(mm_compaction_migratepages,
 
-	TP_PROTO(unsigned long nr_migrated,
-		unsigned long nr_failed),
+	TP_PROTO(unsigned long nr_all,
+		int migrate_rc,
+		struct list_head *migratepages),
 
-	TP_ARGS(nr_migrated, nr_failed),
+	TP_ARGS(nr_all, migrate_rc, migratepages),
 
 	TP_STRUCT__entry(
 		__field(unsigned long, nr_migrated)
@@ -58,7 +61,22 @@ TRACE_EVENT(mm_compaction_migratepages,
 	),
 
 	TP_fast_assign(
-		__entry->nr_migrated = nr_migrated;
+		unsigned long nr_failed = 0;
+		struct page *page;
+
+		/*
+		 * migrate_pages() returns either a non-negative number
+		 * with the number of pages that failed migration, or an
+		 * error code, in which case we need to count the remaining
+		 * pages manually
+		 */
+		if (migrate_rc >= 0)
+			nr_failed = migrate_rc;
+		else
+			list_for_each_entry(page, migratepages, lru)
+				nr_failed++;
+
+		__entry->nr_migrated = nr_all - nr_failed;
 		__entry->nr_failed = nr_failed;
 	),
 
diff -puN mm/compaction.c~mm-compaction-do-not-count-migratepages-when-unnecessary mm/compaction.c
--- a/mm/compaction.c~mm-compaction-do-not-count-migratepages-when-unnecessary
+++ a/mm/compaction.c
@@ -819,22 +819,6 @@ static void compaction_free(struct page
 	cc->nr_freepages++;
 }
 
-/*
- * We cannot control nr_migratepages fully when migration is running as
- * migrate_pages() has no knowledge of of compact_control.  When migration is
- * complete, we count the number of pages on the list by hand.
- */
-static void update_nr_listpages(struct compact_control *cc)
-{
-	int nr_migratepages = 0;
-	struct page *page;
-
-	list_for_each_entry(page, &cc->migratepages, lru)
-		nr_migratepages++;
-
-	cc->nr_migratepages = nr_migratepages;
-}
-
 /* possible outcome of isolate_migratepages */
 typedef enum {
 	ISOLATE_ABORT,		/* Abort compaction now */
@@ -1029,7 +1013,6 @@ static int compact_zone(struct zone *zon
 	migrate_prep_local();
 
 	while ((ret = compact_finished(zone, cc)) == COMPACT_CONTINUE) {
-		unsigned long nr_migrate, nr_remaining;
 		int err;
 
 		switch (isolate_migratepages(zone, cc)) {
@@ -1044,20 +1027,20 @@ static int compact_zone(struct zone *zon
 			;
 		}
 
-		nr_migrate = cc->nr_migratepages;
+		if (!cc->nr_migratepages)
+			continue;
+
 		err = migrate_pages(&cc->migratepages, compaction_alloc,
 				compaction_free, (unsigned long)cc, cc->mode,
 				MR_COMPACTION);
-		update_nr_listpages(cc);
-		nr_remaining = cc->nr_migratepages;
 
-		trace_mm_compaction_migratepages(nr_migrate - nr_remaining,
-						nr_remaining);
+		trace_mm_compaction_migratepages(cc->nr_migratepages, err,
+							&cc->migratepages);
 
-		/* Release isolated pages not migrated */
+		/* All pages were either migrated or will be released */
+		cc->nr_migratepages = 0;
 		if (err) {
 			putback_movable_pages(&cc->migratepages);
-			cc->nr_migratepages = 0;
 			/*
 			 * migrate_pages() may return -ENOMEM when scanners meet
 			 * and we want compact_finished() to detect it
_

Patches currently in -mm which might be from vbabka@suse.cz are

origin.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch
mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages.patch
mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages-fix.patch
mm-compaction-clean-up-unused-code-lines.patch
mm-compaction-cleanup-isolate_freepages.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
mm-compaction-cleanup-isolate_freepages-fix-2.patch
mm-migration-add-destination-page-freeing-callback.patch
mm-compaction-return-failed-migration-target-pages-back-to-freelist.patch
mm-compaction-add-per-zone-migration-pfn-cache-for-async-compaction.patch
mm-compaction-embed-migration-mode-in-compact_control.patch
mm-thp-avoid-excessive-compaction-latency-during-fault.patch
mm-compaction-terminate-async-compaction-when-rescheduling.patch
mm-compaction-do-not-count-migratepages-when-unnecessary.patch
mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages.patch

