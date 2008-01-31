From: akpm@linux-foundation.org
Subject: + pidns-make-full-use-of-xxx_vnr-calls.patch added to -mm tree
Date: Thu, 31 Jan 2008 13:56:28 -0800
Message-ID: <200801312156.m0VLuTdn013274@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37166 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760372AbYAaV5L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jan 2008 16:57:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, balbir@in.ibm.com, ebiederm@xmission.com, oleg@tv-sign.ru


The patch titled
     Pidns: make full use of xxx_vnr() calls
has been added to the -mm tree.  Its filename is
     pidns-make-full-use-of-xxx_vnr-calls.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Pidns: make full use of xxx_vnr() calls
From: Pavel Emelyanov <xemul@openvz.org>

Some time ago the xxx_vnr() calls (e.g.  pid_vnr or find_task_by_vpid) were
_all_ converted to operate on the current pid namespace.  After this each call
like xxx_nr_ns(foo, current->nsproxy->pid_ns) is nothing but a xxx_vnr(foo)
one.

Switch all the xxx_nr_ns() callers to use the xxx_vnr() calls where
appropriate.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Reviewed-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fcntl.c      |    2 +-
 fs/locks.c      |    5 ++---
 ipc/mqueue.c    |    3 +--
 kernel/exit.c   |    6 +++---
 kernel/fork.c   |    8 +-------
 kernel/sys.c    |    7 ++-----
 kernel/sysctl.c |    2 +-
 kernel/timer.c  |    2 +-
 8 files changed, 12 insertions(+), 23 deletions(-)

