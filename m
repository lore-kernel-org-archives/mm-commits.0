From: akpm@linux-foundation.org
Subject: + ptrace-give-more-respect-to-sigkill.patch added to -mm tree
Date: Mon, 30 Jun 2008 16:27:01 -0700
Message-ID: <200806302327.m5UNR2nO030953@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59515 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753328AbYF3X1t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 19:27:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, matthew@wil.cx, mingo@elte.hu, roland@redhat.com


The patch titled
     ptrace: give more respect to SIGKILL
has been added to the -mm tree.  Its filename is
     ptrace-give-more-respect-to-sigkill.patch

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
Subject: ptrace: give more respect to SIGKILL
From: Oleg Nesterov <oleg@tv-sign.ru>

ptrace_stop() has some complicated checks to prevent the scheduling in the
TASK_TRACED state with the pending SIGKILL, but these checks are racy, and
they depend on arch_ptrace_stop_needed().

This patch assumes that the traced task should die asap if it was killed by
SIGKILL, in that case schedule()->signal_pending_state() has no reason to
ignore the TASK_WAKEKILL part of TASK_TRACED, and we can kill this nasty
special case.

Note: do_exit()->ptrace_notify() is special, the killed task can already
dequeue SIGKILL at this point. Another indication that fatal_signal_pending()
is not exactly right.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN include/linux/sched.h~ptrace-give-more-respect-to-sigkill include/linux/sched.h
--- a/include/linux/sched.h~ptrace-give-more-respect-to-sigkill
+++ a/include/linux/sched.h
@@ -2039,9 +2039,6 @@ static inline int signal_pending_state(l
 	if (!signal_pending(p))
 		return 0;
 
-	if (state & (__TASK_STOPPED | __TASK_TRACED))
-		return 0;
-
 	return (state & TASK_INTERRUPTIBLE) || __fatal_signal_pending(p);
 }
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

get_user_pages-fix-possible-page-leak-on-oom.patch
introduce-pf_kthread-flag.patch
kill-pf_borrowed_mm-in-favour-of-pf_kthread.patch
coredump-zap_threads-must-skip-kernel-threads.patch
posix-timers-timer_delete-remove-the-bogus-it_process-=-null-check.patch
posix-timers-release_posix_timer-kill-the-bogus-put_task_struct-it_process.patch
signals-collect_signal-remove-the-unneeded-sigismember-check.patch
signals-collect_signal-simplify-the-still_pending-logic.patch
signals-change-collect_signal-to-return-void.patch
__exit_signal-dont-take-rcu-lock.patch
signals-dequeue_signal-dont-check-signal_group_exit-when-setting-signal_stop_dequeued.patch
signals-do_signal_stop-kill-the-signal_unkillable-check.patch
coredump-zap_threads-comments-use-while_each_thread.patch
signals-make-siginfo_t-si_utime-si_sstime-report-times-in-user_hz-not-hz.patch
kernel-signalc-change-vars-pid-and-tgid-types-to-pid_t.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
ptrace-give-more-respect-to-sigkill.patch
ptrace-never-sleep-in-task_traced-if-sigkilled.patch
ptrace-kill-may_ptrace_stop.patch
pidns-remove-now-unused-kill_proc-function.patch
pidns-remove-now-unused-find_pid-function.patch
pidns-remove-find_task_by_pid-unused-for-a-long-time.patch
distinct-tgid-tid-i-o-statistics.patch

