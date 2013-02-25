From: akpm@linux-foundation.org
Subject: [merged] mm-use-up-free-swap-space-before-reaching-oom-kill.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:55:00 -0800
Message-ID: <20130225205501.0D1F931C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:53419 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932149Ab3BYUzD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:55:03 -0500
Received: by mail-ye0-f201.google.com with SMTP id m12so142397yen.2
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:55:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, hannes@cmpxchg.org, hughd@google.com, riel@redhat.com, semenzato@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use up free swap space before reaching OOM kill
has been removed from the -mm tree.  Its filename was
     mm-use-up-free-swap-space-before-reaching-oom-kill.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: use up free swap space before reaching OOM kill

Recently, Luigi reported there are lots of free swap space when OOM
happens.  It's easily reproduced on zram-over-swap, where many instance of
memory hogs are running and laptop_mode is enabled.  He said there was no
problem when he disabled laptop_mode.  The problem when I investigate
problem is following as.

Assumption for easy explanation: There are no page cache page in system
because they all are already reclaimed.

1. try_to_free_pages disable may_writepage when laptop_mode is enabled.
2. shrink_inactive_list isolates victim pages from inactive anon lru list.
3. shrink_page_list adds them to swapcache via add_to_swap but it doesn't
   pageout because sc->may_writepage is 0 so the page is rotated back into
   inactive anon lru list. The add_to_swap made the page Dirty by SetPageDirty.
4. 3 couldn't reclaim any pages so do_try_to_free_pages increase priority and
   retry reclaim with higher priority.
5. shrink_inactlive_list try to isolate victim pages from inactive anon lru list
   but got failed because it try to isolate pages with ISOLATE_CLEAN mode but
   inactive anon lru list is full of dirty pages by 3 so it just returns
   without  any reclaim progress.
6. do_try_to_free_pages doesn't set may_writepage due to zero total_scanned.
   Because sc->nr_scanned is increased by shrink_page_list but we don't call
   shrink_page_list in 5 due to short of isolated pages.

Above loop is continued until OOM happens.

The problem didn't happen before [1] was merged because old logic's
isolatation in shrink_inactive_list was successful and tried to call
shrink_page_list to pageout them but it still ends up failed to page out
by may_writepage.  But important point is that sc->nr_scanned was
increased although we couldn't swap out them so do_try_to_free_pages could
set may_writepages.

Since f80c067 ("mm: zone_reclaim: make isolate_lru_page() filter-aware")
was introduced, it's not a good idea any more to depends on only the
number of scanned pages for setting may_writepage.  So this patch adds new
trigger point of setting may_writepage as below DEF_PRIOIRTY - 2 which is
used to show the significant memory pressure in VM so it's good fit for
our purpose which would be better to lose power saving or clickety rather
than OOM killing.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: Luigi Semenzato <semenzato@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff -puN mm/vmscan.c~mm-use-up-free-swap-space-before-reaching-oom-kill mm/vmscan.c
--- a/mm/vmscan.c~mm-use-up-free-swap-space-before-reaching-oom-kill
+++ a/mm/vmscan.c
@@ -2195,6 +2195,13 @@ static unsigned long do_try_to_free_page
 			goto out;
 
 		/*
+		 * If we're getting trouble reclaiming, start doing
+		 * writepage even in laptop mode.
+		 */
+		if (sc->priority < DEF_PRIORITY - 2)
+			sc->may_writepage = 1;
+
+		/*
 		 * Try to write back as many pages as we just scanned.  This
 		 * tends to cause slow streaming writers to write data to the
 		 * disk smoothly, at the dirtying rate, which is nice.   But
@@ -2765,12 +2772,10 @@ loop_again:
 			}
 
 			/*
-			 * If we've done a decent amount of scanning and
-			 * the reclaim ratio is low, start doing writepage
-			 * even in laptop mode
+			 * If we're getting trouble reclaiming, start doing
+			 * writepage even in laptop mode.
 			 */
-			if (total_scanned > SWAP_CLUSTER_MAX * 2 &&
-			    total_scanned > sc.nr_reclaimed + sc.nr_reclaimed / 2)
+			if (sc.priority < DEF_PRIORITY - 2)
 				sc.may_writepage = 1;
 
 			if (zone->all_unreclaimable) {
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
mm-add-vm-event-counters-for-balloon-pages-compaction.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch
debugging-keep-track-of-page-owners-fix-2.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix.patch

