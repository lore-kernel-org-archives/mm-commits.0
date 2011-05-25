From: akpm@linux-foundation.org
Subject: [merged] mm-compaction-reverse-the-change-that-forbade-sync-migraton-with-__gfp_no_kswapd.patch removed from -mm tree
Date: Wed, 25 May 2011 13:27:50 -0700
Message-ID: <201105252026.p4PKQDo6014478@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753334Ab1EYU1O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:27:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, avillaci@fiec.espol.edu.ec, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     mm/compaction: reverse the change that forbade sync migraton with __GFP_NO_KSWAPD
has been removed from the -mm tree.  Its filename was
     mm-compaction-reverse-the-change-that-forbade-sync-migraton-with-__gfp_no_kswapd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/compaction: reverse the change that forbade sync migraton with __GFP_NO_KSWAPD
From: Andrea Arcangeli <aarcange@redhat.com>

It's uncertain this has been beneficial, so it's safer to undo it.  All
other compaction users would still go in synchronous mode if a first
attempt at async compaction failed.  Hopefully we don't need to force
special behavior for THP (which is the only __GFP_NO_KSWAPD user so far
and it's the easier to exercise and to be noticeable).  This also make
__GFP_NO_KSWAPD return to its original strict semantics specific to bypass
kswapd, as THP allocations have khugepaged for the async THP
allocations/compactions.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Alex Villacis Lasso <avillaci@fiec.espol.edu.ec>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-compaction-reverse-the-change-that-forbade-sync-migraton-with-__gfp_no_kswapd mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-reverse-the-change-that-forbade-sync-migraton-with-__gfp_no_kswapd
+++ a/mm/page_alloc.c
@@ -2107,7 +2107,7 @@ rebalance:
 					sync_migration);
 	if (page)
 		goto got_pg;
-	sync_migration = !(gfp_mask & __GFP_NO_KSWAPD);
+	sync_migration = true;
 
 	/* Try direct reclaim and then allocating */
 	page = __alloc_pages_direct_reclaim(gfp_mask, order,
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
mm-hugepages-can-cause-negative-commitlimit.patch

