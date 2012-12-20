From: akpm@linux-foundation.org
Subject: + compaction-fix-build-error-in-cma-compaction.patch added to -mm tree
Date: Thu, 20 Dec 2012 12:38:28 -0800
Message-ID: <20121220203829.23D3120004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:57368 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab2LTUic (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Dec 2012 15:38:32 -0500
Received: by mail-la0-f74.google.com with SMTP id v3so195110lag.3
        for <mm-commits@vger.kernel.org>; Thu, 20 Dec 2012 12:38:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan@kernel.org, m.szyprowski@samsung.com, mgorman@suse.de


The patch titled
     Subject: compaction: fix build error in CMA && !COMPACTION
has been added to the -mm tree.  Its filename is
     compaction-fix-build-error-in-cma-compaction.patch

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
Subject: compaction: fix build error in CMA && !COMPACTION

isolate_freepages_block() and isolate_migratepages_range() are used for
CMA as well as compaction so it breaks build for CONFIG_CMA &&
!CONFIG_COMPACTION.

This patch fixes it.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff -puN mm/compaction.c~compaction-fix-build-error-in-cma-compaction mm/compaction.c
--- a/mm/compaction.c~compaction-fix-build-error-in-cma-compaction
+++ a/mm/compaction.c
@@ -17,6 +17,21 @@
 #include <linux/balloon_compaction.h>
 #include "internal.h"
 
+#ifdef CONFIG_COMPACTION
+static inline void count_compact_event(enum vm_event_item item)
+{
+	count_vm_event(item);
+}
+
+static inline void count_compact_events(enum vm_event_item item, long delta)
+{
+	count_vm_events(item, delta);
+}
+#else
+#define count_compact_event(item)
+#define count_compact_events(item, delta)
+#endif
+
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
 
 #define CREATE_TRACE_POINTS
@@ -303,10 +318,9 @@ static unsigned long isolate_freepages_b
 	if (blockpfn == end_pfn)
 		update_pageblock_skip(cc, valid_page, total_isolated, false);
 
-	count_vm_events(COMPACTFREE_SCANNED, nr_scanned);
+	count_compact_events(COMPACTFREE_SCANNED, nr_scanned);
 	if (total_isolated)
-		count_vm_events(COMPACTISOLATED, total_isolated);
-
+		count_compact_events(COMPACTISOLATED, total_isolated);
 	return total_isolated;
 }
 
@@ -613,9 +627,9 @@ next_pageblock:
 
 	trace_mm_compaction_isolate_migratepages(nr_scanned, nr_isolated);
 
-	count_vm_events(COMPACTMIGRATE_SCANNED, nr_scanned);
+	count_compact_events(COMPACTMIGRATE_SCANNED, nr_scanned);
 	if (nr_isolated)
-		count_vm_events(COMPACTISOLATED, nr_isolated);
+		count_compact_events(COMPACTISOLATED, nr_isolated);
 
 	return low_pfn;
 }
@@ -1110,7 +1124,7 @@ unsigned long try_to_compact_pages(struc
 	if (!order || !may_enter_fs || !may_perform_io)
 		return rc;
 
-	count_vm_event(COMPACTSTALL);
+	count_compact_event(COMPACTSTALL);
 
 #ifdef CONFIG_CMA
 	if (allocflags_to_migratetype(gfp_mask) == MIGRATE_MOVABLE)
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
compaction-fix-build-error-in-cma-compaction.patch
mm-fix-zone_watermark_ok_safe-accounting-of-isolated-pages.patch
mm-add-vm-event-counters-for-balloon-pages-compaction.patch

