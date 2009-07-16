From: akpm@linux-foundation.org
Subject: + vmscan-throttle-direct-reclaim-when-too-many-pages-are-isolated-already.patch added to -mm tree
Date: Wed, 15 Jul 2009 21:04:08 -0700
Message-ID: <200907160404.n6G448BE028680@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45159 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751328AbZGPEEc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Jul 2009 00:04:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     vmscan: throttle direct reclaim when too many pages are isolated already
has been added to the -mm tree.  Its filename is
     vmscan-throttle-direct-reclaim-when-too-many-pages-are-isolated-already.patch

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
@@ -1029,6 +1029,31 @@ int isolate_lru_page(struct page *page)
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
@@ -1043,6 +1068,14 @@ static unsigned long shrink_inactive_lis
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

mm-copy-over-oom_adj-value-at-fork-time.patch
mm-make-swap-token-dummies-static-inlines.patch
mm-make-swap-token-dummies-static-inlines-fix.patch
mm-make-swap-token-dummies-static-inlines-fix-2.patch
mm-clean-up-page_remove_rmap.patch
mm-oom-analysis-add-per-zone-statistics-to-show_free_areas.patch
mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
mm-oom-analysis-show-kernel-stack-usage-in-proc-meminfo-and-oom-log-output.patch
mm-oom-analysis-add-shmem-vmstat.patch
mm-rename-pgmoved-variable-in-shrink_active_list.patch
mm-shrink_inactive_list-nr_scan-accounting-fix-fix.patch
mm-vmstat-add-isolate-pages.patch
vmscan-throttle-direct-reclaim-when-too-many-pages-are-isolated-already.patch

