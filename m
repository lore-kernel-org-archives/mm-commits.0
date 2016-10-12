From: akpm@linux-foundation.org
Subject: [merged] kthread-allow-to-modify-delayed-kthread-work.patch
 removed from -mm tree
Date: Wed, 12 Oct 2016 12:26:27 -0700
Message-ID: <57fe8e63.2zJbiMMlY7/ikhYG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33861 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755565AbcJLT1k (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:27:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pmladek@suse.com, bp@suse.de, jkosina@suse.cz, josh@joshtriplett.org, mhocko@suse.cz, mingo@redhat.com, oleg@redhat.com, paulmck@linux.vnet.ibm.com, peterz@infradead.org, rostedt@goodmis.org, tglx@linutronix.de, tj@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: kthread: allow to modify delayed kthread work
has been removed from the -mm tree.  Its filename was
     kthread-allow-to-modify-delayed-kthread-work.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Petr Mladek <pmladek@suse.com>
Subject: kthread: allow to modify delayed kthread work

There are situations when we need to modify the delay of a delayed kthread
work. For example, when the work depends on an event and the initial delay
means a timeout. Then we want to queue the work immediately when the event
happens.

This patch implements kthread_mod_delayed_work() as inspired workqueues.
It cancels the timer, removes the work from any worker list and queues it
again with the given timeout.

A very special case is when the work is being canceled at the same time.
It might happen because of the regular kthread_cancel_delayed_work_sync()
or by another kthread_mod_delayed_work(). In this case, we do nothing and
let the other operation win. This should not normally happen as the caller
is supposed to synchronize these operations a reasonable way.

Link: http://lkml.kernel.org/r/1470754545-17632-11-git-send-email-pmladek@suse.com
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

 include/linux/kthread.h |    4 ++
 kernel/kthread.c        |   53 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+)

diff -puN include/linux/kthread.h~kthread-allow-to-modify-delayed-kthread-work include/linux/kthread.h
--- a/include/linux/kthread.h~kthread-allow-to-modify-delayed-kthread-work
+++ a/include/linux/kthread.h
@@ -168,6 +168,10 @@ bool kthread_queue_delayed_work(struct k
 				struct kthread_delayed_work *dwork,
 				unsigned long delay);
 
+bool kthread_mod_delayed_work(struct kthread_worker *worker,
+			      struct kthread_delayed_work *dwork,
+			      unsigned long delay);
+
 void kthread_flush_work(struct kthread_work *work);
 void kthread_flush_worker(struct kthread_worker *worker);
 
diff -puN kernel/kthread.c~kthread-allow-to-modify-delayed-kthread-work kernel/kthread.c
--- a/kernel/kthread.c~kthread-allow-to-modify-delayed-kthread-work
+++ a/kernel/kthread.c
@@ -976,6 +976,59 @@ static bool __kthread_cancel_work(struct
 	return false;
 }
 
+/**
+ * kthread_mod_delayed_work - modify delay of or queue a kthread delayed work
+ * @worker: kthread worker to use
+ * @dwork: kthread delayed work to queue
+ * @delay: number of jiffies to wait before queuing
+ *
+ * If @dwork is idle, equivalent to kthread_queue_delayed_work(). Otherwise,
+ * modify @dwork's timer so that it expires after @delay. If @delay is zero,
+ * @work is guaranteed to be queued immediately.
+ *
+ * Return: %true if @dwork was pending and its timer was modified,
+ * %false otherwise.
+ *
+ * A special case is when the work is being canceled in parallel.
+ * It might be caused either by the real kthread_cancel_delayed_work_sync()
+ * or yet another kthread_mod_delayed_work() call. We let the other command
+ * win and return %false here. The caller is supposed to synchronize these
+ * operations a reasonable way.
+ *
+ * This function is safe to call from any context including IRQ handler.
+ * See __kthread_cancel_work() and kthread_delayed_work_timer_fn()
+ * for details.
+ */
+bool kthread_mod_delayed_work(struct kthread_worker *worker,
+			      struct kthread_delayed_work *dwork,
+			      unsigned long delay)
+{
+	struct kthread_work *work = &dwork->work;
+	unsigned long flags;
+	int ret = false;
+
+	spin_lock_irqsave(&worker->lock, flags);
+
+	/* Do not bother with canceling when never queued. */
+	if (!work->worker)
+		goto fast_queue;
+
+	/* Work must not be used with >1 worker, see kthread_queue_work() */
+	WARN_ON_ONCE(work->worker != worker);
+
+	/* Do not fight with another command that is canceling this work. */
+	if (work->canceling)
+		goto out;
+
+	ret = __kthread_cancel_work(work, true, &flags);
+fast_queue:
+	__kthread_queue_delayed_work(worker, dwork, delay);
+out:
+	spin_unlock_irqrestore(&worker->lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kthread_mod_delayed_work);
+
 static bool __kthread_cancel_work_sync(struct kthread_work *work, bool is_dwork)
 {
 	struct kthread_worker *worker = work->worker;
_

Patches currently in -mm which might be from pmladek@suse.com are


