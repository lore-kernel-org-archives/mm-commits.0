From: akpm@linux-foundation.org
Subject: - linux-kernel-markers-samples-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:36:15 -0700
Message-ID: <200710190436.l9J4aFeA015401@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44372 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752159AbXJSEgX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:36:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     linux-kernel-markers-samples-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     linux-kernel-markers-samples-checkpatch-fixes.patch

This patch was dropped because it was folded into linux-kernel-markers-samples.patch

------------------------------------------------------
Subject: linux-kernel-markers-samples-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN samples/markers/marker-example.c~linux-kernel-markers-samples-checkpatch-fixes samples/markers/marker-example.c
--- a/samples/markers/marker-example.c~linux-kernel-markers-samples-checkpatch-fixes
+++ a/samples/markers/marker-example.c
@@ -13,16 +13,15 @@
 #include <linux/sched.h>
 #include <linux/proc_fs.h>
 
-struct proc_dir_entry *pentry_example = NULL;
+struct proc_dir_entry *pentry_example;
 
 static int my_open(struct inode *inode, struct file *file)
 {
 	int i;
 
 	trace_mark(subsystem_event, "%d %s", 123, "example string");
-	for (i=0; i<10; i++) {
+	for (i = 0; i < 10; i++)
 		trace_mark(subsystem_eventb, MARK_NOARGS);
-	}
 	return -EPERM;
 }
 
diff -puN samples/markers/probe-example.c~linux-kernel-markers-samples-checkpatch-fixes samples/markers/probe-example.c
--- a/samples/markers/probe-example.c~linux-kernel-markers-samples-checkpatch-fixes
+++ a/samples/markers/probe-example.c
@@ -34,7 +34,7 @@ void probe_subsystem_event(const struct 
 	mystr = va_arg(ap, typeof(mystr));
 
 	/* Call printk */
-	printk("Value %u, string %s\n", value, mystr);
+	printk(KERN_DEBUG "Value %u, string %s\n", value, mystr);
 
 	/* or count, check rights, serialize data in a buffer */
 
@@ -84,10 +84,10 @@ static void __exit probe_fini(void)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(probe_array); i++) {
+	for (i = 0; i < ARRAY_SIZE(probe_array); i++)
 		marker_probe_unregister(probe_array[i].name);
-	}
-	printk("Number of event b : %u\n", atomic_read(&eventb_count));
+	printk(KERN_INFO "Number of event b : %u\n",
+			atomic_read(&eventb_count));
 }
 
 module_init(probe_init);
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
ipc-integrate-ipc_checkid-into-ipc_lock.patch
hook-up-group-scheduler-with-control-groups.patch
linux-kernel-markers.patch
linux-kernel-markers-samples.patch
linux-kernel-markers-samples-checkpatch-fixes.patch
uninline-forkc-exitc-checkpatch-fixes.patch
