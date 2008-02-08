From: akpm@linux-foundation.org
Subject: - do_wait-fix-security-checks-fix.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:38:56 -0800
Message-ID: <200802080838.m188cb6M015918@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42009 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753957AbYBHIkJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:40:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, chrisw@sous-sol.org, eparis@redhat.com, jmorris@namei.org, roland@redhat.com, sds@tycho.nsa.gov, mm-commits@vger.kernel.org


The patch titled
     do_wait-fix-security-checks-fix
has been removed from the -mm tree.  Its filename was
     do_wait-fix-security-checks-fix.patch

This patch was dropped because it was folded into do_wait-fix-security-checks.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: do_wait-fix-security-checks-fix
From: Oleg Nesterov <oleg@tv-sign.ru>

On 11/24, Oleg Nesterov wrote:
>
> -		if (!flag) {
> +		if (flag)
> +			continue;

This "last obvious cleanup right before sending the patch" is terribly wrong,
we can't continue, we must advance the tsk to the next_thread().

Cc: Roland McGrath <roland@redhat.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Eric Paris <eparis@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff -puN kernel/exit.c~do_wait-fix-security-checks-fix kernel/exit.c
--- a/kernel/exit.c~do_wait-fix-security-checks-fix
+++ a/kernel/exit.c
@@ -1535,16 +1535,17 @@ repeat:
 			if (retval != 0) /* tasklist_lock released */
 				goto end;
 		}
-		if (flag)
-			continue;
-		list_for_each_entry(p, &tsk->ptrace_children, ptrace_list) {
-			flag = eligible_child(pid, options, p);
-			if (!flag)
-				continue;
-			if (likely(flag > 0))
-				break;
-			retval = flag;
-			goto end;
+		if (!flag) {
+			list_for_each_entry(p, &tsk->ptrace_children,
+								ptrace_list) {
+				flag = eligible_child(pid, options, p);
+				if (!flag)
+					continue;
+				if (likely(flag > 0))
+					break;
+				retval = flag;
+				goto end;
+			}
 		}
 		if (options & __WNOTHREAD)
 			break;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
proc-implement-proc_single_file_operations.patch
proc-rewrite-do_task_stat-to-correctly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_statm.patch
proc-proper-pidns-handling-for-proc-self.patch
proc-fix-the-threaded-proc-self.patch
proc-fix-openless-usage-due-to-proc_fops-flip.patch
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
pid-fix-mips-irix-emulation-pid-usage-fix.patch
pid-fix-solaris_procids.patch
uglify-kill_pid_info-to-fix-kill-vs-exec-race.patch
uglify-while_each_pid_task-to-make-sure-we-dont-count-the-execing-pricess-twice.patch
itimer_real-convert-to-use-struct-pid.patch
pidns-make-full-use-of-xxx_vnr-calls.patch
pidns-fix-badly-converted-mqueues-pid-handling.patch
clean-up-the-kill_something_info.patch
get-rid-of-the-kill_pgrp_info-function.patch
