From: akpm@linux-foundation.org
Subject: + kernel-cpuc-document-clear_tasks_mm_cpumask.patch added to -mm tree
Date: Tue, 08 May 2012 16:32:26 -0700
Message-ID: <20120508233226.98755A03B2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:38207 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab2EHXc2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2012 19:32:28 -0400
Received: by wgbdt11 with SMTP id dt11so385145wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 08 May 2012 16:32:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anton.vorontsov@linaro.org, a.p.zijlstra@chello.nl, akpm@linux-foundation.org


The patch titled
     Subject: kernel/cpu.c: document clear_tasks_mm_cpumask()
has been added to the -mm tree.  Its filename is
     kernel-cpuc-document-clear_tasks_mm_cpumask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: kernel/cpu.c: document clear_tasks_mm_cpumask()

Add more comments on clear_tasks_mm_cpumask, plus adds a runtime check:
the function is only suitable for offlined CPUs, and if called
inappropriately, the kernel should scream aloud.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpu.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN kernel/cpu.c~kernel-cpuc-document-clear_tasks_mm_cpumask kernel/cpu.c
--- a/kernel/cpu.c~kernel-cpuc-document-clear_tasks_mm_cpumask
+++ a/kernel/cpu.c
@@ -13,6 +13,7 @@
 #include <linux/oom.h>
 #include <linux/rcupdate.h>
 #include <linux/export.h>
+#include <linux/bug.h>
 #include <linux/kthread.h>
 #include <linux/stop_machine.h>
 #include <linux/mutex.h>
@@ -173,6 +174,18 @@ void __ref unregister_cpu_notifier(struc
 }
 EXPORT_SYMBOL(unregister_cpu_notifier);
 
+/**
+ * clear_tasks_mm_cpumask - Safely clear tasks' mm_cpumask for a CPU
+ * @cpu: a CPU id
+ *
+ * This function walks up all processes, finds a valid mm struct for
+ * each one and then clears a corresponding bit in mm's cpumask. While
+ * this all sounds trivial, there are various non-obvious corner cases,
+ * which this function tries to solve in a safe manner.
+ *
+ * Also note that the function uses a somewhat relaxed locking scheme,
+ * so it may be called only for an already offlined CPU.
+ */
 void clear_tasks_mm_cpumask(int cpu)
 {
 	struct task_struct *p;
@@ -184,10 +197,15 @@ void clear_tasks_mm_cpumask(int cpu)
 	 * Thus, we may use rcu_read_lock() here, instead of grabbing
 	 * full-fledged tasklist_lock.
 	 */
+	WARN_ON(cpu_online(cpu));
 	rcu_read_lock();
 	for_each_process(p) {
 		struct task_struct *t;
 
+		/*
+		 * Main thread might exit, but other threads may still have
+		 * a valid mm. Find one.
+		 */
 		t = find_lock_task_mm(p);
 		if (!t)
 			continue;
_
Subject: Subject: kernel/cpu.c: document clear_tasks_mm_cpumask()

Patches currently in -mm which might be from anton.vorontsov@linaro.org are

linux-next.patch
cpu-introduce-clear_tasks_mm_cpumask-helper.patch
arm-use-clear_tasks_mm_cpumask.patch
powerpc-use-clear_tasks_mm_cpumask.patch
sh-use-clear_tasks_mm_cpumask.patch
blackfin-a-couple-of-task-mm-handling-fixes.patch
blackfin-fix-possible-deadlock-in-decode_address.patch
um-should-hold-tasklist_lock-while-traversing-processes.patch
um-fix-possible-race-on-task-mm.patch
um-properly-check-all-process-threads-for-a-live-mm.patch
kernel-cpuc-document-clear_tasks_mm_cpumask.patch

