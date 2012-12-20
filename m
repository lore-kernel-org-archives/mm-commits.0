From: akpm@linux-foundation.org
Subject: + mm-vmscan-improve-comment-on-low-page-cache-handling.patch added to -mm tree
Date: Wed, 19 Dec 2012 16:11:21 -0800
Message-ID: <20121220001122.8381620004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f201.google.com ([74.125.82.201]:38216 "EHLO
	mail-we0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab2LTALZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 19:11:25 -0500
Received: by mail-we0-f201.google.com with SMTP id t11so140363wey.4
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 16:11:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, hughd@google.com, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, satoru.moriya@hds.com, simon.jeons@gmail.com


The patch titled
     Subject: mm: vmscan: improve comment on low-page cache handling
has been added to the -mm tree.  Its filename is
     mm-vmscan-improve-comment-on-low-page-cache-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-fix-calculation-of-dirtyable-memory.patch
mm-memcg-only-evict-file-pages-when-we-have-plenty.patch
mm-vmscan-save-work-scanning-almost-empty-lru-lists.patch
mm-vmscan-clarify-how-swappiness-highest-priority-memcg-interact.patch
mm-vmscan-improve-comment-on-low-page-cache-handling.patch
mm-vmscan-clean-up-get_scan_count.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-reduce-rmap-overhead-for-ex-ksm-page-copies-created-on-swap-faults.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mm-memmap_init_zone-performance-improvement.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch

