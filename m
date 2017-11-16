From: akpm@linux-foundation.org
Subject: [patch 049/131] mm: remove unused pgdat->inactive_ratio
Date: Wed, 15 Nov 2017 17:34:15 -0800
Message-ID: <20171116013415.BORBHJ3g9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39092 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753159AbdKPBeQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:34:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aryabinin@virtuozzo.com, mm-commits@vger.kernel.org, riel@redhat.com, torvalds@linux-foundation.org

From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: mm: remove unused pgdat->inactive_ratio

Since 59dc76b0d4df ("mm: vmscan: reduce size of inactive file list")
'pgdat->inactive_ratio' is not used, except for printing
"node_inactive_ratio: 0" in /proc/zoneinfo output.

Remove it.

Link: http://lkml.kernel.org/r/20171003152611.27483-1-aryabinin@virtuozzo.com
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    6 ------
 mm/vmscan.c            |    2 +-
 mm/vmstat.c            |    6 ++----
 3 files changed, 3 insertions(+), 11 deletions(-)

diff -puN include/linux/mmzone.h~mm-remove-unused-pgdat-inactive_ratio include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-remove-unused-pgdat-inactive_ratio
+++ a/include/linux/mmzone.h
@@ -712,12 +712,6 @@ typedef struct pglist_data {
 	/* Fields commonly accessed by the page reclaim scanner */
 	struct lruvec		lruvec;
 
-	/*
-	 * The target ratio of ACTIVE_ANON to INACTIVE_ANON pages on
-	 * this node's LRU.  Maintained by the pageout code.
-	 */
-	unsigned int inactive_ratio;
-
 	unsigned long		flags;
 
 	ZONE_PADDING(_pad2_)
diff -puN mm/vmscan.c~mm-remove-unused-pgdat-inactive_ratio mm/vmscan.c
--- a/mm/vmscan.c~mm-remove-unused-pgdat-inactive_ratio
+++ a/mm/vmscan.c
@@ -2082,7 +2082,7 @@ static void shrink_active_list(unsigned
  * If that fails and refaulting is observed, the inactive list grows.
  *
  * The inactive_ratio is the target ratio of ACTIVE to INACTIVE pages
- * on this LRU, maintained by the pageout code. A zone->inactive_ratio
+ * on this LRU, maintained by the pageout code. An inactive_ratio
  * of 3 means 3:1 or 25% of the pages are kept on the inactive list.
  *
  * total     target    max
diff -puN mm/vmstat.c~mm-remove-unused-pgdat-inactive_ratio mm/vmstat.c
--- a/mm/vmstat.c~mm-remove-unused-pgdat-inactive_ratio
+++ a/mm/vmstat.c
@@ -1564,11 +1564,9 @@ static void zoneinfo_show_print(struct s
 	}
 	seq_printf(m,
 		   "\n  node_unreclaimable:  %u"
-		   "\n  start_pfn:           %lu"
-		   "\n  node_inactive_ratio: %u",
+		   "\n  start_pfn:           %lu",
 		   pgdat->kswapd_failures >= MAX_RECLAIM_RETRIES,
-		   zone->zone_start_pfn,
-		   zone->zone_pgdat->inactive_ratio);
+		   zone->zone_start_pfn);
 	seq_putc(m, '\n');
 }
 
_
