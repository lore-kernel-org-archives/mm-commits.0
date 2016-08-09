From: akpm@linux-foundation.org
Subject: +
 kthread-detect-when-a-kthread-work-is-used-by-more-workers.patch added to
 -mm tree
Date: Tue, 09 Aug 2016 15:11:10 -0700
Message-ID: <57aa54fe.p8n3EmwrKiH7qUNB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40283 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932506AbcHIWLM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Aug 2016 18:11:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pmladek@suse.com, bp@suse.de, jkosina@suse.cz, josh@joshtriplett.org, mhocko@suse.cz, mingo@redhat.com, oleg@redhat.com, paulmck@linux.vnet.ibm.com, peterz@infradead.org, rostedt@goodmis.org, tglx@linutronix.de, tj@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: kthread: detect when a kthread work is used by more workers
has been added to the -mm tree.  Its filename is
     kthread-detect-when-a-kthread-work-is-used-by-more-workers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kthread-detect-when-a-kthread-work-is-used-by-more-workers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kthread-detect-when-a-kthread-work-is-used-by-more-workers.patch

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
Subject: kthread: detect when a kthread work is used by more workers

Nothing currently prevents a work from queuing for a kthread worker when
it is already running on another one.  This means that the work might run
in parallel on more than one worker.  Also some operations are not
reliable, e.g.  flush.

This problem will be even more visible after we add kthread_cancel_work()
function.  It will only have "work" as the parameter and will use
worker->lock to synchronize with others.

Well, normally this is not a problem because the API users are sane.
But bugs might happen and users also might be crazy.

This patch adds a warning when we try to insert the work for another
worker.  It does not fully prevent the misuse because it would make the
code much more complicated without a big benefit.

It adds the same warning also into kthread_flush_work() instead of the
repeated attempts to get the right lock.

A side effect is that one needs to explicitly reinitialize the work if it
must be queued into another worker.  This is needed, for example, when the
worker is stopped and started again.  It is a bit inconvenient.  But it
looks like a good compromise between the stability and complexity.

I have double checked all existing users of the kthread worker API and
they all seems to initialize the work after the worker gets started.

Just for completeness, the patch adds a check that the work is not already
in a queue.

The patch also puts all the checks into a separate function.  It will be
reused when implementing delayed works.

Link: http://lkml.kernel.org/r/1470754545-17632-8-git-send-email-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
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

 kernel/kthread.c |   28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff -puN kernel/kthread.c~kthread-detect-when-a-kthread-work-is-used-by-more-workers kernel/kthread.c
--- a/kernel/kthread.c~kthread-detect-when-a-kthread-work-is-used-by-more-workers
+++ a/kernel/kthread.c
@@ -574,6 +574,9 @@ EXPORT_SYMBOL_GPL(__kthread_init_worker)
  * The works are not allowed to keep any locks, disable preemption or interrupts
  * when they finish. There is defined a safe point for freezing when one work
  * finishes and before a new one is started.
+ *
+ * Also the works must not be handled by more than one worker at the same time,
+ * see also kthread_queue_work().
  */
 int kthread_worker_fn(void *worker_ptr)
 {
@@ -710,12 +713,21 @@ kthread_create_worker_on_cpu(int cpu, co
 }
 EXPORT_SYMBOL(kthread_create_worker_on_cpu);
 
+static void kthread_insert_work_sanity_check(struct kthread_worker *worker,
+					     struct kthread_work *work)
+{
+	lockdep_assert_held(&worker->lock);
+	WARN_ON_ONCE(!list_empty(&work->node));
+	/* Do not use a work with >1 worker, see kthread_queue_work() */
+	WARN_ON_ONCE(work->worker && work->worker != worker);
+}
+
 /* insert @work before @pos in @worker */
 static void kthread_insert_work(struct kthread_worker *worker,
-			       struct kthread_work *work,
-			       struct list_head *pos)
+				struct kthread_work *work,
+				struct list_head *pos)
 {
-	lockdep_assert_held(&worker->lock);
+	kthread_insert_work_sanity_check(worker, work);
 
 	list_add_tail(&work->node, pos);
 	work->worker = worker;
@@ -731,6 +743,9 @@ static void kthread_insert_work(struct k
  * Queue @work to work processor @task for async execution.  @task
  * must have been created with kthread_worker_create().  Returns %true
  * if @work was successfully queued, %false if it was already pending.
+ *
+ * Reinitialize the work if it needs to be used by another worker.
+ * For example, when the worker was stopped and started again.
  */
 bool kthread_queue_work(struct kthread_worker *worker,
 			struct kthread_work *work)
@@ -775,16 +790,13 @@ void kthread_flush_work(struct kthread_w
 	struct kthread_worker *worker;
 	bool noop = false;
 
-retry:
 	worker = work->worker;
 	if (!worker)
 		return;
 
 	spin_lock_irq(&worker->lock);
-	if (work->worker != worker) {
-		spin_unlock_irq(&worker->lock);
-		goto retry;
-	}
+	/* Work must not be used with >1 worker, see kthread_queue_work(). */
+	WARN_ON_ONCE(work->worker != worker);
 
 	if (!list_empty(&work->node))
 		kthread_insert_work(worker, &fwork.work, work->node.next);
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

