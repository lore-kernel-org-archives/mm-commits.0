From: akpm@linux-foundation.org
Subject: + kmod-avoid-deadlock-from-recursive-kmod-call.patch added to -mm tree
Date: Fri, 08 Jun 2012 13:58:50 -0700
Message-ID: <20120608205850.C2BFDA02F8@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:48647 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601Ab2FHU6w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2012 16:58:52 -0400
Received: by vcbfl13 with SMTP id fl13so211634vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 08 Jun 2012 13:58:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penguin-kernel@i-love.sakura.ne.jp, arjan@linux.intel.com, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, rusty@rustcorp.com.au, tj@kernel.org


The patch titled
     Subject: kmod: avoid deadlock from recursive kmod call
has been added to the -mm tree.  Its filename is
     kmod-avoid-deadlock-from-recursive-kmod-call.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Rusty Russell <rusty@rustcorp.com.au>
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
Subject: Subject: kmod: avoid deadlock from recursive kmod call

Patches currently in -mm which might be from penguin-kernel@i-love.sakura.ne.jp are

kmod-avoid-deadlock-from-recursive-kmod-call.patch

