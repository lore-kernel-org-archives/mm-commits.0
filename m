From: akpm@linux-foundation.org
Subject: [merged] mm-compaction-restrict-fragindex-to-costly-orders.patch
 removed from -mm tree
Date: Mon, 10 Oct 2016 15:45:38 -0700
Message-ID: <57fc1a12.fxUKTCkTbWyMuUMc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37159 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752387AbcJJWpj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:45:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: restrict fragindex to costly orders
has been removed from the -mm tree.  Its filename was
     mm-compaction-restrict-fragindex-to-costly-orders.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 			ret = COMPACT_NOT_SUITABLE_ZONE;
_

Patches currently in -mm which might be from vbabka@suse.cz are

fs-select-add-vmalloc-fallback-for-select2.patch

