From: akpm@linux-foundation.org
Subject: - more-aggressively-use-lumpy-reclaim.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:32:45 -0700
Message-ID: <200810202032.m9KKWjQB010477@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752954AbYJTUdh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:33:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     more aggressively use lumpy reclaim
has been removed from the -mm tree.  Its filename was
     more-aggressively-use-lumpy-reclaim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: more aggressively use lumpy reclaim
From: Rik van Riel <riel@redhat.com>

During an AIM7 run on a 16GB system, fork started failing around 32000
threads, despite the system having plenty of free swap and 15GB of
pageable memory.  This was on x86-64, so 8k stacks.

If a higher order allocation fails, we can either:
- keep evicting pages off the end of the LRUs and hope that
  we eventually create a contiguous region; this is somewhat
  unlikely if the system is under enough stress by new
  allocations
- after trying normal eviction for a bit, use lumpy reclaim

This patch switches the system to lumpy reclaim if the VM is having
trouble freeing enough pages, using the same threshold for detection as
used by pageout congestion wait.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff -puN mm/vmscan.c~more-aggressively-use-lumpy-reclaim mm/vmscan.c
--- a/mm/vmscan.c~more-aggressively-use-lumpy-reclaim
+++ a/mm/vmscan.c
@@ -909,7 +909,8 @@ int isolate_lru_page(struct page *page)
  * of reclaimed pages
  */
 static unsigned long shrink_inactive_list(unsigned long max_scan,
-			struct zone *zone, struct scan_control *sc, int file)
+			struct zone *zone, struct scan_control *sc,
+			int priority, int file)
 {
 	LIST_HEAD(page_list);
 	struct pagevec pvec;
@@ -927,8 +928,19 @@ static unsigned long shrink_inactive_lis
 		unsigned long nr_freed;
 		unsigned long nr_active;
 		unsigned int count[NR_LRU_LISTS] = { 0, };
-		int mode = (sc->order > PAGE_ALLOC_COSTLY_ORDER) ?
-					ISOLATE_BOTH : ISOLATE_INACTIVE;
+		int mode = ISOLATE_INACTIVE;
+
+		/*
+		 * If we need a large contiguous chunk of memory, or have
+		 * trouble getting a small set of contiguous pages, we
+		 * will reclaim both active and inactive pages.
+		 *
+		 * We use the same threshold as pageout congestion_wait below.
+		 */
+		if (sc->order > PAGE_ALLOC_COSTLY_ORDER)
+			mode = ISOLATE_BOTH;
+		else if (sc->order && priority < DEF_PRIORITY - 2)
+			mode = ISOLATE_BOTH;
 
 		nr_taken = sc->isolate_pages(sc->swap_cluster_max,
 			     &page_list, &nr_scan, sc->order, mode,
@@ -1172,7 +1184,7 @@ static unsigned long shrink_list(enum lr
 		shrink_active_list(nr_to_scan, zone, sc, priority, file);
 		return 0;
 	}
-	return shrink_inactive_list(nr_to_scan, zone, sc, file);
+	return shrink_inactive_list(nr_to_scan, zone, sc, priority, file);
 }
 
 /*
_

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
linux-next.patch

