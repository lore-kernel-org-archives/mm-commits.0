From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Wed, 10 Jun 2009 10:40:32 -0700
Message-ID: <200906101740.n5AHeWu7027926@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56272 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753098AbZFJRkc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jun 2009 13:40:32 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n5AHeWfT017503
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 10 Jun 2009 10:40:33 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/cpufreq/powernow-k7.c        |    5 -----
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c        |    4 ----
 arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c |    7 -------
 arch/x86/kernel/tlb_uv.c                         |    6 ------
 drivers/acpi/processor_core.c                    |    4 ----
 drivers/cpufreq/cpufreq.c                        |    4 ----
 kernel/sched_cpupri.c                            |    4 ----
 kernel/sched_rt.c                                |    5 -----
 kernel/smp.c                                     |    5 -----
 9 files changed, 44 deletions(-)

diff -puN arch/x86/kernel/cpu/cpufreq/powernow-k7.c~linux-next-git-rejects arch/x86/kernel/cpu/cpufreq/powernow-k7.c
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k7.c~linux-next-git-rejects
+++ a/arch/x86/kernel/cpu/cpufreq/powernow-k7.c
@@ -322,13 +322,8 @@ static int powernow_acpi_init(void)
 		goto err0;
 	}
 
-<<<<<<< HEAD:arch/x86/kernel/cpu/cpufreq/powernow-k7.c
-	if (!zalloc_cpumask_var(&acpi_processor_perf->shared_cpu_map,
-								GFP_KERNEL)) {
-=======
 	if (!alloc_cpumask_var(&acpi_processor_perf->shared_cpu_map,
 			       GFP_KERNEL | __GFP_ZERO)) {
->>>>>>> FETCH_HEAD:arch/x86/kernel/cpu/cpufreq/powernow-k7.c
 		retval = -ENOMEM;
 		goto err05;
 	}
diff -puN arch/x86/kernel/cpu/cpufreq/powernow-k8.c~linux-next-git-rejects arch/x86/kernel/cpu/cpufreq/powernow-k8.c
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c~linux-next-git-rejects
+++ a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -879,12 +879,8 @@ static int powernow_k8_cpu_init_acpi(str
 	/* notify BIOS that we exist */
 	acpi_processor_notify_smm(THIS_MODULE);
 
-<<<<<<< HEAD:arch/x86/kernel/cpu/cpufreq/powernow-k8.c
-	if (!zalloc_cpumask_var(&data->acpi_data.shared_cpu_map, GFP_KERNEL)) {
-=======
 	if (!alloc_cpumask_var(&data->acpi_data.shared_cpu_map,
 			       GFP_KERNEL | __GFP_ZERO)) {
->>>>>>> FETCH_HEAD:arch/x86/kernel/cpu/cpufreq/powernow-k8.c
 		printk(KERN_ERR PFX
 				"unable to alloc powernow_k8_data cpumask\n");
 		ret_val = -ENOMEM;
diff -puN arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c~linux-next-git-rejects arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c~linux-next-git-rejects
+++ a/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
@@ -461,14 +461,7 @@ static int centrino_target (struct cpufr
 	unsigned int		j, k, first_cpu, tmp;
 	cpumask_var_t covered_cpus;
 
-<<<<<<< HEAD:arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
-	if (unlikely(!alloc_cpumask_var(&saved_mask, GFP_KERNEL)))
-		return -ENOMEM;
-	if (unlikely(!zalloc_cpumask_var(&covered_cpus, GFP_KERNEL))) {
-		free_cpumask_var(saved_mask);
-=======
 	if (unlikely(!alloc_cpumask_var(&covered_cpus, GFP_KERNEL)))
->>>>>>> FETCH_HEAD:arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
 		return -ENOMEM;
 
 	if (unlikely(per_cpu(centrino_model, cpu) == NULL)) {
diff -puN arch/x86/kernel/tlb_uv.c~linux-next-git-rejects arch/x86/kernel/tlb_uv.c
--- a/arch/x86/kernel/tlb_uv.c~linux-next-git-rejects
+++ a/arch/x86/kernel/tlb_uv.c
@@ -843,15 +843,9 @@ static int __init uv_bau_init(void)
 		return 0;
 
 	for_each_possible_cpu(cur_cpu)
-<<<<<<< HEAD:arch/x86/kernel/tlb_uv.c
-		zalloc_cpumask_var_node(&per_cpu(uv_flush_tlb_mask, cur_cpu),
-				       GFP_KERNEL, cpu_to_node(cur_cpu));
-=======
 		alloc_cpumask_var_node(&per_cpu(uv_flush_tlb_mask, cur_cpu),
 				       GFP_KERNEL | __GFP_ZERO,
 				       cpu_to_node(cur_cpu));
->>>>>>> FETCH_HEAD:arch/x86/kernel/tlb_uv.c
-
 	uv_bau_retry_limit = 1;
 	uv_nshift = uv_hub_info->n_val;
 	uv_mmask = (1UL << uv_hub_info->n_val) - 1;
diff -puN drivers/acpi/processor_core.c~linux-next-git-rejects drivers/acpi/processor_core.c
--- a/drivers/acpi/processor_core.c~linux-next-git-rejects
+++ a/drivers/acpi/processor_core.c
@@ -844,12 +844,8 @@ static int acpi_processor_add(struct acp
 	if (!pr)
 		return -ENOMEM;
 
-<<<<<<< HEAD:drivers/acpi/processor_core.c
-	if (!zalloc_cpumask_var(&pr->throttling.shared_cpu_map, GFP_KERNEL)) {
-=======
 	if (!alloc_cpumask_var(&pr->throttling.shared_cpu_map,
 			       GFP_KERNEL | __GFP_ZERO)) {
->>>>>>> FETCH_HEAD:drivers/acpi/processor_core.c
 		kfree(pr);
 		return -ENOMEM;
 	}
diff -puN drivers/cpufreq/cpufreq.c~linux-next-git-rejects drivers/cpufreq/cpufreq.c
--- a/drivers/cpufreq/cpufreq.c~linux-next-git-rejects
+++ a/drivers/cpufreq/cpufreq.c
@@ -808,12 +808,8 @@ static int cpufreq_add_dev(struct sys_de
 		ret = -ENOMEM;
 		goto nomem_out;
 	}
-<<<<<<< HEAD:drivers/cpufreq/cpufreq.c
-	if (!zalloc_cpumask_var(&policy->related_cpus, GFP_KERNEL)) {
-=======
 	if (!alloc_cpumask_var(&policy->related_cpus,
 			       GFP_KERNEL | __GFP_ZERO)) {
->>>>>>> FETCH_HEAD:drivers/cpufreq/cpufreq.c
 		free_cpumask_var(policy->cpus);
 		kfree(policy);
 		ret = -ENOMEM;
diff -puN kernel/sched_cpupri.c~linux-next-git-rejects kernel/sched_cpupri.c
--- a/kernel/sched_cpupri.c~linux-next-git-rejects
+++ a/kernel/sched_cpupri.c
@@ -165,11 +165,7 @@ int __init_refok cpupri_init(struct cpup
 		vec->count = 0;
 		if (bootmem)
 			alloc_bootmem_cpumask_var(&vec->mask);
-<<<<<<< HEAD:kernel/sched_cpupri.c
-		else if (!zalloc_cpumask_var(&vec->mask, GFP_KERNEL))
-=======
 		else if (!alloc_cpumask_var(&vec->mask, GFP_KERNEL | __GFP_ZERO))
->>>>>>> FETCH_HEAD:kernel/sched_cpupri.c
 			goto cleanup;
 	}
 
diff -puN kernel/sched_rt.c~linux-next-git-rejects kernel/sched_rt.c
--- a/kernel/sched_rt.c~linux-next-git-rejects
+++ a/kernel/sched_rt.c
@@ -1591,14 +1591,9 @@ static inline void init_sched_rt_class(v
 	unsigned int i;
 
 	for_each_possible_cpu(i)
-<<<<<<< HEAD:kernel/sched_rt.c
-		zalloc_cpumask_var_node(&per_cpu(local_cpu_mask, i),
-					GFP_KERNEL, cpu_to_node(i));
-=======
 		alloc_cpumask_var_node(&per_cpu(local_cpu_mask, i),
 					GFP_KERNEL | __GFP_ZERO,
 					cpu_to_node(i));
->>>>>>> FETCH_HEAD:kernel/sched_rt.c
 }
 #endif /* CONFIG_SMP */
 
diff -puN kernel/smp.c~linux-next-git-rejects kernel/smp.c
--- a/kernel/smp.c~linux-next-git-rejects
+++ a/kernel/smp.c
@@ -52,14 +52,9 @@ hotplug_cfd(struct notifier_block *nfb, 
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-<<<<<<< HEAD:kernel/smp.c
-		if (!zalloc_cpumask_var_node(&cfd->cpumask, GFP_KERNEL,
-				cpu_to_node(cpu)))
-=======
 		if (!alloc_cpumask_var_node(&cfd->cpumask,
 					    GFP_KERNEL | __GFP_ZERO,
 					    cpu_to_node(cpu)))
->>>>>>> FETCH_HEAD:kernel/smp.c
 			return NOTIFY_BAD;
 		break;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
ds_selftest-is-borked.patch
eeepc-laptop-enable-camera-by-default-fix.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
cpufreq-powernow-k8-cleanup-msg-if-bios-does-not-export-acpi-_pss-cpufreq-data-cleanup.patch
devres-warn-and-return-dont-crash-on-device_del-of-uninitialized-device-cleanup.patch
dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
e100-add-non-mii-phy-support-fix.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
firmware_map-fix-hang-with-x86-32bit-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
drivers-rtc-rtc-cmosc-cmos_init-dont-ignore-pnp_register_driver-return-value.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
pagemap-add-page-types-tool-fix.patch
videobuf-dma-contig-zero-copy-userptr-support-v3-comments-checkpatch-fixes.patch
page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen.patch
page-allocator-clean-up-functions-related-to-pages_min-checkpatch-fixes.patch
page-allocator-add-inactive-ratio-calculation-function-of-each-zone-checkpatch-fixes.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
mm-add-a-gfp-translate-script-to-help-understand-page-allocation-failure-reports-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
arch-m68k-include-asm-motorola_pgalloch-fix-kunmap-arg.patch
headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh.patch
remove-put_cpu_no_resched-fix.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
proc-merge-arrayc-into-basec-checkpatch-fixes.patch
jsm-clean-up-serial-jsm-correctly-support-4-8-port-boards.patch
radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb-fix.patch
fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers-checkpatch-fixes.patch
documentation-changes-perl-is-needed-to-build-the-kernel-fix.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes.patch
char-moxa-prevent-opening-unavailable-ports.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
edac-kconfig-fix-the-meaning-of-edac-abbreviation-fix.patch
kexec-sysrq-simplify-sysrq-c-handler.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
lib-add-lib-gcdc-fix.patch
lib-add-lib-gcdc-fix-fix.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

