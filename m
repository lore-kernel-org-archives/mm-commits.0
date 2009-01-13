From: akpm@linux-foundation.org
Subject: + cgroups-clean-up-kconfig.patch added to -mm tree
Date: Tue, 13 Jan 2009 00:14:46 -0800
Message-ID: <200901130814.n0D8EkTx011884@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753136AbZAMIP0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 03:15:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com, menage@google.com


The patch titled
     cgroups: clean up Kconfig
has been added to the -mm tree.  Its filename is
     cgroups-clean-up-kconfig.patch

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
Subject: cgroups: clean up Kconfig
From: Li Zefan <lizf@cn.fujitsu.com>

- move CONFIG_PROC_PID_CPUSET into cgroup menu
- move MM_OWNER to the bottom for better menu indent
- fix typos
- use tabs not spaces

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |   56 ++++++++++++++++++++++++-------------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff -puN init/Kconfig~cgroups-clean-up-kconfig init/Kconfig
--- a/init/Kconfig~cgroups-clean-up-kconfig
+++ a/init/Kconfig
@@ -328,11 +328,10 @@ config CGROUP_SCHED
 
 endchoice
 
-menu "Control Group support"
-config CGROUPS
-	bool "Control Group support"
+menuconfig CGROUPS
+	boolean "Control Group support"
 	help
-	  This option add support for grouping sets of processes together, for
+	  This option adds support for grouping sets of processes together, for
 	  use with process control subsystems such as Cpusets, CFS, memory
 	  controls or device isolation.
 	  See
@@ -343,6 +342,8 @@ config CGROUPS
 
 	  Say N if unsure.
 
+if CGROUPS
+
 config CGROUP_DEBUG
 	bool "Example debug cgroup subsystem"
 	depends on CGROUPS
@@ -350,24 +351,24 @@ config CGROUP_DEBUG
 	help
 	  This option enables a simple cgroup subsystem that
 	  exports useful debugging information about the cgroups
-	  framework
+	  framework.
 
-	  Say N if unsure
+	  Say N if unsure.
 
 config CGROUP_NS
-        bool "Namespace cgroup subsystem"
-        depends on CGROUPS
-        help
-          Provides a simple namespace cgroup subsystem to
-          provide hierarchical naming of sets of namespaces,
-          for instance virtual servers and checkpoint/restart
-          jobs.
+	bool "Namespace cgroup subsystem"
+	depends on CGROUPS
+	help
+	  Provides a simple namespace cgroup subsystem to
+	  provide hierarchical naming of sets of namespaces,
+	  for instance virtual servers and checkpoint/restart
+	  jobs.
 
 config CGROUP_FREEZER
-        bool "control group freezer subsystem"
-        depends on CGROUPS
-        help
-          Provides a way to freeze and unfreeze all tasks in a
+	bool "Freezer cgroup subsystem"
+	depends on CGROUPS
+	help
+	  Provides a way to freeze and unfreeze all tasks in a
 	  cgroup.
 
 config CGROUP_DEVICE
@@ -388,18 +389,23 @@ config CPUSETS
 
 	  Say N if unsure.
 
+config PROC_PID_CPUSET
+	bool "Include legacy /proc/<pid>/cpuset file"
+	depends on CPUSETS
+	default y
+
 config CGROUP_CPUACCT
 	bool "Simple CPU accounting cgroup subsystem"
 	depends on CGROUPS
 	help
 	  Provides a simple Resource Controller for monitoring the
-	  total CPU consumed by the tasks in a cgroup
+	  total CPU consumed by the tasks in a cgroup.
 
 config RESOURCE_COUNTERS
 	bool "Resource counters"
 	help
 	  This option enables controller independent resource accounting
-          infrastructure that works with cgroups
+	  infrastructure that works with cgroups.
 	depends on CGROUPS
 
 config CGROUP_MEM_RES_CTLR
@@ -425,9 +431,6 @@ config CGROUP_MEM_RES_CTLR
 	  This config option also selects MM_OWNER config option, which
 	  could in turn add some fork/exit overhead.
 
-config MM_OWNER
-	bool
-
 config CGROUP_MEM_RES_CTLR_SWAP
 	bool "Memory Resource Controller Swap Extension(EXPERIMENTAL)"
 	depends on CGROUP_MEM_RES_CTLR && SWAP && EXPERIMENTAL
@@ -444,8 +447,10 @@ config CGROUP_MEM_RES_CTLR_SWAP
 	  there will be no overhead from this. Even when you set this config=y,
 	  if boot option "noswapaccount" is set, swap will not be accounted.
 
+endif # CGROUPS
 
-endmenu
+config MM_OWNER
+	bool
 
 config SYSFS_DEPRECATED
 	bool
@@ -483,11 +488,6 @@ config SYSFS_DEPRECATED_V2
 	  if the original kernel, that came with your distribution, has
 	  this option set to N.
 
-config PROC_PID_CPUSET
-	bool "Include legacy /proc/<pid>/cpuset file"
-	depends on CPUSETS
-	default y
