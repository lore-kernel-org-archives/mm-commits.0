From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-remove-redundant-checks-from-alloc-fastpath.patch removed
 from -mm tree
Date: Mon, 27 Feb 2017 12:25:12 -0800
Message-ID: <58b48b28.rsdx2962mJHG9mWh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34550 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751637AbdB0Ukd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:40:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, khandual@linux.vnet.ibm.com, mgorman@techsingularity.net, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: remove redundant checks from alloc fastpath
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-redundant-checks-from-alloc-fastpath.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_alloc: remove redundant checks from alloc fastpath

The allocation fast path contains two similar checks for zoneref->zone
being NULL, where zoneref points either to the first zone in the zonelist,
or to the preferred zone.  These can be NULL either due to empty zonelist,
or no zone being compatible with given nodemask or task's cpuset.

These checks are unnecessary, because the zonelist walks in
first_zones_zonelist() and get_page_from_freelist() handle a NULL starting
zoneref->zone or preferred_zoneref->zone safely.  It's safe to fallback to
__alloc_pages_slowpath() where we also have the check early enough.

Link: http://lkml.kernel.org/r/20170124150511.5710-1-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   18 ------------------
 1 file changed, 18 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-remove-redundant-checks-from-alloc-fastpath mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-remove-redundant-checks-from-alloc-fastpath
+++ a/mm/page_alloc.c
@@ -3915,14 +3915,6 @@ static inline bool prepare_alloc_pages(g
 	if (should_fail_alloc_page(gfp_mask, order))
 		return false;
 
-	/*
-	 * Check the zones suitable for the gfp_mask contain at least one
-	 * valid zone. It's possible to have an empty zonelist as a result
-	 * of __GFP_THISNODE and a memoryless node
-	 */
-	if (unlikely(!ac->zonelist->_zonerefs->zone))
-		return false;
-
 	if (IS_ENABLED(CONFIG_CMA) && ac->migratetype == MIGRATE_MOVABLE)
 		*alloc_flags |= ALLOC_CMA;
 
@@ -3962,22 +3954,12 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 		return NULL;
 
 	finalise_ac(gfp_mask, order, &ac);
-	if (!ac.preferred_zoneref->zone) {
-		page = NULL;
-		/*
-		 * This might be due to race with cpuset_current_mems_allowed
-		 * update, so make sure we retry with original nodemask in the
-		 * slow path.
-		 */
-		goto no_zone;
-	}
 
 	/* First allocation attempt */
 	page = get_page_from_freelist(alloc_mask, order, alloc_flags, &ac);
 	if (likely(page))
 		goto out;
 
-no_zone:
 	/*
 	 * Runtime PM, block IO and its error handling path can deadlock
 	 * because I/O on the device might not complete.
_

Patches currently in -mm which might be from vbabka@suse.cz are


