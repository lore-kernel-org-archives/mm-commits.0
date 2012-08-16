From: akpm@linux-foundation.org
Subject: + mm-compactionc-fix-deferring-compaction-mistake.patch added to -mm tree
Date: Thu, 16 Aug 2012 11:50:22 -0700
Message-ID: <20120816185023.0E63D20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:47716 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab2HPSuZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Aug 2012 14:50:25 -0400
Received: by lbbge1 with SMTP id ge1so151453lbb.1
        for <mm-commits@vger.kernel.org>; Thu, 16 Aug 2012 11:50:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan@kernel.org, mel@csn.ul.ie, riel@redhat.com


The patch titled
     Subject: mm/compaction.c: fix deferring compaction mistake
has been added to the -mm tree.  Its filename is
     mm-compactionc-fix-deferring-compaction-mistake.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
mm-compactionc-fix-deferring-compaction-mistake.patch
mm-remove-__gfp_no_kswapd.patch
remove-__gfp_no_kswapd-fixes-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch

