From: akpm@linux-foundation.org
Subject: + uglify-while_each_pid_task-to-make-sure-we-dont-count-the-execing-pricess-twice.patch added to -mm tree
Date: Tue, 11 Dec 2007 21:12:13 -0800
Message-ID: <200712120512.lBC5CDGh026833@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43692 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752317AbXLLFNC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 00:13:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, davidel@xmailserver.org, ebiederm@xmission.com, roland@redhat.com, xemul@openvz.org


The patch titled
     uglify while_each_pid_task() to make sure we don't count the execing pricess twice
has been added to the -mm tree.  Its filename is
     uglify-while_each_pid_task-to-make-sure-we-dont-count-the-execing-pricess-twice.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uglify while_each_pid_task() to make sure we don't count the execing pricess twice
From: Oleg Nesterov <oleg@tv-sign.ru>

There is a window when de_thread() switches the leader and drops
tasklist_lock.  In that window do_each_pid_task(PIDTYPE_PID) finds both new
and old leaders.

The problem is pretty much theoretical and probably can be ignored.  Currently
the only users of do_each_pid_task(PIDTYPE_PID) are send_sigio/send_sigurg, so
they can send the signal to the same process twice.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN include/linux/pid.h~uglify-while_each_pid_task-to-make-sure-we-dont-count-the-execing-pricess-twice include/linux/pid.h
--- a/include/linux/pid.h~uglify-while_each_pid_task-to-make-sure-we-dont-count-the-execing-pricess-twice
+++ a/include/linux/pid.h
@@ -152,7 +152,13 @@ pid_t pid_vnr(struct pid *pid);
 			hlist_for_each_entry_rcu((task), pos___,	\
 				&pid->tasks[type], pids[type].node) {
 
+			/*
+			 * Both old and new leaders may be attached to
+			 * the same pid in the middle of de_thread().
+			 */
 #define while_each_pid_task(pid, type, task)				\
+				if (type == PIDTYPE_PID)		\
+					break;				\
 			}						\
 	} while (0)
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

__group_complete_signal-fix-coredump-with-group-stop-race.patch
remove-handle_group_stop-in-favor-of-do_signal_stop.patch
exec-rework-the-group-exit-and-fix-the-race-with-kill.patch
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
move-the-related-code-from-exit_notify-to-exit_signals.patch
pid-sys_wait-fixes-v2.patch
pid-extend-fix-pid_vnr.patch
sys_getsid-dont-use-nsproxy-directly.patch
pid-fix-mips-irix-emulation-pid-usage.patch
pid-fix-solaris_procids.patch
uglify-kill_pid_info-to-fix-kill-vs-exec-race.patch
uglify-while_each_pid_task-to-make-sure-we-dont-count-the-execing-pricess-twice.patch
