From: akpm@linux-foundation.org
Subject: + pid_ns-zap_pid_ns_processes-fix-the-child_reaper-changing.patch added to -mm tree
Date: Wed, 27 Aug 2008 14:25:22 -0700
Message-ID: <200808272125.m7RLPMj4023301@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751475AbYH0V0d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Aug 2008 17:26:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, serue@us.ibm.com, sukadev@linux.vnet.ibm.com, xemul@openvz.org


The patch titled
     pid_ns: zap_pid_ns_processes: fix the ->child_reaper changing
has been added to the -mm tree.  Its filename is
     pid_ns-zap_pid_ns_processes-fix-the-child_reaper-changing.patch

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
Subject: pid_ns: zap_pid_ns_processes: fix the ->child_reaper changing
From: Oleg Nesterov <oleg@tv-sign.ru>

zap_pid_ns_processes() sets pid_ns->child_reaper = NULL, this is wrong.

Yes, we have already killed all tasks in this namespace, and sys_wait4()
doesn't see any child.  But this doesn't mean ->children list is empty, we
may have EXIT_DEAD tasks which are not visible to do_wait().  In that case
the subsequent forget_original_parent() will crash the kernel because it
will try to re-parent these tasks to the NULL reaper.

Even if there are no childs, it is not good that forget_original_parent()
uses reaper == NULL.

Change the code to set ->child_reaper = init_pid_ns.child_reaper instead. 
We could use pid_ns->parent->child_reaper as well, I think this does not
really matter.  These EXIT_DEAD tasks are not visible to the new ->parent
after re-parenting, they will silently do release_task() eventually.

Note that we must change ->child_reaper, otherwise
forget_original_parent() will use reaper == father, and in that case we
will hit the (correct) BUG_ON(!list_empty(&father->children)).

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Acked-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid_namespace.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN kernel/pid_namespace.c~pid_ns-zap_pid_ns_processes-fix-the-child_reaper-changing kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~pid_ns-zap_pid_ns_processes-fix-the-child_reaper-changing
+++ a/kernel/pid_namespace.c
@@ -179,9 +179,12 @@ void zap_pid_ns_processes(struct pid_nam
 		rc = sys_wait4(-1, NULL, __WALL, NULL);
 	} while (rc != -ECHILD);
 
-
-	/* Child reaper for the pid namespace is going away */
-	pid_ns->child_reaper = NULL;
+	/*
+	 * We can not clear ->child_reaper or leave it alone.
+	 * There may by stealth EXIT_DEAD tasks on ->children,
+	 * forget_original_parent() must move them somewhere.
+	 */
+	pid_ns->child_reaper = init_pid_ns.child_reaper;
 	acct_exit_ns(pid_ns);
 	return;
 }
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

exit-signals-use-of-uninitialized-field-notify_count.patch
pid_ns-zap_pid_ns_processes-fix-the-child_reaper-changing.patch
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

