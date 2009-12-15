From: akpm@linux-foundation.org
Subject: [merged] vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:52:13 -0800
Message-ID: <200912152152.nBFLqDwd015179@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761227AbZLOVx3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:53:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, cl@linux-foundation.org, elendil@planet.nl, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: have kswapd sleep for a short interval and double check it should be asleep
has been removed from the -mm tree.  Its filename was
     vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: have kswapd sleep for a short interval and double check it should be asleep
From: Mel Gorman <mel@csn.ul.ie>

After kswapd balances all zones in a pgdat, it goes to sleep.  In the
event of no IO congestion, kswapd can go to sleep very shortly after the
high watermark was reached.  If there are a constant stream of allocations
from parallel processes, it can mean that kswapd went to sleep too quickly
and the high watermark is not being maintained for sufficient length time.

This patch makes kswapd go to sleep as a two-stage process.  It first
tries to sleep for HZ/10.  If it is woken up by another process or the
high watermark is no longer met, it's considered a premature sleep and
kswapd continues work.  Otherwise it goes fully to sleep.

This adds more counters to distinguish between fast and slow breaches of
watermarks.  A "fast" premature sleep is one where the low watermark was
hit in a very short time after kswapd going to sleep.  A "slow" premature
sleep indicates that the high watermark was breached after a very short
interval.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Frans Pop <elendil@planet.nl>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    1 
 mm/vmscan.c            |   44 +++++++++++++++++++++++++++++++++++++--
 mm/vmstat.c            |    2 +
 3 files changed, 45 insertions(+), 2 deletions(-)

diff -puN include/linux/vmstat.h~vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep include/linux/vmstat.h
--- a/include/linux/vmstat.h~vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep
+++ a/include/linux/vmstat.h
@@ -40,6 +40,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		PGSCAN_ZONE_RECLAIM_FAILED,
 #endif
 		PGINODESTEAL, SLABS_SCANNED, KSWAPD_STEAL, KSWAPD_INODESTEAL,
+		KSWAPD_PREMATURE_FAST, KSWAPD_PREMATURE_SLOW,
 		PAGEOUTRUN, ALLOCSTALL, PGROTATED,
 #ifdef CONFIG_HUGETLB_PAGE
 		HTLB_BUDDY_PGALLOC, HTLB_BUDDY_PGALLOC_FAIL,
diff -puN mm/vmscan.c~vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep mm/vmscan.c
--- a/mm/vmscan.c~vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep
+++ a/mm/vmscan.c
@@ -1904,6 +1904,24 @@ unsigned long try_to_free_mem_cgroup_pag
 }
 #endif
 
+/* is kswapd sleeping prematurely? */
+static int sleeping_prematurely(int order, long remaining)
+{
+	struct zone *zone;
+
+	/* If a direct reclaimer woke kswapd within HZ/10, it's premature */
+	if (remaining)
+		return 1;
+
+	/* If after HZ/10, a zone is below the high mark, it's premature */
+	for_each_populated_zone(zone)
+		if (!zone_watermark_ok(zone, order, high_wmark_pages(zone),
+								0, 0))
+			return 1;
+
+	return 0;
+}
+
 /*
  * For kswapd, balance_pgdat() will work across all this node's zones until
  * they are all at high_wmark_pages(zone).
@@ -2185,8 +2203,30 @@ static int kswapd(void *p)
 			 */
 			order = new_order;
 		} else {
-			if (!freezing(current) && !kthread_should_stop())
-				schedule();
+			if (!freezing(current) && !kthread_should_stop()) {
+				long remaining = 0;
+
+				/* Try to sleep for a short interval */
+				if (!sleeping_prematurely(order, remaining)) {
+					remaining = schedule_timeout(HZ/10);
+					finish_wait(&pgdat->kswapd_wait, &wait);
+					prepare_to_wait(&pgdat->kswapd_wait, &wait, TASK_INTERRUPTIBLE);
+				}
+
+				/*
+				 * After a short sleep, check if it was a
+				 * premature sleep. If not, then go fully
+				 * to sleep until explicitly woken up
+				 */
+				if (!sleeping_prematurely(order, remaining))
+					schedule();
+				else {
+					if (remaining)
+						count_vm_event(KSWAPD_PREMATURE_FAST);
+					else
+						count_vm_event(KSWAPD_PREMATURE_SLOW);
+				}
+			}
 
 			order = pgdat->kswapd_max_order;
 		}
diff -puN mm/vmstat.c~vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep mm/vmstat.c
--- a/mm/vmstat.c~vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep
+++ a/mm/vmstat.c
@@ -683,6 +683,8 @@ static const char * const vmstat_text[] 
 	"slabs_scanned",
 	"kswapd_steal",
 	"kswapd_inodesteal",
+	"kswapd_slept_prematurely_fast",
+	"kswapd_slept_prematurely_slow",
 	"pageoutrun",
 	"allocstall",
 
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
mm-add-notifier-in-pageblock-isolation-for-balloon-drivers.patch
powerpc-make-the-cmm-memory-hotplug-aware.patch
powerpc-make-the-cmm-memory-hotplug-aware-update.patch
mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch
add-debugging-aid-for-memory-initialisation-problems.patch

