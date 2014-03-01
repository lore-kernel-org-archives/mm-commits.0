From: akpm@linux-foundation.org
Subject: + mm-page_alloc-reset-aging-cycle-with-gfp_thisnode-v2.patch
 added to -mm tree
Date: Fri, 28 Feb 2014 16:06:14 -0800
Message-ID: <53112476.sJE1CRCVi9UlJhrS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52720 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbaCAAGP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Feb 2014 19:06:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@kernel.org, riel@redhat.com, mgorman@suse.de, hannes@cmpxchg.org, jstancek@redhat.com

Subject: + mm-page_alloc-reset-aging-cycle-with-gfp_thisnode-v2.patch added to -mm tree
To: jstancek@redhat.com,hannes@cmpxchg.org,mgorman@suse.de,riel@redhat.com,stable@kernel.org
From: akpm@linux-foundation.org
Date: Fri, 28 Feb 2014 16:06:14 -0800


The patch titled
     
has been added to the -mm tree.  Its filename is
     mm-page_alloc-reset-aging-cycle-with-gfp_thisnode-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-reset-aging-cycle-with-gfp_thisnode-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-reset-aging-cycle-with-gfp_thisnode-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------

Subject: mm: page_alloc: exempt GFP_THISNODE allocations from zone fairness

Jan Stancek reports manual page migration encountering allocation failures
after some pages when there is still plenty of memory free, and bisected
the problem down to 81c0a2bb515f ("mm: page_alloc: fair zone allocator
policy").

The problem is that GFP_THISNODE obeys the zone fairness allocation
batches on one hand, but doesn't reset them and wake kswapd on the other
hand.  After a few of those allocations, the batches are exhausted and the
allocations fail.

Fixing this means either having GFP_THISNODE wake up kswapd, or
GFP_THISNODE not participating in zone fairness at all.  The latter seems
safer as an acute bugfix, we can clean up later.

Reported-by: Jan Stancek <jstancek@redhat.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: <stable@kernel.org>		[3.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-reset-aging-cycle-with-gfp_thisnode-v2 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-reset-aging-cycle-with-gfp_thisnode-v2
+++ a/mm/page_alloc.c
@@ -1238,6 +1238,15 @@ void drain_zone_pages(struct zone *zone,
 	}
 	local_irq_restore(flags);
 }
+static bool gfp_thisnode_allocation(gfp_t gfp_mask)
+{
+	return (gfp_mask & GFP_THISNODE) == GFP_THISNODE;
+}
+#else
+static bool gfp_thisnode_allocation(gfp_t gfp_mask)
+{
+	return false;
+}
 #endif
 
 /*
@@ -1574,7 +1583,13 @@ again:
 					  get_pageblock_migratetype(page));
 	}
 
-	__mod_zone_page_state(zone, NR_ALLOC_BATCH, -(1 << order));
+	/*
+	 * NOTE: GFP_THISNODE allocations do not partake in the kswapd
+	 * aging protocol, so they can't be fair.
+	 */
+	if (!gfp_thisnode_allocation(gfp_flags))
+		__mod_zone_page_state(zone, NR_ALLOC_BATCH, -(1 << order));
+
 	__count_zone_vm_events(PGALLOC, zone, 1 << order);
 	zone_statistics(preferred_zone, zone, gfp_flags);
 	local_irq_restore(flags);
@@ -1946,8 +1961,12 @@ zonelist_scan:
 		 * ultimately fall back to remote zones that do not
 		 * partake in the fairness round-robin cycle of this
 		 * zonelist.
+		 *
+		 * NOTE: GFP_THISNODE allocations do not partake in
+		 * the kswapd aging protocol, so they can't be fair.
 		 */
-		if (alloc_flags & ALLOC_WMARK_LOW) {
+		if ((alloc_flags & ALLOC_WMARK_LOW) &&
+		    !gfp_thisnode_allocation(gfp_mask)) {
 			if (zone_page_state(zone, NR_ALLOC_BATCH) <= 0)
 				continue;
 			if (!zone_local(preferred_zone, zone))
@@ -2503,8 +2522,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	 * allowed per node queues are empty and that nodes are
 	 * over allocated.
 	 */
-	if (IS_ENABLED(CONFIG_NUMA) &&
-			(gfp_mask & GFP_THISNODE) == GFP_THISNODE)
+	if (gfp_thisnode_allocation(gfp_mask))
 		goto nopage;
 
 restart:
_

Patches currently in -mm which might be from jstancek@redhat.com are

mm-page_alloc-reset-aging-cycle-with-gfp_thisnode-v2.patch
mm-fix-gfp_thisnode-callers-and-clarify.patch

