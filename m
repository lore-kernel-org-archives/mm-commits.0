From: akpm@linux-foundation.org
Subject: + mm-compaction-fix-special-case-1-order-checks.patch added to -mm tree
Date: Mon, 06 Jun 2011 15:18:28 -0700
Message-ID: <201106062218.p56MISLi026095@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44175 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751772Ab1FFWTI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jun 2011 18:19:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, kamezawa.hioryu@jp.fujitsu.com, mgorman@suse.de, minchan.kim@gmail.com


The patch titled
     mm: compaction: fix special case -1 order checks
has been added to the -mm tree.  Its filename is
     mm-compaction-fix-special-case-1-order-checks.patch

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
Subject: mm: compaction: fix special case -1 order checks
From: Michal Hocko <mhocko@suse.cz>

56de7263 ("mm: compaction: direct compact when a high-order allocation
fails") introduced a check for cc->order == -1 in compact_finished.  We
should continue compacting in that case because the request came from
userspace and there is no particular order to compact for.  Similar check
has been added by 82478fb7 (mm: compaction: prevent division-by-zero
during user-requested compaction) for compaction_suitable.

The check is, however, done after zone_watermark_ok which uses order as a
right hand argument for shifts.  Not only watermark check is pointless if
we can break out without it but it also uses 1 << -1 which is not well
defined (at least from C standard).  Let's move the -1 check above
zone_watermark_ok.

[minchan.kim@gmail.com> - caught compaction_suitable]
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hioryu@jp.fujitsu.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff -puN mm/compaction.c~mm-compaction-fix-special-case-1-order-checks mm/compaction.c
--- a/mm/compaction.c~mm-compaction-fix-special-case-1-order-checks
+++ a/mm/compaction.c
@@ -420,13 +420,6 @@ static int compact_finished(struct zone 
 	if (cc->free_pfn <= cc->migrate_pfn)
 		return COMPACT_COMPLETE;
 
-	/* Compaction run is not finished if the watermark is not met */
-	watermark = low_wmark_pages(zone);
-	watermark += (1 << cc->order);
-
-	if (!zone_watermark_ok(zone, cc->order, watermark, 0, 0))
-		return COMPACT_CONTINUE;
-
 	/*
 	 * order == -1 is expected when compacting via
 	 * /proc/sys/vm/compact_memory
@@ -434,6 +427,13 @@ static int compact_finished(struct zone 
 	if (cc->order == -1)
 		return COMPACT_CONTINUE;
 
+	/* Compaction run is not finished if the watermark is not met */
+	watermark = low_wmark_pages(zone);
+	watermark += (1 << cc->order);
+
+	if (!zone_watermark_ok(zone, cc->order, watermark, 0, 0))
+		return COMPACT_CONTINUE;
+
 	/* Direct compactor: Is a suitable page free? */
 	for (order = cc->order; order < MAX_ORDER; order++) {
 		/* Job done if page is free of the right migratetype */
@@ -461,6 +461,13 @@ unsigned long compaction_suitable(struct
 	unsigned long watermark;
 
 	/*
+	 * order == -1 is expected when compacting via
+	 * /proc/sys/vm/compact_memory
+	 */
+	if (order == -1)
+		return COMPACT_CONTINUE;
+
+	/*
 	 * Watermarks for order-0 must be met for compaction. Note the 2UL.
 	 * This is because during migration, copies of pages need to be
 	 * allocated and for a short time, the footprint is higher
@@ -470,13 +477,6 @@ unsigned long compaction_suitable(struct
 		return COMPACT_SKIPPED;
 
 	/*
-	 * order == -1 is expected when compacting via
-	 * /proc/sys/vm/compact_memory
-	 */
-	if (order == -1)
-		return COMPACT_CONTINUE;
