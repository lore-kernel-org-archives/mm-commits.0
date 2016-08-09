From: akpm@linux-foundation.org
Subject: + kthread-add-kthread_create_worker.patch added to -mm tree
Date: Tue, 09 Aug 2016 15:11:05 -0700
Message-ID: <57aa54f9.HS6wk/GIQNd4Nfxs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40265 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932506AbcHIWLH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Aug 2016 18:11:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pmladek@suse.com, bp@suse.de, jkosina@suse.cz, josh@joshtriplett.org, mhocko@suse.cz, mingo@redhat.com, oleg@redhat.com, paulmck@linux.vnet.ibm.com, peterz@infradead.org, rostedt@goodmis.org, tglx@linutronix.de, tj@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: kthread: add kthread_create_worker*()
has been added to the -mm tree.  Its filename is
     kthread-add-kthread_create_worker.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kthread-add-kthread_create_worker.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kthread-add-kthread_create_worker.patch

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
Subject: kthread: add kthread_create_worker*()

Kthread workers are currently created using the classic kthread API,
namely kthread_run().  kthread_worker_fn() is passed as the @threadfn
parameter.

This patch defines kthread_create_worker() and
kthread_create_worker_on_cpu() functions that hide implementation details.

They enforce using kthread_worker_fn() for the main thread.  But I doubt
that there are any plans to create any alternative.  In fact, I think that
we do not want any alternative main thread because it would be hard to
support consistency with the rest of the kthread worker API.

The naming and function of kthread_create_worker() is inspired by the
workqueues API like the rest of the kthread worker API.

The kthread_create_worker_on_cpu() variant is motivated by the original
kthread_create_on_cpu().  Note that we need to bind per-CPU kthread
workers already when they are created.  It makes the life easier. 
kthread_bind() could not be used later for an already running worker.

This patch does _not_ convert existing kthread workers.  The kthread
worker API need more improvements first, e.g.  a function to destroy the
worker.

IMPORTANT:

kthread_create_worker_on_cpu() allows to use any format of the worker
name, in compare with kthread_create_on_cpu().  The good thing is that it
is more generic.  The bad thing is that most users will need to pass the
cpu number in two parameters, e.g.  kthread_create_worker_on_cpu(cpu,
"helper/%d", cpu).

To be honest, the main motivation was to avoid the need for an empty
va_list.  The only legal way was to create a helper function that would be
called with an empty list.  Other attempts caused compilation warnings or
even errors on different architectures.

There were also other alternatives, for example, using #define or
splitting __kthread_create_worker().  The used solution looked like the
least ugly.

Link: http://lkml.kernel.org/r/1470754545-17632-6-git-send-email-pmladek@suse.com
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

 include/linux/kthread.h |    7 ++
 kernel/kthread.c        |  115 ++++++++++++++++++++++++++++++++++----
 2 files changed, 111 insertions(+), 11 deletions(-)

