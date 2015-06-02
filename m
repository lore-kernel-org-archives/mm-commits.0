From: akpm@linux-foundation.org
Subject: + oom-always-panic-on-oom-when-panic_on_oom-is-configured.patch
 added to -mm tree
Date: Tue, 02 Jun 2015 13:05:41 -0700
Message-ID: <556e0c95.bvJMunbx9i1PQHVJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45168 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbbFBUFm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jun 2015 16:05:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, emunson@akamai.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom: always panic on OOM when panic_on_oom is configured
has been added to the -mm tree.  Its filename is
     oom-always-panic-on-oom-when-panic_on_oom-is-configured.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/oom-always-panic-on-oom-when-panic_on_oom-is-configured.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/oom-always-panic-on-oom-when-panic_on_oom-is-configured.patch

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
Subject: oom: always panic on OOM when panic_on_oom is configured

panic_on_oom allows administrator to set OOM policy to panic the system
when it is out of memory to reduce failover time e.g.  when resolving the
OOM condition would take much more time than rebooting the system.

out_of_memory tries to be clever and prevent from premature panics by
checking the current task and prevent from panic when the task has fatal
signal pending and so it should die shortly and release some memory.  This
is fair enough but Tetsuo Handa has noted that this might lead to a silent
deadlock when current cannot exit because of dependencies invisible to the
OOM killer.

panic_on_oom is disabled by default and if somebody enables it then any
risk of potential deadlock is certainly unwelcome.  The risk is really low
because there are usually more sources of allocation requests and one of
them would eventually trigger the panic but it is better to reduce the
risk as much as possible.

Let's move check_panic_on_oom up before the current task is checked so
that the knob value is .  Do the same for the memcg in
mem_cgroup_out_of_memory.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: David Rientjes <rientjes@google.com>
Reviewed-by: Eric B Munson <emunson@akamai.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ++-
 mm/oom_kill.c   |   18 +++++++++---------
 2 files changed, 11 insertions(+), 10 deletions(-)

diff -puN mm/memcontrol.c~oom-always-panic-on-oom-when-panic_on_oom-is-configured mm/memcontrol.c
--- a/mm/memcontrol.c~oom-always-panic-on-oom-when-panic_on_oom-is-configured
+++ a/mm/memcontrol.c
@@ -1532,6 +1532,8 @@ static void mem_cgroup_out_of_memory(str
 
 	mutex_lock(&oom_lock);
 
+	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, order, NULL, memcg);
+
 	/*
 	 * If current has a pending SIGKILL or is exiting, then automatically
 	 * select it.  The goal is to allow it to allocate so that it may
@@ -1542,7 +1544,6 @@ static void mem_cgroup_out_of_memory(str
 		goto unlock;
 	}
 
-	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, order, NULL, memcg);
 	totalpages = mem_cgroup_get_limit(memcg) ? : 1;
 	for_each_mem_cgroup_tree(iter, memcg) {
 		struct css_task_iter it;
diff -puN mm/oom_kill.c~oom-always-panic-on-oom-when-panic_on_oom-is-configured mm/oom_kill.c
--- a/mm/oom_kill.c~oom-always-panic-on-oom-when-panic_on_oom-is-configured
+++ a/mm/oom_kill.c
@@ -667,6 +667,15 @@ bool out_of_memory(struct zonelist *zone
 		goto out;
 
 	/*
+	 * Check if there were limitations on the allocation (only relevant for
+	 * NUMA) that may require different handling.
+	 */
+	constraint = constrained_alloc(zonelist, gfp_mask, nodemask,
+						&totalpages);
+	mpol_mask = (constraint == CONSTRAINT_MEMORY_POLICY) ? nodemask : NULL;
+	check_panic_on_oom(constraint, gfp_mask, order, mpol_mask, NULL);
+
+	/*
 	 * If current has a pending SIGKILL or is exiting, then automatically
 	 * select it.  The goal is to allow it to allocate so that it may
 	 * quickly exit and free its memory.
@@ -680,15 +689,6 @@ bool out_of_memory(struct zonelist *zone
 		goto out;
 	}
 
-	/*
-	 * Check if there were limitations on the allocation (only relevant for
-	 * NUMA) that may require different handling.
-	 */
-	constraint = constrained_alloc(zonelist, gfp_mask, nodemask,
-						&totalpages);
-	mpol_mask = (constraint == CONSTRAINT_MEMORY_POLICY) ? nodemask : NULL;
-	check_panic_on_oom(constraint, gfp_mask, order, mpol_mask, NULL);
-
 	if (sysctl_oom_kill_allocating_task && current->mm &&
 	    !oom_unkillable_task(current, NULL, nodemask) &&
 	    current->signal->oom_score_adj != OOM_SCORE_ADJ_MIN) {
_

Patches currently in -mm which might be from mhocko@suse.cz are

memcg-do-not-call-reclaim-if-__gfp_wait.patch
jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
mm-meminit-inline-some-helper-functions-fix2.patch
mm-only-define-hashdist-variable-when-needed.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-reclaimable-pages.patch
rename-reclaim_swap-to-reclaim_unmap.patch
mm-oom_kill-remove-unnecessary-locking-in-oom_enable.patch
mm-oom_kill-clean-up-victim-marking-and-exiting-interfaces.patch
mm-oom_kill-switch-test-and-clear-of-known-tif_memdie-to-clear.patch
mm-oom_kill-generalize-oom-progress-waitqueue.patch
mm-oom_kill-remove-unnecessary-locking-in-exit_oom_victim.patch
mm-oom_kill-simplify-oom-killer-locking.patch
mm-page_alloc-inline-should_alloc_retry.patch
hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages.patch
hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages-fix.patch
mm-memcg-try-charging-a-page-before-setting-page-up-to-date.patch
documentation-vm-unevictable-lrutxt-clarify-map_locked-behavior.patch
oom-print-points-as-unsigned-int.patch
oom-always-panic-on-oom-when-panic_on_oom-is-configured.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
exitstats-obey-this-comment.patch
linux-next.patch

