From: akpm@linux-foundation.org
Subject: + containers-implement-namespace-tracking-subsystem-fix-order-of-container-subsystems-in-init-kconfig.patch added to -mm tree
Date: Thu, 26 Jul 2007 00:55:52 -0700
Message-ID: <200707260755.l6Q7tqNP021180@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53040 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757863AbXGZH4Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 03:56:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clg@fr.ibm.com, menage@google.com


The patch titled
     fix order of container subsystems in init/Kconfig
has been added to the -mm tree.  Its filename is
     containers-implement-namespace-tracking-subsystem-fix-order-of-container-subsystems-in-init-kconfig.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix order of container subsystems in init/Kconfig
From: Cedric Le Goater <clg@fr.ibm.com>

some cosmetic changes to init/Kconfig to make the subsystem list
under containers look nicer when CONFIG_CONTAINERS=y.

also changed the 'select' to 'depends on' for the namespace
subsystem.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff -puN init/Kconfig~containers-implement-namespace-tracking-subsystem-fix-order-of-container-subsystems-in-init-kconfig init/Kconfig
--- a/init/Kconfig~containers-implement-namespace-tracking-subsystem-fix-order-of-container-subsystems-in-init-kconfig
+++ a/init/Kconfig
@@ -310,6 +310,22 @@ config CONTAINER_DEBUG
 
 	  Say N if unsure
 
+config CONTAINER_NS
+        bool "Namespace container subsystem"
+        depends on CONTAINERS
+        help
+          Provides a simple namespace container subsystem to
+          provide hierarchical naming of sets of namespaces,
+          for instance virtual servers and checkpoint/restart
+          jobs.
+
+config CONTAINER_CPUACCT
+	bool "Simple CPU accounting container subsystem"
+	depends on CONTAINERS
+	help
+	  Provides a simple Resource Controller for monitoring the
+	  total CPU consumed by the tasks in a container
+
 config CPUSETS
 	bool "Cpuset support"
 	depends on SMP && CONTAINERS
@@ -341,27 +357,11 @@ config SYSFS_DEPRECATED
 	  If you are using a distro that was released in 2006 or later,
 	  it should be safe to say N here.
 
-config CONTAINER_NS
-        bool "Namespace container subsystem"
-        select CONTAINERS
-        help
-          Provides a simple namespace container subsystem to
-          provide hierarchical naming of sets of namespaces,
-          for instance virtual servers and checkpoint/restart
-          jobs.
-
 config PROC_PID_CPUSET
 	bool "Include legacy /proc/<pid>/cpuset file"
 	depends on CPUSETS
 	default y
 
-config CONTAINER_CPUACCT
-	bool "Simple CPU accounting container subsystem"
-	depends on CONTAINERS
-	help
-	  Provides a simple Resource Controller for monitoring the
-	  total CPU consumed by the tasks in a container
-
 config RELAY
 	bool "Kernel->user space relay support (formerly relayfs)"
 	help
_

Patches currently in -mm which might be from clg@fr.ibm.com are

chipsfb-use-correct-pm-state.patch
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
pid-namespaces-move-alloc_pid-to-copy_process.patch
