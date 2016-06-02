From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-recalculate-the-preferred-zoneref-if-the-context-can-ignore-memory-policies.patch added to -mm tree
Date: Thu, 02 Jun 2016 11:43:45 -0700
Message-ID: <57507e61.zqsxC1PuQjY2gMwi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49681 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933169AbcFBSnq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jun 2016 14:43:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, geert@linux-m68k.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: recalculate the preferred zoneref if the context can ignore memory policies
has been added to the -mm tree.  Its filename is
     mm-page_alloc-recalculate-the-preferred-zoneref-if-the-context-can-ignore-memory-policies.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-recalculate-the-preferred-zoneref-if-the-context-can-ignore-memory-policies.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-recalculate-the-preferred-zoneref-if-the-context-can-ignore-memory-policies.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: recalculate the preferred zoneref if the context can ignore memory policies

The optimistic fast path may use cpuset_current_mems_allowed instead of of
a NULL nodemask supplied by the caller for cpuset allocations.  The
preferred zone is calculated on this basis for statistic purposes and as a
starting point in the zonelist iterator.

However, if the context can ignore memory policies due to being atomic or
being able to ignore watermarks then the starting point in the zonelist
iterator is no longer correct.  This patch resets the zonelist iterator in
the allocator slowpath if the context can ignore memory policies.  This
will alter the zone used for statistics but only after it is known that it
makes sense for that context.  Resetting it before entering the slowpath
would potentially allow an ALLOC_CPUSET allocation to be accounted for
against the wrong zone.  Note that while nodemask is not explicitly set to
the original nodemask, it would only have been overwritten if
cpuset_enabled() and it was reset before the slowpath was entered.

Link: http://lkml.kernel.org/r/20160602103936.GU2527@techsingularity.net
Fixes: c33d6c06f60f710 ("mm, page_alloc: avoid looking up the first zone in a zonelist twice")
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-recalculate-the-preferred-zoneref-if-the-context-can-ignore-memory-policies mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-recalculate-the-preferred-zoneref-if-the-context-can-ignore-memory-policies
+++ a/mm/page_alloc.c
@@ -3604,6 +3604,17 @@ retry:
 	 */
 	alloc_flags = gfp_to_alloc_flags(gfp_mask);
 
+	/*
+	 * Reset the zonelist iterators if memory policies can be ignored.
+	 * These allocations are high priority and system rather than user
+	 * orientated.
+	 */
+	if ((alloc_flags & ALLOC_NO_WATERMARKS) || !(alloc_flags & ALLOC_CPUSET)) {
+		ac->zonelist = node_zonelist(numa_node_id(), gfp_mask);
+		ac->preferred_zoneref = first_zones_zonelist(ac->zonelist,
+					ac->high_zoneidx, ac->nodemask);
+	}
+
 	/* This is the last chance, in general, before the goto nopage. */
 	page = get_page_from_freelist(gfp_mask, order,
 				alloc_flags & ~ALLOC_NO_WATERMARKS, ac);
@@ -3612,12 +3623,6 @@ retry:
 
 	/* Allocate without watermarks if the context allows */
 	if (alloc_flags & ALLOC_NO_WATERMARKS) {
-		/*
-		 * Ignore mempolicies if ALLOC_NO_WATERMARKS on the grounds
-		 * the allocation is high priority and these type of
-		 * allocations are system rather than user orientated
-		 */
-		ac->zonelist = node_zonelist(numa_node_id(), gfp_mask);
 		page = get_page_from_freelist(gfp_mask, order,
 						ALLOC_NO_WATERMARKS, ac);
 		if (page)
@@ -3816,7 +3821,11 @@ retry_cpuset:
 	/* Dirty zone balancing only done in the fast path */
 	ac.spread_dirty_pages = (gfp_mask & __GFP_WRITE);
 
-	/* The preferred zone is used for statistics later */
+	/*
+	 * The preferred zone is used for statistics but crucially it is
+	 * also used as the starting point for the zonelist iterator. It
+	 * may get reset for allocations that ignore memory policies.
+	 */
 	ac.preferred_zoneref = first_zones_zonelist(ac.zonelist,
 					ac.high_zoneidx, ac.nodemask);
 	if (!ac.preferred_zoneref) {
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-reset-zonelist-iterator-after-resetting-fair-zone-allocation-policy.patch
mm-page_alloc-recalculate-the-preferred-zoneref-if-the-context-can-ignore-memory-policies.patch

