From: akpm@linux-foundation.org
Subject: + mm-invoke-oom-killer-for-__gfp_nofail.patch added to -mm tree
Date: Mon, 11 May 2009 13:28:55 -0700
Message-ID: <200905112028.n4BKSt1D029034@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52905 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753953AbZEKUer (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 May 2009 16:34:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, a.p.zijlstra@chello.nl, cl@linux-foundation.org, dave@linux.vnet.ibm.com, mel@csn.ul.ie, minchan.kim@gmail.com, npiggin@suse.de, riel@redhat.com


The patch titled
     mm: invoke oom killer for __GFP_NOFAIL
has been added to the -mm tree.  Its filename is
     mm-invoke-oom-killer-for-__gfp_nofail.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: invoke oom killer for __GFP_NOFAIL
From: David Rientjes <rientjes@google.com>

The oom killer must be invoked regardless of the order if the allocation
is __GFP_NOFAIL, otherwise it will loop forever when reclaim fails to free
some memory.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff -puN mm/page_alloc.c~mm-invoke-oom-killer-for-__gfp_nofail mm/page_alloc.c
--- a/mm/page_alloc.c~mm-invoke-oom-killer-for-__gfp_nofail
+++ a/mm/page_alloc.c
@@ -1547,7 +1547,7 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 		goto out;
 
 	/* The OOM killer will not help higher order allocs */
-	if (order > PAGE_ALLOC_COSTLY_ORDER)
+	if (order > PAGE_ALLOC_COSTLY_ORDER && !(gfp_mask & __GFP_NOFAIL))
 		goto out;
 
 	/* Exhausted what can be done so it's blamo time */
@@ -1763,16 +1763,12 @@ rebalance:
 					migratetype);
 			if (page)
 				goto got_pg;
+			if ((gfp_mask & __GFP_NOFAIL) ||
+					order <= PAGE_ALLOC_COSTLY_ORDER)
+				goto restart;
 
-			/*
-			 * The OOM killer does not trigger for high-order allocations
-			 * but if no progress is being made, there are no other
-			 * options and retrying is unlikely to help
-			 */
-			if (order > PAGE_ALLOC_COSTLY_ORDER)
-				goto nopage;
