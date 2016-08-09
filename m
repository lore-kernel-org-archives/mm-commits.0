From: akpm@linux-foundation.org
Subject: + kthread-add-kthread_destroy_worker.patch added to -mm tree
Date: Tue, 09 Aug 2016 15:11:08 -0700
Message-ID: <57aa54fc.wna+XFxxZavAIDEg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40272 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932506AbcHIWLK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Aug 2016 18:11:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pmladek@suse.com, bp@suse.de, jkosina@suse.cz, josh@joshtriplett.org, mhocko@suse.cz, mingo@redhat.com, oleg@redhat.com, paulmck@linux.vnet.ibm.com, peterz@infradead.org, rostedt@goodmis.org, tglx@linutronix.de, tj@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: kthread: add kthread_destroy_worker()
has been added to the -mm tree.  Its filename is
     kthread-add-kthread_destroy_worker.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kthread-add-kthread_destroy_worker.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kthread-add-kthread_destroy_worker.patch

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
@@ -819,3 +819,26 @@ void kthread_flush_worker(struct kthread
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

