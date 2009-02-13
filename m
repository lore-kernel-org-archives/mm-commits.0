From: akpm@linux-foundation.org
Subject: + mm-shrink_all_memory-use-scnr_reclaimed.patch added to -mm tree
Date: Fri, 13 Feb 2009 14:58:51 -0800
Message-ID: <200902132258.n1DMwpbV029469@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758219AbZBMW7y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Feb 2009 17:59:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, rjw@sisk.pl


The patch titled
     mm: shrink_all_memory(): use sc.nr_reclaimed
has been added to the -mm tree.  Its filename is
     mm-shrink_all_memory-use-scnr_reclaimed.patch

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
Subject: mm: shrink_all_memory(): use sc.nr_reclaimed
From: MinChan Kim <minchan.kim@gmail.com>

Commit a79311c14eae4bb946a97af25f3e1b17d625985d "vmscan: bail out of
direct reclaim after swap_cluster_max pages" moved the nr_reclaimed
counter into the scan control to accumulate the number of all reclaimed
pages in a reclaim invocation.

shrink_all_memory() can use the same mechanism. it increase code
consistency and redability.

Signed-off-by: MinChan Kim <minchan.kim@gmail.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff -puN mm/vmscan.c~mm-shrink_all_memory-use-scnr_reclaimed mm/vmscan.c
--- a/mm/vmscan.c~mm-shrink_all_memory-use-scnr_reclaimed
+++ a/mm/vmscan.c
@@ -2048,16 +2048,15 @@ unsigned long global_lru_pages(void)
 #ifdef CONFIG_PM
 /*
  * Helper function for shrink_all_memory().  Tries to reclaim 'nr_pages' pages
- * from LRU lists system-wide, for given pass and priority, and returns the
- * number of reclaimed pages
+ * from LRU lists system-wide, for given pass and priority.
  *
  * For pass > 3 we also try to shrink the LRU lists that contain a few pages
  */
-static unsigned long shrink_all_zones(unsigned long nr_pages, int prio,
+static void shrink_all_zones(unsigned long nr_pages, int prio,
 				      int pass, struct scan_control *sc)
 {
 	struct zone *zone;
-	unsigned long ret = 0;
+	unsigned long nr_reclaimed = 0;
 
 	for_each_populated_zone(zone) {
 		enum lru_list l;
@@ -2080,14 +2079,16 @@ static unsigned long shrink_all_zones(un
 
 				zone->lru[l].nr_scan = 0;
 				nr_to_scan = min(nr_pages, lru_pages);
-				ret += shrink_list(l, nr_to_scan, zone,
+				nr_reclaimed += shrink_list(l, nr_to_scan, zone,
 								sc, prio);
-				if (ret >= nr_pages)
-					return ret;
+				if (nr_reclaimed >= nr_pages) {
+					sc->nr_reclaimed = nr_reclaimed;
+					return;
+				}
 			}
 		}
 	}
-	return ret;
+	sc->nr_reclaimed = nr_reclaimed;
 }
 
 /*
@@ -2101,7 +2102,6 @@ static unsigned long shrink_all_zones(un
 unsigned long shrink_all_memory(unsigned long nr_pages)
 {
 	unsigned long lru_pages, nr_slab;
-	unsigned long ret = 0;
 	int pass;
 	struct reclaim_state reclaim_state;
 	struct scan_control sc = {
@@ -2123,8 +2123,8 @@ unsigned long shrink_all_memory(unsigned
 		if (!reclaim_state.reclaimed_slab)
 			break;
 
-		ret += reclaim_state.reclaimed_slab;
-		if (ret >= nr_pages)
+		sc.nr_reclaimed += reclaim_state.reclaimed_slab;
+		if (sc.nr_reclaimed >= nr_pages)
 			goto out;
 
 		nr_slab -= reclaim_state.reclaimed_slab;
@@ -2146,18 +2146,18 @@ unsigned long shrink_all_memory(unsigned
 			sc.may_unmap = 1;
 
 		for (prio = DEF_PRIORITY; prio >= 0; prio--) {
-			unsigned long nr_to_scan = nr_pages - ret;
+			unsigned long nr_to_scan = nr_pages - sc.nr_reclaimed;
 
 			sc.nr_scanned = 0;
-			ret += shrink_all_zones(nr_to_scan, prio, pass, &sc);
-			if (ret >= nr_pages)
+			shrink_all_zones(nr_to_scan, prio, pass, &sc);
+			if (sc.nr_reclaimed >= nr_pages)
 				goto out;
 
 			reclaim_state.reclaimed_slab = 0;
 			shrink_slab(sc.nr_scanned, sc.gfp_mask,
 					global_lru_pages());
-			ret += reclaim_state.reclaimed_slab;
-			if (ret >= nr_pages)
+			sc.nr_reclaimed += reclaim_state.reclaimed_slab;
+			if (sc.nr_reclaimed >= nr_pages)
 				goto out;
 
 			if (sc.nr_scanned && prio < DEF_PRIORITY - 2)
@@ -2166,21 +2166,22 @@ unsigned long shrink_all_memory(unsigned
 	}
 
 	/*
-	 * If ret = 0, we could not shrink LRUs, but there may be something
+	 * If sc.nr_reclaimed = 0, we could not shrink LRUs, but there may be something
 	 * in slab caches
 	 */
-	if (!ret) {
+	if (!sc.nr_reclaimed) {
 		do {
 			reclaim_state.reclaimed_slab = 0;
 			shrink_slab(nr_pages, sc.gfp_mask, global_lru_pages());
-			ret += reclaim_state.reclaimed_slab;
-		} while (ret < nr_pages && reclaim_state.reclaimed_slab > 0);
+			sc.nr_reclaimed += reclaim_state.reclaimed_slab;
+		} while (sc.nr_reclaimed < nr_pages && reclaim_state.reclaimed_slab > 0);
 	}
 
+
 out:
 	current->reclaim_state = NULL;
 
-	return ret;
+	return sc.nr_reclaimed;
 }
 #endif
 
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

origin.patch
vmap-remove-needless-lock-and-list-in-vmap.patch
vmscan-rename-scmay_swap-to-may_unmap.patch
mm-shrink_all_memory-use-scnr_reclaimed.patch
mm-shrink_all_memory-use-scnr_reclaimed-checkpatch-fixes.patch
vmscan-clip-swap_cluster_max-in-shrink_all_memory.patch

