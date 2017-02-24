From: akpm@linux-foundation.org
Subject: [patch 014/124] mm: vmscan: kick flushers when we encounter dirty pages on the LRU
Date: Fri, 24 Feb 2017 14:56:14 -0800
Message-ID: <58b0ba0e.8qugzs+gMbB6wvDT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37104 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751268AbdBXW4Q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:56:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, mgorman@suse.de, mhocko@suse.com, minchan@kernel.org, riel@redhat.com

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmscan: kick flushers when we encounter dirty pages on the LRU

Memory pressure can put dirty pages at the end of the LRU without anybody
running into dirty limits.  Don't start writing individual pages from
kswapd while the flushers might be asleep.

Unlike the old direct reclaim flusher wakeup (removed in the next patch)
that flushes the number of pages just scanned, this patch wakes the
flushers for all outstanding dirty pages.  That seemed to perform better
in a synthetic test that pushes dirty pages to the end of the LRU and into
reclaim, because we know LRU aging outstrips writeback already, and this
way we give younger dirty pages a headstart rather than wait until reclaim
runs into them as well.  It also means less plugging and risk of
exhausting the struct request pool from reclaim.

There is a concern that this will cause temporary files that used to get
dirtied and truncated before writeback to now get written to disk under
memory pressure.  If this turns out to be a real problem, we'll have to
revisit this and tame the reclaim flusher wakeups.

[hannes@cmpxchg.org: mention dirty expiration as a condition]
  Link: http://lkml.kernel.org/r/20170126174739.GA30636@cmpxchg.org
Link: http://lkml.kernel.org/r/20170123181641.23938-3-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
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
+		 * happen when memory pressure pushes dirty pages to the end of
+		 * the LRU before the dirty limits are breached and the dirty
+		 * data has expired. It can also happen when the proportion of
+		 * dirty pages grows not through writes but through memory
+		 * pressure reclaiming all the clean cache. And in some cases,
+		 * the flushers simply cannot keep up with the allocation
+		 * rate. Nudge the flusher threads in case they are asleep, but
+		 * also allow kswapd to start writing pages during reclaim.
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
