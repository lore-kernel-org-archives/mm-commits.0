From: akpm@linux-foundation.org
Subject: [folded-merged] mm-bail-out-in-shrin_inactive_list-fix.patch
 removed from -mm tree
Date: Thu, 28 Jul 2016 15:10:18 -0700
Message-ID: <579a82ca.n/FsJXkqaOk7mr6B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54839 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbcG1WKT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:10:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mgorman@techsingularity.net, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-bail-out-in-shrin_inactive_list-fix
has been removed from the -mm tree.  Its filename was
     mm-bail-out-in-shrin_inactive_list-fix.patch

This patch was dropped because it was folded into mm-bail-out-in-shrin_inactive_list.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-bail-out-in-shrin_inactive_list-fix

fixes per Mel

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/vmscan.c~mm-bail-out-in-shrin_inactive_list-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-bail-out-in-shrin_inactive_list-fix
+++ a/mm/vmscan.c
@@ -1652,13 +1652,12 @@ static int current_may_throttle(void)
 		bdi_write_congested(current->backing_dev_info);
 }
 
-static inline bool inactive_reclaimable_pages(struct lruvec *lruvec,
-				struct scan_control *sc,
-				enum lru_list lru)
+static bool inactive_reclaimable_pages(struct lruvec *lruvec,
+				struct scan_control *sc, enum lru_list lru)
 {
 	int zid;
 	struct zone *zone;
-	bool file = is_file_lru(lru);
+	int file = is_file_lru(lru);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
 	if (!global_reclaim(sc))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-bail-out-in-shrin_inactive_list.patch
revert-mm-mempool-only-set-__gfp_nomemalloc-if-there-are-free-elements-checkpatch-fixes.patch
mm-optimize-copy_page_to-from_iter_iovec-fix.patch
mm-optimize-copy_page_to-from_iter_iovec-fix-fix.patch

