From: akpm@linux-foundation.org
Subject: + mm-compaction-restrict-fragindex-to-costly-orders.patch added
 to -mm tree
Date: Mon, 26 Sep 2016 16:09:06 -0700
Message-ID: <57e9aa92.4B5AAHi70dhNpAND%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47146 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753801AbcIZXJI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2016 19:09:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: restrict fragindex to costly orders
has been added to the -mm tree.  Its filename is
     mm-compaction-restrict-fragindex-to-costly-orders.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-restrict-fragindex-to-costly-orders.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-restrict-fragindex-to-costly-orders.patch

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
Subject: mm, compaction: restrict fragindex to costly orders

Fragmentation index and the vm.extfrag_threshold sysctl is meant as a
heuristic to prevent excessive compaction for costly orders (i.e.  THP). 
It's unlikely to make any difference for non-costly orders, especially
with the default threshold.  But we cannot afford any uncertainty for the
non-costly orders where the only alternative to successful
reclaim/compaction is OOM.  After the recent patches we are guaranteed
maximum effort without heuristics from compaction before deciding OOM, and
fragindex is the last remaining heuristic.  Therefore skip fragindex
altogether for non-costly orders.

Suggested-by: Michal Hocko <mhocko@suse.com>
Link: http://lkml.kernel.org/r/20160926162025.21555-5-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN mm/compaction.c~mm-compaction-restrict-fragindex-to-costly-orders mm/compaction.c
--- a/mm/compaction.c~mm-compaction-restrict-fragindex-to-costly-orders
+++ a/mm/compaction.c
@@ -1435,9 +1435,14 @@ enum compact_result compaction_suitable(
 	 * index towards 0 implies failure is due to lack of memory
 	 * index towards 1000 implies failure is due to fragmentation
 	 *
-	 * Only compact if a failure would be due to fragmentation.
+	 * Only compact if a failure would be due to fragmentation. Also
+	 * ignore fragindex for non-costly orders where the alternative to
+	 * a successful reclaim/compaction is OOM. Fragindex and the
+	 * vm.extfrag_threshold sysctl is meant as a heuristic to prevent
+	 * excessive compaction for costly orders, but it should not be at the
+	 * expense of system stability.
 	 */
-	if (ret == COMPACT_CONTINUE) {
+	if (ret == COMPACT_CONTINUE && (order > PAGE_ALLOC_COSTLY_ORDER)) {
 		fragindex = fragmentation_index(zone, order);
 		if (fragindex >= 0 && fragindex <= sysctl_extfrag_threshold)
 			return COMPACT_NOT_SUITABLE_ZONE;
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

