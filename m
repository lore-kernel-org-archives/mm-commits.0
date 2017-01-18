From: akpm@linux-foundation.org
Subject: +
 mm-help-__gfp_nofail-allocations-which-do-not-trigger-oom-killer.patch
 added to -mm tree
Date: Wed, 18 Jan 2017 13:52:09 -0800
Message-ID: <587fe389.uXFtpOd3qazKjPS8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39634 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753542AbdARVwM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2017 16:52:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, penguin-kernel@I-love.SAKURA.ne.jp, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: help __GFP_NOFAIL allocations which do not trigger OOM killer
has been added to the -mm tree.  Its filename is
     mm-help-__gfp_nofail-allocations-which-do-not-trigger-oom-killer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-help-__gfp_nofail-allocations-which-do-not-trigger-oom-killer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-help-__gfp_nofail-allocations-which-do-not-trigger-oom-killer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm: help __GFP_NOFAIL allocations which do not trigger OOM killer

Now that __GFP_NOFAIL doesn't override decisions to skip the oom killer we
are left with requests which require to loop inside the allocator without
invoking the oom killer (e.g.  GFP_NOFS|__GFP_NOFAIL used by fs code) and
so they might, in very unlikely situations, loop for ever - e.g.  other
parallel request could starve them.

This patch tries to limit the likelihood of such a lockup by giving these
__GFP_NOFAIL requests a chance to move on by consuming a small part of
memory reserves.  We are using ALLOC_HARDER which should be enough to
prevent from the starvation by regular allocation requests, yet it
shouldn't consume enough from the reserves to disrupt high priority
requests (ALLOC_HIGH).

While we are at it, let's introduce a helper __alloc_pages_cpuset_fallback
which enforces the cpusets but allows to fallback to ignore them if the
first attempt fails.  __GFP_NOFAIL requests can be considered important
enough to allow cpuset runaway in order for the system to move on.  It is
highly unlikely that any of these will be GFP_USER anyway.

Link: http://lkml.kernel.org/r/20161220134904.21023-4-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   46 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 36 insertions(+), 10 deletions(-)

diff -puN mm/page_alloc.c~mm-help-__gfp_nofail-allocations-which-do-not-trigger-oom-killer mm/page_alloc.c
--- a/mm/page_alloc.c~mm-help-__gfp_nofail-allocations-which-do-not-trigger-oom-killer
+++ a/mm/page_alloc.c
@@ -3059,6 +3059,26 @@ void warn_alloc(gfp_t gfp_mask, nodemask
 }
 
 static inline struct page *
+__alloc_pages_cpuset_fallback(gfp_t gfp_mask, unsigned int order,
+			      unsigned int alloc_flags,
+			      const struct alloc_context *ac)
+{
+	struct page *page;
+
+	page = get_page_from_freelist(gfp_mask, order,
+			alloc_flags|ALLOC_CPUSET, ac);
+	/*
+	 * fallback to ignore cpuset restriction if our nodes
+	 * are depleted
+	 */
+	if (!page)
+		page = get_page_from_freelist(gfp_mask, order,
+				alloc_flags, ac);
+
+	return page;
+}
+
+static inline struct page *
 __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 	const struct alloc_context *ac, unsigned long *did_some_progress)
 {
@@ -3122,17 +3142,13 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 	if (out_of_memory(&oc) || WARN_ON_ONCE(gfp_mask & __GFP_NOFAIL)) {
 		*did_some_progress = 1;
 
-		if (gfp_mask & __GFP_NOFAIL) {
-			page = get_page_from_freelist(gfp_mask, order,
-					ALLOC_NO_WATERMARKS|ALLOC_CPUSET, ac);
-			/*
-			 * fallback to ignore cpuset restriction if our nodes
-			 * are depleted
-			 */
-			if (!page)
-				page = get_page_from_freelist(gfp_mask, order,
+		/*
+		 * Help non-failing allocations by giving them access to memory
+		 * reserves
+		 */
+		if (gfp_mask & __GFP_NOFAIL)
+			page = __alloc_pages_cpuset_fallback(gfp_mask, order,
 					ALLOC_NO_WATERMARKS, ac);
-		}
 	}
 out:
 	mutex_unlock(&oom_lock);
@@ -3753,6 +3769,16 @@ nopage:
 		 */
 		WARN_ON_ONCE(order > PAGE_ALLOC_COSTLY_ORDER);
 
+		/*
+		 * Help non-failing allocations by giving them access to memory
+		 * reserves but do not use ALLOC_NO_WATERMARKS because this
+		 * could deplete whole memory reserves which would just make
+		 * the situation worse
+		 */
+		page = __alloc_pages_cpuset_fallback(gfp_mask, order, ALLOC_HARDER, ac);
+		if (page)
+			goto got_pg;
+
 		cond_resched();
 		goto retry;
 	}
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-throttle-show_mem-from-warn_alloc.patch
mm-trace-extract-compaction_status-and-zone_type-to-a-common-header.patch
oom-trace-add-oom-detection-tracepoints.patch
oom-trace-add-compaction-retry-tracepoint.patch
mm-vmscan-remove-unused-mm_vmscan_memcg_isolate.patch
mm-vmscan-add-active-list-aging-tracepoint.patch
mm-vmscan-add-active-list-aging-tracepoint-update.patch
mm-vmscan-show-the-number-of-skipped-pages-in-mm_vmscan_lru_isolate.patch
mm-vmscan-show-lru-name-in-mm_vmscan_lru_isolate-tracepoint.patch
mm-vmscan-extract-shrink_page_list-reclaim-counters-into-a-struct.patch
mm-vmscan-enhance-mm_vmscan_lru_shrink_inactive-tracepoint.patch
mm-vmscan-add-mm_vmscan_inactive_list_is_low-tracepoint.patch
trace-vmscan-postprocess-sync-with-tracepoints-updates.patch
mm-vmscan-do-not-count-freed-pages-as-pgdeactivate.patch
mm-vmscan-cleanup-lru-size-claculations.patch
mm-vmscan-consider-eligible-zones-in-get_scan_count.patch
revert-mm-bail-out-in-shrink_inactive_list.patch
mm-page_alloc-do-not-report-all-nodes-in-show_mem.patch
mm-page_alloc-warn_alloc-print-nodemask.patch
arch-mm-remove-arch-specific-show_mem.patch
lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask.patch
mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath.patch
mm-oom-do-not-enfore-oom-killer-for-__gfp_nofail-automatically.patch
mm-help-__gfp_nofail-allocations-which-do-not-trigger-oom-killer.patch

