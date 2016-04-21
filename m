From: akpm@linux-foundation.org
Subject: + arch-defconfig-remove-config_resource_counters.patch added to
 -mm tree
Date: Thu, 21 Apr 2016 16:34:17 -0700
Message-ID: <57196379.s1gcSf/BLBCqOtAE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34585 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbcDUXeS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2016 19:34:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koct9i@gmail.com, arnd@arndb.de, bsingharora@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/defconfig: remove CONFIG_RESOURCE_COUNTERS
has been added to the -mm tree.  Its filename is
     arch-defconfig-remove-config_resource_counters.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-defconfig-remove-config_resource_counters.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-defconfig-remove-config_resource_counters.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: arch/defconfig: remove CONFIG_RESOURCE_COUNTERS

This option was replaced by PAGE_COUNTER which is selected by MEMCG.

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/configs/bcm_defconfig              |    1 -
 arch/arm/configs/zx_defconfig               |    1 -
 arch/mips/configs/db1xxx_defconfig          |    1 -
 arch/mips/configs/loongson3_defconfig       |    1 -
 arch/mn10300/configs/asb2364_defconfig      |    1 -
 arch/sh/configs/apsh4ad0a_defconfig         |    1 -
 arch/sh/configs/sdk7786_defconfig           |    1 -
 arch/sh/configs/se7206_defconfig            |    1 -
 arch/sh/configs/shx3_defconfig              |    1 -
 arch/sh/configs/urquell_defconfig           |    1 -
 arch/tile/configs/tilegx_defconfig          |    1 -
 arch/tile/configs/tilepro_defconfig         |    1 -
 arch/um/configs/i386_defconfig              |    1 -
 arch/um/configs/x86_64_defconfig            |    1 -
 arch/x86/configs/i386_defconfig             |    1 -
 arch/x86/configs/x86_64_defconfig           |    1 -
 arch/xtensa/configs/generic_kc705_defconfig |    1 -
 arch/xtensa/configs/smp_lx200_defconfig     |    1 -
 18 files changed, 18 deletions(-)

diff -puN arch/arm/configs/bcm_defconfig~arch-defconfig-remove-config_resource_counters arch/arm/configs/bcm_defconfig
--- a/arch/arm/configs/bcm_defconfig~arch-defconfig-remove-config_resource_counters
+++ a/arch/arm/configs/bcm_defconfig
@@ -12,7 +12,6 @@ CONFIG_CGROUPS=y
 CONFIG_CGROUP_FREEZER=y
 CONFIG_CGROUP_DEVICE=y
 CONFIG_CGROUP_CPUACCT=y
-CONFIG_RESOURCE_COUNTERS=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_BLK_CGROUP=y
 CONFIG_NAMESPACES=y
diff -puN arch/arm/configs/zx_defconfig~arch-defconfig-remove-config_resource_counters arch/arm/configs/zx_defconfig
--- a/arch/arm/configs/zx_defconfig~arch-defconfig-remove-config_resource_counters
+++ a/arch/arm/configs/zx_defconfig
@@ -7,7 +7,6 @@ CONFIG_CGROUPS=y
 CONFIG_CGROUP_DEBUG=y
 CONFIG_CGROUP_FREEZER=y
 CONFIG_CGROUP_CPUACCT=y
-CONFIG_RESOURCE_COUNTERS=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_RT_GROUP_SCHED=y
 CONFIG_NAMESPACES=y
diff -puN arch/mips/configs/db1xxx_defconfig~arch-defconfig-remove-config_resource_counters arch/mips/configs/db1xxx_defconfig
--- a/arch/mips/configs/db1xxx_defconfig~arch-defconfig-remove-config_resource_counters
+++ a/arch/mips/configs/db1xxx_defconfig
@@ -18,7 +18,6 @@ CONFIG_CGROUP_FREEZER=y
 CONFIG_CGROUP_DEVICE=y
 CONFIG_CPUSETS=y
 CONFIG_CGROUP_CPUACCT=y
-CONFIG_RESOURCE_COUNTERS=y
 CONFIG_MEMCG=y
 CONFIG_MEMCG_SWAP=y
 CONFIG_MEMCG_KMEM=y
diff -puN arch/mips/configs/loongson3_defconfig~arch-defconfig-remove-config_resource_counters arch/mips/configs/loongson3_defconfig
--- a/arch/mips/configs/loongson3_defconfig~arch-defconfig-remove-config_resource_counters
+++ a/arch/mips/configs/loongson3_defconfig
@@ -25,7 +25,6 @@ CONFIG_TASK_XACCT=y
 CONFIG_TASK_IO_ACCOUNTING=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_CPUSETS=y
-CONFIG_RESOURCE_COUNTERS=y
 CONFIG_MEMCG=y
 CONFIG_MEMCG_SWAP=y
 CONFIG_BLK_CGROUP=y
