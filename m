From: akpm@linux-foundation.org
Subject: + page-allocator-replace-__alloc_pages_internal-with-__alloc_pages_nodemask.patch added to -mm tree
Date: Thu, 23 Apr 2009 16:07:18 -0700
Message-ID: <200904232307.n3NN7I38009200@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753200AbZDWXMo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Apr 2009 19:12:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, a.p.zijlstra@chello.nl, cl@linux-foundation.org, dave@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, nickpiggin@yahoo.com.au, penberg@cs.helsinki.fi


The patch titled
     page allocator: replace __alloc_pages_internal() with __alloc_pages_nodemask()
has been added to the -mm tree.  Its filename is
     page-allocator-replace-__alloc_pages_internal-with-__alloc_pages_nodemask.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |   12 ++----------
 mm/page_alloc.c     |    4 ++--
 2 files changed, 4 insertions(+), 12 deletions(-)

diff -puN include/linux/gfp.h~page-allocator-replace-__alloc_pages_internal-with-__alloc_pages_nodemask include/linux/gfp.h
--- a/include/linux/gfp.h~page-allocator-replace-__alloc_pages_internal-with-__alloc_pages_nodemask
+++ a/include/linux/gfp.h
@@ -169,24 +169,16 @@ static inline void arch_alloc_page(struc
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
@@ -1462,7 +1462,7 @@ try_next_zone:
  * This is the 'heart' of the zoned buddy allocator.
  */
 struct page *
-__alloc_pages_internal(gfp_t gfp_mask, unsigned int order,
+__alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
 			struct zonelist *zonelist, nodemask_t *nodemask)
 {
 	const gfp_t wait = gfp_mask & __GFP_WAIT;
@@ -1671,7 +1671,7 @@ nopage:
 got_pg:
 	return page;
 }
-EXPORT_SYMBOL(__alloc_pages_internal);
+EXPORT_SYMBOL(__alloc_pages_nodemask);
 
 /*
  * Common helper functions.
_

Patches currently in -mm which might be from mel@csn.ul.ie are

vmscan-low-order-lumpy-reclaim-also-should-use-pageout_io_sync.patch
page-allocator-replace-__alloc_pages_internal-with-__alloc_pages_nodemask.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid.patch
page-allocator-check-only-once-if-the-zonelist-is-suitable-for-the-allocation.patch
page-allocator-break-up-the-allocator-entry-point-into-fast-and-slow-paths.patch
page-allocator-move-check-for-disabled-anti-fragmentation-out-of-fastpath.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-calculate-the-migratetype-for-allocation-only-once.patch
page-allocator-calculate-the-alloc_flags-for-allocation-only-once.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
page-allocator-inline-__rmqueue_smallest.patch
page-allocator-inline-buffered_rmqueue.patch
page-allocator-inline-__rmqueue_fallback.patch
page-allocator-do-not-call-get_pageblock_migratetype-more-than-necessary.patch
page-allocator-do-not-disable-interrupts-in-free_page_mlock.patch
page-allocator-do-not-setup-zonelist-cache-when-there-is-only-one-node.patch
page-allocator-do-not-check-for-compound-pages-during-the-page-allocator-sanity-checks.patch
page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark.patch
page-allocator-update-nr_free_pages-only-as-necessary.patch
page-allocator-get-the-pageblock-migratetype-without-disabling-interrupts.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths.patch
page-allocator-slab-use-nr_online_nodes-to-check-for-a-numa-platform.patch
add-debugging-aid-for-memory-initialisation-problems.patch

