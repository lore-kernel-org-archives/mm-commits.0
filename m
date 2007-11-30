From: akpm@linux-foundation.org
Subject: + start-the-global-sbin-init-with-00-special-pids.patch added to -mm tree
Date: Thu, 29 Nov 2007 16:13:57 -0800
Message-ID: <200711300013.lAU0DwW4014486@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50120 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763785AbXK3AOB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 19:14:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, ebiederm@xmission.com, xemul@openvz.org


The patch titled
     start the global /sbin/init with 0,0 special pids
has been added to the -mm tree.  Its filename is
     start-the-global-sbin-init-with-00-special-pids.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: start the global /sbin/init with 0,0 special pids
From: Oleg Nesterov <oleg@tv-sign.ru>

As Eric pointed out, there is no problem with init starting with sid == pgid
== 0, and this was historical linux behavior changed in 2.6.18.

Remove kernel_init()->__set_special_pids(), this is unneeded and complicates
the rules for sys_setsid().

This change and the previous change in daemonize() mean that /sbin/init does
not need the special "session != 1" hack in sys_setsid() any longer. We can't
remove this check yet, we should cleanup copy_process(CLONE_NEWPID) first, so
update the comment only.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c  |    1 -
 kernel/sys.c |    9 ++++-----
 2 files changed, 4 insertions(+), 6 deletions(-)

diff -puN init/main.c~start-the-global-sbin-init-with-00-special-pids init/main.c
--- a/init/main.c~start-the-global-sbin-init-with-00-special-pids
+++ a/init/main.c
@@ -830,7 +830,6 @@ static int __init kernel_init(void * unu
 	 */
 	init_pid_ns.child_reaper = current;
 
-	__set_special_pids(task_pid(current));
 	cad_pid = task_pid(current);
 
 	smp_prepare_cpus(max_cpus);
diff -puN kernel/sys.c~start-the-global-sbin-init-with-00-special-pids kernel/sys.c
--- a/kernel/sys.c~start-the-global-sbin-init-with-00-special-pids
+++ a/kernel/sys.c
@@ -1054,12 +1054,11 @@ asmlinkage long sys_setsid(void)
 	if (group_leader->signal->leader)
 		goto out;
 
-	/* Fail if a process group id already exists that equals the proposed
-	 * session id.
+	/* Fail if a process group id already exists that equals the
+	 * proposed session id.
 	 *
-	 * Don't check if session == 1 because kernel threads and CLONE_NEWPID
-	 * tasks use this session id and so the check will always fail and make
-	 * it so init cannot successfully call setsid.
+	 * Don't check if session == 1, clone(CLONE_NEWPID) creates
+	 * this group/session beforehand.
 	 */
 	if (session != 1 && pid_task(sid, PIDTYPE_PGID))
 		goto out;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

wait_task_stopped-dont-use-task_pid_nr_ns-lockless.patch
proc-remove-races-from-proc_id_readdir.patch
wait_task_stopped-pass-correct-exit_code-to.patch
use-__set_task_state-for-traced-stopped-tasks.patch
add-task_wakekill.patch
do_wait-remove-one-else-if-branch.patch
proc-implement-proc_single_file_operations.patch
proc-rewrite-do_task_stat-to-correctly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_statm.patch
proc-proper-pidns-handling-for-proc-self.patch
proc-fix-the-threaded-proc-self.patch
kill-pt_attached.patch
kill-my_ptrace_child.patch
ptrace_check_attach-remove-unneeded-signal-=-null-check.patch
ptrace_stop-fix-the-race-with-ptrace-detachattach.patch
wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace.patch
do_wait-factor-out-retval-=-0-checks.patch
ptrace_stop-fix-racy-nonstop_code-setting.patch
wait_task_stopped-remove-unneeded-delay_group_leader-check.patch
do_wait-cleanup-delay_group_leader-usage.patch
do_wait-fix-security-checks.patch
do_wait-fix-security-checks-fix.patch
wait_task_continued-zombie-dont-use-task_pid_nr_ns-lockless.patch
wait_task_zombie-remove-exit_state-exit_signal-checks-for-wnowait.patch
sys_setpgid-simplify-pid-ns-interaction.patch
fix-setsid-for-sub-namespace-sbin-init.patch
teach-set_special_pids-to-use-struct-pid.patch
move-daemonized-kernel-threads-into-the-swappers-session.patch
start-the-global-sbin-init-with-00-special-pids.patch