diff -puN arch/mn10300/configs/asb2364_defconfig~arch-defconfig-remove-config_resource_counters arch/mn10300/configs/asb2364_defconfig
--- a/arch/mn10300/configs/asb2364_defconfig~arch-defconfig-remove-config_resource_counters
+++ a/arch/mn10300/configs/asb2364_defconfig
@@ -11,7 +11,6 @@ CONFIG_CGROUPS=y
 CONFIG_CGROUP_FREEZER=y
 CONFIG_CGROUP_DEVICE=y
 CONFIG_CGROUP_CPUACCT=y
-CONFIG_RESOURCE_COUNTERS=y
 CONFIG_RELAY=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
diff -puN arch/sh/configs/apsh4ad0a_defconfig~arch-defconfig-remove-config_resource_counters arch/sh/configs/apsh4ad0a_defconfig
--- a/arch/sh/configs/apsh4ad0a_defconfig~arch-defconfig-remove-config_resource_counters
+++ a/arch/sh/configs/apsh4ad0a_defconfig
@@ -10,7 +10,6 @@ CONFIG_CGROUPS=y
 CONFIG_CGROUP_FREEZER=y
 CONFIG_CGROUP_DEVICE=y
 CONFIG_CGROUP_CPUACCT=y
-CONFIG_RESOURCE_COUNTERS=y
 CONFIG_CGROUP_MEMCG=y
 CONFIG_BLK_CGROUP=y
 CONFIG_NAMESPACES=y
diff -puN arch/sh/configs/sdk7786_defconfig~arch-defconfig-remove-config_resource_counters arch/sh/configs/sdk7786_defconfig
--- a/arch/sh/configs/sdk7786_defconfig~arch-defconfig-remove-config_resource_counters
+++ a/arch/sh/configs/sdk7786_defconfig
@@ -17,7 +17,6 @@ CONFIG_CGROUP_DEVICE=y
 CONFIG_CPUSETS=y
 # CONFIG_PROC_PID_CPUSET is not set
 CONFIG_CGROUP_CPUACCT=y
-CONFIG_RESOURCE_COUNTERS=y
 CONFIG_CGROUP_MEMCG=y
 CONFIG_CGROUP_MEMCG_SWAP=y
 CONFIG_CGROUP_SCHED=y
diff -puN arch/sh/configs/se7206_defconfig~arch-defconfig-remove-config_resource_counters arch/sh/configs/se7206_defconfig
--- a/arch/sh/configs/se7206_defconfig~arch-defconfig-remove-config_resource_counters
+++ a/arch/sh/configs/se7206_defconfig
@@ -10,7 +10,6 @@ CONFIG_CGROUPS=y
 CONFIG_CGROUP_DEBUG=y
 CONFIG_CGROUP_DEVICE=y
 CONFIG_CGROUP_CPUACCT=y
-CONFIG_RESOURCE_COUNTERS=y
 CONFIG_CGROUP_MEMCG=y
 CONFIG_RELAY=y
 CONFIG_NAMESPACES=y
diff -puN arch/sh/configs/shx3_defconfig~arch-defconfig-remove-config_resource_counters arch/sh/configs/shx3_defconfig
--- a/arch/sh/configs/shx3_defconfig~arch-defconfig-remove-config_resource_counters
+++ a/arch/sh/configs/shx3_defconfig
@@ -12,7 +12,6 @@ CONFIG_CGROUPS=y
 CONFIG_CGROUP_FREEZER=y
 CONFIG_CGROUP_DEVICE=y
 CONFIG_CGROUP_CPUACCT=y
-CONFIG_RESOURCE_COUNTERS=y
 CONFIG_CGROUP_MEMCG=y
 CONFIG_RELAY=y
 CONFIG_NAMESPACES=y
diff -puN arch/sh/configs/urquell_defconfig~arch-defconfig-remove-config_resource_counters arch/sh/configs/urquell_defconfig
--- a/arch/sh/configs/urquell_defconfig~arch-defconfig-remove-config_resource_counters
+++ a/arch/sh/configs/urquell_defconfig
@@ -14,7 +14,6 @@ CONFIG_CGROUP_DEVICE=y
 CONFIG_CPUSETS=y
 # CONFIG_PROC_PID_CPUSET is not set
 CONFIG_CGROUP_CPUACCT=y
-CONFIG_RESOURCE_COUNTERS=y
 CONFIG_CGROUP_MEMCG=y
 CONFIG_CGROUP_MEMCG_SWAP=y
 CONFIG_CGROUP_SCHED=y
diff -puN arch/tile/configs/tilegx_defconfig~arch-defconfig-remove-config_resource_counters arch/tile/configs/tilegx_defconfig
--- a/arch/tile/configs/tilegx_defconfig~arch-defconfig-remove-config_resource_counters
+++ a/arch/tile/configs/tilegx_defconfig
@@ -16,7 +16,6 @@ CONFIG_CGROUP_DEBUG=y
 CONFIG_CGROUP_DEVICE=y
 CONFIG_CPUSETS=y
 CONFIG_CGROUP_CPUACCT=y
-CONFIG_RESOURCE_COUNTERS=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_RT_GROUP_SCHED=y
 CONFIG_BLK_CGROUP=y
