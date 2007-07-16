From: akpm@linux-foundation.org
Subject: - rename-cancel_rearming_delayed_work-to-cancel_delayed_work_sync.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:58:55 -0700
Message-ID: <200707162058.l6GKwtsD002379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41209 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760433AbXGPVP0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:15:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, jarkao2@o2.pl, mm-commits@vger.kernel.org


The patch titled
     rename cancel_rearming_delayed_work() to cancel_delayed_work_sync()
has been removed from the -mm tree.  Its filename was
     rename-cancel_rearming_delayed_work-to-cancel_delayed_work_sync.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rename cancel_rearming_delayed_work() to cancel_delayed_work_sync()
From: Oleg Nesterov <oleg@tv-sign.ru>

Imho, the current naming of cancel_xxx workqueue functions is very confusing.

	cancel_delayed_work()
	cancel_rearming_delayed_work()
	cancel_rearming_delayed_workqueue()	// obsolete

	cancel_work_sync()

This looks as if the first 2 functions differ in "type" of their argument
which is not true any longer, nowadays the difference is the behaviour.

The semantics of cancel_rearming_delayed_work(dwork) was changed
significantly, it doesn't require that dwork rearms itself, and cancels dwork
synchronously.

Rename it to cancel_delayed_work_sync().  This matches cancel_delayed_work()
and cancel_work_sync().  Re-create cancel_rearming_delayed_work() as a simple
inline obsolete wrapper, like cancel_rearming_delayed_workqueue().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Jarek Poplawski <jarkao2@o2.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/workqueue.h |   13 ++++++++++---
 kernel/workqueue.c        |    6 +++---
 2 files changed, 13 insertions(+), 6 deletions(-)

diff -puN include/linux/workqueue.h~rename-cancel_rearming_delayed_work-to-cancel_delayed_work_sync include/linux/workqueue.h
--- a/include/linux/workqueue.h~rename-cancel_rearming_delayed_work-to-cancel_delayed_work_sync
+++ a/include/linux/workqueue.h
@@ -166,14 +166,21 @@ static inline int cancel_delayed_work(st
 	return ret;
 }
 
-extern void cancel_rearming_delayed_work(struct delayed_work *work);
+extern void cancel_delayed_work_sync(struct delayed_work *work);
 
-/* Obsolete. use cancel_rearming_delayed_work() */
+/* Obsolete. use cancel_delayed_work_sync() */
 static inline
 void cancel_rearming_delayed_workqueue(struct workqueue_struct *wq,
 					struct delayed_work *work)
 {
-	cancel_rearming_delayed_work(work);
+	cancel_delayed_work_sync(work);
+}
+
+/* Obsolete. use cancel_delayed_work_sync() */
+static inline
+void cancel_rearming_delayed_work(struct delayed_work *work)
+{
+	cancel_delayed_work_sync(work);
 }
 
 #endif
diff -puN kernel/workqueue.c~rename-cancel_rearming_delayed_work-to-cancel_delayed_work_sync kernel/workqueue.c
--- a/kernel/workqueue.c~rename-cancel_rearming_delayed_work-to-cancel_delayed_work_sync
+++ a/kernel/workqueue.c
@@ -486,13 +486,13 @@ void cancel_work_sync(struct work_struct
 EXPORT_SYMBOL_GPL(cancel_work_sync);
 
 /**
- * cancel_rearming_delayed_work - reliably kill off a delayed work.
+ * cancel_delayed_work_sync - reliably kill off a delayed work.
  * @dwork: the delayed work struct
  *
  * It is possible to use this function if @dwork rearms itself via queue_work()
  * or queue_delayed_work(). See also the comment for cancel_work_sync().
  */
-void cancel_rearming_delayed_work(struct delayed_work *dwork)
+void cancel_delayed_work_sync(struct delayed_work *dwork)
 {
 	while (!del_timer(&dwork->timer) &&
 	       !try_to_grab_pending(&dwork->work))
@@ -500,7 +500,7 @@ void cancel_rearming_delayed_work(struct
 	wait_on_work(&dwork->work);
 	work_clear_pending(&dwork->work);
 }
-EXPORT_SYMBOL(cancel_rearming_delayed_work);
+EXPORT_SYMBOL(cancel_delayed_work_sync);
 
 static struct workqueue_struct *keventd_wq __read_mostly;
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
freezer-make-kernel-threads-nonfreezable-by-default.patch
freezer-run-show_state-when-freezing-times-out.patch
hibernation-prepare-to-enter-the-low-power-state.patch
freezer-avoid-freezing-kernel-threads-prematurely.patch
freezer-use-__set_current_state-in-refrigerator.patch
freezer-return-int-from-freeze_processes.patch
freezer-remove-redundant-check-in-try_to_freeze_tasks.patch
pm-prevent-frozen-user-mode-helpers-from-failing-the-freezing-of-tasks-rev-2.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
destroy_workqueue-can-livelock.patch
