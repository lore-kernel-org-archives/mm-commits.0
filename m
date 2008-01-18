From: akpm@linux-foundation.org
Subject: + cpufreq-revert-get-core-affinity-from-acpi_processor_preregister_performance.patch added to -mm tree
Date: Fri, 18 Jan 2008 13:13:43 -0800
Message-ID: <200801182113.m0ILDhXn005504@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47321 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761782AbYARVOH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jan 2008 16:14:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, davej@codemonkey.org.uk, mark.langsdorf@amd.com, rjw@sisk.pl


The patch titled
     cpufreq: revert "Get core affinity from acpi_processor_preregister_performance()"
has been added to the -mm tree.  Its filename is
     cpufreq-revert-get-core-affinity-from-acpi_processor_preregister_performance.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpufreq: revert "Get core affinity from acpi_processor_preregister_performance()"
From: Andrew Morton <akpm@linux-foundation.org>

Breaks suspend.

Cc: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |  109 ++++++--------------
 arch/x86/kernel/cpu/cpufreq/powernow-k8.h |    4 
 2 files changed, 39 insertions(+), 74 deletions(-)

diff -puN arch/x86/kernel/cpu/cpufreq/powernow-k8.c~cpufreq-revert-get-core-affinity-from-acpi_processor_preregister_performance arch/x86/kernel/cpu/cpufreq/powernow-k8.c
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c~cpufreq-revert-get-core-affinity-from-acpi_processor_preregister_performance
+++ a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -29,7 +29,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/cpufreq.h>
-#include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/cpumask.h>
@@ -125,8 +124,7 @@ static int query_current_values_with_pen
 		return 0;
 	}
 	do {
-		msleep(5);
-		if (i++ > 1000) {
+		if (i++ > 10000) {
 			dprintk("detected change pending stuck\n");
 			return 1;
 		}
@@ -722,7 +720,6 @@ static int find_psb_table(struct powerno
 
 		data->numps = psb->numps;
 		dprintk("numpstates: 0x%x\n", data->numps);
-		data->starting_core_affinity = cpumask_of_cpu(0);
 		return fill_powernow_table(data, (struct pst_s *)(psb+1), maxvid);
 	}
 	/*
@@ -743,29 +740,15 @@ static int find_psb_table(struct powerno
 #ifdef CONFIG_X86_POWERNOW_K8_ACPI
 static void powernow_k8_acpi_pst_values(struct powernow_k8_data *data, unsigned int index)
 {
-	if (!data->acpi_data->state_count || (cpu_family == CPU_HW_PSTATE))
+	if (!data->acpi_data.state_count || (cpu_family == CPU_HW_PSTATE))
 		return;
 
-	data->irt = (data->acpi_data->states[index].control >> IRT_SHIFT) & IRT_MASK;
-	data->rvo = (data->acpi_data->states[index].control >> RVO_SHIFT) & RVO_MASK;
-	data->exttype = (data->acpi_data->states[index].control >> EXT_TYPE_SHIFT) & EXT_TYPE_MASK;
-	data->plllock = (data->acpi_data->states[index].control >> PLL_L_SHIFT) & PLL_L_MASK;
-	data->vidmvs = 1 << ((data->acpi_data->states[index].control >> MVS_SHIFT) & MVS_MASK);
-	data->vstable = (data->acpi_data->states[index].control >> VST_SHIFT) & VST_MASK;
-}
-
-static struct acpi_processor_performance *acpi_perf_data;
-static int preregister_valid = 0;
-
-static int powernow_k8_cpu_preinit_acpi()
-{
-	acpi_perf_data = alloc_percpu(struct acpi_processor_performance);
-
-	if (acpi_processor_preregister_performance(acpi_perf_data))
-		return -ENODEV;
-	else
-		preregister_valid = 1;
-	return 0;
+	data->irt = (data->acpi_data.states[index].control >> IRT_SHIFT) & IRT_MASK;
+	data->rvo = (data->acpi_data.states[index].control >> RVO_SHIFT) & RVO_MASK;
+	data->exttype = (data->acpi_data.states[index].control >> EXT_TYPE_SHIFT) & EXT_TYPE_MASK;
+	data->plllock = (data->acpi_data.states[index].control >> PLL_L_SHIFT) & PLL_L_MASK;
+	data->vidmvs = 1 << ((data->acpi_data.states[index].control >> MVS_SHIFT) & MVS_MASK);
+	data->vstable = (data->acpi_data.states[index].control >> VST_SHIFT) & VST_MASK;
 }
 
 static int powernow_k8_cpu_init_acpi(struct powernow_k8_data *data)
@@ -773,29 +756,28 @@ static int powernow_k8_cpu_init_acpi(str
 	struct cpufreq_frequency_table *powernow_table;
 	int ret_val;
 
-	data->acpi_data = percpu_ptr(acpi_perf_data, data->cpu);
-	if (acpi_processor_register_performance(data->acpi_data, data->cpu)) {
+	if (acpi_processor_register_performance(&data->acpi_data, data->cpu)) {
 		dprintk("register performance failed: bad ACPI data\n");
 		return -EIO;
 	}
 
 	/* verify the data contained in the ACPI structures */
-	if (data->acpi_data->state_count <= 1) {
+	if (data->acpi_data.state_count <= 1) {
 		dprintk("No ACPI P-States\n");
 		goto err_out;
 	}
 
-	if ((data->acpi_data->control_register.space_id != ACPI_ADR_SPACE_FIXED_HARDWARE) ||
-		(data->acpi_data->status_register.space_id != ACPI_ADR_SPACE_FIXED_HARDWARE)) {
+	if ((data->acpi_data.control_register.space_id != ACPI_ADR_SPACE_FIXED_HARDWARE) ||
+		(data->acpi_data.status_register.space_id != ACPI_ADR_SPACE_FIXED_HARDWARE)) {
 		dprintk("Invalid control/status registers (%x - %x)\n",
-			data->acpi_data->control_register.space_id,
-			data->acpi_data->status_register.space_id);
+			data->acpi_data.control_register.space_id,
+			data->acpi_data.status_register.space_id);
 		goto err_out;
 	}
 
 	/* fill in data->powernow_table */
 	powernow_table = kmalloc((sizeof(struct cpufreq_frequency_table)
-		* (data->acpi_data->state_count + 1)), GFP_KERNEL);
+		* (data->acpi_data.state_count + 1)), GFP_KERNEL);
 	if (!powernow_table) {
 		dprintk("powernow_table memory alloc failure\n");
 		goto err_out;
@@ -808,12 +790,12 @@ static int powernow_k8_cpu_init_acpi(str
 	if (ret_val)
 		goto err_out_mem;
 
-	powernow_table[data->acpi_data->state_count].frequency = CPUFREQ_TABLE_END;
-	powernow_table[data->acpi_data->state_count].index = 0;
+	powernow_table[data->acpi_data.state_count].frequency = CPUFREQ_TABLE_END;
+	powernow_table[data->acpi_data.state_count].index = 0;
 	data->powernow_table = powernow_table;
 
 	/* fill in data */
-	data->numps = data->acpi_data->state_count;
+	data->numps = data->acpi_data.state_count;
 	if (first_cpu(per_cpu(cpu_core_map, data->cpu)) == data->cpu)
 		print_basics(data);
 	powernow_k8_acpi_pst_values(data, 0);
@@ -821,32 +803,16 @@ static int powernow_k8_cpu_init_acpi(str
 	/* notify BIOS that we exist */
 	acpi_processor_notify_smm(THIS_MODULE);
 
-	/* determine affinity, from ACPI if available */
-	if (preregister_valid) {
-		if ((data->acpi_data->shared_type == CPUFREQ_SHARED_TYPE_ALL) ||
-		    (data->acpi_data->shared_type == CPUFREQ_SHARED_TYPE_ANY))
-			data->starting_core_affinity = data->acpi_data->shared_cpu_map;
-		else
-			data->starting_core_affinity = cpumask_of_cpu(data->cpu);
-	} else {
-		/* best guess from family if not */
-		if (cpu_family == CPU_HW_PSTATE)
-			data->starting_core_affinity = cpumask_of_cpu(data->cpu);
-		else
-			data->starting_core_affinity = per_cpu(cpu_core_map, data->cpu);
-
-	}
-
 	return 0;
 
 err_out_mem:
 	kfree(powernow_table);
 
 err_out:
-	acpi_processor_unregister_performance(data->acpi_data, data->cpu);
+	acpi_processor_unregister_performance(&data->acpi_data, data->cpu);
 
-	/* data->acpi_data->state_count informs us at ->exit() whether ACPI was used */
-	data->acpi_data->state_count = 0;
+	/* data->acpi_data.state_count informs us at ->exit() whether ACPI was used */
+	data->acpi_data.state_count = 0;
 
 	return -ENODEV;
 }
@@ -858,11 +824,11 @@ static int fill_powernow_table_pstate(st
 	rdmsr(MSR_PSTATE_CUR_LIMIT, hi, lo);
 	data->max_hw_pstate = (hi & HW_PSTATE_MAX_MASK) >> HW_PSTATE_MAX_SHIFT;
 
-	for (i = 0; i < data->acpi_data->state_count; i++) {
+	for (i = 0; i < data->acpi_data.state_count; i++) {
 		u32 index;
 		u32 hi = 0, lo = 0;
 
-		index = data->acpi_data->states[i].control & HW_PSTATE_MASK;
+		index = data->acpi_data.states[i].control & HW_PSTATE_MASK;
 		if (index > data->max_hw_pstate) {
 			printk(KERN_ERR PFX "invalid pstate %d - bad value %d.\n", i, index);
 			printk(KERN_ERR PFX "Please report to BIOS manufacturer\n");
@@ -878,7 +844,7 @@ static int fill_powernow_table_pstate(st
 
 		powernow_table[i].index = index;
 
-		powernow_table[i].frequency = data->acpi_data->states[i].core_frequency * 1000;
+		powernow_table[i].frequency = data->acpi_data.states[i].core_frequency * 1000;
 	}
 	return 0;
 }
@@ -887,16 +853,16 @@ static int fill_powernow_table_fidvid(st
 {
 	int i;
 	int cntlofreq = 0;
-	for (i = 0; i < data->acpi_data->state_count; i++) {
+	for (i = 0; i < data->acpi_data.state_count; i++) {
 		u32 fid;
 		u32 vid;
 
 		if (data->exttype) {
-			fid = data->acpi_data->states[i].status & EXT_FID_MASK;
-			vid = (data->acpi_data->states[i].status >> VID_SHIFT) & EXT_VID_MASK;
+			fid = data->acpi_data.states[i].status & EXT_FID_MASK;
+			vid = (data->acpi_data.states[i].status >> VID_SHIFT) & EXT_VID_MASK;
 		} else {
-			fid = data->acpi_data->states[i].control & FID_MASK;
-			vid = (data->acpi_data->states[i].control >> VID_SHIFT) & VID_MASK;
+			fid = data->acpi_data.states[i].control & FID_MASK;
+			vid = (data->acpi_data.states[i].control >> VID_SHIFT) & VID_MASK;
 		}
 
 		dprintk("   %d : fid 0x%x, vid 0x%x\n", i, fid, vid);
@@ -937,10 +903,10 @@ static int fill_powernow_table_fidvid(st
 				cntlofreq = i;
 		}
 
-		if (powernow_table[i].frequency != (data->acpi_data->states[i].core_frequency * 1000)) {
+		if (powernow_table[i].frequency != (data->acpi_data.states[i].core_frequency * 1000)) {
 			printk(KERN_INFO PFX "invalid freq entries %u kHz vs. %u kHz\n",
 				powernow_table[i].frequency,
-				(unsigned int) (data->acpi_data->states[i].core_frequency * 1000));
+				(unsigned int) (data->acpi_data.states[i].core_frequency * 1000));
 			powernow_table[i].frequency = CPUFREQ_ENTRY_INVALID;
 			continue;
 		}
@@ -950,15 +916,14 @@ static int fill_powernow_table_fidvid(st
 
 static void powernow_k8_cpu_exit_acpi(struct powernow_k8_data *data)
 {
-	if (data->acpi_data->state_count)
-		acpi_processor_unregister_performance(data->acpi_data, data->cpu);
+	if (data->acpi_data.state_count)
+		acpi_processor_unregister_performance(&data->acpi_data, data->cpu);
 }
 
 #else
 static int powernow_k8_cpu_init_acpi(struct powernow_k8_data *data) { return -ENODEV; }
 static void powernow_k8_cpu_exit_acpi(struct powernow_k8_data *data) { return; }
 static void powernow_k8_acpi_pst_values(struct powernow_k8_data *data, unsigned int index) { return; }
-static int powernow_k8_cpu_preinit_acpi() { return -ENODEV; }
 #endif /* CONFIG_X86_POWERNOW_K8_ACPI */
 
 /* Take a frequency, and issue the fid/vid transition command */
@@ -1163,7 +1128,7 @@ static int __cpuinit powernowk8_cpu_init
 		 * an UP version, and is deprecated by AMD.
 		 */
 		if (num_online_cpus() != 1) {
-			printk(KERN_ERR PFX "Your BIOS does not provide _PSS objects.  PowerNow! does not work on SMP systems without _PSS objects.  Complain to your BIOS vendor.\n");
+			printk(KERN_ERR PFX "MP systems not supported by PSB BIOS structure\n");
 			kfree(data);
 			return -ENODEV;
 		}
@@ -1202,7 +1167,10 @@ static int __cpuinit powernowk8_cpu_init
 	/* run on any CPU again */
 	set_cpus_allowed(current, oldmask);
 
-	pol->cpus = data->starting_core_affinity;
+	if (cpu_family == CPU_HW_PSTATE)
+		pol->cpus = cpumask_of_cpu(pol->cpu);
+	else
+		pol->cpus = per_cpu(cpu_core_map, pol->cpu);
 	data->available_cores = &(pol->cpus);
 
 	/* Take a crude guess here.
@@ -1321,7 +1289,6 @@ static int __cpuinit powernowk8_init(voi
 	}
 
 	if (supported_cpus == num_online_cpus()) {
-		powernow_k8_cpu_preinit_acpi();
 		printk(KERN_INFO PFX "Found %d %s "
 			"processors (%d cpu cores) (" VERSION ")\n",
 			num_online_nodes(),
diff -puN arch/x86/kernel/cpu/cpufreq/powernow-k8.h~cpufreq-revert-get-core-affinity-from-acpi_processor_preregister_performance arch/x86/kernel/cpu/cpufreq/powernow-k8.h
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.h~cpufreq-revert-get-core-affinity-from-acpi_processor_preregister_performance
+++ a/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
@@ -33,13 +33,12 @@ struct powernow_k8_data {
 #ifdef CONFIG_X86_POWERNOW_K8_ACPI
 	/* the acpi table needs to be kept. it's only available if ACPI was
 	 * used to determine valid frequency/vid/fid states */
-	struct acpi_processor_performance *acpi_data;
+	struct acpi_processor_performance acpi_data;
 #endif
 	/* we need to keep track of associated cores, but let cpufreq
 	 * handle hotplug events - so just point at cpufreq pol->cpus
 	 * structure */
 	cpumask_t *available_cores;
-	cpumask_t starting_core_affinity;
 };
 
 
@@ -209,7 +208,6 @@ static int core_frequency_transition(str
 static void powernow_k8_acpi_pst_values(struct powernow_k8_data *data, unsigned int index);
 
 #ifdef CONFIG_X86_POWERNOW_K8_ACPI
-static int powernow_k8_cpu_preinit_acpi(void);
 static int fill_powernow_table_pstate(struct powernow_k8_data *data, struct cpufreq_frequency_table *powernow_table);
 static int fill_powernow_table_fidvid(struct powernow_k8_data *data, struct cpufreq_frequency_table *powernow_table);
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped-fix.patch
timerfd-v3-new-timerfd-api-make-the-returned-time-to-be-the-remaining-time-till-the-next-expiration-checkpatch-fixes.patch
timerfd-v3-new-timerfd-api-ia64-fix.patch
timerfd-v3-new-timerfd-api-m68k-fix.patch
timerfd-v3-new-timerfd-api-mips-fix.patch
timerfd-v3-new-timerfd-api-arch-fixes.patch
timerfd-v3-new-timerfd-api-powerpc-fix.patch
timerfd-v3-new-timerfd-api-sparc64-fix.patch
git-acpi.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-ignore-acpi-video-devices-that-arent-present-in-hardware-checkpatch-fixes.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
git-alsa.patch
git-alsa-fixup.patch
git-alsa-disable-sound-pci-ice1712-ice1724c.patch
git-agpgart.patch
git-agpgart-intel-agp-dont-zero-an-already-registered-resource-during-resume.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
intel_agp-add-new-chipset-ids-checkpatch-fixes.patch
git-arm.patch
git-audit-master.patch
git-audit-printk-warning-fix.patch
git-cifs.patch
git-cpufreq.patch
revert-agk-dm-dm-loop.patch
git-powerpc.patch
git-powerpc-fixup.patch
include-asm-powerpc-nvramh-needs-listh.patch
include-asm-powerpc-nvramh-needs-listh-fix.patch
revert-gregkh-driver-atm-convert-struct-class_device-to-struct-device.patch
gregkh-driver-kset-convert-to-kobj_sysfs_ops-vs-git-acpi.patch
revert-gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch
pm-acquire-device-locks-on-suspend-rev-3-checkpatch-fixes.patch
pm-acquire-device-locks-on-suspend-rev-3-checkpatch-fixes-2.patch
unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc.patch
drivers-pcmcia-i82092c-fix-up-after-pci_bus_region-changes.patch
git-drm.patch
intel-agp-enable-i915-recognition.patch
drm-convert-from-nopage-to-fault-checkpatch-fixes.patch
git-dvb.patch
drivers-media-dvb-frontends-xc5000c-dont-return-garbage-from-xc5000_init.patch
drivers-media-video-em28xx-em28xx-corec-fix-use-of-potentially-uninitialized-variable.patch
git-dvb-fix-drivers-media-video-bt8xx-bttv-driverc-build.patch
fix-jdelvare-i2c-i2c-constify-client-address-data.patch
hwmon-new-chip-driver-for-ti-ads7828-a-d.patch
hwmon-new-chip-driver-for-ti-ads7828-a-d-checkpatch-fixes.patch
git-hid.patch
revert-git-hrt.patch
git-ieee1394.patch
git-infiniband.patch
git-infiniband-versus-driver-tree.patch
git-infiniband-fix-build-with-config_infiniband_ipoib_cm=n.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
git-kbuild.patch
git-kvm.patch
git-libata-all.patch
git-libata-all-fix-drivers-ata-sata_fslc.patch
fix-ide-mm-ide-use-ide_destroy_dmatable-instead-of-pci_unmap_sg.patch
drivers-ide-ide-acpic-fix-uninitialized-var-warning.patch
drivers-ide-legacy-hdc-fix-uninitialized-var-warning.patch
git-md-accel.patch
memstick-initial-commit-for-sony-memorystick-support-fix-2.patch
git-mmc.patch
git-mtd.patch
drivers-mtd-ubi-wlc-fix-uninitialized-var-warning.patch
drivers-mtd-ubi-scanc-fix-uninitialized-var-warning.patch
drivers-mtd-ubi-cdevc-unused-var.patch
git-net.patch
git-net-fix-conflicts.patch
git-net-vs-git-lblnet.patch
git-net-vs-git-lblnet-2.patch
git-netdev-all.patch
git-netdev-all-fix-conflicts.patch
git-netdev-all-fix-conflicts-fix.patch
git-net-vs-git-netdev-all.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-backlight.patch
git-battery.patch
bluetooth-uninlining.patch
net-sunrpc-schedc-revert-git-net-changes.patch
net-sunrpc-schedc-reapply-git-net-changes.patch
serial-add-addi-data-gmbh-communication-cardsin8250_pcic-and-pci_idsh-checkpatch-fixes.patch
revert-gregkh-pci-pci-use-dev_printk-in-x86-quirk-messages.patch
fix-gregkh-pci-pci-make-pci-extended-config-space-a-driver-opt-in.patch
cleanup-gregkh-pci-pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform-checkpatch-fixes.patch
x86-validate-against-acpi-motherboard-resources.patch
git-sched.patch
git-sched-fixup.patch
git-sched-fix-bug_on.patch
git-sh.patch
git-scsi-misc.patch
git-scsi-misc-vs-gregkh-pci-pci-remove-users-of-pci_enable_device_bars.patch
scsi-fix-isa-pcmcia-compile-problem-checkpatch-fixes.patch
scsi-aic94xx-cleanups-checkpatch-fixes.patch
scsi-aic94xx-cleanups-checkpatch-fixes-checkpatch-fixes.patch
drivers-scsi-dc395xc-fix-uninitialized-var-warning.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
git-unionfs.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
fix-gregkh-usb-usb-ti_usb-termios-cleanups.patch
ehci-hcd-fix-sparse-warning-about-shadowing-status-symbol-checkpatch-fixes.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
9p-util-fix-semaphore-handling.patch
git-watchdog.patch
git-watchdog-fixup.patch
wdt-fix-locking-checkpatch-fixes.patch
git-wireless.patch
drivers-net-wireless-iwlwifi-iwl-3945c-fix-printk-warning.patch
drivers-net-wireless-iwlwifi-iwl-4965c-fix-printk-warning.patch
drivers-net-wireless-rt2x00-rt2x00usbc-fix-uninitialized-var-warning.patch
git-ipwireless_cs.patch
revert-kvm-stuff-to-make-git-x86-apply.patch
git-x86.patch
git-x86-fixup.patch
git-x86-fixup-2.patch
git-x86-vs-pm-acquire-device-locks-on-suspend-rev-3.patch
git-x86-fix-doubly-merged-patch.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
pci-dont-load-acpi_php-when-acpi-is-disabled-fix.patch
git-cryptodev.patch
git-cryptodev-fixup.patch
git-xtensa.patch
usbtouchscreen-fix-buffer-overflow-make-more-egalax-work.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix-2.patch
vmalloc-add-const-to-void-parameters-fix.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
shmem-factor-out-sbi-free_inodes-manipulations-fix.patch
maps4-rework-task_size-macros-mips-fix.patch
maps4-add-proc-kpagecount-interface-fix.patch
maps4-add-proc-kpageflags-interface-fix.patch
maps4-add-proc-kpageflags-interface-fix-2-fix.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix-fix.patch
mm-page-writeback-highmem_is_dirtyable-option-fix.patch
mm-remove-fastcall-from-mm-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
revert-capabilities-clean-up-file-capability-reading.patch
revert-capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message-fix.patch
alpha-atomic_add_return-should-return-int.patch
alpha-fix-warning-by-fixing-flush_tlb_kernel_range.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
dio-array_size-cleanup-update-checkpatch-fixes.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-improve-detection-of-host-cmov-checkpatch-fixes.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
kernel-printkc-concerns-about-the-console-handover.patch
riscom8-fix-smp-brokenness-fix.patch
use-macros-instead-of-task_-flags-checkpatch-fixes.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
remove-warnings-for-longstanding-conditions-fix.patch
genericizing-iova-fix.patch
parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patch
remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
allow-auto-destruction-of-loop-devices-checkpatch-fixes.patch
remove-__attribute_used__-checkpatch-fixes.patch
read_current_time-cleanups.patch
read_current_time-cleanups-build-fix-fix.patch
address-hfs-on-disk-corruption-robustness-review-comments.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open-fix.patch
kallsyms-should-prefer-non-weak-symbols-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
quota-improve-inode-list-scanning-in-add_dquot_ref-fix.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline-checkpatch-fixes.patch
stopmachine-semaphore-to-mutex-fix.patch
parport-add-support-for-the-quatech-sppxp-100-parallel-port-pci-expresscard-fix.patch
debug_smp_processor_id-fixlets.patch
use-ilog2-in-fs-namespacec-fix.patch
export-iov_shorten-for-ext4s-use-fix.patch
system-timer-fix-crash-in-100hz-system-timer-cleanup.patch
speed-up-jiffies-conversion-functions-if-hz==user_hz.patch
add-have_oprofile.patch
drivers-isdn-hardware-eicon-debugc-fix-uninitialized-var-warning.patch
ecryptfs-make-show_options-reflect-actual-mount-options-fix.patch
rtc-ds1302-rtc-support-checkpatch-fixes.patch
fbmon-cleanup-trailing-whitespaces-checkpatch-fixes.patch
neofb-avoid-overwriting-fb_info-fields.patch
vermilionc-use-align-not-__align_mask.patch
declare-pnp-option-parsing-functions-as-__init-checkpatch-fixes.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
ext4-mm-ext4_store_maxbytes_for_bitmaped_files-warning-fix.patch
kill-filp_open-checkpatch-fixes.patch
rename-open_namei-to-open_pathname-fix.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
r-o-bind-mounts-elevate-write-count-opened-files-oops-fix.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly-checkpatch-fixes.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
cgroup-simplify-space-stripping-fix.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-memorystat-file.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup-cleanup.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup-checkpatch-fixes.patch
hotplug-cpu-move-tasks-in-empty-cpusets-to-parent-checkpatch-fixes.patch
cpusets-update_cpumask-revision-fix.patch
cpusets-update_cpumask-revision-checkpatch-fixes.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-unionfs-from-using-iget-and-read_inode-fix-2.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-vs-git-unionfs.patch
one-less-parameter-to-__d_path-checkpatch-fixes.patch
d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes.patch
d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
cleanup-the-code-managed-with-the-user_ns-option-checkpatch-fixes.patch
cleanup-the-code-managed-with-pid_ns-option-checkpatch-fixes.patch
proc-detect-duplicate-names-on-registration-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-2.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-3.patch
proc-fix-openless-usage-due-to-proc_fops-flip-checkpatch-fixes.patch
intel-iommu-fault_reason_index_cleanuppatch-fix.patch
modules-make-module_address_lookup-safe-fix.patch
pid-sys_wait-fixes-v2-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-x86.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-sanitize-the-type-of-struct-useru_ar0.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
rewrite-rd-fixes.patch
fs-remove-fastcall-it-is-always-empty-checkpatch-fixes.patch
kernel-remove-fastcall-in-kernel-checkpatch-fixes.patch
lib-remove-fastcall-from-lib-checkpatch-fixes.patch
remove-fastcall-from-linux-include-checkpatch-fixes.patch
constify-tables-in-kernel-sysctl_checkc-fix.patch
aoe-statically-initialise-devlist_lock.patch
xfs-convert-bex_add-to-bex_add_cpu-new-common-api-fix.patch
ufs-fix-symlink-creation-on-ufs2-fix.patch
libfs-allow-error-return-from-simple-attributes-fix.patch
fs-hfsplus-unicodec-fix-uninitialized-var-warning.patch
fs-afs-securityc-fix-uninitialized-var-warning.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch
cpufreq-revert-get-core-affinity-from-acpi_processor_preregister_performance.patch
