From: akpm@linux-foundation.org
Subject: - oom-move-prototypes-to-appropriate-header-file-fix.patch removed from -mm tree
Date: Tue, 16 Oct 2007 14:42:51 -0700
Message-ID: <200710162142.l9GLgpu1018899@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33732 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966035AbXJPVoE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:44:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clg@fr.ibm.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     oom-move-prototypes-to-appropriate-header-file fix
has been removed from the -mm tree.  Its filename was
     oom-move-prototypes-to-appropriate-header-file-fix.patch

This patch was dropped because it was folded into oom-move-prototypes-to-appropriate-header-file.patch

------------------------------------------------------
Subject: oom-move-prototypes-to-appropriate-header-file fix
From: Cedric Le Goater <clg@fr.ibm.com>

Andy Whitcroft wrote:
> Getting compile errors on S390:
>
>     CC      arch/s390/mm/cmm.o
>   arch/s390/mm/cmm.c: In function `cmm_init':
>   arch/s390/mm/cmm.c:431: error: implicit declaration of function
>   				`register_oom_notifier'
>   arch/s390/mm/cmm.c:443: error: implicit declaration of function
>   				`unregister_oom_notifier'
>   make[1]: *** [arch/s390/mm/cmm.o] Error 1
>   make: *** [arch/s390/mm] Error 2

yes. It's from oom-move-prototypes-to-appropriate-header-file.patch.

I think this patch fixes it.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/cmm.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/s390/mm/cmm.c~oom-move-prototypes-to-appropriate-header-file-fix arch/s390/mm/cmm.c
--- a/arch/s390/mm/cmm.c~oom-move-prototypes-to-appropriate-header-file-fix
+++ a/arch/s390/mm/cmm.c
@@ -17,6 +17,7 @@
 #include <linux/ctype.h>
 #include <linux/swap.h>
 #include <linux/kthread.h>
+#include <linux/oom.h>
 
 #include <asm/pgalloc.h>
 #include <asm/uaccess.h>
_

Patches currently in -mm which might be from clg@fr.ibm.com are

oom-move-prototypes-to-appropriate-header-file.patch
oom-move-prototypes-to-appropriate-header-file-fix.patch
handle-the-multi-threaded-inits-exit-properly.patch
ipc-namespace-remove-config-ipc-ns-fix.patch
remove-unused-member-from-nsproxy.patch
use-kmem_cache-macro-to-create-the-nsproxy-cache.patch
task-containersv11-basic-task-container-framework.patch
task-containersv11-add-tasks-file-interface.patch
task-containersv11-add-fork-exit-hooks.patch
task-containersv11-add-container_clone-interface.patch
task-containersv11-add-procfs-interface.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
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
isolate-the-explicit-usage-of-signal-pgrp.patch
