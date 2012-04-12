From: akpm@linux-foundation.org
Subject: + mm-fix-up-the-vmscan-stat-in-vmstat.patch added to -mm tree
Date: Thu, 12 Apr 2012 16:35:33 -0700
Message-ID: <20120412233533.8F61BA02AD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:53226 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934233Ab2DLXfe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Apr 2012 19:35:34 -0400
Received: by qabg24 with SMTP id g24so338060qab.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Apr 2012 16:35:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghan@google.com, cl@linux.com, dan.magenheimer@oracle.com, dhillf@gmail.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, riel@redhat.com


The patch titled
     Subject: mm: fix up the vmscan stat in vmstat
has been added to the -mm tree.  Its filename is
     mm-fix-up-the-vmscan-stat-in-vmstat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ying Han <yinghan@google.com>
Subject: mm: fix up the vmscan stat in vmstat

The "pgsteal" stat is confusing because it counts both direct reclaim as
well as background reclaim.  However, we have "kswapd_steal" which also
counts background reclaim value.

This patch fixes it and also makes it match the existng "pgscan_" stats.

Test:
pgsteal_kswapd_dma32 447623
pgsteal_kswapd_normal 42272677
pgsteal_kswapd_movable 0
pgsteal_direct_dma32 2801
pgsteal_direct_normal 44353270
pgsteal_direct_movable 0

Signed-off-by: Ying Han <yinghan@google.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vm_event_item.h |    5 +++--
 mm/vmscan.c                   |   11 ++++++++---
 mm/vmstat.c                   |    4 ++--
 3 files changed, 13 insertions(+), 7 deletions(-)

diff -puN include/linux/vm_event_item.h~mm-fix-up-the-vmscan-stat-in-vmstat include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~mm-fix-up-the-vmscan-stat-in-vmstat
+++ a/include/linux/vm_event_item.h
@@ -26,13 +26,14 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		PGFREE, PGACTIVATE, PGDEACTIVATE,
 		PGFAULT, PGMAJFAULT,
 		FOR_ALL_ZONES(PGREFILL),
-		FOR_ALL_ZONES(PGSTEAL),
+		FOR_ALL_ZONES(PGSTEAL_KSWAPD),
+		FOR_ALL_ZONES(PGSTEAL_DIRECT),
 		FOR_ALL_ZONES(PGSCAN_KSWAPD),
 		FOR_ALL_ZONES(PGSCAN_DIRECT),
 #ifdef CONFIG_NUMA
 		PGSCAN_ZONE_RECLAIM_FAILED,
 #endif
-		PGINODESTEAL, SLABS_SCANNED, KSWAPD_STEAL, KSWAPD_INODESTEAL,
+		PGINODESTEAL, SLABS_SCANNED, KSWAPD_INODESTEAL,
 		KSWAPD_LOW_WMARK_HIT_QUICKLY, KSWAPD_HIGH_WMARK_HIT_QUICKLY,
 		KSWAPD_SKIP_CONGESTION_WAIT,
 		PAGEOUTRUN, ALLOCSTALL, PGROTATED,
diff -puN mm/vmscan.c~mm-fix-up-the-vmscan-stat-in-vmstat mm/vmscan.c
--- a/mm/vmscan.c~mm-fix-up-the-vmscan-stat-in-vmstat
+++ a/mm/vmscan.c
@@ -1568,9 +1568,14 @@ shrink_inactive_list(unsigned long nr_to
 	reclaim_stat->recent_scanned[0] += nr_anon;
 	reclaim_stat->recent_scanned[1] += nr_file;
 
-	if (current_is_kswapd())
-		__count_vm_events(KSWAPD_STEAL, nr_reclaimed);
-	__count_zone_vm_events(PGSTEAL, zone, nr_reclaimed);
+	if (global_reclaim(sc)) {
+		if (current_is_kswapd())
+			__count_zone_vm_events(PGSTEAL_KSWAPD, zone,
+					       nr_reclaimed);
+		else
+			__count_zone_vm_events(PGSTEAL_DIRECT, zone,
+					       nr_reclaimed);
+	}
 
 	putback_inactive_pages(mz, &page_list);
 
diff -puN mm/vmstat.c~mm-fix-up-the-vmscan-stat-in-vmstat mm/vmstat.c
--- a/mm/vmstat.c~mm-fix-up-the-vmscan-stat-in-vmstat
+++ a/mm/vmstat.c
@@ -738,7 +738,8 @@ const char * const vmstat_text[] = {
 	"pgmajfault",
 
 	TEXTS_FOR_ZONES("pgrefill")
-	TEXTS_FOR_ZONES("pgsteal")
+	TEXTS_FOR_ZONES("pgsteal_kswapd")
+	TEXTS_FOR_ZONES("pgsteal_direct")
 	TEXTS_FOR_ZONES("pgscan_kswapd")
 	TEXTS_FOR_ZONES("pgscan_direct")
 
@@ -747,7 +748,6 @@ const char * const vmstat_text[] = {
 #endif
 	"pginodesteal",
 	"slabs_scanned",
-	"kswapd_steal",
 	"kswapd_inodesteal",
 	"kswapd_low_wmark_hit_quickly",
 	"kswapd_high_wmark_hit_quickly",
_
Subject: Subject: mm: fix up the vmscan stat in vmstat

Patches currently in -mm which might be from yinghan@google.com are

memcg-fix-up-documentation-on-global-lru.patch
revert-mm-vmscan-fix-misused-nr_reclaimed-in-shrink_mem_cgroup_zone.patch
mm-fix-up-the-vmscan-stat-in-vmstat.patch

