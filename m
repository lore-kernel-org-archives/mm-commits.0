From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-dont-retry-initial-attempt-in-slowpath.patch removed from -mm tree
Date: Fri, 29 Jul 2016 11:57:31 -0700
Message-ID: <579ba71b.vXAGaIKneS2AmyQN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37718 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbcG2S5c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 14:57:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, mgorman@techsingularity.net, mhocko@suse.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: don't retry initial attempt in slowpath
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-dont-retry-initial-attempt-in-slowpath.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_alloc: don't retry initial attempt in slowpath

After __alloc_pages_slowpath() sets up new alloc_flags and wakes up
kswapd, it first tries get_page_from_freelist() with the new alloc_flags,
as it may succeed e.g.  due to using min watermark instead of low
watermark.  It makes sense to to do this attempt before adjusting zonelist
based on alloc_flags/gfp_mask, as it's still relatively a fast path if we
just wake up kswapd and successfully allocate.

This patch therefore moves the initial attempt above the retry label and
reorganizes a bit the part below the retry label.  We still have to
attempt get_page_from_freelist() on each retry, as some allocations cannot
do that as part of direct reclaim or compaction, and yet are not allowed
to fail (even though they do a WARN_ON_ONCE() and thus should not exist). 
We can reuse the call meant for ALLOC_NO_WATERMARKS attempt and just set
alloc_flags to ALLOC_NO_WATERMARKS if the context allows it.  As a
side-effect, the attempts from direct reclaim/compaction will also no
longer obey watermarks once this is set, but there's little harm in that.

Kswapd wakeups are also done on each retry to be safe from potential races
resulting in kswapd going to sleep while a process (that may not be able
to reclaim by itself) is still looping.

Link: http://lkml.kernel.org/r/20160721073614.24395-4-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-dont-retry-initial-attempt-in-slowpath mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-dont-retry-initial-attempt-in-slowpath
+++ a/mm/page_alloc.c
@@ -3510,35 +3510,42 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	 */
 	alloc_flags = gfp_to_alloc_flags(gfp_mask);
 
+	if (gfp_mask & __GFP_KSWAPD_RECLAIM)
+		wake_all_kswapds(order, ac);
+
+	/*
+	 * The adjusted alloc_flags might result in immediate success, so try
+	 * that first
+	 */
+	page = get_page_from_freelist(gfp_mask, order, alloc_flags, ac);
+	if (page)
+		goto got_pg;
+
+
 retry:
+	/* Ensure kswapd doesn't accidentally go to sleep as long as we loop */
 	if (gfp_mask & __GFP_KSWAPD_RECLAIM)
 		wake_all_kswapds(order, ac);
 
+	if (gfp_pfmemalloc_allowed(gfp_mask))
+		alloc_flags = ALLOC_NO_WATERMARKS;
+
 	/*
 	 * Reset the zonelist iterators if memory policies can be ignored.
 	 * These allocations are high priority and system rather than user
 	 * orientated.
 	 */
-	if (!(alloc_flags & ALLOC_CPUSET) || gfp_pfmemalloc_allowed(gfp_mask)) {
+	if (!(alloc_flags & ALLOC_CPUSET) || (alloc_flags & ALLOC_NO_WATERMARKS)) {
 		ac->zonelist = node_zonelist(numa_node_id(), gfp_mask);
 		ac->preferred_zoneref = first_zones_zonelist(ac->zonelist,
 					ac->high_zoneidx, ac->nodemask);
 	}
 
-	/* This is the last chance, in general, before the goto nopage. */
+	/* Attempt with potentially adjusted zonelist and alloc_flags */
 	page = get_page_from_freelist(gfp_mask, order, alloc_flags, ac);
 	if (page)
 		goto got_pg;
 
-	/* Allocate without watermarks if the context allows */
-	if (gfp_pfmemalloc_allowed(gfp_mask)) {
-
-		page = get_page_from_freelist(gfp_mask, order,
-						ALLOC_NO_WATERMARKS, ac);
-		if (page)
-			goto got_pg;
-	}
