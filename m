From: akpm@linux-foundation.org
Subject: + page-allocator-sanity-check-order-in-the-page-allocator-slow-path.patch added to -mm tree
Date: Fri, 24 Apr 2009 10:44:02 -0700
Message-ID: <200904241744.n3OHi2Kt027743@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48068 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753062AbZDXRqQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Apr 2009 13:46:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, dave@linux.vnet.ibm.com


The patch titled
     page allocator: sanity check order in the page allocator slow path
has been added to the -mm tree.  Its filename is
     page-allocator-sanity-check-order-in-the-page-allocator-slow-path.patch

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
Subject: page allocator: sanity check order in the page allocator slow path
From: Mel Gorman <mel@csn.ul.ie>

Callers may speculatively call different allocators in order of preference
trying to allocate a buffer of a given size.  The order needed to allocate
this may be larger than what the page allocator can normally handle. 
While the allocator mostly does the right thing, it should not direct
reclaim or wakeup kswapd with a bogus order.  This patch sanity checks the
order in the slow path and returns NULL if it is too large.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~page-allocator-sanity-check-order-in-the-page-allocator-slow-path mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-sanity-check-order-in-the-page-allocator-slow-path
+++ a/mm/page_alloc.c
@@ -1449,9 +1449,6 @@ get_page_from_freelist(gfp_t gfp_mask, n
 	int zlc_active = 0;		/* set if using zonelist_cache */
 	int did_zlc_setup = 0;		/* just call zlc_setup() one time */
 
-	if (WARN_ON_ONCE(order >= MAX_ORDER))
-		return NULL;
-
 zonelist_scan:
 	/*
 	 * Scan zonelist, looking for a zone with enough free.
@@ -1708,6 +1705,15 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	struct task_struct *p = current;
 
 	/*
+	 * In the slowpath, we sanity check order to avoid ever trying to
+	 * reclaim >= MAX_ORDER areas which will never succeed. Callers may
+	 * be using allocators in order of preference for an area that is
+	 * too large.
+	 */
+	if (WARN_ON_ONCE(order >= MAX_ORDER))
+		return NULL;
+
+	/*
 	 * GFP_THISNODE (meaning __GFP_THISNODE, __GFP_NORETRY and
 	 * __GFP_NOWARN set) should not cause reclaim since the subsystem
 	 * (f.e. slab) using GFP_THISNODE may choose to trigger reclaim
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
page-allocator-move-free_page_mlock-to-page_allocc.patch
page-allocator-sanity-check-order-in-the-page-allocator-slow-path.patch
add-debugging-aid-for-memory-initialisation-problems.patch

