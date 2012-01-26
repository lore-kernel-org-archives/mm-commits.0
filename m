From: akpm@linux-foundation.org
Subject: + kmod-avoid-deadlock-by-recursive-kmod-call.patch added to -mm tree
Date: Wed, 25 Jan 2012 16:41:39 -0800
Message-ID: <20120126004139.8E5BAA0245@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:40083 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab2AZAll (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2012 19:41:41 -0500
Received: by yenr8 with SMTP id r8so4867yen.1
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2012 16:41:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penguin-kernel@i-love.sakura.ne.jp, arjan@linux.intel.com, penguin-kernel@I-love.SAKURA.ne.jp, rusty@rustcorp.com.au, tj@kernel.org


The patch titled
     Subject: kmod: avoid deadlock from recursive kmod call
has been added to the -mm tree.  Its filename is
     kmod-avoid-deadlock-by-recursive-kmod-call.patch

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

In order to avoid deadlock, do not try to call wait_for_completion() in
call_usermodehelper_exec() if the worker thread was created by khelper
thread with CLONE_VFORK flag.

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

There are various hooks called during do_execve() operation (e.g. 
security_bprm_check(), audit_bprm(), "struct
linux_binfmt"->load_binary()).  If one of such hooks triggers
UMH_WAIT_EXEC, this deadlock will happen even if /sbin/hotplug is not
corrupted.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff -puN kernel/kmod.c~kmod-avoid-deadlock-by-recursive-kmod-call kernel/kmod.c
--- a/kernel/kmod.c~kmod-avoid-deadlock-by-recursive-kmod-call
+++ a/kernel/kmod.c
@@ -44,6 +44,7 @@
 extern int max_threads;
 
 static struct workqueue_struct *khelper_wq;
+static const struct task_struct *kmod_thread_locker;
 
 #define CAP_BSET	(void *)1
 #define CAP_PI		(void *)2
@@ -191,6 +192,13 @@ fail:
 	do_exit(0);
 }
 
+static int call_helper(void *data)
+{
+	/* Worker thread started blocking khelper thread. */
+	kmod_thread_locker = current;
+	return ____call_usermodehelper(data);
+}
+
 void call_usermodehelper_freeinfo(struct subprocess_info *info)
 {
 	if (info->cleanup)
@@ -253,9 +261,12 @@ static void __call_usermodehelper(struct
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
@@ -449,6 +460,16 @@ int call_usermodehelper_exec(struct subp
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

kmod-avoid-deadlock-by-recursive-kmod-call.patch
kmod-avoid-deadlock-by-recursive-kmod-call-fix.patch

