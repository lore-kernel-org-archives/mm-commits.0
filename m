From: akpm@linux-foundation.org
Subject: - oom-move-constraints-to-enum.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:51:38 -0700
Message-ID: <200710180651.l9I6pcgR030205@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40514 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932434AbXJRHob (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:44:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, andrea@suse.de, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     oom: move constraints to enum
has been removed from the -mm tree.  Its filename was
     oom-move-constraints-to-enum.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: oom: move constraints to enum
From: David Rientjes <rientjes@google.com>

The OOM killer's CONSTRAINT definitions are really more appropriate in an
enum, so define them in include/linux/oom.h.

Cc: Andrea Arcangeli <andrea@suse.de>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h |    9 +++++++++
 mm/oom_kill.c       |   12 +++---------
 2 files changed, 12 insertions(+), 9 deletions(-)

diff -puN include/linux/oom.h~oom-move-constraints-to-enum include/linux/oom.h
--- a/include/linux/oom.h~oom-move-constraints-to-enum
+++ a/include/linux/oom.h
@@ -11,6 +11,15 @@
 
 #ifdef __KERNEL__
 
+/*
+ * Types of limitations to the nodes from which allocations may occur
+ */
+enum oom_constraint {
+	CONSTRAINT_NONE,
+	CONSTRAINT_CPUSET,
+	CONSTRAINT_MEMORY_POLICY,
+};
+
 extern void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask, int order);
 extern int register_oom_notifier(struct notifier_block *nb);
 extern int unregister_oom_notifier(struct notifier_block *nb);
diff -puN mm/oom_kill.c~oom-move-constraints-to-enum mm/oom_kill.c
--- a/mm/oom_kill.c~oom-move-constraints-to-enum
+++ a/mm/oom_kill.c
@@ -164,16 +164,10 @@ unsigned long badness(struct task_struct
 }
 
 /*
- * Types of limitations to the nodes from which allocations may occur
- */
-#define CONSTRAINT_NONE 1
-#define CONSTRAINT_MEMORY_POLICY 2
-#define CONSTRAINT_CPUSET 3
-
-/*
  * Determine the type of allocation constraint.
  */
-static inline int constrained_alloc(struct zonelist *zonelist, gfp_t gfp_mask)
+static inline enum oom_constraint constrained_alloc(struct zonelist *zonelist,
+						    gfp_t gfp_mask)
 {
 #ifdef CONFIG_NUMA
 	struct zone **z;
@@ -393,7 +387,7 @@ void out_of_memory(struct zonelist *zone
 	struct task_struct *p;
 	unsigned long points = 0;
 	unsigned long freed = 0;
-	int constraint;
+	enum oom_constraint constraint;
 
 	blocking_notifier_call_chain(&oom_notify_list, 0, &freed);
 	if (freed > 0)
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
