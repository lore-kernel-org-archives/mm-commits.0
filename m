From: akpm@osdl.org
Subject: + revert-x86_64-mm-copy-user-nocache.patch added to -mm tree
Date: Wed, 13 Dec 2006 21:55:34 -0800
Message-ID: <200612140555.kBE5tYOA001537@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50984 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbWLNF4G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 00:56:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@osdl.org, ak@suse.de, bos@pathscale.com


The patch titled
     revert x86_64-mm-copy-user-nocache
has been added to the -mm tree.  Its filename is
     revert-x86_64-mm-copy-user-nocache.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: revert x86_64-mm-copy-user-nocache
From: Andrew Morton <akpm@osdl.org>

Evict old patch from Andi's tree - Brian sent a new one.

Cc: Bryan O'Sullivan <bos@pathscale.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/kernel/x8664_ksyms.c    |    1 
 arch/x86_64/lib/Makefile            |    2 
 arch/x86_64/lib/copy_user_nocache.S |  217 --------------------------
 include/asm-x86_64/uaccess.h        |   14 -
 4 files changed, 1 insertion(+), 233 deletions(-)

diff -puN arch/x86_64/kernel/x8664_ksyms.c~revert-x86_64-mm-copy-user-nocache arch/x86_64/kernel/x8664_ksyms.c
--- a/arch/x86_64/kernel/x8664_ksyms.c~revert-x86_64-mm-copy-user-nocache
+++ a/arch/x86_64/kernel/x8664_ksyms.c
@@ -26,7 +26,6 @@ EXPORT_SYMBOL(__put_user_4);
 EXPORT_SYMBOL(__put_user_8);
 
 EXPORT_SYMBOL(copy_user_generic);
-EXPORT_SYMBOL(__copy_user_nocache);
 EXPORT_SYMBOL(copy_from_user);
 EXPORT_SYMBOL(copy_to_user);
 EXPORT_SYMBOL(__copy_from_user_inatomic);
diff -puN arch/x86_64/lib/Makefile~revert-x86_64-mm-copy-user-nocache arch/x86_64/lib/Makefile
--- a/arch/x86_64/lib/Makefile~revert-x86_64-mm-copy-user-nocache
+++ a/arch/x86_64/lib/Makefile
@@ -9,4 +9,4 @@ obj-y := io.o iomap_copy.o
 lib-y := csum-partial.o csum-copy.o csum-wrappers.o delay.o \
 	usercopy.o getuser.o putuser.o  \
 	thunk.o clear_page.o copy_page.o bitstr.o bitops.o
