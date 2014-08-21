From: akpm@linux-foundation.org
Subject: + mm-compaction-skip-rechecks-when-lock-was-already-held.patch
 added to -mm tree
Date: Thu, 21 Aug 2014 15:22:06 -0700
Message-ID: <53f6710e.l/5L1Q62cFeRUqm4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f201.google.com ([209.85.192.201]:35487 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471AbaHUWWH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Aug 2014 18:22:07 -0400
Received: by mail-pd0-f201.google.com with SMTP id g10so2626276pdj.4
        for <mm-commits@vger.kernel.org>; Thu, 21 Aug 2014 15:22:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, cl@linux.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: skip rechecks when lock was already held
has been added to the -mm tree.  Its filename is
     mm-compaction-skip-rechecks-when-lock-was-already-held.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-skip-rechecks-when-lock-was-already-held.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-skip-rechecks-when-lock-was-already-held.patch

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
Subject: mm, compaction: skip rechecks when lock was already held

Compaction scanners try to lock zone locks as late as possible by checking
many page or pageblock properties opportunistically without lock and
skipping them if not unsuitable.  For pages that pass the initial checks,
some properties have to be checked again safely under lock.  However, if
the lock was already held from a previous iteration in the initial checks,
the rechecks are unnecessary.

This patch therefore skips the rechecks when the lock was already held. 
This is now possible to do, since we don't (potentially) drop and
reacquire the lock between the initial checks and the safe rechecks
anymore.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   53 ++++++++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 22 deletions(-)

diff -puN mm/compaction.c~mm-compaction-skip-rechecks-when-lock-was-already-held mm/compaction.c
--- a/mm/compaction.c~mm-compaction-skip-rechecks-when-lock-was-already-held
+++ a/mm/compaction.c
@@ -367,22 +367,30 @@ static unsigned long isolate_freepages_b
 			goto isolate_fail;
 
 		/*
-		 * The zone lock must be held to isolate freepages.
-		 * Unfortunately this is a very coarse lock and can be
-		 * heavily contended if there are parallel allocations
-		 * or parallel compactions. For async compaction do not
-		 * spin on the lock and we acquire the lock as late as
-		 * possible.
+		 * If we already hold the lock, we can skip some rechecking.
+		 * Note that if we hold the lock now, checked_pageblock was
+		 * already set in some previous iteration (or strict is true),
+		 * so it is correct to skip the suitable migration target
+		 * recheck as well.
 		 */
-		if (!locked)
+		if (!locked) {
+			/*
+			 * The zone lock must be held to isolate freepages.
+			 * Unfortunately this is a very coarse lock and can be
+			 * heavily contended if there are parallel allocations
+			 * or parallel compactions. For async compaction do not
+			 * spin on the lock and we acquire the lock as late as
+			 * possible.
+			 */
 			locked = compact_trylock_irqsave(&cc->zone->lock,
 								&flags, cc);
-		if (!locked)
-			break;
+			if (!locked)
+				break;
 
-		/* Recheck this is a buddy page under lock */
-		if (!PageBuddy(page))
-			goto isolate_fail;
+			/* Recheck this is a buddy page under lock */
+			if (!PageBuddy(page))
+				goto isolate_fail;
+		}
 
 		/* Found a free page, break it into order-0 pages */
 		isolated = split_free_page(page);
@@ -647,19 +655,20 @@ isolate_migratepages_block(struct compac
 		    page_count(page) > page_mapcount(page))
 			continue;
 
-		/* If the lock is not held, try to take it */
-		if (!locked)
+		/* If we already hold the lock, we can skip some rechecking */
+		if (!locked) {
 			locked = compact_trylock_irqsave(&zone->lru_lock,
 								&flags, cc);
-		if (!locked)
-			break;
+			if (!locked)
+				break;
 
-		/* Recheck PageLRU and PageTransHuge under lock */
-		if (!PageLRU(page))
-			continue;
-		if (PageTransHuge(page)) {
-			low_pfn += (1 << compound_order(page)) - 1;
-			continue;
+			/* Recheck PageLRU and PageTransHuge under lock */
+			if (!PageLRU(page))
+				continue;
+			if (PageTransHuge(page)) {
+				low_pfn += (1 << compound_order(page)) - 1;
+				continue;
+			}
 		}
 
 		lruvec = mem_cgroup_page_lruvec(page, zone);
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

