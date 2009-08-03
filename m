From: akpm@linux-foundation.org
Subject: + signals-send_sigio-use-do_send_sig_info-to-avoid-check_kill_permission.patch added to -mm tree
Date: Mon, 03 Aug 2009 15:37:31 -0700
Message-ID: <200908032237.n73MbWi1005650@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52572 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752989AbZHCWif (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Aug 2009 18:38:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, a.p.zijlstra@chello.nl, eranian@googlemail.com, mingo@elte.hu, roland@redhat.com


The patch titled
     signals: send_sigio: use do_send_sig_info() to avoid check_kill_permission()
has been added to the -mm tree.  Its filename is
     signals-send_sigio-use-do_send_sig_info-to-avoid-check_kill_permission.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: send_sigio: use do_send_sig_info() to avoid check_kill_permission()
From: Oleg Nesterov <oleg@redhat.com>

group_send_sig_info()->check_kill_permission() assumes that current is the
sender and uses current_cred().

This is not true in send_sigio_to_task() case.  From the security pov the
sender is not current, but the task which did fcntl(F_SETOWN), that is why
we have sigio_perm() which uses the right creds to check.

Fortunately, send_sigio() always sends either SEND_SIG_PRIV or
SI_FROMKERNEL() signal, so check_kill_permission() does nothing.  But
still it would be tidier to avoid this bogus security check and save a
couple of cycles.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: stephane eranian <eranian@googlemail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fcntl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/fcntl.c~signals-send_sigio-use-do_send_sig_info-to-avoid-check_kill_permission fs/fcntl.c
--- a/fs/fcntl.c~signals-send_sigio-use-do_send_sig_info-to-avoid-check_kill_permission
+++ a/fs/fcntl.c
@@ -461,11 +461,11 @@ static void send_sigio_to_task(struct ta
 			else
 				si.si_band = band_table[reason - POLL_IN];
 			si.si_fd    = fd;
-			if (!group_send_sig_info(signum, &si, p))
+			if (!do_send_sig_info(signum, &si, p, true))
 				break;
 		/* fall-through: fall back on the old plain SIGIO signal */
 		case 0:
-			group_send_sig_info(SIGIO, SEND_SIG_PRIV, p);
+			do_send_sig_info(SIGIO, SEND_SIG_PRIV, p, true);
 	}
 }
 
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
execve-must-clear-current-clear_child_tid-v2.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
proc_flush_task-flush-proc-tid-task-pid-when-a-sub-thread-exits.patch
ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee.patch
do_wait-wakeup-optimization-shift-security_task_wait-from-eligible_child-to-wait_consider_task.patch
do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup.patch
do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup-selinux_bprm_committed_creds-use-__wake_up_parent.patch
do_wait-wakeup-optimization-child_wait_callback-check-__wnothread-case.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch
wait_consider_task-kill-parent-argument.patch
do_wait-fix-sys_waitid-specific-behaviour.patch
wait_noreap_copyout-check-for-wo_info-=-null.patch
signals-introduce-do_send_sig_info-helper.patch
signals-send_sigio-use-do_send_sig_info-to-avoid-check_kill_permission.patch
signals-tracehook_notify_jctl-change.patch
signals-tracehook_notify_jctl-change-do_signal_stop-do-not-call-tracehook_notify_jctl-in-task_stopped-state.patch
signals-introduce-tracehook_finish_jctl-helper.patch
utrace-core.patch
exec-fix-set_binfmt-vs-sys_delete_module-race.patch
schedule_work-documentation-improvements.patch
fork-disable-clone_parent-for-init.patch
pidns-deny-clone_parentclone_newpid-combination.patch
task_struct-cleanup-move-binfmt-field-to-mm_struct.patch

