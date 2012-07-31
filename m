From: akpm@linux-foundation.org
Subject: [merged] kmod-avoid-deadlock-from-recursive-kmod-call.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:53:37 -0700
Message-ID: <20120731185338.38C3020004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:36542 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322Ab2GaSxk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:53:40 -0400
Received: by weyr1 with SMTP id r1so292439wey.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:53:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@i-love.sakura.ne.jp, arjan@linux.intel.com, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, rusty@rustcorp.com.au, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kmod: avoid deadlock from recursive kmod call
has been removed from the -mm tree.  Its filename was
     kmod-avoid-deadlock-from-recursive-kmod-call.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: kmod: avoid deadlock from recursive kmod call

The system deadlocks (at least since 2.6.10) when
call_usermodehelper(UMH_WAIT_EXEC) request triggered
call_usermodehelper(UMH_WAIT_PROC) request.

This is because "khelper thread is waiting for the worker thread at
wait_for_completion() in do_fork() since the worker thread was created
with CLONE_VFORK flag" and "the worker thread cannot call complete()
because do_execve() is blocked at UMH_WAIT_PROC request" and "the khelper
thread cannot start processing UMH_WAIT_PROC request because the khelper
thread is waiting for the worker thread at wait_for_completion() in
do_fork()".

The easiest example to observe this deadlock is to use a corrupted
/sbin/hotplug binary (like shown below).

  # : > /tmp/dummy
  # chmod 755 /tmp/dummy
  # echo /tmp/dummy > /proc/sys/kernel/hotplug
  # modprobe whatever

call_usermodehelper("/tmp/dummy", UMH_WAIT_EXEC) is called from
kobject_uevent_env() in lib/kobject_uevent.c upon loading/unloading a
module.  do_execve("/tmp/dummy") triggers a call to
request_module("binfmt-0000") from search_binary_handler() which in turn
calls call_usermodehelper(UMH_WAIT_PROC).

In order to avoid deadlock, as a for-now and easy-to-backport solution, do
not try to call wait_for_completion() in call_usermodehelper_exec() if the
worker thread was created by khelper thread with CLONE_VFORK flag.  Future
and fundamental solution might be replacing singleton khelper thread with
some workqueue so that recursive calls up to max_active dependency loop
can be handled without deadlock.

[akpm@linux-foundation.org: add comment to kmod_thread_locker]
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |   31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff -puN kernel/kmod.c~kmod-avoid-deadlock-from-recursive-kmod-call kernel/kmod.c
--- a/kernel/kmod.c~kmod-avoid-deadlock-from-recursive-kmod-call
+++ a/kernel/kmod.c
@@ -45,6 +45,13 @@ extern int max_threads;
 
 static struct workqueue_struct *khelper_wq;
 
+/*
+ * kmod_thread_locker is used for deadlock avoidance.  There is no explicit
+ * locking to protect this global - it is private to the singleton khelper
+ * thread and should only ever be modified by that thread.
+ */
+static const struct task_struct *kmod_thread_locker;
+
 #define CAP_BSET	(void *)1
 #define CAP_PI		(void *)2
 
@@ -221,6 +228,13 @@ fail:
 	return 0;
 }
 
+static int call_helper(void *data)
+{
+	/* Worker thread started blocking khelper thread. */
+	kmod_thread_locker = current;
+	return ____call_usermodehelper(data);
+}
+
 static void call_usermodehelper_freeinfo(struct subprocess_info *info)
 {
 	if (info->cleanup)
@@ -295,9 +309,12 @@ static void __call_usermodehelper(struct
 	if (wait == UMH_WAIT_PROC)
 		pid = kernel_thread(wait_for_helper, sub_info,
 				    CLONE_FS | CLONE_FILES | SIGCHLD);
-	else
-		pid = kernel_thread(____call_usermodehelper, sub_info,
+	else {
+		pid = kernel_thread(call_helper, sub_info,
 				    CLONE_VFORK | SIGCHLD);
+		/* Worker thread stopped blocking khelper thread. */
+		kmod_thread_locker = NULL;
+	}
 
 	switch (wait) {
 	case UMH_NO_WAIT:
@@ -548,6 +565,16 @@ int call_usermodehelper_exec(struct subp
 		retval = -EBUSY;
 		goto out;
 	}
+	/*
+	 * Worker thread must not wait for khelper thread at below
+	 * wait_for_completion() if the thread was created with CLONE_VFORK
+	 * flag, for khelper thread is already waiting for the thread at
+	 * wait_for_completion() in do_fork().
+	 */
+	if (wait != UMH_NO_WAIT && current == kmod_thread_locker) {
+		retval = -EBUSY;
+		goto out;
+	}
 
 	sub_info->complete = &done;
 	sub_info->wait = wait;
_

Patches currently in -mm which might be from penguin-kernel@i-love.sakura.ne.jp are

origin.patch

