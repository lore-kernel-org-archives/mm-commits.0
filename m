From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-restrict-full-priority-to-non-costly-orders.patch removed
 from -mm tree
Date: Mon, 10 Oct 2016 15:45:26 -0700
Message-ID: <57fc1a06.Aa2QL3ck5OswVH8e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37124 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752232AbcJJWp1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:45:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@kernel.org, penguin-kernel@i-love.sakura.ne.jp, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: restrict full priority to non-costly orders
has been removed from the -mm tree.  Its filename was
     mm-compaction-restrict-full-priority-to-non-costly-orders.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: restrict full priority to non-costly orders

The new ultimate compaction priority disables some heuristics, which may
result in excessive cost.  This is fine for non-costly orders where we
want to try hard before resulting for OOM, but might be disruptive for
costly orders which do not trigger OOM and should generally have some
fallback.  Thus, we disable the full priority for costly orders.

Suggested-by: Michal Hocko <mhocko@kernel.org>
Link: http://lkml.kernel.org/r/20160906135258.18335-4-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |    1 +
 mm/page_alloc.c            |    5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN include/linux/compaction.h~mm-compaction-restrict-full-priority-to-non-costly-orders include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-restrict-full-priority-to-non-costly-orders
+++ a/include/linux/compaction.h
@@ -9,6 +9,7 @@ enum compact_priority {
 	COMPACT_PRIO_SYNC_FULL,
 	MIN_COMPACT_PRIORITY = COMPACT_PRIO_SYNC_FULL,
 	COMPACT_PRIO_SYNC_LIGHT,
+	MIN_COMPACT_COSTLY_PRIORITY = COMPACT_PRIO_SYNC_LIGHT,
 	DEF_COMPACT_PRIORITY = COMPACT_PRIO_SYNC_LIGHT,
 	COMPACT_PRIO_ASYNC,
 	INIT_COMPACT_PRIORITY = COMPACT_PRIO_ASYNC
diff -puN mm/page_alloc.c~mm-compaction-restrict-full-priority-to-non-costly-orders mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-restrict-full-priority-to-non-costly-orders
+++ a/mm/page_alloc.c
@@ -3163,6 +3163,7 @@ should_compact_retry(struct alloc_contex
 		     int *compaction_retries)
 {
 	int max_retries = MAX_COMPACT_RETRIES;
+	int min_priority;
 
 	if (!order)
 		return false;
@@ -3205,7 +3206,9 @@ should_compact_retry(struct alloc_contex
 	 * all retries or failed at the lower priorities.
 	 */
 check_priority:
-	if (*compact_priority > MIN_COMPACT_PRIORITY) {
+	min_priority = (order > PAGE_ALLOC_COSTLY_ORDER) ?
+			MIN_COMPACT_COSTLY_PRIORITY : MIN_COMPACT_PRIORITY;
+	if (*compact_priority > min_priority) {
 		(*compact_priority)--;
 		*compaction_retries = 0;
 		return true;
_

Patches currently in -mm which might be from vbabka@suse.cz are

fs-select-add-vmalloc-fallback-for-select2.patch

