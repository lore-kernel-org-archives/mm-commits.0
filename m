From: akpm@linux-foundation.org
Subject: + mm-avoid-throttling-reclaim-for-loop-back-nfsd-threads.patch
 added to -mm tree
Date: Thu, 24 Apr 2014 11:09:47 -0700
Message-ID: <5359536b.3KPR4QaYRlzzMAdz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38190 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757656AbaDXSJs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Apr 2014 14:09:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mel@csn.ul.ie, hannes@cmpxchg.org, neilb@suse.de

Subject: + mm-avoid-throttling-reclaim-for-loop-back-nfsd-threads.patch added to -mm tree
To: neilb@suse.de,hannes@cmpxchg.org,mel@csn.ul.ie
From: akpm@linux-foundation.org
Date: Thu, 24 Apr 2014 11:09:47 -0700


The patch titled
     Subject: mm/vmscan.c: avoid throttling reclaim for loop-back nfsd threads
has been added to the -mm tree.  Its filename is
     mm-avoid-throttling-reclaim-for-loop-back-nfsd-threads.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-avoid-throttling-reclaim-for-loop-back-nfsd-threads.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-avoid-throttling-reclaim-for-loop-back-nfsd-threads.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: mm/vmscan.c: avoid throttling reclaim for loop-back nfsd threads

When a loopback NFS mount is active and the backing device for the NFS
mount becomes congested, that can impose throttling delays on the nfsd
threads.

These delays significantly reduce throughput and so the NFS mount remains
congested.

This results in a livelock and the reduced throughput persists.

This livelock has been found in testing with the 'wait_iff_congested'
call, and could possibly be caused by the 'congestion_wait' call.

This livelock is similar to the deadlock which justified the introduction
of PF_LESS_THROTTLE, and the same flag can be used to remove this
livelock.

To minimise the impact of the change, we still throttle nfsd when the
filesystem it is writing to is congested, but not when some separate
filesystem (e.g.  the NFS filesystem) is congested.

Signed-off-by: NeilBrown <neilb@suse.de>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~mm-avoid-throttling-reclaim-for-loop-back-nfsd-threads mm/vmscan.c
--- a/mm/vmscan.c~mm-avoid-throttling-reclaim-for-loop-back-nfsd-threads
+++ a/mm/vmscan.c
@@ -1442,6 +1442,19 @@ putback_inactive_pages(struct lruvec *lr
 }
 
 /*
+ * If a kernel thread (such as nfsd for loop-back mounts) services
+ * a backing device by writing to the page cache it sets PF_LESS_THROTTLE.
+ * In that case we should only throttle if the backing device it is
+ * writing to is congested.  In other cases it is safe to throttle.
+ */
+static int current_may_throttle(void)
+{
+	return !(current->flags & PF_LESS_THROTTLE) ||
+		current->backing_dev_info == NULL ||
+		bdi_write_congested(current->backing_dev_info);
+}
+
+/*
  * shrink_inactive_list() is a helper for shrink_zone().  It returns the number
  * of reclaimed pages
  */
@@ -1569,7 +1582,8 @@ shrink_inactive_list(unsigned long nr_to
 		 * implies that pages are cycling through the LRU faster than
 		 * they are written so also forcibly stall.
 		 */
-		if (nr_unqueued_dirty == nr_taken || nr_immediate)
+		if ((nr_unqueued_dirty == nr_taken || nr_immediate) &&
+		    current_may_throttle())
 			congestion_wait(BLK_RW_ASYNC, HZ/10);
 	}
 
@@ -1578,7 +1592,8 @@ shrink_inactive_list(unsigned long nr_to
 	 * is congested. Allow kswapd to continue until it starts encountering
 	 * unqueued dirty pages or cycling through the LRU too quickly.
 	 */
-	if (!sc->hibernation_mode && !current_is_kswapd())
+	if (!sc->hibernation_mode && !current_is_kswapd() &&
+	    current_may_throttle())
 		wait_iff_congested(zone, BLK_RW_ASYNC, HZ/10);
 
 	trace_mm_vmscan_lru_shrink_inactive(zone->zone_pgdat->node_id,
_

Patches currently in -mm which might be from neilb@suse.de are

mm-avoid-throttling-reclaim-for-loop-back-nfsd-threads.patch
linux-next.patch

