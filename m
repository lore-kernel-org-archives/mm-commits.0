From: akpm@linux-foundation.org
Subject: - cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:29:08 -0700
Message-ID: <200710190429.l9J4T8t0015119@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35858 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751295AbXJSE3M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:29:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified-checkpatch-fixes.patch

This patch was dropped because it was folded into cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified.patch

------------------------------------------------------
Subject: cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN kernel/cpu.c~cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified-checkpatch-fixes kernel/cpu.c
--- a/kernel/cpu.c~cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified-checkpatch-fixes
+++ a/kernel/cpu.c
@@ -266,10 +266,11 @@ int __cpuinit cpu_up(unsigned int cpu)
 {
 	int err = 0;
 	if (!cpu_isset(cpu, cpu_possible_map)) {
-		printk("can't online cpu %d because it is not configured "
-		       "as may-hotadded at boot time\n", cpu);
-#if defined(CONFIG_IA64) || defined (CONFIG_X86_64) || defined(CONFIG_S390)
-		printk("please check additional_cpus= boot parameter\n");
+		printk(KERN_ERR "can't online cpu %d because it is not "
+			"configured as may-hotadd at boot time\n", cpu);
+#if defined(CONFIG_IA64) || defined(CONFIG_X86_64) || defined(CONFIG_S390)
+		printk(KERN_ERR "please check additional_cpus= boot "
+				"parameter\n");
 #endif
 		return -EINVAL;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
console-keyboard-events-and-accessibility.patch
add-kernel-notifierc.patch
console-events-and-accessibility.patch
fix-random-hard-freeze-with-avm-cards-using-b1dma.patch
jbd-config_jbd_debug-cannot-create-proc-entry.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
add-containerstats-v3.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
lockdep-fix-mismatched-lockdep_depth-curr_chain_hash-checkpatch-fixes.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids.patch
pid-namespaces-changes-to-show-virtual-ids-to-user.patch
cpuset-sched_load_balance-flag.patch
cpusets-decrustify-cpuset-mask-update-code.patch
fix-cpusets-update_cpumask.patch
remove-bits_to_type-macro.patch
use-helpers-to-obtain-task-pid-in-printks.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified.patch
cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified-checkpatch-fixes.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix-2.patch
use-extended-crashkernel-command-line-on-i386.patch
hook-up-group-scheduler-with-control-groups-fix.patch
linux-kernel-markers-checkpatch-fixes.patch
linux-kernel-markers-samples-checkpatch-fixes.patch
uninline-forkc-exitc-checkpatch-fixes.patch
