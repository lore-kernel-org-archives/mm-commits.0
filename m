From: akpm@linux-foundation.org
Subject: - cgroups-make-cgroup-config-a-submenu.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:47:16 -0800
Message-ID: <200901082247.n08MlGfS026733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761042AbZAHWsB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:48:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, menage@google.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     cgroups: make cgroup config a submenu
has been removed from the -mm tree.  Its filename was
     cgroups-make-cgroup-config-a-submenu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: make cgroup config a submenu
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Making CGROUP related configs be a sub-menu.

This patch make CGROUP related configs be a sub-menu and makes 1st level
configs of "General Setup" shorter.

 including following additional changes
  - add help comment about CGROUPS and GROUP_SCHED.
  - moved MM_OWNER config to the bottom.
    (for good indent in menuconfig)

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |  123 ++++++++++++++++++++++++++-----------------------
 1 file changed, 67 insertions(+), 56 deletions(-)

diff -puN init/Kconfig~cgroups-make-cgroup-config-a-submenu init/Kconfig
--- a/init/Kconfig~cgroups-make-cgroup-config-a-submenu
+++ a/init/Kconfig
@@ -271,59 +271,6 @@ config LOG_BUF_SHIFT
 		     13 =>  8 KB
 		     12 =>  4 KB
 
-config CGROUPS
-	bool "Control Group support"
-	help
-	  This option will let you use process cgroup subsystems
-	  such as Cpusets
-
-	  Say N if unsure.
-
-config CGROUP_DEBUG
-	bool "Example debug cgroup subsystem"
-	depends on CGROUPS
-	default n
-	help
-	  This option enables a simple cgroup subsystem that
-	  exports useful debugging information about the cgroups
-	  framework
-
-	  Say N if unsure
-
-config CGROUP_NS
-        bool "Namespace cgroup subsystem"
-        depends on CGROUPS
-        help
-          Provides a simple namespace cgroup subsystem to
-          provide hierarchical naming of sets of namespaces,
-          for instance virtual servers and checkpoint/restart
-          jobs.
-
-config CGROUP_FREEZER
-        bool "control group freezer subsystem"
-        depends on CGROUPS
-        help
-          Provides a way to freeze and unfreeze all tasks in a
-	  cgroup.
-
-config CGROUP_DEVICE
-	bool "Device controller for cgroups"
-	depends on CGROUPS && EXPERIMENTAL
-	help
-	  Provides a cgroup implementing whitelists for devices which
-	  a process in the cgroup can mknod or open.
-
-config CPUSETS
-	bool "Cpuset support"
-	depends on SMP && CGROUPS
-	help
-	  This option will let you create and manage CPUSETs which
-	  allow dynamically partitioning a system into sets of CPUs and
-	  Memory Nodes and assigning tasks to run only within those sets.
-	  This is primarily useful on large SMP or NUMA systems.
-
-	  Say N if unsure.
-
 #
 # Architectures with an unreliable sched_clock() should select this:
 #
@@ -337,6 +284,8 @@ config GROUP_SCHED
 	help
 	  This feature lets CPU scheduler recognize task groups and control CPU
 	  bandwidth allocation to such task groups.
+	  In order to create a group from arbitrary set of processes, use
+	  CONFIG_CGROUPS. (See Control Group support.)
 
 config FAIR_GROUP_SCHED
 	bool "Group scheduling for SCHED_OTHER"
@@ -379,6 +328,66 @@ config CGROUP_SCHED
 
 endchoice
 
+menu "Control Group support"
+config CGROUPS
+	bool "Control Group support"
+	help
+	  This option add support for grouping sets of processes together, for
+	  use with process control subsystems such as Cpusets, CFS, memory
+	  controls or device isolation.
+	  See
+		- Documentation/cpusets.txt	(Cpusets)
+		- Documentation/scheduler/sched-design-CFS.txt	(CFS)
+		- Documentation/cgroups/ (features for grouping, isolation)
+		- Documentation/controllers/ (features for resource control)
+
+	  Say N if unsure.
+
+config CGROUP_DEBUG
+	bool "Example debug cgroup subsystem"
+	depends on CGROUPS
+	default n
+	help
+	  This option enables a simple cgroup subsystem that
+	  exports useful debugging information about the cgroups
+	  framework
+
+	  Say N if unsure
+
+config CGROUP_NS
+        bool "Namespace cgroup subsystem"
+        depends on CGROUPS
+        help
+          Provides a simple namespace cgroup subsystem to
+          provide hierarchical naming of sets of namespaces,
+          for instance virtual servers and checkpoint/restart
+          jobs.
+
+config CGROUP_FREEZER
+        bool "control group freezer subsystem"
+        depends on CGROUPS
+        help
+          Provides a way to freeze and unfreeze all tasks in a
+	  cgroup.
+
+config CGROUP_DEVICE
+	bool "Device controller for cgroups"
+	depends on CGROUPS && EXPERIMENTAL
+	help
+	  Provides a cgroup implementing whitelists for devices which
+	  a process in the cgroup can mknod or open.
+
+config CPUSETS
+	bool "Cpuset support"
+	depends on SMP && CGROUPS
+	help
+	  This option will let you create and manage CPUSETs which
+	  allow dynamically partitioning a system into sets of CPUs and
+	  Memory Nodes and assigning tasks to run only within those sets.
+	  This is primarily useful on large SMP or NUMA systems.
+
+	  Say N if unsure.
+
 config CGROUP_CPUACCT
 	bool "Simple CPU accounting cgroup subsystem"
 	depends on CGROUPS
@@ -393,9 +402,6 @@ config RESOURCE_COUNTERS
           infrastructure that works with cgroups
 	depends on CGROUPS
 
-config MM_OWNER
-	bool
