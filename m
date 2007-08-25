From: akpm@linux-foundation.org
Subject: - x86_64-mm-xen-attempt-to-patch-inline-versions-of-common-operations.patch removed from -mm tree
Date: Fri, 24 Aug 2007 22:24:44 -0700
Message-ID: <200708250524.l7P5Oi7l032226@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45780 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751469AbXHYFZU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 25 Aug 2007 01:25:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     arch/x86_64/vdso/vma.c needs sched.h
has been removed from the -mm tree.  Its filename was
     x86_64-mm-xen-attempt-to-patch-inline-versions-of-common-operations.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: arch/x86_64/vdso/vma.c needs sched.h
From: Jeremy Fitzhardinge <jeremy@goop.org>
i386: Attempt to patch inline versions of common operations

This patchs adds the mechanism to allow us to patch inline versions of
common operations.

The implementations of the direct-access versions save_fl, restore_fl,
irq_enable and irq_disable are now in assembler, and the same code is
used for both out of line and inline uses.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Keir Fraser <keir@xensource.com>
---
 arch/i386/kernel/asm-offsets.c |    7 ++
 arch/i386/xen/Makefile         |    2 
 arch/i386/xen/enlighten.c      |  108 +++++++++++++++++++-------------------
 arch/i386/xen/xen-asm.S        |  114 +++++++++++++++++++++++++++++++++++++++++
 arch/i386/xen/xen-ops.h        |   13 ++++
 5 files changed, 190 insertions(+), 54 deletions(-)

===================================================================
Index: linux/arch/i386/kernel/asm-offsets.c
===================================================================
--- linux.orig/arch/i386/kernel/asm-offsets.c
+++ linux/arch/i386/kernel/asm-offsets.c
@@ -16,6 +16,7 @@
 #include <asm/processor.h>
 #include <asm/thread_info.h>
 #include <asm/elf.h>
+#include <xen/interface/xen.h>
 
 #define DEFINE(sym, val) \
         asm volatile("\n->" #sym " %0 " #val : : "i" (val))
@@ -115,4 +116,10 @@ void foo(void)
 	OFFSET(PARAVIRT_iret, paravirt_ops, iret);
 	OFFSET(PARAVIRT_read_cr0, paravirt_ops, read_cr0);
 #endif
+
+#ifdef CONFIG_XEN
+	BLANK();
+	OFFSET(XEN_vcpu_info_mask, vcpu_info, evtchn_upcall_mask);
+	OFFSET(XEN_vcpu_info_pending, vcpu_info, evtchn_upcall_pending);
+#endif
 }
Index: linux/arch/i386/xen/Makefile
===================================================================
--- linux.orig/arch/i386/xen/Makefile
+++ linux/arch/i386/xen/Makefile
@@ -1,4 +1,4 @@
 obj-y		:= enlighten.o setup.o features.o multicalls.o mmu.o \
-			events.o time.o manage.o
+			events.o time.o manage.o xen-asm.o
 
 obj-$(CONFIG_SMP)	+= smp.o
Index: linux/arch/i386/xen/enlighten.c
===================================================================
--- linux.orig/arch/i386/xen/enlighten.c
+++ linux/arch/i386/xen/enlighten.c
@@ -107,9 +107,11 @@ void xen_vcpu_setup(int cpu)
 	if (err == 0) {
 		have_vcpu_info_placement = 1;
 		per_cpu(xen_vcpu, cpu) = vcpup;
+
 		printk("cpu %d using vcpu_info at %p\n",
 		       cpu, vcpup);
 	}
+
 }
 
 static void __init xen_banner(void)
@@ -169,20 +171,6 @@ static unsigned long xen_save_fl(void)
 	return (-flags) & X86_EFLAGS_IF;
 }
 
-static unsigned long xen_save_fl_direct(void)
-{
-	unsigned long flags;
-
-	/* flag has opposite sense of mask */
-	flags = !x86_read_percpu(xen_vcpu_info.evtchn_upcall_mask);
-
-	/* convert to IF type flag
-	   -0 -> 0x00000000
-	   -1 -> 0xffffffff
-	*/
-	return (-flags) & X86_EFLAGS_IF;
-}
-
 static void xen_restore_fl(unsigned long flags)
 {
 	struct vcpu_info *vcpu;
@@ -209,25 +197,6 @@ static void xen_restore_fl(unsigned long
 	}
 }
 