diff -puN fs/fcntl.c~pidns-make-full-use-of-xxx_vnr-calls fs/fcntl.c
--- a/fs/fcntl.c~pidns-make-full-use-of-xxx_vnr-calls
+++ a/fs/fcntl.c
@@ -309,7 +309,7 @@ pid_t f_getown(struct file *filp)
 {
 	pid_t pid;
 	read_lock(&filp->f_owner.lock);
-	pid = pid_nr_ns(filp->f_owner.pid, current->nsproxy->pid_ns);
+	pid = pid_vnr(filp->f_owner.pid);
 	if (filp->f_owner.pid_type == PIDTYPE_PGID)
 		pid = -pid;
 	read_unlock(&filp->f_owner.lock);
diff -puN fs/locks.c~pidns-make-full-use-of-xxx_vnr-calls fs/locks.c
--- a/fs/locks.c~pidns-make-full-use-of-xxx_vnr-calls
+++ a/fs/locks.c
@@ -685,8 +685,7 @@ posix_test_lock(struct file *filp, struc
 	if (cfl) {
 		__locks_copy_lock(fl, cfl);
 		if (cfl->fl_nspid)
-			fl->fl_pid = pid_nr_ns(cfl->fl_nspid,
-						task_active_pid_ns(current));
+			fl->fl_pid = pid_vnr(cfl->fl_nspid);
 	} else
 		fl->fl_type = F_UNLCK;
 	unlock_kernel();
@@ -2098,7 +2097,7 @@ static void lock_get_status(struct seq_f
 	unsigned int fl_pid;
 
 	if (fl->fl_nspid)
-		fl_pid = pid_nr_ns(fl->fl_nspid, task_active_pid_ns(current));
+		fl_pid = pid_vnr(fl->fl_nspid);
 	else
 		fl_pid = fl->fl_pid;
 
diff -puN ipc/mqueue.c~pidns-make-full-use-of-xxx_vnr-calls ipc/mqueue.c
--- a/ipc/mqueue.c~pidns-make-full-use-of-xxx_vnr-calls
+++ a/ipc/mqueue.c
@@ -332,8 +332,7 @@ static ssize_t mqueue_read_file(struct f
 			(info->notify_owner &&
 			 info->notify.sigev_notify == SIGEV_SIGNAL) ?
 				info->notify.sigev_signo : 0,
-			pid_nr_ns(info->notify_owner,
-				current->nsproxy->pid_ns));
+			pid_vnr(info->notify_owner));
 	spin_unlock(&info->lock);
 	buffer[sizeof(buffer)-1] = '\0';
 	slen = strlen(buffer)+1;
diff -puN kernel/exit.c~pidns-make-full-use-of-xxx_vnr-calls kernel/exit.c
--- a/kernel/exit.c~pidns-make-full-use-of-xxx_vnr-calls
+++ a/kernel/exit.c
@@ -1170,7 +1170,7 @@ static int wait_task_zombie(struct task_
 {
 	unsigned long state;
 	int retval, status, traced;
-	pid_t pid = task_pid_nr_ns(p, current->nsproxy->pid_ns);
+	pid_t pid = task_pid_vnr(p);
 
 	if (unlikely(noreap)) {
 		uid_t uid = p->uid;
@@ -1365,7 +1365,7 @@ unlock_sig:
 	 * possibly take page faults for user memory.
 	 */
 	get_task_struct(p);
-	pid = task_pid_nr_ns(p, current->nsproxy->pid_ns);
+	pid = task_pid_vnr(p);
 	why = (p->ptrace & PT_PTRACED) ? CLD_TRAPPED : CLD_STOPPED;
 	read_unlock(&tasklist_lock);
 
@@ -1424,7 +1424,7 @@ static int wait_task_continued(struct ta
 		p->signal->flags &= ~SIGNAL_STOP_CONTINUED;
 	spin_unlock_irq(&p->sighand->siglock);
 
-	pid = task_pid_nr_ns(p, current->nsproxy->pid_ns);
+	pid = task_pid_vnr(p);
 	uid = p->uid;
 	get_task_struct(p);
 	read_unlock(&tasklist_lock);
diff -puN kernel/fork.c~pidns-make-full-use-of-xxx_vnr-calls kernel/fork.c
--- a/kernel/fork.c~pidns-make-full-use-of-xxx_vnr-calls
+++ a/kernel/fork.c
@@ -1461,13 +1461,7 @@ long do_fork(unsigned long clone_flags,
 	if (!IS_ERR(p)) {
 		struct completion vfork;
 
-		/*
-		 * this is enough to call pid_nr_ns here, but this if
-		 * improves optimisation of regular fork()
-		 */
-		nr = (clone_flags & CLONE_NEWPID) ?
-			task_pid_nr_ns(p, current->nsproxy->pid_ns) :
-				task_pid_vnr(p);
+		nr = task_pid_vnr(p);
 
 		if (clone_flags & CLONE_PARENT_SETTID)
 			put_user(nr, parent_tidptr);
diff -puN kernel/sys.c~pidns-make-full-use-of-xxx_vnr-calls kernel/sys.c
--- a/kernel/sys.c~pidns-make-full-use-of-xxx_vnr-calls
+++ a/kernel/sys.c
@@ -991,17 +991,14 @@ asmlinkage long sys_getpgid(pid_t pid)
 	else {
 		int retval;
 		struct task_struct *p;
-		struct pid_namespace *ns;
-
-		ns = current->nsproxy->pid_ns;
 
 		read_lock(&tasklist_lock);
-		p = find_task_by_pid_ns(pid, ns);
+		p = find_task_by_vpid(pid);
 		retval = -ESRCH;
 		if (p) {
 			retval = security_task_getpgid(p);
 			if (!retval)
-				retval = task_pgrp_nr_ns(p, ns);
+				retval = task_pgrp_vnr(p);
 		}
 		read_unlock(&tasklist_lock);
 		return retval;
diff -puN kernel/sysctl.c~pidns-make-full-use-of-xxx_vnr-calls kernel/sysctl.c
--- a/kernel/sysctl.c~pidns-make-full-use-of-xxx_vnr-calls
+++ a/kernel/sysctl.c
@@ -2492,7 +2492,7 @@ static int proc_do_cad_pid(struct ctl_ta
 	pid_t tmp;
 	int r;
 
-	tmp = pid_nr_ns(cad_pid, current->nsproxy->pid_ns);
+	tmp = pid_vnr(cad_pid);
 
 	r = __do_proc_dointvec(&tmp, table, write, filp, buffer,
 			       lenp, ppos, NULL, NULL);
diff -puN kernel/timer.c~pidns-make-full-use-of-xxx_vnr-calls kernel/timer.c
--- a/kernel/timer.c~pidns-make-full-use-of-xxx_vnr-calls
+++ a/kernel/timer.c
@@ -979,7 +979,7 @@ asmlinkage long sys_getppid(void)
 	int pid;
 
 	rcu_read_lock();
-	pid = task_tgid_nr_ns(current->real_parent, current->nsproxy->pid_ns);
+	pid = task_tgid_vnr(current->real_parent);
 	rcu_read_unlock();
 
 	return pid;
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
use-find_task_by_vpid-in-audit-code.patch
gfs2-make-gfs2_glockgl_owner_pid-be-a-struct-pid.patch
gfs2-make-gfs2_holdergh_owner_pid-be-a-struct-pid.patch
ia64-make-pfm_get_task-work-with-virtual-pids.patch
ia64-fix-ptrace-inside-a-namespace.patch
mips-use-find_task_by_vpid-in-system-calls.patch
git-net.patch
shmem-factor-out-sbi-free_inodes-manipulations.patch
shmem-factor-out-sbi-free_inodes-manipulations-fix.patch
frv-use-find_task_by_vpid-in-cxn_pin_by_pid.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
memcgroup-reinstate-swapoff-mod.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages-fix.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch
memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch
memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-memorystat-file.patch
memory-cgroup-enhancements-add-pre_destroy-handler.patch
memory-cgroup-enhancements-implicit-force_empty-at-rmdir.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-add-scan_global_lru-macro.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-nid-zid-helper-function-for-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-active-inactive-counter.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-mapper_ratio-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-active-inactive-imbalance-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-the-number-of-pages-to-be-scanned-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lock-for-cgroup.patch
handle-pid-namespaces-in-cgroups-code.patch
add-the-namespaces-config-option.patch
move-the-uts-namespace-under-uts_ns-option.patch
move-the-ipc-namespace-under-ipc_ns-option.patch
cleanup-the-code-managed-with-the-user_ns-option.patch
cleanup-the-code-managed-with-the-user_ns-option-checkpatch-fixes.patch
cleanup-the-code-managed-with-pid_ns-option.patch
cleanup-the-code-managed-with-pid_ns-option-checkpatch-fixes.patch
mark-net_ns-with-depends-on-namespaces.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
proc-proper-pidns-handling-for-proc-self.patch
proc-fix-the-threaded-proc-self.patch
ipc-uninline-some-code-from-utilh.patch
ipc-make-struct-ipc_ids-static-in-ipc_namespace.patch
ipc-consolidate-sem_exit_ns-msg_exit_ns-and-shm_exit_ns.patch
sys_setpgid-simplify-pid-ns-interaction.patch
fix-setsid-for-sub-namespace-sbin-init.patch
teach-set_special_pids-to-use-struct-pid.patch
move-daemonized-kernel-threads-into-the-swappers-session.patch
start-the-global-sbin-init-with-00-special-pids.patch
pid-sys_wait-fixes-v2.patch
pid-extend-fix-pid_vnr.patch
sys_getsid-dont-use-nsproxy-directly.patch
pid-fix-mips-irix-emulation-pid-usage.patch
pid-fix-mips-irix-emulation-pid-usage-fix.patch
pid-fix-solaris_procids.patch
uglify-kill_pid_info-to-fix-kill-vs-exec-race.patch
uglify-while_each_pid_task-to-make-sure-we-dont-count-the-execing-pricess-twice.patch
itimer_real-convert-to-use-struct-pid.patch
pidns-make-full-use-of-xxx_vnr-calls.patch
pidns-fix-badly-converted-mqueues-pid-handling.patch
clean-up-the-kill_something_info.patch
get-rid-of-the-kill_pgrp_info-function.patch
use-find_task_by_vpid-in-posix-timers.patch
use-find_task_by_vpid-in-taskstats.patch
dont-operate-with-pid_t-in-rtmutex-tester.patch
deprecate-find_task_by_pid.patch
reiser4.patch
