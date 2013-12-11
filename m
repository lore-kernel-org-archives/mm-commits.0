From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure.patch
 added to -mm tree
Date: Wed, 11 Dec 2013 15:59:22 -0800
Message-ID: <52a8fc5a.HrhzSAherbStbM5t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50628 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab3LKX7X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Dec 2013 18:59:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, mgorman@suse.de, akpm@linux-foundation.org, rientjes@google.com

Subject: + mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure.patch added to -mm tree
To: rientjes@google.com,akpm@linux-foundation.org,mgorman@suse.de,mhocko@suse.cz
From: akpm@linux-foundation.org
Date: Wed, 11 Dec 2013 15:59:22 -0800


The patch titled
     Subject: mm, page_alloc: warn for non-blockable __GFP_NOFAIL allocation failure
has been added to the -mm tree.  Its filename is
     mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, page_alloc: warn for non-blockable __GFP_NOFAIL allocation failure

__GFP_NOFAIL may return NULL when coupled with GFP_NOWAIT or GFP_ATOMIC.

Luckily, nothing currently does such craziness.  So instead of causing
such allocations to loop (potentially forever), we maintain the current
behavior and also warn about the new users of the deprecated flag.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure
+++ a/mm/page_alloc.c
@@ -2527,8 +2527,15 @@ rebalance:
 	}
 
 	/* Atomic allocations - we can't balance anything */
-	if (!wait)
+	if (!wait) {
+		/*
+		 * All existing users of the deprecated __GFP_NOFAIL are
+		 * blockable, so warn of any new users that actually allow this
+		 * type of allocation to fail.
+		 */
+		WARN_ON_ONCE(gfp_mask & __GFP_NOFAIL);
 		goto nopage;
+	}
 
 	/* Avoid recursion of direct reclaim */
 	if (current->flags & PF_MEMALLOC)
_

Patches currently in -mm which might be from rientjes@google.com are

include-linux-hugetlbh-make-isolate_huge_page-an-inline.patch
mm-memcg-do-not-declare-oom-from-__gfp_nofail-allocations.patch
mm-memcg-fix-race-condition-between-memcg-teardown-and-swapin.patch
mm-memcg-do-not-allow-task-about-to-oom-kill-to-bypass-the-limit.patch
arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit.patch
arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit-fix.patch
mm-memcg-avoid-oom-notification-when-current-needs-access-to-memory-reserves.patch
mm-mempolicy-remove-unneeded-functions-for-uma-configs.patch
mm-show_mem-remove-show_mem_filter_page_count.patch
introduce-for_each_thread-to-replace-the-buggy-while_each_thread.patch
oom_kill-change-oom_killc-to-use-for_each_thread.patch
oom_kill-has_intersects_mems_allowed-needs-rcu_read_lock.patch
oom_kill-add-rcu_read_lock-into-find_lock_task_mm.patch
mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim.patch
lib-show_memc-show-num_poisoned_pages-when-oom.patch
memcg-oom-lock-mem_cgroup_print_oom_info.patch
mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure.patch
checkpatch-add-warning-of-future-__gfp_nofail-use.patch

