From: akpm@linux-foundation.org
Subject: + linux-sysdevh-needs-to-include-linux-moduleh-up-fix.patch added to -mm tree
Date: Thu, 01 Mar 2007 22:11:52 -0800
Message-ID: <200703020613.l226DRVC001961@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44688 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422947AbXCBGQr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 01:16:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ak@suse.de, ralf@linux-mips.org


The patch titled
     linux-sysdevh-needs-to-include-linux-moduleh-up-fix
has been added to the -mm tree.  Its filename is
     linux-sysdevh-needs-to-include-linux-moduleh-up-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1642,10 +1642,7 @@ static inline void arch_pick_mmap_layout
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
cyclades-return-closing_wait.patch
make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-drm.patch
git-dvb.patch
git-dvb-fixup.patch
pvrusb-warning-fix.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-kvm.patch
git-leds-fixup.patch
git-leds-make-it-compile.patch
git-md-accel-fixup.patch
nommu-present-backing-device-capabilities-for-mtd-fix.patch
git-ubi.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
cisco_ioctl-initialise-header_cache_update.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-block-another-md-fix.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch
after-before-x86_64-mm-mmconfig-share.patch
linux-sysdevh-needs-to-include-linux-moduleh-up-fix.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial-up-fix.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial-tweak.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
driver_bfin_serial_core-update.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-2.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler-up-fix.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy.patch
utrace-prep.patch
utrace-prep-2.patch
revert-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
