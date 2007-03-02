From: akpm@linux-foundation.org
Subject: + git-acpi-fix-cpuidle-borkage.patch added to -mm tree
Date: Thu, 01 Mar 2007 23:37:45 -0800
Message-ID: <200703020739.l227dJue003395@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47213 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161318AbXCBHjX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 02:39:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, abelay@novell.com, len.brown@intel.com, shaohua.li@intel.com, venkatesh.pallipadi@intel.com


The patch titled
     git-acpi-fix-cpuidle-borkage
has been added to the -mm tree.  Its filename is
     git-acpi-fix-cpuidle-borkage.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-acpi-fix-cpuidle-borkage
From: Andrew Morton <akpm@linux-foundation.org>

This is pretty pathetic.

Don't apply this patch - please fix it properly.

Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Adam Belay <abelay@novell.com>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_core.c |    5 ++++-
 drivers/acpi/processor_idle.c |    4 ++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff -puN include/linux/cpuidle.h~git-acpi-fix-cpuidle-borkage include/linux/cpuidle.h
diff -puN drivers/acpi/processor_idle.c~git-acpi-fix-cpuidle-borkage drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~git-acpi-fix-cpuidle-borkage
+++ a/drivers/acpi/processor_idle.c
@@ -623,7 +623,11 @@ int acpi_processor_cst_has_changed(struc
 		return -ENODEV;
 
 	acpi_processor_get_power_info(pr);
+#ifdef CONFIG_CPU_IDLE
 	return cpuidle_force_redetect(&per_cpu(cpuidle_devices, pr->id));
+#else
+	return 0;
+#endif
 }
 
 /* proc interface */
diff -puN drivers/acpi/processor_core.c~git-acpi-fix-cpuidle-borkage drivers/acpi/processor_core.c
--- a/drivers/acpi/processor_core.c~git-acpi-fix-cpuidle-borkage
+++ a/drivers/acpi/processor_core.c
@@ -1029,14 +1029,17 @@ static int __init acpi_processor_init(vo
 
 	acpi_processor_ppc_init();
 
+#ifdef CONFIG_CPU_IDLE
 	cpuidle_register_driver(&acpi_idle_driver);
+#endif
 	return 0;
 }
 
 static void __exit acpi_processor_exit(void)
 {
+#ifdef CONFIG_CPU_IDLE
 	cpuidle_unregister_driver(&acpi_idle_driver);
-
+#endif
 	acpi_processor_ppc_exit();
 
 	acpi_thermal_cpufreq_exit();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
cyclades-return-closing_wait.patch
md-fix-for-raid6-reshape-fix.patch
slab-introduce-krealloc-fix.patch
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
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
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
git-acpi-fix-cpuidle-borkage.patch
