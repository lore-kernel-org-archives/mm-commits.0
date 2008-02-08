From: akpm@linux-foundation.org
Subject: - memcontrol-move-oom-task-exclusion-to-tasklist.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:03:39 -0800
Message-ID: <200802080803.m1883KjN014114@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45003 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932718AbYBHIUm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:20:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, balbir@linux.vnet.ibm.com, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     memcontrol: move oom task exclusion to tasklist scan
has been removed from the -mm tree.  Its filename was
     memcontrol-move-oom-task-exclusion-to-tasklist.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcontrol: move oom task exclusion to tasklist scan
From: David Rientjes <rientjes@google.com>

Creates a helper function to return non-zero if a task is a member of a
memory controller:

	int task_in_mem_cgroup(const struct task_struct *task,
			       const struct mem_cgroup *mem);

When the OOM killer is constrained by the memory controller, the exclusion
of tasks that are not a member of that controller was previously misplaced
and appeared in the badness scoring function.  It should be excluded
during the tasklist scan in select_bad_process() instead.

[akpm@linux-foundation.org: build fix]
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    7 +++++++
 mm/memcontrol.c            |   10 ++++++++++
 mm/oom_kill.c              |    9 ++-------
 3 files changed, 19 insertions(+), 7 deletions(-)

diff -puN include/linux/memcontrol.h~memcontrol-move-oom-task-exclusion-to-tasklist include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcontrol-move-oom-task-exclusion-to-tasklist
+++ a/include/linux/memcontrol.h
@@ -48,6 +48,7 @@ extern unsigned long mem_cgroup_isolate_
 extern void mem_cgroup_out_of_memory(struct mem_cgroup *mem, gfp_t gfp_mask);
 extern int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 					gfp_t gfp_mask);
+int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem);
 
 static inline struct mem_cgroup *mm_cgroup(const struct mm_struct *mm)
 {
@@ -110,6 +111,12 @@ static inline struct mem_cgroup *mm_cgro
 	return NULL;
 }
 
+static inline int task_in_mem_cgroup(struct task_struct *task,
+				     const struct mem_cgroup *mem)
+{
+	return 1;
+}
+
 #endif /* CONFIG_CGROUP_MEM_CONT */
 
 #endif /* _LINUX_MEMCONTROL_H */
diff -puN mm/memcontrol.c~memcontrol-move-oom-task-exclusion-to-tasklist mm/memcontrol.c
--- a/mm/memcontrol.c~memcontrol-move-oom-task-exclusion-to-tasklist
+++ a/mm/memcontrol.c
@@ -170,6 +170,16 @@ static void __mem_cgroup_move_lists(stru
 		list_move(&pc->lru, &pc->mem_cgroup->inactive_list);
 }
 
+int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem)
+{
+	int ret;
+
+	task_lock(task);
+	ret = task->mm && mm_cgroup(task->mm) == mem;
+	task_unlock(task);
+	return ret;
+}
+
 /*
  * This routine assumes that the appropriate zone's lru lock is already held
  */
diff -puN mm/oom_kill.c~memcontrol-move-oom-task-exclusion-to-tasklist mm/oom_kill.c
--- a/mm/oom_kill.c~memcontrol-move-oom-task-exclusion-to-tasklist
+++ a/mm/oom_kill.c
@@ -65,13 +65,6 @@ unsigned long badness(struct task_struct
 		return 0;
 	}
 
-#ifdef CONFIG_CGROUP_MEM_CONT
-	if (mem != NULL && mm->mem_cgroup != mem) {
-		task_unlock(p);
-		return 0;
-	}
-#endif
-
 	/*
 	 * The memory size of the process is the basis for the badness.
 	 */
@@ -223,6 +216,8 @@ static struct task_struct *select_bad_pr
 		/* skip the init task */
 		if (is_global_init(p))
 			continue;
+		if (mem && !task_in_mem_cgroup(p, mem))
+			continue;
 
 		/*
 		 * This task already has access to memory reserves and is
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-nommu-fix.patch
