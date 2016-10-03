From: akpm@linux-foundation.org
Subject: +
 mm-compaction-ignore-fragindex-from-compaction_zonelist_suitable-fix.patch
 added to -mm tree
Date: Mon, 03 Oct 2016 14:44:58 -0700
Message-ID: <57f2d15a.z+ElE8ijwdbEUnTr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36908 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751500AbcJCVo7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2016 17:44:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-ignore-fragindex-from-compaction_zonelist_suitable-fix
has been added to the -mm tree.  Its filename is
     mm-compaction-ignore-fragindex-from-compaction_zonelist_suitable-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-ignore-fragindex-from-compaction_zonelist_suitable-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-ignore-fragindex-from-compaction_zonelist_suitable-fix.patch

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

fs-select-add-vmalloc-fallback-for-select2.patch
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
mm-compaction-ignore-fragindex-from-compaction_zonelist_suitable-fix.patch
mm-compaction-restrict-fragindex-to-costly-orders.patch