-lib-y += memcpy.o memmove.o memset.o copy_user.o rwlock.o copy_user_nocache.o
+lib-y += memcpy.o memmove.o memset.o copy_user.o rwlock.o
diff -puN arch/x86_64/lib/copy_user_nocache.S~revert-x86_64-mm-copy-user-nocache /dev/null
--- a/arch/x86_64/lib/copy_user_nocache.S
+++ /dev/null
@@ -1,217 +0,0 @@
-/* Copyright 2002 Andi Kleen, SuSE Labs.
- * Subject to the GNU Public License v2.
- *
- * Functions to copy from and to user space.
- */
-
-#include <linux/linkage.h>
-#include <asm/dwarf2.h>
-
-#define FIX_ALIGNMENT 1
-
-#include <asm/current.h>
-#include <asm/asm-offsets.h>
-#include <asm/thread_info.h>
-#include <asm/cpufeature.h>
-
-/*
- * copy_user_nocache - Uncached memory copy with exception handling
- * This will force destination/source out of cache for more performance.
- *
- * Input:
- * rdi destination
- * rsi source
- * rdx count
- * rcx zero flag	when 1 zero on exception
- *
- * Output:
- * eax uncopied bytes or 0 if successful.
- */
-ENTRY(__copy_user_nocache)
-	CFI_STARTPROC
-	pushq %rbx
-	CFI_ADJUST_CFA_OFFSET 8
-	CFI_REL_OFFSET rbx, 0
-	pushq %rcx		/* save zero flag */
-	CFI_ADJUST_CFA_OFFSET 8
-	CFI_REL_OFFSET rcx, 0
-
-	xorl %eax,%eax		/* zero for the exception handler */
-
-#ifdef FIX_ALIGNMENT
-	/* check for bad alignment of destination */
-	movl %edi,%ecx
-	andl $7,%ecx
-	jnz  .Lbad_alignment
-.Lafter_bad_alignment:
-#endif
-
-	movq %rdx,%rcx
-
-	movl $64,%ebx
-	shrq $6,%rdx
-	decq %rdx
-	js   .Lhandle_tail
-
-	.p2align 4
-.Lloop:
-.Ls1:	movq (%rsi),%r11
-.Ls2:	movq 1*8(%rsi),%r8
-.Ls3:	movq 2*8(%rsi),%r9
-.Ls4:	movq 3*8(%rsi),%r10
-.Ld1:	movnti %r11,(%rdi)
-.Ld2:	movnti %r8,1*8(%rdi)
-.Ld3:	movnti %r9,2*8(%rdi)
-.Ld4:	movnti %r10,3*8(%rdi)
-
-.Ls5:	movq 4*8(%rsi),%r11
-.Ls6:	movq 5*8(%rsi),%r8
-.Ls7:	movq 6*8(%rsi),%r9
-.Ls8:	movq 7*8(%rsi),%r10
-.Ld5:	movnti %r11,4*8(%rdi)
-.Ld6:	movnti %r8,5*8(%rdi)
-.Ld7:	movnti %r9,6*8(%rdi)
-.Ld8:	movnti %r10,7*8(%rdi)
-
-	dec  %rdx
-
-	leaq 64(%rsi),%rsi
-	leaq 64(%rdi),%rdi
-
-	jns  .Lloop
-
-	.p2align 4
-.Lhandle_tail:
-	movl %ecx,%edx
-	andl $63,%ecx
-	shrl $3,%ecx
-	jz   .Lhandle_7
-	movl $8,%ebx
-	.p2align 4
-.Lloop_8:
-.Ls9:	movq (%rsi),%r8
-.Ld9:	movnti %r8,(%rdi)
-	decl %ecx
-	leaq 8(%rdi),%rdi
-	leaq 8(%rsi),%rsi
-	jnz .Lloop_8
-
-.Lhandle_7:
-	movl %edx,%ecx
-	andl $7,%ecx
-	jz   .Lende
-	.p2align 4
-.Lloop_1:
-.Ls10:	movb (%rsi),%bl
-.Ld10:	movb %bl,(%rdi)
-	incq %rdi
-	incq %rsi
-	decl %ecx
-	jnz .Lloop_1
-
-	CFI_REMEMBER_STATE
-.Lende:
-	popq %rcx
-	CFI_ADJUST_CFA_OFFSET -8
-	CFI_RESTORE %rcx
-	popq %rbx
-	CFI_ADJUST_CFA_OFFSET -8
-	CFI_RESTORE rbx
-	ret
-	CFI_RESTORE_STATE
-
-#ifdef FIX_ALIGNMENT
-	/* align destination */
-	.p2align 4
-.Lbad_alignment:
-	movl $8,%r9d
-	subl %ecx,%r9d
-	movl %r9d,%ecx
-	cmpq %r9,%rdx
-	jz   .Lhandle_7
-	js   .Lhandle_7
-.Lalign_1:
-.Ls11:	movb (%rsi),%bl
-.Ld11:	movb %bl,(%rdi)
-	incq %rsi
-	incq %rdi
-	decl %ecx
-	jnz .Lalign_1
-	subq %r9,%rdx
-	jmp .Lafter_bad_alignment
-#endif
-
-	/* table sorted by exception address */
-	.section __ex_table,"a"
-	.align 8
-	.quad .Ls1,.Ls1e
-	.quad .Ls2,.Ls2e
-	.quad .Ls3,.Ls3e
-	.quad .Ls4,.Ls4e
-	.quad .Ld1,.Ls1e
-	.quad .Ld2,.Ls2e
-	.quad .Ld3,.Ls3e
-	.quad .Ld4,.Ls4e
-	.quad .Ls5,.Ls5e
-	.quad .Ls6,.Ls6e
-	.quad .Ls7,.Ls7e
-	.quad .Ls8,.Ls8e
-	.quad .Ld5,.Ls5e
-	.quad .Ld6,.Ls6e
-	.quad .Ld7,.Ls7e
-	.quad .Ld8,.Ls8e
-	.quad .Ls9,.Le_quad
-	.quad .Ld9,.Le_quad
-	.quad .Ls10,.Le_byte
-	.quad .Ld10,.Le_byte
-#ifdef FIX_ALIGNMENT
-	.quad .Ls11,.Lzero_rest
-	.quad .Ld11,.Lzero_rest
-#endif
-	.quad .Le5,.Le_zero
-	.previous
-
-	/* compute 64-offset for main loop. 8 bytes accuracy with error on the
-	   pessimistic side. this is gross. it would be better to fix the
-	   interface. */
-	/* eax: zero, ebx: 64 */
-.Ls1e: 	addl $8,%eax
-.Ls2e: 	addl $8,%eax
-.Ls3e: 	addl $8,%eax
-.Ls4e: 	addl $8,%eax
-.Ls5e: 	addl $8,%eax
-.Ls6e: 	addl $8,%eax
-.Ls7e: 	addl $8,%eax
-.Ls8e: 	addl $8,%eax
-	addq %rbx,%rdi	/* +64 */
-	subq %rax,%rdi  /* correct destination with computed offset */
-
-	shlq $6,%rdx	/* loop counter * 64 (stride length) */
-	addq %rax,%rdx	/* add offset to loopcnt */
-	andl $63,%ecx	/* remaining bytes */
-	addq %rcx,%rdx	/* add them */
-	jmp .Lzero_rest
-
-	/* exception on quad word loop in tail handling */
-	/* ecx:	loopcnt/8, %edx: length, rdi: correct */
-.Le_quad:
-	shll $3,%ecx
-	andl $7,%edx
-	addl %ecx,%edx
-	/* edx: bytes to zero, rdi: dest, eax:zero */
-.Lzero_rest:
-	cmpl $0,(%rsp)	/* zero flag set? */
-	jz   .Le_zero
-	movq %rdx,%rcx
-.Le_byte:
-	xorl %eax,%eax
-.Le5:	rep
-	stosb
-	/* when there is another exception while zeroing the rest just return */
-.Le_zero:
-	movq %rdx,%rax
-	jmp .Lende
-	CFI_ENDPROC
-ENDPROC(__copy_user_nocache)
-
-
diff -puN include/asm-x86_64/uaccess.h~revert-x86_64-mm-copy-user-nocache include/asm-x86_64/uaccess.h
--- a/include/asm-x86_64/uaccess.h~revert-x86_64-mm-copy-user-nocache
+++ a/include/asm-x86_64/uaccess.h
@@ -367,18 +367,4 @@ __copy_to_user_inatomic(void __user *dst
 	return copy_user_generic((__force void *)dst, src, size);
 }
 
