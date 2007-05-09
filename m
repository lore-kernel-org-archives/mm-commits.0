From: akpm@linux-foundation.org
Subject: - make-cancel_rearming_delayed_work-work-on-any-workqueue-not-just-keventd_wq.patch removed from -mm tree
Date: Wed, 09 May 2007 14:52:03 -0700
Message-ID: <200705092152.l49Lq3sO002961@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33481 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758849AbXEIVw0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:52:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     make cancel_rearming_delayed_work() work on any workqueue, not just keventd_wq
has been removed from the -mm tree.  Its filename was
     make-cancel_rearming_delayed_work-work-on-any-workqueue-not-just-keventd_wq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: make cancel_rearming_delayed_work() work on any workqueue, not just keventd_wq
From: Oleg Nesterov <oleg@tv-sign.ru>

cancel_rearming_delayed_workqueue(wq, dwork) doesn't need the first
parameter.  We don't hang on un-queued dwork any longer, and work->data
doesn't change its type.  This means we can always figure out "wq" from
dwork when it is needed.

Remove this parameter, and rename the function to
cancel_rearming_delayed_work().  Re-create an inline "obsolete"
cancel_rearming_delayed_workqueue(wq) which just calls
cancel_rearming_delayed_work().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/workqueue.h |   13 ++++++++++---
 kernel/workqueue.c        |   27 +++++++++------------------
 2 files changed, 19 insertions(+), 21 deletions(-)

diff -puN include/linux/workqueue.h~make-cancel_rearming_delayed_work-work-on-any-workqueue-not-just-keventd_wq include/linux/workqueue.h
--- a/include/linux/workqueue.h~make-cancel_rearming_delayed_work-work-on-any-workqueue-not-just-keventd_wq
+++ a/include/linux/workqueue.h
@@ -191,9 +191,6 @@ extern int current_is_keventd(void);
 extern int keventd_up(void);
 
 extern void init_workqueues(void);
-void cancel_rearming_delayed_work(struct delayed_work *work);
-void cancel_rearming_delayed_workqueue(struct workqueue_struct *,
-				       struct delayed_work *);
 int execute_in_process_context(work_func_t fn, struct execute_work *);
 
 /*
@@ -212,4 +209,14 @@ static inline int cancel_delayed_work(st
 	return ret;
 }
 
+extern void cancel_rearming_delayed_work(struct delayed_work *work);
+
+/* Obsolete. use cancel_rearming_delayed_work() */
+static inline
+void cancel_rearming_delayed_workqueue(struct workqueue_struct *wq,
+					struct delayed_work *work)
+{
+	cancel_rearming_delayed_work(work);
+}
+
 #endif
diff -puN kernel/workqueue.c~make-cancel_rearming_delayed_work-work-on-any-workqueue-not-just-keventd_wq kernel/workqueue.c
--- a/kernel/workqueue.c~make-cancel_rearming_delayed_work-work-on-any-workqueue-not-just-keventd_wq
+++ a/kernel/workqueue.c
@@ -555,32 +555,23 @@ void flush_work_keventd(struct work_stru
 EXPORT_SYMBOL(flush_work_keventd);
 
 /**
- * cancel_rearming_delayed_workqueue - kill off a delayed work whose handler rearms the delayed work.
- * @wq:   the controlling workqueue structure
+ * cancel_rearming_delayed_work - kill off a delayed work whose handler rearms the delayed work.
  * @dwork: the delayed work struct
  *
  * Note that the work callback function may still be running on return from
  * cancel_delayed_work(). Run flush_workqueue() or flush_work() to wait on it.
  */
-void cancel_rearming_delayed_workqueue(struct workqueue_struct *wq,
-				       struct delayed_work *dwork)
+void cancel_rearming_delayed_work(struct delayed_work *dwork)
 {
-	/* Was it ever queued ? */
-	if (!get_wq_data(&dwork->work))
-		return;
+	struct cpu_workqueue_struct *cwq = get_wq_data(&dwork->work);
 
-	while (!cancel_delayed_work(dwork))
-		flush_workqueue(wq);
-}
-EXPORT_SYMBOL(cancel_rearming_delayed_workqueue);
+	/* Was it ever queued ? */
+	if (cwq != NULL) {
+		struct workqueue_struct *wq = cwq->wq;
 
-/**
- * cancel_rearming_delayed_work - kill off a delayed keventd work whose handler rearms the delayed work.
- * @dwork: the delayed work struct
- */
-void cancel_rearming_delayed_work(struct delayed_work *dwork)
-{
-	cancel_rearming_delayed_workqueue(keventd_wq, dwork);
+		while (!cancel_delayed_work(dwork))
+			flush_workqueue(wq);
+	}
 }
 EXPORT_SYMBOL(cancel_rearming_delayed_work);
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
nlmclnt_recovery-dont-use-clone_sighand.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
fix-pf_nofreeze-and-freezeable-race-2.patch
freezer-document-task_lock-in-thaw_process.patch
move-frozen_process-to-kernel-power-processc.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
libata-core-convert-to-use-cancel_rearming_delayed_work.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
getrusage-fill-ru_inblock-and-ru_oublock-fields-if-possible.patch
dont-init-pgrp-and-__session-in-init_signals.patch
