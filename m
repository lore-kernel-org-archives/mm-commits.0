From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-kick-flushers-when-we-encounter-dirty-pages-on-the-lru.patch
 added to -mm tree
Date: Mon, 23 Jan 2017 14:21:25 -0800
Message-ID: <588681e5.yz2g97hAooMfUL0T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42946 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751571AbdAWWV0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jan 2017 17:21:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mgorman@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: kick flushers when we encounter dirty pages on the LRU
has been added to the -mm tree.  Its filename is
     mm-vmscan-kick-flushers-when-we-encounter-dirty-pages-on-the-lru.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-kick-flushers-when-we-encounter-dirty-pages-on-the-lru.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-kick-flushers-when-we-encounter-dirty-pages-on-the-lru.patch

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
Subject: mm: vmscan: kick flushers when we encounter dirty pages on the LRU

Memory pressure can put dirty pages at the end of the LRU without anybody
running into dirty limits.  Don't start writing individual pages from
kswapd while the flushers might be asleep.

Link: http://lkml.kernel.org/r/20170123181641.23938-3-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/writeback.h        |    2 +-
 include/trace/events/writeback.h |    2 +-
 mm/vmscan.c                      |   18 +++++++++++++-----
 3 files changed, 15 insertions(+), 7 deletions(-)

diff -puN include/linux/writeback.h~mm-vmscan-kick-flushers-when-we-encounter-dirty-pages-on-the-lru include/linux/writeback.h
--- a/include/linux/writeback.h~mm-vmscan-kick-flushers-when-we-encounter-dirty-pages-on-the-lru
+++ a/include/linux/writeback.h
@@ -46,7 +46,7 @@ enum writeback_sync_modes {
  */
 enum wb_reason {
 	WB_REASON_BACKGROUND,
-	WB_REASON_TRY_TO_FREE_PAGES,
+	WB_REASON_VMSCAN,
 	WB_REASON_SYNC,
 	WB_REASON_PERIODIC,
 	WB_REASON_LAPTOP_TIMER,
diff -puN include/trace/events/writeback.h~mm-vmscan-kick-flushers-when-we-encounter-dirty-pages-on-the-lru include/trace/events/writeback.h
--- a/include/trace/events/writeback.h~mm-vmscan-kick-flushers-when-we-encounter-dirty-pages-on-the-lru
+++ a/include/trace/events/writeback.h
@@ -31,7 +31,7 @@
 
 #define WB_WORK_REASON							\
 	EM( WB_REASON_BACKGROUND,		"background")		\
-	EM( WB_REASON_TRY_TO_FREE_PAGES,	"try_to_free_pages")	\
+	EM( WB_REASON_VMSCAN,			"vmscan")		\
 	EM( WB_REASON_SYNC,			"sync")			\
 	EM( WB_REASON_PERIODIC,			"periodic")		\
 	EM( WB_REASON_LAPTOP_TIMER,		"laptop_timer")		\
diff -puN mm/vmscan.c~mm-vmscan-kick-flushers-when-we-encounter-dirty-pages-on-the-lru mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-kick-flushers-when-we-encounter-dirty-pages-on-the-lru
+++ a/mm/vmscan.c
@@ -1798,12 +1798,20 @@ shrink_inactive_list(unsigned long nr_to
 
 		/*
 		 * If dirty pages are scanned that are not queued for IO, it
-		 * implies that flushers are not keeping up. In this case, flag
-		 * the pgdat PGDAT_DIRTY and kswapd will start writing pages from
-		 * reclaim context.
+		 * implies that flushers are not doing their job. This can
+		 * happen when memory pressure pushes dirty pages to the end
+		 * of the LRU without the dirty limits being breached. It can
+		 * also happen when the proportion of dirty pages grows not
+		 * through writes but through memory pressure reclaiming all
+		 * the clean cache. And in some cases, the flushers simply
+		 * cannot keep up with the allocation rate. Nudge the flusher
+		 * threads in case they are asleep, but also allow kswapd to
+		 * start writing pages during reclaim.
 		 */
-		if (stat.nr_unqueued_dirty == nr_taken)
+		if (stat.nr_unqueued_dirty == nr_taken) {
+			wakeup_flusher_threads(0, WB_REASON_VMSCAN);
 			set_bit(PGDAT_DIRTY, &pgdat->flags);
+		}
 
 		/*
 		 * If kswapd scans pages marked marked for immediate
@@ -2787,7 +2795,7 @@ retry:
 		writeback_threshold = sc->nr_to_reclaim + sc->nr_to_reclaim / 2;
 		if (total_scanned > writeback_threshold) {
 			wakeup_flusher_threads(laptop_mode ? 0 : total_scanned,
-						WB_REASON_TRY_TO_FREE_PAGES);
+						WB_REASON_VMSCAN);
 			sc->may_writepage = 1;
 		}
 	} while (--sc->priority >= 0);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-vmscan-scan-dirty-pages-even-in-laptop-mode.patch
mm-vmscan-kick-flushers-when-we-encounter-dirty-pages-on-the-lru.patch
mm-vmscan-remove-old-flusher-wakeup-from-direct-reclaim-path.patch
mm-vmscan-only-write-dirty-pages-that-the-scanner-has-seen-twice.patch
mm-vmscan-move-dirty-pages-out-of-the-way-until-theyre-flushed.patch

