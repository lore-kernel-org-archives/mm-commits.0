From: akpm@linux-foundation.org
Subject: [merged]
 mmpage_alloc-dont-call-__node_reclaim-with-oom_lock-held.patch removed from
 -mm tree
Date: Tue, 05 Sep 2017 12:51:40 -0700
Message-ID: <20170905195140.WSBDlb42s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37764 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752292AbdIETvm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Sep 2017 15:51:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, vbabka@suse.cz


The patch titled
     Subject: mm,page_alloc: don't call __node_reclaim() with oom_lock held.
has been removed from the -mm tree.  Its filename was
     mmpage_alloc-dont-call-__node_reclaim-with-oom_lock-held.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: mm,page_alloc: don't call __node_reclaim() with oom_lock held.

We are doing last second memory allocation attempt before calling
out_of_memory().  But since slab shrinker functions might indirectly wait
for other thread's __GFP_DIRECT_RECLAIM && !__GFP_NORETRY memory
allocations via sleeping locks, calling slab shrinker functions from
node_reclaim() from get_page_from_freelist() with oom_lock held has
possibility of deadlock.  Therefore, make sure that last second memory
allocation attempt does not call slab shrinker functions.

Link: http://lkml.kernel.org/r/1503577106-9196-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mmpage_alloc-dont-call-__node_reclaim-with-oom_lock-held mm/page_alloc.c
--- a/mm/page_alloc.c~mmpage_alloc-dont-call-__node_reclaim-with-oom_lock-held
+++ a/mm/page_alloc.c
@@ -3291,10 +3291,13 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 	/*
 	 * Go through the zonelist yet one more time, keep very high watermark
 	 * here, this is only to catch a parallel oom killing, we must fail if
-	 * we're still under heavy pressure.
+	 * we're still under heavy pressure. But make sure that this reclaim
+	 * attempt shall not depend on __GFP_DIRECT_RECLAIM && !__GFP_NORETRY
+	 * allocation which will never fail due to oom_lock already held.
 	 */
-	page = get_page_from_freelist(gfp_mask | __GFP_HARDWALL, order,
-					ALLOC_WMARK_HIGH|ALLOC_CPUSET, ac);
+	page = get_page_from_freelist((gfp_mask | __GFP_HARDWALL) &
+				      ~__GFP_DIRECT_RECLAIM, order,
+				      ALLOC_WMARK_HIGH|ALLOC_CPUSET, ac);
 	if (page)
 		goto out;
 
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are


