From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-move-cpuset-seqcount-checking-to-slowpath.patch removed from
 -mm tree
Date: Wed, 25 Jan 2017 14:05:06 -0800
Message-ID: <58892112.ACZSfjZ5F84T0mDu%akpm__32830.2129208625$1485381933$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42150 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752488AbdAYWFH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2017 17:05:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, gpkulkarni@gmail.com, hillf.zj@alibaba-inc.com, mgorman@techsingularity.net, mhocko@suse.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: move cpuset seqcount checking to slowpath
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-move-cpuset-seqcount-checking-to-slowpath.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_alloc: move cpuset seqcount checking to slowpath

This is a preparation for the following patch to make review simpler. 
While the primary motivation is a bug fix, this also simplifies the fast
path, although the moved code is only enabled when cpusets are in use.

Link: http://lkml.kernel.org/r/20170120103843.24587-4-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Ganapatrao Kulkarni <gpkulkarni@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   47 +++++++++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 21 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-move-cpuset-seqcount-checking-to-slowpath mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-move-cpuset-seqcount-checking-to-slowpath
+++ a/mm/page_alloc.c
@@ -3523,12 +3523,13 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	struct page *page = NULL;
 	unsigned int alloc_flags;
 	unsigned long did_some_progress;
-	enum compact_priority compact_priority = DEF_COMPACT_PRIORITY;
+	enum compact_priority compact_priority;
 	enum compact_result compact_result;
-	int compaction_retries = 0;
-	int no_progress_loops = 0;
+	int compaction_retries;
+	int no_progress_loops;
 	unsigned long alloc_start = jiffies;
 	unsigned int stall_timeout = 10 * HZ;
+	unsigned int cpuset_mems_cookie;
 
 	/*
 	 * In the slowpath, we sanity check order to avoid ever trying to
@@ -3549,6 +3550,12 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 				(__GFP_ATOMIC|__GFP_DIRECT_RECLAIM)))
 		gfp_mask &= ~__GFP_ATOMIC;
 
+retry_cpuset:
+	compaction_retries = 0;
+	no_progress_loops = 0;
+	compact_priority = DEF_COMPACT_PRIORITY;
+	cpuset_mems_cookie = read_mems_allowed_begin();
+
 	/*
 	 * The fast path uses conservative alloc_flags to succeed only until
 	 * kswapd needs to be woken up, and to avoid the cost of setting up
@@ -3720,6 +3727,15 @@ retry:
 	}
 
 nopage:
+	/*
+	 * When updating a task's mems_allowed, it is possible to race with
+	 * parallel threads in such a way that an allocation can fail while
+	 * the mask is being updated. If a page allocation is about to fail,
+	 * check if the cpuset changed during allocation and if so, retry.
+	 */
+	if (read_mems_allowed_retry(cpuset_mems_cookie))
+		goto retry_cpuset;
+
 	warn_alloc(gfp_mask,
 			"page allocation failure: order:%u", order);
 got_pg:
@@ -3734,7 +3750,6 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 			struct zonelist *zonelist, nodemask_t *nodemask)
 {
 	struct page *page;
-	unsigned int cpuset_mems_cookie;
 	unsigned int alloc_flags = ALLOC_WMARK_LOW;
 	gfp_t alloc_mask = gfp_mask; /* The gfp_t that was actually used for allocation */
 	struct alloc_context ac = {
@@ -3771,9 +3786,6 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	if (IS_ENABLED(CONFIG_CMA) && ac.migratetype == MIGRATE_MOVABLE)
 		alloc_flags |= ALLOC_CMA;
 
-retry_cpuset:
-	cpuset_mems_cookie = read_mems_allowed_begin();
-
 	/* Dirty zone balancing only done in the fast path */
 	ac.spread_dirty_pages = (gfp_mask & __GFP_WRITE);
 
@@ -3786,6 +3798,11 @@ retry_cpuset:
 					ac.high_zoneidx, ac.nodemask);
 	if (!ac.preferred_zoneref->zone) {
 		page = NULL;
+		/*
+		 * This might be due to race with cpuset_current_mems_allowed
+		 * update, so make sure we retry with original nodemask in the
+		 * slow path.
+		 */
 		goto no_zone;
 	}
 
@@ -3794,6 +3811,7 @@ retry_cpuset:
 	if (likely(page))
 		goto out;
 
+no_zone:
 	/*
 	 * Runtime PM, block IO and its error handling path can deadlock
 	 * because I/O on the device might not complete.
@@ -3811,24 +3829,11 @@ retry_cpuset:
 		ac.nodemask = nodemask;
 		ac.preferred_zoneref = first_zones_zonelist(ac.zonelist,
 						ac.high_zoneidx, ac.nodemask);
-		if (!ac.preferred_zoneref->zone)
-			goto no_zone;
+		/* If we have NULL preferred zone, slowpath wll handle that */
 	}
 
 	page = __alloc_pages_slowpath(alloc_mask, order, &ac);
 
-no_zone:
-	/*
-	 * When updating a task's mems_allowed, it is possible to race with
-	 * parallel threads in such a way that an allocation can fail while
-	 * the mask is being updated. If a page allocation is about to fail,
-	 * check if the cpuset changed during allocation and if so, retry.
-	 */
-	if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie))) {
-		alloc_mask = gfp_mask;
-		goto retry_cpuset;
-	}
