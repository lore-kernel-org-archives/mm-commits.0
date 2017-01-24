From: akpm@linux-foundation.org
Subject: + mm-page_alloc-remove-redundant-checks-from-alloc-fastpath.patch added to -mm tree
Date: Tue, 24 Jan 2017 13:45:53 -0800
Message-ID: <5887cb11.VGVIBwoAbOSNysX0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35474 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750751AbdAXVpy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2017 16:45:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, khandual@linux.vnet.ibm.com, mgorman@techsingularity.net, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: remove redundant checks from alloc fastpath
has been added to the -mm tree.  Its filename is
     mm-page_alloc-remove-redundant-checks-from-alloc-fastpath.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-remove-redundant-checks-from-alloc-fastpath.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-remove-redundant-checks-from-alloc-fastpath.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -3912,14 +3912,6 @@ static inline bool prepare_alloc_pages(g
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
 
@@ -3959,22 +3951,12 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
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

mm-mempolicyc-do-not-put-mempolicy-before-using-its-nodemask.patch
mm-page_alloc-fix-check-for-null-preferred_zone.patch
mm-page_alloc-fix-fast-path-race-with-cpuset-update-or-removal.patch
mm-page_alloc-move-cpuset-seqcount-checking-to-slowpath.patch
mm-page_alloc-fix-premature-oom-when-racing-with-cpuset-mems-update.patch
mm-page_alloc-dont-convert-pfn-to-idx-when-merging.patch
mm-page_alloc-avoid-page_to_pfn-when-merging-buddies.patch
mm-page_alloc-remove-redundant-checks-from-alloc-fastpath.patch
mm-page_alloc-dont-check-cpuset-allowed-twice-in-fast-path.patch

