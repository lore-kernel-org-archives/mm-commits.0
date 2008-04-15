From: akpm@linux-foundation.org
Subject: + page-allcoator-smarter-retry-of-costly-order-allocations.patch added to -mm tree
Date: Tue, 15 Apr 2008 00:08:25 -0700
Message-ID: <200804150708.m3F78Pft016156@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753210AbYDOHTQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 03:19:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nacc@us.ibm.com, apw@shadowen.org, clameter@sgi.com, haveblue@us.ibm.com, mel@csn.ul.ie


The patch titled
     page allcoator: smarter retry of costly-order allocations
has been added to the -mm tree.  Its filename is
     page-allcoator-smarter-retry-of-costly-order-allocations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page allcoator: smarter retry of costly-order allocations
From: Nishanth Aravamudan <nacc@us.ibm.com>

Because of page order checks in __alloc_pages(), hugepage (and similarly large
order) allocations will not retry unless explicitly marked __GFP_REPEAT. 
However, the current retry logic is nearly an infinite loop (or until reclaim
does no progress whatsoever).  For these costly allocations, that seems like
overkill and could potentially never terminate.

Modify try_to_free_pages() to indicate how many pages were reclaimed.  Use
that information in __alloc_pages() to eventually fail a large __GFP_REPEAT
allocation when we've reclaimed an order of pages equal to or greater than the
allocation's order.  This relies on lumpy reclaim functioning as advertised. 
Due to fragmentation, lumpy reclaim may not be able to free up the order
needed in one invocation, so multiple iterations may be requred.  In other
words, the more fragmented memory is, the more retry attempts __GFP_REPEAT
will make (particularly for higher order allocations).

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   22 +++++++++++++++++-----
 mm/vmscan.c     |    7 +++++--
 2 files changed, 22 insertions(+), 7 deletions(-)

diff -puN mm/page_alloc.c~page-allcoator-smarter-retry-of-costly-order-allocations mm/page_alloc.c
--- a/mm/page_alloc.c~page-allcoator-smarter-retry-of-costly-order-allocations
+++ a/mm/page_alloc.c
@@ -1461,7 +1461,8 @@ __alloc_pages_internal(gfp_t gfp_mask, u
 	struct task_struct *p = current;
 	int do_retry;
 	int alloc_flags;
-	int did_some_progress;
+	unsigned long did_some_progress;
+	unsigned long pages_reclaimed = 0;
 
 	might_sleep_if(wait);
 
@@ -1611,15 +1612,26 @@ nofail_alloc:
 	 * Don't let big-order allocations loop unless the caller explicitly
 	 * requests that.  Wait for some write requests to complete then retry.
 	 *
-	 * In this implementation, either order <= PAGE_ALLOC_COSTLY_ORDER or
-	 * __GFP_REPEAT mean __GFP_NOFAIL, but that may not be true in other
+	 * In this implementation, order <= PAGE_ALLOC_COSTLY_ORDER
+	 * means __GFP_NOFAIL, but that may not be true in other
 	 * implementations.
+	 *
+	 * For order > PAGE_ALLOC_COSTLY_ORDER, if __GFP_REPEAT is
+	 * specified, then we retry until we no longer reclaim any pages
+	 * (above), or we've reclaimed an order of pages at least as
+	 * large as the allocation's order. In both cases, if the
+	 * allocation still fails, we stop retrying.
 	 */
+	pages_reclaimed += did_some_progress;
 	do_retry = 0;
 	if (!(gfp_mask & __GFP_NORETRY)) {
-		if ((order <= PAGE_ALLOC_COSTLY_ORDER) ||
-						(gfp_mask & __GFP_REPEAT))
+		if (order <= PAGE_ALLOC_COSTLY_ORDER) {
 			do_retry = 1;
+		} else {
+			if (gfp_mask & __GFP_REPEAT &&
+				pages_reclaimed < (1 << order))
+					do_retry = 1;
+		}
 		if (gfp_mask & __GFP_NOFAIL)
 			do_retry = 1;
 	}
diff -puN mm/vmscan.c~page-allcoator-smarter-retry-of-costly-order-allocations mm/vmscan.c
--- a/mm/vmscan.c~page-allcoator-smarter-retry-of-costly-order-allocations
+++ a/mm/vmscan.c
@@ -1309,6 +1309,9 @@ static unsigned long shrink_zones(int pr
  * hope that some of these pages can be written.  But if the allocating task
  * holds filesystem locks which prevent writeout this might not work, and the
  * allocation attempt will fail.
+ *
+ * returns:	0, if no pages reclaimed
+ * 		else, the number of pages reclaimed
  */
 static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 					struct scan_control *sc)
@@ -1358,7 +1361,7 @@ static unsigned long do_try_to_free_page
 		}
 		total_scanned += sc->nr_scanned;
 		if (nr_reclaimed >= sc->swap_cluster_max) {
-			ret = 1;
+			ret = nr_reclaimed;
 			goto out;
 		}
 
@@ -1381,7 +1384,7 @@ static unsigned long do_try_to_free_page
 	}
 	/* top priority shrink_caches still had more to do? don't OOM, then */
 	if (!sc->all_unreclaimable && scan_global_lru(sc))
-		ret = 1;
+		ret = nr_reclaimed;
 out:
 	/*
 	 * Now that we've scanned all the zones at this priority level, note
_

Patches currently in -mm which might be from nacc@us.ibm.com are

documentation-correct-overcommit-caveat-in-hugetlbpagetxt.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask-rework.patch
mm-fix-misleading-__gfp_repeat-related-comments.patch
page-allcoator-smarter-retry-of-costly-order-allocations.patch
explicitly-retry-hugepage-allocations.patch

