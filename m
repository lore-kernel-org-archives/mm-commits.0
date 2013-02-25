From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-improve-comment-on-low-page-cache-handling.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:48:26 -0800
Message-ID: <20130225204826.C15BF31C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:47349 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab3BYUs3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:48:29 -0500
Received: by mail-qe0-f74.google.com with SMTP id 1so120515qee.5
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:48:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, satoru.moriya@hds.com, simon.jeons@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: improve comment on low-page cache handling
has been removed from the -mm tree.  Its filename was
     mm-vmscan-improve-comment-on-low-page-cache-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmscan: improve comment on low-page cache handling

Fix comment style and elaborate on why anonymous memory is force-scanned
when file cache runs low.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Satoru Moriya <satoru.moriya@hds.com>
Cc: Simon Jeons <simon.jeons@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-improve-comment-on-low-page-cache-handling mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-improve-comment-on-low-page-cache-handling
+++ a/mm/vmscan.c
@@ -1713,13 +1713,15 @@ static void get_scan_count(struct lruvec
 	file  = get_lru_size(lruvec, LRU_ACTIVE_FILE) +
 		get_lru_size(lruvec, LRU_INACTIVE_FILE);
 
+	/*
+	 * If it's foreseeable that reclaiming the file cache won't be
+	 * enough to get the zone back into a desirable shape, we have
+	 * to swap.  Better start now and leave the - probably heavily
+	 * thrashing - remaining file pages alone.
+	 */
 	if (global_reclaim(sc)) {
-		free  = zone_page_state(zone, NR_FREE_PAGES);
+		free = zone_page_state(zone, NR_FREE_PAGES);
 		if (unlikely(file + free <= high_wmark_pages(zone))) {
-			/*
-			 * If we have very few page cache pages, force-scan
-			 * anon pages.
-			 */
 			fraction[0] = 1;
 			fraction[1] = 0;
 			denominator = 1;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-memmap_init_zone-performance-improvement.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch

