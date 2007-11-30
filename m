From: akpm@linux-foundation.org
Subject: + move-daemonized-kernel-threads-into-the-swappers-session.patch added to -mm tree
Date: Thu, 29 Nov 2007 16:13:54 -0800
Message-ID: <200711300013.lAU0DsGv014483@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36595 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755563AbXK3AN6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 19:13:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, ebiederm@xmission.com, xemul@openvz.org


The patch titled
     move daemonized kernel threads into the swapper's session
has been added to the -mm tree.  Its filename is
     move-daemonized-kernel-threads-into-the-swappers-session.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: move daemonized kernel threads into the swapper's session
From: Oleg Nesterov <oleg@tv-sign.ru>

Daemonized kernel threads run in the init's session. This doesn't match the
behaviour of kthread_create()'ed threads, and this is one of the 2 reasons
why we need a special hack in sys_setsid().

Now that set_special_pids() was changed to use struct pid, not pid_t, we can
use init_struct_pid and set 0,0 special pids.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/exit.c~move-daemonized-kernel-threads-into-the-swappers-session kernel/exit.c
--- a/kernel/exit.c~move-daemonized-kernel-threads-into-the-swappers-session
+++ a/kernel/exit.c
@@ -390,7 +390,7 @@ void daemonize(const char *name, ...)
 		get_nsproxy(&init_nsproxy);
 		switch_task_namespaces(current, &init_nsproxy);
 	}
-	set_special_pids(find_pid(1));
+	set_special_pids(&init_struct_pid);
 	proc_clear_tty(current);
 
 	/* Block and flush all signals */
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