-#define ARCH_HAS_NOCACHE_UACCESS 1
-extern long __copy_user_nocache(void *dst, const void __user *src, unsigned size, int zerorest);
-
-static inline int __copy_from_user_nocache(void *dst, const void __user *src, unsigned size)
-{
-	might_sleep();
-	return __copy_user_nocache(dst, (__force void *)src, size, 1);
-}
-
-static inline int __copy_from_user_inatomic_nocache(void *dst, const void __user *src, unsigned size)
-{
-	return __copy_user_nocache(dst, (__force void *)src, size, 0);
-}
-
 #endif /* __X86_64_UACCESS_H */
_

Patches currently in -mm which might be from akpm@osdl.org are

build-compileh-earlier.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
acpi-dont-select-pm.patch
implementation-of-acpi_video_get_next_level.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register.patch
sony_apci-resume.patch
sony_apci-resume-fix.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-sony_acpi-fix.patch
git-alsa.patch
alsa-workqueue-fixes.patch
git-drm.patch
ia64-enable-config_debug_spinlock_sleep.patch
git-input-vs-git-alsa.patch
git-libata-all.patch
pata_cs5530-suspend-resume-support-tweak.patch
pata_sil680-suspend-resume-tidy.patch
pata_via-suspend-resume-support-fix.patch
git-lxdialog-fixup.patch
git-mmc-fixup.patch
git-mmc-tifm_sd-warning-fix.patch
git-mtd.patch
git-ubi.patch
ubi-versus-add-include-linux-freezerh-and-move-definitions-from.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
driver-for-silan-sc92031-netdev-include-fix.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
net-use-bitrev8.patch
net-uninline-skb_put.patch
ioat-warning-fix.patch
pci-legacy-resource-fix-tidy.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-in2000-scsi_cmnd-convertion.patch
aic79xx-wrong-max-memory-at-driver-init.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver-fix.patch
git-qla3xxx-fixup.patch
nokia-e70-is-an-unusual-device.patch
fix-gregkh-usb-usb-ehci-hcd-add-shadow-budget-code.patch
git-wireless.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
revert-x86_64-mm-copy-user-nocache.patch
convert-i386-pda-code-to-use-%fs-fixes.patch
add-memcpy_uncached_read-tidy.patch
touchkit-ps-2-touchscreen-driver.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap-fix-2.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap-fix-3.patch
lumpy-reclaim-v2-tidy.patch
nfs-fix-nr_file_dirty-underflow-tidy.patch
deprecate-smbfs-in-favour-of-cifs.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
drivers-add-lcd-support-workqueue-fixups.patch
ecryptfs-public-key-packet-management-slab-fix.patch
add-retain_initrd-boot-option-tweak.patch
count_vm_events-warning-fix.patch
gtod-persistent-clock-support-i386.patch
hrtimers-clean-up-locking.patch
hrtimers-add-state-tracking.patch
clockevents-i386-drivers.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
implement-flush_work.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
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
hpt3xx-rework-rate-filtering-tidy.patch
jmicron-warning-fix.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
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
squash-ipc-warnings.patch
squash-udf-warnings.patch

