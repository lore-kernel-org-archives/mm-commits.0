From: akpm@linux-foundation.org
Subject: +
 mm-memory_hotplug-do-not-back-off-draining-pcp-free-pages-from-kworker-context.patch added to -mm tree
Date: Mon, 28 Aug 2017 15:34:40 -0700
Message-ID: <59a49a80.CK0Q7DSjWKlWelmq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37446 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751194AbdH1Wel (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Aug 2017 18:34:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, mgorman@suse.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memory_hotplug: do not back off draining pcp free pages from kworker context
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-do-not-back-off-draining-pcp-free-pages-from-kworker-context.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-do-not-back-off-draining-pcp-free-pages-from-kworker-context.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-do-not-back-off-draining-pcp-free-pages-from-kworker-context.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, memory_hotplug: do not back off draining pcp free pages from kworker context

drain_all_pages backs off when called from a kworker context since
0ccce3b924212 ("mm, page_alloc: drain per-cpu pages from workqueue
context") because the original IPI based pcp draining has been replaced by
a WQ based one and the check wanted to prevent from recursion and inter
workers dependencies.  This has made some sense at the time because the
system WQ has been used and one worker holding the lock could be blocked
while waiting for new workers to emerge which can be a problem under OOM
conditions.

Since then ce612879ddc7 ("mm: move pcp and lru-pcp draining into single
wq") has moved draining to a dedicated (mm_percpu_wq) WQ with a rescuer so
we shouldn't depend on any other WQ activity to make a forward progress so
calling drain_all_pages from a worker context is safe as long as this
doesn't happen from mm_percpu_wq itself which is not the case because all
workers are required to _not_ depend on any MM locks.

Why is this a problem in the first place?  ACPI driven memory hot-remove
(acpi_device_hotplug) is executed from the worker context.  We end up
calling __offline_pages to free all the pages and that requires both
lru_add_drain_all_cpuslocked and drain_all_pages to do their job otherwise
we can have dangling pages on pcp lists and fail the offline operation
(__test_page_isolated_in_pageblock would see a page with 0 ref.  count but
without PageBuddy set).

Fix the issue by removing the worker check in drain_all_pages. 
lru_add_drain_all_cpuslocked doesn't have this restriction so it works as
expected.

Link: http://lkml.kernel.org/r/20170828093341.26341-1-mhocko@kernel.org
Fixes: 0ccce3b924212 ("mm, page_alloc: drain per-cpu pages from workqueue context")
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN mm/page_alloc.c~mm-memory_hotplug-do-not-back-off-draining-pcp-free-pages-from-kworker-context mm/page_alloc.c
--- a/mm/page_alloc.c~mm-memory_hotplug-do-not-back-off-draining-pcp-free-pages-from-kworker-context
+++ a/mm/page_alloc.c
@@ -2477,10 +2477,6 @@ void drain_all_pages(struct zone *zone)
 	if (WARN_ON_ONCE(!mm_percpu_wq))
 		return;
 
-	/* Workqueues cannot recurse */
-	if (current->flags & PF_WQ_WORKER)
-		return;
-
 	/*
 	 * Do not drain if one is already in progress unless it's specific to
 	 * a zone. Such callers are primarily CMA and memory hotplug and need
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-memory_hotplug-do-not-back-off-draining-pcp-free-pages-from-kworker-context.patch
mm-memory_hotplug-display-allowed-zones-in-the-preferred-ordering.patch
mm-memory_hotplug-remove-zone-restrictions.patch
mm-page_alloc-rip-out-zonelist_order_zone.patch
mm-page_alloc-rip-out-zonelist_order_zone-fix.patch
mm-page_alloc-remove-boot-pageset-initialization-from-memory-hotplug.patch
mm-page_alloc-do-not-set_cpu_numa_mem-on-empty-nodes-initialization.patch
mm-memory_hotplug-drop-zone-from-build_all_zonelists.patch
mm-memory_hotplug-remove-explicit-build_all_zonelists-from-try_online_node.patch
mm-page_alloc-simplify-zonelist-initialization.patch
mm-page_alloc-remove-stop_machine-from-build_all_zonelists.patch
mm-memory_hotplug-get-rid-of-zonelists_mutex.patch
mm-sparse-page_ext-drop-ugly-n_high_memory-branches-for-allocations.patch
mm-vmscan-do-not-loop-on-too_many_isolated-for-ever.patch
mm-vmscan-do-not-loop-on-too_many_isolated-for-ever-fix.patch
mm-rename-global_page_state-to-global_zone_page_state.patch
mm-hugetlb-do-not-allocate-non-migrateable-gigantic-pages-from-movable-zones.patch
mm-oom-do-not-rely-on-tif_memdie-for-memory-reserves-access.patch
mm-replace-tif_memdie-checks-by-tsk_is_oom_victim.patch
mm-memory_hotplug-introduce-add_pages.patch
fs-proc-remove-priv-argument-from-is_stack.patch
treewide-remove-gfp_temporary-allocation-flag.patch

