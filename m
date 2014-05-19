From: akpm@linux-foundation.org
Subject: +
 mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention.patch added to -mm tree
Date: Mon, 19 May 2014 16:37:48 -0700
Message-ID: <537a95cc.PQi5ieOr2r7LBUho%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50631 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbaESXht (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 May 2014 19:37:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, n-horiguchi@ah.jp.nec.com, minchan@kernel.org, mina86@mina86.com, mgorman@suse.de, iamjoonsoo.kim@lge.com, cl@linux.com, b.zolnierkie@samsung.com, vbabka@suse.cz

Subject: + mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention.patch added to -mm tree
To: vbabka@suse.cz,b.zolnierkie@samsung.com,cl@linux.com,iamjoonsoo.kim@lge.com,mgorman@suse.de,mina86@mina86.com,minchan@kernel.org,n-horiguchi@ah.jp.nec.com,riel@redhat.com
From: akpm@linux-foundation.org
Date: Mon, 19 May 2014 16:37:48 -0700


The patch titled
     Subject: mm, compaction: properly signal and act upon lock and need_sched() contention
has been added to the -mm tree.  Its filename is
     mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention.patch

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
Subject: mm, compaction: properly signal and act upon lock and need_sched() contention

Compaction uses compact_checklock_irqsave() to periodically check for lock
contention and need_resched() to either abort async compaction, or to free
the lock, schedule and retake the lock.  When aborting, cc->contended is
set to signal the contended state to the caller.  Two problems have been
identified in this mechanism.

First, compaction also calls directly cond_resched() in both scanners when
no lock is yet taken.  This call either does not abort async compaction,
or sets cc->contended appropriately.  This patch introduces a new
compact_should_abort() function to achieve both.  In isolate_freepages(),
the check frequency is reduced to once per SWAP_CLUSTER_MAX pageblocks to
match what the migration scanner does in the preliminary page checks.  In
case a pageblock is found suitable for calling isolate_freepages_block(),
the checks within there are done at higher frequency.

Second, isolate_freepages() does not check if isolate_freepages_block()
aborted due to contention, and advances to the next pageblock.  This
violates the principle of aborting on contention, and might result in
pageblocks not being scanned completely, since the scanning cursor is
advanced.  This patch makes isolate_freepages_block() check the
cc->contended flag and abort.

In case isolate_freepages() has already isolated some pages before
aborting due to contention, page migration will proceed, which is OK since
we do not want to waste the work that has been done, and page migration
has own checks for contention.  However, we do not want another isolation
attempt by either of the scanners, so cc->contended flag check is added
also to compaction_alloc() and compact_finished() to make sure compaction
is aborted right after the migration.

Reported-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   54 +++++++++++++++++++++++++++++++++++++---------
 mm/internal.h   |    5 +++-
 2 files changed, 48 insertions(+), 11 deletions(-)

diff -puN mm/compaction.c~mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention mm/compaction.c
--- a/mm/compaction.c~mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention
+++ a/mm/compaction.c
@@ -222,6 +222,30 @@ static bool compact_checklock_irqsave(sp
 	return true;
 }
 
+/*
+ * Aside from avoiding lock contention, compaction also periodically checks
+ * need_resched() and either schedules in sync compaction, or aborts async
+ * compaction. This is similar to compact_checklock_irqsave() does, but used
+ * where no lock is concerned.
+ *
+ * Returns false when no scheduling was needed, or sync compaction scheduled.
+ * Returns true when async compaction should abort.
+ */
+static inline bool compact_should_abort(struct compact_control *cc)
+{
+	/* async compaction aborts if contended */
+	if (need_resched()) {
+		if (cc->mode == MIGRATE_ASYNC) {
+			cc->contended = true;
+			return false;
+		}
+
+		cond_resched();
+	}
+
+	return true;
+}
+
 /* Returns true if the page is within a block suitable for migration to */
 static bool suitable_migration_target(struct page *page)
 {
@@ -491,11 +515,8 @@ isolate_migratepages_range(struct zone *
 			return 0;
 	}
 
-	if (cond_resched()) {
-		/* Async terminates prematurely on need_resched() */
-		if (cc->mode == MIGRATE_ASYNC)
-			return 0;
-	}
+	if (compact_should_abort(cc))
+		return 0;
 
 	/* Time to isolate some pages for migration */
 	for (; low_pfn < end_pfn; low_pfn++) {
@@ -717,9 +738,11 @@ static void isolate_freepages(struct zon
 		/*
 		 * This can iterate a massively long zone without finding any
 		 * suitable migration targets, so periodically check if we need
-		 * to schedule.
+		 * to schedule, or even abort async compaction.
 		 */
-		cond_resched();
+		if (!(block_start_pfn % (SWAP_CLUSTER_MAX * pageblock_nr_pages))
+						&& compact_should_abort(cc))
+			break;
 
 		if (!pfn_valid(block_start_pfn))
 			continue;
@@ -757,6 +780,13 @@ static void isolate_freepages(struct zon
 		 */
 		if (isolated)
 			cc->finished_update_free = true;
+
+		/*
+		 * isolate_freepages_block() might have aborted due to async
+		 * compaction being contended
+		 */
+		if (cc->contended)
+			break;
 	}
 
 	/* split_free_page does not map the pages */
@@ -783,9 +813,13 @@ static struct page *compaction_alloc(str
 	struct compact_control *cc = (struct compact_control *)data;
 	struct page *freepage;
 
-	/* Isolate free pages if necessary */
+	/*
+	 * Isolate free pages if necessary, and if we are not aborting due to
+	 * contention.
+	 */
 	if (list_empty(&cc->freepages)) {
-		isolate_freepages(cc->zone, cc);
+		if (!cc->contended)
+			isolate_freepages(cc->zone, cc);
 
 		if (list_empty(&cc->freepages))
 			return NULL;
@@ -855,7 +889,7 @@ static int compact_finished(struct zone
 	unsigned int order;
 	unsigned long watermark;
 
-	if (fatal_signal_pending(current))
+	if (cc->contended || fatal_signal_pending(current))
 		return COMPACT_PARTIAL;
 
 	/* Compaction run completes if the migrate and free scanner meet */
diff -puN mm/internal.h~mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention mm/internal.h
--- a/mm/internal.h~mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention
+++ a/mm/internal.h
@@ -144,7 +144,10 @@ struct compact_control {
 	int order;			/* order a direct compactor needs */
 	int migratetype;		/* MOVABLE, RECLAIMABLE etc */
 	struct zone *zone;
-	bool contended;			/* True if a lock was contended */
+	bool contended;			/* True if a lock was contended, or
+					 * need_resched() true during async
+					 * compaction
+					 */
 };
 
 unsigned long
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch
mm-compaction-clean-up-unused-code-lines.patch
mm-compaction-cleanup-isolate_freepages.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
mm-compaction-cleanup-isolate_freepages-fix-2.patch
mm-migration-add-destination-page-freeing-callback.patch
mm-compaction-return-failed-migration-target-pages-back-to-freelist.patch
mm-compaction-add-per-zone-migration-pfn-cache-for-async-compaction.patch
mm-compaction-embed-migration-mode-in-compact_control.patch
mm-compaction-embed-migration-mode-in-compact_control-fix.patch
mm-thp-avoid-excessive-compaction-latency-during-fault.patch
mm-thp-avoid-excessive-compaction-latency-during-fault-fix.patch
mm-compaction-terminate-async-compaction-when-rescheduling.patch
mm-compaction-do-not-count-migratepages-when-unnecessary.patch
mm-compaction-do-not-count-migratepages-when-unnecessary-fix.patch
mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages.patch
mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages-fix.patch
jump_label-expose-the-reference-count.patch
mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets.patch
mm-page_alloc-only-check-the-zone-id-check-if-pages-are-buddies.patch
mm-page_alloc-only-check-the-alloc-flags-and-gfp_mask-for-dirty-once.patch
mm-page_alloc-take-the-alloc_no_watermark-check-out-of-the-fast-path.patch
mm-page_alloc-use-word-based-accesses-for-get-set-pageblock-bitmaps.patch
mm-page_alloc-reduce-number-of-times-page_to_pfn-is-called.patch
mm-page_alloc-lookup-pageblock-migratetype-with-irqs-enabled-during-free.patch
mm-page_alloc-use-unsigned-int-for-order-in-more-places.patch
mm-page_alloc-convert-hot-cold-parameter-and-immediate-callers-to-bool.patch
mm-shmem-avoid-atomic-operation-during-shmem_getpage_gfp.patch
mm-do-not-use-atomic-operations-when-releasing-pages.patch
mm-do-not-use-unnecessary-atomic-operations-when-adding-pages-to-the-lru.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix.patch
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible.patch
mm-page_alloc-calculate-classzone_idx-once-from-the-zonelist-ref.patch
mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention.patch
mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention-fix.patch

