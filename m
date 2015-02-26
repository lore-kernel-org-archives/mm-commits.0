From: akpm@linux-foundation.org
Subject: +
 mm-oom-do-not-fail-__gfp_nofail-allocation-if-oom-killer-is-disbaled.patch
 added to -mm tree
Date: Thu, 26 Feb 2015 15:54:18 -0800
Message-ID: <54efb22a.wJUwrWt4BUREnTu8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60689 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbbBZXyT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Feb 2015 18:54:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, hannes@cmpxchg.org, penguin-kernel@i-love.sakura.ne.jp, rientjes@gooogle.com, rjw@rjwysocki.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: do not fail __GFP_NOFAIL allocation if oom killer is disabled
has been added to the -mm tree.  Its filename is
     mm-oom-do-not-fail-__gfp_nofail-allocation-if-oom-killer-is-disbaled.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-do-not-fail-__gfp_nofail-allocation-if-oom-killer-is-disbaled.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-do-not-fail-__gfp_nofail-allocation-if-oom-killer-is-disbaled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

memcg-fix-low-limit-calculation.patch
mm-memcontrol-use-max-instead-of-infinity-in-control-knobs.patch
mm-page_alloc-revert-inadvertent-__gfp_fs-retry-behavior-change.patch
mm-oom-do-not-fail-__gfp_nofail-allocation-if-oom-killer-is-disbaled.patch
mm-memcontrol-update-copyright-notice.patch
mm-cma-release-trigger-fixpatch.patch
mm-hide-per-cpu-lists-in-output-of-show_mem.patch
mm-refactor-do_wp_page-extract-the-reuse-case.patch
mm-refactor-do_wp_page-rewrite-the-unlock-flow.patch
mm-refactor-do_wp_page-extract-the-page-copy-flow.patch
mm-refactor-do_wp_page-handling-of-shared-vma-into-a-function.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
fork-report-pid-reservation-failure-properly.patch

