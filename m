From: akpm@linux-foundation.org
Subject: [merged] mm-page_allocc-prevent-unending-loop-in-__alloc_pages_slowpath.patch removed from -mm tree
Date: Wed, 25 May 2011 13:30:31 -0700
Message-ID: <201105252028.p4PKSsqE014793@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35011 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756358Ab1EYUtP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:49:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: abarry@cray.com, mgorman@suse.de, minchan.kim@gmail.com, riel@redhat.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mm/page_alloc.c: prevent unending loop in __alloc_pages_slowpath()
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-prevent-unending-loop-in-__alloc_pages_slowpath.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/page_alloc.c: prevent unending loop in __alloc_pages_slowpath()
From: Andrew Barry <abarry@cray.com>

I believe I found a problem in __alloc_pages_slowpath, which allows a
process to get stuck endlessly looping, even when lots of memory is
available.

Running an I/O and memory intensive stress-test I see a 0-order page
allocation with __GFP_IO and __GFP_WAIT, running on a system with very
little free memory.  Right about the same time that the stress-test gets
killed by the OOM-killer, the utility trying to allocate memory gets stuck
in __alloc_pages_slowpath even though most of the systems memory was freed
by the oom-kill of the stress-test.

The utility ends up looping from the rebalance label down through the
wait_iff_congested continiously.  Because order=0,
__alloc_pages_direct_compact skips the call to get_page_from_freelist. 
Because all of the reclaimable memory on the system has already been
reclaimed, __alloc_pages_direct_reclaim skips the call to
get_page_from_freelist.  Since there is no __GFP_FS flag, the block with
__alloc_pages_may_oom is skipped.  The loop hits the wait_iff_congested,
then jumps back to rebalance without ever trying to
get_page_from_freelist.  This loop repeats infinitely.

The test case is pretty pathological.  Running a mix of I/O stress-tests
that do a lot of fork() and consume all of the system memory, I can pretty
reliably hit this on 600 nodes, in about 12 hours.  32GB/node.

Signed-off-by: Andrew Barry <abarry@cray.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: Rik van Riel<riel@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_allocc-prevent-unending-loop-in-__alloc_pages_slowpath mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-prevent-unending-loop-in-__alloc_pages_slowpath
+++ a/mm/page_alloc.c
@@ -2106,6 +2106,7 @@ restart:
 		first_zones_zonelist(zonelist, high_zoneidx, NULL,
 					&preferred_zone);
 
+rebalance:
 	/* This is the last chance, in general, before the goto nopage. */
 	page = get_page_from_freelist(gfp_mask, nodemask, order, zonelist,
 			high_zoneidx, alloc_flags & ~ALLOC_NO_WATERMARKS,
@@ -2113,7 +2114,6 @@ restart:
 	if (page)
 		goto got_pg;
 
-rebalance:
 	/* Allocate without watermarks if the context allows */
 	if (alloc_flags & ALLOC_NO_WATERMARKS) {
 		page = __alloc_pages_high_priority(gfp_mask, order,
_

Patches currently in -mm which might be from abarry@cray.com are

origin.patch

