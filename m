From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-swap-out-anonymous-page-regardless-of-laptop_mode.patch removed from -mm tree
Date: Wed, 09 Jan 2013 15:59:27 -0800
Message-ID: <20130109235927.F1AD2200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:36329 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118Ab3AIX7b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Jan 2013 18:59:31 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt14so146929wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 09 Jan 2013 15:59:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, bfreed@google.com, dan.magenheimer@oracle.com, hannes@cmpxchg.org, hughd@google.com, mgorman@suse.de, riel@redhat.com, semenzato@google.com, sonnyrao@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: swap out anonymous page regardless of laptop_mode
has been removed from the -mm tree.  Its filename was
     mm-swap-out-anonymous-page-regardless-of-laptop_mode.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: swap out anonymous page regardless of laptop_mode

Recently, Luigi reported there are lots of free swap space when OOM
happens.  It's easily reproduced on zram-over-swap, where many instance of
memory hogs are running and laptop_mode is enabled.

Luigi reported there was no problem when he disabled laptop_mode.  The
problem when I investigate problem is following as.

try_to_free_pages disable may_writepage if laptop_mode is enabled. 
shrink_page_list adds lots of anon pages in swap cache by add_to_swap,
which makes pages Dirty and rotate them to head of inactive LRU without
pageout.  If it is repeated, inactive anon LRU is full of Dirty and
SwapCache pages.

In case of that, isolate_lru_pages fails because it try to isolate clean
page due to may_writepage == 0.

may_writepage could be 1 only if total_scanned is higher than
writeback_threshold in do_try_to_free_pages but unfortunately, VM can't
isolate anon pages from inactive anon lru list by above reason and we
already reclaimed all file-backed pages.  So it ends up OOM killing.

This patch makes may_writepage could be set when shrink_inactive_list
encounters SwapCachePage from tail of inactive anon LRU.  What it means
that anon LRU list is short and memory pressure is severe so it would be
better to swap out that pages by sacrificing the power rather than OOM
killing.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: Luigi Semenzato <semenzato@google.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Sonny Rao <sonnyrao@google.com>
Cc: Bryan Freed <bfreed@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-swap-out-anonymous-page-regardless-of-laptop_mode mm/vmscan.c
--- a/mm/vmscan.c~mm-swap-out-anonymous-page-regardless-of-laptop_mode
+++ a/mm/vmscan.c
@@ -1102,7 +1102,7 @@ static unsigned long isolate_lru_pages(u
 		prefetchw_prev_lru_page(page, src, flags);
 
 		VM_BUG_ON(!PageLRU(page));
-
+retry:
 		switch (__isolate_lru_page(page, mode)) {
 		case 0:
 			nr_pages = hpage_nr_pages(page);
@@ -1112,6 +1112,17 @@ static unsigned long isolate_lru_pages(u
 			break;
 
 		case -EBUSY:
+			/*
+			 * If VM encounters PageSwapCache from inactive LRU,
+			 * it means we havd to swap out those pages regardless
+			 * of laptop_mode for preventing OOM kill.
+			 */
+			if ((mode & ISOLATE_CLEAN) && PageSwapCache(page) &&
+				!PageActive(page)) {
+				mode &= ~ISOLATE_CLEAN;
+				sc->may_writepage = 1;
+				goto retry;
+			}
 			/* else it is being freed elsewhere */
 			list_move(&page->lru, src);
 			continue;
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
mm-compaction-fix-echo-1-compact_memory-return-error-issue.patch
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
mm-add-vm-event-counters-for-balloon-pages-compaction.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix.patch

