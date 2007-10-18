From: akpm@linux-foundation.org
Subject: - oom-serialize-out-of-memory-calls.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:51:45 -0700
Message-ID: <200710180651.l9I6pjbl030214@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45920 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932803AbXJRHoo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:44:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, andrea@suse.de, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     oom: serialize out of memory calls
has been removed from the -mm tree.  Its filename was
     oom-serialize-out-of-memory-calls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: oom: serialize out of memory calls
From: David Rientjes <rientjes@google.com>

A final allocation attempt with a very high watermark needs to be attempted
before invoking out_of_memory().  OOM killer serialization needs to occur
before this final attempt, otherwise tasks attempting to OOM-lock all zones in
its zonelist may spin and acquire the lock unnecessarily after the OOM
condition has already been alleviated.

If the final allocation does succeed, the zonelist is simply OOM-unlocked and
__alloc_pages() returns the page.  Otherwise, the OOM killer is invoked.

If the task cannot acquire OOM-locks on all zones in its zonelist, it is put
to sleep and the allocation is retried when it gets rescheduled.  One of its
zones is already marked as being in the OOM killer so it'll hopefully be
getting some free memory soon, at least enough to satisfy a high watermark
allocation attempt.  This prevents needlessly killing a task when the OOM
condition would have already been alleviated if it had simply been given
enough time.

Cc: Andrea Arcangeli <andrea@suse.de>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~oom-serialize-out-of-memory-calls mm/page_alloc.c
--- a/mm/page_alloc.c~oom-serialize-out-of-memory-calls
+++ a/mm/page_alloc.c
@@ -1587,6 +1587,11 @@ nofail_alloc:
 		if (page)
 			goto got_pg;
 	} else if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)) {
+		if (!try_set_zone_oom(zonelist)) {
+			schedule_timeout_uninterruptible(1);
+			goto restart;
+		}
+
 		/*
 		 * Go through the zonelist yet one more time, keep
 		 * very high watermark here, this is only to catch
@@ -1595,14 +1600,19 @@ nofail_alloc:
 		 */
 		page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, order,
 				zonelist, ALLOC_WMARK_HIGH|ALLOC_CPUSET);
-		if (page)
+		if (page) {
+			clear_zonelist_oom(zonelist);
 			goto got_pg;
+		}
 
 		/* The OOM killer will not help higher order allocs so fail */
-		if (order > PAGE_ALLOC_COSTLY_ORDER)
+		if (order > PAGE_ALLOC_COSTLY_ORDER) {
+			clear_zonelist_oom(zonelist);
 			goto nopage;
+		}
 
 		out_of_memory(zonelist, gfp_mask, order);
+		clear_zonelist_oom(zonelist);
 		goto restart;
 	}
 
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
fix-cpusets-update_cpumask.patch
fix-cpusets-update_cpumask-checkpatch-fixes.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-resource-counters-v7-fix.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
memcontrol-move-mm_cgroup-to-header-file.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memcontrol-move-oom-task-exclusion-to-tasklist-fix.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
