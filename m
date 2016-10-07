From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-compaction-ignore-fragindex-from-compaction_zonelist_suitable-fix.patch
 removed from -mm tree
Date: Fri, 07 Oct 2016 16:40:08 -0700
Message-ID: <57f83258.w5vpJdwwSca/ymVZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38387 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754882AbcJGXkJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 19:40:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-ignore-fragindex-from-compaction_zonelist_suitable-fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-ignore-fragindex-from-compaction_zonelist_suitable-fix.patch

This patch was dropped because it was folded into mm-compaction-ignore-fragindex-from-compaction_zonelist_suitable.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-compaction-ignore-fragindex-from-compaction_zonelist_suitable-fix

COMPACT_NOT_SUITABLE_ZONE should not leak outside compaction_suitable() and
we should not skip tracepoint.

Link: http://lkml.kernel.org/r/cadadd38-6456-f58e-504f-cc18ddc47b3f@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-compaction-ignore-fragindex-from-compaction_zonelist_suitable-fix mm/compaction.c
--- a/mm/compaction.c~mm-compaction-ignore-fragindex-from-compaction_zonelist_suitable-fix
+++ a/mm/compaction.c
@@ -1440,7 +1440,7 @@ enum compact_result compaction_suitable(
 	if (ret == COMPACT_CONTINUE) {
 		fragindex = fragmentation_index(zone, order);
 		if (fragindex >= 0 && fragindex <= sysctl_extfrag_threshold)
-			return COMPACT_NOT_SUITABLE_ZONE;
+			ret = COMPACT_NOT_SUITABLE_ZONE;
 	}
 
 	trace_mm_compaction_suitable(zone, order, ret);
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions.patch
mm-compaction-cleanup-unused-functions.patch
mm-compaction-rename-compact_partial-to-compact_success.patch
mm-compaction-dont-recheck-watermarks-after-compact_success.patch
mm-compaction-add-the-ultimate-direct-compaction-priority.patch
mm-compaction-use-correct-watermark-when-checking-compaction-success.patch
mm-compaction-create-compact_gap-wrapper.patch
mm-compaction-use-proper-alloc_flags-in-__compaction_suitable.patch
mm-compaction-require-only-min-watermarks-for-non-costly-orders.patch
mm-vmscan-make-compaction_ready-more-accurate-and-readable.patch
revert-mm-oom-prevent-premature-oom-killer-invocation-for-high-order-request.patch
mm-compaction-more-reliably-increase-direct-compaction-priority.patch
mm-compaction-restrict-full-priority-to-non-costly-orders.patch
mm-compaction-make-full-priority-ignore-pageblock-suitability.patch
mm-page_alloc-pull-no_progress_loops-update-to-should_reclaim_retry.patch
mm-compaction-ignore-fragindex-from-compaction_zonelist_suitable.patch
mm-compaction-restrict-fragindex-to-costly-orders.patch

