From: akpm@linux-foundation.org
Subject: [patch 073/127] mm, compaction: more reliably increase direct
 compaction priority
Date: Fri, 07 Oct 2016 17:00:31 -0700
Message-ID: <57f8371f.pv+OeM6o9ZRQb2P7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39310 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932714AbcJHAAc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 20:00:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vbabka@suse.cz, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@kernel.org, penguin-kernel@i-love.sakura.ne.jp, riel@redhat.com, rientjes@google.com

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: more reliably increase direct compaction priority

During reclaim/compaction loop, compaction priority can be increased by
the should_compact_retry() function, but the current code is not optimal. 
Priority is only increased when compaction_failed() is true, which means
that compaction has scanned the whole zone.  This may not happen even
after multiple attempts with a lower priority due to parallel activity, so
we might needlessly struggle on the lower priorities and possibly run out
of compaction retry attempts in the process.

After this patch we are guaranteed at least one attempt at the highest
compaction priority even if we exhaust all retries at the lower
priorities.

Link: http://lkml.kernel.org/r/20160906135258.18335-3-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff -puN mm/page_alloc.c~mm-compaction-more-reliably-increase-direct-compaction-priority mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-more-reliably-increase-direct-compaction-priority
+++ a/mm/page_alloc.c
@@ -3160,25 +3160,23 @@ static inline bool
 should_compact_retry(struct alloc_context *ac, int order, int alloc_flags,
 		     enum compact_result compact_result,
 		     enum compact_priority *compact_priority,
-		     int compaction_retries)
+		     int *compaction_retries)
 {
 	int max_retries = MAX_COMPACT_RETRIES;
 
 	if (!order)
 		return false;
 
+	if (compaction_made_progress(compact_result))
+		(*compaction_retries)++;
+
 	/*
 	 * compaction considers all the zone as desperately out of memory
 	 * so it doesn't really make much sense to retry except when the
 	 * failure could be caused by insufficient priority
 	 */
-	if (compaction_failed(compact_result)) {
-		if (*compact_priority > MIN_COMPACT_PRIORITY) {
-			(*compact_priority)--;
-			return true;
-		}
-		return false;
-	}
+	if (compaction_failed(compact_result))
+		goto check_priority;
 
 	/*
 	 * make sure the compaction wasn't deferred or didn't bail out early
@@ -3199,9 +3197,19 @@ should_compact_retry(struct alloc_contex
 	 */
 	if (order > PAGE_ALLOC_COSTLY_ORDER)
 		max_retries /= 4;
-	if (compaction_retries <= max_retries)
+	if (*compaction_retries <= max_retries)
 		return true;
 
+	/*
+	 * Make sure there are attempts at the highest priority if we exhausted
+	 * all retries or failed at the lower priorities.
+	 */
+check_priority:
+	if (*compact_priority > MIN_COMPACT_PRIORITY) {
+		(*compact_priority)--;
+		*compaction_retries = 0;
+		return true;
+	}
 	return false;
 }
 #else
@@ -3218,7 +3226,7 @@ static inline bool
 should_compact_retry(struct alloc_context *ac, unsigned int order, int alloc_flags,
 		     enum compact_result compact_result,
 		     enum compact_priority *compact_priority,
-		     int compaction_retries)
+		     int *compaction_retries)
 {
 	struct zone *zone;
 	struct zoneref *z;
@@ -3620,9 +3628,6 @@ retry:
 	if (page)
 		goto got_pg;
 
-	if (order && compaction_made_progress(compact_result))
-		compaction_retries++;
