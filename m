From: akpm@linux-foundation.org
Subject: - page-allcoator-smarter-retry-of-costly-order-allocations.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:38:31 -0700
Message-ID: <200804300538.m3U5cWnc028756@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50784 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752231AbYD3Fiz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:38:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nacc@us.ibm.com, apw@shadowen.org, clameter@sgi.com, haveblue@us.ibm.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     page allocator: smarter retry of costly-order allocations
has been removed from the -mm tree.  Its filename was
     page-allcoator-smarter-retry-of-costly-order-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page allocator: smarter retry of costly-order allocations
From: Nishanth Aravamudan <nacc@us.ibm.com>

Because of page order checks in __alloc_pages(), hugepage (and similarly
large order) allocations will not retry unless explicitly marked
__GFP_REPEAT. However, the current retry logic is nearly an infinite
loop (or until reclaim does no progress whatsoever). For these costly
allocations, that seems like overkill and could potentially never
terminate. Mel observed that allowing current __GFP_REPEAT semantics for
hugepage allocations essentially killed the system. I believe this is
because we may continue to reclaim small orders of pages all over, but
never have enough to satisfy the hugepage allocation request. This is
clearly only a problem for large order allocations, of which hugepages
are the most obvious (to me).

Modify try_to_free_pages() to indicate how many pages were reclaimed.
Use that information in __alloc_pages() to eventually fail a large
__GFP_REPEAT allocation when we've reclaimed an order of pages equal to
or greater than the allocation's order. This relies on lumpy reclaim
functioning as advertised. Due to fragmentation, lumpy reclaim may not
be able to free up the order needed in one invocation, so multiple
iterations may be requred. In other words, the more fragmented memory
is, the more retry attempts __GFP_REPEAT will make (particularly for
higher order allocations).

This changes the semantics of __GFP_REPEAT subtly, but *only* for
allocations > PAGE_ALLOC_COSTLY_ORDER. With this patch, for those size
allocations, we will try up to some point (at least 1<<order reclaimed
pages), rather than forever (which is the case for allocations <=
PAGE_ALLOC_COSTLY_ORDER).

This change improves the /proc/sys/vm/nr_hugepages interface with a
follow-on patch that makes pool allocations use __GFP_REPEAT. Rather
than administrators repeatedly echo'ing a particular value into the
sysctl, and forcing reclaim into action manually, this change allows for
the sysctl to attempt a reasonable effort itself. Similarly, dynamic
pool growth should be more successful under load, as lumpy reclaim can
try to free up pages, rather than failing right away.

Choosing to reclaim only up to the order of the requested allocation
strikes a balance between not failing hugepage allocations and returning
to the caller when it's unlikely to every succeed. Because of lumpy
reclaim, if we have freed the order requested, hopefully it has been in
big chunks and those chunks will allow our allocation to succeed. If
that isn't the case after freeing up the current order, I don't think it
is likely to succeed in the future, although it is possible given a
particular fragmentation pattern.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Tested-by: Mel Gorman <mel@csn.ul.ie>
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
@@ -1299,6 +1299,9 @@ static unsigned long shrink_zones(int pr
  * hope that some of these pages can be written.  But if the allocating task
  * holds filesystem locks which prevent writeout this might not work, and the
  * allocation attempt will fail.
+ *
+ * returns:	0, if no pages reclaimed
+ * 		else, the number of pages reclaimed
  */
 static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 					struct scan_control *sc)
@@ -1347,7 +1350,7 @@ static unsigned long do_try_to_free_page
 		}
 		total_scanned += sc->nr_scanned;
 		if (nr_reclaimed >= sc->swap_cluster_max) {
-			ret = 1;
+			ret = nr_reclaimed;
 			goto out;
 		}
 
@@ -1370,7 +1373,7 @@ static unsigned long do_try_to_free_page
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

origin.patch

