From: akpm@linux-foundation.org
Subject: [merged]
 mm-oom-do-not-fail-__gfp_nofail-allocation-if-oom-killer-is-disbaled.patch
 removed from -mm tree
Date: Mon, 16 Mar 2015 11:02:36 -0700
Message-ID: <55071abc.otpYYGvrljXs8Hi0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33524 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932944AbbCPSCh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Mar 2015 14:02:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, hannes@cmpxchg.org, penguin-kernel@i-love.sakura.ne.jp, rientjes@google.com, rjw@rjwysocki.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: do not fail __GFP_NOFAIL allocation if oom killer is disabled
has been removed from the -mm tree.  Its filename was
     mm-oom-do-not-fail-__gfp_nofail-allocation-if-oom-killer-is-disbaled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: mm, oom: do not fail __GFP_NOFAIL allocation if oom killer is disabled

Tetsuo Handa has pointed out that __GFP_NOFAIL allocations might fail
after OOM killer is disabled if the allocation is performed by a kernel
thread.  This behavior was introduced from the very beginning by
7f33d49a2ed5 ("mm, PM/Freezer: Disable OOM killer when tasks are frozen").
 This means that the basic contract for the allocation request is broken
and the context requesting such an allocation might blow up unexpectedly.

There are basically two ways forward.

1) move oom_killer_disable after kernel threads are frozen.  This has a
   risk that the OOM victim wouldn't be able to finish because it would
   depend on an already frozen kernel thread.  This would be really tricky
   to debug.

2) do not fail GFP_NOFAIL allocation no matter what and risk a
   potential Freezable kernel threads will loop and fail the suspend. 
   Incidental allocations after kernel threads are frozen will at least
   dump a warning - if we are lucky and the serial console is still active
   of course...

This patch implements the later option because it is safer.  We would see
warning rather than allocation failures for the kernel threads which would
blow up otherwise and have a higher chances to identify __GFP_NOFAIL users
from deeper pm code.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: David Rientjes <rientjes@gooogle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-oom-do-not-fail-__gfp_nofail-allocation-if-oom-killer-is-disbaled mm/page_alloc.c
--- a/mm/page_alloc.c~mm-oom-do-not-fail-__gfp_nofail-allocation-if-oom-killer-is-disbaled
+++ a/mm/page_alloc.c
@@ -2373,7 +2373,8 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 			goto out;
 	}
 	/* Exhausted what can be done so it's blamo time */
-	if (out_of_memory(ac->zonelist, gfp_mask, order, ac->nodemask, false))
+	if (out_of_memory(ac->zonelist, gfp_mask, order, ac->nodemask, false)
+			|| WARN_ON_ONCE(gfp_mask & __GFP_NOFAIL))
 		*did_some_progress = 1;
 out:
 	oom_zonelist_unlock(ac->zonelist, gfp_mask);
_

Patches currently in -mm which might be from mhocko@suse.cz are

mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention.patch
mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention-v2.patch
cxgb4-drop-__gfp_nofail-allocation.patch
cxgb4-drop-__gfp_nofail-allocation-fix.patch
jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
mm-memcontrol-update-copyright-notice.patch
mm-cma-release-trigger-fixpatch.patch
mm-hide-per-cpu-lists-in-output-of-show_mem.patch
mm-completely-remove-dumping-per-cpu-lists-from-show_mem.patch
mm-refactor-do_wp_page-extract-the-reuse-case.patch
mm-refactor-do_wp_page-rewrite-the-unlock-flow.patch
mm-refactor-do_wp_page-extract-the-page-copy-flow.patch
mm-refactor-do_wp_page-handling-of-shared-vma-into-a-function.patch
mm-clarify-__gfp_nofail-deprecation-status.patch
mm-clarify-__gfp_nofail-deprecation-status-checkpatch-fixes.patch
sparc-clarify-__gfp_nofail-allocation.patch
mm-memcontrol-let-mem_cgroup_move_account-have-effect-only-if-mmu-enabled.patch
memcg-print-cgroup-information-when-system-panics-due-to-panic_on_oom.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
fork-report-pid-reservation-failure-properly.patch

