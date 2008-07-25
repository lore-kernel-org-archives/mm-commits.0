From: akpm@linux-foundation.org
Subject: - introduce-pf_kthread-flag.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:59:46 -0700
Message-ID: <200807252259.m6PMxkwE003416@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35273 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751784AbYGYXAe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:00:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     introduce PF_KTHREAD flag
has been removed from the -mm tree.  Its filename was
     introduce-pf_kthread-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1326,6 +1326,7 @@ int do_execve(char * filename,
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
@@ -1483,6 +1483,7 @@ static inline void put_task_struct(struc
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
@@ -430,7 +430,7 @@ void daemonize(const char *name, ...)
 	 * We don't want to have TIF_FREEZE set if the system-wide hibernation
 	 * or suspend transition begins right now.
 	 */
-	current->flags |= PF_NOFREEZE;
+	current->flags |= (PF_NOFREEZE | PF_KTHREAD);
 
 	if (current->nsproxy != &init_nsproxy) {
 		get_nsproxy(&init_nsproxy);
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
linux-next.patch
migrate_timers-add-comment-use-spinlock_irq.patch
tracehook-add-linux-tracehookh.patch
tracehook-exec.patch
tracehook-unexport-ptrace_notify.patch
tracehook-exit.patch
tracehook-clone.patch
tracehook-vfork-done.patch
tracehook-release_task.patch
tracehook-tracehook_tracer_task.patch
tracehook-tracehook_expect_breakpoints.patch
tracehook-tracehook_signal_handler.patch
tracehook-tracehook_consider_ignored_signal.patch
tracehook-tracehook_consider_fatal_signal.patch
tracehook-syscall.patch
tracehook-get_signal_to_deliver.patch
tracehook-job-control.patch
tracehook-death.patch
tracehook-force-signal_pending.patch
tracehook-tif_notify_resume.patch
tracehook-asm-syscallh.patch
tracehook-config_have_arch_tracehook.patch
tracehook-wait_task_inactive.patch
task_current_syscall.patch
proc-pid-syscall.patch

