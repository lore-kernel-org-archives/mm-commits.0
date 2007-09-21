From: akpm@linux-foundation.org
Subject: + oom-do-not-take-callback_mutex.patch added to -mm tree
Date: Fri, 21 Sep 2007 02:11:13 -0700
Message-ID: <200709210911.l8L9BDds028219@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52618 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752740AbXIUJLY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 05:11:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, andrea@suse.de, clameter@sgi.com


The patch titled
     oom: do not take callback_mutex
has been added to the -mm tree.  Its filename is
     oom-do-not-take-callback_mutex.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: oom: do not take callback_mutex
From: David Rientjes <rientjes@google.com>

Since no task descriptor's 'cpuset' field is dereferenced in the execution of
the OOM killer anymore, it is no longer necessary to take callback_mutex.

Cc: Andrea Arcangeli <andrea@suse.de>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpuset.h |    6 ------
 kernel/cpuset.c        |   27 ---------------------------
 mm/oom_kill.c          |    3 ---
 3 files changed, 36 deletions(-)

diff -puN include/linux/cpuset.h~oom-do-not-take-callback_mutex include/linux/cpuset.h
--- a/include/linux/cpuset.h~oom-do-not-take-callback_mutex
+++ a/include/linux/cpuset.h
@@ -59,9 +59,6 @@ extern void __cpuset_memory_pressure_bum
 extern const struct file_operations proc_cpuset_operations;
 extern char *cpuset_task_status_allowed(struct task_struct *task, char *buffer);
 
-extern void cpuset_lock(void);
-extern void cpuset_unlock(void);
-
 extern int cpuset_mem_spread_node(void);
 
 static inline int cpuset_do_page_mem_spread(void)
@@ -128,9 +125,6 @@ static inline char *cpuset_task_status_a
 	return buffer;
 }
 
-static inline void cpuset_lock(void) {}
-static inline void cpuset_unlock(void) {}
-
 static inline int cpuset_mem_spread_node(void)
 {
 	return 0;
diff -puN kernel/cpuset.c~oom-do-not-take-callback_mutex kernel/cpuset.c
--- a/kernel/cpuset.c~oom-do-not-take-callback_mutex
+++ a/kernel/cpuset.c
@@ -2521,33 +2521,6 @@ int __cpuset_zone_allowed_hardwall(struc
 }
 
 /**
- * cpuset_lock - lock out any changes to cpuset structures
- *
- * The out of memory (oom) code needs to mutex_lock cpusets
- * from being changed while it scans the tasklist looking for a
- * task in an overlapping cpuset.  Expose callback_mutex via this
- * cpuset_lock() routine, so the oom code can lock it, before
- * locking the task list.  The tasklist_lock is a spinlock, so
- * must be taken inside callback_mutex.
- */
-
-void cpuset_lock(void)
-{
-	mutex_lock(&callback_mutex);
-}
-
-/**
- * cpuset_unlock - release lock on cpuset changes
- *
- * Undo the lock taken in a previous cpuset_lock() call.
- */
-
-void cpuset_unlock(void)
-{
-	mutex_unlock(&callback_mutex);
-}
-
-/**
  * cpuset_mem_spread_node() - On which node to begin search for a page
  *
  * If a task is marked PF_SPREAD_PAGE or PF_SPREAD_SLAB (as for
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
oom-move-constraints-to-enum.patch
oom-change-all_unreclaimable-zone-member-to-flags.patch
oom-change-all_unreclaimable-zone-member-to-flags-fix.patch
oom-add-per-zone-locking.patch
oom-serialize-out-of-memory-calls.patch
oom-add-oom_kill_allocating_task-sysctl.patch
oom-suppress-extraneous-stack-and-memory-dump.patch
oom-compare-cpuset-mems_allowed-instead-of-exclusive.patch
oom-do-not-take-callback_mutex.patch
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
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
