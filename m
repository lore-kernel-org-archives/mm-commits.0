From: akpm@linux-foundation.org
Subject: [merged] mm-compactionc-fix-deferring-compaction-mistake.patch removed from -mm tree
Date: Fri, 24 Aug 2012 11:41:35 -0700
Message-ID: <20120824184135.BDA84100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:36459 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759564Ab2HXSlg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Aug 2012 14:41:36 -0400
Received: by ghbz15 with SMTP id z15so311246ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Aug 2012 11:41:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction.c: fix deferring compaction mistake
has been removed from the -mm tree.  Its filename was
     mm-compactionc-fix-deferring-compaction-mistake.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm/compaction.c: fix deferring compaction mistake

aff62249 ("vmscan: only defer compaction for failed order and higher")
fixed bad deferring policy but made mistake about checking
compact_order_failed in __compact_pgdat().  So it can't update
compact_order_failed with the new order.  This ends up preventing correct
operation of policy deferral.  This patch fixes it.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-compactionc-fix-deferring-compaction-mistake mm/compaction.c
--- a/mm/compaction.c~mm-compactionc-fix-deferring-compaction-mistake
+++ a/mm/compaction.c
@@ -861,7 +861,7 @@ static int __compact_pgdat(pg_data_t *pg
 		if (cc->order > 0) {
 			int ok = zone_watermark_ok(zone, cc->order,
 						low_wmark_pages(zone), 0, 0);
-			if (ok && cc->order > zone->compact_order_failed)
+			if (ok && cc->order >= zone->compact_order_failed)
 				zone->compact_order_failed = cc->order + 1;
 			/* Currently async compaction is never deferred. */
 			else if (!ok && cc->sync)
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
memory-hotplug-reset-pgdat-kswapd-to-null-if-creating-kernel-thread-fails.patch
linux-next.patch
mm-remove-__gfp_no_kswapd.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-compaction-update-comment-in-try_to_compact_pages.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available.patch

