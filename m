From: akpm@linux-foundation.org
Subject: - signals-fix-sbin-init-protection-from-unwanted-signals.patch removed from -mm tree
Date: Thu, 01 May 2008 02:27:07 -0700
Message-ID: <200805010927.m419R70E030370@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755511AbYEAJ15 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:27:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, ebiederm@xmission.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: fix /sbin/init protection from unwanted signals
has been removed from the -mm tree.  Its filename was
     signals-fix-sbin-init-protection-from-unwanted-signals.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: fix /sbin/init protection from unwanted signals
From: Oleg Nesterov <oleg@tv-sign.ru>

The global init has a lot of long standing problems with the unhandled fatal
signals.

	- The "is_global_init(current)" check in get_signal_to_deliver()
	  protects only the main thread. Sub-thread can dequee the fatal
	  signal and shutdown the whole thread group except the main thread.
	  If it dequeues SIGSTOP /sbin/init will be stopped, this is not
	  right too. Note that we can't use is_global_init(->group_leader),
	  this breaks exec and this can't solve other problems we have.

	- Even if afterwards ignored, the fatal signals sets SIGNAL_GROUP_EXIT
	  on delivery. This breaks exec, has other bad implications, and this
	  is just wrong.

Introduce the new SIGNAL_UNKILLABLE flag to fix these problems.  It also helps
to solve some other problems addressed by the subsequent patches.

Currently we use this flag for the global init only, but it could also be used
by kthreads and (perhaps) by the sub-namespace inits.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 ++
 init/main.c           |    2 ++
 kernel/signal.c       |    9 ++++++---
 3 files changed, 10 insertions(+), 3 deletions(-)

diff -puN include/linux/sched.h~signals-fix-sbin-init-protection-from-unwanted-signals include/linux/sched.h
--- a/include/linux/sched.h~signals-fix-sbin-init-protection-from-unwanted-signals
+++ a/include/linux/sched.h
@@ -561,6 +561,8 @@ struct signal_struct {
 #define SIGNAL_CLD_CONTINUED	0x00000020
 #define SIGNAL_CLD_MASK		(SIGNAL_CLD_STOPPED|SIGNAL_CLD_CONTINUED)
 
+#define SIGNAL_UNKILLABLE	0x00000040 /* for init: ignore fatal signals */
+
 /* If true, all threads except ->group_exit_task have pending SIGKILL */
 static inline int signal_group_exit(const struct signal_struct *sig)
 {
diff -puN init/main.c~signals-fix-sbin-init-protection-from-unwanted-signals init/main.c
--- a/init/main.c~signals-fix-sbin-init-protection-from-unwanted-signals
+++ a/init/main.c
@@ -802,6 +802,8 @@ static int noinline init_post(void)
 	(void) sys_dup(0);
 	(void) sys_dup(0);
 
+	current->signal->flags |= SIGNAL_UNKILLABLE;
+
 	if (ramdisk_execute_command) {
 		run_init_process(ramdisk_execute_command);
 		printk(KERN_WARNING "Failed to execute %s\n",
diff -puN kernel/signal.c~signals-fix-sbin-init-protection-from-unwanted-signals kernel/signal.c
--- a/kernel/signal.c~signals-fix-sbin-init-protection-from-unwanted-signals
+++ a/kernel/signal.c
@@ -728,7 +728,8 @@ static void complete_signal(int sig, str
 	 * Found a killable thread.  If the signal will be fatal,
 	 * then start taking the whole group down immediately.
 	 */
-	if (sig_fatal(p, sig) && !(signal->flags & SIGNAL_GROUP_EXIT) &&
+	if (sig_fatal(p, sig) &&
+	    !(signal->flags & (SIGNAL_UNKILLABLE | SIGNAL_GROUP_EXIT)) &&
 	    !sigismember(&t->real_blocked, sig) &&
 	    (sig == SIGKILL || !(t->ptrace & PT_PTRACED))) {
 		/*
@@ -1615,7 +1616,8 @@ static int do_signal_stop(int signr)
 	} else {
 		struct task_struct *t;
 
-		if (!likely(sig->flags & SIGNAL_STOP_DEQUEUED) ||
+		if (unlikely((sig->flags & (SIGNAL_STOP_DEQUEUED | SIGNAL_UNKILLABLE))
+					 != SIGNAL_STOP_DEQUEUED) ||
 		    unlikely(signal_group_exit(sig)))
 			return 0;
 		/*
@@ -1761,7 +1763,8 @@ relock:
 		/*
 		 * Global init gets no signals it doesn't want.
 		 */
-		if (is_global_init(current))
+		if (unlikely(signal->flags & SIGNAL_UNKILLABLE) &&
+		    !signal_group_exit(signal))
 			continue;
 
 		if (sig_kernel_stop(signr)) {
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
workqueue-remove-redundant-function-invocation.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

