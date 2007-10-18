From: akpm@linux-foundation.org
Subject: - oom-do-not-take-callback_mutex.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:51:55 -0700
Message-ID: <200710180651.l9I6ptEF030226@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40779 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932417AbXJRHns (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:43:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, andrea@suse.de, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     oom: do not take callback_mutex
has been removed from the -mm tree.  Its filename was
     oom-do-not-take-callback_mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: oom: do not take callback_mutex
From: David Rientjes <rientjes@google.com>

Since no task descriptor's 'cpuset' field is dereferenced in the execution of
the OOM killer anymore, it is no longer necessary to take callback_mutex.

[akpm@linux-foundation.org: restore cpuset_lock for other patches]
Cc: Andrea Arcangeli <andrea@suse.de>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/oom_kill.c~oom-do-not-take-callback_mutex mm/oom_kill.c
--- a/mm/oom_kill.c~oom-do-not-take-callback_mutex
+++ a/mm/oom_kill.c
@@ -463,7 +463,6 @@ void out_of_memory(struct zonelist *zone
 	 * NUMA) that may require different handling.
 	 */
 	constraint = constrained_alloc(zonelist, gfp_mask);
-	cpuset_lock();
 	read_lock(&tasklist_lock);
 
 	switch (constraint) {
@@ -495,7 +494,6 @@ retry:
 		/* Found nothing?!?! Either we hang forever, or we panic. */
 		if (!p) {
 			read_unlock(&tasklist_lock);
-			cpuset_unlock();
 			panic("Out of memory and no killable processes...\n");
 		}
 
@@ -508,7 +506,6 @@ retry:
 
 out:
 	read_unlock(&tasklist_lock);
-	cpuset_unlock();
 
 	/*
 	 * Give "p" a good chance of killing itself before we
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
