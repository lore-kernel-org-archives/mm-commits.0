From: akpm@linux-foundation.org
Subject: [patch 084/117] mm, oom: move GFP_NOFS check to out_of_memory
Date: Thu, 19 May 2016 17:13:09 -0700
Message-ID: <573e5695.JP50AYgacUPOL39o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46487 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932921AbcETANL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:13:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, daniel.vetter@intel.com, mst@redhat.com, oleg@redhat.com, paulmck@linux.vnet.ibm.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, rmaksudova@parallels.com

From: Michal Hocko <mhocko@suse.com>
Subject: mm, oom: move GFP_NOFS check to out_of_memory

__alloc_pages_may_oom is the central place to decide when the
out_of_memory should be invoked.  This is a good approach for most checks
there because they are page allocator specific and the allocation fails
right after for all of them.

The notable exception is GFP_NOFS context which is faking
did_some_progress and keep the page allocator looping even though there
couldn't have been any progress from the OOM killer.  This patch doesn't
change this behavior because we are not ready to allow those allocation
requests to fail yet (and maybe we will face the reality that we will
never manage to safely fail these request).  Instead __GFP_FS check is
moved down to out_of_memory and prevent from OOM victim selection there. 
There are two reasons for that

	- OOM notifiers might release some memory even from this context
	  as none of the registered notifier seems to be FS related
	- this might help a dying thread to get an access to memory
          reserves and move on which will make the behavior more
          consistent with the case when the task gets killed from a
          different context.

Keep a comment in __alloc_pages_may_oom to make sure we do not forget how
GFP_NOFS is special and that we really want to do something about it.

Note to the current oom_notifier users:

The observable difference for you is that oom notifiers cannot depend on
any fs locks because we could deadlock.  Not that this would be allowed
today because that would just lockup machine in most of the cases and
ruling out the OOM killer along the way.  Another difference is that
callbacks might be invoked sooner now because GFP_NOFS is a weaker reclaim
context and so there could be reclaimable memory which is just not
reachable now.  That would require GFP_NOFS only loads which are really
rare and more importantly the observable result would be dropping of
reconstructible object and potential performance drop which is not such a
big deal when we are struggling to fulfill other important allocation
requests.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Raushaniya Maksudova <rmaksudova@parallels.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Daniel Vetter <daniel.vetter@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c   |    9 +++++++++
 mm/page_alloc.c |   24 ++++++++++--------------
 2 files changed, 19 insertions(+), 14 deletions(-)

diff -puN mm/oom_kill.c~mm-oom-move-gfp_nofs-check-to-out_of_memory mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-move-gfp_nofs-check-to-out_of_memory
+++ a/mm/oom_kill.c
@@ -877,6 +877,15 @@ bool out_of_memory(struct oom_control *o
 	}
 
 	/*
+	 * The OOM killer does not compensate for IO-less reclaim.
+	 * pagefault_out_of_memory lost its gfp context so we have to
+	 * make sure exclude 0 mask - all other users should have at least
+	 * ___GFP_DIRECT_RECLAIM to get here.
+	 */
+	if (oc->gfp_mask && !(oc->gfp_mask & (__GFP_FS|__GFP_NOFAIL)))
+		return true;
+
+	/*
 	 * Check if there were limitations on the allocation (only relevant for
 	 * NUMA) that may require different handling.
 	 */
diff -puN mm/page_alloc.c~mm-oom-move-gfp_nofs-check-to-out_of_memory mm/page_alloc.c
--- a/mm/page_alloc.c~mm-oom-move-gfp_nofs-check-to-out_of_memory
+++ a/mm/page_alloc.c
@@ -2875,22 +2875,18 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 		/* The OOM killer does not needlessly kill tasks for lowmem */
 		if (ac->high_zoneidx < ZONE_NORMAL)
 			goto out;
-		/* The OOM killer does not compensate for IO-less reclaim */
-		if (!(gfp_mask & __GFP_FS)) {
-			/*
-			 * XXX: Page reclaim didn't yield anything,
-			 * and the OOM killer can't be invoked, but
-			 * keep looping as per tradition.
-			 *
-			 * But do not keep looping if oom_killer_disable()
-			 * was already called, for the system is trying to
-			 * enter a quiescent state during suspend.
-			 */
-			*did_some_progress = !oom_killer_disabled;
-			goto out;
-		}
 		if (pm_suspended_storage())
 			goto out;
+		/*
+		 * XXX: GFP_NOFS allocations should rather fail than rely on
+		 * other request to make a forward progress.
+		 * We are in an unfortunate situation where out_of_memory cannot
+		 * do much for this context but let's try it to at least get
+		 * access to memory reserved if the current task is killed (see
+		 * out_of_memory). Once filesystems are ready to handle allocation
+		 * failures more gracefully we should just bail out here.
+		 */
+
 		/* The OOM killer may not free memory on a specific node */
 		if (gfp_mask & __GFP_THISNODE)
 			goto out;
_
