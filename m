From: akpm@osdl.org
Subject: - revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch removed from -mm tree
Date: Wed, 10 Jan 2007 14:43:51 -0800
Message-ID: <200701102243.l0AMhpqa010174@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59953 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965171AbXAJWoe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 17:44:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, ak@suse.de, mingo@elte.hu, shaohua.li@intel.com, suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     revert x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525
has been removed from the -mm tree.  Its filename was
     revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: revert x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525
From: Andrew Morton <akpm@osdl.org>

Obsoleted by Ingo's genapic stuff.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Li, Shaohua" <shaohua.li@intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/acpi/earlyquirk.c |   21 ------------
 arch/i386/kernel/quirks.c          |   46 ++++++---------------------
 arch/i386/kernel/smpboot.c         |    7 ----
 arch/x86_64/kernel/early-quirks.c  |   13 -------
 arch/x86_64/kernel/smpboot.c       |    8 ----
 include/asm-i386/genapic.h         |    2 -
 include/asm-i386/irq.h             |    2 -
 include/asm-x86_64/proto.h         |    1 
 8 files changed, 12 insertions(+), 88 deletions(-)

diff -puN arch/i386/kernel/acpi/earlyquirk.c~revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525 arch/i386/kernel/acpi/earlyquirk.c
--- a/arch/i386/kernel/acpi/earlyquirk.c~revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525
+++ a/arch/i386/kernel/acpi/earlyquirk.c
@@ -10,7 +10,6 @@
 #include <asm/pci-direct.h>
 #include <asm/acpi.h>
 #include <asm/apic.h>
-#include <asm/irq.h>
 
 #ifdef CONFIG_ACPI
 
@@ -50,24 +49,6 @@ static int __init check_bridge(int vendo
 	return 0;
 }
 
-static void check_intel(void)
-{
-	u16 vendor, device;
-
-	vendor = read_pci_config_16(0, 0, 0, PCI_VENDOR_ID);
-
-	if (vendor != PCI_VENDOR_ID_INTEL)
-		return;
-
-	device = read_pci_config_16(0, 0, 0, PCI_DEVICE_ID);
-#ifdef CONFIG_SMP
-	if (device == PCI_DEVICE_ID_INTEL_E7320_MCH ||
-	    device == PCI_DEVICE_ID_INTEL_E7520_MCH ||
-	    device == PCI_DEVICE_ID_INTEL_E7525_MCH)
-		quirk_intel_irqbalance();
-#endif
-}
-
 void __init check_acpi_pci(void)
 {
 	int num, slot, func;
@@ -79,8 +60,6 @@ void __init check_acpi_pci(void)
 	if (!early_pci_allowed())
 		return;
 
-	check_intel();
-
 	/* Poor man's PCI discovery */
 	for (num = 0; num < 32; num++) {
 		for (slot = 0; slot < 32; slot++) {
diff -puN arch/i386/kernel/quirks.c~revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525 arch/i386/kernel/quirks.c
--- a/arch/i386/kernel/quirks.c~revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525
+++ a/arch/i386/kernel/quirks.c
@@ -3,23 +3,10 @@
  */
 #include <linux/pci.h>
 #include <linux/irq.h>
-#include <asm/pci-direct.h>
-#include <asm/genapic.h>
-#include <asm/cpu.h>
 
 #if defined(CONFIG_X86_IO_APIC) && defined(CONFIG_SMP) && defined(CONFIG_PCI)
-static void __devinit verify_quirk_intel_irqbalance(struct pci_dev *dev)
-{
-#ifdef CONFIG_X86_64
-	if (genapic !=  &apic_flat)
-		panic("APIC mode must be flat on this system\n");
-#elif defined(CONFIG_X86_GENERICARCH)
-	if (genapic != &apic_default)
-		panic("APIC mode must be default(flat) on this system. Use apic=default\n");
-#endif
-}
 
-void __init quirk_intel_irqbalance(void)
+static void __devinit quirk_intel_irqbalance(struct pci_dev *dev)
 {
 	u8 config, rev;
 	u32 word;
@@ -29,18 +16,18 @@ void __init quirk_intel_irqbalance(void)
 	 * based platforms.
 	 * Disable SW irqbalance/affinity on those platforms.
 	 */
-	rev = read_pci_config_byte(0, 0, 0, PCI_CLASS_REVISION);
+	pci_read_config_byte(dev, PCI_CLASS_REVISION, &rev);
 	if (rev > 0x9)
 		return;
 
 	printk(KERN_INFO "Intel E7520/7320/7525 detected.");
 
-	/* enable access to config space */
-	config = read_pci_config_byte(0, 0, 0, 0xf4);
-	write_pci_config_byte(0, 0, 0, 0xf4, config|0x2);
+	/* enable access to config space*/
+	pci_read_config_byte(dev, 0xf4, &config);
+	pci_write_config_byte(dev, 0xf4, config|0x2);
 
 	/* read xTPR register */
-	word = read_pci_config_16(0, 0, 0x40, 0x4c);
+	raw_pci_ops->read(0, 0, 0x40, 0x4c, 2, &word);
 
 	if (!(word & (1 << 13))) {
 		printk(KERN_INFO "Disabling irq balancing and affinity\n");
@@ -51,24 +38,13 @@ void __init quirk_intel_irqbalance(void)
 #ifdef CONFIG_PROC_FS
 		no_irq_affinity = 1;
 #endif
-#ifdef CONFIG_HOTPLUG_CPU
-		printk(KERN_INFO "Disabling cpu hotplug control\n");
-		enable_cpu_hotplug = 0;
-#endif
-#ifdef CONFIG_X86_64
-		/* force the genapic selection to flat mode so that
-		 * interrupts can be redirected to more than one CPU.
-		 */
-		genapic_force = &apic_flat;
-#endif
 	}
 
-	/* put back the original value for config space */
+	/* put back the original value for config space*/
 	if (!(config & 0x2))
-		write_pci_config_byte(0, 0, 0, 0xf4, config);
+		pci_write_config_byte(dev, 0xf4, config);
 }
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,   PCI_DEVICE_ID_INTEL_E7320_MCH,  verify_quirk_intel_irqbalance);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,   PCI_DEVICE_ID_INTEL_E7525_MCH,  verify_quirk_intel_irqbalance);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,   PCI_DEVICE_ID_INTEL_E7520_MCH,  verify_quirk_intel_irqbalance);
-
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_E7320_MCH,	quirk_intel_irqbalance);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_E7525_MCH,	quirk_intel_irqbalance);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_E7520_MCH,	quirk_intel_irqbalance);
 #endif
diff -puN arch/i386/kernel/smpboot.c~revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525 arch/i386/kernel/smpboot.c
--- a/arch/i386/kernel/smpboot.c~revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525
+++ a/arch/i386/kernel/smpboot.c
@@ -58,7 +58,6 @@
 #include <asm/arch_hooks.h>
 #include <asm/nmi.h>
 #include <asm/pda.h>
-#include <asm/genapic.h>
 
 #include <mach_apic.h>
 #include <mach_wakecpu.h>
@@ -1463,12 +1462,6 @@ int __devinit __cpu_up(unsigned int cpu)
 	cpu_set(cpu, smp_commenced_mask);
 	while (!cpu_isset(cpu, cpu_online_map))
 		cpu_relax();
-
-#ifdef CONFIG_X86_GENERICARCH
-	if (num_online_cpus() > 8 && genapic == &apic_default)
-		panic("Default flat APIC routing can't be used with > 8 cpus\n");
-#endif
-
 	return 0;
 }
 
diff -puN arch/x86_64/kernel/early-quirks.c~revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525 arch/x86_64/kernel/early-quirks.c
--- a/arch/x86_64/kernel/early-quirks.c~revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525
+++ a/arch/x86_64/kernel/early-quirks.c
@@ -71,18 +71,6 @@ static void ati_bugs(void)
 {
 }
 
-static void intel_bugs(void)
-{
-	u16 device = read_pci_config_16(0, 0, 0, PCI_DEVICE_ID);
-
-#ifdef CONFIG_SMP
-	if (device == PCI_DEVICE_ID_INTEL_E7320_MCH ||
-	    device == PCI_DEVICE_ID_INTEL_E7520_MCH ||
-	    device == PCI_DEVICE_ID_INTEL_E7525_MCH)
-		quirk_intel_irqbalance();
-#endif
-}
-
 struct chipset {
 	u16 vendor;
 	void (*f)(void);
@@ -92,7 +80,6 @@ static struct chipset early_qrk[] = {
 	{ PCI_VENDOR_ID_NVIDIA, nvidia_bugs },
 	{ PCI_VENDOR_ID_VIA, via_bugs },
 	{ PCI_VENDOR_ID_ATI, ati_bugs },
-	{ PCI_VENDOR_ID_INTEL, intel_bugs},
 	{}
 };
 
diff -puN arch/x86_64/kernel/smpboot.c~revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525 arch/x86_64/kernel/smpboot.c
--- a/arch/x86_64/kernel/smpboot.c~revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525
+++ a/arch/x86_64/kernel/smpboot.c
@@ -60,7 +60,6 @@
 #include <asm/irq.h>
 #include <asm/hw_irq.h>
 #include <asm/numa.h>
-#include <asm/genapic.h>
 
 /* Number of siblings per CPU package */
 int smp_num_siblings = 1;
@@ -1170,13 +1169,6 @@ int __cpuinit __cpu_up(unsigned int cpu)
 
 	while (!cpu_isset(cpu, cpu_online_map))
 		cpu_relax();
-
-	if (num_online_cpus() > 8 && genapic == &apic_flat) {
-		printk(KERN_WARNING
-		       "flat APIC routing can't be used with > 8 cpus\n");
-		BUG();
-	}
-
 	err = 0;
 
 	return err;
diff -puN include/asm-i386/genapic.h~revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525 include/asm-i386/genapic.h
--- a/include/asm-i386/genapic.h~revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525
+++ a/include/asm-i386/genapic.h
@@ -122,6 +122,6 @@ struct genapic { 
 	APICFUNC(phys_pkg_id) \
 	}
 
-extern struct genapic *genapic, apic_default;
+extern struct genapic *genapic;
 
 #endif
diff -puN include/asm-i386/irq.h~revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525 include/asm-i386/irq.h
--- a/include/asm-i386/irq.h~revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525
+++ a/include/asm-i386/irq.h
@@ -37,8 +37,6 @@ static __inline__ int irq_canonicalize(i
 extern int irqbalance_disable(char *str);
 #endif
 
-extern void quirk_intel_irqbalance(void);
-
 #ifdef CONFIG_HOTPLUG_CPU
 extern void fixup_irqs(cpumask_t map);
 #endif
diff -puN include/asm-x86_64/proto.h~revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525 include/asm-x86_64/proto.h
--- a/include/asm-x86_64/proto.h~revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525
+++ a/include/asm-x86_64/proto.h
@@ -87,7 +87,6 @@ extern void syscall32_cpu_init(void);
 extern void setup_node_bootmem(int nodeid, unsigned long start, unsigned long end);
 
 extern void early_quirks(void);
-extern void quirk_intel_irqbalance(void);
 extern void check_efer(void);
 
 extern int unhandled_signal(struct task_struct *tsk, int sig);
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
nfs-fix-race-in-nfs_release_page-tidy.patch
use-correct-macros-in-raid-code-not-raw-asm-include.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
exit-acpi-processor-module-gracefully-if-acpi-is-disabled-tidy.patch
sony_apci-resume.patch
sony_apci-resume-fix.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-sony_acpi-fix.patch
git-alsa.patch
agpgart-allow-drm-populated-agp-memory-types-tidy.patch
cifs-sprintf-fix.patch
rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix-2.patch
fix-gregkh-driver-driver-core-fix-race-in-sysfs-between-sysfs_remove_file-and-read-write.patch
git-dvb.patch
git-gfs2-nmw.patch
ia64-enable-config_debug_spinlock_sleep.patch
git-ieee1394.patch
git-input.patch
git-libata-all.patch
git-lxdialog-fixup.patch
git-mmc.patch
git-mtd.patch
git-ubi.patch
ubi-missing-include.patch
git-netdev-all.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
net-use-bitrev8.patch
bonding-replace-kmalloc-memset-pairs-with-the-appropriate-kzalloc-calls-fix.patch
net-uninline-skb_put.patch
ioat-warning-fix.patch
r8169-warning-fixes.patch
git-scsi-rc-fixes.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-block-fixup.patch
git-block-atomicity-fix.patch
nokia-e70-is-an-unusual-device.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation-fix.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation-fix-fix.patch
touchkit-ps-2-touchscreen-driver.patch
lumpy-reclaim-v2-page_to_pfn-fix.patch
lumpy-reclaim-v2-tidy.patch
avoid-excessive-sorting-of-early_node_map-tidy.patch
proc-zoneinfo-fix-vm-stats-display.patch
swsusp-change-code-ordering-in-userc-sanity.patch
deprecate-smbfs-in-favour-of-cifs.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
drivers-add-lcd-support-workqueue-fixups.patch
ecryptfs-public-key-packet-management-slab-fix.patch
add-retain_initrd-boot-option-tweak.patch
count_vm_events-warning-fix.patch
toshiba-tc86c001-ide-driver-take-2-fix-2.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
consolidate-line-discipline-number-definitions-v2-sparc-fix.patch
consolidate-line-discipline-number-definitions-v2-fix-2.patch
spi-controller-driver-for-omap-microwire-tidy.patch
spi-controller-driver-for-omap-microwire-update-fix.patch
remove-invalidate_inode_pages.patch
add-an-rcu-version-of-list-splicing-fix.patch
factor-outstanding-i-o-error-handling-tidy.patch
sync_sb_inodes-propagate-errors.patch
block_write_full_page-handle-enospc.patch
sysctl-warning-fix.patch
proc_misc-warning-fix.patch
vmi-versus-hrtimers.patch
gtod-persistent-clock-support-i386.patch
hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
hrtimers-clean-up-locking.patch
hrtimers-add-state-tracking.patch
clockevents-i386-drivers.patch
debugging-feature-proc-timer_list-warning-fix.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
schedule_on_each_cpu-use-preempt_disable.patch
implement-flush_work-sanity.patch
implement-flush_work_keventd.patch
flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
omap-gpio-wrappers-tidy.patch
at91-gpio-wrappers-tidy.patch
aio-is-unlikely.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
user-ns-implement-user-ns-unshare-tidy.patch
readahead-kconfig-options-fix.patch
readahead-minmax_ra_pages.patch
readahead-sysctl-parameters.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
readahead-context-based-method-locking-fix.patch
readahead-context-based-method-locking-fix-2.patch
readahead-call-scheme-ifdef-fix.patch
readahead-call-scheme-build-fix.patch
readahead-nfsd-case-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
resier4-add-include-linux-freezerh-and-move-definitions-from.patch
make-kmem_cache_destroy-return-void-reiser4.patch
reiser4-hardirq-include-fix.patch
reiser4-run-truncate_inode_pages-in-reiser4_delete_inode.patch
reiser4-get_sb_dev-fix.patch
reiser4-vs-zoned-allocator.patch
reiser4-temp-fix.patch
reiser4-kmem_cache_t-removal.patch
reiser4-test_clear_page_dirty.patch
reiser4-vs-git-block.patch
reiser4-vs-git-block-2.patch
hpt3xx-rework-rate-filtering-tidy.patch
jmicron-warning-fix.patch
cyber2010-framebuffer-on-arm-netwinder-fix-tidy.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
slim-main-include-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch
