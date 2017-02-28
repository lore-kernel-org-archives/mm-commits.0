From: akpm@linux-foundation.org
Subject: + mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes.patch
 added to -mm tree
Date: Tue, 28 Feb 2017 15:53:21 -0800
Message-ID: <58b60d71.llz5rVE3tkjOZgnz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38076 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751543AbdB1XzF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 18:55:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hejianet@gmail.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix 100% CPU kswapd busyloop on unreclaimable nodes
has been added to the -mm tree.  Its filename is
     mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-100%25-cpu-kswapd-busyloop-on-unreclaimable-nodes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-100%25-cpu-kswapd-busyloop-on-unreclaimable-nodes.patch

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
Subject: mm: fix 100% CPU kswapd busyloop on unreclaimable nodes

Patch series "mm: kswapd spinning on unreclaimable nodes - fixes and cleanups".

Jia reported a scenario in which the kswapd of a node indefinitely spins
at 100% CPU usage.  We have seen similar cases at Facebook.

The kernel's current method of judging its ability to reclaim a node (or
whether to back off and sleep) is based on the amount of scanned pages in
proportion to the amount of reclaimable pages.  In Jia's and our
scenarios, there are no reclaimable pages in the node, however, and the
condition for backing off is never met.  Kswapd busyloops in an attempt to
restore the watermarks while having nothing to work with.

This series reworks the definition of an unreclaimable node based not on
scanning but on whether kswapd is able to actually reclaim pages in
MAX_RECLAIM_RETRIES (16) consecutive runs.  This is the same criteria the
page allocator uses for giving up on direct reclaim and invoking the OOM
killer.  If it cannot free any pages, kswapd will go to sleep and leave
further attempts to direct reclaim invocations, which will either make
progress and re-enable kswapd, or invoke the OOM killer.

Patch #1 fixes the immediate problem Jia reported, the remainder are
smaller fixlets, cleanups, and overall phasing out of the old method.

Patch #6 is the odd one out.  It's a nice cleanup to get_scan_count(), and
directly related to #5, but in itself not relevant to the series.

If the whole series is too ambitious for 4.11, I would consider the first
three patches fixes, the rest cleanups.


This patch (of 9):

Jia He reports a problem with kswapd spinning at 100% CPU when requesting
more hugepages than memory available in the system:

$ echo 4000 >/proc/sys/vm/nr_hugepages

top - 13:42:59 up  3:37,  1 user,  load average: 1.09, 1.03, 1.01
Tasks:   1 total,   1 running,   0 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0.0 us, 12.5 sy,  0.0 ni, 85.5 id,  2.0 wa,  0.0 hi,  0.0 si,  0.0 st
KiB Mem:  31371520 total, 30915136 used,   456384 free,      320 buffers
KiB Swap:  6284224 total,   115712 used,  6168512 free.    48192 cached Mem

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
   76 root      20   0       0      0      0 R 100.0 0.000 217:17.29 kswapd3

At that time, there are no reclaimable pages left in the node, but as
kswapd fails to restore the high watermarks it refuses to go to sleep.

Kswapd needs to back away from nodes that fail to balance.  Up until
1d82de618ddd ("mm, vmscan: make kswapd reclaim in terms of nodes") kswapd
had such a mechanism.  It considered zones whose theoretically reclaimable
pages it had reclaimed six times over as unreclaimable and backed away
from them.  This guard was erroneously removed as the patch changed the
definition of a balanced node.

However, simply restoring this code wouldn't help in the case reported
here: there *are* no reclaimable pages that could be scanned until the
threshold is met.  Kswapd would stay awake anyway.

Introduce a new and much simpler way of backing off.  If kswapd runs
through MAX_RECLAIM_RETRIES (16) cycles without reclaiming a single page,
make it back off from the node.  This is the same number of shots direct
reclaim takes before declaring OOM.  Kswapd will go to sleep on that node
until a direct reclaimer manages to reclaim some pages, thus proving the
node reclaimable again.

v2: move MAX_RECLAIM_RETRIES to mm/internal.h (Michal)

Link: http://lkml.kernel.org/r/20170228214007.5621-2-hannes@cmpxchg.org
Reported-by: Jia He <hejianet@gmail.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Tested-by: Jia He <hejianet@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 ++
 mm/internal.h          |    6 ++++++
 mm/page_alloc.c        |    9 ++-------
 mm/vmscan.c            |   27 ++++++++++++++++++++-------
 mm/vmstat.c            |    2 +-
 5 files changed, 31 insertions(+), 15 deletions(-)

