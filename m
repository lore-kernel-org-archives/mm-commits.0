From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-remove-old-flusher-wakeup-from-direct-reclaim-path.patch added to -mm tree
Date: Mon, 23 Jan 2017 14:21:28 -0800
Message-ID: <588681e8.sVrfikY5WKTyGEE+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42954 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751823AbdAWWV3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jan 2017 17:21:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mgorman@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: remove old flusher wakeup from direct reclaim path
has been added to the -mm tree.  Its filename is
     mm-vmscan-remove-old-flusher-wakeup-from-direct-reclaim-path.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-remove-old-flusher-wakeup-from-direct-reclaim-path.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-remove-old-flusher-wakeup-from-direct-reclaim-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmscan: remove old flusher wakeup from direct reclaim path

Direct reclaim has been replaced by kswapd reclaim in pretty much all
common memory pressure situations, so this code most likely doesn't
accomplish the described effect anymore.  The previous patch wakes up
flushers for all reclaimers when we encounter dirty pages at the tail end
of the LRU.  Remove the crufty old direct reclaim invocation.

Link: http://lkml.kernel.org/r/20170123181641.23938-4-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   17 -----------------
 1 file changed, 17 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-remove-old-flusher-wakeup-from-direct-reclaim-path mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-remove-old-flusher-wakeup-from-direct-reclaim-path
+++ a/mm/vmscan.c
@@ -2757,8 +2757,6 @@ static unsigned long do_try_to_free_page
 					  struct scan_control *sc)
 {
 	int initial_priority = sc->priority;
-	unsigned long total_scanned = 0;
-	unsigned long writeback_threshold;
 retry:
 	delayacct_freepages_start();
 
@@ -2771,7 +2769,6 @@ retry:
 		sc->nr_scanned = 0;
 		shrink_zones(zonelist, sc);
 
-		total_scanned += sc->nr_scanned;
 		if (sc->nr_reclaimed >= sc->nr_to_reclaim)
 			break;
 
@@ -2784,20 +2781,6 @@ retry:
 		 */
 		if (sc->priority < DEF_PRIORITY - 2)
 			sc->may_writepage = 1;
-
-		/*
-		 * Try to write back as many pages as we just scanned.  This
-		 * tends to cause slow streaming writers to write data to the
-		 * disk smoothly, at the dirtying rate, which is nice.   But
-		 * that's undesirable in laptop mode, where we *want* lumpy
-		 * writeout.  So in laptop mode, write out the whole world.
-		 */
-		writeback_threshold = sc->nr_to_reclaim + sc->nr_to_reclaim / 2;
-		if (total_scanned > writeback_threshold) {
-			wakeup_flusher_threads(laptop_mode ? 0 : total_scanned,
-						WB_REASON_VMSCAN);
-			sc->may_writepage = 1;
-		}
 	} while (--sc->priority >= 0);
 
 	delayacct_freepages_end();
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-vmscan-scan-dirty-pages-even-in-laptop-mode.patch
mm-vmscan-kick-flushers-when-we-encounter-dirty-pages-on-the-lru.patch
mm-vmscan-remove-old-flusher-wakeup-from-direct-reclaim-path.patch
mm-vmscan-only-write-dirty-pages-that-the-scanner-has-seen-twice.patch
mm-vmscan-move-dirty-pages-out-of-the-way-until-theyre-flushed.patch

