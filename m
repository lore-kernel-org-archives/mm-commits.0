From: akpm@linux-foundation.org
Subject: - git-tip-rejects.patch removed from -mm tree
Date: Thu, 09 Oct 2008 13:30:42 -0700
Message-ID: <200810092030.m99KUgFI030864@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36458 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753728AbYJIUap (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2008 16:30:45 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m99KUh7T011273
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Thu, 9 Oct 2008 13:30:44 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     git-x86-git-rejects
has been removed from the -mm tree.  Its filename was
     git-tip-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: git-x86-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/common.c |    6 ----
 arch/x86/kernel/process_32.c |   43 ---------------------------------
 arch/x86/kernel/process_64.c |    4 ---
 arch/x86/kernel/setup.c      |    3 --
 drivers/pci/intel-iommu.c    |    3 --
 drivers/pci/probe.c          |   23 -----------------
 include/asm-x86/cpufeature.h |    3 --
 include/asm-x86/idle.h       |    4 ---
 lib/swiotlb.c                |    5 ---
 lib/vsprintf.c               |   13 ---------
 10 files changed, 107 deletions(-)

diff -puN arch/x86/kernel/cpu/common.c~git-tip-rejects arch/x86/kernel/cpu/common.c
--- a/arch/x86/kernel/cpu/common.c~git-tip-rejects
+++ a/arch/x86/kernel/cpu/common.c
@@ -552,18 +552,12 @@ void __init early_cpu_init(void)
  * The NOPL instruction is supposed to exist on all CPUs with
  * family >= 6; unfortunately, that's not true in practice because
  * of early VIA chips and (more importantly) broken virtualizers that
-<<<<<<< HEAD:arch/x86/kernel/cpu/common.c
- * are not easy to detect.  In the latter case it doesn't even *fail*
- * reliably, so probing for it doesn't even work.  Disable it completely
- * unless we can find a reliable way to detect all the broken cases.
-=======
  * are not easy to detect.  Hence, probe for it based on first
  * principles.
  *
  * Note: no 64-bit chip is known to lack these, but put the code here
  * for consistency with 32 bits, and to make it utterly trivial to
  * diagnose the problem should it ever surface.
->>>>>>> FETCH_HEAD:arch/x86/kernel/cpu/common.c
  */
 static void __cpuinit detect_nopl(struct cpuinfo_x86 *c)
 {
diff -puN arch/x86/kernel/process_32.c~git-tip-rejects arch/x86/kernel/process_32.c
--- a/arch/x86/kernel/process_32.c~git-tip-rejects
+++ a/arch/x86/kernel/process_32.c
@@ -55,12 +55,8 @@
 #include <asm/tlbflush.h>
 #include <asm/cpu.h>
 #include <asm/kdebug.h>
-<<<<<<< HEAD:arch/x86/kernel/process_32.c
-#include <asm/idle.h>
-=======
 #include <asm/syscalls.h>
 #include <asm/smp.h>
->>>>>>> FETCH_HEAD:arch/x86/kernel/process_32.c
 
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 
@@ -78,46 +74,7 @@ unsigned long thread_saved_pc(struct tas
 	return ((unsigned long *)tsk->thread.sp)[3];
 }
 
-<<<<<<< HEAD:arch/x86/kernel/process_32.c
-#ifdef CONFIG_HOTPLUG_CPU
-#include <asm/nmi.h>
-
-static void cpu_exit_clear(void)
-{
-	int cpu = raw_smp_processor_id();
-
-	idle_task_exit();
-
-	cpu_uninit();
-	irq_ctx_exit(cpu);
-
-	cpu_clear(cpu, cpu_callout_map);
-	cpu_clear(cpu, cpu_callin_map);
-
-	numa_remove_cpu(cpu);
-	c1e_remove_cpu(cpu);
-}
-
-/* We don't actually take CPU down, just spin without interrupts. */
-static inline void play_dead(void)
-{
-	/* This must be done before dead CPU ack */
-	cpu_exit_clear();
-	mb();
-	/* Ack it */
-	__get_cpu_var(cpu_state) = CPU_DEAD;
-
-	/*
-	 * With physical CPU hotplug, we should halt the cpu
-	 */
-	local_irq_disable();
-	/* mask all interrupts, flush any and all caches, and halt */
-	wbinvd_halt();
-}
-#else
-=======
 #ifndef CONFIG_SMP
->>>>>>> FETCH_HEAD:arch/x86/kernel/process_32.c
 static inline void play_dead(void)
 {
 	BUG();
diff -puN arch/x86/kernel/process_64.c~git-tip-rejects arch/x86/kernel/process_64.c
--- a/arch/x86/kernel/process_64.c~git-tip-rejects
+++ a/arch/x86/kernel/process_64.c
@@ -87,7 +87,6 @@ void exit_idle(void)
 	__exit_idle();
 }
 
-<<<<<<< HEAD:arch/x86/kernel/process_64.c
 #ifdef CONFIG_HOTPLUG_CPU
 DECLARE_PER_CPU(int, cpu_state);
 
@@ -107,9 +106,6 @@ static inline void play_dead(void)
 	wbinvd_halt();
 }
 #else
-=======
-#ifndef CONFIG_SMP
->>>>>>> FETCH_HEAD:arch/x86/kernel/process_64.c
 static inline void play_dead(void)
 {
 	BUG();
diff -puN arch/x86/kernel/setup.c~git-tip-rejects arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c~git-tip-rejects
+++ a/arch/x86/kernel/setup.c
@@ -909,12 +909,9 @@ void __init setup_arch(char **cmdline_p)
 #else
 	num_physpages = max_pfn;
 
-<<<<<<< HEAD:arch/x86/kernel/setup.c
-=======
 	check_efer();
  	if (cpu_has_x2apic)
  		check_x2apic();
->>>>>>> FETCH_HEAD:arch/x86/kernel/setup.c
 
 	/* How many end-of-memory variables you have, grandma! */
 	/* need this before calling reserve_initrd */
diff -puN include/asm-x86/cpufeature.h~git-tip-rejects include/asm-x86/cpufeature.h
--- a/include/asm-x86/cpufeature.h~git-tip-rejects
+++ a/include/asm-x86/cpufeature.h
@@ -89,11 +89,8 @@
 #define X86_FEATURE_LFENCE_RDTSC (3*32+18) /* "" Lfence synchronizes RDTSC */
 #define X86_FEATURE_11AP	(3*32+19) /* "" Bad local APIC aka 11AP */
 #define X86_FEATURE_NOPL	(3*32+20) /* The NOPL (0F 1F) instructions */
-<<<<<<< HEAD:include/asm-x86/cpufeature.h
 #define X86_FEATURE_AMDC1E	(3*32+21) /* AMD C1E detected */
-=======
 #define X86_FEATURE_XTOPOLOGY	(3*32+21) /* cpu topology enum extensions */
->>>>>>> FETCH_HEAD:include/asm-x86/cpufeature.h
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* "pni" SSE-3 */
diff -puN include/asm-x86/idle.h~git-tip-rejects include/asm-x86/idle.h
--- a/include/asm-x86/idle.h~git-tip-rejects
+++ a/include/asm-x86/idle.h
@@ -10,10 +10,6 @@ void idle_notifier_register(struct notif
 void enter_idle(void);
 void exit_idle(void);
 
-<<<<<<< HEAD:include/asm-x86/idle.h
 void c1e_remove_cpu(int cpu);
 
-#endif
-=======
 #endif /* ASM_X86__IDLE_H */
->>>>>>> FETCH_HEAD:include/asm-x86/idle.h
diff -puN include/asm-x86/statfs.h~git-tip-rejects include/asm-x86/statfs.h
diff -puN drivers/pci/intel-iommu.c~git-tip-rejects drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c~git-tip-rejects
+++ a/drivers/pci/intel-iommu.c
@@ -2238,7 +2238,6 @@ static void __init iommu_exit_mempool(vo
 
 }
 
-<<<<<<< HEAD:drivers/pci/intel-iommu.c
 static int blacklist_iommu(const struct dmi_system_id *id)
 {
 	printk(KERN_INFO "%s detected; disabling IOMMU\n",
@@ -2271,8 +2270,6 @@ void __init detect_intel_iommu(void)
 	}
 }
 
-=======
->>>>>>> FETCH_HEAD:drivers/pci/intel-iommu.c
 static void __init init_no_remapping_devices(void)
 {
 	struct dmar_drhd_unit *drhd;
diff -puN drivers/pci/probe.c~git-tip-rejects drivers/pci/probe.c
--- a/drivers/pci/probe.c~git-tip-rejects
+++ a/drivers/pci/probe.c
@@ -305,12 +305,8 @@ static int __pci_read_base(struct pci_de
 			res->start = l64;
 			res->end = l64 + sz64;
 			printk(KERN_DEBUG "PCI: %s reg %x 64bit mmio: [%llx, %llx]\n",
-<<<<<<< HEAD:drivers/pci/probe.c
 				pci_name(dev), pos, (unsigned long long)res->start,
 				(unsigned long long)res->end);
-=======
-				 pci_name(dev), pos, res->start, res->end);
->>>>>>> FETCH_HEAD:drivers/pci/probe.c
 		}
 	} else {
 		sz = pci_size(l, sz, mask);
@@ -321,14 +317,8 @@ static int __pci_read_base(struct pci_de
 		res->start = l;
 		res->end = l + sz;
 		printk(KERN_DEBUG "PCI: %s reg %x %s: [%llx, %llx]\n", pci_name(dev),
-<<<<<<< HEAD:drivers/pci/probe.c
 			pos, (res->flags & IORESOURCE_IO) ? "io port":"32bit mmio",
 			(unsigned long long)res->start, (unsigned long long)res->end);
-=======
-			 pos, (res->flags & IORESOURCE_IO) ? "io port":"32bit mmio",
-			 res->start, res->end);
-
->>>>>>> FETCH_HEAD:drivers/pci/probe.c
 	}
 
  out:
@@ -400,12 +390,8 @@ void __devinit pci_read_bridge_bases(str
 		if (!res->end)
 			res->end = limit + 0xfff;
 		printk(KERN_DEBUG "PCI: bridge %s io port: [%llx, %llx]\n",
-<<<<<<< HEAD:drivers/pci/probe.c
 			pci_name(dev), (unsigned long long) res->start,
 			(unsigned long long) res->end);
-=======
-				 pci_name(dev), res->start, res->end);
->>>>>>> FETCH_HEAD:drivers/pci/probe.c
 	}
 
 	res = child->resource[1];
@@ -418,12 +404,8 @@ void __devinit pci_read_bridge_bases(str
 		res->start = base;
 		res->end = limit + 0xfffff;
 		printk(KERN_DEBUG "PCI: bridge %s 32bit mmio: [%llx, %llx]\n",
-<<<<<<< HEAD:drivers/pci/probe.c
 			pci_name(dev), (unsigned long long) res->start,
 			(unsigned long long) res->end);
-=======
-				 pci_name(dev), res->start, res->end);
->>>>>>> FETCH_HEAD:drivers/pci/probe.c
 	}
 
 	res = child->resource[2];
