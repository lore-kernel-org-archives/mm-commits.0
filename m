From: akpm@linux-foundation.org
Subject: + mm-remove-unused-pgdat-inactive_ratio.patch added to -mm tree
Date: Tue, 03 Oct 2017 14:38:21 -0700
Message-ID: <59d4034d.7L7eHDhMRv9hlhgi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52490 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750841AbdJCViW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 17:38:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove unused pgdat->inactive_ratio
has been added to the -mm tree.  Its filename is
     mm-remove-unused-pgdat-inactive_ratio.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-unused-pgdat-inactive_ratio.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-unused-pgdat-inactive_ratio.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -711,12 +711,6 @@ typedef struct pglist_data {
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
@@ -2081,7 +2081,7 @@ static void shrink_active_list(unsigned
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
@@ -1682,11 +1682,9 @@ static void zoneinfo_show_print(struct s
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

Patches currently in -mm which might be from aryabinin@virtuozzo.com are

mm-mempolicy-fix-numa_interleave_hit-counter.patch
mm-remove-unused-pgdat-inactive_ratio.patch
kcov-remove-pointless-current-=-null-check.patch

