From: akpm@linux-foundation.org
Subject: [withdrawn] mm-forcibly-swapout-when-we-are-out-of-page-cache.patch removed from -mm tree
Date: Thu, 10 Jan 2013 13:56:35 -0800
Message-ID: <20130110215636.B7D4420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f201.google.com ([209.85.212.201]:52355 "EHLO
	mail-wi0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456Ab3AJV4k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Jan 2013 16:56:40 -0500
Received: by mail-wi0-f201.google.com with SMTP id hm2so67481wib.0
        for <mm-commits@vger.kernel.org>; Thu, 10 Jan 2013 13:56:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, bfreed@google.com, dan.magenheimer@oracle.com, hannes@cmpxchg.org, hughd@google.com, mel@csn.ul.ie, riel@redhat.com, semenzato@google.com, sonnyrao@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: forcibly swapout when we are out of page cache
has been removed from the -mm tree.  Its filename was
     mm-forcibly-swapout-when-we-are-out-of-page-cache.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: forcibly swapout when we are out of page cache

If laptop_mode is enable the VM tries to avoid I/O for saving power.  But
if there isn't reclaimable memory without I/O, we should do I/O to prevent
an unnecessary OOM kill, although we sacrifice some power.

One example is when we are out of page cache.  Remaining memory is only
anonymous pages, for swapping out, we needs may_writepage = 1.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: Luigi Semenzato <semenzato@google.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Sonny Rao <sonnyrao@google.com>
Cc: Bryan Freed <bfreed@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/vmscan.c~mm-forcibly-swapout-when-we-are-out-of-page-cache mm/vmscan.c
--- a/mm/vmscan.c~mm-forcibly-swapout-when-we-are-out-of-page-cache
+++ a/mm/vmscan.c
@@ -1728,6 +1728,12 @@ static void get_scan_count(struct lruvec
 		free = zone_page_state(zone, NR_FREE_PAGES);
 		if (unlikely(file + free <= high_wmark_pages(zone))) {
 			scan_balance = SCAN_ANON;
+			/*
+			 * From now on, we have to swap out
+			 * for peventing OOM kill although
+			 * we sacrifice power consumption.
+			 */
+			sc->may_writepage = 1;
 			goto out;
 		}
 	}
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-compaction-fix-echo-1-compact_memory-return-error-issue.patch
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
mm-prevent-addition-of-pages-to-swap-if-may_writepage-is-unset.patch
mm-forcibly-swapout-when-we-are-out-of-page-cache-fix.patch
mm-add-vm-event-counters-for-balloon-pages-compaction.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix.patch

