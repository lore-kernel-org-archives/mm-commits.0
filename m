From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-kick-flushers-when-we-encounter-dirty-pages-on-the-lru-fix.patch
 added to -mm tree
Date: Thu, 26 Jan 2017 14:53:59 -0800
Message-ID: <588a7e07.x6eP8RIr9RcINhP4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51422 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752313AbdAZXBR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2017 18:01:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: kick flushers when we encounter dirty pages on the LRU fix
has been added to the -mm tree.  Its filename is
     mm-vmscan-kick-flushers-when-we-encounter-dirty-pages-on-the-lru-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-kick-flushers-when-we-encounter-dirty-pages-on-the-lru-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-kick-flushers-when-we-encounter-dirty-pages-on-the-lru-fix.patch

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
Subject: mm: vmscan: kick flushers when we encounter dirty pages on the LRU fix

Mention dirty expiration as a condition: we need dirty data that is too
recent for periodic flushing and not large enough for waking up limit
flushing.  As per Mel.

Link: http://lkml.kernel.org/r/20170126174739.GA30636@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-kick-flushers-when-we-encounter-dirty-pages-on-the-lru-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-kick-flushers-when-we-encounter-dirty-pages-on-the-lru-fix
+++ a/mm/vmscan.c
@@ -1799,14 +1799,14 @@ shrink_inactive_list(unsigned long nr_to
 		/*
 		 * If dirty pages are scanned that are not queued for IO, it
 		 * implies that flushers are not doing their job. This can
-		 * happen when memory pressure pushes dirty pages to the end
-		 * of the LRU without the dirty limits being breached. It can
-		 * also happen when the proportion of dirty pages grows not
-		 * through writes but through memory pressure reclaiming all
-		 * the clean cache. And in some cases, the flushers simply
-		 * cannot keep up with the allocation rate. Nudge the flusher
-		 * threads in case they are asleep, but also allow kswapd to
-		 * start writing pages during reclaim.
+		 * happen when memory pressure pushes dirty pages to the end of
+		 * the LRU before the dirty limits are breached and the dirty
+		 * data has expired. It can also happen when the proportion of
+		 * dirty pages grows not through writes but through memory
+		 * pressure reclaiming all the clean cache. And in some cases,
+		 * the flushers simply cannot keep up with the allocation
+		 * rate. Nudge the flusher threads in case they are asleep, but
+		 * also allow kswapd to start writing pages during reclaim.
 		 */
 		if (stat.nr_unqueued_dirty == nr_taken) {
 			wakeup_flusher_threads(0, WB_REASON_VMSCAN);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-vmscan-scan-dirty-pages-even-in-laptop-mode.patch
mm-vmscan-kick-flushers-when-we-encounter-dirty-pages-on-the-lru.patch
mm-vmscan-kick-flushers-when-we-encounter-dirty-pages-on-the-lru-fix.patch
mm-vmscan-remove-old-flusher-wakeup-from-direct-reclaim-path.patch
mm-vmscan-only-write-dirty-pages-that-the-scanner-has-seen-twice.patch
mm-vmscan-move-dirty-pages-out-of-the-way-until-theyre-flushed.patch

