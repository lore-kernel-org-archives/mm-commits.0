From: akpm@linux-foundation.org
Subject: - introduce-pf_kthread-flag.patch removed from -mm tree
Date: Mon, 23 Jun 2008 13:45:41 -0700
Message-ID: <200806232045.m5NKjfq0015276@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752237AbYFWUqt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 16:46:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     introduce PF_KTHREAD flag
has been removed from the -mm tree.  Its filename was
     introduce-pf_kthread-flag.patch

This patch was dropped because an updated version will be merged

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
@@ -1328,6 +1328,7 @@ int do_execve(char * filename,
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
@@ -1470,6 +1470,7 @@ static inline void put_task_struct(struc
 #define PF_EXITING	0x00000004	/* getting shut down */
 #define PF_EXITPIDONE	0x00000008	/* pi exit done on shut down */
 #define PF_VCPU		0x00000010	/* I'm a virtual CPU */
+#define PF_KTHREAD	0x00000020	/* I am a kernel thread */
 #define PF_FORKNOEXEC	0x00000040	/* forked but didn't exec */
 #define PF_SUPERPRIV	0x00000100	/* used super-user privileges */
 #define PF_DUMPCORE	0x00000200	/* dumped core */
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

linux-next.patch
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
distinct-tgid-tid-i-o-statistics.patch

