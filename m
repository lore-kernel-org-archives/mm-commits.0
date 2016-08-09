From: akpm@linux-foundation.org
Subject: + kthread-better-support-freezable-kthread-workers.patch added to -mm tree
Date: Tue, 09 Aug 2016 15:11:21 -0700
Message-ID: <57aa5509.8/JesNCjNIvhyVNp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40329 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932506AbcHIWLX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Aug 2016 18:11:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pmladek@suse.com, bp@suse.de, jkosina@suse.cz, josh@joshtriplett.org, mhocko@suse.cz, mingo@redhat.com, oleg@redhat.com, paulmck@linux.vnet.ibm.com, peterz@infradead.org, rostedt@goodmis.org, tglx@linutronix.de, tj@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: kthread: better support freezable kthread workers
has been added to the -mm tree.  Its filename is
     kthread-better-support-freezable-kthread-workers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kthread-better-support-freezable-kthread-workers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kthread-better-support-freezable-kthread-workers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Petr Mladek <pmladek@suse.com>
Subject: kthread: better support freezable kthread workers

This patch allows to make kthread worker freezable via a new @flags
parameter. It will allow to avoid an init work in some kthreads.

It currently does not affect the function of kthread_worker_fn()
but it might help to do some optimization or fixes eventually.

I currently do not know about any other use for the @flags
parameter but I believe that we will want more flags
in the future.

Finally, I hope that it will not cause confusion with @flags member
in struct kthread. Well, I guess that we will want to rework the
basic kthreads implementation once all kthreads are converted into
kthread workers or workqueues. It is possible that we will merge
the two structures.

Link: http://lkml.kernel.org/r/1470754545-17632-12-git-send-email-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Borislav Petkov <bp@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kthread.h |   12 +++++++++---
 kernel/kthread.c        |   21 +++++++++++++++------
 2 files changed, 24 insertions(+), 9 deletions(-)

diff -puN include/linux/kthread.h~kthread-better-support-freezable-kthread-workers include/linux/kthread.h
--- a/include/linux/kthread.h~kthread-better-support-freezable-kthread-workers
+++ a/include/linux/kthread.h
@@ -65,7 +65,12 @@ struct kthread_work;
 typedef void (*kthread_work_func_t)(struct kthread_work *work);
 void kthread_delayed_work_timer_fn(unsigned long __data);
 
