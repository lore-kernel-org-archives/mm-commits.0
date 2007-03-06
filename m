From: akpm@linux-foundation.org
Subject: - linux-sysdevh-needs-to-include-linux-moduleh-up-fix.patch removed from -mm tree
Date: Tue, 06 Mar 2007 02:52:01 -0800
Message-ID: <200703061052.l26Aq1kM020311@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35391 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965833AbXCFKze (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 05:55:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@suse.de, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     linux-sysdevh-needs-to-include-linux-moduleh-up-fix
has been removed from the -mm tree.  Its filename was
     linux-sysdevh-needs-to-include-linux-moduleh-up-fix.patch

This patch was dropped because it was folded into linux-sysdevh-needs-to-include-linux-moduleh.patch

------------------------------------------------------
Subject: linux-sysdevh-needs-to-include-linux-moduleh-up-fix
From: Andrew Morton <akpm@linux-foundation.org>

In file included from include/linux/utsname.h:35,
                 from include/asm/elf.h:12,
                 from include/linux/elf.h:7,
                 from include/linux/module.h:15,
                 from include/linux/sysdev.h:25,
                 from kernel/time/clocksource.c:28:
include/linux/sched.h:1648: warning: 'struct sysdev_class' declared inside parameter list
include/linux/sched.h:1648: warning: its scope is only this definition or declaration, which is probably not what you want

Cc: Andi Kleen <ak@suse.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpu.h   |    3 +++
 include/linux/sched.h |    3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/cpu.h~linux-sysdevh-needs-to-include-linux-moduleh-up-fix include/linux/cpu.h
--- a/include/linux/cpu.h~linux-sysdevh-needs-to-include-linux-moduleh-up-fix
+++ a/include/linux/cpu.h
@@ -41,6 +41,9 @@ extern void cpu_remove_sysdev_attr(struc
 extern int cpu_add_sysdev_attr_group(struct attribute_group *attrs);
 extern void cpu_remove_sysdev_attr_group(struct attribute_group *attrs);
 
+extern struct sysdev_attribute attr_sched_mc_power_savings;
+extern struct sysdev_attribute attr_sched_smt_power_savings;
+extern int sched_create_sysfs_power_savings_entries(struct sysdev_class *cls);
 
 #ifdef CONFIG_HOTPLUG_CPU
 extern void unregister_cpu(struct cpu *cpu);
diff -puN include/linux/sched.h~linux-sysdevh-needs-to-include-linux-moduleh-up-fix include/linux/sched.h
--- a/include/linux/sched.h~linux-sysdevh-needs-to-include-linux-moduleh-up-fix
+++ a/include/linux/sched.h
@@ -1641,10 +1641,7 @@ static inline void arch_pick_mmap_layout
 extern long sched_setaffinity(pid_t pid, cpumask_t new_mask);
 extern long sched_getaffinity(pid_t pid, cpumask_t *mask);
 
-#include <linux/sysdev.h>
 extern int sched_mc_power_savings, sched_smt_power_savings;
-extern struct sysdev_attribute attr_sched_mc_power_savings, attr_sched_smt_power_savings;
-extern int sched_create_sysfs_power_savings_entries(struct sysdev_class *cls);
 
 extern void normalize_rt_tasks(void);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fix-build-with-config_no_idle_hz=n.patch
highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-alsa-oops-fix.patch
git-drm.patch
git-dvb.patch
gfs2-build-fix.patch
git-input.patch
git-md-accel-fixup.patch
git-mmc-fix-99.patch
git-ubi.patch
git-netdev-all.patch
git-netdev-all-ipw2200-fix.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume.patch
sis900-warning-fixes.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device.patch
git-wireless-fixup.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
linux-sysdevh-needs-to-include-linux-moduleh-up-fix.patch
linux-sysdevh-needs-to-include-linux-moduleh-up-fix-2.patch
x86_64-irq-make-affinity-works-for-genapic_flat-mode-tidy.patch
i386-vdso_prelink-warning-fix.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
driver_bfin_serial_core-update.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
utrace-prep.patch
utrace-prep-2.patch
revert-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
fbdev-hecuba-framebuffer-driver.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
