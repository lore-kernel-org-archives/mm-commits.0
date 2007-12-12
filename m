From: akpm@linux-foundation.org
Subject: + pid-extend-fix-pid_vnr.patch added to -mm tree
Date: Tue, 11 Dec 2007 21:05:19 -0800
Message-ID: <200712120505.lBC55J84026561@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33317 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751096AbXLLFFW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 00:05:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com


The patch titled
     pid: Extend/Fix pid_vnr
has been added to the -mm tree.  Its filename is
     pid-extend-fix-pid_vnr.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pid: Extend/Fix pid_vnr
From: Eric W. Biederman <ebiederm@xmission.com>

pid_vnr returns the user space pid with respect to the pid namespace the
struct pid was allocated in.  What we want before we return a pid to user
space is the user space pid with respect to the pid namespace of current.

pid_vnr is a very nice optimization but because it isn't quite what we want
it is easy to use pid_vnr at times when we aren't certain the struct pid
was allocated in our pid namespace.

Currently this describes at least tiocgpgrp and tiocgsid in ttyio.c the
parent process reported in the core dumps and the parent process in
get_signal_to_deliver.

So unless the performance impact is huge having an interface that does what
we want instead of always what we want should be much more reliable and
much less error prone.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid.h   |   14 +++-----------
 include/linux/sched.h |    5 ++---
 kernel/pid.c          |    6 ++++++
 3 files changed, 11 insertions(+), 14 deletions(-)

diff -puN include/linux/pid.h~pid-extend-fix-pid_vnr include/linux/pid.h
--- a/include/linux/pid.h~pid-extend-fix-pid_vnr
+++ a/include/linux/pid.h
@@ -127,9 +127,8 @@ extern void FASTCALL(free_pid(struct pid
  * the helpers to get the pid's id seen from different namespaces
  *
  * pid_nr()    : global id, i.e. the id seen from the init namespace;
- * pid_vnr()   : virtual id, i.e. the id seen from the namespace this pid
- *               belongs to. this only makes sence when called in the
- *               context of the task that belongs to the same namespace;
+ * pid_vnr()   : virtual id, i.e. the id seen from the pid namespace of
+ *               current.
  * pid_nr_ns() : id seen from the ns specified.
  *
  * see also task_xid_nr() etc in include/linux/sched.h
@@ -144,14 +143,7 @@ static inline pid_t pid_nr(struct pid *p
 }
 
 pid_t pid_nr_ns(struct pid *pid, struct pid_namespace *ns);
-
-static inline pid_t pid_vnr(struct pid *pid)
-{
-	pid_t nr = 0;
-	if (pid)
-		nr = pid->numbers[pid->level].nr;
-	return nr;
-}
+pid_t pid_vnr(struct pid *pid);
 
 #define do_each_pid_task(pid, type, task)				\
 	do {								\
diff -puN include/linux/sched.h~pid-extend-fix-pid_vnr include/linux/sched.h
--- a/include/linux/sched.h~pid-extend-fix-pid_vnr
+++ a/include/linux/sched.h
@@ -1298,9 +1298,8 @@ struct pid_namespace;
  * from various namespaces
  *
  * task_xid_nr()     : global id, i.e. the id seen from the init namespace;
- * task_xid_vnr()    : virtual id, i.e. the id seen from the namespace the task
- *                     belongs to. this only makes sence when called in the
- *                     context of the task that belongs to the same namespace;
+ * task_xid_vnr()    : virtual id, i.e. the id seen from the pid namespace of
+ *                     current.
  * task_xid_nr_ns()  : id seen from the ns specified;
  *
  * set_task_vxid()   : assigns a virtual id to a task;
diff -puN kernel/pid.c~pid-extend-fix-pid_vnr kernel/pid.c
--- a/kernel/pid.c~pid-extend-fix-pid_vnr
+++ a/kernel/pid.c
@@ -442,6 +442,12 @@ pid_t pid_nr_ns(struct pid *pid, struct 
 	return nr;
 }
 
+pid_t pid_vnr(struct pid *pid)
+{
+	return pid_nr_ns(pid, current->nsproxy->pid_ns);
+}
+EXPORT_SYMBOL_GPL(pid_vnr);
+
 pid_t task_pid_nr_ns(struct task_struct *tsk, struct pid_namespace *ns)
 {
 	return pid_nr_ns(task_pid(tsk), ns);
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
pid-sys_wait-fixes-v2-checkpatch-fixes.patch
