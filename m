From: akpm@linux-foundation.org
Subject: [merged] mm-ignore-mempolicies-when-using-alloc_no_watermark.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:15:56 -0700
Message-ID: <20120801201556.E183C1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:52099 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878Ab2HAUP6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:15:58 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5412588obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:15:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, a.p.zijlstra@chello.nl, cl@linux.com, davem@davemloft.net, emunson@mgebm.net, eric.dumazet@gmail.com, michaelc@cs.wisc.edu, neilb@suse.de, sebastian@breakpoint.cc, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: ignore mempolicies when using ALLOC_NO_WATERMARK
has been removed from the -mm tree.  Its filename was
     mm-ignore-mempolicies-when-using-alloc_no_watermark.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: ignore mempolicies when using ALLOC_NO_WATERMARK

The reserve is proportionally distributed over all !highmem zones in the
system.  So we need to allow an emergency allocation access to all zones. 
In order to do that we need to break out of any mempolicy boundaries we
might have.

In my opinion that does not break mempolicies as those are user oriented
and not system oriented.  That is, system allocations are not guaranteed
to be within mempolicy boundaries.  For instance IRQs do not even have a
mempolicy.

So breaking out of mempolicy boundaries for 'rare' emergency allocations,
which are always system allocations (as opposed to user) is ok.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: David Miller <davem@davemloft.net>
Cc: Neil Brown <neilb@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN mm/page_alloc.c~mm-ignore-mempolicies-when-using-alloc_no_watermark mm/page_alloc.c
--- a/mm/page_alloc.c~mm-ignore-mempolicies-when-using-alloc_no_watermark
+++ a/mm/page_alloc.c
@@ -2378,6 +2378,13 @@ rebalance:
 
 	/* Allocate without watermarks if the context allows */
 	if (alloc_flags & ALLOC_NO_WATERMARKS) {
+		/*
+		 * Ignore mempolicies if ALLOC_NO_WATERMARKS on the grounds
+		 * the allocation is high priority and these type of
+		 * allocations are system rather than user orientated
+		 */
+		zonelist = node_zonelist(numa_node_id(), gfp_mask);
+
 		page = __alloc_pages_high_priority(gfp_mask, order,
 				zonelist, high_zoneidx, nodemask,
 				preferred_zone, migratetype);
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch

