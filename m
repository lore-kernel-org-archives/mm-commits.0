From: akpm@linux-foundation.org
Subject: + x86_64-mm-vdso-text-offset.patch added to -mm tree
Date: Tue, 25 Sep 2007 12:53:39 -0700
Message-ID: <200709251953.l8PJrdBL001712@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54320 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754125AbXIYTxr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Sep 2007 15:53:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@suse.de, pbadari@us.ibm.com


The patch titled
     x86_64: increase VDSO_TEXT_OFFSET for ancient binutils
has been added to the -mm tree.  Its filename is
     x86_64-mm-vdso-text-offset.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: increase VDSO_TEXT_OFFSET for ancient binutils
From: Andi Kleen <ak@suse.de>

For some reason old binutils genertate larger headers so increase the text
offset of the vdso to avoid linker errors.

(akpm; stolen from Andi's patch queue due to Badari's report of link failure)

Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/vdso/voffset.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86_64/vdso/voffset.h~x86_64-mm-vdso-text-offset arch/x86_64/vdso/voffset.h
--- a/arch/x86_64/vdso/voffset.h~x86_64-mm-vdso-text-offset
+++ a/arch/x86_64/vdso/voffset.h
@@ -1 +1 @@
-#define VDSO_TEXT_OFFSET 0x500
+#define VDSO_TEXT_OFFSET 0x600
_

Patches currently in -mm which might be from ak@suse.de are

x86_64-mm-vdso-text-offset.patch
acpi-add-reboot-mechanism.patch
cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core.patch
cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default.patch
net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
serial-keep-the-dtr-setting-for-serial-console.patch
i386-compaq-evo-n800c-needs-pci-bus-renumbering.patch
i386-compaq-evo-n800c-needs-pci-bus-renumbering-fix.patch
x86_64-mce-poll-at-idle_start-and-printk-fix.patch
fix-x86_64-mm-unwinder.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
x86_64-add-acpi-reboot-option.patch
i386-convert-mm_context_t-semaphore-to-a-mutex.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
x86-make-io-apic-not-connected-pin-print-complete.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init.patch
i386-stop-bogus-nmi-softlockup-warnings-in-show_mem.patch
voyager-include-asm-smph-to-fix-compile-error.patch
clockevents-remove-unused-inline-function.patch
clockevents-allow-build-without-runtime-use.patch
x86_64-consolidate-tsc-calibration.patch
i386-prepare-sharing-hpet-code.patch
i386-hpet-add-x8664-hpet-bits.patch
i386-prepare-sharing-pit-code.patch
x86_64-use-i386-i8253-h.patch
x86_64-preparatory-apic-set-lvtt.patch
x86_64-apic-remove-bogus-pit-synchronization.patch
x86_64-apic-shuffle-calibration-around.patch
x86_64-apic-calibration-remove-divisor.patch
x86_64-apic-change-setup-calling-convention.patch
x86_64-apic-remove-nested-irq-disable.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-apic-add-clockevents-functions.patch
x86_64-convert-to-clockevents.patch
x86_64-remove-unused-code.patch
x86_64-cleanup-apic-c.patch
jiffies-remove-unused-macros.patch
acpi-remove-the-useless-ifdef-code.patch
i386-pit-remove-the-useless-ifdefs.patch
i386-hpet-sharing-optimize.patch
ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer.patch
ich-force-hpet-restructure-hpet-generic-clock-code.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-late-initialization-of-hpet-after-quirk.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch
ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch
hpet-force-enable-on-ich34.patch
x86-fix-cpu_to_node-references.patch
x86-convert-cpu_core_map-to-be-a-per-cpu-variable.patch
convert-cpu_sibling_map-to-be-a-per-cpu-variable.patch
x86-convert-x86_cpu_to_apicid-to-be-a-per-cpu-variable.patch
x86-convert-cpu_llc_id-to-be-a-per-cpu-variable.patch
x86-acpi-use-cpu_physical_id.patch
i386-cleanup-struct-irqaction-initializers.patch
x86_64-cleanup-struct-irqaction-initializers.patch
optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft.patch
optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft-fix.patch
hpet-force-enable-on-vt8235-37-chipsets.patch
voyager-dont-try-to-support-unprocessor-builds.patch
x86_64-nx-bit-handling-in-change_page_attr.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch
x86_64-sparsemem_vmemmap-vmemmap-x86_64-convert-to-new-helper-based-initialisation.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
mem-policy-add-mpol_f_mems_allowed-get_mempolicy-flag.patch
s2ram-kill-old-debugging-junk.patch
hibernation-arbitrary-boot-kernel-support-generic-code-rev-2.patch
hibernation-arbitrary-boot-kernel-support-on-x86_64-rev-2.patch
hibernation-pass-cr3-in-the-image-header-on-x86_64-rev-2.patch
hibernation-use-temporary-page-tables-for-kernel-text-mapping-on-x86_64.patch
remove-workaround-for-unimmunized-rcu_dereference-from-mce_log.patch
kconfig-make-instrumentation-support-non-experimental.patch
do_sys_poll-simplify-playing-with-on-stack-data.patch
do_poll-return-eintr-when-signalled.patch
i386-mark-pit_clockevent-static.patch
report-the-per-irq-statistics-on-allarches.patch
deprecate-aout-elf-interpreters.patch
deprecate-aout-elf-interpreters-fix.patch
add-linux-elfcore-compath.patch
x86_64-use-linux-elfcore-compath.patch
powerpc-use-linux-elfcore-compath.patch
x86_64-efi-boot-support-efi-frame-buffer-driver.patch
x86_64-efi-boot-support-efi-boot-document.patch
pie-executable-randomization-fix.patch
pie-executable-randomization-fix-3.patch
i386-and-x86_64-randomize-brk.patch
i386-and-x86_64-randomize-brk-fix.patch
fix-discrepancy-between-vdso-based-gettimeofday-and-sys_gettimeofday.patch
cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
intel-iommu-optimize-sg-map-unmap-calls.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
sysctl-x86_64-remove-unnecessary-binary-paths.patch
x86-msr-driver-misc-cpuinit-annotations.patch
i386-cpuid-misc-cpuinit-annotations.patch
extended-crashkernel-command-line.patch
use-extended-crashkernel-command-line-on-i386.patch
use-extended-crashkernel-command-line-on-x86_64.patch
add-documentation-for-extended-crashkernel-syntax.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
