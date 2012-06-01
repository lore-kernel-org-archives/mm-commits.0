From: akpm@linux-foundation.org
Subject: [merged] kernel-cpuc-document-clear_tasks_mm_cpumask.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:34:30 -0700
Message-ID: <20120601193430.5D656A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:46196 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932804Ab2FATeb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:34:31 -0400
Received: by mail-vc0-f202.google.com with SMTP id fl13so245502vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:34:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anton.vorontsov@linaro.org, a.p.zijlstra@chello.nl, akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/cpu.c: document clear_tasks_mm_cpumask()
has been removed from the -mm tree.  Its filename was
     kernel-cpuc-document-clear_tasks_mm_cpumask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: kernel/cpu.c: document clear_tasks_mm_cpumask()

Add more comments on clear_tasks_mm_cpumask, plus adds a runtime check:
the function is only suitable for offlined CPUs, and if called
inappropriately, the kernel should scream aloud.

[akpm@linux-foundation.org: tweak comment: s/walks up/walks/, use 80 cols]
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
@@ -175,6 +176,18 @@ void __ref unregister_cpu_notifier(struc
 }
 EXPORT_SYMBOL(unregister_cpu_notifier);
 
+/**
+ * clear_tasks_mm_cpumask - Safely clear tasks' mm_cpumask for a CPU
+ * @cpu: a CPU id
+ *
+ * This function walks all processes, finds a valid mm struct for each one and
+ * then clears a corresponding bit in mm's cpumask.  While this all sounds
+ * trivial, there are various non-obvious corner cases, which this function
+ * tries to solve in a safe manner.
+ *
+ * Also note that the function uses a somewhat relaxed locking scheme, so it may
+ * be called only for an already offlined CPU.
+ */
 void clear_tasks_mm_cpumask(int cpu)
 {
 	struct task_struct *p;
@@ -186,10 +199,15 @@ void clear_tasks_mm_cpumask(int cpu)
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

Patches currently in -mm which might be from anton.vorontsov@linaro.org are

origin.patch

