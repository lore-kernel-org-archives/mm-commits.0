From: akpm@linux-foundation.org
Subject: + vmscan-prevent-get_scan_ratio-rounding-errors.patch added to -mm tree
Date: Fri, 09 Apr 2010 14:21:07 -0700
Message-ID: <201004092121.o39LL747011735@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52655 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757504Ab0DIVVv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Apr 2010 17:21:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, fengguang.wu@intel.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com


The patch titled
     vmscan: prevent get_scan_ratio() rounding errors
has been added to the -mm tree.  Its filename is
     vmscan-prevent-get_scan_ratio-rounding-errors.patch

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
Subject: vmscan: prevent get_scan_ratio() rounding errors
From: Shaohua Li <shaohua.li@intel.com>

get_scan_ratio() calculates percentage and if the percentage is < 1%, it
will round percentage down to 0% and cause we completely ignore scanning
anon/file pages to reclaim memory even the total anon/file pages are very
big.

To avoid underflow, we don't use percentage, instead we directly calculate
how many pages should be scaned.  In this way, we should get several
scanned pages for < 1% percent.

This has some benefits:

1. increase our calculation precision

2.  making our scan more smoothly.  Without this, if percent[x] is
   underflow, shrink_zone() doesn't scan any pages and suddenly it scans
   all pages when priority is zero.  With this, even priority isn't zero,
   shrink_zone() gets chance to scan some pages.

Note, this patch doesn't really change logics, but just increase
precision.  For system with a lot of memory, this might slightly changes
behavior.  For example, in a sequential file read workload, without the
patch, we don't swap any anon pages.  With it, if anon memory size is
bigger than 16G, we will see one anon page swapped.  The 16G is calculated
as PAGE_SIZE * priority(4096) * (fp/ap).  fp/ap is assumed to be 1024
which is common in this workload.  So the impact sounds not a big deal.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |  107 +++++++++++++++++++++++++-------------------------
 1 file changed, 55 insertions(+), 52 deletions(-)

diff -puN mm/vmscan.c~vmscan-prevent-get_scan_ratio-rounding-errors mm/vmscan.c
--- a/mm/vmscan.c~vmscan-prevent-get_scan_ratio-rounding-errors
+++ a/mm/vmscan.c
@@ -1514,21 +1514,52 @@ static unsigned long shrink_list(enum lr
 }
 
 /*
+ * Smallish @nr_to_scan's are deposited in @nr_saved_scan,
+ * until we collected @swap_cluster_max pages to scan.
+ */
+static unsigned long nr_scan_try_batch(unsigned long nr_to_scan,
+				       unsigned long *nr_saved_scan)
+{
+	unsigned long nr;
+
+	*nr_saved_scan += nr_to_scan;
+	nr = *nr_saved_scan;
+
+	if (nr >= SWAP_CLUSTER_MAX)
+		*nr_saved_scan = 0;
+	else
+		nr = 0;
+
+	return nr;
+}
+
+/*
  * Determine how aggressively the anon and file LRU lists should be
  * scanned.  The relative value of each set of LRU lists is determined
  * by looking at the fraction of the pages scanned we did rotate back
  * onto the active list instead of evict.
  *
- * percent[0] specifies how much pressure to put on ram/swap backed
- * memory, while percent[1] determines pressure on the file LRUs.
+ * nr[0] = anon pages to scan; nr[1] = file pages to scan
  */
-static void get_scan_ratio(struct zone *zone, struct scan_control *sc,
-					unsigned long *percent)
+static void get_scan_count(struct zone *zone, struct scan_control *sc,
+					unsigned long *nr, int priority)
 {
 	unsigned long anon, file, free;
 	unsigned long anon_prio, file_prio;
 	unsigned long ap, fp;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
+	u64 fraction[2], denominator;
+	enum lru_list l;
+	int noswap = 0;
+
+	/* If we have no swap space, do not bother scanning anon pages. */
+	if (!sc->may_swap || (nr_swap_pages <= 0)) {
+		noswap = 1;
+		fraction[0] = 0;
+		fraction[1] = 1;
+		denominator = 1;
+		goto out;
+	}
 
 	anon  = zone_nr_lru_pages(zone, sc, LRU_ACTIVE_ANON) +
 		zone_nr_lru_pages(zone, sc, LRU_INACTIVE_ANON);
@@ -1540,9 +1571,10 @@ static void get_scan_ratio(struct zone *
 		/* If we have very few page cache pages,
 		   force-scan anon pages. */
 		if (unlikely(file + free <= high_wmark_pages(zone))) {
-			percent[0] = 100;
-			percent[1] = 0;
-			return;
+			fraction[0] = 1;
+			fraction[1] = 0;
+			denominator = 1;
+			goto out;
 		}
 	}
 
@@ -1589,29 +1621,22 @@ static void get_scan_ratio(struct zone *
 	fp = (file_prio + 1) * (reclaim_stat->recent_scanned[1] + 1);
 	fp /= reclaim_stat->recent_rotated[1] + 1;
 
-	/* Normalize to percentages */
-	percent[0] = 100 * ap / (ap + fp + 1);
-	percent[1] = 100 - percent[0];
-}
-
-/*
- * Smallish @nr_to_scan's are deposited in @nr_saved_scan,
- * until we collected @swap_cluster_max pages to scan.
- */
-static unsigned long nr_scan_try_batch(unsigned long nr_to_scan,
-				       unsigned long *nr_saved_scan)
-{
-	unsigned long nr;
-
-	*nr_saved_scan += nr_to_scan;
-	nr = *nr_saved_scan;
-
-	if (nr >= SWAP_CLUSTER_MAX)
-		*nr_saved_scan = 0;
-	else
-		nr = 0;
+	fraction[0] = ap;
+	fraction[1] = fp;
+	denominator = ap + fp + 1;
+out:
+	for_each_evictable_lru(l) {
+		int file = is_file_lru(l);
+		unsigned long scan;
 
-	return nr;
+		scan = zone_nr_lru_pages(zone, sc, l);
+		if (priority || noswap) {
+			scan >>= priority;
+			scan = div64_u64(scan * fraction[file], denominator);
+		}
+		nr[l] = nr_scan_try_batch(scan,
+					  &reclaim_stat->nr_saved_scan[l]);
+	}
 }
 
 /*
@@ -1622,33 +1647,11 @@ static void shrink_zone(int priority, st
 {
 	unsigned long nr[NR_LRU_LISTS];
 	unsigned long nr_to_scan;
-	unsigned long percent[2];	/* anon @ 0; file @ 1 */
 	enum lru_list l;
 	unsigned long nr_reclaimed = sc->nr_reclaimed;
 	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
-	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
-	int noswap = 0;
-
-	/* If we have no swap space, do not bother scanning anon pages. */
-	if (!sc->may_swap || (nr_swap_pages <= 0)) {
-		noswap = 1;
-		percent[0] = 0;
-		percent[1] = 100;
-	} else
-		get_scan_ratio(zone, sc, percent);
 
-	for_each_evictable_lru(l) {
-		int file = is_file_lru(l);
-		unsigned long scan;
