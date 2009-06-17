From: akpm@linux-foundation.org
Subject: [merged] vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:36:43 -0700
Message-ID: <200906171836.n5HIahic002814@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45477 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757683AbZFQSre (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:47:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, cl@linux-foundation.org, fengguang.wu@intel.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     vmscan: count the number of times zone_reclaim() scans and fails
has been removed from the -mm tree.  Its filename was
     vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: count the number of times zone_reclaim() scans and fails
From: Mel Gorman <mel@csn.ul.ie>

On NUMA machines, the administrator can configure zone_reclaim_mode that
is a more targetted form of direct reclaim.  On machines with large NUMA
distances for example, a zone_reclaim_mode defaults to 1 meaning that
clean unmapped pages will be reclaimed if the zone watermarks are not
being met.

There is a heuristic that determines if the scan is worthwhile but it is
possible that the heuristic will fail and the CPU gets tied up scanning
uselessly.  Detecting the situation requires some guesswork and
experimentation so this patch adds a counter "zreclaim_failed" to
/proc/vmstat.  If during high CPU utilisation this counter is increasing
rapidly, then the resolution to the problem may be to set
/proc/sys/vm/zone_reclaim_mode to 0.

[akpm@linux-foundation.org: name things consistently]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    3 +++
 mm/vmscan.c            |    3 +++
 mm/vmstat.c            |    3 +++
 3 files changed, 9 insertions(+)

diff -puN include/linux/vmstat.h~vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails include/linux/vmstat.h
--- a/include/linux/vmstat.h~vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails
+++ a/include/linux/vmstat.h
@@ -36,6 +36,9 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		FOR_ALL_ZONES(PGSTEAL),
 		FOR_ALL_ZONES(PGSCAN_KSWAPD),
 		FOR_ALL_ZONES(PGSCAN_DIRECT),
+#ifdef CONFIG_NUMA
+		PGSCAN_ZONE_RECLAIM_FAILED,
+#endif
 		PGINODESTEAL, SLABS_SCANNED, KSWAPD_STEAL, KSWAPD_INODESTEAL,
 		PAGEOUTRUN, ALLOCSTALL, PGROTATED,
 #ifdef CONFIG_HUGETLB_PAGE
diff -puN mm/vmscan.c~vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails mm/vmscan.c
--- a/mm/vmscan.c~vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails
+++ a/mm/vmscan.c
@@ -2519,6 +2519,9 @@ int zone_reclaim(struct zone *zone, gfp_
 	ret = __zone_reclaim(zone, gfp_mask, order);
 	zone_clear_flag(zone, ZONE_RECLAIM_LOCKED);
 
+	if (!ret)
+		count_vm_event(PGSCAN_ZONE_RECLAIM_FAILED);
+
 	return ret;
 }
 #endif
diff -puN mm/vmstat.c~vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails mm/vmstat.c
--- a/mm/vmstat.c~vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails
+++ a/mm/vmstat.c
@@ -673,6 +673,9 @@ static const char * const vmstat_text[] 
 	TEXTS_FOR_ZONES("pgscan_kswapd")
 	TEXTS_FOR_ZONES("pgscan_direct")
 
+#ifdef CONFIG_NUMA
+	"zone_reclaim_failed",
+#endif
 	"pginodesteal",
 	"slabs_scanned",
 	"kswapd_steal",
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
linux-next.patch
page_alloc-oops-when-setting-percpu_pagelist_fraction.patch
memcg-fix-lru-rotation-in-isolate_pages.patch
add-debugging-aid-for-memory-initialisation-problems.patch

