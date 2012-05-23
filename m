From: akpm@linux-foundation.org
Subject: + mm-avoid-swapping-out-with-swappiness==0.patch added to -mm tree
Date: Wed, 23 May 2012 14:51:50 -0700
Message-ID: <20120523215151.2D055A03B2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:64638 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760814Ab2EWVvw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 May 2012 17:51:52 -0400
Received: by vbnl22 with SMTP id l22so941672vbn.1
        for <mm-commits@vger.kernel.org>; Wed, 23 May 2012 14:51:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: satoru.moriya@hds.com, minchan@kernel.org, riel@redhat.com


The patch titled
     Subject: mm: avoid swapping out with swappiness==0
has been added to the -mm tree.  Its filename is
     mm-avoid-swapping-out-with-swappiness==0.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: mm: avoid swapping out with swappiness==0

Patches currently in -mm which might be from satoru.moriya@hds.com are

linux-next.patch
mm-avoid-swapping-out-with-swappiness==0.patch

