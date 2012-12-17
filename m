From: akpm@linux-foundation.org
Subject: + mm-avoid-possible-deadlock-caused-by-too_many_isolated.patch added to -mm tree
Date: Mon, 17 Dec 2012 13:47:24 -0800
Message-ID: <20121217214725.D2DD3200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:40727 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab2LQVr3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Dec 2012 16:47:29 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt14so351173wgb.1
        for <mm-commits@vger.kernel.org>; Mon, 17 Dec 2012 13:47:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, hannes@cmpxchg.org, just.for.lkml@googlemail.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, neilb@suse.de, riel@redhat.com


The patch titled
     Subject: mm/vmscan.c: avoid possible deadlock caused by too_many_isolated()
has been added to the -mm tree.  Its filename is
     mm-avoid-possible-deadlock-caused-by-too_many_isolated.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 mm/vmscan.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN mm/vmscan.c~mm-avoid-possible-deadlock-caused-by-too_many_isolated mm/vmscan.c
--- a/mm/vmscan.c~mm-avoid-possible-deadlock-caused-by-too_many_isolated
+++ a/mm/vmscan.c
@@ -1202,6 +1202,13 @@ static int too_many_isolated(struct zone
 		isolated = zone_page_state(zone, NR_ISOLATED_ANON);
 	}
 
+	/*
+	 * GFP_NOIO/GFP_NOFS callers are allowed to isolate more pages, so that
+	 * they won't get blocked by normal ones and form circular deadlock.
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
h8300-select-generic-atomic64_t-support.patch
vmscan-comment-too_many_isolated.patch
mm-avoid-possible-deadlock-caused-by-too_many_isolated.patch
mm-avoid-possible-deadlock-caused-by-too_many_isolated-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes-fix.patch
fs-notify-add-procfs-fdinfo-helper-v7-fix-fix.patch

