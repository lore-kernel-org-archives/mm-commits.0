From: akpm@linux-foundation.org
Subject: + pid_ns-kill-the-now-unused-task_child_reaper.patch added to -mm tree
Date: Wed, 27 Aug 2008 14:28:57 -0700
Message-ID: <200808272128.m7RLSvGc023427@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752549AbYH0V3r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Aug 2008 17:29:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, serue@us.ibm.com, sukadev@linux.vnet.ibm.com, xemul@openvz.org


The patch titled
     pid_ns: kill the now unused task_child_reaper()
has been added to the -mm tree.  Its filename is
     pid_ns-kill-the-now-unused-task_child_reaper.patch

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
Subject: pid_ns: kill the now unused task_child_reaper()
From: Oleg Nesterov <oleg@tv-sign.ru>

task_child_reaper() has no callers anymore, kill it.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Acked-by: Pavel Emelyanov <xemul@openvz.org>
Acked-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid_namespace.h |    6 ------
 1 file changed, 6 deletions(-)

diff -puN include/linux/pid_namespace.h~pid_ns-kill-the-now-unused-task_child_reaper include/linux/pid_namespace.h
--- a/include/linux/pid_namespace.h~pid_ns-kill-the-now-unused-task_child_reaper
+++ a/include/linux/pid_namespace.h
@@ -84,12 +84,6 @@ static inline struct pid_namespace *task
 	return tsk->nsproxy->pid_ns;
 }
 
-static inline struct task_struct *task_child_reaper(struct task_struct *tsk)
-{
-	BUG_ON(tsk != current);
-	return tsk->nsproxy->pid_ns->child_reaper;
-}
-
 void pidhash_init(void);
 void pidmap_init(void);
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

exit-signals-use-of-uninitialized-field-notify_count.patch
pid_ns-zap_pid_ns_processes-fix-the-child_reaper-changing.patch
pid_ns-bug-11391-change-child_reaper-when-init-group_leader-exits.patch
linux-next.patch
posix-timers-dont-switch-to-group_leader-if-it_process-dies.patch
posix-timers-always-do-get_task_structtimer-it_process.patch
posix-timers-sys_timer_create-remove-the-buggy-pf_exiting-check.patch
posix-timers-sys_timer_create-simplify-and-s-tasklist-rcu.patch
posix-timers-move-the-initialization-of-timer-sigq-from-send-to-create-path.patch
posix-timers-sys_timer_create-cleanup-the-error-handling.patch
posix-timers-kill-it_sigev_signo-and-it_sigev_value.patch
posix-timers-lock_timer-kill-the-bogus-it_id-check.patch
posix-timers-lock_timer-make-it-readable.patch
posix-timers-use-struct-pid-instead-of-struct-task_struct.patch
posix-timers-check-it_signal-instead-of-it_pid-to-validate-the-timer.patch
posix-timers-simplify-de_thread-exit_itimers-path.patch
make-ptrace_untrace-static.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
kthread_bind-use-wait_task_inactivetask_uninterruptible.patch
pid_ns-de_thread-kill-the-now-unneeded-child_reaper-change.patch
pid_ns-kill-the-now-unused-task_child_reaper.patch

