From: akpm@linux-foundation.org
Subject: +
 kernel-signalc-change-do_signal_stop-do_sigaction-to-use-while_each_thread.patch added to -mm tree
Date: Fri, 22 Nov 2013 14:52:59 -0800
Message-ID: <528fe04b.B410bQ+fgQfxsmf8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58198 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797Ab3KVWxA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Nov 2013 17:53:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, snanda@chromium.org, kosaki.motohiro@jp.fujitsu.com, keescook@chromium.org, oleg@redhat.com

Subject: + kernel-signalc-change-do_signal_stop-do_sigaction-to-use-while_each_thread.patch added to -mm tree
To: oleg@redhat.com,keescook@chromium.org,kosaki.motohiro@jp.fujitsu.com,snanda@chromium.org,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Fri, 22 Nov 2013 14:52:59 -0800


The patch titled
     Subject: kernel/signal.c: change do_signal_stop/do_sigaction to use while_each_thread()
has been added to the -mm tree.  Its filename is
     kernel-signalc-change-do_signal_stop-do_sigaction-to-use-while_each_thread.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-signalc-change-do_signal_stop-do_sigaction-to-use-while_each_thread.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-signalc-change-do_signal_stop-do_sigaction-to-use-while_each_thread.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: kernel/signal.c: change do_signal_stop/do_sigaction to use while_each_thread()

Change do_signal_stop() and do_sigaction() to avoid next_thread() and use
while_each_thread() instead.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Reviewed-by: Sameer Nanda <snanda@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN kernel/signal.c~kernel-signalc-change-do_signal_stop-do_sigaction-to-use-while_each_thread kernel/signal.c
--- a/kernel/signal.c~kernel-signalc-change-do_signal_stop-do_sigaction-to-use-while_each_thread
+++ a/kernel/signal.c
@@ -2047,8 +2047,8 @@ static bool do_signal_stop(int signr)
 		if (task_set_jobctl_pending(current, signr | gstop))
 			sig->group_stop_count++;
 
-		for (t = next_thread(current); t != current;
-		     t = next_thread(t)) {
+		t = current;
+		while_each_thread(current, t) {
 			/*
 			 * Setting state to TASK_STOPPED for a group
 			 * stop is always done with the siglock held,
@@ -3125,8 +3125,7 @@ int do_sigaction(int sig, struct k_sigac
 			rm_from_queue_full(&mask, &t->signal->shared_pending);
 			do {
 				rm_from_queue_full(&mask, &t->pending);
-				t = next_thread(t);
-			} while (t != current);
+			} while_each_thread(current, t);
 		}
 	}
 
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
coredump-set_dumpable-fix-the-theoretical-race-with-itself.patch
coredump-kill-mmf_dumpable-and-mmf_dump_securely.patch
coredump-make-__get_dumpable-get_dumpable-inline-kill-fs-coredumph.patch
exit_state-kill-task_is_dead.patch
proc-cleanup-simplify-get_task_state-task_state_array.patch
proc-fix-the-potential-use-after-free-in-first_tid.patch
proc-change-first_tid-to-use-while_each_thread-rather-than-next_thread.patch
proc-dont-abuse-group_leader-in-proc_task_readdir-paths.patch
proc-fix-f_pos-overflows-in-first_tid.patch
fork-no-need-to-initialize-child-exit_state.patch
exec-check_unsafe_exec-use-while_each_thread-rather-than-next_thread.patch
exec-check_unsafe_exec-kill-the-dead-eagain-and-clear_in_exec-logic.patch
exec-move-the-final-allow_write_access-fput-into-free_bprm.patch
exec-kill-task_struct-did_exec.patch
fs-proc-arrayc-change-do_task_stat-to-use-while_each_thread.patch
kernel-sysc-k_getrusage-can-use-while_each_thread.patch
kernel-signalc-change-do_signal_stop-do_sigaction-to-use-while_each_thread.patch
linux-next.patch

