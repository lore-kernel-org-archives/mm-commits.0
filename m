From: akpm@linux-foundation.org
Subject: + tracepoint-add-tracepoints-for-debugging-oom_score_adj.patch added to -mm tree
Date: Thu, 15 Dec 2011 13:33:07 -0800
Message-ID: <20111215213307.A80CC1E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:52425 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab1LOVdJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2011 16:33:09 -0500
Received: by ghbf20 with SMTP id f20so262544ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2011 13:33:08 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com


The patch titled
     Subject: tracepoint: add tracepoints for debugging oom_score_adj
has been added to the -mm tree.  Its filename is
     tracepoint-add-tracepoints-for-debugging-oom_score_adj.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: tracepoint: add tracepoints for debugging oom_score_adj

oom_score_adj is used for guarding processes from OOM-Killer.  One of
problem is that it's inherited at fork().  When a daemon set oom_score_adj
and make children, it's hard to know where the value is set.

This patch adds some tracepoints useful for debugging. This patch adds
3 trace points.
  - creating new task
  - renaming a task (exec)
  - set oom_score_adj

To debug, users need to enable some trace pointer. Maybe filtering is useful as

# EVENT=/sys/kernel/debug/tracing/events/task/
# echo "oom_score_adj != 0" > $EVENT/task_newtask/filter
# echo "oom_score_adj != 0" > $EVENT/task_rename/filter
# echo 1 > $EVENT/enable
# EVENT=/sys/kernel/debug/tracing/events/oom/
# echo 1 > $EVENT/enable

output will be like this.
# grep oom /sys/kernel/debug/tracing/trace
bash-7699  [007] d..3  5140.744510: oom_score_adj_update: pid=7699 comm=bash oom_score_adj=-1000
bash-7699  [007] ...1  5151.818022: task_newtask: pid=7729 comm=bash clone_flags=1200011 oom_score_adj=-1000
ls-7729  [003] ...2  5151.818504: task_rename: pid=7729 oldcomm=bash newcomm=ls oom_score_adj=-1000
bash-7699  [002] ...1  5175.701468: task_newtask: pid=7730 comm=bash clone_flags=1200011 oom_score_adj=-1000
grep-7730  [007] ...2  5175.701993: task_rename: pid=7730 oldcomm=bash newcomm=grep oom_score_adj=-1000

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c                   |    4 ++
 fs/proc/base.c              |    3 +
 include/trace/events/oom.h  |   35 ++++++++++++++++++
 include/trace/events/task.h |   63 ++++++++++++++++++++++++++++++++++
 kernel/fork.c               |    6 +++
 mm/oom_kill.c               |    6 +++
 6 files changed, 117 insertions(+)

diff -puN fs/exec.c~tracepoint-add-tracepoints-for-debugging-oom_score_adj fs/exec.c
--- a/fs/exec.c~tracepoint-add-tracepoints-for-debugging-oom_score_adj
+++ a/fs/exec.c
@@ -59,6 +59,8 @@
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
 #include <asm/tlb.h>
+
+#include <trace/events/task.h>
 #include "internal.h"
 
 int core_uses_pid;
