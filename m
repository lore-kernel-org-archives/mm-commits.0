From: akpm@linux-foundation.org
Subject: + cpu_hotplug-dont-affect-current-tasks-affinity.patch added to -mm tree
Date: Wed, 22 Jul 2009 15:03:00 -0700
Message-ID: <200907222203.n6MM30Tq021288@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33314 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754654AbZGVWDo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Jul 2009 18:03:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laijs@cn.fujitsu.com, mingo@elte.hu, rusty@rustcorp.com.au


The patch titled
     cpu_hotplug: don't affect current task's affinity
has been added to the -mm tree.  Its filename is
     cpu_hotplug-dont-affect-current-tasks-affinity.patch

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
Subject: cpu_hotplug: don't affect current task's affinity
From: Lai Jiangshan <laijs@cn.fujitsu.com>

_cpu_down() changes the current task's affinity and then recovers it at
the end.

It has two problems:

1) The recovery of the current tasks's cpus_allowed will fail under
   some conditions.

   # grep Cpus_allowed_list /proc/$$/status
   Cpus_allowed_list:      0-3

   # taskset -pc 2 $$
   pid 29075's current affinity list: 0-3
   pid 29075's new affinity list: 2

   # grep Cpus_allowed_list /proc/$$/status
   Cpus_allowed_list:      2

   # echo 0 > /sys/devices/system/cpu/cpu2/online

   # grep Cpus_allowed_list /proc/$$/status
   Cpus_allowed_list:      0

   Here, the Cpus_allowed_list was originally "2" and has become
   "0-1,3" after cpu #2 is offlined.

   This "Cpus_allowed_list:      0" is incorrect.

2) If the current task is a userspace task, the user may change its
   cpu-affinity during the CPU hot-unplugging.  This change can be
   overwritten when _cpu_down() changes the current task's affinity.


Fix all this by not changing the current tasks's affinity.  Instead we
create a kernel thread to do the work.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpu.c |   72 ++++++++++++++++++++++++++++---------------------
 1 file changed, 42 insertions(+), 30 deletions(-)

diff -puN kernel/cpu.c~cpu_hotplug-dont-affect-current-tasks-affinity kernel/cpu.c
--- a/kernel/cpu.c~cpu_hotplug-dont-affect-current-tasks-affinity
+++ a/kernel/cpu.c
@@ -162,15 +162,17 @@ static inline void check_for_tasks(int c
 	write_unlock_irq(&tasklist_lock);
 }
 
-struct take_cpu_down_param {
+struct cpu_down_param {
 	unsigned long mod;
-	void *hcpu;
+	unsigned int cpu;
+	int ret;
+	struct completion done;
 };
 
 /* Take this CPU down. */
 static int __ref take_cpu_down(void *_param)
 {
-	struct take_cpu_down_param *param = _param;
+	struct cpu_down_param *param = _param;
 	int err;
 
 	/* Ensure this CPU doesn't handle any more interrupts. */
@@ -179,7 +181,7 @@ static int __ref take_cpu_down(void *_pa
 		return err;
 
 	raw_notifier_call_chain(&cpu_chain, CPU_DYING | param->mod,
-				param->hcpu);
+				(void *)(long)param->cpu);
 
 	/* Force idle task to run as soon as we yield: it should
 	   immediately notice cpu is offline and die quickly. */
@@ -187,26 +189,13 @@ static int __ref take_cpu_down(void *_pa
 	return 0;
 }
 
-/* Requires cpu_add_remove_lock to be held */
-static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
+static int __ref _cpu_down_thread(void *_param)
 {
+	struct cpu_down_param *param = _param;
 	int err, nr_calls = 0;
-	cpumask_var_t old_allowed;
+	unsigned long mod = param->mod;
+	unsigned int cpu = param->cpu;
 	void *hcpu = (void *)(long)cpu;
-	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
-	struct take_cpu_down_param tcd_param = {
-		.mod = mod,
-		.hcpu = hcpu,
-	};
-
-	if (num_online_cpus() == 1)
-		return -EBUSY;
-
-	if (!cpu_online(cpu))
-		return -EINVAL;
-
-	if (!alloc_cpumask_var(&old_allowed, GFP_KERNEL))
-		return -ENOMEM;
 
 	cpu_hotplug_begin();
 	err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE | mod,
@@ -222,18 +211,16 @@ static int __ref _cpu_down(unsigned int 
 	}
 
 	/* Ensure that we are not runnable on dying cpu */
-	cpumask_copy(old_allowed, &current->cpus_allowed);
-	set_cpus_allowed_ptr(current,
-			     cpumask_of(cpumask_any_but(cpu_online_mask, cpu)));
+	set_cpus_allowed_ptr(current, cpu_active_mask);
 
-	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
+	err = __stop_machine(take_cpu_down, param, cpumask_of(cpu));
 	if (err) {
 		/* CPU didn't die: tell everyone.  Can't complain. */
 		if (raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED | mod,
 					    hcpu) == NOTIFY_BAD)
 			BUG();
 
-		goto out_allowed;
+		goto out_release;
 	}
 	BUG_ON(cpu_online(cpu));
 
@@ -251,8 +238,6 @@ static int __ref _cpu_down(unsigned int 
 
 	check_for_tasks(cpu);
 
-out_allowed:
-	set_cpus_allowed_ptr(current, old_allowed);
 out_release:
 	cpu_hotplug_done();
 	if (!err) {
@@ -260,8 +245,35 @@ out_release:
 					    hcpu) == NOTIFY_BAD)
 			BUG();
 	}
-	free_cpumask_var(old_allowed);
-	return err;
+	param->ret = err;
+	complete(&param->done);
+
+	return 0;
+}
+
+/* Requires cpu_add_remove_lock to be held */
+static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
+{
+	struct task_struct *k;
+	struct cpu_down_param param = {
+		.mod = tasks_frozen ? CPU_TASKS_FROZEN : 0,
+		.cpu = cpu,
+		.ret = 0,
+	};
+
+	if (num_online_cpus() == 1)
+		return -EBUSY;
+
+	if (!cpu_online(cpu))
+		return -EINVAL;
+
+	init_completion(&param.done);
+	k = kthread_run(_cpu_down_thread, &param, "kcpu_down");
+	if (IS_ERR(k))
+		return PTR_ERR(k);
+	wait_for_completion(&param.done);
+
+	return param.ret;
 }
 
 int __ref cpu_down(unsigned int cpu)
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

linux-next.patch
cpu_hotplug-dont-affect-current-tasks-affinity.patch