@@ -460,13 +442,8 @@ void __devinit pci_read_bridge_bases(str
 		res->start = base;
 		res->end = limit + 0xfffff;
 		printk(KERN_DEBUG "PCI: bridge %s %sbit mmio pref: [%llx, %llx]\n",
-<<<<<<< HEAD:drivers/pci/probe.c
 			pci_name(dev), (res->flags & PCI_PREF_RANGE_TYPE_64) ? "64" : "32",
 			(unsigned long long) res->start, (unsigned long long) res->end);
-=======
-				 pci_name(dev), (res->flags & PCI_PREF_RANGE_TYPE_64)?"64":"32",
-				 res->start, res->end);
->>>>>>> FETCH_HEAD:drivers/pci/probe.c
 	}
 }
 
diff -puN lib/swiotlb.c~git-tip-rejects lib/swiotlb.c
--- a/lib/swiotlb.c~git-tip-rejects
+++ a/lib/swiotlb.c
@@ -488,14 +488,9 @@ swiotlb_alloc_coherent(struct device *hw
 		 * swiotlb_map_single(), which will grab memory from
 		 * the lowest available address range.
 		 */
-<<<<<<< HEAD:lib/swiotlb.c
 		dma_addr_t handle;
 		handle = swiotlb_map_single(hwdev, NULL, size, DMA_FROM_DEVICE);
 		if (swiotlb_dma_mapping_error(hwdev, handle))
-=======
-		ret = map_single(hwdev, NULL, size, DMA_FROM_DEVICE);
-		if (!ret)
->>>>>>> FETCH_HEAD:lib/swiotlb.c
 			return NULL;
 	}
 
