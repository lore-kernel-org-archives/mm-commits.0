From: akpm@linux-foundation.org
Subject: + kernel-convert-cpu-notifier-to-return-encapsulate-errno-value.patch added to -mm tree
Date: Mon, 22 Mar 2010 14:49:14 -0700
Message-ID: <201003222149.o2MLnEXN029436@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45420 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756562Ab0CVVtg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 17:49:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, mingo@elte.hu, peterz@infradead.org


The patch titled
     kernel/: convert cpu notifier to return encapsulate errno value
has been added to the -mm tree.  Its filename is
     kernel-convert-cpu-notifier-to-return-encapsulate-errno-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/: convert cpu notifier to return encapsulate errno value
From: Akinobu Mita <akinobu.mita@gmail.com>

By the previous modification, the cpu notifier can return encapsulate
errno value.  This converts the cpu notifiers for kernel/*.c

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/padata.c     |    4 ++--
 kernel/profile.c    |    4 ++--
 kernel/relay.c      |    2 +-
 kernel/sched.c      |    2 +-
 kernel/smp.c        |    2 +-
 kernel/softirq.c    |    2 +-
 kernel/softlockup.c |    2 +-
 kernel/timer.c      |    7 +++++--
 kernel/workqueue.c  |    9 +++++----
 9 files changed, 19 insertions(+), 15 deletions(-)

diff -puN kernel/padata.c~kernel-convert-cpu-notifier-to-return-encapsulate-errno-value kernel/padata.c
--- a/kernel/padata.c~kernel-convert-cpu-notifier-to-return-encapsulate-errno-value
+++ a/kernel/padata.c
@@ -587,7 +587,7 @@ static int __cpuinit padata_cpu_callback
 		err = __padata_add_cpu(pinst, cpu);
 		mutex_unlock(&pinst->lock);
 		if (err)
-			return NOTIFY_BAD;
+			return notifier_from_errno(err);
 		break;
 
 	case CPU_DOWN_PREPARE:
@@ -598,7 +598,7 @@ static int __cpuinit padata_cpu_callback
 		err = __padata_remove_cpu(pinst, cpu);
 		mutex_unlock(&pinst->lock);
 		if (err)
-			return NOTIFY_BAD;
+			return notifier_from_errno(err);
 		break;
 
 	case CPU_UP_CANCELED:
diff -puN kernel/profile.c~kernel-convert-cpu-notifier-to-return-encapsulate-errno-value kernel/profile.c
--- a/kernel/profile.c~kernel-convert-cpu-notifier-to-return-encapsulate-errno-value
+++ a/kernel/profile.c
@@ -370,7 +370,7 @@ static int __cpuinit profile_cpu_callbac
 					GFP_KERNEL | __GFP_ZERO,
 					0);
 			if (!page)
-				return NOTIFY_BAD;
+				return notifier_from_errno(-ENOMEM);
 			per_cpu(cpu_profile_hits, cpu)[1] = page_address(page);
 		}
 		if (!per_cpu(cpu_profile_hits, cpu)[0]) {
@@ -386,7 +386,7 @@ out_free:
 		page = virt_to_page(per_cpu(cpu_profile_hits, cpu)[1]);
 		per_cpu(cpu_profile_hits, cpu)[1] = NULL;
 		__free_page(page);
-		return NOTIFY_BAD;
+		return notifier_from_errno(-ENOMEM);
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
 		if (prof_cpu_mask != NULL)
diff -puN kernel/relay.c~kernel-convert-cpu-notifier-to-return-encapsulate-errno-value kernel/relay.c
--- a/kernel/relay.c~kernel-convert-cpu-notifier-to-return-encapsulate-errno-value
+++ a/kernel/relay.c
@@ -539,7 +539,7 @@ static int __cpuinit relay_hotcpu_callba
 					"relay_hotcpu_callback: cpu %d buffer "
 					"creation failed\n", hotcpu);
 				mutex_unlock(&relay_channels_mutex);
-				return NOTIFY_BAD;
+				return notifier_from_errno(-ENOMEM);
 			}
 		}
 		mutex_unlock(&relay_channels_mutex);
diff -puN kernel/sched.c~kernel-convert-cpu-notifier-to-return-encapsulate-errno-value kernel/sched.c
--- a/kernel/sched.c~kernel-convert-cpu-notifier-to-return-encapsulate-errno-value
+++ a/kernel/sched.c
@@ -5883,7 +5883,7 @@ migration_call(struct notifier_block *nf
 	case CPU_UP_PREPARE_FROZEN:
 		p = kthread_create(migration_thread, hcpu, "migration/%d", cpu);
 		if (IS_ERR(p))
-			return NOTIFY_BAD;
+			return notifier_from_errno(PTR_ERR(p));
 		kthread_bind(p, cpu);
 		/* Must be high prio: stop_machine expects to yield to it. */
 		rq = task_rq_lock(p, &flags);
