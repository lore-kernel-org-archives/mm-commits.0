From: akpm@linux-foundation.org
Subject: - workqueue-fix-broken-suspend-on-smp-with-tifm.patch removed from -mm tree
Date: Sun, 13 May 2007 15:50:02 -0700
Message-ID: <200705132250.l4DMo2kV004827@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55183 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755415AbXEMWuL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 May 2007 18:50:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     workqueue: fix broken suspend on SMP with tifm
has been removed from the -mm tree.  Its filename was
     workqueue-fix-broken-suspend-on-smp-with-tifm.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
Subject: workqueue: fix broken suspend on SMP with tifm
From: "Rafael J. Wysocki" <rjw@sisk.pl>

Prevent freezable worqueues from deadlocking with CPU hotplug during a
suspend/hibernation by thawing their worker threads before they get stopped.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN kernel/workqueue.c~workqueue-fix-broken-suspend-on-smp-with-tifm kernel/workqueue.c
--- a/kernel/workqueue.c~workqueue-fix-broken-suspend-on-smp-with-tifm
+++ a/kernel/workqueue.c
@@ -799,9 +799,7 @@ static int __devinit workqueue_cpu_callb
 	struct cpu_workqueue_struct *cwq;
 	struct workqueue_struct *wq;
 
-	action &= ~CPU_TASKS_FROZEN;
-
-	switch (action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_LOCK_ACQUIRE:
 		mutex_lock(&workqueue_mutex);
 		return NOTIFY_OK;
@@ -819,20 +817,29 @@ static int __devinit workqueue_cpu_callb
 
 		switch (action) {
 		case CPU_UP_PREPARE:
+		case CPU_UP_PREPARE_FROZEN:
 			if (!create_workqueue_thread(cwq, cpu))
 				break;
 			printk(KERN_ERR "workqueue for %i failed\n", cpu);
 			return NOTIFY_BAD;
 
 		case CPU_ONLINE:
+		case CPU_ONLINE_FROZEN:
 			start_workqueue_thread(cwq, cpu);
 			break;
 
 		case CPU_UP_CANCELED:
+		case CPU_UP_CANCELED_FROZEN:
 			start_workqueue_thread(cwq, -1);
 		case CPU_DEAD:
 			cleanup_workqueue_thread(cwq, cpu);
 			break;
+
+		case CPU_DEAD_FROZEN:
+			if (wq->freezeable)
+				thaw_process(cwq->thread);
+			cleanup_workqueue_thread(cwq, cpu);
+			break;
 		}
 	}
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

workqueue-fix-broken-suspend-on-smp-with-tifm.patch
at91-fix-enable-disable_irq_wake-symmetry-in-pcmcia-driver.patch
freezer-close-potential-race-between-refrigerator-and-thaw_tasks.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
freezer-fix-kthread_create-vs-freezer-theoretical-race.patch
freezer-fix-pf_nofreeze-vs-freezeable-race.patch
freezer-move-frozen_process-to-kernel-power-processc.patch
add-common-orderly_poweroff.patch
add-suspend-related-notifications-for-cpu-hotplug-statistics.patch
shrink_slab-handle-bad-shrinkers.patch
