From: akpm@linux-foundation.org
Subject: + introduce-pf_kthread-flag.patch added to -mm tree
Date: Wed, 04 Jun 2008 00:57:51 -0700
Message-ID: <200806040757.m547vpON011127@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35734 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752235AbYFDH7j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2008 03:59:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     introduce PF_KTHREAD flag
has been added to the -mm tree.  Its filename is
     introduce-pf_kthread-flag.patch

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
Subject: introduce PF_KTHREAD flag
From: Oleg Nesterov <oleg@tv-sign.ru>

Introduce the new PF_KTHREAD flag to mark the kernel threads.  It is set
by INIT_TASK() and copied to the forked childs (we could set it in
kthreadd() along with PF_NOFREEZE instead).

daemonize() was changed as well.  In that case testing of PF_KTHREAD is
racy, but daemonize() is hopeless anyway.

This flag is cleared in do_execve(), before search_binary_handler(). 
Probably not the best place, we can do this in exec_mmap() or in
start_thread(), or clear it along with PF_FORKNOEXEC.  But I think this
doesn't matter in practice, and if do_execve() fails kthread should die
soon.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c                 |    1 +
 include/linux/init_task.h |    2 +-
 include/linux/sched.h     |    1 +
 kernel/exit.c             |    2 +-
 4 files changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/exec.c~introduce-pf_kthread-flag fs/exec.c
--- a/fs/exec.c~introduce-pf_kthread-flag
+++ a/fs/exec.c
@@ -1324,6 +1324,7 @@ int do_execve(char * filename,
 	if (retval < 0)
 		goto out;
 
+	current->flags &= ~PF_KTHREAD;
 	retval = search_binary_handler(bprm,regs);
 	if (retval >= 0) {
 		/* execve success */
diff -puN include/linux/init_task.h~introduce-pf_kthread-flag include/linux/init_task.h
--- a/include/linux/init_task.h~introduce-pf_kthread-flag
+++ a/include/linux/init_task.h
@@ -122,7 +122,7 @@ extern struct group_info init_groups;
 	.state		= 0,						\
 	.stack		= &init_thread_info,				\
 	.usage		= ATOMIC_INIT(2),				\
-	.flags		= 0,						\
+	.flags		= PF_KTHREAD,					\
 	.lock_depth	= -1,						\
 	.prio		= MAX_PRIO-20,					\
 	.static_prio	= MAX_PRIO-20,					\
diff -puN include/linux/sched.h~introduce-pf_kthread-flag include/linux/sched.h
--- a/include/linux/sched.h~introduce-pf_kthread-flag
+++ a/include/linux/sched.h
@@ -1508,6 +1508,7 @@ static inline void put_task_struct(struc
 #define PF_MEMPOLICY	0x10000000	/* Non-default NUMA mempolicy */
 #define PF_MUTEX_TESTER	0x20000000	/* Thread belongs to the rt mutex tester */
 #define PF_FREEZER_SKIP	0x40000000	/* Freezer should not count it as freezeable */
+#define PF_KTHREAD	0x80000000	/* I am a kernel thread */
 
 /*
  * Only the _current_ task can read/write to tsk->flags, but other
diff -puN kernel/exit.c~introduce-pf_kthread-flag kernel/exit.c
--- a/kernel/exit.c~introduce-pf_kthread-flag
+++ a/kernel/exit.c
@@ -421,7 +421,7 @@ void daemonize(const char *name, ...)
 	 * We don't want to have TIF_FREEZE set if the system-wide hibernation
 	 * or suspend transition begins right now.
 	 */
-	current->flags |= PF_NOFREEZE;
+	current->flags |= (PF_NOFREEZE | PF_KTHREAD);
 
 	if (current->nsproxy != &init_nsproxy) {
 		get_nsproxy(&init_nsproxy);
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

vt-fix-vc_resize-locking.patch
introduce-pf_kthread-flag.patch
kill-pf_borrowed_mm-in-favour-of-pf_kthread.patch
coredump-zap_threads-must-skip-kernel-threads.patch
uml-activate_mm-remove-the-dead-pf_borrowed_mm-check.patch
posix-timers-timer_delete-remove-the-bogus-it_process-=-null-check.patch
posix-timers-release_posix_timer-kill-the-bogus-put_task_struct-it_process.patch
signals-collect_signal-remove-the-unneeded-sigismember-check.patch
signals-collect_signal-simplify-the-still_pending-logic.patch
signals-change-collect_signal-to-return-void.patch
__exit_signal-dont-take-rcu-lock.patch
signals-dequeue_signal-dont-check-signal_group_exit-when-setting-signal_stop_dequeued.patch
signals-do_signal_stop-kill-the-signal_unkillable-check.patch
coredump-zap_threads-comments-use-while_each_thread.patch
distinct-tgid-tid-i-o-statistics.patch