diff -puN kernel/smp.c~kernel-convert-cpu-notifier-to-return-encapsulate-errno-value kernel/smp.c
--- a/kernel/smp.c~kernel-convert-cpu-notifier-to-return-encapsulate-errno-value
+++ a/kernel/smp.c
@@ -51,7 +51,7 @@ hotplug_cfd(struct notifier_block *nfb, 
 	case CPU_UP_PREPARE_FROZEN:
 		if (!zalloc_cpumask_var_node(&cfd->cpumask, GFP_KERNEL,
 				cpu_to_node(cpu)))
-			return NOTIFY_BAD;
+			return notifier_from_errno(-ENOMEM);
 		break;
 
 #ifdef CONFIG_HOTPLUG_CPU
diff -puN kernel/softirq.c~kernel-convert-cpu-notifier-to-return-encapsulate-errno-value kernel/softirq.c
--- a/kernel/softirq.c~kernel-convert-cpu-notifier-to-return-encapsulate-errno-value
+++ a/kernel/softirq.c
@@ -808,7 +808,7 @@ static int __cpuinit cpu_callback(struct
 		p = kthread_create(run_ksoftirqd, hcpu, "ksoftirqd/%d", hotcpu);
 		if (IS_ERR(p)) {
 			printk("ksoftirqd for %i failed\n", hotcpu);
-			return NOTIFY_BAD;
+			return notifier_from_errno(PTR_ERR(p));
 		}
 		kthread_bind(p, hotcpu);
   		per_cpu(ksoftirqd, hotcpu) = p;
diff -puN kernel/softlockup.c~kernel-convert-cpu-notifier-to-return-encapsulate-errno-value kernel/softlockup.c
--- a/kernel/softlockup.c~kernel-convert-cpu-notifier-to-return-encapsulate-errno-value
+++ a/kernel/softlockup.c
@@ -228,7 +228,7 @@ cpu_callback(struct notifier_block *nfb,
 		p = kthread_create(watchdog, hcpu, "watchdog/%d", hotcpu);
 		if (IS_ERR(p)) {
 			printk(KERN_ERR "watchdog for %i failed\n", hotcpu);
-			return NOTIFY_BAD;
+			return notifier_from_errno(PTR_ERR(p));
 		}
 		per_cpu(softlockup_touch_ts, hotcpu) = 0;
 		per_cpu(softlockup_watchdog, hotcpu) = p;
diff -puN kernel/timer.c~kernel-convert-cpu-notifier-to-return-encapsulate-errno-value kernel/timer.c
--- a/kernel/timer.c~kernel-convert-cpu-notifier-to-return-encapsulate-errno-value
+++ a/kernel/timer.c
@@ -1675,11 +1675,14 @@ static int __cpuinit timer_cpu_notify(st
 				unsigned long action, void *hcpu)
 {
 	long cpu = (long)hcpu;
+	int err;
+
 	switch(action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		if (init_timers_cpu(cpu) < 0)
-			return NOTIFY_BAD;
+		err = init_timers_cpu(cpu);
+		if (err < 0)
+			return notifier_from_errno(err);
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_DEAD:
diff -puN kernel/workqueue.c~kernel-convert-cpu-notifier-to-return-encapsulate-errno-value kernel/workqueue.c
--- a/kernel/workqueue.c~kernel-convert-cpu-notifier-to-return-encapsulate-errno-value
+++ a/kernel/workqueue.c
@@ -1101,7 +1101,7 @@ static int __devinit workqueue_cpu_callb
 	unsigned int cpu = (unsigned long)hcpu;
 	struct cpu_workqueue_struct *cwq;
 	struct workqueue_struct *wq;
-	int ret = NOTIFY_OK;
+	int err = 0;
 
 	action &= ~CPU_TASKS_FROZEN;
 
@@ -1115,12 +1115,13 @@ undo:
 
 		switch (action) {
 		case CPU_UP_PREPARE:
-			if (!create_workqueue_thread(cwq, cpu))
+			err = create_workqueue_thread(cwq, cpu);
+			if (!err)
 				break;
 			printk(KERN_ERR "workqueue [%s] for %i failed\n",
 				wq->name, cpu);
 			action = CPU_UP_CANCELED;
-			ret = NOTIFY_BAD;
+			err = -ENOMEM;
 			goto undo;
 
 		case CPU_ONLINE:
@@ -1141,7 +1142,7 @@ undo:
 		cpumask_clear_cpu(cpu, cpu_populated_map);
 	}
 
-	return ret;
+	return notifier_from_errno(err);
 }
 
 #ifdef CONFIG_SMP
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

intel-iommu-use-for_each_set_bit.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
cpu-hotplug-introduce-cpu_notify-__cpu_notify-cpu_notify_nofail.patch
cpu-hotplug-return-better-errno-on-cpu-hotplug-failure.patch
notifier-change-notifier_from_errno0-to-return-notify_ok.patch
x86-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
topology-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
kernel-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
slab-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
iucv-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
ehca-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
s390-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
md-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
fault-injection-add-cpu-notifier-error-injection-module.patch
bitops-remove-temporary-for_each_bit.patch

