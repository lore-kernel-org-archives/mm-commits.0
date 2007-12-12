From: akpm@linux-foundation.org
Subject: + pid-sys_wait-fixes-v2.patch added to -mm tree
Date: Tue, 11 Dec 2007 21:04:07 -0800
Message-ID: <200712120504.lBC5476E026545@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53624 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751429AbXLLFET (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 00:04:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, oleg@tv-sign.ru, xemul@openvz.org


The patch titled
     pid: sys_wait... fixes
has been added to the -mm tree.  Its filename is
     pid-sys_wait-fixes-v2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pid: sys_wait... fixes
From: Eric W. Biederman <ebiederm@xmission.com>

This modifies do_wait and eligible child to take a pair of enum pid_type
and struct pid *pid to precisely specify what set of processes are eligible
to be waited for, instead of the raw pid_t value from sys_wait4.

This fixes a bug in sys_waitid where you could not wait for children in
just process group 1.

This fixes a pid namespace crossing case in eligible_child.  Allowing us to
wait for a processes in our current process group even if our current
process group == 0.

This allows the no child with this pid case to be optimized.  This allows
us to optimize the pid membership test in eligible child to be optimized.

This even closes a theoretical pid wraparound race where in a threaded
parent if two threads are waiting for the same child and one thread picks
up the child and the pid numbers wrap around and generate another child
with that same pid before the other thread is scheduled (teribly insanely
unlikely) we could end up waiting on the second child with the same pid#
and not discover that the specific child we were waiting for has exited.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Oleg Nesterov <oleg@tv-sign.ru>
Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   82 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 58 insertions(+), 24 deletions(-)

diff -puN kernel/exit.c~pid-sys_wait-fixes-v2 kernel/exit.c
--- a/kernel/exit.c~pid-sys_wait-fixes-v2
+++ a/kernel/exit.c
@@ -1086,20 +1086,23 @@ asmlinkage void sys_exit_group(int error
 	do_group_exit((error_code & 0xff) << 8);
 }
 
-static int eligible_child(pid_t pid, int options, struct task_struct *p)
+static struct pid *task_pid_type(struct task_struct *task, enum pid_type type)
+{
+	struct pid *pid = NULL;
+	if (type == PIDTYPE_PID)
+		pid = task->pids[type].pid;
+	else if (type < PIDTYPE_MAX)
+		pid = task->group_leader->pids[type].pid;
+	return pid;
+}
+
+static int eligible_child(enum pid_type type, struct pid *pid, int options,
+			  struct task_struct *p)
 {
 	int err;
-	struct pid_namespace *ns;
 
-	ns = current->nsproxy->pid_ns;
-	if (pid > 0) {
-		if (task_pid_nr_ns(p, ns) != pid)
-			return 0;
-	} else if (!pid) {
-		if (task_pgrp_nr_ns(p, ns) != task_pgrp_vnr(current))
-			return 0;
-	} else if (pid != -1) {
-		if (task_pgrp_nr_ns(p, ns) != -pid)
+	if (type < PIDTYPE_MAX) {
+		if (task_pid_type(p, type) != pid)
 			return 0;
 	}
 
@@ -1123,7 +1126,7 @@ static int eligible_child(pid_t pid, int
 	if (likely(!err))
 		return 1;
 
-	if (pid <= 0)
+	if (type != PIDTYPE_PID)
 		return 0;
 	/* This child was explicitly requested, abort */
 	read_unlock(&tasklist_lock);
@@ -1443,8 +1446,9 @@ static int wait_task_continued(struct ta
 	return retval;
 }
 
-static long do_wait(pid_t pid, int options, struct siginfo __user *infop,
-		    int __user *stat_addr, struct rusage __user *ru)
+static long do_wait(enum pid_type type, struct pid *pid, int options,
+		    struct siginfo __user *infop, int __user *stat_addr,
+		    struct rusage __user *ru)
 {
 	DECLARE_WAITQUEUE(wait, current);
 	struct task_struct *tsk;
@@ -1452,6 +1456,11 @@ static long do_wait(pid_t pid, int optio
 
 	add_wait_queue(&current->signal->wait_chldexit,&wait);
 repeat:
+	/* If there is nothing that can match our critier just get out */
+	retval = -ECHILD;
+	if ((type < PIDTYPE_MAX) && (!pid || hlist_empty(&pid->tasks[type])))
+		goto end;
+
 	/*
 	 * We will set this flag if we see any child that might later
 	 * match our criteria, even if we are not able to reap it yet.
@@ -1464,7 +1473,7 @@ repeat:
 		struct task_struct *p;
 
 		list_for_each_entry(p, &tsk->children, sibling) {
-			int ret = eligible_child(pid, options, p);
+			int ret = eligible_child(type, pid, options, p);
 			if (!ret)
 				continue;
 
@@ -1511,7 +1520,7 @@ repeat:
 		if (!flag) {
 			list_for_each_entry(p, &tsk->ptrace_children,
 								ptrace_list) {
-				flag = eligible_child(pid, options, p);
+				flag = eligible_child(type, pid, options, p);
 				if (!flag)
 					continue;
 				if (likely(flag > 0))
@@ -1566,10 +1575,12 @@ end:
 	return retval;
 }
 
-asmlinkage long sys_waitid(int which, pid_t pid,
+asmlinkage long sys_waitid(int which, pid_t upid,
 			   struct siginfo __user *infop, int options,
 			   struct rusage __user *ru)
 {
+	struct pid *pid = NULL;
+	enum pid_type type;
 	long ret;
 
 	if (options & ~(WNOHANG|WNOWAIT|WEXITED|WSTOPPED|WCONTINUED))
@@ -1579,37 +1590,60 @@ asmlinkage long sys_waitid(int which, pi
 
 	switch (which) {
 	case P_ALL:
-		pid = -1;
+		type = PIDTYPE_MAX;
 		break;
 	case P_PID:
-		if (pid <= 0)
+		type = PIDTYPE_PID;
+		if (upid <= 0)
 			return -EINVAL;
 		break;
 	case P_PGID:
-		if (pid <= 0)
+		type = PIDTYPE_PGID;
+		if (upid <= 0)
 			return -EINVAL;
-		pid = -pid;
 		break;
 	default:
 		return -EINVAL;
 	}
 
-	ret = do_wait(pid, options, infop, NULL, ru);
+	if (type < PIDTYPE_MAX)
+		pid = find_get_pid(upid);
+	ret = do_wait(type, pid, options, infop, NULL, ru);
+	put_pid(pid);
 
 	/* avoid REGPARM breakage on x86: */
 	prevent_tail_call(ret);
 	return ret;
 }
 
-asmlinkage long sys_wait4(pid_t pid, int __user *stat_addr,
+asmlinkage long sys_wait4(pid_t upid, int __user *stat_addr,
 			  int options, struct rusage __user *ru)
 {
+	struct pid *pid = NULL;
+	enum pid_type type;
 	long ret;
 
 	if (options & ~(WNOHANG|WUNTRACED|WCONTINUED|
 			__WNOTHREAD|__WCLONE|__WALL))
 		return -EINVAL;
-	ret = do_wait(pid, options | WEXITED, NULL, stat_addr, ru);
+
+	if (upid == -1)
+		type = PIDTYPE_MAX;
+	else if (upid < 0) {
+		type = PIDTYPE_PGID;
+		pid = find_get_pid(-upid);
+	}
+	else if (upid == 0) {
+		type = PIDTYPE_PGID;
+		pid = get_pid(task_pgrp(current));
+	}
+	else /* upid > 0 */ {
+		type= PIDTYPE_PID;
+		pid = find_get_pid(upid);
+	}
+
+	ret = do_wait(type, pid, options | WEXITED, NULL, stat_addr, ru);
+	put_pid(pid);
 
 	/* avoid REGPARM breakage on x86: */
 	prevent_tail_call(ret);
_

Patches currently in -mm which might be from ebiederm@xmission.com are

git-net.patch
quirk-enable-msi-mapping-on-ht1000.patch
quirk-enable-msi-mapping-on-ht1000-v2.patch
git-x86.patch
fix-proc-dcache-deadlock-in-do_exit.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-memcgroup-fix-try_to_free-order.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
memcgroup-reinstate-swapoff-mod.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages-fix.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch
memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch
memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-checkpatch-fixes.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-1.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-uninlining.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-2.patch
memory-cgroup-enhancements-add-memorystat-file.patch
memory-cgroup-enhancements-add-memorystat-file-checkpatch-fixes.patch
memory-cgroup-enhancements-add-memorystat-file-printk-fix.patch
memory-cgroup-enhancements-add-pre_destroy-handler.patch
memory-cgroup-enhancements-implicit-force_empty-at-rmdir.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-add-scan_global_lru-macro.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-nid-zid-helper-function-for-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-active-inactive-counter.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-mapper_ratio-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-active-inactive-imbalance-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup-fix.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup-fix-2.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-the-number-of-pages-to-be-scanned-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity-fix.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lock-for-cgroup.patch
introduce-flags-for-reserve_bootmem.patch
use-bootmem_exclusive-for-kdump.patch
iget-stop-procfs-from-using-iget-and-read_inode.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
add-the-namespaces-config-option.patch
move-the-uts-namespace-under-uts_ns-option.patch
move-the-ipc-namespace-under-ipc_ns-option.patch
cleanup-the-code-managed-with-the-user_ns-option.patch
cleanup-the-code-managed-with-pid_ns-option.patch
mark-net_ns-with-depends-on-namespaces.patch
proc-implement-proc_single_file_operations.patch
proc-rewrite-do_task_stat-to-correctly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_statm.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-2.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-3.patch
proc-proper-pidns-handling-for-proc-self.patch
proc-fix-the-threaded-proc-self.patch
sys_setpgid-simplify-pid-ns-interaction.patch
fix-setsid-for-sub-namespace-sbin-init.patch
teach-set_special_pids-to-use-struct-pid.patch
move-daemonized-kernel-threads-into-the-swappers-session.patch
start-the-global-sbin-init-with-00-special-pids.patch
sys_setsid-remove-now-unneeded-session-=-1-check.patch
pid-sys_wait-fixes-v2.patch
pid-extend-fix-pid_vnr.patch
