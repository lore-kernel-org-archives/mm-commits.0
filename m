From: akpm@linux-foundation.org
Subject: + make-cancel_rearming_delayed_work-work-on-any-workqueue-not-just-keventd_wq.patch added to -mm tree
Date: Mon, 12 Feb 2007 22:41:00 -0800
Message-ID: <200702130641.l1D6f0EB024139@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56486 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161104AbXBMGlL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 01:41:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru


The patch titled
     make cancel_rearming_delayed_work() work on any workqueue, not just keventd_wq
has been added to the -mm tree.  Its filename is
     make-cancel_rearming_delayed_work-work-on-any-workqueue-not-just-keventd_wq.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -185,9 +185,6 @@ extern int current_is_keventd(void);
 extern int keventd_up(void);
 
 extern void init_workqueues(void);
-void cancel_rearming_delayed_work(struct delayed_work *work);
-void cancel_rearming_delayed_workqueue(struct workqueue_struct *,
-				       struct delayed_work *);
 int execute_in_process_context(work_func_t fn, struct execute_work *);
 
 /*
@@ -205,4 +202,14 @@ static inline int cancel_delayed_work(st
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
@@ -554,32 +554,23 @@ void flush_work_keventd(struct work_stru
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
git-block.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
posix-timers-rcu-optimization-for-clock_gettime.patch
posix-timers-rcu-optimization-for-clock_gettime-fix.patch
reimplement-flush_workqueue.patch
implement-flush_work.patch
implement-flush_work-sanity.patch
implement-flush_work_keventd.patch
flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch
flush_cpu_workqueue-dont-flush-an-empty-worklist.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed.patch
slab-use-cpu_lock_.patch
workqueue-fix-freezeable-workqueues-implementation.patch
workqueue-fix-flush_workqueue-vs-cpu_dead-race.patch
workqueue-dont-clear-cwq-thread-until-it-exits.patch
workqueue-dont-migrate-pending-works-from-the-dead-cpu.patch
workqueue-kill-run_scheduled_work.patch
workqueue-dont-save-interrupts-in-run_workqueue.patch
workqueue-dont-save-interrupts-in-run_workqueue-update-2.patch
workqueue-make-cancel_rearming_delayed_workqueue-work-on-idle-dwork.patch
workqueue-introduce-cpu_singlethread_map.patch
workqueue-introduce-workqueue_struct-singlethread.patch
workqueue-make-init_workqueues-__init.patch
make-queue_delayed_work-friendly-to-flush_fork.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
make-cancel_rearming_delayed_work-work-on-any-workqueue-not-just-keventd_wq.patch
ipvs-flush-defense_work-before-module-unload.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
rework-compat_sys_io_submit.patch
fix-aioh-includes.patch
fix-access_ok-checks.patch
make-good_sigevent-non-static.patch
make-good_sigevent-non-static-fix.patch
make-__sigqueue_free-and.patch
aio-completion-signal-notification.patch
aio-completion-signal-notification-fix.patch
aio-completion-signal-notification-fixes-and-cleanups.patch
aio-completion-signal-notification-small-cleanup.patch
add-listio-syscall-support.patch
