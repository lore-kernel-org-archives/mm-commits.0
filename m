From: akpm@linux-foundation.org
Subject: - define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch removed from -mm tree
Date: Wed, 09 May 2007 14:51:25 -0700
Message-ID: <200705092151.l49LpPks002875@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37474 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751580AbXEIVvv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:51:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ego@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Define and use new events,CPU_LOCK_ACQUIRE and CPU_LOCK_RELEASE
has been removed from the -mm tree.  Its filename was
     define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Define and use new events,CPU_LOCK_ACQUIRE and CPU_LOCK_RELEASE
From: Gautham R Shenoy <ego@in.ibm.com>

This is an attempt to provide an alternate mechanism for postponing
a hotplug event instead of using a global mechanism like lock_cpu_hotplug.

The proposal is to add two new events namely CPU_LOCK_ACQUIRE and
CPU_LOCK_RELEASE. The notification for these two events would be sent
out before and after a cpu_hotplug event respectively.

During the CPU_LOCK_ACQUIRE event, a cpu-hotplug-aware subsystem is
supposed to acquire any per-subsystem hotcpu mutex ( Eg. workqueue_mutex
in kernel/workqueue.c ).

During the CPU_LOCK_RELEASE release event the cpu-hotplug-aware subsystem
is supposed to release the per-subsystem hotcpu mutex.

The reasons for defining new events as opposed to reusing the existing events
like CPU_UP_PREPARE/CPU_UP_FAILED/CPU_ONLINE for locking/unlocking of
per-subsystem hotcpu mutexes are as follow:

	- CPU_LOCK_ACQUIRE: All hotcpu mutexes are taken before subsystems
	start handling pre-hotplug events like CPU_UP_PREPARE/CPU_DOWN_PREPARE
	etc, thus ensuring a clean handling of these events.

	- CPU_LOCK_RELEASE: The hotcpu mutexes will be released only after
	all subsystems have handled post-hotplug events like CPU_DOWN_FAILED,
	CPU_DEAD,CPU_ONLINE etc thereby ensuring that there are no subsequent
	clashes amongst the interdependent subsystems after a cpu hotplugs.

This patch also uses __raw_notifier_call chain in _cpu_up to take care
of the dependency between the two consequetive calls to
raw_notifier_call_chain.

[akpm@linux-foundation.org: fix a bug]
Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/notifier.h |    2 ++
 kernel/cpu.c             |   19 ++++++++++++++-----
 2 files changed, 16 insertions(+), 5 deletions(-)

diff -puN include/linux/notifier.h~define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release include/linux/notifier.h
--- a/include/linux/notifier.h~define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release
+++ a/include/linux/notifier.h
@@ -194,6 +194,8 @@ extern int __srcu_notifier_call_chain(st
 #define CPU_DOWN_PREPARE	0x0005 /* CPU (unsigned)v going down */
 #define CPU_DOWN_FAILED		0x0006 /* CPU (unsigned)v NOT going down */
 #define CPU_DEAD		0x0007 /* CPU (unsigned)v dead */
+#define CPU_LOCK_ACQUIRE	0x0008 /* Acquire all hotcpu locks */
+#define CPU_LOCK_RELEASE	0x0009 /* Release all hotcpu locks */
 
 #endif /* __KERNEL__ */
 #endif /* _LINUX_NOTIFIER_H */
diff -puN kernel/cpu.c~define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release kernel/cpu.c
--- a/kernel/cpu.c~define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release
+++ a/kernel/cpu.c
@@ -132,12 +132,15 @@ static int _cpu_down(unsigned int cpu)
 	if (!cpu_online(cpu))
 		return -EINVAL;
 
+	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_ACQUIRE,
+						(void *)(long)cpu);
 	err = raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE,
 						(void *)(long)cpu);
 	if (err == NOTIFY_BAD) {
 		printk("%s: attempt to take down CPU %u failed\n",
 				__FUNCTION__, cpu);
-		return -EINVAL;
+		err = -EINVAL;
+		goto out_release;
 	}
 
 	/* Ensure that we are not runnable on dying cpu */
@@ -185,6 +188,9 @@ out_thread:
 	err = kthread_stop(p);
 out_allowed:
 	set_cpus_allowed(current, old_allowed);
+out_release:
+	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_RELEASE,
+						(void *)(long)cpu);
 	return err;
 }
 
@@ -206,13 +212,15 @@ int cpu_down(unsigned int cpu)
 /* Requires cpu_add_remove_lock to be held */
 static int __cpuinit _cpu_up(unsigned int cpu)
 {
-	int ret;
+	int ret, nr_calls = 0;
 	void *hcpu = (void *)(long)cpu;
 
 	if (cpu_online(cpu) || !cpu_present(cpu))
 		return -EINVAL;
 
-	ret = raw_notifier_call_chain(&cpu_chain, CPU_UP_PREPARE, hcpu);
+	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_ACQUIRE, hcpu);
+	ret = __raw_notifier_call_chain(&cpu_chain, CPU_UP_PREPARE, hcpu,
+							-1, &nr_calls);
 	if (ret == NOTIFY_BAD) {
 		printk("%s: attempt to bring up CPU %u failed\n",
 				__FUNCTION__, cpu);
@@ -233,8 +241,9 @@ static int __cpuinit _cpu_up(unsigned in
 
 out_notify:
 	if (ret != 0)
-		raw_notifier_call_chain(&cpu_chain,
-				CPU_UP_CANCELED, hcpu);
+		__raw_notifier_call_chain(&cpu_chain,
+				CPU_UP_CANCELED, hcpu, nr_calls, NULL);
+	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_RELEASE, hcpu);
 
 	return ret;
 }
_

Patches currently in -mm which might be from ego@in.ibm.com are

origin.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
fix-pf_nofreeze-and-freezeable-race-2.patch
freezer-document-task_lock-in-thaw_process.patch
move-frozen_process-to-kernel-power-processc.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
