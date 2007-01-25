From: akpm@osdl.org
Subject: - handle-cpu_lock_acquire-and-cpu_lock_release-in-workqueue_cpu_callback.patch removed from -mm tree
Date: Thu, 25 Jan 2007 14:40:05 -0800
Message-ID: <200701252240.l0PMe6dL032377@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:32789 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030644AbXAYWkO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 17:40:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ego@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Handle CPU_LOCK_ACQUIRE and CPU_LOCK_RELEASE in workqueue_cpu_callback
has been removed from the -mm tree.  Its filename was
     handle-cpu_lock_acquire-and-cpu_lock_release-in-workqueue_cpu_callback.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: Handle CPU_LOCK_ACQUIRE and CPU_LOCK_RELEASE in workqueue_cpu_callback
From: Gautham R Shenoy <ego@in.ibm.com>

In hot-cpu callback function workqueue_cpu_callback, lock the workqueue_mutex
under CPU_LOCK_ACQUIRE and release it under CPU_LOCK_RELEASE.

This eliminates handling of redundant events namely CPU_DOWN_PREPARE and
CPU_DOWN_FAILED.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/workqueue.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff -puN kernel/workqueue.c~handle-cpu_lock_acquire-and-cpu_lock_release-in-workqueue_cpu_callback kernel/workqueue.c
--- a/kernel/workqueue.c~handle-cpu_lock_acquire-and-cpu_lock_release-in-workqueue_cpu_callback
+++ a/kernel/workqueue.c
@@ -850,8 +850,11 @@ static int __devinit workqueue_cpu_callb
 	struct workqueue_struct *wq;
 
 	switch (action) {
-	case CPU_UP_PREPARE:
+	case CPU_LOCK_ACQUIRE:
 		mutex_lock(&workqueue_mutex);
+		break;
+
+	case CPU_UP_PREPARE:
 		/* Create a new workqueue thread for it. */
 		list_for_each_entry(wq, &workqueues, list) {
 			if (!create_workqueue_thread(wq, hotcpu, 0)) {
@@ -870,7 +873,6 @@ static int __devinit workqueue_cpu_callb
 			kthread_bind(cwq->thread, hotcpu);
 			wake_up_process(cwq->thread);
 		}
-		mutex_unlock(&workqueue_mutex);
 		break;
 
 	case CPU_UP_CANCELED:
@@ -882,15 +884,6 @@ static int __devinit workqueue_cpu_callb
 				     any_online_cpu(cpu_online_map));
 			cleanup_workqueue_thread(wq, hotcpu);
 		}
-		mutex_unlock(&workqueue_mutex);
-		break;
-
-	case CPU_DOWN_PREPARE:
-		mutex_lock(&workqueue_mutex);
-		break;
-
-	case CPU_DOWN_FAILED:
-		mutex_unlock(&workqueue_mutex);
 		break;
 
 	case CPU_DEAD:
@@ -898,6 +891,9 @@ static int __devinit workqueue_cpu_callb
 			cleanup_workqueue_thread(wq, hotcpu);
 		list_for_each_entry(wq, &workqueues, list)
 			take_over_work(wq, hotcpu);
+		break;
+
+	case CPU_LOCK_RELEASE:
 		mutex_unlock(&workqueue_mutex);
 		break;
 	}
_

Patches currently in -mm which might be from ego@in.ibm.com are

rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues.patch
rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix.patch
rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix-2.patch
rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix-3.patch
ondemand-governor-restructure-the-work-callback.patch
ondemand-governor-use-new-cpufreq-rwsem-locking-in-work-callback.patch
flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch
flush_cpu_workqueue-dont-flush-an-empty-worklist.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
handle-cpu_lock_acquire-and-cpu_lock_release-in-workqueue_cpu_callback.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed.patch
slab-use-cpu_lock_.patch
workqueue-fix-freezeable-workqueues-implementation.patch
workqueue-fix-flush_workqueue-vs-cpu_dead-race.patch
workqueue-dont-clear-cwq-thread-until-it-exits.patch
