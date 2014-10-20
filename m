From: akpm@linux-foundation.org
Subject: + usermodehelper-kill-the-kmod_thread_locker-logic.patch added to -mm tree
Date: Mon, 20 Oct 2014 14:14:54 -0700
Message-ID: <54457b4e.5LEf4CEFo9VXBEDP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56870 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbaJTVOy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Oct 2014 17:14:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: usermodehelper: kill the kmod_thread_locker logic
has been added to the -mm tree.  Its filename is
     usermodehelper-kill-the-kmod_thread_locker-logic.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/usermodehelper-kill-the-kmod_thread_locker-logic.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/usermodehelper-kill-the-kmod_thread_locker-logic.patch

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