+enum {
+	KTW_FREEZABLE		= 1 << 0,	/* freeze during suspend */
+};
+
 struct kthread_worker {
+	unsigned int		flags;
 	spinlock_t		lock;
 	struct list_head	work_list;
 	struct list_head	delayed_work_list;
@@ -154,12 +159,13 @@ extern void __kthread_init_worker(struct
 
 int kthread_worker_fn(void *worker_ptr);
 
-__printf(1, 2)
+__printf(2, 3)
 struct kthread_worker *
-kthread_create_worker(const char namefmt[], ...);
+kthread_create_worker(unsigned int flags, const char namefmt[], ...);
 
 struct kthread_worker *
-kthread_create_worker_on_cpu(int cpu, const char namefmt[], ...);
+kthread_create_worker_on_cpu(int cpu, unsigned int flags,
+			     const char namefmt[], ...);
 
 bool kthread_queue_work(struct kthread_worker *worker,
 			struct kthread_work *work);
diff -puN kernel/kthread.c~kthread-better-support-freezable-kthread-workers kernel/kthread.c
--- a/kernel/kthread.c~kthread-better-support-freezable-kthread-workers
+++ a/kernel/kthread.c
@@ -556,11 +556,11 @@ void __kthread_init_worker(struct kthrea
 				const char *name,
 				struct lock_class_key *key)
 {
+	memset(worker, 0, sizeof(struct kthread_worker));
 	spin_lock_init(&worker->lock);
 	lockdep_set_class_and_name(&worker->lock, key, name);
 	INIT_LIST_HEAD(&worker->work_list);
 	INIT_LIST_HEAD(&worker->delayed_work_list);
-	worker->task = NULL;
 }
 EXPORT_SYMBOL_GPL(__kthread_init_worker);
 
@@ -590,6 +590,10 @@ int kthread_worker_fn(void *worker_ptr)
 	 */
 	WARN_ON(worker->task && worker->task != current);
 	worker->task = current;
+
+	if (worker->flags & KTW_FREEZABLE)
+		set_freezable();
+
 repeat:
 	set_current_state(TASK_INTERRUPTIBLE);	/* mb paired w/ kthread_stop */
 
@@ -623,7 +627,8 @@ repeat:
 EXPORT_SYMBOL_GPL(kthread_worker_fn);
 
 static struct kthread_worker *
-__kthread_create_worker(int cpu, const char namefmt[], va_list args)
+__kthread_create_worker(int cpu, unsigned int flags,
+			const char namefmt[], va_list args)
 {
 	struct kthread_worker *worker;
 	struct task_struct *task;
@@ -653,6 +658,7 @@ __kthread_create_worker(int cpu, const c
 	if (IS_ERR(task))
 		goto fail_task;
 
+	worker->flags = flags;
 	worker->task = task;
 	wake_up_process(task);
 	return worker;
@@ -664,6 +670,7 @@ fail_task:
 
 /**
  * kthread_create_worker - create a kthread worker
+ * @flags: flags modifying the default behavior of the worker
  * @namefmt: printf-style name for the kthread worker (task).
  *
  * Returns a pointer to the allocated worker on success, ERR_PTR(-ENOMEM)
@@ -671,13 +678,13 @@ fail_task:
  * when the worker was SIGKILLed.
  */
 struct kthread_worker *
-kthread_create_worker(const char namefmt[], ...)
+kthread_create_worker(unsigned int flags, const char namefmt[], ...)
 {
 	struct kthread_worker *worker;
 	va_list args;
 
 	va_start(args, namefmt);
-	worker = __kthread_create_worker(-1, namefmt, args);
+	worker = __kthread_create_worker(-1, flags, namefmt, args);
 	va_end(args);
 
 	return worker;
@@ -688,6 +695,7 @@ EXPORT_SYMBOL(kthread_create_worker);
  * kthread_create_worker_on_cpu - create a kthread worker and bind it
  *	it to a given CPU and the associated NUMA node.
  * @cpu: CPU number
+ * @flags: flags modifying the default behavior of the worker
  * @namefmt: printf-style name for the kthread worker (task).
  *
  * Use a valid CPU number if you want to bind the kthread worker
@@ -701,13 +709,14 @@ EXPORT_SYMBOL(kthread_create_worker);
  * when the worker was SIGKILLed.
  */
 struct kthread_worker *
-kthread_create_worker_on_cpu(int cpu, const char namefmt[], ...)
+kthread_create_worker_on_cpu(int cpu, unsigned int flags,
+			     const char namefmt[], ...)
 {
 	struct kthread_worker *worker;
 	va_list args;
 
 	va_start(args, namefmt);
-	worker = __kthread_create_worker(cpu, namefmt, args);
+	worker = __kthread_create_worker(cpu, flags, namefmt, args);
 	va_end(args);
 
 	return worker;
_

Patches currently in -mm which might be from pmladek@suse.com are

kthread-rename-probe_kthread_data-to-kthread_probe_data.patch
kthread-kthread-worker-api-cleanup.patch
kthread-smpboot-do-not-park-in-kthread_create_on_cpu.patch
kthread-allow-to-call-__kthread_create_on_node-with-va_list-args.patch
kthread-add-kthread_create_worker.patch
kthread-add-kthread_destroy_worker.patch
kthread-detect-when-a-kthread-work-is-used-by-more-workers.patch
kthread-initial-support-for-delayed-kthread-work.patch
kthread-allow-to-cancel-kthread-work.patch
kthread-allow-to-modify-delayed-kthread-work.patch
kthread-better-support-freezable-kthread-workers.patch

