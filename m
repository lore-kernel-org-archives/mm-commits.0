From: akpm@linux-foundation.org
Subject: + pid-fix-mips-irix-emulation-pid-usage.patch added to -mm tree
Date: Tue, 11 Dec 2007 21:09:52 -0800
Message-ID: <200712120509.lBC59qfN026722@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43602 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751597AbXLLFKN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 00:10:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, oleg@tv-sign.ru, ralf@linux-mips.org, xemul@openvz.org


The patch titled
     pid: fix mips irix emulation pid usage
has been added to the -mm tree.  Its filename is
     pid-fix-mips-irix-emulation-pid-usage.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pid: fix mips irix emulation pid usage
From: Eric W. Biederman <ebiederm@xmission.com>

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/irixelf.c |   14 +++++++-------
 arch/mips/kernel/irixsig.c |   16 ++++++++++------
 arch/mips/kernel/sysirix.c |   12 ++++++------
 3 files changed, 23 insertions(+), 19 deletions(-)

diff -puN arch/mips/kernel/irixelf.c~pid-fix-mips-irix-emulation-pid-usage arch/mips/kernel/irixelf.c
--- a/arch/mips/kernel/irixelf.c~pid-fix-mips-irix-emulation-pid-usage
+++ a/arch/mips/kernel/irixelf.c
@@ -591,9 +591,9 @@ static void irix_map_prda_page(void)
 		return;
 
 	pp = (struct prda *) v;
-	pp->prda_sys.t_pid  = current->pid;
+	pp->prda_sys.t_pid  = task_pid_vnr(current);
 	pp->prda_sys.t_prid = read_c0_prid();
-	pp->prda_sys.t_rpid = current->pid;
+	pp->prda_sys.t_rpid = task_pid_vnr(current);
 
 	/* We leave the rest set to zero */
 }
