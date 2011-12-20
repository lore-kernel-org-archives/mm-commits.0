From: akpm@linux-foundation.org
Subject: + mm-vmscanc-consider-swap-space-when-deciding-whether-to-continue-reclaim.patch added to -mm tree
Date: Tue, 20 Dec 2011 14:25:57 -0800
Message-ID: <20111220222558.3E0C520004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:50519 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab1LTW0D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Dec 2011 17:26:03 -0500
Received: by eekc1 with SMTP id c1so220742eek.1
        for <mm-commits@vger.kernel.org>; Tue, 20 Dec 2011 14:25:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan@kernel.org, aarcange@redhat.com, jweiner@redhat.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, riel@redhat.com


The patch titled
     Subject: mm/vmscan.c: consider swap space when deciding whether to continue reclaim
has been added to the -mm tree.  Its filename is
     mm-vmscanc-consider-swap-space-when-deciding-whether-to-continue-reclaim.patch

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
From: Minchan Kim <minchan@kernel.org>
Subject: mm/vmscan.c: consider swap space when deciding whether to continue reclaim

It's pointless to continue reclaiming when we have no swap space and lots
of anon pages in the inactive list.

Without this patch, it is possible when swap is disabled to continue
trying to reclaim when there are only anonymous pages in the system even
though that will not make any progress.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~mm-vmscanc-consider-swap-space-when-deciding-whether-to-continue-reclaim mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscanc-consider-swap-space-when-deciding-whether-to-continue-reclaim
+++ a/mm/vmscan.c
@@ -2000,8 +2000,9 @@ static inline bool should_continue_recla
 	 * inactive lists are large enough, continue reclaiming
 	 */
 	pages_for_compaction = (2UL << sc->order);
-	inactive_lru_pages = zone_nr_lru_pages(zone, sc, LRU_INACTIVE_ANON) +
-				zone_nr_lru_pages(zone, sc, LRU_INACTIVE_FILE);
+	inactive_lru_pages = zone_nr_lru_pages(zone, sc, LRU_INACTIVE_FILE);
+	if (nr_swap_pages > 0)
+		inactive_lru_pages += zone_nr_lru_pages(zone, sc, LRU_INACTIVE_ANON);
 	if (sc->nr_reclaimed < pages_for_compaction &&
 			inactive_lru_pages > pages_for_compaction)
 		return true;
_
Subject: Subject: mm/vmscan.c: consider swap space when deciding whether to continue reclaim

Patches currently in -mm which might be from minchan@kernel.org are

mm-vmscanc-consider-swap-space-when-deciding-whether-to-continue-reclaim.patch
vmscan-trace-add-file-info-to-trace_mm_vmscan_lru_isolate.patch
mm-compaction-make-isolate_lru_page-filter-aware-again.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix.patch

