From: akpm@linux-foundation.org
Subject: [patch 092/102] kthread: add kthread_destroy_worker()
Date: Tue, 11 Oct 2016 13:55:33 -0700
Message-ID: <57fd51c5.voaU9G2nGW6ciAvG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38488 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752449AbcJKU5W (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:57:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, pmladek@suse.com, bp@suse.de, jkosina@suse.cz, josh@joshtriplett.org, mhocko@suse.cz, mingo@redhat.com, oleg@redhat.com, paulmck@linux.vnet.ibm.com, peterz@infradead.org, rostedt@goodmis.org, tglx@linutronix.de, tj@kernel.org, vbabka@suse.cz

From: Petr Mladek <pmladek@suse.com>
Subject: kthread: add kthread_destroy_worker()

The current kthread worker users call flush() and stop() explicitly.
This function does the same plus it frees the kthread_worker struct
in one call.

It is supposed to be used together with kthread_create_worker*() that
allocates struct kthread_worker.

Link: http://lkml.kernel.org/r/1470754545-17632-7-git-send-email-pmladek@suse.com
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

 include/linux/kthread.h |    2 ++
 kernel/kthread.c        |   23 +++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff -puN include/linux/kthread.h~kthread-add-kthread_destroy_worker include/linux/kthread.h
--- a/include/linux/kthread.h~kthread-add-kthread_destroy_worker
+++ a/include/linux/kthread.h
@@ -136,4 +136,6 @@ bool kthread_queue_work(struct kthread_w
 void kthread_flush_work(struct kthread_work *work);
 void kthread_flush_worker(struct kthread_worker *worker);
 
+void kthread_destroy_worker(struct kthread_worker *worker);
+
 #endif /* _LINUX_KTHREAD_H */
diff -puN kernel/kthread.c~kthread-add-kthread_destroy_worker kernel/kthread.c
--- a/kernel/kthread.c~kthread-add-kthread_destroy_worker
+++ a/kernel/kthread.c
@@ -823,3 +823,26 @@ void kthread_flush_worker(struct kthread
 	wait_for_completion(&fwork.done);
 }
 EXPORT_SYMBOL_GPL(kthread_flush_worker);
+
+/**
+ * kthread_destroy_worker - destroy a kthread worker
+ * @worker: worker to be destroyed
+ *
+ * Flush and destroy @worker.  The simple flush is enough because the kthread
+ * worker API is used only in trivial scenarios.  There are no multi-step state
+ * machines needed.
+ */
+void kthread_destroy_worker(struct kthread_worker *worker)
+{
+	struct task_struct *task;
+
+	task = worker->task;
+	if (WARN_ON(!task))
+		return;
+
+	kthread_flush_worker(worker);
+	kthread_stop(task);
+	WARN_ON(!list_empty(&worker->work_list));
+	kfree(worker);
+}
+EXPORT_SYMBOL(kthread_destroy_worker);
_
