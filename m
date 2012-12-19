From: akpm@linux-foundation.org
Subject: [merged] mm-avoid-possible-deadlock-caused-by-too_many_isolated.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:42:56 -0800
Message-ID: <20121219204256.D6A50100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:35748 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351Ab2LSUm6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:42:58 -0500
Received: by mail-yh0-f73.google.com with SMTP id 47so277821yhr.2
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:42:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, hannes@cmpxchg.org, just.for.lkml@googlemail.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, neilb@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan.c: avoid possible deadlock caused by too_many_isolated()
has been removed from the -mm tree.  Its filename was
     mm-avoid-possible-deadlock-caused-by-too_many_isolated.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: mm/vmscan.c: avoid possible deadlock caused by too_many_isolated()

Neil found that if too_many_isolated() returns true while performing
direct reclaim we can end up waiting for other threads to complete their
direct reclaim.  If those threads are allowed to enter the FS or IO to
free memory, but this thread is not, then it is possible that those
threads will be waiting on this thread and so we get a circular deadlock.

some task enters direct reclaim with GFP_KERNEL
  => too_many_isolated() false
    => vmscan and run into dirty pages
      => pageout()
        => take some FS lock
	  => fs/block code does GFP_NOIO allocation
	    => enter direct reclaim again
	      => too_many_isolated() true
		  => waiting for others to progress, however the other
		     tasks may be circular waiting for the FS lock..

The fix is to let !__GFP_IO and !__GFP_FS direct reclaims enjoy higher
priority than normal ones, by lowering the throttle threshold for the
latter.

Allowing ~1/8 isolated pages in normal is large enough.  For example, for
a 1GB LRU list, that's ~128MB isolated pages, or 1k blocked tasks (each
isolates 32 4KB pages), or 64 blocked tasks per logical CPU (assuming 16
logical CPUs per NUMA node).  So it's not likely some CPU goes idle
waiting (when it could make progress) because of this limit: there are
much more sleeping reclaim tasks than the number of CPU, so the task may
well be blocked by some low level queue/lock anyway.

Now !GFP_IOFS reclaims won't be waiting for GFP_IOFS reclaims to progress.
 They will be blocked only when there are too many concurrent !GFP_IOFS
reclaims, however that's very unlikely because the IO-less direct reclaims
is able to progress much more faster, and they won't deadlock each other. 
The threshold is raised high enough for them, so that there can be
sufficient parallel progress of !GFP_IOFS reclaims.

[akpm@linux-foundation.org: tweak comment]
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>
Tested-by: NeilBrown <neilb@suse.de>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/vmscan.c~mm-avoid-possible-deadlock-caused-by-too_many_isolated mm/vmscan.c
--- a/mm/vmscan.c~mm-avoid-possible-deadlock-caused-by-too_many_isolated
+++ a/mm/vmscan.c
@@ -1202,6 +1202,14 @@ static int too_many_isolated(struct zone
 		isolated = zone_page_state(zone, NR_ISOLATED_ANON);
 	}
 
+	/*
+	 * GFP_NOIO/GFP_NOFS callers are allowed to isolate more pages, so they
+	 * won't get blocked by normal direct-reclaimers, forming a circular
+	 * deadlock.
+	 */
+	if ((sc->gfp_mask & GFP_IOFS) == GFP_IOFS)
+		inactive >>= 3;
+
 	return isolated > inactive;
 }
 
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch

