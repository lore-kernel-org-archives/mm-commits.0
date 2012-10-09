From: akpm@linux-foundation.org
Subject: [merged] mm-compaction-move-fatal-signal-check-out-of-compact_checklock_irqsave.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:12:08 -0700
Message-ID: <20121009181209.2F03E200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:57651 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756748Ab2JISML (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:12:11 -0400
Received: by mail-fa0-f74.google.com with SMTP id t1so360479fae.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:12:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aarcange@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, minchan@kernel.org, riel@redhat.com, shli@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: move fatal signal check out of compact_checklock_irqsave
has been removed from the -mm tree.  Its filename was
     mm-compaction-move-fatal-signal-check-out-of-compact_checklock_irqsave.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: compaction: move fatal signal check out of compact_checklock_irqsave

c67fe3752 ("mm: compaction: Abort async compaction if locks are contended
or taking too long") addressed a lock contention problem in compaction by
introducing compact_checklock_irqsave() that effecively aborting async
compaction in the event of compaction.

To preserve existing behaviour it also moved a fatal_signal_pending()
check into compact_checklock_irqsave() but that is very misleading.  It
"hides" the check within a locking function but has nothing to do with
locking as such.  It just happens to work in a desirable fashion.

This patch moves the fatal_signal_pending() check to
isolate_migratepages_range() where it belongs.  Arguably the same check
should also happen when isolating pages for freeing but it's overkill.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/compaction.c~mm-compaction-move-fatal-signal-check-out-of-compact_checklock_irqsave mm/compaction.c
--- a/mm/compaction.c~mm-compaction-move-fatal-signal-check-out-of-compact_checklock_irqsave
+++ a/mm/compaction.c
@@ -75,8 +75,6 @@ static bool compact_checklock_irqsave(sp
 		}
 
 		cond_resched();
-		if (fatal_signal_pending(current))
-			return false;
 	}
 
 	if (!locked)
@@ -363,7 +361,7 @@ isolate_migratepages_range(struct zone *
 		/* Check if it is ok to still hold the lock */
 		locked = compact_checklock_irqsave(&zone->lru_lock, &flags,
 								locked, cc);
-		if (!locked)
+		if (!locked || fatal_signal_pending(current))
 			break;
 
 		/*
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch

