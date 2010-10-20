From: akpm@linux-foundation.org
Subject: + namespaces-kconfig-remove-pointless-cgroup-dependency.patch added to -mm tree
Date: Wed, 20 Oct 2010 16:28:22 -0700
Message-ID: <201010202328.o9KNSMTV010929@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50235 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750975Ab0JTX2d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Oct 2010 19:28:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel.lezcano@free.fr, ebiederm@xmission.com, lizf@cn.fujitsu.com, menage@google.com, serue@us.ibm.com


The patch titled
     namespaces Kconfig: remove pointless cgroup dependency
has been added to the -mm tree.  Its filename is
     namespaces-kconfig-remove-pointless-cgroup-dependency.patch

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
Subject: namespaces Kconfig: remove pointless cgroup dependency
From: Daniel Lezcano <daniel.lezcano@free.fr>

The different cgroup subsystems are under the cgroup submenu.  The
dependency between the cgroups and the menu subsystems is pointless.

Signed-off-by: Daniel Lezcano <daniel.lezcano@free.fr>
Acked-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff -puN init/Kconfig~namespaces-kconfig-remove-pointless-cgroup-dependency init/Kconfig
--- a/init/Kconfig~namespaces-kconfig-remove-pointless-cgroup-dependency
+++ a/init/Kconfig
@@ -518,7 +518,6 @@ if CGROUPS
 
 config CGROUP_DEBUG
 	bool "Example debug cgroup subsystem"
-	depends on CGROUPS
 	default n
 	help
 	  This option enables a simple cgroup subsystem that
@@ -529,7 +528,6 @@ config CGROUP_DEBUG
 
 config CGROUP_NS
 	bool "Namespace cgroup subsystem"
-	depends on CGROUPS
 	help
 	  Provides a simple namespace cgroup subsystem to
 	  provide hierarchical naming of sets of namespaces,
@@ -538,21 +536,19 @@ config CGROUP_NS
 
 config CGROUP_FREEZER
 	bool "Freezer cgroup subsystem"
-	depends on CGROUPS
 	help
 	  Provides a way to freeze and unfreeze all tasks in a
 	  cgroup.
 
 config CGROUP_DEVICE
 	bool "Device controller for cgroups"
-	depends on CGROUPS && EXPERIMENTAL
+	depends on EXPERIMENTAL
 	help
 	  Provides a cgroup implementing whitelists for devices which
 	  a process in the cgroup can mknod or open.
 
 config CPUSETS
 	bool "Cpuset support"
-	depends on CGROUPS
 	help
 	  This option will let you create and manage CPUSETs which
 	  allow dynamically partitioning a system into sets of CPUs and
@@ -568,7 +564,6 @@ config PROC_PID_CPUSET
 
 config CGROUP_CPUACCT
 	bool "Simple CPU accounting cgroup subsystem"
-	depends on CGROUPS
 	help
 	  Provides a simple Resource Controller for monitoring the
 	  total CPU consumed by the tasks in a cgroup.
@@ -578,11 +573,10 @@ config RESOURCE_COUNTERS
 	help
 	  This option enables controller independent resource accounting
 	  infrastructure that works with cgroups.
-	depends on CGROUPS
 
 config CGROUP_MEM_RES_CTLR
 	bool "Memory Resource Controller for Control Groups"
-	depends on CGROUPS && RESOURCE_COUNTERS
+	depends on RESOURCE_COUNTERS
 	select MM_OWNER
 	help
 	  Provides a memory resource controller that manages both anonymous
@@ -623,7 +617,7 @@ config CGROUP_MEM_RES_CTLR_SWAP
 
 menuconfig CGROUP_SCHED
 	bool "Group CPU scheduler"
-	depends on EXPERIMENTAL && CGROUPS
+	depends on EXPERIMENTAL
 	default n
 	help
 	  This feature lets CPU scheduler recognize task groups and control CPU
@@ -652,7 +646,7 @@ endif #CGROUP_SCHED
 
 config BLK_CGROUP
 	tristate "Block IO controller"
-	depends on CGROUPS && BLOCK
+	depends on BLOCK
 	default n
 	---help---
 	Generic block IO controller cgroup interface. This is the common
_

Patches currently in -mm which might be from daniel.lezcano@free.fr are

linux-next.patch
cgroup-add-clone_children-control-file.patch
cgroup-make-the-mount-options-parsing-more-accurate.patch
cgroup-notify-ns_cgroup-deprecated.patch
namespaces-remove-pid_ns-and-net_ns-experimental-status.patch
namespaces-default-all-the-namespaces-to-yes-when-config_namespaces-is-selected.patch
namespaces-kconfig-make-namespace-a-submenu.patch
namespaces-kconfig-remove-pointless-cgroup-dependency.patch
namespaces-kconfig-remove-the-cgroup-device-whitelist-experimental-tag.patch
namespaces-kconfig-move-namespace-menu-location-after-the-cgroup.patch

