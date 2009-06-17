From: akpm@linux-foundation.org
Subject: [merged] page-allocator-do-not-setup-zonelist-cache-when-there-is-only-one-node.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:34:12 -0700
Message-ID: <200906171834.n5HIYCTG032754@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51480 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759931AbZFQSel (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:34:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, Lee.Schermerhorn@hp.com, a.p.zijlstra@chello.nl, cl@linux-foundation.org, dave@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, nickpiggin@yahoo.com.au, penberg@cs.h


The patch titled
     page allocator: do not setup zonelist cache when there is only one node
has been removed from the -mm tree.  Its filename was
     page-allocator-do-not-setup-zonelist-cache-when-there-is-only-one-node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page allocator: do not setup zonelist cache when there is only one node
From: Mel Gorman <mel@csn.ul.ie>

There is a zonelist cache which is used to track zones that are not in the
allowed cpuset or found to be recently full.  This is to reduce cache
footprint on large machines.  On smaller machines, it just incurs cost for
no gain.  This patch only uses the zonelist cache when there are NUMA
nodes.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~page-allocator-do-not-setup-zonelist-cache-when-there-is-only-one-node mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-do-not-setup-zonelist-cache-when-there-is-only-one-node
+++ a/mm/page_alloc.c
@@ -1464,8 +1464,11 @@ this_zone_full:
 		if (NUMA_BUILD)
 			zlc_mark_zone_full(zonelist, z);
 try_next_zone:
-		if (NUMA_BUILD && !did_zlc_setup) {
-			/* we do zlc_setup after the first zone is tried */
+		if (NUMA_BUILD && !did_zlc_setup && num_online_nodes() > 1) {
+			/*
+			 * we do zlc_setup after the first zone is tried but only
+			 * if there are multiple nodes make it worthwhile
+			 */
 			allowednodes = zlc_setup(zonelist, alloc_flags);
 			zlc_active = 1;
 			did_zlc_setup = 1;
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
linux-next.patch
page_alloc-oops-when-setting-percpu_pagelist_fraction.patch
memcg-fix-lru-rotation-in-isolate_pages.patch
add-debugging-aid-for-memory-initialisation-problems.patch

