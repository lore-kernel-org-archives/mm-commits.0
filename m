From: akpm@linux-foundation.org
Subject: + kmod-handle-umh_wait_proc-from-system-unbound-workqueue.patch
 added to -mm tree
Date: Fri, 14 Aug 2015 13:49:48 -0700
Message-ID: <55ce546c.e60ZU40y+sJMLQr3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54097 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbbHNUtt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Aug 2015 16:49:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fweisbec@gmail.com, cl@linux.com, oleg@redhat.com, riel@redhat.com, rusty@rustcorp.com.au, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kmod: handle UMH_WAIT_PROC from system unbound workqueue
has been added to the -mm tree.  Its filename is
     kmod-handle-umh_wait_proc-from-system-unbound-workqueue.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kmod-handle-umh_wait_proc-from-system-unbound-workqueue.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kmod-handle-umh_wait_proc-from-system-unbound-workqueue.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: kmod: handle UMH_WAIT_PROC from system unbound workqueue

The UMH_WAIT_PROC handler runs in its own thread in order to make sure
that waiting for the exec kernel thread completion won't block other
usermodehelper queued jobs.

On older workqueue implementations, worklets couldn't sleep without
blocking the rest of the queue.  But now the workqueue subsystem handles
that.  Khelper still had the older limitation due to its singlethread
properties but we replaced it to system unbound workqueues.

Those are affine to the current node and can block up to some number of
instances.

They are a good candidate to handle UMH_WAIT_PROC assuming that we have
enough system unbound workers to handle lots of parallel usermodehelper
jobs.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |   44 ++++++++++++++++++++------------------------
 1 file changed, 20 insertions(+), 24 deletions(-)

diff -puN kernel/kmod.c~kmod-handle-umh_wait_proc-from-system-unbound-workqueue kernel/kmod.c
--- a/kernel/kmod.c~kmod-handle-umh_wait_proc-from-system-unbound-workqueue
+++ a/kernel/kmod.c
@@ -265,15 +265,9 @@ out:
 	do_exit(0);
 }
 
-/*
- * Handles UMH_WAIT_PROC. Our parent (unbound workqueue) might not be able to
- * run enough instances to handle usermodehelper completions without blocking
- * some other pending requests. That's why we use a kernel thread dedicated for
- * that purpose.
- */
-static int call_usermodehelper_exec_sync(void *data)
+/* Handles UMH_WAIT_PROC.  */
+static void call_usermodehelper_exec_sync(struct subprocess_info *sub_info)
 {
-	struct subprocess_info *sub_info = data;
 	pid_t pid;
 
 	/* If SIGCLD is ignored sys_wait4 won't populate the status. */
@@ -287,9 +281,9 @@ static int call_usermodehelper_exec_sync
 		 * Normally it is bogus to call wait4() from in-kernel because
 		 * wait4() wants to write the exit code to a userspace address.
 		 * But call_usermodehelper_exec_sync() always runs as kernel
-		 * thread and put_user() to a kernel address works OK for kernel
-		 * threads, due to their having an mm_segment_t which spans the
-		 * entire address space.
+		 * thread (workqueue) and put_user() to a kernel address works
+		 * OK for kernel threads, due to their having an mm_segment_t
+		 * which spans the entire address space.
 		 *
 		 * Thus the __user pointer cast is valid here.
 		 */
@@ -304,19 +298,21 @@ static int call_usermodehelper_exec_sync
 			sub_info->retval = ret;
 	}
 
+	/* Restore default kernel sig handler */
+	kernel_sigaction(SIGCHLD, SIG_IGN);
+
 	umh_complete(sub_info);
-	do_exit(0);
 }
 
 /*
- * This function doesn't strictly needs to be called asynchronously. But we
- * need to create the usermodehelper kernel threads from a task that is affine
+ * We need to create the usermodehelper kernel thread from a task that is affine
  * to an optimized set of CPUs (or nohz housekeeping ones) such that they
  * inherit a widest affinity irrespective of call_usermodehelper() callers with
  * possibly reduced affinity (eg: per-cpu workqueues). We don't want
  * usermodehelper targets to contend a busy CPU.
  *
- * Unbound workqueues provide such wide affinity.
+ * Unbound workqueues provide such wide affinity and allow to block on
+ * UMH_WAIT_PROC requests without blocking pending request (up to some limit).
  *
  * Besides, workqueues provide the privilege level that caller might not have
  * to perform the usermodehelper request.
@@ -326,18 +322,18 @@ static void call_usermodehelper_exec_wor
 {
 	struct subprocess_info *sub_info =
 		container_of(work, struct subprocess_info, work);
-	pid_t pid;
 
-	if (sub_info->wait & UMH_WAIT_PROC)
-		pid = kernel_thread(call_usermodehelper_exec_sync, sub_info,
-				    CLONE_FS | CLONE_FILES | SIGCHLD);
-	else
+	if (sub_info->wait & UMH_WAIT_PROC) {
+		call_usermodehelper_exec_sync(sub_info);
+	} else {
+		pid_t pid;
+
 		pid = kernel_thread(call_usermodehelper_exec_async, sub_info,
 				    SIGCHLD);
-
-	if (pid < 0) {
-		sub_info->retval = pid;
-		umh_complete(sub_info);
+		if (pid < 0) {
+			sub_info->retval = pid;
+			umh_complete(sub_info);
+		}
 	}
 }
 
_

Patches currently in -mm which might be from fweisbec@gmail.com are

smpboot-fix-memory-leak-on-error-handling.patch
smpboot-make-cleanup-to-mirror-setup.patch
smpboot-allow-to-pass-the-cpumask-on-per-cpu-thread-registration.patch
smpboot-allow-to-pass-the-cpumask-on-per-cpu-thread-registration-fix.patch
watchdog-simplify-housekeeping-affinity-with-the-appropriate-mask.patch
watchdog-introduce-watchdog_park_threads-and-watchdog_unpark_threads.patch
watchdog-introduce-watchdog_suspend-and-watchdog_resume.patch
watchdog-use-park-unpark-functions-in-update_watchdog_all_cpus.patch
watchdog-use-suspend-resume-interface-in-fixup_ht_bug.patch
watchdog-use-suspend-resume-interface-in-fixup_ht_bug-fix-2.patch
watchdog-rename-watchdog_suspend-and-watchdog_resume.patch
kmod-bunch-of-internal-functions-renames.patch
kmod-remove-unecessary-explicit-wide-cpu-affinity-setting.patch
kmod-add-up-to-date-explanations-on-the-purpose-of-each-asynchronous-levels.patch
kmod-use-system_unbound_wq-instead-of-khelper.patch
kmod-handle-umh_wait_proc-from-system-unbound-workqueue.patch
linux-next.patch

