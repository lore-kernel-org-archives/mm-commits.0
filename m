From: akpm@linux-foundation.org
Subject: [merged] kmod-use-system_unbound_wq-instead-of-khelper.patch
 removed from -mm tree
Date: Fri, 11 Sep 2015 11:12:51 -0700
Message-ID: <55f319a3.6rVq8hex1TAd6eKi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53925 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbbIKSMw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:12:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fweisbec@gmail.com, cl@linux.com, oleg@redhat.com, riel@redhat.com, rusty@rustcorp.com.au, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kmod: use system_unbound_wq instead of khelper
has been removed from the -mm tree.  Its filename was
     kmod-use-system_unbound_wq-instead-of-khelper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: kmod: use system_unbound_wq instead of khelper

We need to launch the usermodehelper kernel threads with the widest
affinity and this is partly why we use khelper.  This workqueue has
unbound properties and thus a wide affinity inherited by all its children.

Now khelper also has special properties that we aren't much interested in:
ordered and singlethread.  There is really no need about ordering as all
we do is creating kernel threads.  This can be done concurrently.  And
singlethread is a useless limitation as well.

The workqueue engine already proposes generic unbound workqueues that
don't share these useless properties and handle well parallel jobs.

The only worrysome specific is their affinity to the node of the current
CPU.  It's fine for creating the usermodehelper kernel threads but those
inherit this affinity for longer jobs such as requesting modules.

This patch proposes to use these node affine unbound workqueues assuming
that a node is sufficient to handle several parallel usermodehelper
requests.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kmod.h |    2 --
 init/main.c          |    1 -
 kernel/kmod.c        |   40 +++++++++++++++++-----------------------
 3 files changed, 17 insertions(+), 26 deletions(-)

diff -puN include/linux/kmod.h~kmod-use-system_unbound_wq-instead-of-khelper include/linux/kmod.h
--- a/include/linux/kmod.h~kmod-use-system_unbound_wq-instead-of-khelper
+++ a/include/linux/kmod.h
@@ -85,8 +85,6 @@ enum umh_disable_depth {
 	UMH_DISABLED,
 };
 
-extern void usermodehelper_init(void);
-
 extern int __usermodehelper_disable(enum umh_disable_depth depth);
 extern void __usermodehelper_set_disable_depth(enum umh_disable_depth depth);
 
diff -puN init/main.c~kmod-use-system_unbound_wq-instead-of-khelper init/main.c
--- a/init/main.c~kmod-use-system_unbound_wq-instead-of-khelper
+++ a/init/main.c
@@ -877,7 +877,6 @@ static void __init do_initcalls(void)
 static void __init do_basic_setup(void)
 {
 	cpuset_init_smp();
-	usermodehelper_init();
 	shmem_init();
 	driver_init();
 	init_irq_proc();
diff -puN kernel/kmod.c~kmod-use-system_unbound_wq-instead-of-khelper kernel/kmod.c
--- a/kernel/kmod.c~kmod-use-system_unbound_wq-instead-of-khelper
+++ a/kernel/kmod.c
@@ -45,8 +45,6 @@
 
 extern int max_threads;
 
-static struct workqueue_struct *khelper_wq;
-
 #define CAP_BSET	(void *)1
 #define CAP_PI		(void *)2
 
@@ -225,7 +223,7 @@ static int call_usermodehelper_exec_asyn
 	spin_unlock_irq(&current->sighand->siglock);
 
 	/*
-	 * Our parent is khelper which runs with elevated scheduling
+	 * Our parent (unbound workqueue) runs with elevated scheduling
 	 * priority. Avoid propagating that into the userspace child.
 	 */
 	set_user_nice(current, 0);
@@ -268,9 +266,10 @@ out:
 }
 
 /*
- * Handles UMH_WAIT_PROC. Our parent khelper can't wait for usermodehelper
- * completion without blocking every other pending requests. That's why
- * we use a kernel thread dedicated for that purpose.
+ * Handles UMH_WAIT_PROC. Our parent (unbound workqueue) might not be able to
+ * run enough instances to handle usermodehelper completions without blocking
+ * some other pending requests. That's why we use a kernel thread dedicated for
+ * that purpose.
  */
 static int call_usermodehelper_exec_sync(void *data)
 {
@@ -312,14 +311,15 @@ static int call_usermodehelper_exec_sync
 /*
  * This function doesn't strictly needs to be called asynchronously. But we
  * need to create the usermodehelper kernel threads from a task that is affine
- * to all CPUs (or nohz housekeeping ones) such that they inherit a widest
- * affinity irrespective of call_usermodehelper() callers with possibly reduced
- * affinity (eg: per-cpu workqueues). We don't want usermodehelper targets to
- * contend any busy CPU.
- * Khelper provides such wide affinity.
+ * to an optimized set of CPUs (or nohz housekeeping ones) such that they
+ * inherit a widest affinity irrespective of call_usermodehelper() callers with
+ * possibly reduced affinity (eg: per-cpu workqueues). We don't want
+ * usermodehelper targets to contend a busy CPU.
+ *
+ * Unbound workqueues provide such wide affinity.
  *
- * Besides, khelper provides the privilege level that caller might not have to
- * perform the usermodehelper request.
+ * Besides, workqueues provide the privilege level that caller might not have
+ * to perform the usermodehelper request.
  *
  */
 static void call_usermodehelper_exec_work(struct work_struct *work)
@@ -549,8 +549,8 @@ EXPORT_SYMBOL(call_usermodehelper_setup)
  *        from interrupt context.
  *
  * Runs a user-space application.  The application is started
- * asynchronously if wait is not set, and runs as a child of khelper.
- * (ie. it runs with full root capabilities and wide affinity).
+ * asynchronously if wait is not set, and runs as a child of system workqueues.
+ * (ie. it runs with full root capabilities and optimized affinity).
  */
 int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
 {
@@ -562,7 +562,7 @@ int call_usermodehelper_exec(struct subp
 		return -EINVAL;
 	}
 	helper_lock();
-	if (!khelper_wq || usermodehelper_disabled) {
+	if (usermodehelper_disabled) {
 		retval = -EBUSY;
 		goto out;
 	}
@@ -574,7 +574,7 @@ int call_usermodehelper_exec(struct subp
 	sub_info->complete = (wait == UMH_NO_WAIT) ? NULL : &done;
 	sub_info->wait = wait;
 
-	queue_work(khelper_wq, &sub_info->work);
+	queue_work(system_unbound_wq, &sub_info->work);
 	if (wait == UMH_NO_WAIT)	/* task has freed sub_info */
 		goto unlock;
 
@@ -704,9 +704,3 @@ struct ctl_table usermodehelper_table[]
 	},
 	{ }
 };
