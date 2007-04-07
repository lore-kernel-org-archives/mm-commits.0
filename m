From: akpm@linux-foundation.org
Subject: + revert-proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621.patch added to -mm tree
Date: Fri, 06 Apr 2007 22:50:05 -0700
Message-ID: <200704070550.l375o5j4028588@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45551 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192AbXDGFuN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 7 Apr 2007 01:50:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ak@muc.de, jeremy@goop.org, zach@vmware.com


The patch titled
     revert proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621
has been added to the -mm tree.  Its filename is
     revert-proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: revert proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Zachary Amsden <zach@vmware.com>
Cc: Andi Kleen <ak@muc.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/vmi.c        |   23 +----------------------
 arch/i386/mm/highmem.c        |    2 --
 include/asm-generic/pgtable.h |    2 --
 include/asm-i386/paravirt.h   |    3 ---
 4 files changed, 1 insertion(+), 29 deletions(-)

diff -puN arch/i386/kernel/vmi.c~revert-proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621 arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c~revert-proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621
+++ a/arch/i386/kernel/vmi.c
@@ -69,7 +69,6 @@ struct {
 	void (*flush_tlb)(int);
 	void (*set_initial_ap_state)(int, int);
 	void (*halt)(void);
-  	void (*set_lazy_mode)(int mode);
 } vmi_ops;
 
 /* XXX move this to alternative.h */
@@ -575,26 +574,6 @@ vmi_startup_ipi_hook(int phys_apicid, un
 }
 #endif
 