-static void xen_restore_fl_direct(unsigned long flags)
-{
-	/* convert from IF type flag */
-	flags = !(flags & X86_EFLAGS_IF);
-
-	/* This is an atomic update, so no need to worry about
-	   preemption. */
-	x86_write_percpu(xen_vcpu_info.evtchn_upcall_mask, flags);
-
-	/* If we get preempted here, then any pending event will be
-	   handled anyway. */
-
-	if (flags == 0) {
-		barrier(); /* unmask then check (avoid races) */
-		if (unlikely(x86_read_percpu(xen_vcpu_info.evtchn_upcall_pending)))
-			force_evtchn_callback();
-	}
-}
-
 static void xen_irq_disable(void)
 {
 	/* There's a one instruction preempt window here.  We need to
@@ -238,12 +207,6 @@ static void xen_irq_disable(void)
 	preempt_enable_no_resched();
 }
 
-static void xen_irq_disable_direct(void)
-{
-	/* Atomic update, so preemption not a concern. */
-	x86_write_percpu(xen_vcpu_info.evtchn_upcall_mask, 1);
-}
-
 static void xen_irq_enable(void)
 {
 	struct vcpu_info *vcpu;
@@ -264,19 +227,6 @@ static void xen_irq_enable(void)
 		force_evtchn_callback();
 }
 
-static void xen_irq_enable_direct(void)
-{
-	/* Atomic update, so preemption not a concern. */
-	x86_write_percpu(xen_vcpu_info.evtchn_upcall_mask, 0);
-
-	/* Doesn't matter if we get preempted here, because any
-	   pending event will get dealt with anyway. */
-
-	barrier(); /* unmask then check (avoid races) */
-	if (unlikely(x86_read_percpu(xen_vcpu_info.evtchn_upcall_pending)))
-		force_evtchn_callback();
-}
-
 static void xen_safe_halt(void)
 {
 	/* Blocking includes an implicit local_irq_enable(). */
@@ -862,6 +812,57 @@ static __init void xen_pagetable_setup_d
 	xen_vcpu_setup(smp_processor_id());
 }
 
+static unsigned xen_patch(u8 type, u16 clobbers, void *insns, unsigned len)
+{
+	char *start, *end, *reloc;
+	unsigned ret;
+
+	start = end = reloc = NULL;
+
+#define SITE(x)								\
+	case PARAVIRT_PATCH(x):						\
+	if (have_vcpu_info_placement) {					\
+		start = (char *)xen_##x##_direct;			\
+		end = xen_##x##_direct_end;				\
+		reloc = xen_##x##_direct_reloc;				\
+	}								\
+	goto patch_site
+
+	switch(type) {
+		SITE(irq_enable);
+		SITE(irq_disable);
+		SITE(save_fl);
+		SITE(restore_fl);
+#undef SITE
+
+	patch_site:
+		if (start == NULL || (end-start) > len)
+			goto default_patch;
+
+		ret = paravirt_patch_insns(insns, len, start, end);
+
+		/* Note: because reloc is assigned from something that
+		   appears to be an array, gcc assumes it's non-null,
+		   but doesn't know its relationship with start and
+		   end. */
+		if (reloc > start && reloc < end) {
+			int reloc_off = reloc - start;
+			long *relocp = (long *)(insns + reloc_off);
+			long delta = start - (char *)insns;
+
+			*relocp += delta;
+		}
+		break;
+
+	default_patch:
+	default:
+		ret = paravirt_patch_default(type, clobbers, insns, len);
+		break;
+	}
+
+	return ret;
+}
+
 static const struct paravirt_ops xen_paravirt_ops __initdata = {
 	.paravirt_enabled = 1,
 	.shared_kernel_pmd = 0,
@@ -869,7 +870,7 @@ static const struct paravirt_ops xen_par
 	.name = "Xen",
 	.banner = xen_banner,
 
-	.patch = paravirt_patch_default,
+	.patch = xen_patch,
 
 	.memory_setup = xen_memory_setup,
 	.arch_setup = xen_arch_setup,
@@ -1046,6 +1047,7 @@ static const struct machine_ops __initda
 	.emergency_restart = xen_emergency_restart,
 };
 
