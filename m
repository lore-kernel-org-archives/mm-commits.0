From: akpm@linux-foundation.org
Subject: - ipc-namespace-remove-config-ipc-ns-fix.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:59:59 -0700
Message-ID: <200710180659.l9I6xxHd031038@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46808 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761575AbXJRHab (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:30:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clg@fr.ibm.com, ebiederm@xmision.com, rpjday@mindspring.com, mm-commits@vger.kernel.org


The patch titled
     ipc namespace: remove config ipc ns fix
has been removed from the -mm tree.  Its filename was
     ipc-namespace-remove-config-ipc-ns-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ipc namespace: remove config ipc ns fix
From: Cedric Le Goater <clg@fr.ibm.com>

Finish the work : kill all #ifdef CONFIG_IPC_NS.

Thanks Robert !

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Cc: Eric Biederman <ebiederm@xmision.com>
Cc: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/ipc_sysctl.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN ipc/ipc_sysctl.c~ipc-namespace-remove-config-ipc-ns-fix ipc/ipc_sysctl.c
--- a/ipc/ipc_sysctl.c~ipc-namespace-remove-config-ipc-ns-fix
+++ a/ipc/ipc_sysctl.c
@@ -15,7 +15,6 @@
 #include <linux/sysctl.h>
 #include <linux/uaccess.h>
 
-#ifdef CONFIG_IPC_NS
 static void *get_ipc(ctl_table *table)
 {
 	char *which = table->data;
@@ -23,9 +22,6 @@ static void *get_ipc(ctl_table *table)
 	which = (which - (char *)&init_ipc_ns) + (char *)ipc_ns;
 	return which;
 }
-#else
-#define get_ipc(T) ((T)->data)
-#endif
 
 #ifdef CONFIG_PROC_FS
 static int proc_ipc_dointvec(ctl_table *table, int write, struct file *filp,
_

Patches currently in -mm which might be from clg@fr.ibm.com are

origin.patch
task-containersv11-basic-task-container-framework.patch
task-containersv11-add-tasks-file-interface.patch
task-containersv11-add-fork-exit-hooks.patch
task-containersv11-add-container_clone-interface.patch
task-containersv11-add-procfs-interface.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
task-containersv11-shared-container-subsystem-group-arrays-simplify-proc-cgroups.patch
task-containersv11-shared-container-subsystem-group-arrays-simplify-proc-cgroups-fix.patch
task-containersv11-automatic-userspace-notification-of-idle-containers.patch
task-containersv11-make-cpusets-a-client-of-containers.patch
task-containersv11-example-cpu-accounting-subsystem.patch
task-containersv11-simple-task-container-debug-info-subsystem.patch
containers-implement-namespace-tracking-subsystem-fix-order-of-container-subsystems-in-init-kconfig.patch
pid-namespaces-round-up-the-api.patch
pid-namespaces-make-get_pid_ns-return-the-namespace-itself.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
pid-namespaces-rename-child_reaper-function.patch
pid-namespaces-use-task_pid-to-find-leaders-pid.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix-capabilityc-to-work-with-threaded-init.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
pid-namespaces-move-alloc_pid-to-copy_process.patch
make-access-to-tasks-nsproxy-lighterpatch-breaks-unshare.patch
make-access-to-tasks-nsproxy-lighter-update-get_net_ns_by_pid.patch
fix-cpusets-update_cpumask.patch
fix-cpusets-update_cpumask-checkpatch-fixes.patch
isolate-the-explicit-usage-of-signal-pgrp.patch
