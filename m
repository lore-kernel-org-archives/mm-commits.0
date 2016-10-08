From: akpm@linux-foundation.org
Subject: [patch 102/127] mm: warn about allocations which stall for too
 long
Date: Fri, 07 Oct 2016 17:01:58 -0700
Message-ID: <57f83776.oWtkHtULWoCkHdlh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39523 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932840AbcJHAB7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 20:01:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, dave.hansen@intel.com, hannes@cmpxchg.org, mgorman@suse.de, penguin-kernel@I-love.SAKURA.ne.jp, vbabka@suse.cz

From: Michal Hocko <mhocko@suse.com>
Subject: mm: warn about allocations which stall for too long

Currently we do warn only about allocation failures but small allocations
are basically nofail and they might loop in the page allocator for a long
time.  Especially when the reclaim cannot make any progress - e.g. 
GFP_NOFS cannot invoke the oom killer and rely on a different context to
make a forward progress in case there is a lot memory used by filesystems.

Give us at least a clue when something like this happens and warn about
allocations which take more than 10s.  Print the basic allocation context
information along with the cumulative time spent in the allocation as well
as the allocation stack.  Repeat the warning after every 10 seconds so
that we know that the problem is permanent rather than ephemeral.

Link: http://lkml.kernel.org/r/20160929084407.7004-3-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN mm/page_alloc.c~mm-warn-about-allocations-which-stall-for-too-long mm/page_alloc.c
--- a/mm/page_alloc.c~mm-warn-about-allocations-which-stall-for-too-long
+++ a/mm/page_alloc.c
@@ -3493,6 +3493,8 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	enum compact_result compact_result;
 	int compaction_retries = 0;
 	int no_progress_loops = 0;
+	unsigned long alloc_start = jiffies;
+	unsigned int stall_timeout = 10 * HZ;
 
 	/*
 	 * In the slowpath, we sanity check order to avoid ever trying to
@@ -3648,6 +3650,14 @@ retry:
 	if (order > PAGE_ALLOC_COSTLY_ORDER && !(gfp_mask & __GFP_REPEAT))
 		goto nopage;
 
+	/* Make sure we know about allocations which stall for too long */
+	if (time_after(jiffies, alloc_start + stall_timeout)) {
+		warn_alloc(gfp_mask,
+			"page alloction stalls for %ums, order:%u\n",
+			jiffies_to_msecs(jiffies-alloc_start), order);
+		stall_timeout += 10 * HZ;
+	}
+
 	if (should_reclaim_retry(gfp_mask, order, ac, alloc_flags,
 				 did_some_progress > 0, &no_progress_loops))
 		goto retry;
_
