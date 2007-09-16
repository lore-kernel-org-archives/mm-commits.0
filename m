From: akpm@linux-foundation.org
Subject: + task-containers-enable-containers-by-default-in-some-configs.patch added to -mm tree
Date: Sat, 15 Sep 2007 22:38:51 -0700
Message-ID: <200709160538.l8G5cpsM002119@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32838 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978AbXIPFjA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 01:39:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pj@sgi.com, menage@google.com


The patch titled
     task containers: enable containers by default in some configs
has been added to the -mm tree.  Its filename is
     task-containers-enable-containers-by-default-in-some-configs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: task containers: enable containers by default in some configs
From: Paul Jackson <pj@sgi.com>

In pre-container cpusets, a few config files enabled cpusets by default. 

Signed-off-by: Paul Jackson <pj@sgi.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/configs/sn2_defconfig          |    1 +
 arch/mips/configs/ip27_defconfig         |    1 +
 arch/mips/configs/sb1250-swarm_defconfig |    1 +
 arch/powerpc/configs/cell_defconfig      |    1 +
 arch/powerpc/configs/ppc64_defconfig     |    1 +
 arch/powerpc/configs/pseries_defconfig   |    1 +
 6 files changed, 6 insertions(+)

diff -puN arch/ia64/configs/sn2_defconfig~task-containers-enable-containers-by-default-in-some-configs arch/ia64/configs/sn2_defconfig
--- a/arch/ia64/configs/sn2_defconfig~task-containers-enable-containers-by-default-in-some-configs
+++ a/arch/ia64/configs/sn2_defconfig
@@ -27,6 +27,7 @@ CONFIG_TASKSTATS=y
 # CONFIG_UTS_NS is not set
 # CONFIG_AUDIT is not set
 # CONFIG_IKCONFIG is not set
+CONFIG_CONTAINERS=y
 CONFIG_CPUSETS=y
 CONFIG_RELAY=y
 CONFIG_INITRAMFS_SOURCE=""
diff -puN arch/mips/configs/ip27_defconfig~task-containers-enable-containers-by-default-in-some-configs arch/mips/configs/ip27_defconfig
--- a/arch/mips/configs/ip27_defconfig~task-containers-enable-containers-by-default-in-some-configs
+++ a/arch/mips/configs/ip27_defconfig
@@ -175,6 +175,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=15
+CONFIG_CONTAINERS=y
 CONFIG_CPUSETS=y
 CONFIG_SYSFS_DEPRECATED=y
 CONFIG_RELAY=y
diff -puN arch/mips/configs/sb1250-swarm_defconfig~task-containers-enable-containers-by-default-in-some-configs arch/mips/configs/sb1250-swarm_defconfig
--- a/arch/mips/configs/sb1250-swarm_defconfig~task-containers-enable-containers-by-default-in-some-configs
+++ a/arch/mips/configs/sb1250-swarm_defconfig
@@ -197,6 +197,7 @@ CONFIG_SYSVIPC_SYSCTL=y
 # CONFIG_UTS_NS is not set
 # CONFIG_AUDIT is not set
 # CONFIG_IKCONFIG is not set
+CONFIG_CONTAINERS=y
 CONFIG_CPUSETS=y
 CONFIG_SYSFS_DEPRECATED=y
 CONFIG_RELAY=y
diff -puN arch/powerpc/configs/cell_defconfig~task-containers-enable-containers-by-default-in-some-configs arch/powerpc/configs/cell_defconfig
--- a/arch/powerpc/configs/cell_defconfig~task-containers-enable-containers-by-default-in-some-configs
+++ a/arch/powerpc/configs/cell_defconfig
@@ -68,6 +68,7 @@ CONFIG_SYSVIPC_SYSCTL=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=15
+CONFIG_CONTAINERS=y
 CONFIG_CPUSETS=y
 CONFIG_SYSFS_DEPRECATED=y
 # CONFIG_RELAY is not set
diff -puN arch/powerpc/configs/ppc64_defconfig~task-containers-enable-containers-by-default-in-some-configs arch/powerpc/configs/ppc64_defconfig
--- a/arch/powerpc/configs/ppc64_defconfig~task-containers-enable-containers-by-default-in-some-configs
+++ a/arch/powerpc/configs/ppc64_defconfig
@@ -71,6 +71,7 @@ CONFIG_TASK_DELAY_ACCT=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=17
+CONFIG_CONTAINERS=y
 CONFIG_CPUSETS=y
 CONFIG_SYSFS_DEPRECATED=y
 CONFIG_RELAY=y
diff -puN arch/powerpc/configs/pseries_defconfig~task-containers-enable-containers-by-default-in-some-configs arch/powerpc/configs/pseries_defconfig
--- a/arch/powerpc/configs/pseries_defconfig~task-containers-enable-containers-by-default-in-some-configs
+++ a/arch/powerpc/configs/pseries_defconfig
@@ -71,6 +71,7 @@ CONFIG_AUDITSYSCALL=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=17
+CONFIG_CONTAINERS=y
 CONFIG_CPUSETS=y
 CONFIG_SYSFS_DEPRECATED=y
 # CONFIG_RELAY is not set
_

Patches currently in -mm which might be from pj@sgi.com are

cpuset-remove-sched-domain-hooks-from-cpusets.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
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
task-containers-enable-containers-by-default-in-some-configs.patch
whitespace-fixes-cpuset.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch
