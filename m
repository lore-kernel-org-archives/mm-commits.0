From: akpm@linux-foundation.org
Subject: + mm-compaction-encapsulate-defer-reset-logic.patch added to -mm
 tree
Date: Wed, 11 Dec 2013 15:43:08 -0800
Message-ID: <52a8f88c.XTZ8Zffso/GfgjNT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50459 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab3LKXnJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Dec 2013 18:43:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mgorman@suse.de, iamjoonsoo.kim@lge.com, vbabka@suse.cz

Subject: + mm-compaction-encapsulate-defer-reset-logic.patch added to -mm tree
To: vbabka@suse.cz,iamjoonsoo.kim@lge.com,mgorman@suse.de,riel@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 11 Dec 2013 15:43:08 -0800


The patch titled
     Subject: mm: compaction: encapsulate defer reset logic
has been added to the -mm tree.  Its filename is
     mm-compaction-encapsulate-defer-reset-logic.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-encapsulate-defer-reset-logic.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-encapsulate-defer-reset-logic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm: compaction: encapsulate defer reset logic

Currently there are several functions to manipulate the deferred
compaction state variables.  The remaining case where the variables are
touched directly is when a successful allocation occurs in direct
compaction, or is expected to be successful in the future by kswapd. 
Here, the lowest order that is expected to fail is updated, and in the
case of successful allocation, the deferred status and counter is reset
completely.

Create a new function compaction_defer_reset() to encapsulate this
functionality and make it easier to understand the code.  No functional
change.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |   16 ++++++++++++++++
 mm/compaction.c            |    9 ++++-----
 mm/page_alloc.c            |    5 +----
 3 files changed, 21 insertions(+), 9 deletions(-)

diff -puN include/linux/compaction.h~mm-compaction-encapsulate-defer-reset-logic include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-encapsulate-defer-reset-logic
+++ a/include/linux/compaction.h
@@ -62,6 +62,22 @@ static inline bool compaction_deferred(s
 	return zone->compact_considered < defer_limit;
 }
 
+/*
+ * Update defer tracking counters after successful compaction of given order,
+ * which means an allocation either succeeded (alloc_success == true) or is
+ * expected to succeed.
+ */
+static inline void compaction_defer_reset(struct zone *zone, int order,
+		bool alloc_success)
+{
+	if (alloc_success) {
+		zone->compact_considered = 0;
+		zone->compact_defer_shift = 0;
+	}
+	if (order >= zone->compact_order_failed)
+		zone->compact_order_failed = order + 1;
+}
+
 /* Returns true if restarting compaction after many failures */
 static inline bool compaction_restarting(struct zone *zone, int order)
 {
diff -puN mm/compaction.c~mm-compaction-encapsulate-defer-reset-logic mm/compaction.c
--- a/mm/compaction.c~mm-compaction-encapsulate-defer-reset-logic
+++ a/mm/compaction.c
@@ -1120,12 +1120,11 @@ static void __compact_pgdat(pg_data_t *p
 			compact_zone(zone, cc);
 
 		if (cc->order > 0) {
-			int ok = zone_watermark_ok(zone, cc->order,
-						low_wmark_pages(zone), 0, 0);
-			if (ok && cc->order >= zone->compact_order_failed)
-				zone->compact_order_failed = cc->order + 1;
+			if (zone_watermark_ok(zone, cc->order,
+						low_wmark_pages(zone), 0, 0))
+				compaction_defer_reset(zone, cc->order, false);
 			/* Currently async compaction is never deferred. */
-			else if (!ok && cc->sync)
+			else if (cc->sync)
 				defer_compaction(zone, cc->order);
 		}
 
diff -puN mm/page_alloc.c~mm-compaction-encapsulate-defer-reset-logic mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-encapsulate-defer-reset-logic
+++ a/mm/page_alloc.c
@@ -2237,10 +2237,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 				preferred_zone, migratetype);
 		if (page) {
 			preferred_zone->compact_blockskip_flush = false;
-			preferred_zone->compact_considered = 0;
-			preferred_zone->compact_defer_shift = 0;
-			if (order >= preferred_zone->compact_order_failed)
-				preferred_zone->compact_order_failed = order + 1;
+			compaction_defer_reset(preferred_zone, order, true);
 			count_vm_event(COMPACTSUCCESS);
 			return page;
 		}
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-mmapc-add-mlock_future_check-helper.patch
mm-mlock-prepare-params-outside-critical-region.patch
mm-compaction-trace-compaction-begin-and-end.patch
mm-compaction-encapsulate-defer-reset-logic.patch
mm-compaction-reset-cached-scanner-pfns-before-reading-them.patch
mm-compaction-detect-when-scanners-meet-in-isolate_freepages.patch
mm-compaction-do-not-mark-unmovable-pageblocks-as-skipped-in-async-compaction.patch
mm-compaction-reset-scanner-positions-immediately-when-they-meet.patch

