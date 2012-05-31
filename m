From: akpm@linux-foundation.org
Subject: [merged] mm-avoid-swapping-out-with-swappiness==0.patch removed from -mm tree
Date: Thu, 31 May 2012 12:16:20 -0700
Message-ID: <20120531191620.72435A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:33169 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932949Ab2EaTQV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:16:21 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so134565ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:16:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: satoru.moriya@hds.com, jmarchan@redhat.com, minchan@kernel.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: avoid swapping out with swappiness==0
has been removed from the -mm tree.  Its filename was
     mm-avoid-swapping-out-with-swappiness==0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Satoru Moriya <satoru.moriya@hds.com>
Subject: mm: avoid swapping out with swappiness==0

Sometimes we'd like to avoid swapping out anonymous memory in particular,
avoid swapping out pages of important process or process groups while
there is a reasonable amount of pagecache on RAM so that we can satisfy
our customers' requirements.

OTOH, we can control how aggressive the kernel will swap memory pages with
/proc/sys/vm/swappiness for global and
/sys/fs/cgroup/memory/memory.swappiness for each memcg.

But with current reclaim implementation, the kernel may swap out even if
we set swappiness=0 and there is pagecache in RAM.

This patch changes the behavior with swappiness==0.  If we set
swappiness==0, the kernel does not swap out completely (for global reclaim
until the amount of free pages and filebacked pages in a zone has been
reduced to something very very small (nr_free + nr_filebacked < high
watermark)).

Signed-off-by: Satoru Moriya <satoru.moriya@hds.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/vmscan.c~mm-avoid-swapping-out-with-swappiness==0 mm/vmscan.c
--- a/mm/vmscan.c~mm-avoid-swapping-out-with-swappiness==0
+++ a/mm/vmscan.c
@@ -1761,10 +1761,10 @@ static void get_scan_count(struct mem_cg
 	 * proportional to the fraction of recently scanned pages on
 	 * each list that were recently referenced and in active use.
 	 */
-	ap = (anon_prio + 1) * (reclaim_stat->recent_scanned[0] + 1);
+	ap = anon_prio * (reclaim_stat->recent_scanned[0] + 1);
 	ap /= reclaim_stat->recent_rotated[0] + 1;
 
-	fp = (file_prio + 1) * (reclaim_stat->recent_scanned[1] + 1);
+	fp = file_prio * (reclaim_stat->recent_scanned[1] + 1);
 	fp /= reclaim_stat->recent_rotated[1] + 1;
 	spin_unlock_irq(&mz->zone->lru_lock);
 
@@ -1777,7 +1777,7 @@ out:
 		unsigned long scan;
 
 		scan = zone_nr_lru_pages(mz, lru);
-		if (priority || noswap) {
+		if (priority || noswap || !vmscan_swappiness(mz, sc)) {
 			scan >>= priority;
 			if (!scan && force_scan)
 				scan = SWAP_CLUSTER_MAX;
_

Patches currently in -mm which might be from satoru.moriya@hds.com are

origin.patch
linux-next.patch

