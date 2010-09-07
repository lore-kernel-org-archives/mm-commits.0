From: akpm@linux-foundation.org
Subject: + memory-hotplug-fix-next-block-calculation-in-is_removable.patch added to -mm tree
Date: Tue, 07 Sep 2010 14:03:33 -0700
Message-ID: <201009072103.o87L3XMV006005@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33555 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751795Ab0IGVEp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Sep 2010 17:04:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, fengguang.wu@intel.com, mel@csn.ul.ie, mhocko@suse.cz, stable@kernel.org


The patch titled
     memory hotplug: fix next block calculation in is_removable
has been added to the -mm tree.  Its filename is
     memory-hotplug-fix-next-block-calculation-in-is_removable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory hotplug: fix next block calculation in is_removable
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

next_active_pageblock() is for finding next _used_ freeblock.  It skips
several blocks when it finds there are a chunk of free pages lager than
pageblock.  But it has 2 bugs.

  1. We have no lock. page_order(page) - pageblock_order can be minus.
  2. pageblocks_stride += is wrong. it should skip page_order(p) of pages.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN mm/memory_hotplug.c~memory-hotplug-fix-next-block-calculation-in-is_removable mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-fix-next-block-calculation-in-is_removable
+++ a/mm/memory_hotplug.c
@@ -584,19 +584,19 @@ static inline int pageblock_free(struct 
 /* Return the start of the next active pageblock after a given page */
 static struct page *next_active_pageblock(struct page *page)
 {
-	int pageblocks_stride;
-
 	/* Ensure the starting page is pageblock-aligned */
 	BUG_ON(page_to_pfn(page) & (pageblock_nr_pages - 1));
 
-	/* Move forward by at least 1 * pageblock_nr_pages */
-	pageblocks_stride = 1;
-
 	/* If the entire pageblock is free, move to the end of free page */
-	if (pageblock_free(page))
-		pageblocks_stride += page_order(page) - pageblock_order;
+	if (pageblock_free(page)) {
+		int order;
+		/* be careful. we don't have locks, page_order can be changed.*/
+		order = page_order(page);
+		if ((order < MAX_ORDER) && (order >= pageblock_order))
+			return page + (1 << order);
+	}
 
-	return page + (pageblocks_stride * pageblock_nr_pages);
+	return page + pageblock_nr_pages;
 }
 
 /* Checks if this range of memory is likely to be hot-removable. */
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

linux-next.patch
memory-hotplug-fix-next-block-calculation-in-is_removable.patch
swap-revert-special-hibernation-allocation.patch
swap-prevent-reuse-during-hibernation.patch
vmstat-update-zone-stat-threshold-when-onlining-a-cpu.patch
mm-page-allocator-update-free-page-counters-after-pages-are-placed-on-the-free-list.patch
mm-page-allocator-update-free-page-counters-after-pages-are-placed-on-the-free-list-fix.patch
mm-page-allocator-drain-per-cpu-lists-after-direct-reclaim-allocation-fails.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
vmscan-kick-flusher-threads-to-clean-pages-when-reclaim-is-encountering-dirty-pages.patch
oom-add-per-mm-oom-disable-count.patch
oom-avoid-killing-a-task-if-a-thread-sharing-its-mm-cannot-be-killed.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
oom-fix-locking-for-oom_adj-and-oom_score_adj.patch
memory-hotplug-fix-notifiers-return-value-check.patch
memory-hotplug-unify-is_removable-and-offline-detection-code.patch

