From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath-fix.patch added to -mm tree
Date: Wed, 17 Dec 2014 13:15:19 -0800
Message-ID: <5491f267.VYnADS65k88hB5zz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42308 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbaLQVPV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Dec 2014 16:15:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: embed OOM killing naturally into allocation slowpath fix
has been added to the -mm tree.  Its filename is
     mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: embed OOM killing naturally into allocation slowpath fix

When retrying the allocation after potentially invoking OOM, make sure
the alloc flags are recalculated, as they have to consider TIF_MEMDIE.

Restore the original restart label, but rename it to 'retry' to match
the should_alloc_retry() it depends on.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath-fix
+++ a/mm/page_alloc.c
@@ -2673,6 +2673,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	    (gfp_mask & GFP_THISNODE) == GFP_THISNODE)
 		goto nopage;
 
+retry:
 	if (!(gfp_mask & __GFP_NO_KSWAPD))
 		wake_all_kswapds(order, zonelist, high_zoneidx,
 				preferred_zone, nodemask);
@@ -2695,7 +2696,6 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 		classzone_idx = zonelist_zone_idx(preferred_zoneref);
 	}
 
-rebalance:
 	/* This is the last chance, in general, before the goto nopage. */
 	page = get_page_from_freelist(gfp_mask, nodemask, order, zonelist,
 			high_zoneidx, alloc_flags & ~ALLOC_NO_WATERMARKS,
@@ -2823,7 +2823,7 @@ rebalance:
 		}
 		/* Wait for some write requests to complete then retry */
 		wait_iff_congested(preferred_zone, BLK_RW_ASYNC, HZ/50);
-		goto rebalance;
+		goto retry;
 	} else {
 		/*
 		 * High-order allocations do not necessarily loop after
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath-update.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask-fix.patch