diff -puN lib/vsprintf.c~git-tip-rejects lib/vsprintf.c
--- a/lib/vsprintf.c~git-tip-rejects
+++ a/lib/vsprintf.c
@@ -514,19 +514,6 @@ static char *string(char *buf, char *end
 	return buf;
 }
 
-<<<<<<< HEAD:lib/vsprintf.c
-=======
-void *dereference_function_descriptor(void *ptr)
-{
-#if defined(CONFIG_IA64) || defined(CONFIG_PPC64)
-	void *p;
-	if (!probe_kernel_address(ptr, p))
-		ptr = p;
-#endif
-	return ptr;
-}
-
->>>>>>> FETCH_HEAD:lib/vsprintf.c
 static char *symbol_string(char *buf, char *end, void *ptr, int field_width, int precision, int flags)
 {
 	unsigned long value = (unsigned long) ptr;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-remove-the-might_sleep-from-lock_page.patch
git-tip.patch
git-tip-rejects.patch
git-powerpc.patch
git-4xx.patch
git-galak.patch
git-sparc.patch
git-x86.patch
git-xtensa.patch
git-tip-core.patch
git-ftrace.patch
git-genirq.patch
git-sched.patch
git-timers.patch
git-timers-fix-printk-errors-clean-up.patch
git-pci.patch
git-hid.patch
git-v4l-dvb.patch
git-v4l-dvb-git-rejects.patch
git-nfs.patch
git-acpi-git-rejects.patch
git-nfsd.patch
git-kvm.patch
git-dlm.patch
git-scsi.patch
git-tests-fixup.patch
git-ext4.patch
git-ext4-vs-git-ocfs2.patch
git-async_tx.patch
git-net.patch
git-net-rejects.patch
git-mtd.patch
git-wireless.patch
git-vfs-vs-git-ext4.patch
git-sound.patch
git-sound-vs-git-arm.patch
git-input.patch
git-block.patch
git-block-reject-fix.patch
git-pcmcia-git-rejects.patch
git-battery.patch
git-battery-rejects.patch
git-slab-rejects.patch
git-md-rejects.patch
git-kmemcheck.patch
git-mfd.patch
git-drm.patch
git-sparseirq.patch
git-scsi-post-merge.patch
git-bdev.patch
usb-usb-remove-warn-macro-from-usbh-vs-git-hid-fix.patch
drivers-mfd-ucb1400_corec-needs-gpio.patch
drivers-mfd-ucb1400_corec-further-unbork.patch
arch-x86-kernel-early_printkc-remove-unused-enable_debug_console.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
libata-blackfin-pata-driver-add-proper-pm-operation-into-atapi-driver.patch
misdn-misc-timerdev-fixes-fix.patch
drivers-net-sfc-falconc-fix-min-warnings.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
drivers-scsi-sdh-use-inlined-c-functions-not-macros.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch-fix.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-make-mlock-error-return-posixly-correct-fix.patch
mm-vmallocc-revert-git-tip-change.patch
mm-rewrite-vmap-layer-fix.patch
mm-rewrite-vmap-layer-fix-fix.patch
mm-rewrite-vmap-layer-fix-fix-fix.patch
revert-mm-vmallocc-revert-git-tip-change.patch
h8300-generic_bug-support-checkpatch-fixes.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation-cleanup.patch
container-freezer-add-tif_freeze-flag-to-all-architectures-fix.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process-fix.patch
eeepc-laptop-use-standard-interfaces-fix-fix.patch
separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix.patch
separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix-fix.patch
make-taint-bit-reliable-v3-fix.patch
kernel-sysc-improve-code-generation.patch
compat-generic-compat-get-settimeofday-checkpatch-fixes.patch
hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-therm-min-max-crit-alarms-cleanup.patch
drivers-hwmon-applesmcc-remove-unneeded-casts.patch
allow-recursion-in-binfmt_script-and-binfmt_misc-fix.patch
serial-make-uart_ports-ioport-unsigned-long-fix.patch
autofs4-track-uid-and-gid-of-last-mount-requester-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-2.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-fix-3.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip-fix.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
viafb-viafbmodes-viafbtxt-fix-fix.patch
viafb-accelc-accelh-checkpatch-fixes.patch
viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
fbdev-kconfig-update-fix.patch
fbdev-allow-more-chip-revisions-in-epson-s1d13-video-driver-cleanups.patch
ext2-avoid-printk-floods-in-the-face-of-directory-corruption-checkpatch-fixes.patch
ext3-fix-ext3_dx_readdir-hash-collision-handling-checkpatch-fixes.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
message-queues-increase-range-limits-checkpatch-fixes.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
tpm-addition-of-pnp_remove-checkpatch-fixes.patch
w1-be-able-to-manually-add-and-remove-slaves-fix.patch
w1-new-driver-ds2431-chip-fix.patch
gru-driver-minor-updates-fix.patch
drivers-rtc-rtc-bq4802c-dont-use-bin_2_bcd-and-bcd_2_bin.patch
x86-sysfs-kill-owner-field-from-attribute-fix.patch
x86-sysfs-kill-owner-field-from-attribute-fix-3.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

