From: akpm@linux-foundation.org
Subject: [patch 20/26] mm, page_alloc: fix premature OOM when racing with
 cpuset mems update
Date: Tue, 24 Jan 2017 15:18:41 -0800
Message-ID: <5887e0d1.k0DVSlsxvSUcVBvv%akpm__17276.8363533125$1485299942$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41550 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751110AbdAXXSm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2017 18:18:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vbabka@suse.cz, gpkulkarni@gmail.com, hillf.zj@alibaba-inc.com, mgorman@techsingularity.net, mhocko@suse.com, stable@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_alloc: fix premature OOM when racing with cpuset mems update

Ganapatrao Kulkarni reported that the LTP test cpuset01 in stress mode
triggers OOM killer in few seconds, despite lots of free memory.  The test
attempts to repeatedly fault in memory in one process in a cpuset, while
changing allowed nodes of the cpuset between 0 and 1 in another process.

The problem comes from insufficient protection against cpuset changes,
which can cause get_page_from_freelist() to consider all zones as
non-eligible due to nodemask and/or current->mems_allowed.  This was
masked in the past by sufficient retries, but since commit 682a3385e773
("mm, page_alloc: inline the fast path of the zonelist iterator") we fix
the preferred_zoneref once, and don't iterate over the whole zonelist in
further attempts, thus the only eligible zones might be placed in the
zonelist before our starting point and we always miss them.

A previous patch fixed this problem for current->mems_allowed.  However,
cpuset changes also update the task's mempolicy nodemask.  The fix has two
parts.  We have to repeat the preferred_zoneref search when we detect
cpuset update by way of seqcount, and we have to check the seqcount before
considering OOM.

[akpm@linux-foundation.org: fix typo in comment]
Link: http://lkml.kernel.org/r/20170120103843.24587-5-vbabka@suse.cz
Fixes: c33d6c06f60f ("mm, page_alloc: avoid looking up the first zone in a zonelist twice")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Ganapatrao Kulkarni <gpkulkarni@gmail.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-fix-premature-oom-when-racing-with-cpuset-mems-update mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-fix-premature-oom-when-racing-with-cpuset-mems-update
+++ a/mm/page_alloc.c
@@ -3555,6 +3555,17 @@ retry_cpuset:
 	no_progress_loops = 0;
 	compact_priority = DEF_COMPACT_PRIORITY;
 	cpuset_mems_cookie = read_mems_allowed_begin();
+	/*
+	 * We need to recalculate the starting point for the zonelist iterator
+	 * because we might have used different nodemask in the fast path, or
+	 * there was a cpuset modification and we are retrying - otherwise we
+	 * could end up iterating over non-eligible zones endlessly.
+	 */
+	ac->preferred_zoneref = first_zones_zonelist(ac->zonelist,
+					ac->high_zoneidx, ac->nodemask);
+	if (!ac->preferred_zoneref->zone)
+		goto nopage;
+
 
 	/*
 	 * The fast path uses conservative alloc_flags to succeed only until
@@ -3715,6 +3726,13 @@ retry:
 				&compaction_retries))
 		goto retry;
 
+	/*
+	 * It's possible we raced with cpuset update so the OOM would be
+	 * premature (see below the nopage: label for full explanation).
+	 */
+	if (read_mems_allowed_retry(cpuset_mems_cookie))
+		goto retry_cpuset;
+
 	/* Reclaim has failed us, start killing things */
 	page = __alloc_pages_may_oom(gfp_mask, order, ac, &did_some_progress);
 	if (page)
@@ -3728,10 +3746,11 @@ retry:
 
 nopage:
 	/*
-	 * When updating a task's mems_allowed, it is possible to race with
-	 * parallel threads in such a way that an allocation can fail while
-	 * the mask is being updated. If a page allocation is about to fail,
-	 * check if the cpuset changed during allocation and if so, retry.
+	 * When updating a task's mems_allowed or mempolicy nodemask, it is
+	 * possible to race with parallel threads in such a way that our
+	 * allocation can fail while the mask is being updated. If we are about
+	 * to fail, check if the cpuset changed during allocation and if so,
+	 * retry.
 	 */
 	if (read_mems_allowed_retry(cpuset_mems_cookie))
 		goto retry_cpuset;
@@ -3822,15 +3841,9 @@ no_zone:
 	/*
 	 * Restore the original nodemask if it was potentially replaced with
 	 * &cpuset_current_mems_allowed to optimize the fast-path attempt.
-	 * Also recalculate the starting point for the zonelist iterator or
-	 * we could end up iterating over non-eligible zones endlessly.
 	 */
-	if (unlikely(ac.nodemask != nodemask)) {
+	if (unlikely(ac.nodemask != nodemask))
 		ac.nodemask = nodemask;
-		ac.preferred_zoneref = first_zones_zonelist(ac.zonelist,
-						ac.high_zoneidx, ac.nodemask);
-		/* If we have NULL preferred zone, slowpath wll handle that */
-	}
 
 	page = __alloc_pages_slowpath(alloc_mask, order, &ac);
 
_
