From: akpm@linux-foundation.org
Subject: + mm-compaction-handle-active-and-inactive-fairly-in-too_many_isolated.patch added to -mm tree
Date: Fri, 03 Sep 2010 16:59:00 -0700
Message-ID: <201009032359.o83Nx0k1020096@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752603Ab0IDAAu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Sep 2010 20:00:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, fengguang.wu@intel.com, iram.shahzad@jp.fujitsu.com, mel@csn.ul.ie, stable@kernel.org


The patch titled
     mm: compaction: handle active and inactive fairly in too_many_isolated
has been added to the -mm tree.  Its filename is
     mm-compaction-handle-active-and-inactive-fairly-in-too_many_isolated.patch

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
Subject: mm: compaction: handle active and inactive fairly in too_many_isolated
From: Minchan Kim <minchan.kim@gmail.com>

Iram reported that compaction's too_many_isolated() loops forever. 
(http://www.spinics.net/lists/linux-mm/msg08123.html)

The meminfo when the situation happened was inactive anon is zero.  That's
because the system has no memory pressure until then.  While all anon
pages were in the active lru, compaction could select active lru as well
as inactive lru.  That's a different thing from vmscan's isolated.  So we
has been two too_many_isolated.

While compaction can isolate pages in both active and inactive, current
implementation of too_many_isolated only considers inactive.  It made
Iram's problem.

This patch handles active and inactive fairly.  That's because we can't
expect where from and how many compaction would isolated pages.

This patch changes (nr_isolated > nr_inactive) with
nr_isolated > (nr_active + nr_inactive) / 2.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Reported-by: Iram Shahzad <iram.shahzad@jp.fujitsu.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/compaction.c~mm-compaction-handle-active-and-inactive-fairly-in-too_many_isolated mm/compaction.c
--- a/mm/compaction.c~mm-compaction-handle-active-and-inactive-fairly-in-too_many_isolated
+++ a/mm/compaction.c
@@ -214,15 +214,16 @@ static void acct_isolated(struct zone *z
 /* Similar to reclaim, but different enough that they don't share logic */
 static bool too_many_isolated(struct zone *zone)
 {
-
-	unsigned long inactive, isolated;
+	unsigned long active, inactive, isolated;
 
 	inactive = zone_page_state(zone, NR_INACTIVE_FILE) +
 					zone_page_state(zone, NR_INACTIVE_ANON);
+	active = zone_page_state(zone, NR_ACTIVE_FILE) +
+					zone_page_state(zone, NR_ACTIVE_ANON);
 	isolated = zone_page_state(zone, NR_ISOLATED_FILE) +
 					zone_page_state(zone, NR_ISOLATED_ANON);
 
-	return isolated > inactive;
+	return isolated > (inactive + active) / 2;
 }
 
 /*
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

mm-compaction-handle-active-and-inactive-fairly-in-too_many_isolated.patch
vmstat-update-zone-stat-threshold-when-onlining-a-cpu.patch
mm-page-allocator-update-free-page-counters-after-pages-are-placed-on-the-free-list.patch
mm-page-allocator-update-free-page-counters-after-pages-are-placed-on-the-free-list-fix.patch
mm-page-allocator-drain-per-cpu-lists-after-direct-reclaim-allocation-fails.patch
vmscan-prevent-background-aging-of-anon-page-in-no-swap-system.patch
mm-vmap-area-cache.patch

