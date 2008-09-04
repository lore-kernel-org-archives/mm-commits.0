From: akpm@linux-foundation.org
Subject: + tracehook-comment-pasto-fixes.patch added to -mm tree
Date: Thu, 04 Sep 2008 14:27:19 -0700
Message-ID: <200809042127.m84LRJwh031987@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49140 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753208AbYIDV2R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Sep 2008 17:28:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, wenji.huang@oracle.com


The patch titled
     tracehook: comment pasto fixes
has been added to the -mm tree.  Its filename is
     tracehook-comment-pasto-fixes.patch

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
Subject: tracehook: comment pasto fixes
From: Roland McGrath <roland@redhat.com>

Fix some pasto's in comments in the new linux/tracehook.h and
asm-generic/syscall.h files.

Reported-by: Wenji Huang <wenji.huang@oracle.com>
Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/syscall.h |    2 +-
 include/linux/tracehook.h     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/asm-generic/syscall.h~tracehook-comment-pasto-fixes include/asm-generic/syscall.h
--- a/include/asm-generic/syscall.h~tracehook-comment-pasto-fixes
+++ a/include/asm-generic/syscall.h
@@ -126,7 +126,7 @@ void syscall_get_arguments(struct task_s
  * @args:	array of argument values to store
  *
  * Changes @n arguments to the system call starting with the @i'th argument.
- * @n'th argument to @val.  Argument @i gets value @args[0], and so on.
+ * Argument @i gets value @args[0], and so on.
  * An arch inline version is probably optimal when @i and @n are constants.
  *
  * It's only valid to call this when @task is stopped for tracing on
diff -puN include/linux/tracehook.h~tracehook-comment-pasto-fixes include/linux/tracehook.h
--- a/include/linux/tracehook.h~tracehook-comment-pasto-fixes
+++ a/include/linux/tracehook.h
@@ -272,7 +272,7 @@ static inline void tracehook_finish_clon
  * tracehook_report_clone_complete().  This must prevent the child from
  * self-reaping if tracehook_report_clone_complete() uses the @child
  * pointer; otherwise it might have died and been released by the time
- * tracehook_report_report_clone_complete() is called.
+ * tracehook_report_clone_complete() is called.
  *
  * Called with no locks held, but the child cannot run until this returns.
  */
_

Patches currently in -mm which might be from roland@redhat.com are

tracehook-comment-pasto-fixes.patch
linux-next.patch
x86-tracehook-config_have_arch_tracehook.patch
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

