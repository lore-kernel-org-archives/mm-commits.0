From: akpm@linux-foundation.org
Subject: - freezer-move-frozen_process-to-kernel-power-processc.patch removed from -mm tree
Date: Tue, 29 May 2007 11:50:20 -0700
Message-ID: <200705291850.l4TIoJRN008253@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752209AbXE2SvF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:51:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ego@in.ibm.com, ebiederm@xmission.com, oleg@tv-sign.ru, pavel@ucw.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     freezer: move frozen_process() to kernel/power/process.c
has been removed from the -mm tree.  Its filename was
     freezer-move-frozen_process-to-kernel-power-processc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: freezer: move frozen_process() to kernel/power/process.c
From: Gautham R Shenoy <ego@in.ibm.com>

Other than refrigerator, no one else calls frozen_process().  So move it from
include/linux/freezer.h to kernel/power/process.c.

Also, since a task can be marked as frozen by itself, we don't need to pass
the (struct task_struct *p) parameter to frozen_process().

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/freezer.h |   13 -------------
 kernel/power/process.c  |   14 +++++++++++++-
 2 files changed, 13 insertions(+), 14 deletions(-)

diff -puN include/linux/freezer.h~freezer-move-frozen_process-to-kernel-power-processc include/linux/freezer.h
--- a/include/linux/freezer.h~freezer-move-frozen_process-to-kernel-power-processc
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
diff -puN kernel/power/process.c~freezer-move-frozen_process-to-kernel-power-processc kernel/power/process.c
--- a/kernel/power/process.c~freezer-move-frozen_process-to-kernel-power-processc
+++ a/kernel/power/process.c
@@ -31,6 +31,18 @@ static inline int freezeable(struct task
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
@@ -40,7 +52,7 @@ void refrigerator(void)
 
 	task_lock(current);
 	if (freezing(current)) {
-		frozen_process(current);
+		frozen_process();
 		task_unlock(current);
 	} else {
 		task_unlock(current);
_

Patches currently in -mm which might be from ego@in.ibm.com are

fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
