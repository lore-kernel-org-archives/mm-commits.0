From: akpm@linux-foundation.org
Subject: + move-frozen_process-to-kernel-power-processc.patch added to -mm tree
Date: Fri, 27 Apr 2007 18:02:27 -0700
Message-ID: <200704280102.l3S12REx012079@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55883 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030190AbXD1BDY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 21:03:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ego@in.ibm.com, oleg@tv-sign.ru, rjw@sisk.pl


The patch titled
     Move frozen_process() to kernel/power/process.c
has been added to the -mm tree.  Its filename is
     move-frozen_process-to-kernel-power-processc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Move frozen_process() to kernel/power/process.c
From: Gautham R Shenoy <ego@in.ibm.com>

Other than refrigerator, no one else calls frozen_process(). So move it
from include/linux/freezer.h to kernel/power/process.c.

Also, since a task can be marked frozen by itself, we don't need to pass
the (struct task_struct *p) parameter to frozen_process().

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/freezer.h |   13 -------------
 kernel/power/process.c  |   14 +++++++++++++-
 2 files changed, 13 insertions(+), 14 deletions(-)

diff -puN include/linux/freezer.h~move-frozen_process-to-kernel-power-processc include/linux/freezer.h
--- a/include/linux/freezer.h~move-frozen_process-to-kernel-power-processc
+++ a/include/linux/freezer.h
@@ -58,18 +58,6 @@ static inline int thaw_process(struct ta
 	return 0;
 }
 
-/*
- * freezing is complete, mark process as frozen
- */
-static inline void frozen_process(struct task_struct *p)
-{
-	if (!unlikely(p->flags & PF_NOFREEZE)) {
-		p->flags |= PF_FROZEN;
-		wmb();
-	}
-	clear_tsk_thread_flag(p, TIF_FREEZE);
-}
-
 extern void refrigerator(void);
 extern int freeze_processes(void);
 extern void thaw_processes(void);
@@ -132,7 +120,6 @@ static inline int frozen(struct task_str
 static inline int freezing(struct task_struct *p) { return 0; }
 static inline void freeze(struct task_struct *p) { BUG(); }
 static inline int thaw_process(struct task_struct *p) { return 1; }
-static inline void frozen_process(struct task_struct *p) { BUG(); }
 
 static inline void refrigerator(void) {}
 static inline int freeze_processes(void) { BUG(); return 0; }
diff -puN kernel/power/process.c~move-frozen_process-to-kernel-power-processc kernel/power/process.c
--- a/kernel/power/process.c~move-frozen_process-to-kernel-power-processc
+++ a/kernel/power/process.c
@@ -32,6 +32,18 @@ static inline int freezeable(struct task
 	return 1;
 }
 
+/*
+ * freezing is complete, mark current process as frozen
+ */
+static inline void frozen_process(void)
+{
+	if (!unlikely(current->flags & PF_NOFREEZE)) {
+		current->flags |= PF_FROZEN;
+		wmb();
+	}
+	clear_tsk_thread_flag(current, TIF_FREEZE);
+}
+
 /* Refrigerator is place where frozen processes are stored :-). */
 void refrigerator(void)
 {
@@ -41,7 +53,7 @@ void refrigerator(void)
 
 	task_lock(current);
 	if (freezing(current)) {
-		frozen_process(current);
+		frozen_process();
 		task_unlock(current);
 	} else {
 		task_unlock(current);
_

Patches currently in -mm which might be from ego@in.ibm.com are

i386-avoid-checking-for-cpu-gone-when-config_hotplug_cpu-not-defined.patch
flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch
flush_cpu_workqueue-dont-flush-an-empty-worklist.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed.patch
slab-use-cpu_lock_.patch
workqueue-fix-freezeable-workqueues-implementation.patch
workqueue-fix-flush_workqueue-vs-cpu_dead-race.patch
workqueue-dont-clear-cwq-thread-until-it-exits.patch
workqueue-dont-migrate-pending-works-from-the-dead-cpu.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
fix-kthread_create-vs-freezer-theoretical-race-dont-be-obnoxious.patch
fix-pf_nofreeze-and-freezeable-race-2.patch
freezer-document-task_lock-in-thaw_process.patch
move-frozen_process-to-kernel-power-processc.patch
add-suspend-related-notifications-for-cpu-hotplug.patch
microcode-use-suspend-related-cpu-hotplug-notifications.patch
