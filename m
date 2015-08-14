From: akpm@linux-foundation.org
Subject: + kmod-bunch-of-internal-functions-renames.patch added to -mm
 tree
Date: Fri, 14 Aug 2015 13:49:40 -0700
Message-ID: <55ce5464.1sQagC7Mr4m3ysKO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54075 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbbHNUtl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Aug 2015 16:49:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fweisbec@gmail.com, cl@linux.com, oleg@redhat.com, riel@redhat.com, rusty@rustcorp.com.au, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kmod: bunch of internal functions renames
has been added to the -mm tree.  Its filename is
     kmod-bunch-of-internal-functions-renames.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kmod-bunch-of-internal-functions-renames.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kmod-bunch-of-internal-functions-renames.patch

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
Subject: kmod: bunch of internal functions renames

This patchset does a bunch of cleanups and converts khelper to use system
unbound workqueues.  The 3 first patches should be uncontroversial.  The
last 2 patches are debatable.

Kmod creates kernel threads that perform userspace jobs and we want those
to have a large affinity in order not to contend busy CPUs.  This is
(partly) why we use khelper which has a wide affinity that the kernel
threads it create can inherit from.  Now khelper is a dedicated workqueue
that has singlethread properties which we aren't interested in.

Hence those two debatable changes:

_ We would like to use generic workqueues. System unbound workqueues are
  a very good candidate but they are not wide affine, only node affine.
  Now probably a node is enough to perform many parallel kmod jobs.

_ We would like to remove the wait_for_helper kernel thread (UMH_WAIT_PROC
  handler) to use the workqueue. It means that if the workqueue blocks,
  and no other worker can take pending kmod request, we can be screwed.
  Now if we have 512 threads, this should be enough.


This patch (of 5):

Underscores on function names aren't much verbose to explain the purpose
of a function.  And kmod has interesting such flavours.

Lets rename the following functions:

* __call_usermodehelper -> call_usermodehelper_exec_work
* ____call_usermodehelper -> call_usermodehelper_exec_async
* wait_for_helper -> call_usermodehelper_exec_sync

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |   30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff -puN kernel/kmod.c~kmod-bunch-of-internal-functions-renames kernel/kmod.c
--- a/kernel/kmod.c~kmod-bunch-of-internal-functions-renames
+++ a/kernel/kmod.c
@@ -214,7 +214,7 @@ static void umh_complete(struct subproce
 /*
  * This is the task which runs the usermode application
  */
-static int ____call_usermodehelper(void *data)
+static int call_usermodehelper_exec_async(void *data)
 {
 	struct subprocess_info *sub_info = data;
 	struct cred *new;
@@ -259,7 +259,10 @@ static int ____call_usermodehelper(void
 			   (const char __user *const __user *)sub_info->envp);
 out:
 	sub_info->retval = retval;
-	/* wait_for_helper() will call umh_complete if UHM_WAIT_PROC. */
+	/*
+	 * call_usermodehelper_exec_sync() will call umh_complete
+	 * if UHM_WAIT_PROC.
+	 */
 	if (!(sub_info->wait & UMH_WAIT_PROC))
 		umh_complete(sub_info);
 	if (!retval)
@@ -268,14 +271,14 @@ out:
 }
 
 /* Keventd can't block, but this (a child) can. */
-static int wait_for_helper(void *data)
+static int call_usermodehelper_exec_sync(void *data)
 {
 	struct subprocess_info *sub_info = data;
 	pid_t pid;
 
 	/* If SIGCLD is ignored sys_wait4 won't populate the status. */
 	kernel_sigaction(SIGCHLD, SIG_DFL);
-	pid = kernel_thread(____call_usermodehelper, sub_info, SIGCHLD);
+	pid = kernel_thread(call_usermodehelper_exec_async, sub_info, SIGCHLD);
 	if (pid < 0) {
 		sub_info->retval = pid;
 	} else {
@@ -283,17 +286,18 @@ static int wait_for_helper(void *data)
 		/*
 		 * Normally it is bogus to call wait4() from in-kernel because
 		 * wait4() wants to write the exit code to a userspace address.
-		 * But wait_for_helper() always runs as keventd, and put_user()
-		 * to a kernel address works OK for kernel threads, due to their
-		 * having an mm_segment_t which spans the entire address space.
+		 * But call_usermodehelper_exec_sync() always runs as keventd,
+		 * and put_user() to a kernel address works OK for kernel
+		 * threads, due to their having an mm_segment_t which spans the
+		 * entire address space.
 		 *
 		 * Thus the __user pointer cast is valid here.
 		 */
 		sys_wait4(pid, (int __user *)&ret, 0, NULL);
 
 		/*
-		 * If ret is 0, either ____call_usermodehelper failed and the
-		 * real error code is already in sub_info->retval or
+		 * If ret is 0, either call_usermodehelper_exec_async failed and
+		 * the real error code is already in sub_info->retval or
 		 * sub_info->retval is 0 anyway, so don't mess with it then.
 		 */
 		if (ret)
@@ -305,17 +309,17 @@ static int wait_for_helper(void *data)
 }
 
 /* This is run by khelper thread  */
-static void __call_usermodehelper(struct work_struct *work)
+static void call_usermodehelper_exec_work(struct work_struct *work)
 {
 	struct subprocess_info *sub_info =
 		container_of(work, struct subprocess_info, work);
 	pid_t pid;
 
 	if (sub_info->wait & UMH_WAIT_PROC)
-		pid = kernel_thread(wait_for_helper, sub_info,
+		pid = kernel_thread(call_usermodehelper_exec_sync, sub_info,
 				    CLONE_FS | CLONE_FILES | SIGCHLD);
 	else
-		pid = kernel_thread(____call_usermodehelper, sub_info,
+		pid = kernel_thread(call_usermodehelper_exec_async, sub_info,
 				    SIGCHLD);
 
 	if (pid < 0) {
@@ -510,7 +514,7 @@ struct subprocess_info *call_usermodehel
 	if (!sub_info)
 		goto out;
 
-	INIT_WORK(&sub_info->work, __call_usermodehelper);
+	INIT_WORK(&sub_info->work, call_usermodehelper_exec_work);
 	sub_info->path = path;
 	sub_info->argv = argv;
 	sub_info->envp = envp;
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

