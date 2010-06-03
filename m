From: akpm@linux-foundation.org
Subject: + vmscan-fix-do_try_to_free_pages-return-value-when-priority==0-reclaim-failure.patch added to -mm tree
Date: Thu, 03 Jun 2010 13:29:34 -0700
Message-ID: <201006032029.o53KTZVM013813@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43914 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752857Ab0FCU3z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jun 2010 16:29:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, balbir@linux.vnet.ibm.com, gthelen@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, nacc@us.ibm.com


The patch titled
     vmscan: fix do_try_to_free_pages() return value when priority==0 reclaim failure
has been added to the -mm tree.  Its filename is
     vmscan-fix-do_try_to_free_pages-return-value-when-priority==0-reclaim-failure.patch

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
Subject: vmscan: fix do_try_to_free_pages() return value when priority==0 reclaim failure
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Greg Thelen reported recent Johannes's stack diet patch makes kernel hang.
 His test is following.

  mount -t cgroup none /cgroups -o memory
  mkdir /cgroups/cg1
  echo $$ > /cgroups/cg1/tasks
  dd bs=1024 count=1024 if=/dev/null of=/data/foo
  echo $$ > /cgroups/tasks
  echo 1 > /cgroups/cg1/memory.force_empty

Actually, This OOM hard to try logic have been corrupted since following
two years old patch.

	commit a41f24ea9fd6169b147c53c2392e2887cc1d9247
	Author: Nishanth Aravamudan <nacc@us.ibm.com>
	Date:   Tue Apr 29 00:58:25 2008 -0700

	    page allocator: smarter retry of costly-order allocations

Original intention was "return success if the system have shrinkable zones
though priority==0 reclaim was failure".  But the above patch changed to
"return nr_reclaimed if .....".  Oh, That forgot nr_reclaimed may be 0 if
priority==0 reclaim failure.

And Johannes's patch 0aeb2339e54e ("vmscan: remove all_unreclaimable scan
control") made it more corrupt.  Originally, priority==0 reclaim failure
on memcg return 0, but this patch changed to return 1.  It totally
confused memcg.

This patch fixes it completely.

Reported-by: Greg Thelen <gthelen@google.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Tested-by: Greg Thelen <gthelen@google.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff -puN mm/vmscan.c~vmscan-fix-do_try_to_free_pages-return-value-when-priority==0-reclaim-failure mm/vmscan.c
--- a/mm/vmscan.c~vmscan-fix-do_try_to_free_pages-return-value-when-priority==0-reclaim-failure
+++ a/mm/vmscan.c
@@ -1724,13 +1724,13 @@ static void shrink_zone(int priority, st
  * If a zone is deemed to be full of pinned pages then just give it a light
  * scan then give up on it.
  */
-static int shrink_zones(int priority, struct zonelist *zonelist,
+static bool shrink_zones(int priority, struct zonelist *zonelist,
 					struct scan_control *sc)
 {
 	enum zone_type high_zoneidx = gfp_zone(sc->gfp_mask);
 	struct zoneref *z;
 	struct zone *zone;
-	int progress = 0;
+	bool all_unreclaimable = true;
 
 	for_each_zone_zonelist_nodemask(zone, z, zonelist, high_zoneidx,
 					sc->nodemask) {
@@ -1757,9 +1757,9 @@ static int shrink_zones(int priority, st
 		}
 
 		shrink_zone(priority, zone, sc);
-		progress = 1;
+		all_unreclaimable = false;
 	}
-	return progress;
+	return all_unreclaimable;
 }
 
 /*
@@ -1782,7 +1782,7 @@ static unsigned long do_try_to_free_page
 					struct scan_control *sc)
 {
 	int priority;
-	unsigned long ret = 0;
+	bool all_unreclaimable;
 	unsigned long total_scanned = 0;
 	struct reclaim_state *reclaim_state = current->reclaim_state;
 	unsigned long lru_pages = 0;
@@ -1813,7 +1813,7 @@ static unsigned long do_try_to_free_page
 		sc->nr_scanned = 0;
 		if (!priority)
 			disable_swap_token();
-		ret = shrink_zones(priority, zonelist, sc);
+		all_unreclaimable = shrink_zones(priority, zonelist, sc);
 		/*
 		 * Don't shrink slabs when reclaiming memory from
 		 * over limit cgroups
@@ -1826,10 +1826,8 @@ static unsigned long do_try_to_free_page
 			}
 		}
 		total_scanned += sc->nr_scanned;
-		if (sc->nr_reclaimed >= sc->nr_to_reclaim) {
-			ret = sc->nr_reclaimed;
+		if (sc->nr_reclaimed >= sc->nr_to_reclaim)
 			goto out;
-		}
 
 		/*
 		 * Try to write back as many pages as we just scanned.  This
@@ -1849,9 +1847,7 @@ static unsigned long do_try_to_free_page
 		    priority < DEF_PRIORITY - 2)
 			congestion_wait(BLK_RW_ASYNC, HZ/10);
 	}
-	/* top priority shrink_zones still had more to do? don't OOM, then */
-	if (ret && scanning_global_lru(sc))
-		ret = sc->nr_reclaimed;
+
 out:
 	/*
 	 * Now that we've scanned all the zones at this priority level, note
@@ -1877,7 +1873,14 @@ out:
 	delayacct_freepages_end();
 	put_mems_allowed();
 
-	return ret;
+	if (sc->nr_reclaimed)
+		return sc->nr_reclaimed;
+
+	/* top priority shrink_zones still had more to do? don't OOM, then */
+	if (scanning_global_lru(sc) && !all_unreclaimable)
+		return 1;
+
+	return 0;
 }
 
 unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

vmscan-fix-do_try_to_free_pages-return-value-when-priority==0-reclaim-failure.patch
mm-use-memdup_user.patch
reiser4.patch

