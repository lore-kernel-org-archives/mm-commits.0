From: akpm@linux-foundation.org
Subject: +
 revert-mm-oom-prevent-premature-oom-killer-invocation-for-high-order-request.patch added to -mm tree
Date: Thu, 08 Sep 2016 16:41:08 -0700
Message-ID: <57d1f714.ysOj6b4rozMqjYlx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47474 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751143AbcIHXlK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Sep 2016 19:41:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@kernel.org, penguin-kernel@i-love.sakura.ne.jp, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "mm, oom: prevent premature OOM killer invocation for high order request"
has been added to the -mm tree.  Its filename is
     revert-mm-oom-prevent-premature-oom-killer-invocation-for-high-order-request.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/revert-mm-oom-prevent-premature-oom-killer-invocation-for-high-order-request.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/revert-mm-oom-prevent-premature-oom-killer-invocation-for-high-order-request.patch

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
Subject: Revert "mm, oom: prevent premature OOM killer invocation for high order request"

Patch series "reintroduce compaction feedback for OOM decisions".

After several people reported OOM's for order-2 allocations in 4.7 due to
Michal Hocko's OOM rework, he reverted the part that considered compaction
feedback [1] in the decisions to retry reclaim/compaction.  This was to
provide a fix quickly for 4.8 rc and 4.7 stable series, while mmotm had an
almost complete solution that instead improved compaction reliability.

This series completes the mmotm solution and reintroduces the compaction
feedback into OOM decisions.  The first two patches restore the state of
mmotm before the temporary solution was merged, the last patch should be
the missing piece for reliability.  The third patch restricts the hardened
compaction to non-costly orders, since costly orders don't result in OOMs
in the first place.

[1] http://marc.info/?i=20160822093249.GA14916%40dhcp22.suse.cz%3E


This patch (of 4):

Commit 6b4e3181d7bd ("mm, oom: prevent premature OOM killer invocation for
high order request") was intended as a quick fix of OOM regressions for
4.8 and stable 4.7.x kernels.  For a better long-term solution, we still
want to consider compaction feedback, which should be possible after some
more improvements in the following patches.

This reverts commit 6b4e3181d7bd5ca5ab6f45929e4a5ffa7ab4ab7f.

Link: http://lkml.kernel.org/r/20160906135258.18335-2-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   51 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 49 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~revert-mm-oom-prevent-premature-oom-killer-invocation-for-high-order-request mm/page_alloc.c
--- a/mm/page_alloc.c~revert-mm-oom-prevent-premature-oom-killer-invocation-for-high-order-request
+++ a/mm/page_alloc.c
@@ -3156,6 +3156,54 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	return NULL;
 }
 
+static inline bool
+should_compact_retry(struct alloc_context *ac, int order, int alloc_flags,
+		     enum compact_result compact_result,
+		     enum compact_priority *compact_priority,
+		     int compaction_retries)
+{
+	int max_retries = MAX_COMPACT_RETRIES;
+
+	if (!order)
+		return false;
+
+	/*
+	 * compaction considers all the zone as desperately out of memory
+	 * so it doesn't really make much sense to retry except when the
+	 * failure could be caused by insufficient priority
+	 */
+	if (compaction_failed(compact_result)) {
+		if (*compact_priority > MIN_COMPACT_PRIORITY) {
+			(*compact_priority)--;
+			return true;
+		}
+		return false;
+	}
+
+	/*
+	 * make sure the compaction wasn't deferred or didn't bail out early
+	 * due to locks contention before we declare that we should give up.
+	 * But do not retry if the given zonelist is not suitable for
+	 * compaction.
+	 */
+	if (compaction_withdrawn(compact_result))
+		return compaction_zonelist_suitable(ac, order, alloc_flags);
+
+	/*
+	 * !costly requests are much more important than __GFP_REPEAT
+	 * costly ones because they are de facto nofail and invoke OOM
+	 * killer to move on while costly can fail and users are ready
+	 * to cope with that. 1/4 retries is rather arbitrary but we
+	 * would need much more detailed feedback from compaction to
+	 * make a better decision.
+	 */
+	if (order > PAGE_ALLOC_COSTLY_ORDER)
+		max_retries /= 4;
+	if (compaction_retries <= max_retries)
+		return true;
+
+	return false;
+}
 #else
 static inline struct page *
 __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
@@ -3166,8 +3214,6 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	return NULL;
 }
 
-#endif /* CONFIG_COMPACTION */
-
 static inline bool
 should_compact_retry(struct alloc_context *ac, unsigned int order, int alloc_flags,
 		     enum compact_result compact_result,
@@ -3194,6 +3240,7 @@ should_compact_retry(struct alloc_contex
 	}
 	return false;
 }
+#endif /* CONFIG_COMPACTION */
 
 /* Perform direct synchronous page reclaim */
 static int
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
mm-compaction-restrict-full-priority-to-non-costly-orders.patch
mm-compaction-make-full-priority-ignore-pageblock-suitability.patch

