From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-compaction-check-lock-contention-first-before-taking-lock.patch removed from -mm tree
Date: Fri, 21 Sep 2012 14:30:10 -0700
Message-ID: <20120921213011.2F4B11E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:61879 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab2IUVaM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Sep 2012 17:30:12 -0400
Received: by ghbz15 with SMTP id z15so516490ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 21 Sep 2012 14:30:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shli@kernel.org, mgorman@suse.de, minchan@kernel.org, shli@fusionio.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: check lock contention first before taking lock
has been removed from the -mm tree.  Its filename was
     mm-compaction-check-lock-contention-first-before-taking-lock.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Shaohua Li <shli@kernel.org>
Subject: mm: compaction: check lock contention first before taking lock

isolate_migratepages_range will take zone->lru_lock first and check if the
lock is contented, if yes, it will release the lock.  This isn't
efficient.  If the lock is truly contented, a lock/unlock pair will
increase the lock contention.  We'd better check if the lock is contended
first.  compact_trylock_irqsave perfectly meets the requirement.

Signed-off-by: Shaohua Li <shli@fusionio.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/compaction.c~mm-compaction-check-lock-contention-first-before-taking-lock mm/compaction.c
--- a/mm/compaction.c~mm-compaction-check-lock-contention-first-before-taking-lock
+++ a/mm/compaction.c
@@ -349,8 +349,9 @@ isolate_migratepages_range(struct zone *
 
 	/* Time to isolate some pages for migration */
 	cond_resched();
-	spin_lock_irqsave(&zone->lru_lock, flags);
-	locked = true;
+	locked = compact_trylock_irqsave(&zone->lru_lock, &flags, cc);
+	if (!locked)
+		return 0;
 	for (; low_pfn < end_pfn; low_pfn++) {
 		struct page *page;
 
_

Patches currently in -mm which might be from shli@kernel.org are

origin.patch
linux-next.patch
readahead-fault-retry-breaks-mmap-file-read-random-detection.patch
atomic-implement-generic-atomic_dec_if_positive.patch
atomic-implement-generic-atomic_dec_if_positive-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-compaction-move-fatal-signal-check-out-of-compact_checklock_irqsave.patch
mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible.patch
mm-compaction-acquire-the-zone-lock-as-late-as-possible.patch
revert-mm-have-order-0-compaction-start-off-where-it-left.patch
mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated.patch
mm-compaction-restart-compaction-from-near-where-it-left-off.patch

