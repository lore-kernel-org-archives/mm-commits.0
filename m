From: akpm@linux-foundation.org
Subject: +
 mm-compaction-ignore-fragindex-from-compaction_zonelist_suitable.patch
 added to -mm tree
Date: Mon, 26 Sep 2016 16:09:04 -0700
Message-ID: <57e9aa90.hQl5yip7ha3UbIq8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47139 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752810AbcIZXJG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2016 19:09:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: ignore fragindex from compaction_zonelist_suitable()
has been added to the -mm tree.  Its filename is
     mm-compaction-ignore-fragindex-from-compaction_zonelist_suitable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-ignore-fragindex-from-compaction_zonelist_suitable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-ignore-fragindex-from-compaction_zonelist_suitable.patch

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
Subject: mm, compaction: ignore fragindex from compaction_zonelist_suitable()

The compaction_zonelist_suitable() function tries to determine if
compaction will be able to proceed after sufficient reclaim, i.e.  whether
there are enough reclaimable pages to provide enough order-0 freepages for
compaction.

This addition of reclaimable pages to the free pages works well for the
order-0 watermark check, but in the fragmentation index check we only
consider truly free pages.  Thus we can get fragindex value close to 0
which indicates failure do to lack of memory, and wrongly decide that
compaction won't be suitable even after reclaim.

Instead of trying to somehow adjust fragindex for reclaimable pages, let's
just skip it from compaction_zonelist_suitable().

Link: http://lkml.kernel.org/r/20160926162025.21555-4-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff -puN mm/compaction.c~mm-compaction-ignore-fragindex-from-compaction_zonelist_suitable mm/compaction.c
--- a/mm/compaction.c~mm-compaction-ignore-fragindex-from-compaction_zonelist_suitable
+++ a/mm/compaction.c
@@ -1379,7 +1379,6 @@ static enum compact_result __compaction_
 					int classzone_idx,
 					unsigned long wmark_target)
 {
-	int fragindex;
 	unsigned long watermark;
 
 	if (is_via_compact_memory(order))
@@ -1415,6 +1414,18 @@ static enum compact_result __compaction_
 						ALLOC_CMA, wmark_target))
 		return COMPACT_SKIPPED;
 
+	return COMPACT_CONTINUE;
+}
+
+enum compact_result compaction_suitable(struct zone *zone, int order,
+					unsigned int alloc_flags,
+					int classzone_idx)
+{
+	enum compact_result ret;
+	int fragindex;
+
+	ret = __compaction_suitable(zone, order, alloc_flags, classzone_idx,
+				    zone_page_state(zone, NR_FREE_PAGES));
 	/*
 	 * fragmentation index determines if allocation failures are due to
 	 * low memory or external fragmentation
@@ -1426,21 +1437,12 @@ static enum compact_result __compaction_
 	 *
 	 * Only compact if a failure would be due to fragmentation.
 	 */
-	fragindex = fragmentation_index(zone, order);
-	if (fragindex >= 0 && fragindex <= sysctl_extfrag_threshold)
-		return COMPACT_NOT_SUITABLE_ZONE;
-
-	return COMPACT_CONTINUE;
-}
-
-enum compact_result compaction_suitable(struct zone *zone, int order,
-					unsigned int alloc_flags,
-					int classzone_idx)
-{
-	enum compact_result ret;
+	if (ret == COMPACT_CONTINUE) {
+		fragindex = fragmentation_index(zone, order);
+		if (fragindex >= 0 && fragindex <= sysctl_extfrag_threshold)
+			return COMPACT_NOT_SUITABLE_ZONE;
+	}
 
-	ret = __compaction_suitable(zone, order, alloc_flags, classzone_idx,
-				    zone_page_state(zone, NR_FREE_PAGES));
 	trace_mm_compaction_suitable(zone, order, ret);
 	if (ret == COMPACT_NOT_SUITABLE_ZONE)
 		ret = COMPACT_SKIPPED;
@@ -1473,8 +1475,7 @@ bool compaction_zonelist_suitable(struct
 		available += zone_page_state_snapshot(zone, NR_FREE_PAGES);
 		compact_result = __compaction_suitable(zone, order, alloc_flags,
 				ac_classzone_idx(ac), available);
-		if (compact_result != COMPACT_SKIPPED &&
-				compact_result != COMPACT_NOT_SUITABLE_ZONE)
+		if (compact_result != COMPACT_SKIPPED)
 			return true;
 	}
 
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions.patch
mm-compaction-cleanup-unused-functions.patch
mm-compaction-rename-compact_partial-to-compact_success.patch
mm-compaction-dont-recheck-watermarks-after-compact_success.patch
mm-compaction-add-the-ultimate-direct-compaction-priority.patch
mm-compaction-add-the-ultimate-direct-compaction-priority-fix.patch
mm-compaction-use-correct-watermark-when-checking-compaction-success.patch
mm-compaction-create-compact_gap-wrapper.patch
mm-compaction-create-compact_gap-wrapper-fix.patch
mm-compaction-use-proper-alloc_flags-in-__compaction_suitable.patch
mm-compaction-require-only-min-watermarks-for-non-costly-orders.patch
mm-compaction-require-only-min-watermarks-for-non-costly-orders-fix.patch
mm-vmscan-make-compaction_ready-more-accurate-and-readable.patch
revert-mm-oom-prevent-premature-oom-killer-invocation-for-high-order-request.patch
mm-compaction-more-reliably-increase-direct-compaction-priority.patch
mm-compaction-more-reliably-increase-direct-compaction-priority-fix.patch
mm-compaction-restrict-full-priority-to-non-costly-orders.patch
mm-compaction-make-full-priority-ignore-pageblock-suitability.patch
mm-page_alloc-pull-no_progress_loops-update-to-should_reclaim_retry.patch
mm-compaction-ignore-fragindex-from-compaction_zonelist_suitable.patch
mm-compaction-restrict-fragindex-to-costly-orders.patch

