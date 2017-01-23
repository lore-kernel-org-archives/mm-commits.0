From: akpm@linux-foundation.org
Subject: + mm-page_alloc-split-alloc_pages_nodemask.patch added to -mm
 tree
Date: Mon, 23 Jan 2017 14:53:56 -0800
Message-ID: <58868984.vlZmns1vq6vJL7c5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44700 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751355AbdAWWx5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jan 2017 17:53:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, brouer@redhat.com, hillf.zj@alibaba-inc.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: split alloc_pages_nodemask()
has been added to the -mm tree.  Its filename is
     mm-page_alloc-split-alloc_pages_nodemask.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-split-alloc_pages_nodemask.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-split-alloc_pages_nodemask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: split alloc_pages_nodemask()

alloc_pages_nodemask does a number of preperation steps that determine
what zones can be used for the allocation depending on a variety of
factors. This is fine but a hypothetical caller that wanted multiple
order-0 pages has to do the preparation steps multiple times. This patch
structures __alloc_pages_nodemask such that it's relatively easy to build
a bulk order-0 page allocator. There is no functional change.

Link: http://lkml.kernel.org/r/20170123153906.3122-3-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   75 ++++++++++++++++++++++++++++------------------
 1 file changed, 46 insertions(+), 29 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-split-alloc_pages_nodemask mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-split-alloc_pages_nodemask
+++ a/mm/page_alloc.c
@@ -3855,60 +3855,77 @@ got_pg:
 	return page;
 }
 
-/*
- * This is the 'heart' of the zoned buddy allocator.
- */
-struct page *
-__alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
-			struct zonelist *zonelist, nodemask_t *nodemask)
+static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
+		struct zonelist *zonelist, nodemask_t *nodemask,
+		struct alloc_context *ac, gfp_t *alloc_mask,
+		unsigned int *alloc_flags)
 {
-	struct page *page;
-	unsigned int alloc_flags = ALLOC_WMARK_LOW;
-	gfp_t alloc_mask = gfp_mask; /* The gfp_t that was actually used for allocation */
-	struct alloc_context ac = {
-		.high_zoneidx = gfp_zone(gfp_mask),
-		.zonelist = zonelist,
-		.nodemask = nodemask,
-		.migratetype = gfpflags_to_migratetype(gfp_mask),
-	};
+	ac->high_zoneidx = gfp_zone(gfp_mask);
+	ac->zonelist = zonelist;
+	ac->nodemask = nodemask;
+	ac->migratetype = gfpflags_to_migratetype(gfp_mask);
 
 	if (cpusets_enabled()) {
-		alloc_mask |= __GFP_HARDWALL;
-		alloc_flags |= ALLOC_CPUSET;
-		if (!ac.nodemask)
-			ac.nodemask = &cpuset_current_mems_allowed;
+		*alloc_mask |= __GFP_HARDWALL;
+		*alloc_flags |= ALLOC_CPUSET;
+		if (!ac->nodemask)
+			ac->nodemask = &cpuset_current_mems_allowed;
 	}
 
-	gfp_mask &= gfp_allowed_mask;
-
 	lockdep_trace_alloc(gfp_mask);
 
 	might_sleep_if(gfp_mask & __GFP_DIRECT_RECLAIM);
 
 	if (should_fail_alloc_page(gfp_mask, order))
-		return NULL;
+		return false;
 
 	/*
 	 * Check the zones suitable for the gfp_mask contain at least one
 	 * valid zone. It's possible to have an empty zonelist as a result
 	 * of __GFP_THISNODE and a memoryless node
 	 */
-	if (unlikely(!zonelist->_zonerefs->zone))
-		return NULL;
+	if (unlikely(!ac->zonelist->_zonerefs->zone))
+		return false;
+
+	if (IS_ENABLED(CONFIG_CMA) && ac->migratetype == MIGRATE_MOVABLE)
+		*alloc_flags |= ALLOC_CMA;
 
-	if (IS_ENABLED(CONFIG_CMA) && ac.migratetype == MIGRATE_MOVABLE)
-		alloc_flags |= ALLOC_CMA;
+	return true;
+}
 
+/* Determine whether to spread dirty pages and what the first usable zone */
+static inline void finalise_ac(gfp_t gfp_mask,
+		unsigned int order, struct alloc_context *ac)
+{
 	/* Dirty zone balancing only done in the fast path */
-	ac.spread_dirty_pages = (gfp_mask & __GFP_WRITE);
+	ac->spread_dirty_pages = (gfp_mask & __GFP_WRITE);
 
 	/*
 	 * The preferred zone is used for statistics but crucially it is
 	 * also used as the starting point for the zonelist iterator. It
 	 * may get reset for allocations that ignore memory policies.
 	 */
-	ac.preferred_zoneref = first_zones_zonelist(ac.zonelist,
-					ac.high_zoneidx, ac.nodemask);
+	ac->preferred_zoneref = first_zones_zonelist(ac->zonelist,
+					ac->high_zoneidx, ac->nodemask);
+}
+
+/*
+ * This is the 'heart' of the zoned buddy allocator.
+ */
+struct page *
+__alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
+			struct zonelist *zonelist, nodemask_t *nodemask)
+{
+	struct page *page;
+	unsigned int alloc_flags = ALLOC_WMARK_LOW;
+	gfp_t alloc_mask = gfp_mask; /* The gfp_t that was actually used for allocation */
+	struct alloc_context ac = { };
+
+	gfp_mask &= gfp_allowed_mask;
+	if (!prepare_alloc_pages(gfp_mask, order, zonelist, nodemask, &ac, &alloc_mask, &alloc_flags))
+		return NULL;
+
+	finalise_ac(gfp_mask, order, &ac);
 	if (!ac.preferred_zoneref->zone) {
 		page = NULL;
 		/*
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-split-buffered_rmqueue.patch
mm-page_alloc-split-alloc_pages_nodemask.patch
mm-page_alloc-drain-per-cpu-pages-from-workqueue-context.patch
mm-page_alloc-only-use-per-cpu-allocator-for-irq-safe-requests.patch

