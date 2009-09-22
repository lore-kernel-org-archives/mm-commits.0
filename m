From: akpm@linux-foundation.org
Subject: [merged] vmscan-throttle-direct-reclaim-when-too-many-pages-are-isolated-already.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:38:30 -0700
Message-ID: <200909222038.n8MKcUMC001526@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60331 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752058AbZIVUjG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:39:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: throttle direct reclaim when too many pages are isolated already
has been removed from the -mm tree.  Its filename was
     vmscan-throttle-direct-reclaim-when-too-many-pages-are-isolated-already.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: throttle direct reclaim when too many pages are isolated already
From: Rik van Riel <riel@redhat.com>

When way too many processes go into direct reclaim, it is possible for all
of the pages to be taken off the LRU.  One result of this is that the next
process in the page reclaim code thinks there are no reclaimable pages
left and triggers an out of memory kill.

One solution to this problem is to never let so many processes into the
page reclaim path that the entire LRU is emptied.  Limiting the system to
only having half of each inactive list isolated for reclaim should be
safe.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff -puN mm/vmscan.c~vmscan-throttle-direct-reclaim-when-too-many-pages-are-isolated-already mm/vmscan.c
--- a/mm/vmscan.c~vmscan-throttle-direct-reclaim-when-too-many-pages-are-isolated-already
+++ a/mm/vmscan.c
@@ -1034,6 +1034,31 @@ int isolate_lru_page(struct page *page)
 }
 
 /*
+ * Are there way too many processes in the direct reclaim path already?
+ */
+static int too_many_isolated(struct zone *zone, int file,
+		struct scan_control *sc)
+{
+	unsigned long inactive, isolated;
+
+	if (current_is_kswapd())
+		return 0;
+
+	if (!scanning_global_lru(sc))
+		return 0;
+
+	if (file) {
+		inactive = zone_page_state(zone, NR_INACTIVE_FILE);
+		isolated = zone_page_state(zone, NR_ISOLATED_FILE);
+	} else {
+		inactive = zone_page_state(zone, NR_INACTIVE_ANON);
+		isolated = zone_page_state(zone, NR_ISOLATED_ANON);
+	}
+
+	return isolated > inactive;
+}
+
+/*
  * shrink_inactive_list() is a helper for shrink_zone().  It returns the number
  * of reclaimed pages
  */
@@ -1048,6 +1073,14 @@ static unsigned long shrink_inactive_lis
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 	int lumpy_reclaim = 0;
 
+	while (unlikely(too_many_isolated(zone, file, sc))) {
+		congestion_wait(WRITE, HZ/10);
+
+		/* We are about to die and free our memory. Return now. */
+		if (fatal_signal_pending(current))
+			return SWAP_CLUSTER_MAX;
+	}
+
 	/*
 	 * If we need a large contiguous chunk of memory, or have
 	 * trouble getting a small set of contiguous pages, we
_

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
linux-next.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch

