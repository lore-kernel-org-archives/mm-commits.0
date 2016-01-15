From: akpm@linux-foundation.org
Subject: [merged]
 mm-do-not-loop-over-alloc_no_watermarks-without-triggering-reclaim.patch
 removed from -mm tree
Date: Fri, 15 Jan 2016 14:33:00 -0800
Message-ID: <5699739c.Y0BgRMgqliEVSupG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59296 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbcAOWdB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:33:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, mgorman@suse.de, penguin-kernel@i-love.sakura.ne.jp, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: do not loop over ALLOC_NO_WATERMARKS without triggering reclaim
has been removed from the -mm tree.  Its filename was
     mm-do-not-loop-over-alloc_no_watermarks-without-triggering-reclaim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm/page_alloc.c: do not loop over ALLOC_NO_WATERMARKS without triggering reclaim

__alloc_pages_slowpath is looping over ALLOC_NO_WATERMARKS requests if
__GFP_NOFAIL is requested.  This is fragile because we are basically
relying on somebody else to make the reclaim (be it the direct reclaim or
OOM killer) for us.  The caller might be holding resources (e.g.  locks)
which block other other reclaimers from making any progress for example. 
Remove the retry loop and rely on __alloc_pages_slowpath to invoke all
allowed reclaim steps and retry logic.

We have to be careful about __GFP_NOFAIL allocations from the PF_MEMALLOC
context even though this is a very bad idea to begin with because no
progress can be gurateed at all.  We shouldn't break the __GFP_NOFAIL
semantic here though.  It could be argued that this is essentially
GFP_NOWAIT context which we do not support but PF_MEMALLOC is much harder
to check for existing users because they might happen deep down the code
path performed much later after setting the flag so we cannot really rule
out there is no kernel path triggering this combination.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff -puN mm/page_alloc.c~mm-do-not-loop-over-alloc_no_watermarks-without-triggering-reclaim mm/page_alloc.c
--- a/mm/page_alloc.c~mm-do-not-loop-over-alloc_no_watermarks-without-triggering-reclaim
+++ a/mm/page_alloc.c
@@ -3020,32 +3020,36 @@ retry:
 		 * allocations are system rather than user orientated
 		 */
 		ac->zonelist = node_zonelist(numa_node_id(), gfp_mask);
-		do {
-			page = get_page_from_freelist(gfp_mask, order,
-						      ALLOC_NO_WATERMARKS, ac);
-			if (page)
-				goto got_pg;
-
-			if (gfp_mask & __GFP_NOFAIL)
-				wait_iff_congested(ac->preferred_zone,
-						   BLK_RW_ASYNC, HZ/50);
-		} while (gfp_mask & __GFP_NOFAIL);
+		page = get_page_from_freelist(gfp_mask, order,
+						ALLOC_NO_WATERMARKS, ac);
+		if (page)
+			goto got_pg;
 	}
 
 	/* Caller is not willing to reclaim, we can't balance anything */
 	if (!can_direct_reclaim) {
 		/*
-		 * All existing users of the deprecated __GFP_NOFAIL are
-		 * blockable, so warn of any new users that actually allow this
-		 * type of allocation to fail.
+		 * All existing users of the __GFP_NOFAIL are blockable, so warn
+		 * of any new users that actually allow this type of allocation
+		 * to fail.
 		 */
 		WARN_ON_ONCE(gfp_mask & __GFP_NOFAIL);
 		goto nopage;
 	}
 
 	/* Avoid recursion of direct reclaim */
-	if (current->flags & PF_MEMALLOC)
+	if (current->flags & PF_MEMALLOC) {
+		/*
+		 * __GFP_NOFAIL request from this context is rather bizarre
+		 * because we cannot reclaim anything and only can loop waiting
+		 * for somebody to do a work for us.
+		 */
+		if (WARN_ON_ONCE(gfp_mask & __GFP_NOFAIL)) {
+			cond_resched();
+			goto retry;
+		}
 		goto nopage;
+	}
 
 	/* Avoid allocations with no watermarks from looping endlessly */
 	if (test_thread_flag(TIF_MEMDIE) && !(gfp_mask & __GFP_NOFAIL))
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations.patch
mm-oom-introduce-oom-reaper.patch
mm-oom-introduce-oom-reaper-v4.patch
oom-reaper-handle-anonymous-mlocked-pages.patch
oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space.patch

