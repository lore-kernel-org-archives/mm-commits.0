From: akpm@linux-foundation.org
Subject: [merged]
 kmod-add-up-to-date-explanations-on-the-purpose-of-each-asynchronous-levels.patch removed from -mm tree
Date: Fri, 11 Sep 2015 11:12:49 -0700
Message-ID: <55f319a1.Vth9JIE0eJ0TjM7c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53917 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbbIKSMu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:12:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fweisbec@gmail.com, cl@linux.com, oleg@redhat.com, riel@redhat.com, rusty@rustcorp.com.au, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kmod: add up-to-date explanations on the purpose of each asynchronous levels
has been removed from the -mm tree.  Its filename was
     kmod-add-up-to-date-explanations-on-the-purpose-of-each-asynchronous-levels.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: kmod: add up-to-date explanations on the purpose of each asynchronous levels

There seem to be quite some confusions on the comments, likely due to
changes that came after them.

Now since it's very non obvious why we have 3 levels of asynchronous code
to implement usermodehelpers, it's important to comment in detail the
reason of this layout.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |   32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff -puN kernel/kmod.c~kmod-add-up-to-date-explanations-on-the-purpose-of-each-asynchronous-levels kernel/kmod.c
--- a/kernel/kmod.c~kmod-add-up-to-date-explanations-on-the-purpose-of-each-asynchronous-levels
+++ a/kernel/kmod.c
@@ -225,8 +225,8 @@ static int call_usermodehelper_exec_asyn
 	spin_unlock_irq(&current->sighand->siglock);
 
 	/*
-	 * Our parent is keventd, which runs with elevated scheduling priority.
-	 * Avoid propagating that into the userspace child.
+	 * Our parent is khelper which runs with elevated scheduling
+	 * priority. Avoid propagating that into the userspace child.
 	 */
 	set_user_nice(current, 0);
 
@@ -267,7 +267,11 @@ out:
 	do_exit(0);
 }
 
-/* Keventd can't block, but this (a child) can. */
+/*
+ * Handles UMH_WAIT_PROC. Our parent khelper can't wait for usermodehelper
+ * completion without blocking every other pending requests. That's why
+ * we use a kernel thread dedicated for that purpose.
+ */
 static int call_usermodehelper_exec_sync(void *data)
 {
 	struct subprocess_info *sub_info = data;
@@ -283,8 +287,8 @@ static int call_usermodehelper_exec_sync
 		/*
 		 * Normally it is bogus to call wait4() from in-kernel because
 		 * wait4() wants to write the exit code to a userspace address.
-		 * But call_usermodehelper_exec_sync() always runs as keventd,
-		 * and put_user() to a kernel address works OK for kernel
+		 * But call_usermodehelper_exec_sync() always runs as kernel
+		 * thread and put_user() to a kernel address works OK for kernel
 		 * threads, due to their having an mm_segment_t which spans the
 		 * entire address space.
 		 *
@@ -305,7 +309,19 @@ static int call_usermodehelper_exec_sync
 	do_exit(0);
 }
 
-/* This is run by khelper thread  */
+/*
+ * This function doesn't strictly needs to be called asynchronously. But we
+ * need to create the usermodehelper kernel threads from a task that is affine
+ * to all CPUs (or nohz housekeeping ones) such that they inherit a widest
+ * affinity irrespective of call_usermodehelper() callers with possibly reduced
+ * affinity (eg: per-cpu workqueues). We don't want usermodehelper targets to
+ * contend any busy CPU.
+ * Khelper provides such wide affinity.
+ *
+ * Besides, khelper provides the privilege level that caller might not have to
+ * perform the usermodehelper request.
+ *
+ */
 static void call_usermodehelper_exec_work(struct work_struct *work)
 {
 	struct subprocess_info *sub_info =
@@ -533,8 +549,8 @@ EXPORT_SYMBOL(call_usermodehelper_setup)
  *        from interrupt context.
  *
  * Runs a user-space application.  The application is started
- * asynchronously if wait is not set, and runs as a child of keventd.
- * (ie. it runs with full root capabilities).
+ * asynchronously if wait is not set, and runs as a child of khelper.
+ * (ie. it runs with full root capabilities and wide affinity).
  */
 int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
 {
_

Patches currently in -mm which might be from fweisbec@gmail.com are


