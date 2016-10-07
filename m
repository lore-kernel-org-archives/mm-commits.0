From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-compaction-create-compact_gap-wrapper-fix.patch removed from -mm tree
Date: Fri, 07 Oct 2016 16:33:48 -0700
Message-ID: <57f830dc.Bs01RJJiFtyiQvmW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38279 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751968AbcJGXdu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 19:33:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, lstoakes@gmail.com, mgorman@techsingularity.net, mhocko@kernel.org, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-create-compact_gap-wrapper-fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-create-compact_gap-wrapper-fix.patch

This patch was dropped because it was folded into mm-compaction-create-compact_gap-wrapper.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-compaction-create-compact_gap-wrapper-fix

Clarify the comment of compact_gap() wrt COMPACT_CLUSTER_MAX, per Joonsoo.

Link: http://lkml.kernel.org/r/7b6aed1f-fdf8-2063-9ff4-bbe4de712d37@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN include/linux/compaction.h~mm-compaction-create-compact_gap-wrapper-fix include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-create-compact_gap-wrapper-fix
+++ a/include/linux/compaction.h
@@ -67,9 +67,16 @@ static inline unsigned long compact_gap(
 {
 	/*
 	 * Although all the isolations for migration are temporary, compaction
-	 * may have up to 1 << order pages on its list and then try to split
-	 * an (order - 1) free page. At that point, a gap of 1 << order might
-	 * not be enough, so it's safer to require twice that amount.
+	 * free scanner may have up to 1 << order pages on its list and then
+	 * try to split an (order - 1) free page. At that point, a gap of
+	 * 1 << order might not be enough, so it's safer to require twice that
+	 * amount. Note that the number of pages on the list is also
+	 * effectively limited by COMPACT_CLUSTER_MAX, as that's the maximum
+	 * that the migrate scanner can have isolated on migrate list, and free
+	 * scanner is only invoked when the number of isolated free pages is
+	 * lower than that. But it's not worth to complicate the formula here
+	 * as a bigger gap for higher orders than strictly necessary can also
+	 * improve chances of compaction success.
 	 */
 	return 2UL << order;
 }
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

