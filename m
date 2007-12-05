From: akpm@linux-foundation.org
Subject: + sys_setsid-remove-now-unneeded-session-=-1-check.patch added to -mm tree
Date: Wed, 05 Dec 2007 15:20:17 -0800
Message-ID: <200712052320.lB5NKHQi030210@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40716 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752224AbXLEXVF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Dec 2007 18:21:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, ebiederm@xmission.com, roland@redhat.com


The patch titled
     sys_setsid: remove now unneeded session != 1 check
has been added to the -mm tree.  Its filename is
     sys_setsid-remove-now-unneeded-session-=-1-check.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sys_setsid: remove now unneeded session != 1 check
From: Oleg Nesterov <oleg@tv-sign.ru>

Eric's "fix clone(CLONE_NEWPID)" eliminated the last reason for this hack.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN kernel/sys.c~sys_setsid-remove-now-unneeded-session-=-1-check kernel/sys.c
--- a/kernel/sys.c~sys_setsid-remove-now-unneeded-session-=-1-check
+++ a/kernel/sys.c
@@ -1056,11 +1056,8 @@ asmlinkage long sys_setsid(void)
 
 	/* Fail if a process group id already exists that equals the
 	 * proposed session id.
-	 *
-	 * Don't check if session == 1, clone(CLONE_NEWPID) creates
-	 * this group/session beforehand.
 	 */
-	if (session != 1 && pid_task(sid, PIDTYPE_PGID))
+	if (pid_task(sid, PIDTYPE_PGID))
 		goto out;
 
 	group_leader->signal->leader = 1;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

fix-cloneclone_newpid.patch
__group_complete_signal-fix-coredump-with-group-stop-race.patch
remove-handle_group_stop-in-favor-of-do_signal_stop.patch
exec-rework-the-group-exit-and-fix-the-race-with-kill.patch
git-sched.patch
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
fix-group-stop-with-exit-race.patch
sys_setsid-remove-now-unneeded-session-=-1-check.patch
