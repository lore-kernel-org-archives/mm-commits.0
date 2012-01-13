From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-do-not-oom-if-aborting-reclaim-to-start-compaction.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:35:08 -0800
Message-ID: <20120113203508.C483B10004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:55057 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759051Ab2AMUfK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:35:10 -0500
Received: by ghrr18 with SMTP id r18so207300ghr.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:35:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aarcange@redhat.com, adi@hexapodia.org, davej@redhat.com, jack@suse.cz, jweiner@redhat.com, minchan.kim@gmail.com, nai.xia@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: do not OOM if aborting reclaim to start compaction
has been removed from the -mm tree.  Its filename was
     mm-vmscan-do-not-oom-if-aborting-reclaim-to-start-compaction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: vmscan: do not OOM if aborting reclaim to start compaction

During direct reclaim it is possible that reclaim will be aborted so that
compaction can be attempted to satisfy a high-order allocation.  If this
decision is made before any pages are reclaimed, it is possible that 0 is
returned to the page allocator potentially triggering an OOM.  This has
not been observed but it is a possibility so this patch addresses it.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Andy Isaacson <adi@hexapodia.org>
Cc: Nai Xia <nai.xia@gmail.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-vmscan-do-not-oom-if-aborting-reclaim-to-start-compaction mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-do-not-oom-if-aborting-reclaim-to-start-compaction
+++ a/mm/vmscan.c
@@ -2263,6 +2263,7 @@ static unsigned long do_try_to_free_page
 	struct zoneref *z;
 	struct zone *zone;
 	unsigned long writeback_threshold;
+	bool should_abort_reclaim;
 
 	get_mems_allowed();
 	delayacct_freepages_start();
@@ -2274,7 +2275,8 @@ static unsigned long do_try_to_free_page
 		sc->nr_scanned = 0;
 		if (!priority)
 			disable_swap_token(sc->target_mem_cgroup);
-		if (shrink_zones(priority, zonelist, sc))
+		should_abort_reclaim = shrink_zones(priority, zonelist, sc);
+		if (should_abort_reclaim)
 			break;
 
 		/*
@@ -2342,6 +2344,10 @@ out:
 	if (oom_killer_disabled)
 		return 0;
 
+	/* Aborting reclaim to try compaction? don't OOM, then */
+	if (should_abort_reclaim)
+		return 1;
+
 	/* top priority shrink_zones still had more to do? don't OOM, then */
 	if (global_reclaim(sc) && !all_unreclaimable(zonelist, sc))
 		return 1;
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-fix-null-ptr-dereference-in-__count_immobile_pages.patch
mm-__count_immobile_pages-make-sure-the-node-is-online.patch