+
 /* First C function to be called on Xen boot */
 asmlinkage void __init xen_start_kernel(void)
 {
Index: linux/arch/i386/xen/xen-asm.S
===================================================================
--- /dev/null
+++ linux/arch/i386/xen/xen-asm.S
@@ -0,0 +1,114 @@
+/*
+	Asm versions of Xen pv-ops, suitable for either direct use or inlining.
+	The inline versions are the same as the direct-use versions, with the
+	pre- and post-amble chopped off.
+
+	This code is encoded for size rather than absolute efficiency,
+	with a view to being able to inline as much as possible.
+
+	We only bother with direct forms (ie, vcpu in pda) of the operations
+	here; the indirect forms are better handled in C, since they're
+	generally too large to inline anyway.
+ */
+
+#include <linux/linkage.h>
+#include <asm/asm-offsets.h>
+#include <asm/thread_info.h>
+#include <asm/percpu.h>
+#include <asm/asm-offsets.h>
+#include <asm/processor-flags.h>
+
+#define RELOC(x, v)	.globl x##_reloc; x##_reloc=v
+#define ENDPATCH(x)	.globl x##_end; x##_end=.
+
+/*
+	Enable events.  This clears the event mask and tests the pending
+	event status with one and operation.  If there are pending
+	events, then enter the hypervisor to get them handled.
+ */
+ENTRY(xen_irq_enable_direct)
+	/* Clear mask and test pending */
+	andw $0x00ff, PER_CPU_VAR(xen_vcpu_info)+XEN_vcpu_info_pending
+	/* Preempt here doesn't matter because that will deal with
+	   any pending interrupts.  The pending check may end up being
+	   run on the wrong CPU, but that doesn't hurt. */
+	jz 1f
+2:	call check_events
+1:
+ENDPATCH(xen_irq_enable_direct)
+	ret
+	ENDPROC(xen_irq_enable_direct)
+	RELOC(xen_irq_enable_direct, 2b+1)
+
+
+/*
+	Disabling events is simply a matter of making the event mask
+	non-zero.
+ */
+ENTRY(xen_irq_disable_direct)
+	movb $1, PER_CPU_VAR(xen_vcpu_info)+XEN_vcpu_info_mask
+ENDPATCH(xen_irq_disable_direct)
+	ret
+	ENDPROC(xen_irq_disable_direct)
+	RELOC(xen_irq_disable_direct, 0)
+
+/*
+	(xen_)save_fl is used to get the current interrupt enable status.
+	Callers expect the status to be in X86_EFLAGS_IF, and other bits
+	may be set in the return value.  We take advantage of this by
+	making sure that X86_EFLAGS_IF has the right value (and other bits
+	in that byte are 0), but other bits in the return value are
+	undefined.  We need to toggle the state of the bit, because
+	Xen and x86 use opposite senses (mask vs enable).
+ */
+ENTRY(xen_save_fl_direct)
+	testb $0xff, PER_CPU_VAR(xen_vcpu_info)+XEN_vcpu_info_mask
+	setz %ah
+	addb %ah,%ah
+ENDPATCH(xen_save_fl_direct)
+	ret
+	ENDPROC(xen_save_fl_direct)
+	RELOC(xen_save_fl_direct, 0)
+
+
+/*
+	In principle the caller should be passing us a value return
+	from xen_save_fl_direct, but for robustness sake we test only
+	the X86_EFLAGS_IF flag rather than the whole byte. After
+	setting the interrupt mask state, it checks for unmasked
+	pending events and enters the hypervisor to get them delivered
+	if so.
+ */
+ENTRY(xen_restore_fl_direct)
+	testb $X86_EFLAGS_IF>>8, %ah
+	setz %al
+	movb %al, PER_CPU_VAR(xen_vcpu_info)+XEN_vcpu_info_mask
+	/* Preempt here doesn't matter because that will deal with
+	   any pending interrupts.  The pending check may end up being
+	   run on the wrong CPU, but that doesn't hurt. */
+
+	/* check for pending but unmasked */
+	cmpw $0x0001, PER_CPU_VAR(xen_vcpu_info)+XEN_vcpu_info_pending
+	jz 1f
+2:	call check_events
+1:
+ENDPATCH(xen_restore_fl_direct)
+	ret
+	ENDPROC(xen_restore_fl_direct)
+	RELOC(xen_restore_fl_direct, 2b+1)
+
+
+
+/*
+	Force an event check by making a hypercall,
+	but preserve regs before making the call.
+ */
+check_events:
+	push %eax
+	push %ecx
+	push %edx
+	call force_evtchn_callback
+	pop %edx
+	pop %ecx
+	pop %eax
+	ret
Index: linux/arch/i386/xen/xen-ops.h
===================================================================
--- linux.orig/arch/i386/xen/xen-ops.h
+++ linux/arch/i386/xen/xen-ops.h
@@ -54,4 +54,17 @@ int xen_smp_call_function_single(int cpu
 int xen_smp_call_function_mask(cpumask_t mask, void (*func)(void *),
 			       void *info, int wait);
 
+
+/* Declare an asm function, along with symbols needed to make it
+   inlineable */
+#define DECL_ASM(ret, name, ...)		\
+	ret name(__VA_ARGS__);			\
+	extern char name##_end[];		\
+	extern char name##_reloc[]		\
+
+DECL_ASM(void, xen_irq_enable_direct, void);
+DECL_ASM(void, xen_irq_disable_direct, void);
+DECL_ASM(unsigned long, xen_save_fl_direct, void);
+DECL_ASM(void, xen_restore_fl_direct, unsigned long);
+
 #endif /* XEN_OPS_H */

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-ecryptfs-fix-lookup-error-for-special-files.patch
process_zones-fix-recovery-code.patch
remove-bdput-from-do_open-in-fs-block_devc.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
revert-gregkh-driver-block-device.patch
revert-gregkh-driver-warn-when-statically-allocated-kobjects-are-used.patch
sysfs-crash-debugging.patch
git-dma.patch
git-dma-makefile-fix.patch
disable-ioat.patch
git-dvb.patch
git-dvb-fixup-2.patch
infiniband-work-around-gcc-slub-problem.patch
adbhid-produce-all-capslock-key-events.patch
iforce-warning-fix.patch
console-keyboard-events-and-accessibility-fix.patch
console-keyboard-events-and-accessibility-fix-2.patch
git-kvm.patch
git-libata-all.patch
ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61patch.patch
ide-arm-hack.patch
git-mmc.patch
git-mmc-fixup.patch
gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct-vs-git-mmc.patch
git-mtd.patch
git-netdev-all.patch
e1000e-build-fix.patch
revert-8139too-clean-up-i-o-remapping.patch
git-net.patch
git-net-fixup.patch
git-backlight.patch
git-nfs-vs-git-unionfs.patch
git-nfsd.patch
revert-gregkh-pci-pci_bridge-device.patch
pci-remove-irritating-try-pci=assign-busses-warning.patch
fix-ide-legacy-mode-resources-fix.patch
git-s390.patch
git-scsi-misc.patch
advansys-printk-fix.patch
git-block-fixup.patch
git-block-fix-headers_check.patch
git-unionfs.patch
git-unionfs-build-fix.patch
git-unionfs-fix-2.patch
fix-gregkh-usb-usb-sisusb2vga-convert-printk-to-dev_-macros.patch
git-wireless.patch
git-wireless-fixup.patch
git-wireless-vs-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
git-wireless-printk-fixes.patch
net-add-ath5k-wireless-driver-fix.patch
x86_64-get-mp_bus_to_node-as-early-v3.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable-fix.patch
git-xfs.patch
git-kgdb-fixup.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
alloc_pages-permit-get_zeroed_pagegfp_atomic-from-interrupt-context.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
git-nfs-vs-nfs-convert-to-new-aops.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
categorize-gfp-flags-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
mm-mempolicyc-cleanups-fix.patch
security-convert-lsm-into-a-static-interface-fix.patch
security-convert-lsm-into-a-static-interface-fix-2.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
add-in-sunos-41x-compatible-mode-for-ufs-fix.patch
core_pattern-fix-up-a-few-miscellaneous-bugs-fix.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
deprecate-aout-elf-interpreters-fix.patch
ext2-ext3-ext4-add-block-bitmap-validation-fix.patch
pie-executable-randomization-fix-2.patch
binfmt_flat-warning-fixes.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
revert-faster-ext2_clear_inode.patch
ecryptfs-printk-warning-fixes.patch
tdfxfb-mtrr-support-fix.patch
fbdev-fb_create_modedb-non-static-int-first-=-1-fix.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
64-bit-i_version-afs-fixes.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
task-containersv11-basic-task-container-framework-fix.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
profile-likely-unlikely-macros-fix.patch
check_dirty_inode_list.patch
w1-build-fix.patch
