From: akpm@linux-foundation.org
Subject: [merged] page-allocator-replace-__alloc_pages_internal-with-__alloc_pages_nodemask.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:33:31 -0700
Message-ID: <200906171833.n5HIXVvj032088@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40758 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755947AbZFQSeX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:34:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, Lee.Schermerhorn@hp.com, a.p.zijlstra@chello.nl, cl@linux-foundation.org, dave@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, nickpiggin@yahoo.com.au, penberg@cs.h


The patch titled
     page allocator: replace __alloc_pages_internal() with __alloc_pages_nodemask()
has been removed from the -mm tree.  Its filename was
     page-allocator-replace-__alloc_pages_internal-with-__alloc_pages_nodemask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page allocator: replace __alloc_pages_internal() with __alloc_pages_nodemask()
From: Mel Gorman <mel@csn.ul.ie>

The start of a large patch series to clean up and optimise the page
allocator.

The performance improvements are in a wide range depending on the exact
machine but the results I've seen so fair are approximately;

kernbench:	0	to	 0.12% (elapsed time)
		0.49%	to	 3.20% (sys time)
aim9:		-4%	to	30% (for page_test and brk_test)
tbench:		-1%	to	 4%
hackbench:	-2.5%	to	 3.45% (mostly within the noise though)
netperf-udp	-1.34%  to	 4.06% (varies between machines a bit)
netperf-tcp	-0.44%  to	 5.22% (varies between machines a bit)

I haven't sysbench figures at hand, but previously they were within the
-0.5% to 2% range.

On netperf, the client and server were bound to opposite number CPUs to
maximise the problems with cache line bouncing of the struct pages so I
expect different people to report different results for netperf depending
on their exact machine and how they ran the test (different machines, same
cpus client/server, shared cache but two threads client/server, different
socket client/server etc).

I also measured the vmlinux sizes for a single x86-based config with
CONFIG_DEBUG_INFO enabled but not CONFIG_DEBUG_VM.  The core of the
.config is based on the Debian Lenny kernel config so I expect it to be
reasonably typical.


This patch:

__alloc_pages_internal is the core page allocator function but essentially
it is an alias of __alloc_pages_nodemask.  Naming a publicly available and
exported function "internal" is also a big ugly.  This patch renames
__alloc_pages_internal() to __alloc_pages_nodemask() and deletes the old
nodemask function.

Warning - This patch renames an exported symbol.  No kernel driver is
affected by external drivers calling __alloc_pages_internal() should
change the call to __alloc_pages_nodemask() without any alteration of
parameters.

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

 include/linux/gfp.h |   12 ++----------
 mm/page_alloc.c     |    4 ++--
 2 files changed, 4 insertions(+), 12 deletions(-)

diff -puN include/linux/gfp.h~page-allocator-replace-__alloc_pages_internal-with-__alloc_pages_nodemask include/linux/gfp.h
--- a/include/linux/gfp.h~page-allocator-replace-__alloc_pages_internal-with-__alloc_pages_nodemask
+++ a/include/linux/gfp.h
@@ -172,24 +172,16 @@ static inline void arch_alloc_page(struc
 #endif
 
 struct page *
-__alloc_pages_internal(gfp_t gfp_mask, unsigned int order,
+__alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
 		       struct zonelist *zonelist, nodemask_t *nodemask);
 
 static inline struct page *
 __alloc_pages(gfp_t gfp_mask, unsigned int order,
 		struct zonelist *zonelist)
 {
-	return __alloc_pages_internal(gfp_mask, order, zonelist, NULL);
+	return __alloc_pages_nodemask(gfp_mask, order, zonelist, NULL);
 }
 
-static inline struct page *
-__alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
-		struct zonelist *zonelist, nodemask_t *nodemask)
-{
-	return __alloc_pages_internal(gfp_mask, order, zonelist, nodemask);
-}
-
-
 static inline struct page *alloc_pages_node(int nid, gfp_t gfp_mask,
 						unsigned int order)
 {
diff -puN mm/page_alloc.c~page-allocator-replace-__alloc_pages_internal-with-__alloc_pages_nodemask mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-replace-__alloc_pages_internal-with-__alloc_pages_nodemask
+++ a/mm/page_alloc.c
@@ -1458,7 +1458,7 @@ try_next_zone:
  * This is the 'heart' of the zoned buddy allocator.
  */
 struct page *
-__alloc_pages_internal(gfp_t gfp_mask, unsigned int order,
+__alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
 			struct zonelist *zonelist, nodemask_t *nodemask)
 {
 	const gfp_t wait = gfp_mask & __GFP_WAIT;
@@ -1667,7 +1667,7 @@ nopage:
 got_pg:
 	return page;
 }
-EXPORT_SYMBOL(__alloc_pages_internal);
+EXPORT_SYMBOL(__alloc_pages_nodemask);
 
 /*
  * Common helper functions.
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
linux-next.patch
page_alloc-oops-when-setting-percpu_pagelist_fraction.patch
memcg-fix-lru-rotation-in-isolate_pages.patch
add-debugging-aid-for-memory-initialisation-problems.patch