@@ -1170,11 +1170,11 @@ static int irix_core_dump(long signr, st
 	prstatus.pr_info.si_signo = prstatus.pr_cursig = signr;
 	prstatus.pr_sigpend = current->pending.signal.sig[0];
 	prstatus.pr_sighold = current->blocked.sig[0];
-	psinfo.pr_pid = prstatus.pr_pid = current->pid;
-	psinfo.pr_ppid = prstatus.pr_ppid = current->parent->pid;
-	psinfo.pr_pgrp = prstatus.pr_pgrp = task_pgrp_nr(current);
-	psinfo.pr_sid = prstatus.pr_sid = task_session_nr(current);
-	if (current->pid == current->tgid) {
+	psinfo.pr_pid = prstatus.pr_pid = task_pid_vnr(current);
+	psinfo.pr_ppid = prstatus.pr_ppid = task_pid_vnr(current->parent);
+	psinfo.pr_pgrp = prstatus.pr_pgrp = task_pgrp_vnr(current);
+	psinfo.pr_sid = prstatus.pr_sid = task_session_vnr(current);
+	if (thread_group_leader(current)) {
 		/*
 		 * This is the record for the group leader.  Add in the
 		 * cumulative times of previous dead threads.  This total
diff -puN arch/mips/kernel/irixsig.c~pid-fix-mips-irix-emulation-pid-usage arch/mips/kernel/irixsig.c
--- a/arch/mips/kernel/irixsig.c~pid-fix-mips-irix-emulation-pid-usage
+++ a/arch/mips/kernel/irixsig.c
@@ -578,10 +578,11 @@ out:
 
 #define W_MASK      (W_EXITED | W_TRAPPED | W_STOPPED | W_CONT | W_NOHANG)
 
-asmlinkage int irix_waitsys(int type, int pid,
+asmlinkage int irix_waitsys(int type, int upid,
 	struct irix5_siginfo __user *info, int options,
 	struct rusage __user *ru)
 {
+	struct pid *pid = NULL;
 	int flag, retval;
 	DECLARE_WAITQUEUE(wait, current);
 	struct task_struct *tsk;
@@ -604,6 +605,8 @@ asmlinkage int irix_waitsys(int type, in
 	if (type != IRIX_P_PID && type != IRIX_P_PGID && type != IRIX_P_ALL)
 		return -EINVAL;
 
+	if (type != IRIX_P_ALL)
+		pid = find_get_pid(upid);
 	add_wait_queue(&current->signal->wait_chldexit, &wait);
 repeat:
 	flag = 0;
@@ -612,9 +615,9 @@ repeat:
 	tsk = current;
 	list_for_each(_p, &tsk->children) {
 		p = list_entry(_p, struct task_struct, sibling);
-		if ((type == IRIX_P_PID) && p->pid != pid)
+		if ((type == IRIX_P_PID) && task_pid(p) != pid)
 			continue;
-		if ((type == IRIX_P_PGID) && task_pgrp_nr(p) != pid)
+		if ((type == IRIX_P_PGID) && task_pgrp(p) != pid)
 			continue;
 		if ((p->exit_signal != SIGCHLD))
 			continue;
@@ -639,7 +642,7 @@ repeat:
 
 			retval = __put_user(SIGCHLD, &info->sig);
 			retval |= __put_user(0, &info->code);
-			retval |= __put_user(p->pid, &info->stuff.procinfo.pid);
+			retval |= __put_user(task_pid_vnr(p), &info->stuff.procinfo.pid);
 			retval |= __put_user((p->exit_code >> 8) & 0xff,
 			           &info->stuff.procinfo.procdata.child.status);
 			retval |= __put_user(p->utime, &info->stuff.procinfo.procdata.child.utime);
@@ -657,7 +660,7 @@ repeat:
 				getrusage(p, RUSAGE_BOTH, ru);
 			retval = __put_user(SIGCHLD, &info->sig);
 			retval |= __put_user(1, &info->code);      /* CLD_EXITED */
-			retval |= __put_user(p->pid, &info->stuff.procinfo.pid);
+			retval |= __put_user(task_pid_vnr(p), &info->stuff.procinfo.pid);
 			retval |= __put_user((p->exit_code >> 8) & 0xff,
 			           &info->stuff.procinfo.procdata.child.status);
 			retval |= __put_user(p->utime,
@@ -665,7 +668,7 @@ repeat:
 			retval |= __put_user(p->stime,
 			           &info->stuff.procinfo.procdata.child.stime);
 			if (retval)
-				return retval;
+				goto end_waitsys;
 
 			if (p->real_parent != p->parent) {
 				write_lock_irq(&tasklist_lock);
@@ -698,6 +701,7 @@ repeat:
 end_waitsys:
 	current->state = TASK_RUNNING;
 	remove_wait_queue(&current->signal->wait_chldexit, &wait);
+	put_pid(pid);
 
 	return retval;
 }
diff -puN arch/mips/kernel/sysirix.c~pid-fix-mips-irix-emulation-pid-usage arch/mips/kernel/sysirix.c
--- a/arch/mips/kernel/sysirix.c~pid-fix-mips-irix-emulation-pid-usage
+++ a/arch/mips/kernel/sysirix.c
@@ -582,8 +582,8 @@ out:
 
 asmlinkage int irix_getpid(struct pt_regs *regs)
 {
-	regs->regs[3] = current->real_parent->pid;
-	return current->pid;
+	regs->regs[3] = task_pid_vnr(current->real_parent);
+	return task_pid_vnr(current);
 }
 
 asmlinkage int irix_getuid(struct pt_regs *regs)
@@ -763,11 +763,11 @@ asmlinkage int irix_setpgrp(int flags)
 	printk("[%s:%d] setpgrp(%d) ", current->comm, current->pid, flags);
 #endif
 	if(!flags)
-		error = task_pgrp_nr(current);
+		error = task_pgrp_vnr(current);
 	else
 		error = sys_setsid();
 #ifdef DEBUG_PROCGRPS
-	printk("returning %d\n", task_pgrp_nr(current));
+	printk("returning %d\n", error);
 #endif
 
 	return error;
@@ -1093,10 +1093,10 @@ asmlinkage int irix_BSDsetpgrp(int pid, 
 	       pid, pgrp);
 #endif
 	if(!pid)
-		pid = current->pid;
+		pid = task_pid_vnr(current);
 
 	/* Wheee, weird sysv thing... */
-	if ((pgrp == 0) && (pid == current->pid))
+	if ((pgrp == 0) && (pid == task_pid_vnr(current))
 		error = sys_setsid();
 	else
 		error = sys_setpgid(pid, pgrp);
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
pid-sys_wait-fixes-v2-checkpatch-fixes.patch
pid-extend-fix-pid_vnr.patch
sys_getsid-dont-use-nsproxy-directly.patch
pid-fix-mips-irix-emulation-pid-usage.patch
pid-fix-solaris_procids.patch
