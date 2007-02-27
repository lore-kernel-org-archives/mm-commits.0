From: akpm@linux-foundation.org
Subject: + workqueue-kill-noautorel-works.patch added to -mm tree
Date: Tue, 27 Feb 2007 13:00:02 -0800
Message-ID: <200702272100.l1RL0667028462@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52032 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878AbXB0VAf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 16:00:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, dhowells@redhat.com


The patch titled
     workqueue: kill NOAUTOREL works
has been added to the -mm tree.  Its filename is
     workqueue-kill-noautorel-works.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: workqueue: kill NOAUTOREL works
From: Oleg Nesterov <oleg@tv-sign.ru>

We don't have any users, and it is not so trivial to use NOAUTOREL works
correctly.  It is better to simplify API.

Delete NOAUTOREL support and rename work_release to work_clear_pending to
avoid a confusion.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/workqueue.h |   64 +++++-------------------------------
 kernel/workqueue.c        |    5 +-
 2 files changed, 11 insertions(+), 58 deletions(-)

diff -puN include/linux/workqueue.h~workqueue-kill-noautorel-works include/linux/workqueue.h
--- a/include/linux/workqueue.h~workqueue-kill-noautorel-works
+++ a/include/linux/workqueue.h
@@ -24,15 +24,13 @@ typedef void (*work_func_t)(struct work_
 struct work_struct {
 	atomic_long_t data;
 #define WORK_STRUCT_PENDING 0		/* T if work item pending execution */
-#define WORK_STRUCT_NOAUTOREL 1		/* F if work item automatically released on exec */
 #define WORK_STRUCT_FLAG_MASK (3UL)
 #define WORK_STRUCT_WQ_DATA_MASK (~WORK_STRUCT_FLAG_MASK)
 	struct list_head entry;
 	work_func_t func;
 };
 
-#define WORK_DATA_INIT(autorelease) \
-	ATOMIC_LONG_INIT((autorelease) << WORK_STRUCT_NOAUTOREL)
+#define WORK_DATA_INIT()	ATOMIC_LONG_INIT(0)
 
 struct delayed_work {
 	struct work_struct work;
@@ -44,14 +42,8 @@ struct execute_work {
 };
 
 #define __WORK_INITIALIZER(n, f) {				\
-	.data = WORK_DATA_INIT(0),				\
-        .entry	= { &(n).entry, &(n).entry },			\
-	.func = (f),						\
-	}
-
-#define __WORK_INITIALIZER_NAR(n, f) {				\
-	.data = WORK_DATA_INIT(1),				\
-        .entry	= { &(n).entry, &(n).entry },			\
+	.data = WORK_DATA_INIT(),				\
+	.entry	= { &(n).entry, &(n).entry },			\
 	.func = (f),						\
 	}
 
@@ -60,23 +52,12 @@ struct execute_work {
 	.timer = TIMER_INITIALIZER(NULL, 0, 0),			\
 	}
 
-#define __DELAYED_WORK_INITIALIZER_NAR(n, f) {			\
-	.work = __WORK_INITIALIZER_NAR((n).work, (f)),		\
-	.timer = TIMER_INITIALIZER(NULL, 0, 0),			\
-	}
-
 #define DECLARE_WORK(n, f)					\
 	struct work_struct n = __WORK_INITIALIZER(n, f)
 
-#define DECLARE_WORK_NAR(n, f)					\
-	struct work_struct n = __WORK_INITIALIZER_NAR(n, f)
-
 #define DECLARE_DELAYED_WORK(n, f)				\
 	struct delayed_work n = __DELAYED_WORK_INITIALIZER(n, f)
 
-#define DECLARE_DELAYED_WORK_NAR(n, f)			\
-	struct dwork_struct n = __DELAYED_WORK_INITIALIZER_NAR(n, f)
-
 /*
  * initialize a work item's function pointer
  */