diff -puN arch/tile/configs/tilepro_defconfig~arch-defconfig-remove-config_resource_counters arch/tile/configs/tilepro_defconfig
--- a/arch/tile/configs/tilepro_defconfig~arch-defconfig-remove-config_resource_counters
+++ a/arch/tile/configs/tilepro_defconfig
@@ -15,7 +15,6 @@ CONFIG_CGROUP_DEBUG=y
 CONFIG_CGROUP_DEVICE=y
 CONFIG_CPUSETS=y
 CONFIG_CGROUP_CPUACCT=y
-CONFIG_RESOURCE_COUNTERS=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_RT_GROUP_SCHED=y
 CONFIG_BLK_CGROUP=y
diff -puN arch/um/configs/i386_defconfig~arch-defconfig-remove-config_resource_counters arch/um/configs/i386_defconfig
--- a/arch/um/configs/i386_defconfig~arch-defconfig-remove-config_resource_counters
+++ a/arch/um/configs/i386_defconfig
@@ -17,7 +17,6 @@ CONFIG_CGROUP_FREEZER=y
 CONFIG_CGROUP_DEVICE=y
 CONFIG_CPUSETS=y
 CONFIG_CGROUP_CPUACCT=y
-CONFIG_RESOURCE_COUNTERS=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_BLK_CGROUP=y
 # CONFIG_PID_NS is not set
diff -puN arch/um/configs/x86_64_defconfig~arch-defconfig-remove-config_resource_counters arch/um/configs/x86_64_defconfig
--- a/arch/um/configs/x86_64_defconfig~arch-defconfig-remove-config_resource_counters
+++ a/arch/um/configs/x86_64_defconfig
@@ -15,7 +15,6 @@ CONFIG_CGROUP_FREEZER=y
 CONFIG_CGROUP_DEVICE=y
 CONFIG_CPUSETS=y
 CONFIG_CGROUP_CPUACCT=y
-CONFIG_RESOURCE_COUNTERS=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_BLK_CGROUP=y
 # CONFIG_PID_NS is not set
diff -puN arch/x86/configs/i386_defconfig~arch-defconfig-remove-config_resource_counters arch/x86/configs/i386_defconfig
--- a/arch/x86/configs/i386_defconfig~arch-defconfig-remove-config_resource_counters
+++ a/arch/x86/configs/i386_defconfig
@@ -17,7 +17,6 @@ CONFIG_CGROUPS=y
 CONFIG_CGROUP_FREEZER=y
 CONFIG_CPUSETS=y
 CONFIG_CGROUP_CPUACCT=y
-CONFIG_RESOURCE_COUNTERS=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_COMPAT_BRK is not set
diff -puN arch/x86/configs/x86_64_defconfig~arch-defconfig-remove-config_resource_counters arch/x86/configs/x86_64_defconfig
--- a/arch/x86/configs/x86_64_defconfig~arch-defconfig-remove-config_resource_counters
+++ a/arch/x86/configs/x86_64_defconfig
@@ -16,7 +16,6 @@ CONFIG_CGROUPS=y
 CONFIG_CGROUP_FREEZER=y
 CONFIG_CPUSETS=y
 CONFIG_CGROUP_CPUACCT=y
-CONFIG_RESOURCE_COUNTERS=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_COMPAT_BRK is not set
diff -puN arch/xtensa/configs/generic_kc705_defconfig~arch-defconfig-remove-config_resource_counters arch/xtensa/configs/generic_kc705_defconfig
--- a/arch/xtensa/configs/generic_kc705_defconfig~arch-defconfig-remove-config_resource_counters
+++ a/arch/xtensa/configs/generic_kc705_defconfig
@@ -11,7 +11,6 @@ CONFIG_CGROUP_FREEZER=y
 CONFIG_CGROUP_DEVICE=y
 CONFIG_CPUSETS=y
 CONFIG_CGROUP_CPUACCT=y
-CONFIG_RESOURCE_COUNTERS=y
 CONFIG_MEMCG=y
 CONFIG_NAMESPACES=y
 CONFIG_SCHED_AUTOGROUP=y
diff -puN arch/xtensa/configs/smp_lx200_defconfig~arch-defconfig-remove-config_resource_counters arch/xtensa/configs/smp_lx200_defconfig
--- a/arch/xtensa/configs/smp_lx200_defconfig~arch-defconfig-remove-config_resource_counters
+++ a/arch/xtensa/configs/smp_lx200_defconfig
@@ -11,7 +11,6 @@ CONFIG_CGROUP_FREEZER=y
 CONFIG_CGROUP_DEVICE=y
 CONFIG_CPUSETS=y
 CONFIG_CGROUP_CPUACCT=y
-CONFIG_RESOURCE_COUNTERS=y
 CONFIG_MEMCG=y
 CONFIG_NAMESPACES=y
 CONFIG_SCHED_AUTOGROUP=y
_

Patches currently in -mm which might be from koct9i@gmail.com are

mm-huge_memory-replace-vm_no_thp-vm_bug_on-with-actual-vma-check.patch
mm-mmap-kill-hook-arch_rebalance_pgtables.patch
arch-defconfig-remove-config_resource_counters.patch