@@ -1054,6 +1056,8 @@ void set_task_comm(struct task_struct *t
 {
 	task_lock(tsk);
 
+	trace_task_rename(tsk, buf);
+
 	/*
 	 * Threads may access current->comm without holding
 	 * the task lock, so write the string carefully.
diff -puN fs/proc/base.c~tracepoint-add-tracepoints-for-debugging-oom_score_adj fs/proc/base.c
--- a/fs/proc/base.c~tracepoint-add-tracepoints-for-debugging-oom_score_adj
+++ a/fs/proc/base.c
@@ -86,6 +86,7 @@
 #ifdef CONFIG_HARDWALL
 #include <asm/hardwall.h>
 #endif
+#include <trace/events/oom.h>
 #include "internal.h"
 
 /* NOTE:
@@ -1124,6 +1125,7 @@ static ssize_t oom_adjust_write(struct f
 	else
 		task->signal->oom_score_adj = (oom_adjust * OOM_SCORE_ADJ_MAX) /
 								-OOM_DISABLE;
+	trace_oom_score_adj_update(task);
 err_sighand:
 	unlock_task_sighand(task, &flags);
 err_task_lock:
@@ -1211,6 +1213,7 @@ static ssize_t oom_score_adj_write(struc
 	task->signal->oom_score_adj = oom_score_adj;
 	if (has_capability_noaudit(current, CAP_SYS_RESOURCE))
 		task->signal->oom_score_adj_min = oom_score_adj;
+	trace_oom_score_adj_update(task);
 	/*
 	 * Scale /proc/pid/oom_adj appropriately ensuring that OOM_DISABLE is
 	 * always attainable.
diff -puN /dev/null include/trace/events/oom.h
--- /dev/null
+++ a/include/trace/events/oom.h
@@ -0,0 +1,35 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM oom
+
+#if !defined(_TRACE_OOM_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_OOM_H
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(oom_score_adj_update,
+
+	TP_PROTO(struct task_struct *task),
+
+	TP_ARGS(task),
+
+	TP_STRUCT__entry(
+		__field(	pid_t,	pid)
+		__array(	char,	comm,	TASK_COMM_LEN )
+		__field(	 int,	oom_score_adj)
+	),
+
+	TP_fast_assign(
+		__entry->pid = task->pid;
+		memcpy(__entry->comm, task->comm, TASK_COMM_LEN);
+		__entry->oom_score_adj = task->signal->oom_score_adj;
+	),
+
+	TP_printk("pid=%d comm=%s oom_score_adj=%d",
+		__entry->pid, __entry->comm, __entry->oom_score_adj)
+);
+
+#endif
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
+
+
diff -puN /dev/null include/trace/events/task.h
--- /dev/null
+++ a/include/trace/events/task.h
@@ -0,0 +1,63 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM task
+
+#if !defined(_TRACE_TASK_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_TASK_H
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(task_newtask,
+
+	TP_PROTO(struct task_struct *task, unsigned long clone_flags),
+
+	TP_ARGS(task, clone_flags),
+
+	TP_STRUCT__entry(
+		__field(	pid_t,	pid)
+		__array(	char,	comm, TASK_COMM_LEN)
+		__field( unsigned long, clone_flags)
+		__field(	int,    oom_score_adj)
+	),
+
+	TP_fast_assign(
+		__entry->pid = task->pid;
+		memcpy(__entry->comm, task->comm, TASK_COMM_LEN);
+		__entry->clone_flags = clone_flags;
+		__entry->oom_score_adj = task->signal->oom_score_adj;
+	),
+
+	TP_printk("pid=%d comm=%s clone_flags=%lx oom_score_adj=%d",
+		__entry->pid, __entry->comm,
+		__entry->clone_flags, __entry->oom_score_adj)
+);
+
+TRACE_EVENT(task_rename,
+
+	TP_PROTO(struct task_struct *task, char *comm),
+
+	TP_ARGS(task, comm),
+
+	TP_STRUCT__entry(
+		__field(	pid_t,	pid)
+		__array(	char, oldcomm,  TASK_COMM_LEN)
+		__array(	char, newcomm,  TASK_COMM_LEN)
+		__field(	int, oom_score_adj)
+	),
+
+	TP_fast_assign(
+		__entry->pid = task->pid;
+		memcpy(entry->oldcomm, task->comm, TASK_COMM_LEN);
+		memcpy(entry->newcomm, comm, TASK_COMM_LEN);
+		__entry->oom_score_adj = task->signal->oom_score_adj;
+	),
+
+	TP_printk("pid=%d oldcomm=%s newcomm=%s oom_score_adj=%d",
+		__entry->pid, __entry->oldcomm,
+		__entry->newcomm, __entry->oom_score_adj)
+);
+
+#endif
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
+
+
diff -puN kernel/fork.c~tracepoint-add-tracepoints-for-debugging-oom_score_adj kernel/fork.c
--- a/kernel/fork.c~tracepoint-add-tracepoints-for-debugging-oom_score_adj
+++ a/kernel/fork.c
@@ -77,6 +77,9 @@
 
 #include <trace/events/sched.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/task.h>
+
 /*
  * Protected counters by write_lock_irq(&tasklist_lock)
  */
@@ -1387,6 +1390,9 @@ static struct task_struct *copy_process(
 	if (clone_flags & CLONE_THREAD)
 		threadgroup_change_end(current);
 	perf_event_fork(p);
+
+	trace_task_newtask(p, clone_flags);
+
 	return p;
 
 bad_fork_free_pid:
diff -puN mm/oom_kill.c~tracepoint-add-tracepoints-for-debugging-oom_score_adj mm/oom_kill.c
--- a/mm/oom_kill.c~tracepoint-add-tracepoints-for-debugging-oom_score_adj
+++ a/mm/oom_kill.c
@@ -33,6 +33,10 @@
 #include <linux/security.h>
 #include <linux/ptrace.h>
 #include <linux/freezer.h>
+#include <linux/ftrace.h>
+
+#define CREATE_TRACE_POINTS
+#include <trace/events/oom.h>
 
 int sysctl_panic_on_oom;
 int sysctl_oom_kill_allocating_task;
@@ -55,6 +59,7 @@ void compare_swap_oom_score_adj(int old_
 	spin_lock_irq(&sighand->siglock);
 	if (current->signal->oom_score_adj == old_val)
 		current->signal->oom_score_adj = new_val;
+	trace_oom_score_adj_update(current);
 	spin_unlock_irq(&sighand->siglock);
 }
 
@@ -74,6 +79,7 @@ int test_set_oom_score_adj(int new_val)
 	spin_lock_irq(&sighand->siglock);
 	old_val = current->signal->oom_score_adj;
 	current->signal->oom_score_adj = new_val;
+	trace_oom_score_adj_update(current);
 	spin_unlock_irq(&sighand->siglock);
 
 	return old_val;
_
Subject: Subject: tracepoint: add tracepoints for debugging oom_score_adj

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

linux-next.patch
memcg-add-mem_cgroup_replace_page_cache-to-fix-lru-issue.patch
memcg-keep-root-group-unchanged-if-creation-fails.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
mm-avoid-livelock-on-__gfp_fs-allocations-v2.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix.patch
vmscan-add-task-name-to-warn_scan_unevictable-messages.patch
mm-exclude-reserved-pages-from-dirtyable-memory.patch
mm-exclude-reserved-pages-from-dirtyable-memory-fix.patch
mm-writeback-cleanups-in-preparation-for-per-zone-dirty-limits.patch
mm-try-to-distribute-dirty-pages-fairly-across-zones.patch
mm-filemap-pass-__gfp_write-from-grab_cache_page_write_begin.patch
btrfs-pass-__gfp_write-for-buffered-write-page-allocations.patch
mm-simplify-find_vma_prev.patch
tracepoint-add-tracepoints-for-debugging-oom_score_adj.patch
mm-memcg-consolidate-hierarchy-iteration-primitives.patch
mm-vmscan-distinguish-global-reclaim-from-global-lru-scanning.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned.patch
mm-memcg-per-priority-per-zone-hierarchy-scan-generations.patch
mm-move-memcg-hierarchy-reclaim-to-generic-reclaim-code.patch
mm-memcg-remove-optimization-of-keeping-the-root_mem_cgroup-lru-lists-empty.patch
mm-vmscan-convert-global-reclaim-to-per-memcg-lru-lists.patch
mm-collect-lru-list-heads-into-struct-lruvec.patch
mm-make-per-memcg-lru-lists-exclusive.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags-fix.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient-fix.patch
mm-memcg-shorten-preempt-disabled-section-around-event-checks.patch
documentation-cgroups-memorytxt-fix-typo.patch
memcg-fix-pgpgin-pgpgout-documentation.patch
mm-oom_kill-remove-memcg-argument-from-oom_kill_task.patch
mm-unify-remaining-mem_cont-mem-etc-variable-names-to-memcg.patch
mm-memcg-clean-up-fault-accounting.patch
mm-memcg-lookup_page_cgroup-almost-never-returns-null.patch
mm-page_cgroup-check-page_cgroup-arrays-in-lookup_page_cgroup-only-when-necessary.patch
mm-memcg-remove-unneeded-checks-from-newpage_charge.patch
mm-memcg-remove-unneeded-checks-from-uncharge_page.patch
page_cgroup-add-helper-function-to-get-swap_cgroup.patch
page_cgroup-add-helper-function-to-get-swap_cgroup-cleanup.patch
memcg-clean-up-soft_limit_tree-if-allocation-fails.patch
c-r-introduce-checkpoint_restore-symbol.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix.patch