diff -puN include/linux/mmzone.h~mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes
+++ a/include/linux/mmzone.h
@@ -630,6 +630,8 @@ typedef struct pglist_data {
 	int kswapd_order;
 	enum zone_type kswapd_classzone_idx;
 
+	int kswapd_failures;		/* Number of 'reclaimed == 0' runs */
+
 #ifdef CONFIG_COMPACTION
 	int kcompactd_max_order;
 	enum zone_type kcompactd_classzone_idx;
diff -puN mm/internal.h~mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes mm/internal.h
--- a/mm/internal.h~mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes
+++ a/mm/internal.h
@@ -81,6 +81,12 @@ static inline void set_page_refcounted(s
 extern unsigned long highest_memmap_pfn;
 
 /*
+ * Maximum number of reclaim retries without progress before the OOM
+ * killer is consider the only way forward.
+ */
+#define MAX_RECLAIM_RETRIES 16
+
+/*
  * in mm/vmscan.c:
  */
 extern int isolate_lru_page(struct page *page);
diff -puN mm/page_alloc.c~mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes
+++ a/mm/page_alloc.c
@@ -3516,12 +3516,6 @@ bool gfp_pfmemalloc_allowed(gfp_t gfp_ma
 }
 
 /*
- * Maximum number of reclaim retries without any progress before OOM killer
- * is consider as the only way to move forward.
- */
-#define MAX_RECLAIM_RETRIES 16
-
-/*
  * Checks whether it makes sense to retry the reclaim to make a forward progress
  * for the given allocation request.
  * The reclaim feedback represented by did_some_progress (any progress during
@@ -4527,7 +4521,8 @@ void show_free_areas(unsigned int filter
 			K(node_page_state(pgdat, NR_WRITEBACK_TEMP)),
 			K(node_page_state(pgdat, NR_UNSTABLE_NFS)),
 			node_page_state(pgdat, NR_PAGES_SCANNED),
-			!pgdat_reclaimable(pgdat) ? "yes" : "no");
+			pgdat->kswapd_failures >= MAX_RECLAIM_RETRIES ?
+				"yes" : "no");
 	}
 
 	for_each_populated_zone(zone) {
diff -puN mm/vmscan.c~mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes mm/vmscan.c
--- a/mm/vmscan.c~mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes
+++ a/mm/vmscan.c
@@ -2619,6 +2619,15 @@ static bool shrink_node(pg_data_t *pgdat
 	} while (should_continue_reclaim(pgdat, sc->nr_reclaimed - nr_reclaimed,
 					 sc->nr_scanned - nr_scanned, sc));
 
+	/*
+	 * Kswapd gives up on balancing particular nodes after too
+	 * many failures to reclaim anything from them and goes to
+	 * sleep. On reclaim progress, reset the failure counter. A
+	 * successful direct reclaim run will revive a dormant kswapd.
+	 */
+	if (reclaimable)
+		pgdat->kswapd_failures = 0;
+
 	return reclaimable;
 }
 
@@ -2693,10 +2702,6 @@ static void shrink_zones(struct zonelist
 						 GFP_KERNEL | __GFP_HARDWALL))
 				continue;
 
-			if (sc->priority != DEF_PRIORITY &&
-			    !pgdat_reclaimable(zone->zone_pgdat))
-				continue;	/* Let kswapd poll it */
-
 			/*
 			 * If we already have plenty of memory free for
 			 * compaction in this zone, don't free any more.
@@ -3127,6 +3132,10 @@ static bool prepare_kswapd_sleep(pg_data
 	if (waitqueue_active(&pgdat->pfmemalloc_wait))
 		wake_up_all(&pgdat->pfmemalloc_wait);
 
+	/* Hopeless node, leave it to direct reclaim */
+	if (pgdat->kswapd_failures >= MAX_RECLAIM_RETRIES)
+		return true;
+
 	for (i = 0; i <= classzone_idx; i++) {
 		struct zone *zone = pgdat->node_zones + i;
 
@@ -3309,6 +3318,9 @@ static int balance_pgdat(pg_data_t *pgda
 			sc.priority--;
 	} while (sc.priority >= 1);
 
+	if (!sc.nr_reclaimed)
+		pgdat->kswapd_failures++;
+
 out:
 	/*
 	 * Return the order kswapd stopped reclaiming at as
@@ -3508,6 +3520,10 @@ void wakeup_kswapd(struct zone *zone, in
 	if (!waitqueue_active(&pgdat->kswapd_wait))
 		return;
 
+	/* Hopeless node, leave it to direct reclaim */
+	if (pgdat->kswapd_failures >= MAX_RECLAIM_RETRIES)
+		return;
+
 	/* Only wake kswapd if all zones are unbalanced */
 	for (z = 0; z <= classzone_idx; z++) {
 		zone = pgdat->node_zones + z;
@@ -3778,9 +3794,6 @@ int node_reclaim(struct pglist_data *pgd
 	    sum_zone_node_page_state(pgdat->node_id, NR_SLAB_RECLAIMABLE) <= pgdat->min_slab_pages)
 		return NODE_RECLAIM_FULL;
 
-	if (!pgdat_reclaimable(pgdat))
-		return NODE_RECLAIM_FULL;
-
 	/*
 	 * Do not scan if the allocation should not be delayed.
 	 */
diff -puN mm/vmstat.c~mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes mm/vmstat.c
--- a/mm/vmstat.c~mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes
+++ a/mm/vmstat.c
@@ -1422,7 +1422,7 @@ static void zoneinfo_show_print(struct s
 		   "\n  node_unreclaimable:  %u"
 		   "\n  start_pfn:           %lu"
 		   "\n  node_inactive_ratio: %u",
-		   !pgdat_reclaimable(zone->zone_pgdat),
+		   pgdat->kswapd_failures >= MAX_RECLAIM_RETRIES,
 		   zone->zone_start_pfn,
 		   zone->zone_pgdat->inactive_ratio);
 	seq_putc(m, '\n');
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes.patch
mm-fix-check-for-reclaimable-pages-in-pf_memalloc-reclaim-throttling.patch
mm-remove-seemingly-spurious-reclaimability-check-from-laptop_mode-gating.patch
mm-remove-unnecessary-reclaimability-check-from-numa-balancing-target.patch
mm-dont-avoid-high-priority-reclaim-on-unreclaimable-nodes.patch
mm-dont-avoid-high-priority-reclaim-on-memcg-limit-reclaim.patch
mm-delete-nr_pages_scanned-and-pgdat_reclaimable.patch
revert-mm-vmscan-account-for-skipped-pages-as-a-partial-scan.patch
mm-remove-unnecessary-back-off-function-when-retrying-page-reclaim.patch

