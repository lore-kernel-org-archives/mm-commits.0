From: akpm@linux-foundation.org
Subject: [alternative-merged] oom-oom_kill-doesnt-kill-vfork-parentor-child.patch removed from -mm tree
Date: Wed, 12 Aug 2009 17:05:07 -0700
Message-ID: <200908130005.n7D0578g008713@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58683 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750897AbZHMAF3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Aug 2009 20:05:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     oom: oom_kill doesn't kill vfork parent(or child)
has been removed from the -mm tree.  Its filename was
     oom-oom_kill-doesnt-kill-vfork-parentor-child.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom: oom_kill doesn't kill vfork parent(or child)


Current oom_kill doesn't only kill victim process, but also kill mm shread
task.  it mean vfork parent will be killed.

but, That's bogus.  another process have another oom_adj.  we shouldn't
ignore their oom_adj (it might have OOM_DISABLE).

following caller hit the minefield.

---------------------------------------
        switch (constraint) {
        case CONSTRAINT_MEMORY_POLICY:
                oom_kill_process(current, gfp_mask, order, 0, NULL,
                                "No available memory (MPOL_BIND)");
                break;

Note: force_sig(SIGKILL) send SIGKILL to all thread in the process.
We don't need to care multi thread in here.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   12 ------------
 1 file changed, 12 deletions(-)

diff -puN mm/oom_kill.c~oom-oom_kill-doesnt-kill-vfork-parentor-child mm/oom_kill.c
--- a/mm/oom_kill.c~oom-oom_kill-doesnt-kill-vfork-parentor-child
+++ a/mm/oom_kill.c
@@ -399,23 +399,11 @@ static void __oom_kill_task(struct task_
 
 static int oom_kill_task(struct task_struct *p)
 {
-	struct task_struct *g, *q;
-
 	if (get_oom_adj(p) == OOM_DISABLE)
 		return 1;
 
 	__oom_kill_task(p, 1);
 
-	/*
-	 * kill all processes that share the ->mm (i.e. all threads),
-	 * but are in a different thread group. Don't let them have access
-	 * to memory reserves though, otherwise we might deplete all memory.
-	 */
-	do_each_thread(g, q) {
-		if (q->mm == p->mm && !same_thread_group(q, p))
-			force_sig(SIGKILL, q);
-	} while_each_thread(g, q);
-
 	return 0;
 }
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
mm-revert-oom-move-oom_adj-value.patch
linux-next.patch
readahead-add-blk_run_backing_dev.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
mm-clean-up-page_remove_rmap.patch
mm-show_free_areas-display-slab-pages-in-two-separate-fields.patch
mm-oom-analysis-add-per-zone-statistics-to-show_free_areas.patch
mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
mm-oom-analysis-show-kernel-stack-usage-in-proc-meminfo-and-oom-log-output.patch
mm-oom-analysis-add-shmem-vmstat.patch
mm-rename-pgmoved-variable-in-shrink_active_list.patch
mm-shrink_inactive_list-nr_scan-accounting-fix-fix.patch
mm-vmstat-add-isolate-pages.patch
mm-vmstat-add-isolate-pages-fix.patch
vmscan-throttle-direct-reclaim-when-too-many-pages-are-isolated-already.patch
mm-remove-__addsub_zone_page_state.patch
mm-count-only-reclaimable-lru-pages-v2.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
vmscan-move-clearpageactive-from-move_active_pages-to-shrink_active_list.patch
vmscan-kill-unnecessary-page-flag-test.patch
vmscan-kill-unnecessary-prefetch.patch
mm-perform-non-atomic-test-clear-of-pg_mlocked-on-free.patch
oom-oom_kill-doesnt-kill-vfork-parentor-child.patch
oom-fix-oom_adjust_write-input-sanity-check.patch
oom-fix-oom_adjust_write-input-sanity-check-fix.patch
tracing-page-allocator-add-trace-events-for-page-allocation-and-page-freeing.patch
tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
memory-controller-soft-limit-documentation-v9.patch
memory-controller-soft-limit-interface-v9.patch
memory-controller-soft-limit-organize-cgroups-v9.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
memory-controller-soft-limit-refactor-reclaim-flags-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memcg-improve-resource-counter-scalability.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

