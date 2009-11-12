From: akpm@linux-foundation.org
Subject: + vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep.patch added to -mm tree
Date: Thu, 12 Nov 2009 12:34:54 -0800
Message-ID: <200911122034.nACKYsZq003182@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753702AbZKLUfw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Nov 2009 15:35:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, cl@linux-foundation.org, elendil@planet.nl, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com


The patch titled
     vmscan: have kswapd sleep for a short interval and double check it should be asleep
has been added to the -mm tree.  Its filename is
     vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1908,6 +1908,24 @@ unsigned long try_to_free_mem_cgroup_pag
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
@@ -2189,8 +2207,30 @@ static int kswapd(void *p)
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

page-allocator-always-wake-kswapd-when-restarting-an-allocation-attempt-after-direct-reclaim-failed.patch
page-allocator-do-not-allow-interrupts-to-use-alloc_harder.patch
linux-next.patch
mm-add-notifier-in-pageblock-isolation-for-balloon-drivers.patch
powerpc-make-the-cmm-memory-hotplug-aware.patch
mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch
nodemask-make-nodemask_alloc-more-general.patch
hugetlb-rework-hstate_next_node_-functions.patch
hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions.patch
hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions-fix.patch
hugetlb-factor-init_nodemask_of_node.patch
hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy.patch
hugetlb-add-generic-definition-of-numa_no_node.patch
hugetlb-add-per-node-hstate-attributes.patch
hugetlb-update-hugetlb-documentation-for-numa-controls.patch
hugetlb-use-only-nodes-with-memory-for-huge-pages.patch
mm-clear-node-in-n_high_memory-and-stop-kswapd-when-all-memory-is-offlined.patch
hugetlb-handle-memory-hot-plug-events.patch
hugetlb-offload-per-node-attribute-registrations.patch
mm-add-gfp-flags-for-nodemask_alloc-slab-allocations.patch
page-allocator-wait-on-both-sync-and-async-congestion-after-direct-reclaim.patch
vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep.patch
vmscan-take-order-into-consideration-when-deciding-if-kswapd-is-in-trouble.patch
add-debugging-aid-for-memory-initialisation-problems.patch