diff -puN include/linux/kthread.h~kthread-add-kthread_create_worker include/linux/kthread.h
--- a/include/linux/kthread.h~kthread-add-kthread_create_worker
+++ a/include/linux/kthread.h
@@ -124,6 +124,13 @@ extern void __kthread_init_worker(struct
 
 int kthread_worker_fn(void *worker_ptr);
 
+__printf(1, 2)
+struct kthread_worker *
+kthread_create_worker(const char namefmt[], ...);
+
+struct kthread_worker *
+kthread_create_worker_on_cpu(int cpu, const char namefmt[], ...);
+
 bool kthread_queue_work(struct kthread_worker *worker,
 			struct kthread_work *work);
 void kthread_flush_work(struct kthread_work *work);
diff -puN kernel/kthread.c~kthread-add-kthread_create_worker kernel/kthread.c
--- a/kernel/kthread.c~kthread-add-kthread_create_worker
+++ a/kernel/kthread.c
@@ -567,23 +567,24 @@ EXPORT_SYMBOL_GPL(__kthread_init_worker)
  * kthread_worker_fn - kthread function to process kthread_worker
  * @worker_ptr: pointer to initialized kthread_worker
  *
- * This function can be used as @threadfn to kthread_create() or
- * kthread_run() with @worker_ptr argument pointing to an initialized
- * kthread_worker.  The started kthread will process work_list until
- * the it is stopped with kthread_stop().  A kthread can also call
- * this function directly after extra initialization.
- *
- * Different kthreads can be used for the same kthread_worker as long
- * as there's only one kthread attached to it at any given time.  A
- * kthread_worker without an attached kthread simply collects queued
- * kthread_works.
+ * This function implements the main cycle of kthread worker. It processes
+ * work_list until it is stopped with kthread_stop(). It sleeps when the queue
+ * is empty.
+ *
+ * The works are not allowed to keep any locks, disable preemption or interrupts
+ * when they finish. There is defined a safe point for freezing when one work
+ * finishes and before a new one is started.
  */
 int kthread_worker_fn(void *worker_ptr)
 {
 	struct kthread_worker *worker = worker_ptr;
 	struct kthread_work *work;
 
-	WARN_ON(worker->task);
+	/*
+	 * FIXME: Update the check and remove the assignment when all kthread
+	 * worker users are created using kthread_create_worker*() functions.
+	 */
+	WARN_ON(worker->task && worker->task != current);
 	worker->task = current;
 repeat:
 	set_current_state(TASK_INTERRUPTIBLE);	/* mb paired w/ kthread_stop */
@@ -617,6 +618,98 @@ repeat:
 }
 EXPORT_SYMBOL_GPL(kthread_worker_fn);
 
+static struct kthread_worker *
+__kthread_create_worker(int cpu, const char namefmt[], va_list args)
+{
+	struct kthread_worker *worker;
+	struct task_struct *task;
+
+	worker = kzalloc(sizeof(*worker), GFP_KERNEL);
+	if (!worker)
+		return ERR_PTR(-ENOMEM);
+
+	kthread_init_worker(worker);
+
+	if (cpu >= 0) {
+		char name[TASK_COMM_LEN];
+
+		/*
+		 * kthread_create_worker_on_cpu() allows to pass a generic
+		 * namefmt in compare with kthread_create_on_cpu. We need
+		 * to format it here.
+		 */
+		vsnprintf(name, sizeof(name), namefmt, args);
+		task = kthread_create_on_cpu(kthread_worker_fn, worker,
+					     cpu, name);
+	} else {
+		task = __kthread_create_on_node(kthread_worker_fn, worker,
+						-1, namefmt, args);
+	}
+
+	if (IS_ERR(task))
+		goto fail_task;
+
+	worker->task = task;
+	wake_up_process(task);
+	return worker;
+
+fail_task:
+	kfree(worker);
+	return ERR_CAST(task);
+}
+
+/**
+ * kthread_create_worker - create a kthread worker
+ * @namefmt: printf-style name for the kthread worker (task).
+ *
+ * Returns a pointer to the allocated worker on success, ERR_PTR(-ENOMEM)
+ * when the needed structures could not get allocated, and ERR_PTR(-EINTR)
+ * when the worker was SIGKILLed.
+ */
+struct kthread_worker *
+kthread_create_worker(const char namefmt[], ...)
+{
+	struct kthread_worker *worker;
+	va_list args;
+
+	va_start(args, namefmt);
+	worker = __kthread_create_worker(-1, namefmt, args);
+	va_end(args);
+
+	return worker;
+}
+EXPORT_SYMBOL(kthread_create_worker);
+
+/**
+ * kthread_create_worker_on_cpu - create a kthread worker and bind it
+ *	it to a given CPU and the associated NUMA node.
+ * @cpu: CPU number
+ * @namefmt: printf-style name for the kthread worker (task).
+ *
+ * Use a valid CPU number if you want to bind the kthread worker
+ * to the given CPU and the associated NUMA node.
+ *
+ * A good practice is to add the cpu number also into the worker name.
+ * For example, use kthread_create_worker_on_cpu(cpu, "helper/%d", cpu).
+ *
+ * Returns a pointer to the allocated worker on success, ERR_PTR(-ENOMEM)
+ * when the needed structures could not get allocated, and ERR_PTR(-EINTR)
+ * when the worker was SIGKILLed.
+ */
+struct kthread_worker *
+kthread_create_worker_on_cpu(int cpu, const char namefmt[], ...)
+{
+	struct kthread_worker *worker;
+	va_list args;
+
+	va_start(args, namefmt);
+	worker = __kthread_create_worker(cpu, namefmt, args);
+	va_end(args);
+
+	return worker;
+}
+EXPORT_SYMBOL(kthread_create_worker_on_cpu);
+
 /* insert @work before @pos in @worker */
 static void kthread_insert_work(struct kthread_worker *worker,
 			       struct kthread_work *work,
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

