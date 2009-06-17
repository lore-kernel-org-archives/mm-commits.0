From: akpm@linux-foundation.org
Subject: [merged] page-allocator-check-only-once-if-the-zonelist-is-suitable-for-the-allocation.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:33:39 -0700
Message-ID: <200906171833.n5HIXdL4032123@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48303 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759777AbZFQSe1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:34:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, Lee.Schermerhorn@hp.com, a.p.zijlstra@chello.nl, cl@linux-foundation.org, dave@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, nickpiggin@yahoo.com.au, penberg@cs.h


The patch titled
     page allocator: check only once if the zonelist is suitable for the allocation
has been removed from the -mm tree.  Its filename was
     page-allocator-check-only-once-if-the-zonelist-is-suitable-for-the-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page allocator: check only once if the zonelist is suitable for the allocation
From: Mel Gorman <mel@csn.ul.ie>

It is possible with __GFP_THISNODE that no zones are suitable.  This patch
makes sure the check is only made once.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~page-allocator-check-only-once-if-the-zonelist-is-suitable-for-the-allocation mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-check-only-once-if-the-zonelist-is-suitable-for-the-allocation
+++ a/mm/page_alloc.c
@@ -1483,9 +1483,8 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	if (should_fail_alloc_page(gfp_mask, order))
 		return NULL;
 
-restart:
-	z = zonelist->_zonerefs;  /* the list of zones suitable for gfp_mask */
