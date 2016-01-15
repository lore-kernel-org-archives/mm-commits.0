From: akpm@linux-foundation.org
Subject: [merged]
 mm-oom-give-__gfp_nofail-allocations-access-to-memory-reserves.patch
 removed from -mm tree
Date: Fri, 15 Jan 2016 14:34:09 -0800
Message-ID: <569973e1.eDeR2rSFq0udFo2E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59547 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbcAOWeK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:34:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, aarcange@redhat.com, hannes@cmpxchg.org, mgorman@techsingularity.net, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: give __GFP_NOFAIL allocations access to memory reserves
has been removed from the -mm tree.  Its filename was
     mm-oom-give-__gfp_nofail-allocations-access-to-memory-reserves.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, oom: give __GFP_NOFAIL allocations access to memory reserves

__GFP_NOFAIL is a big hammer used to ensure that the allocation request
can never fail.  This is a strong requirement and as such it also deserves
a special treatment when the system is OOM.  The primary problem here is
that the allocation request might have come with some locks held and the
oom victim might be blocked on the same locks.  This is basically an OOM
deadlock situation.

This patch tries to reduce the risk of such a deadlocks by giving
__GFP_NOFAIL allocations a special treatment and let them dive into memory
reserves after oom killer invocation.  This should help them to make a
progress and release resources they are holding.  The OOM victim should
compensate for the reserves consumption.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Suggested-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-oom-give-__gfp_nofail-allocations-access-to-memory-reserves mm/page_alloc.c
--- a/mm/page_alloc.c~mm-oom-give-__gfp_nofail-allocations-access-to-memory-reserves
+++ a/mm/page_alloc.c
@@ -2732,8 +2732,21 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 			goto out;
 	}
 	/* Exhausted what can be done so it's blamo time */
-	if (out_of_memory(&oc) || WARN_ON_ONCE(gfp_mask & __GFP_NOFAIL))
+	if (out_of_memory(&oc) || WARN_ON_ONCE(gfp_mask & __GFP_NOFAIL)) {
 		*did_some_progress = 1;
+
+		if (gfp_mask & __GFP_NOFAIL) {
+			page = get_page_from_freelist(gfp_mask, order,
+					ALLOC_NO_WATERMARKS|ALLOC_CPUSET, ac);
+			/*
+			 * fallback to ignore cpuset restriction if our nodes
+			 * are depleted
+			 */
+			if (!page)
+				page = get_page_from_freelist(gfp_mask, order,
+					ALLOC_NO_WATERMARKS, ac);
+		}
+	}
 out:
 	mutex_unlock(&oom_lock);
 	return page;
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations.patch
mm-oom-introduce-oom-reaper.patch
mm-oom-introduce-oom-reaper-v4.patch
oom-reaper-handle-anonymous-mlocked-pages.patch
oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space.patch

