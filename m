From: akpm@linux-foundation.org
Subject: + cpu-hotplug-introduce-cpu_notify-__cpu_notify-cpu_notify_nofail.patch added to -mm tree
Date: Mon, 22 Mar 2010 14:49:02 -0700
Message-ID: <201003222149.o2MLn2MW029413@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756536Ab0CVVtJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 17:49:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, rusty@rustcorp.com.au


The patch titled
     cpu-hotplug: introduce cpu_notify(), __cpu_notify(), cpu_notify_nofail()
has been added to the -mm tree.  Its filename is
     cpu-hotplug-introduce-cpu_notify-__cpu_notify-cpu_notify_nofail.patch

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
Subject: cpu-hotplug: introduce cpu_notify(), __cpu_notify(), cpu_notify_nofail()
From: Akinobu Mita <akinobu.mita@gmail.com>

No functional change.  These are just wrappers of
raw_cpu_notifier_call_chain.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpu.c |   55 ++++++++++++++++++++++++++++---------------------
 1 file changed, 32 insertions(+), 23 deletions(-)

diff -puN kernel/cpu.c~cpu-hotplug-introduce-cpu_notify-__cpu_notify-cpu_notify_nofail kernel/cpu.c
--- a/kernel/cpu.c~cpu-hotplug-introduce-cpu_notify-__cpu_notify-cpu_notify_nofail
+++ a/kernel/cpu.c
@@ -133,6 +133,26 @@ int __ref register_cpu_notifier(struct n
 	return ret;
 }
 
+static int __cpu_notify(unsigned long val, void *v, int nr_to_call,
+			int *nr_calls)
+{
+	return __raw_notifier_call_chain(&cpu_chain, val, v, nr_to_call,
+					nr_calls);
+}
+
+static int cpu_notify(unsigned long val, void *v)
+{
+	return __cpu_notify(val, v, -1, NULL);
+}
+
+static void cpu_notify_nofail(unsigned long val, void *v)
+{
+	int err;
+
+	err = cpu_notify(val, v);
+	BUG_ON(err == NOTIFY_BAD);
+}
+
 #ifdef CONFIG_HOTPLUG_CPU
 
 EXPORT_SYMBOL(register_cpu_notifier);
@@ -178,8 +198,7 @@ static int __ref take_cpu_down(void *_pa
 	if (err < 0)
 		return err;
 
-	raw_notifier_call_chain(&cpu_chain, CPU_DYING | param->mod,
-				param->hcpu);
+	cpu_notify(CPU_DYING | param->mod, param->hcpu);
 
 	/* Force idle task to run as soon as we yield: it should
 	   immediately notice cpu is offline and die quickly. */
@@ -210,14 +229,12 @@ static int __ref _cpu_down(unsigned int 
 
 	cpu_hotplug_begin();
 	set_cpu_active(cpu, false);
-	err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE | mod,
-					hcpu, -1, &nr_calls);
+	err = __cpu_notify(CPU_DOWN_PREPARE | mod, hcpu, -1, &nr_calls);
 	if (err == NOTIFY_BAD) {
 		set_cpu_active(cpu, true);
 
 		nr_calls--;
-		__raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED | mod,
-					  hcpu, nr_calls, NULL);
+		__cpu_notify(CPU_DOWN_FAILED | mod, hcpu, nr_calls, NULL);
 		printk("%s: attempt to take down CPU %u failed\n",
 				__func__, cpu);
 		err = -EINVAL;
@@ -232,9 +249,7 @@ static int __ref _cpu_down(unsigned int 
 	if (err) {
 		set_cpu_active(cpu, true);
 		/* CPU didn't die: tell everyone.  Can't complain. */
-		if (raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED | mod,
-					    hcpu) == NOTIFY_BAD)
-			BUG();
+		cpu_notify_nofail(CPU_DOWN_FAILED | mod, hcpu);
 
 		goto out_allowed;
 	}
@@ -248,9 +263,7 @@ static int __ref _cpu_down(unsigned int 
 	__cpu_die(cpu);
 
 	/* CPU is completely dead: tell everyone.  Too late to complain. */
-	if (raw_notifier_call_chain(&cpu_chain, CPU_DEAD | mod,
-				    hcpu) == NOTIFY_BAD)
-		BUG();
+	cpu_notify_nofail(CPU_DEAD | mod, hcpu);
 
 	check_for_tasks(cpu);
 
@@ -258,11 +271,9 @@ out_allowed:
 	set_cpus_allowed_ptr(current, old_allowed);
 out_release:
 	cpu_hotplug_done();
-	if (!err) {
-		if (raw_notifier_call_chain(&cpu_chain, CPU_POST_DEAD | mod,
-					    hcpu) == NOTIFY_BAD)
-			BUG();
-	}
+	if (!err)
+		cpu_notify_nofail(CPU_POST_DEAD | mod, hcpu);
+
 	free_cpumask_var(old_allowed);
 	return err;
 }
@@ -302,8 +313,7 @@ static int __cpuinit _cpu_up(unsigned in
 		return -EINVAL;
 
 	cpu_hotplug_begin();
-	ret = __raw_notifier_call_chain(&cpu_chain, CPU_UP_PREPARE | mod, hcpu,
-							-1, &nr_calls);
+	ret = __cpu_notify(CPU_UP_PREPARE | mod, hcpu, -1, &nr_calls);
 	if (ret == NOTIFY_BAD) {
 		nr_calls--;
 		printk("%s: attempt to bring up CPU %u failed\n",
@@ -321,12 +331,11 @@ static int __cpuinit _cpu_up(unsigned in
 	set_cpu_active(cpu, true);
 
 	/* Now call notifier in preparation. */
-	raw_notifier_call_chain(&cpu_chain, CPU_ONLINE | mod, hcpu);
+	cpu_notify(CPU_ONLINE | mod, hcpu);
 
 out_notify:
 	if (ret != 0)
-		__raw_notifier_call_chain(&cpu_chain,
-				CPU_UP_CANCELED | mod, hcpu, nr_calls, NULL);
+		__cpu_notify(CPU_UP_CANCELED | mod, hcpu, nr_calls, NULL);
 	cpu_hotplug_done();
 
 	return ret;
@@ -466,7 +475,7 @@ void __cpuinit notify_cpu_starting(unsig
 	if (frozen_cpus != NULL && cpumask_test_cpu(cpu, frozen_cpus))
 		val = CPU_STARTING_FROZEN;
 #endif /* CONFIG_PM_SLEEP_SMP */
-	raw_notifier_call_chain(&cpu_chain, val, (void *)(long)cpu);
+	cpu_notify(val, (void *)(long)cpu);
 }
 
 #endif /* CONFIG_SMP */
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