@@ -95,16 +76,9 @@ struct execute_work {
  * assignment of the work data initializer allows the compiler
  * to generate better code.
  */
-#define INIT_WORK(_work, _func)					\
-	do {							\
-		(_work)->data = (atomic_long_t) WORK_DATA_INIT(0);	\
-		INIT_LIST_HEAD(&(_work)->entry);		\
-		PREPARE_WORK((_work), (_func));			\
-	} while (0)
-
-#define INIT_WORK_NAR(_work, _func)					\
+#define INIT_WORK(_work, _func)						\
 	do {								\
-		(_work)->data = (atomic_long_t) WORK_DATA_INIT(1);	\
+		(_work)->data = (atomic_long_t) WORK_DATA_INIT();	\
 		INIT_LIST_HEAD(&(_work)->entry);			\
 		PREPARE_WORK((_work), (_func));				\
 	} while (0)
@@ -115,12 +89,6 @@ struct execute_work {
 		init_timer(&(_work)->timer);			\
 	} while (0)
 
-#define INIT_DELAYED_WORK_NAR(_work, _func)			\
-	do {							\
-		INIT_WORK_NAR(&(_work)->work, (_func));		\
-		init_timer(&(_work)->timer);			\
-	} while (0)
-
 /**
  * work_pending - Find out whether a work item is currently pending
  * @work: The work item in question
@@ -137,24 +105,10 @@ struct execute_work {
 	work_pending(&(w)->work)
 
 /**
- * work_release - Release a work item under execution
- * @work: The work item to release
- *
- * This is used to release a work item that has been initialised with automatic
- * release mode disabled (WORK_STRUCT_NOAUTOREL is set).  This gives the work
- * function the opportunity to grab auxiliary data from the container of the
- * work_struct before clearing the pending bit as the work_struct may be
- * subject to deallocation the moment the pending bit is cleared.
- *
- * In such a case, this should be called in the work function after it has
- * fetched any data it may require from the containter of the work_struct.
- * After this function has been called, the work_struct may be scheduled for
- * further execution or it may be deallocated unless other precautions are
- * taken.
- *
- * This should also be used to release a delayed work item.
+ * work_clear_pending - for internal use only, mark a work item as not pending
+ * @work: The work item in question
  */
-#define work_release(work) \
+#define work_clear_pending(work) \
 	clear_bit(WORK_STRUCT_PENDING, work_data_bits(work))
 
 
@@ -198,7 +152,7 @@ static inline int cancel_delayed_work(st
 
 	ret = del_timer_sync(&work->timer);
 	if (ret)
-		work_release(&work->work);
+		work_clear_pending(&work->work);
 	return ret;
 }
 
diff -puN kernel/workqueue.c~workqueue-kill-noautorel-works kernel/workqueue.c
--- a/kernel/workqueue.c~workqueue-kill-noautorel-works
+++ a/kernel/workqueue.c
@@ -246,8 +246,7 @@ static void run_workqueue(struct cpu_wor
 		spin_unlock_irq(&cwq->lock);
 
 		BUG_ON(get_wq_data(work) != cwq);
-		if (!test_bit(WORK_STRUCT_NOAUTOREL, work_data_bits(work)))
-			work_release(work);
+		work_clear_pending(work);
 		f(work);
 
 		if (unlikely(in_atomic() || lockdep_depth(current) > 0)) {
@@ -453,7 +452,7 @@ void flush_work(struct workqueue_struct 
 	 */
 	spin_lock_irq(&cwq->lock);
 	list_del_init(&work->entry);
-	work_release(work);
+	work_clear_pending(work);
 	spin_unlock_irq(&cwq->lock);
 
 	for_each_cpu_mask(cpu, *cpu_map)
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

git-cpufreq.patch
drivers-media-video-cpia_ppc-dont-use-_work_nar.patch
bridge-eliminate-port_check-workqueue.patch
git-block.patch
adapt-page_lock_anon_vma-to-preempt_rcu.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
fix-refrigerator-vs-thaw_process-race.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
softlockup-trivial-s-99-max_rt_prio.patch
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
unify-queue_delayed_work-and-queue_delayed_work_on-fix.patch
workqueue-introduce-wq_per_cpu-helper.patch
make-cancel_rearming_delayed_work-work-on-any-workqueue-not-just-keventd_wq.patch
ipvs-flush-defense_work-before-module-unload.patch
workqueue-kill-noautorel-works.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync.patch
____call_usermodehelper-dont-flush_signals.patch
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