-static void vmi_set_lazy_mode(int mode)
-{
-	static DEFINE_PER_CPU(int, lazy_mode);
-
-	if (!vmi_ops.set_lazy_mode)
-		return;
-
-	/* Modes should never nest or overlap */
-	BUG_ON(__get_cpu_var(lazy_mode) && !(mode == PARAVIRT_LAZY_NONE ||
-					     mode == PARAVIRT_LAZY_FLUSH));
-
-	if (mode == PARAVIRT_LAZY_FLUSH) {
-		vmi_ops.set_lazy_mode(0);
-		vmi_ops.set_lazy_mode(__get_cpu_var(lazy_mode));
-	} else {
-		vmi_ops.set_lazy_mode(mode);
-		__get_cpu_var(lazy_mode) = mode;
-	}
-}
-
 static inline int __init check_vmi_rom(struct vrom_header *rom)
 {
 	struct pci_header *pci;
@@ -825,7 +804,7 @@ static inline int __init activate_vmi(vo
 	para_wrap(load_esp0, vmi_load_esp0, set_kernel_stack, UpdateKernelStack);
 	para_fill(set_iopl_mask, SetIOPLMask);
 	para_fill(io_delay, IODelay);
-	para_wrap(set_lazy_mode, vmi_set_lazy_mode, set_lazy_mode, SetLazyMode);
+	para_fill(set_lazy_mode, SetLazyMode);
 
 	/* user and kernel flush are just handled with different flags to FlushTLB */
 	para_wrap(flush_tlb_user, vmi_flush_tlb_user, flush_tlb, FlushTLB);
diff -puN arch/i386/mm/highmem.c~revert-proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621 arch/i386/mm/highmem.c
--- a/arch/i386/mm/highmem.c~revert-proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621
+++ a/arch/i386/mm/highmem.c
@@ -42,7 +42,6 @@ void *kmap_atomic(struct page *page, enu
 
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	set_pte(kmap_pte-idx, mk_pte(page, kmap_prot));
-	arch_flush_lazy_mmu_mode();
 
 	return (void*) vaddr;
 }
@@ -83,7 +82,6 @@ void *kmap_atomic_pfn(unsigned long pfn,
 	idx = type + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	set_pte(kmap_pte-idx, pfn_pte(pfn, kmap_prot));
-	arch_flush_lazy_mmu_mode();
 
 	return (void*) vaddr;
 }
diff -puN include/asm-generic/pgtable.h~revert-proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621 include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~revert-proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621
+++ a/include/asm-generic/pgtable.h
@@ -180,7 +180,6 @@ static inline void ptep_set_wrprotect(st
 #ifndef __HAVE_ARCH_ENTER_LAZY_MMU_MODE
 #define arch_enter_lazy_mmu_mode()	do {} while (0)
 #define arch_leave_lazy_mmu_mode()	do {} while (0)
-#define arch_flush_lazy_mmu_mode()	do {} while (0)
 #endif
 
 /*
@@ -194,7 +193,6 @@ static inline void ptep_set_wrprotect(st
 #ifndef __HAVE_ARCH_ENTER_LAZY_CPU_MODE
 #define arch_enter_lazy_cpu_mode()	do {} while (0)
 #define arch_leave_lazy_cpu_mode()	do {} while (0)
-#define arch_flush_lazy_cpu_mode()	do {} while (0)
 #endif
 
 /*
diff -puN include/asm-i386/paravirt.h~revert-proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621 include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h~revert-proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621
+++ a/include/asm-i386/paravirt.h
@@ -421,17 +421,14 @@ static inline void pmd_clear(pmd_t *pmdp
 #define PARAVIRT_LAZY_NONE 0
 #define PARAVIRT_LAZY_MMU  1
 #define PARAVIRT_LAZY_CPU  2
-#define PARAVIRT_LAZY_FLUSH 3
 
 #define  __HAVE_ARCH_ENTER_LAZY_CPU_MODE
 #define arch_enter_lazy_cpu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_CPU)
 #define arch_leave_lazy_cpu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_NONE)
-#define arch_flush_lazy_cpu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_FLUSH)
 
 #define  __HAVE_ARCH_ENTER_LAZY_MMU_MODE
 #define arch_enter_lazy_mmu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_MMU)
 #define arch_leave_lazy_mmu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_NONE)
-#define arch_flush_lazy_mmu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_FLUSH)
 
 /* These all sit in the .parainstructions section to tell us what to patch. */
 struct paravirt_patch {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

slab-introduce-krealloc-fix.patch
git-acpi.patch
git-alsa.patch
git-alsa-fixup.patch
git-agpgart.patch
git-avr32.patch
git-avr32-fixup.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-hid-vs-git-input.patch
git-kvm.patch
git-libata-all.patch
libata-acpi-add-infrastructure-for-drivers-to-use-fix.patch
pata_acpi-restore-driver-fix.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
git-mtd.patch
git-ubi.patch
git-netdev-all.patch
vioc-warning-fix.patch
vioc-cast-warning-fix.patch
git-e1000.patch
git-e1000-fixup-2.patch
git-net.patch
git-net-fixup.patch
git-net-vs-git-netdev-all.patch
git-ocfs2.patch
git-parisc.patch
git-r8169-fixup.patch
rm9000-serial-driver.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
git-s390.patch
git-scsi-misc.patch
scsi-fix-config_scsi_wait_scan=m-fix.patch
scsi-fix-config_scsi_wait_scan=m-fix-fix.patch
git-unionfs.patch
git-wireless.patch
git-wireless-fixup.patch
git-wireless-vs-git-net.patch
git-wireless-vs-git-net-2.patch
revert-proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621.patch
fix-x86_64-mm-sched-clock-share.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
x86_64-inhibit-machine-from-asserting-an-nmi-when-doing-alt-sysrq-m-operation-tidy.patch
xfs-clean-up-shrinker-games.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
mm-merge-nopfn-into-fault-fix.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy.patch
mm-move-common-segment-checks-to-separate-helper-function-v7-tidy.patch
slab-mark-set_up_list3s-__init.patch
driver_bfin_serial_core-update.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-fix-fix.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection-fix.patch
proc-maps-protection-tidy.patch
proc-maps-protection-fix-2.patch
fix-cycladesh-for-x86_64-and-probably-others-fix.patch
rtc-add-rtc-rs5c313-driver-tidy.patch
rtc-add-rtc-rs5c313-driver-is-busted.patch
move-die-notifier-handling-to-common-code-fixes-2.patch
move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all.patch
fix-sscanf-%n-match-at-end-of-input-string-tidy.patch
parport-dev-driver-model-support-powerpc-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch-fix-tidy.patch
add-support-for-deferrable-timers-respun-tidy.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
time-smp-friendly-alignment-of-struct-clocksource.patch
move-timekeeping-code-to-timekeepingc-fix.patch
fix-kevents-childs-priority-greediness-fix.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount-fix.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix.patch
sys_futex64-allows-64bit-futexes-workaround.patch
kprobes-the-on-off-knob-thru-debugfs-updated-fix.patch
proc-maps-protection-vs-utrace.patch
utrace-prep-2.patch
undo-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-printk-borkage.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
linux-kernel-markers-i386-optimization-fix.patch
signal-timer-event-fds-v9-signalfd-core-fix.patch
signal-timer-event-fds-v9-signalfd-core-fix-fix.patch
signal-timer-event-fds-v9-timerfd-core-fix.patch
signal-timer-event-fds-v9-eventfd-core-fix.patch
signal-timer-event-fds-v9-eventfd-core-fix-fix.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-wire-up-i386-system-calls-x86_64-fix.patch
fbdev-hecuba-framebuffer-driver.patch
vt-add-color-support-to-the-underline-and-italic-attributes-fix.patch
integrity-new-hooks-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
