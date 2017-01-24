From: akpm@linux-foundation.org
Subject: [patch 18/26] mm, page_alloc: fix fast-path race with cpuset
 update or removal
Date: Tue, 24 Jan 2017 15:18:35 -0800
Message-ID: <5887e0cb.TqW71yvvvIX9lCnh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41510 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750782AbdAXXSg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2017 18:18:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vbabka@suse.cz, gpkulkarni@gmail.com, hillf.zj@alibaba-inc.com, mgorman@techsingularity.net, mhocko@suse.com, stable@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_alloc: fix fast-path race with cpuset update or removal

Ganapatrao Kulkarni reported that the LTP test cpuset01 in stress mode
triggers OOM killer in few seconds, despite lots of free memory.  The test
attempts to repeatedly fault in memory in one process in a cpuset, while
changing allowed nodes of the cpuset between 0 and 1 in another process.

One possible cause is that in the fast path we find the preferred zoneref
according to current mems_allowed, so that it points to the middle of the
zonelist, skipping e.g.  zones of node 1 completely.  If the mems_allowed
is updated to contain only node 1, we never reach it in the zonelist, and
trigger OOM before checking the cpuset_mems_cookie.

This patch fixes the particular case by redoing the preferred zoneref
search if we switch back to the original nodemask.  The condition is also
slightly changed so that when the last non-root cpuset is removed, we
don't miss it.

Note that this is not a full fix, and more patches will follow.

Link: http://lkml.kernel.org/r/20170120103843.24587-3-vbabka@suse.cz
Fixes: 682a3385e773 ("mm, page_alloc: inline the fast path of the zonelist iterator")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Ganapatrao Kulkarni <gpkulkarni@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-fix-fast-path-race-with-cpuset-update-or-removal mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-fix-fast-path-race-with-cpuset-update-or-removal
+++ a/mm/page_alloc.c
@@ -3804,9 +3804,17 @@ retry_cpuset:
 	/*
 	 * Restore the original nodemask if it was potentially replaced with
 	 * &cpuset_current_mems_allowed to optimize the fast-path attempt.
+	 * Also recalculate the starting point for the zonelist iterator or
+	 * we could end up iterating over non-eligible zones endlessly.
 	 */
-	if (cpusets_enabled())
+	if (unlikely(ac.nodemask != nodemask)) {
 		ac.nodemask = nodemask;
+		ac.preferred_zoneref = first_zones_zonelist(ac.zonelist,
+						ac.high_zoneidx, ac.nodemask);
+		if (!ac.preferred_zoneref->zone)
+			goto no_zone;
+	}
+
 	page = __alloc_pages_slowpath(alloc_mask, order, &ac);
 
 no_zone:
_
