From: akpm@linux-foundation.org
Subject: [merged] usermodehelper-kill-the-kmod_thread_locker-logic.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 11:08:06 -0800
Message-ID: <5489eb96.gvOHp8srtOcfrYoH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46058 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758579AbaLKTIH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:08:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: usermodehelper: kill the kmod_thread_locker logic
has been removed from the -mm tree.  Its filename was
     usermodehelper-kill-the-kmod_thread_locker-logic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: usermodehelper: kill the kmod_thread_locker logic

Now that we do not call kernel_thread(CLONE_VFORK) from the worker thread
we can not deadlock if do_execve() in turn triggers another
call_usermodehelper(), we can remove the kmod_thread_locker code.

Note: we should probably kill khelper_wq and simply use one of the global
workqueues, say, system_unbound_wq, this special wq for umh buys nothing
nowadays.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |   33 +++------------------------------
 1 file changed, 3 insertions(+), 30 deletions(-)

diff -puN kernel/kmod.c~usermodehelper-kill-the-kmod_thread_locker-logic kernel/kmod.c
--- a/kernel/kmod.c~usermodehelper-kill-the-kmod_thread_locker-logic
+++ a/kernel/kmod.c
@@ -47,13 +47,6 @@ extern int max_threads;
 
 static struct workqueue_struct *khelper_wq;
 
-/*
- * kmod_thread_locker is used for deadlock avoidance.  There is no explicit
- * locking to protect this global - it is private to the singleton khelper
- * thread and should only ever be modified by that thread.
- */
-static const struct task_struct *kmod_thread_locker;
-
 #define CAP_BSET	(void *)1
 #define CAP_PI		(void *)2
 
@@ -273,13 +266,6 @@ out:
 	do_exit(0);
 }
 
-static int call_helper(void *data)
-{
-	/* Worker thread started blocking khelper thread. */
-	kmod_thread_locker = current;
-	return ____call_usermodehelper(data);
-}
-
 /* Keventd can't block, but this (a child) can. */
 static int wait_for_helper(void *data)
 {
@@ -327,11 +313,9 @@ static void __call_usermodehelper(struct
 	if (sub_info->wait & UMH_WAIT_PROC)
 		pid = kernel_thread(wait_for_helper, sub_info,
 				    CLONE_FS | CLONE_FILES | SIGCHLD);
-	else {
-		pid = kernel_thread(call_helper, sub_info, SIGCHLD);
-		/* Worker thread stopped blocking khelper thread. */
-		kmod_thread_locker = NULL;
-	}
+	else
+		pid = kernel_thread(____call_usermodehelper, sub_info,
+				    SIGCHLD);
 
 	if (pid < 0) {
 		sub_info->retval = pid;
@@ -565,17 +549,6 @@ int call_usermodehelper_exec(struct subp
 		goto out;
 	}
 	/*
-	 * Worker thread must not wait for khelper thread at below
-	 * wait_for_completion() if the thread was created with CLONE_VFORK
-	 * flag, for khelper thread is already waiting for the thread at
-	 * wait_for_completion() in do_fork().
-	 */
-	if (wait != UMH_NO_WAIT && current == kmod_thread_locker) {
-		retval = -EBUSY;
-		goto out;
-	}
-
-	/*
 	 * Set the completion pointer only if there is a waiter.
 	 * This makes it possible to use umh_complete to free
 	 * the data structure in case of UMH_NO_WAIT.
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
mmfs-introduce-helpers-around-the-i_mmap_mutex.patch
mm-use-new-helper-functions-around-the-i_mmap_mutex.patch
mm-convert-i_mmap_mutex-to-rwsem.patch
mm-rmap-share-the-i_mmap_rwsem.patch
uprobes-share-the-i_mmap_rwsem.patch
mm-xip-share-the-i_mmap_rwsem.patch
mm-memory-failure-share-the-i_mmap_rwsem.patch
mm-nommu-share-the-i_mmap_rwsem.patch
mm-memoryc-share-the-i_mmap_rwsem.patch
remove-unnecessary-is_valid_nodemask.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2-fix.patch
oom-kill-the-insufficient-and-no-longer-needed-pt_trace_exit-check.patch
linux-next.patch
all-arches-signal-move-restart_block-to-struct-task_struct.patch

