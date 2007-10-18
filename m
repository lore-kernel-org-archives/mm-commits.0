From: akpm@linux-foundation.org
Subject: - oom-suppress-extraneous-stack-and-memory-dump.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:51:50 -0700
Message-ID: <200710180651.l9I6poAu030220@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40336 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933012AbXJRHo5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:44:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, andrea@suse.de, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     oom: suppress extraneous stack and memory dump
has been removed from the -mm tree.  Its filename was
     oom-suppress-extraneous-stack-and-memory-dump.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: oom: suppress extraneous stack and memory dump
From: David Rientjes <rientjes@google.com>

Suppresses the extraneous stack and memory dump when a parallel OOM killing
has been found.  There's no need to fill the ring buffer with this information
if its already been printed and the condition that triggered the previous OOM
killer has not yet been alleviated.

Cc: Andrea Arcangeli <andrea@suse.de>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff -puN mm/oom_kill.c~oom-suppress-extraneous-stack-and-memory-dump mm/oom_kill.c
--- a/mm/oom_kill.c~oom-suppress-extraneous-stack-and-memory-dump
+++ a/mm/oom_kill.c
@@ -333,12 +333,20 @@ static int oom_kill_task(struct task_str
 	return 0;
 }
 
-static int oom_kill_process(struct task_struct *p, unsigned long points,
-		const char *message)
+static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
+			    unsigned long points, const char *message)
 {
 	struct task_struct *c;
 	struct list_head *tsk;
 
+	if (printk_ratelimit()) {
+		printk(KERN_WARNING "%s invoked oom-killer: "
+			"gfp_mask=0x%x, order=%d, oomkilladj=%d\n",
+			current->comm, gfp_mask, order, current->oomkilladj);
+		dump_stack();
+		show_mem();
+	}
+
 	/*
 	 * If the task is already exiting, don't alarm the sysadmin or kill
 	 * its children or threads, just set TIF_MEMDIE so it can die quickly
@@ -447,14 +455,6 @@ void out_of_memory(struct zonelist *zone
 		/* Got some memory back in the last second. */
 		return;
 
-	if (printk_ratelimit()) {
-		printk(KERN_WARNING "%s invoked oom-killer: "
-			"gfp_mask=0x%x, order=%d, oomkilladj=%d\n",
-			current->comm, gfp_mask, order, current->oomkilladj);
-		dump_stack();
-		show_mem();
-	}
-
 	if (sysctl_panic_on_oom == 2)
 		panic("out of memory. Compulsory panic_on_oom is selected.\n");
 
@@ -468,7 +468,7 @@ void out_of_memory(struct zonelist *zone
 
 	switch (constraint) {
 	case CONSTRAINT_MEMORY_POLICY:
-		oom_kill_process(current, points,
+		oom_kill_process(current, gfp_mask, order, points,
 				"No available memory (MPOL_BIND)");
 		break;
 
@@ -478,7 +478,7 @@ void out_of_memory(struct zonelist *zone
 		/* Fall-through */
 	case CONSTRAINT_CPUSET:
 		if (sysctl_oom_kill_allocating_task) {
-			oom_kill_process(current, points,
+			oom_kill_process(current, gfp_mask, order, points,
 					"Out of memory (oom_kill_allocating_task)");
 			break;
 		}
@@ -499,7 +499,8 @@ retry:
 			panic("Out of memory and no killable processes...\n");
 		}
 
-		if (oom_kill_process(p, points, "Out of memory"))
+		if (oom_kill_process(p, points, gfp_mask, order,
+				     "Out of memory"))
 			goto retry;
 
 		break;
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
