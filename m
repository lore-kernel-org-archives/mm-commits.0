From: akpm@linux-foundation.org
Subject: + memcontrol-move-oom-task-exclusion-to-tasklist.patch added to -mm tree
Date: Thu, 27 Sep 2007 17:03:57 -0700
Message-ID: <200709280003.l8S03vSM001988@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57601 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756554AbXI1AET (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Sep 2007 20:04:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, balbir@linux.vnet.ibm.com, clameter@sgi.com


The patch titled
     memcontrol: move oom task exclusion to tasklist scan
has been added to the -mm tree.  Its filename is
     memcontrol-move-oom-task-exclusion-to-tasklist.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Cc: Christoph Lameter <clameter@sgi.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN include/linux/memcontrol.h~memcontrol-move-oom-task-exclusion-to-tasklist include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcontrol-move-oom-task-exclusion-to-tasklist
+++ a/include/linux/memcontrol.h
@@ -56,6 +56,16 @@ static inline void mem_cgroup_uncharge_p
 	mem_cgroup_uncharge(page_get_page_cgroup(page));
 }
 
+static inline int task_in_mem_cgroup(struct task_struct *task,
+				     const struct mem_cgroup *mem)
+{
+	int ret;
+	task_lock(task);
+	ret = task->mm && mm_cgroup(task->mm) == mem;
+	task_unlock(task);
+	return ret;
+}
+
 #else /* CONFIG_CGROUP_MEM_CONT */
 static inline void mm_init_cgroup(struct mm_struct *mm,
 					struct task_struct *p)
@@ -107,6 +117,12 @@ static inline struct mem_cgroup *mm_cgro
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
@@ -224,6 +217,8 @@ static struct task_struct *select_bad_pr
 		/* skip the init task */
 		if (is_global_init(p))
 			continue;
+		if (mem && !task_in_mem_cgroup(p, mem))
+			continue;
 
 		/*
 		 * This task already has access to memory reserves and is
_

Patches currently in -mm which might be from rientjes@google.com are

maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
oom-move-prototypes-to-appropriate-header-file.patch
oom-move-prototypes-to-appropriate-header-file-fix.patch
oom-move-constraints-to-enum.patch
oom-change-all_unreclaimable-zone-member-to-flags.patch
oom-change-all_unreclaimable-zone-member-to-flags-fix.patch
oom-add-per-zone-locking.patch
oom-serialize-out-of-memory-calls.patch
oom-add-oom_kill_allocating_task-sysctl.patch
oom-suppress-extraneous-stack-and-memory-dump.patch
oom-compare-cpuset-mems_allowed-instead-of-exclusive.patch
oom-do-not-take-callback_mutex.patch
oom-do-not-take-callback_mutex-fix.patch
oom-prevent-including-schedh-in-header-file.patch
oom-add-header-file-to-kbuild-as-unifdef.patch
oom-convert-zone_scan_lock-from-mutex-to-spinlock.patch
mm-test-and-set-zone-reclaim-lock-before-starting.patch
mm-test-and-set-zone-reclaim-lock-before-starting-cleanup.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
add-a-missing-00-index-file-for-documentation-vm-fix.patch
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
