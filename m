From: akpm@linux-foundation.org
Subject: + vmscan-all_unreclaimable-use-zone-all_unreclaimable-as-a-name.patch added to -mm tree
Date: Mon, 11 Apr 2011 15:05:18 -0700
Message-ID: <201104112205.p3BM5JGa004016@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52361 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754507Ab1DKWF3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Apr 2011 18:05:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, avagin@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, npiggin@kernel.dk


The patch titled
     vmscan: all_unreclaimable() use zone->all_unreclaimable as a name
has been added to the -mm tree.  Its filename is
     vmscan-all_unreclaimable-use-zone-all_unreclaimable-as-a-name.patch

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
Subject: vmscan: all_unreclaimable() use zone->all_unreclaimable as a name
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

all_unreclaimable check in direct reclaim has been introduced at 2.6.19
by following commit.

	2006 Sep 25; commit 408d8544; oom: use unreclaimable info

And it went through strange history. firstly, following commit broke
the logic unintentionally.

	2008 Apr 29; commit a41f24ea; page allocator: smarter retry of
				      costly-order allocations

Two years later, I've found obvious meaningless code fragment and
restored original intention by following commit.

	2010 Jun 04; commit bb21c7ce; vmscan: fix do_try_to_free_pages()
				      return value when priority==0

But, the logic didn't works when 32bit highmem system goes hibernation
and Minchan slightly changed the algorithm and fixed it .

	2010 Sep 22: commit d1908362: vmscan: check all_unreclaimable
				      in direct reclaim path

But, recently, Andrey Vagin found the new corner case. Look,

	struct zone {
	  ..
	        int                     all_unreclaimable;
	  ..
	        unsigned long           pages_scanned;
	  ..
	}

zone->all_unreclaimable and zone->pages_scanned are neigher atomic
variables nor protected by lock.  Therefore zones can become a state of
zone->page_scanned=0 and zone->all_unreclaimable=1.  In this case, current
all_unreclaimable() return false even though zone->all_unreclaimabe=1.

Is this ignorable minor issue?  No.  Unfortunately, x86 has very small dma
zone and it become zone->all_unreclamble=1 easily.  and if it become
all_unreclaimable=1, it never restore all_unreclaimable=0.  Why?  if
all_unreclaimable=1, vmscan only try DEF_PRIORITY reclaim and
a-few-lru-pages>>DEF_PRIORITY always makes 0.  that mean no page scan at
all!

Eventually, oom-killer never works on such systems.  That said, we can't
use zone->pages_scanned for this purpose.  This patch restore
all_unreclaimable() use zone->all_unreclaimable as old.  and in addition,
to add oom_killer_disabled check to avoid reintroduce the issue of commit
d1908362 ("vmscan: check all_unreclaimable in direct reclaim path").

Reported-by: Andrey Vagin <avagin@openvz.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff -puN mm/vmscan.c~vmscan-all_unreclaimable-use-zone-all_unreclaimable-as-a-name mm/vmscan.c
--- a/mm/vmscan.c~vmscan-all_unreclaimable-use-zone-all_unreclaimable-as-a-name
+++ a/mm/vmscan.c
@@ -41,6 +41,7 @@
 #include <linux/memcontrol.h>
 #include <linux/delayacct.h>
 #include <linux/sysctl.h>
+#include <linux/oom.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -1988,17 +1989,12 @@ static bool zone_reclaimable(struct zone
 	return zone->pages_scanned < zone_reclaimable_pages(zone) * 6;
 }
 
-/*
- * As hibernation is going on, kswapd is freezed so that it can't mark
- * the zone into all_unreclaimable. It can't handle OOM during hibernation.
- * So let's check zone's unreclaimable in direct reclaim as well as kswapd.
- */
+/* All zones in zonelist are unreclaimable? */
 static bool all_unreclaimable(struct zonelist *zonelist,
 		struct scan_control *sc)
 {
 	struct zoneref *z;
 	struct zone *zone;
-	bool all_unreclaimable = true;
 
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 			gfp_zone(sc->gfp_mask), sc->nodemask) {
@@ -2006,13 +2002,11 @@ static bool all_unreclaimable(struct zon
 			continue;
 		if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
 			continue;
-		if (zone_reclaimable(zone)) {
-			all_unreclaimable = false;
-			break;
-		}
+		if (!zone->all_unreclaimable)
+			return false;
 	}
 
-	return all_unreclaimable;
+	return true;
 }
 
 /*
@@ -2108,6 +2102,14 @@ out:
 	if (sc->nr_reclaimed)
 		return sc->nr_reclaimed;
 
+	/*
+	 * As hibernation is going on, kswapd is freezed so that it can't mark
+	 * the zone into all_unreclaimable. Thus bypassing all_unreclaimable
+	 * check.
+	 */
+	if (oom_killer_disabled)
+		return 0;
+
 	/* top priority shrink_zones still had more to do? don't OOM, then */
 	if (scanning_global_lru(sc) && !all_unreclaimable(zonelist, sc))
 		return 1;
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

memcg-fix-mem_cgroup_rotate_reclaimable_page.patch
mm-per-node-vmstat-show-proper-vmstats.patch
mm-per-node-vmstat-show-proper-vmstats-fix.patch
mm-increase-reclaim_distance-to-30.patch
vmscan-all_unreclaimable-use-zone-all_unreclaimable-as-a-name.patch
oom-kill-remove-boost_dying_task_prio.patch
mm-introduce-wait_on_page_locked_killable.patch
x86mm-make-pagefault-killable.patch
mm-mem-hotplug-fix-section-mismatch-setup_per_zone_inactive_ratio-should-be-__meminit.patch
mm-mem-hotplug-recalculate-lowmem_reserve-when-memory-hotplug-occur.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-stats-to-monitor-soft_limit-reclaim.patch
add-the-pagefault-count-into-memcg-stats.patch
add-the-pagefault-count-into-memcg-stats-fix.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch

