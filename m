From: akpm@linux-foundation.org
Subject: [merged] mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:12:16 -0700
Message-ID: <20121009181217.15FDB1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:42688 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756748Ab2JISMR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:12:17 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so574279yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:12:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aquini@redhat.com, avi@redhat.com, richard@arachsys.com, riel@redhat.com, shli@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: acquire the zone->lru_lock as late as possible
has been removed from the -mm tree.  Its filename was
     mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: compaction: acquire the zone->lru_lock as late as possible

Richard Davies and Shaohua Li have both reported lock contention problems
in compaction on the zone and LRU locks as well as significant amounts of
time being spent in compaction.  This series aims to reduce lock
contention and scanning rates to reduce that CPU usage.  Richard reported
at https://lkml.org/lkml/2012/9/21/91 that this series made a big
different to a problem he reported in August
(http://marc.info/?l=kvm&m=134511507015614&w=2).

Patch 1 defers acquiring the zone->lru_lock as long as possible.

Patch 2 defers acquiring the zone->lock as lock as possible.

Patch 3 reverts Rik's "skip-free" patches as the core concept gets
	reimplemented later and the remaining patches are easier to
	understand if this is reverted first.

Patch 4 adds a pageblock-skip bit to the pageblock flags to cache what
	pageblocks should be skipped by the migrate and free scanners.
	This drastically reduces the amount of scanning compaction has
	to do.

Patch 5 reimplements something similar to Rik's idea except it uses the
	pageblock-skip information to decide where the scanners should
	restart from and does not need to wrap around.

I tested this on 3.6-rc6 + linux-next/akpm. Kernels tested were

akpm-20120920	3.6-rc6 + linux-next/akpm as of Septeber 20th, 2012
lesslock	Patches 1-6
revert		Patches 1-7
cachefail	Patches 1-8
skipuseless	Patches 1-9

Stress high-order allocation tests looked ok.  Success rates are more or
less the same with the full series applied but there is an expectation
that there is less opportunity to race with other allocation requests if
there is less scanning.  The time to complete the tests did not vary that
much and are uninteresting as were the vmstat statistics so I will not
present them here.

Using ftrace I recorded how much scanning was done by compaction and got this

                            3.6.0-rc6     3.6.0-rc6   3.6.0-rc6  3.6.0-rc6 3.6.0-rc6
                            akpm-20120920 lockless  revert-v2r2  cachefail skipuseless

Total   free    scanned         360753976  515414028  565479007   17103281   18916589 
Total   free    isolated          2852429    3597369    4048601     670493     727840 
Total   free    efficiency        0.0079%    0.0070%    0.0072%    0.0392%    0.0385% 
Total   migrate scanned         247728664  822729112 1004645830   17946827   14118903 
Total   migrate isolated          2555324    3245937    3437501     616359     658616 
Total   migrate efficiency        0.0103%    0.0039%    0.0034%    0.0343%    0.0466% 

The efficiency is worthless because of the nature of the test and the
number of failures.  The really interesting point as far as this patch
series is concerned is the number of pages scanned.  Note that reverting
Rik's patches massively increases the number of pages scanned indicating
that those patches really did make a difference to CPU usage.

However, caching what pageblocks should be skipped has a much higher
impact.  With patches 1-8 applied, free page and migrate page scanning are
both reduced by 95% in comparison to the akpm kernel.  If the basic
concept of Rik's patches are implemened on top then scanning then the free
scanner barely changed but migrate scanning was further reduced.  That
said, tests on 3.6-rc5 indicated that the last patch had greater impact
than what was measured here so it is a bit variable.

One way or the other, this series has a large impact on the amount of
scanning compaction does when there is a storm of THP allocations.



This patch:

Compaction's migrate scanner acquires the zone->lru_lock when scanning a
range of pages looking for LRU pages to acquire.  It does this even if
there are no LRU pages in the range.  If multiple processes are compacting
then this can cause severe locking contention.  To make matters worse
commit b2eef8c0 ("mm: compaction: minimise the time IRQs are disabled
while isolating pages for migration") releases the lru_lock every
SWAP_CLUSTER_MAX pages that are scanned.

This patch makes two changes to how the migrate scanner acquires the LRU
lock.  First, it only releases the LRU lock every SWAP_CLUSTER_MAX pages
if the lock is contended.  This reduces the number of times it
unnecessarily disables and re-enables IRQs.  The second is that it defers
acquiring the LRU lock for as long as possible.  If there are no LRU pages
or the only LRU pages are transhuge then the LRU lock will not be acquired
at all which reduces contention on zone->lru_lock.

[minchan@kernel.org: augment comment]
[akpm@linux-foundation.org: tweak comment text]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Richard Davies <richard@arachsys.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Avi Kivity <avi@redhat.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   65 +++++++++++++++++++++++++++++++---------------
 1 file changed, 45 insertions(+), 20 deletions(-)

diff -puN mm/compaction.c~mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible mm/compaction.c
--- a/mm/compaction.c~mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible
+++ a/mm/compaction.c
@@ -50,6 +50,11 @@ static inline bool migrate_async_suitabl
 	return is_migrate_cma(migratetype) || migratetype == MIGRATE_MOVABLE;
 }
 
+static inline bool should_release_lock(spinlock_t *lock)
+{
+	return need_resched() || spin_is_contended(lock);
+}
+
 /*
  * Compaction requires the taking of some coarse locks that are potentially
  * very heavily contended. Check if the process needs to be scheduled or
@@ -62,7 +67,7 @@ static inline bool migrate_async_suitabl
 static bool compact_checklock_irqsave(spinlock_t *lock, unsigned long *flags,
 				      bool locked, struct compact_control *cc)
 {
-	if (need_resched() || spin_is_contended(lock)) {
+	if (should_release_lock(lock)) {
 		if (locked) {
 			spin_unlock_irqrestore(lock, *flags);
 			locked = false;
@@ -327,7 +332,7 @@ isolate_migratepages_range(struct zone *
 	isolate_mode_t mode = 0;
 	struct lruvec *lruvec;
 	unsigned long flags;
-	bool locked;
+	bool locked = false;
 
 	/*
 	 * Ensure that there are not too many pages isolated from the LRU
@@ -347,23 +352,17 @@ isolate_migratepages_range(struct zone *
 
 	/* Time to isolate some pages for migration */
 	cond_resched();
-	spin_lock_irqsave(&zone->lru_lock, flags);
-	locked = true;
 	for (; low_pfn < end_pfn; low_pfn++) {
 		struct page *page;
 
 		/* give a chance to irqs before checking need_resched() */
-		if (!((low_pfn+1) % SWAP_CLUSTER_MAX)) {
-			spin_unlock_irqrestore(&zone->lru_lock, flags);
-			locked = false;
+		if (locked && !((low_pfn+1) % SWAP_CLUSTER_MAX)) {
+			if (should_release_lock(&zone->lru_lock)) {
+				spin_unlock_irqrestore(&zone->lru_lock, flags);
+				locked = false;
+			}
 		}
 
-		/* Check if it is ok to still hold the lock */
-		locked = compact_checklock_irqsave(&zone->lru_lock, &flags,
-								locked, cc);
-		if (!locked || fatal_signal_pending(current))
-			break;
-
 		/*
 		 * migrate_pfn does not necessarily start aligned to a
 		 * pageblock. Ensure that pfn_valid is called when moving
@@ -403,21 +402,40 @@ isolate_migratepages_range(struct zone *
 		pageblock_nr = low_pfn >> pageblock_order;
 		if (!cc->sync && last_pageblock_nr != pageblock_nr &&
 		    !migrate_async_suitable(get_pageblock_migratetype(page))) {
-			low_pfn += pageblock_nr_pages;
-			low_pfn = ALIGN(low_pfn, pageblock_nr_pages) - 1;
-			last_pageblock_nr = pageblock_nr;
-			continue;
+			goto next_pageblock;
 		}
 
+		/* Check may be lockless but that's ok as we recheck later */
 		if (!PageLRU(page))
 			continue;
 
 		/*
-		 * PageLRU is set, and lru_lock excludes isolation,
-		 * splitting and collapsing (collapsing has already
-		 * happened if PageLRU is set).
+		 * PageLRU is set. lru_lock normally excludes isolation
+		 * splitting and collapsing (collapsing has already happened
+		 * if PageLRU is set) but the lock is not necessarily taken
+		 * here and it is wasteful to take it just to check transhuge.
+		 * Check TransHuge without lock and skip the whole pageblock if
+		 * it's either a transhuge or hugetlbfs page, as calling
+		 * compound_order() without preventing THP from splitting the
+		 * page underneath us may return surprising results.
 		 */
 		if (PageTransHuge(page)) {
+			if (!locked)
+				goto next_pageblock;
+			low_pfn += (1 << compound_order(page)) - 1;
+			continue;
+		}
+
+		/* Check if it is ok to still hold the lock */
+		locked = compact_checklock_irqsave(&zone->lru_lock, &flags,
+								locked, cc);
+		if (!locked || fatal_signal_pending(current))
+			break;
+
+		/* Recheck PageLRU and PageTransHuge under lock */
+		if (!PageLRU(page))
+			continue;
+		if (PageTransHuge(page)) {
 			low_pfn += (1 << compound_order(page)) - 1;
 			continue;
 		}
@@ -444,6 +462,13 @@ isolate_migratepages_range(struct zone *
 			++low_pfn;
 			break;
 		}
+
+		continue;
+
+next_pageblock:
+		low_pfn += pageblock_nr_pages;
+		low_pfn = ALIGN(low_pfn, pageblock_nr_pages) - 1;
+		last_pageblock_nr = pageblock_nr;
 	}
 
 	acct_isolated(zone, locked, cc);
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch

