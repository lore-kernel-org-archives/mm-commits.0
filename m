From: akpm@linux-foundation.org
Subject: + do_wait-fix-security-checks-fix.patch added to -mm tree
Date: Tue, 27 Nov 2007 14:50:38 -0800
Message-ID: <200711272250.lARMoca4003510@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55596 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751930AbXK0Wvi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 17:51:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, chrisw@sous-sol.org, eparis@redhat.com, jmorris@namei.org, roland@redhat.com, sds@tycho.nsa.gov


The patch titled
     do_wait-fix-security-checks-fix
has been added to the -mm tree.  Its filename is
     do_wait-fix-security-checks-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1536,16 +1536,17 @@ repeat:
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
