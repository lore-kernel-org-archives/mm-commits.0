From: akpm@linux-foundation.org
Subject: [merged] mm-wake-kcompactd-before-kswapds-short-sleep.patch
 removed from -mm tree
Date: Fri, 29 Apr 2016 15:05:36 -0700
Message-ID: <5723dab0.98w4+JtsPC5tbO4P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45442 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094AbcD2WFh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2016 18:05:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, aarcange@redhat.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@suse.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: wake kcompactd before kswapd's short sleep
has been removed from the -mm tree.  Its filename was
     mm-wake-kcompactd-before-kswapds-short-sleep.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm: wake kcompactd before kswapd's short sleep

When kswapd goes to sleep it checks if the node is balanced and at first
it sleeps only for HZ/10 time, then rechecks if the node is still balanced
and nobody has woken it during the initial sleep.  Only then it goes fully
sleep until an allocation slowpath wakes it up again.

For higher-order allocations, waking up kcompactd is done only before the
full sleep.  This turns out to be an issue in case another high-order
allocation fails during the initial sleep.  It will wake kswapd up,
however kswapd considers the zone balanced from the order-0 perspective,
and will just quickly try to sleep again.  So if there's a longer stream
of high-order allocations hitting the slowpath and waking up kswapd, it
might never actually wake up kcompactd, which may be considered a
regression from kswapd-based compaction.  In the worst case, it might be
that a single allocation that cannot direct reclaim/compact itself is
waking kswapd in the retry loop and preventing kcompactd from being woken
up and unblocking it.

This patch makes sure kcompactd is woken up in such situations by simply
moving the wakeup before the short initial sleep.  More efficient solution
would be to wake kcompactd immediately instead of kswapd if the node is
already order-0 balanced, but in that case we should also move
reset_isolation_suitable() call to kcompactd so it's not adding to the
allocator's latency.  Since it's late in the 4.6 cycle, let's go with the
simpler change for now.

Fixes: accf62422b3a ("mm, kswapd: replace kswapd compaction with waking up kcompactd")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff -puN mm/vmscan.c~mm-wake-kcompactd-before-kswapds-short-sleep mm/vmscan.c
--- a/mm/vmscan.c~mm-wake-kcompactd-before-kswapds-short-sleep
+++ a/mm/vmscan.c
@@ -3318,6 +3318,20 @@ static void kswapd_try_to_sleep(pg_data_
 	/* Try to sleep for a short interval */
 	if (prepare_kswapd_sleep(pgdat, order, remaining,
 						balanced_classzone_idx)) {
+		/*
+		 * Compaction records what page blocks it recently failed to
+		 * isolate pages from and skips them in the future scanning.
+		 * When kswapd is going to sleep, it is reasonable to assume
+		 * that pages and compaction may succeed so reset the cache.
+		 */
+		reset_isolation_suitable(pgdat);
+
+		/*
+		 * We have freed the memory, now we should compact it to make
+		 * allocation of the requested order possible.
+		 */
+		wakeup_kcompactd(pgdat, order, classzone_idx);
+
 		remaining = schedule_timeout(HZ/10);
 		finish_wait(&pgdat->kswapd_wait, &wait);
 		prepare_to_wait(&pgdat->kswapd_wait, &wait, TASK_INTERRUPTIBLE);
@@ -3341,20 +3355,6 @@ static void kswapd_try_to_sleep(pg_data_
 		 */
 		set_pgdat_percpu_threshold(pgdat, calculate_normal_threshold);
 
-		/*
-		 * Compaction records what page blocks it recently failed to
-		 * isolate pages from and skips them in the future scanning.
-		 * When kswapd is going to sleep, it is reasonable to assume
-		 * that pages and compaction may succeed so reset the cache.
-		 */
-		reset_isolation_suitable(pgdat);
-
-		/*
-		 * We have freed the memory, now we should compact it to make
-		 * allocation of the requested order possible.
-		 */
-		wakeup_kcompactd(pgdat, order, classzone_idx);
