From: akpm@linux-foundation.org
Subject: [merged]
 mm-oom-do-not-enfore-oom-killer-for-__gfp_nofail-automatically.patch
 removed from -mm tree
Date: Thu, 23 Feb 2017 13:17:16 -0800
Message-ID: <58af515c.EKSo5kmysXqi1WVH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41630 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751222AbdBWVRm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:17:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, nholland@tisys.org, penguin-kernel@I-love.SAKURA.ne.jp, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: do not enforce OOM killer for __GFP_NOFAIL automatically
has been removed from the -mm tree.  Its filename was
     mm-oom-do-not-enfore-oom-killer-for-__gfp_nofail-automatically.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, oom: do not enforce OOM killer for __GFP_NOFAIL automatically

__alloc_pages_may_oom makes sure to skip the OOM killer depending on the
allocation request.  This includes lowmem requests, costly high order
requests and others.  For a long time __GFP_NOFAIL acted as an override
for all those rules.  This is not documented and it can be quite
surprising as well.  E.g.  GFP_NOFS requests are not invoking the OOM
killer but GFP_NOFS|__GFP_NOFAIL does so if we try to convert some of the
existing open coded loops around allocator to nofail request (and we have
done that in the past) then such a change would have a non trivial side
effect which is far from obvious.  Note that the primary motivation for
skipping the OOM killer is to prevent from pre-mature invocation.

The exception has been added by 82553a937f12 ("oom: invoke oom killer
for __GFP_NOFAIL"). The changelog points out that the oom killer has to
be invoked otherwise the request would be looping for ever. But this
argument is rather weak because the OOM killer doesn't really guarantee
a forward progress for those exceptional cases:

- it will hardly help to form costly order which in turn can result in
  the system panic because of no oom killable task in the end - I believe
  we certainly do not want to put the system down just because there is a
  nasty driver asking for order-9 page with GFP_NOFAIL not realizing all
  the consequences.  It is much better this request would loop for ever
  than the massive system disruption

- lowmem is also highly unlikely to be freed during OOM killer

- GFP_NOFS request could trigger while there is still a lot of memory
  pinned by filesystems.

This patch simply removes the __GFP_NOFAIL special case in order to have a
more clear semantic without surprising side effects.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Nils Holland <nholland@tisys.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c   |    2 -
 mm/page_alloc.c |   49 ++++++++++++++++++++++------------------------
 2 files changed, 25 insertions(+), 26 deletions(-)

diff -puN mm/oom_kill.c~mm-oom-do-not-enfore-oom-killer-for-__gfp_nofail-automatically mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-do-not-enfore-oom-killer-for-__gfp_nofail-automatically
+++ a/mm/oom_kill.c
@@ -1013,7 +1013,7 @@ bool out_of_memory(struct oom_control *o
 	 * make sure exclude 0 mask - all other users should have at least
 	 * ___GFP_DIRECT_RECLAIM to get here.
 	 */
-	if (oc->gfp_mask && !(oc->gfp_mask & (__GFP_FS|__GFP_NOFAIL)))
+	if (oc->gfp_mask && !(oc->gfp_mask & __GFP_FS))
 		return true;
 
 	/*
diff -puN mm/page_alloc.c~mm-oom-do-not-enfore-oom-killer-for-__gfp_nofail-automatically mm/page_alloc.c
--- a/mm/page_alloc.c~mm-oom-do-not-enfore-oom-killer-for-__gfp_nofail-automatically
+++ a/mm/page_alloc.c
@@ -3090,32 +3090,31 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 	if (page)
 		goto out;
 
-	if (!(gfp_mask & __GFP_NOFAIL)) {
-		/* Coredumps can quickly deplete all memory reserves */
-		if (current->flags & PF_DUMPCORE)
-			goto out;
-		/* The OOM killer will not help higher order allocs */
-		if (order > PAGE_ALLOC_COSTLY_ORDER)
-			goto out;
-		/* The OOM killer does not needlessly kill tasks for lowmem */
-		if (ac->high_zoneidx < ZONE_NORMAL)
-			goto out;
-		if (pm_suspended_storage())
-			goto out;
-		/*
-		 * XXX: GFP_NOFS allocations should rather fail than rely on
-		 * other request to make a forward progress.
-		 * We are in an unfortunate situation where out_of_memory cannot
-		 * do much for this context but let's try it to at least get
-		 * access to memory reserved if the current task is killed (see
-		 * out_of_memory). Once filesystems are ready to handle allocation
-		 * failures more gracefully we should just bail out here.
-		 */
+	/* Coredumps can quickly deplete all memory reserves */
+	if (current->flags & PF_DUMPCORE)
+		goto out;
+	/* The OOM killer will not help higher order allocs */
+	if (order > PAGE_ALLOC_COSTLY_ORDER)
+		goto out;
+	/* The OOM killer does not needlessly kill tasks for lowmem */
+	if (ac->high_zoneidx < ZONE_NORMAL)
+		goto out;
+	if (pm_suspended_storage())
+		goto out;
+	/*
+	 * XXX: GFP_NOFS allocations should rather fail than rely on
+	 * other request to make a forward progress.
+	 * We are in an unfortunate situation where out_of_memory cannot
+	 * do much for this context but let's try it to at least get
+	 * access to memory reserved if the current task is killed (see
+	 * out_of_memory). Once filesystems are ready to handle allocation
+	 * failures more gracefully we should just bail out here.
+	 */
+
+	/* The OOM killer may not free memory on a specific node */
+	if (gfp_mask & __GFP_THISNODE)
+		goto out;
 
-		/* The OOM killer may not free memory on a specific node */
-		if (gfp_mask & __GFP_THISNODE)
-			goto out;
-	}
 	/* Exhausted what can be done so it's blamo time */
 	if (out_of_memory(&oc) || WARN_ON_ONCE(gfp_mask & __GFP_NOFAIL)) {
 		*did_some_progress = 1;
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-page_alloc-do-not-depend-on-cpu-hotplug-locks-inside-the-allocator.patch
userfaultfd-non-cooperative-add-event-for-memory-unmaps-fix.patch
vmalloc-back-of-when-the-current-is-killed.patch

