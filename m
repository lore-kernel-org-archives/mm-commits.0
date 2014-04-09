From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-do-not-swap-anon-pages-just-because-freefile-is-low.patch removed from -mm tree
Date: Wed, 09 Apr 2014 10:55:29 -0700
Message-ID: <53458991.jtKAqAoVkr3vHCKc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36931 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933291AbaDIRza (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Apr 2014 13:55:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, suleiman@google.com, stable@kernel.org, riel@redhat.com, mgorman@suse.de, hughd@google.com, aquini@redhat.com, hannes@cmpxchg.org

Subject: [merged] mm-vmscan-do-not-swap-anon-pages-just-because-freefile-is-low.patch removed from -mm tree
To: hannes@cmpxchg.org,aquini@redhat.com,hughd@google.com,mgorman@suse.de,riel@redhat.com,stable@kernel.org,suleiman@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 09 Apr 2014 10:55:29 -0700


The patch titled
     Subject: mm: vmscan: do not swap anon pages just because free+file is low
has been removed from the -mm tree.  Its filename was
     mm-vmscan-do-not-swap-anon-pages-just-because-freefile-is-low.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmscan: do not swap anon pages just because free+file is low

Page reclaim force-scans / swaps anonymous pages when file cache drops
below the high watermark of a zone in order to prevent what little cache
remains from thrashing.

However, on bigger machines the high watermark value can be quite large
and when the workload is dominated by a static anonymous/shmem set, the
file set might just be a small window of used-once cache.  In such
situations, the VM starts swapping heavily when instead it should be
recycling the no longer used cache.

This is a longer-standing problem, but it's more likely to trigger after
81c0a2bb515f ("mm: page_alloc: fair zone allocator policy") because file
pages can no longer accumulate in a single zone and are dispersed into
smaller fractions among the available zones.

To resolve this, do not force scan anon when file pages are low but
instead rely on the scan/rotation ratios to make the right prediction.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Rafael Aquini <aquini@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: <stable@kernel.org>		[3.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-do-not-swap-anon-pages-just-because-freefile-is-low mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-do-not-swap-anon-pages-just-because-freefile-is-low
+++ a/mm/vmscan.c
@@ -1862,7 +1862,7 @@ static void get_scan_count(struct lruvec
 	struct zone *zone = lruvec_zone(lruvec);
 	unsigned long anon_prio, file_prio;
 	enum scan_balance scan_balance;
-	unsigned long anon, file, free;
+	unsigned long anon, file;
 	bool force_scan = false;
 	unsigned long ap, fp;
 	enum lru_list lru;
@@ -1916,20 +1916,6 @@ static void get_scan_count(struct lruvec
 		get_lru_size(lruvec, LRU_INACTIVE_FILE);
 
 	/*
-	 * If it's foreseeable that reclaiming the file cache won't be
-	 * enough to get the zone back into a desirable shape, we have
-	 * to swap.  Better start now and leave the - probably heavily
-	 * thrashing - remaining file pages alone.
-	 */
-	if (global_reclaim(sc)) {
-		free = zone_page_state(zone, NR_FREE_PAGES);
-		if (unlikely(file + free <= high_wmark_pages(zone))) {
-			scan_balance = SCAN_ANON;
-			goto out;
-		}
-	}
