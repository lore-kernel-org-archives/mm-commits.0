From: akpm@linux-foundation.org
Subject: - linux-sysdevh-needs-to-include-linux-moduleh.patch removed from -mm tree
Date: Tue, 08 May 2007 19:48:03 -0700
Message-ID: <200705090248.l492m3bA009049@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934850AbXEICsR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:48:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, ak@suse.de, heiko.carstens@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     <linux/sysdev.h> needs to include <linux/module.h>
has been removed from the -mm tree.  Its filename was
     linux-sysdevh-needs-to-include-linux-moduleh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: <linux/sysdev.h> needs to include <linux/module.h>
From: Ralf Baechle <ralf@linux-mips.org>

sysdev.h uses THIS_MODULE so should include <linux/module.h>.

[akpm@linux-foundation.org: couple of fixes]
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/time.c |    1 +
 include/linux/cpu.h     |    3 +++
 include/linux/sched.h   |    3 ---
 include/linux/sysdev.h  |    1 +
 4 files changed, 5 insertions(+), 3 deletions(-)

diff -puN arch/s390/kernel/time.c~linux-sysdevh-needs-to-include-linux-moduleh arch/s390/kernel/time.c
--- a/arch/s390/kernel/time.c~linux-sysdevh-needs-to-include-linux-moduleh
+++ a/arch/s390/kernel/time.c
@@ -21,6 +21,7 @@
 #include <linux/mm.h>
 #include <linux/interrupt.h>
 #include <linux/time.h>
+#include <linux/sysdev.h>
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/smp.h>
diff -puN include/linux/cpu.h~linux-sysdevh-needs-to-include-linux-moduleh include/linux/cpu.h
--- a/include/linux/cpu.h~linux-sysdevh-needs-to-include-linux-moduleh
+++ a/include/linux/cpu.h
@@ -41,6 +41,9 @@ extern void cpu_remove_sysdev_attr(struc
 extern int cpu_add_sysdev_attr_group(struct attribute_group *attrs);
 extern void cpu_remove_sysdev_attr_group(struct attribute_group *attrs);
 
+extern struct sysdev_attribute attr_sched_mc_power_savings;
+extern struct sysdev_attribute attr_sched_smt_power_savings;
+extern int sched_create_sysfs_power_savings_entries(struct sysdev_class *cls);
 
 #ifdef CONFIG_HOTPLUG_CPU
 extern void unregister_cpu(struct cpu *cpu);
diff -puN include/linux/sched.h~linux-sysdevh-needs-to-include-linux-moduleh include/linux/sched.h
--- a/include/linux/sched.h~linux-sysdevh-needs-to-include-linux-moduleh
+++ a/include/linux/sched.h
@@ -1641,10 +1641,7 @@ static inline void arch_pick_mmap_layout
 extern long sched_setaffinity(pid_t pid, cpumask_t new_mask);
 extern long sched_getaffinity(pid_t pid, cpumask_t *mask);
 
-#include <linux/sysdev.h>
 extern int sched_mc_power_savings, sched_smt_power_savings;
-extern struct sysdev_attribute attr_sched_mc_power_savings, attr_sched_smt_power_savings;
-extern int sched_create_sysfs_power_savings_entries(struct sysdev_class *cls);
 
 extern void normalize_rt_tasks(void);
 
diff -puN include/linux/sysdev.h~linux-sysdevh-needs-to-include-linux-moduleh include/linux/sysdev.h
--- a/include/linux/sysdev.h~linux-sysdevh-needs-to-include-linux-moduleh
+++ a/include/linux/sysdev.h
@@ -22,6 +22,7 @@
 #define _SYSDEV_H_
 
 #include <linux/kobject.h>
+#include <linux/module.h>
 #include <linux/pm.h>
 
 
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
git-alsa.patch
git-mips.patch
introduce-freezer-flags-rev-2.patch
mips-excite-use-__maybe_unused.patch
mips-tlbex-use-__maybe_unused.patch
