From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-fix-fast-path-race-with-cpuset-update-or-removal.patch added
 to -mm tree
Date: Fri, 20 Jan 2017 15:17:13 -0800
Message-ID: <58829a79.e7LdIE2V0lgHbP3W%akpm__40642.5724541352$1484954242$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40020 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752058AbdATXRO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2017 18:17:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, gpkulkarni@gmail.com, mgorman@techsingularity.net, mhocko@suse.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: fix fast-path race with cpuset update or removal
has been added to the -mm tree.  Its filename is
     mm-page_alloc-fix-fast-path-race-with-cpuset-update-or-removal.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-fix-fast-path-race-with-cpuset-update-or-removal.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-fix-fast-path-race-with-cpuset-update-or-removal.patch

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

Patches currently in -mm which might be from vbabka@suse.cz are

mm-mempolicyc-do-not-put-mempolicy-before-using-its-nodemask.patch
mm-page_alloc-fix-check-for-null-preferred_zone.patch
mm-page_alloc-fix-fast-path-race-with-cpuset-update-or-removal.patch
mm-page_alloc-move-cpuset-seqcount-checking-to-slowpath.patch
mm-page_alloc-fix-premature-oom-when-racing-with-cpuset-mems-update.patch
mm-page_alloc-dont-convert-pfn-to-idx-when-merging.patch
mm-page_alloc-avoid-page_to_pfn-when-merging-buddies.patch

