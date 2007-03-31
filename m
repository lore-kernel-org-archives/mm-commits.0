From: akpm@linux-foundation.org
Subject: + move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all.patch added to -mm tree
Date: Sat, 31 Mar 2007 12:53:54 -0700
Message-ID: <200703311953.l2VJrsKX028999@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34258 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313AbXCaTyD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 31 Mar 2007 15:54:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ak@suse.de, hch@lst.de


The patch titled
     move-die-notifier-handling-to-common-code: fix vmalloc_sync_all()
has been added to the -mm tree.  Its filename is
     move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: move-die-notifier-handling-to-common-code: fix vmalloc_sync_all()
From: Andrew Morton <akpm@linux-foundation.org>

Christoph removed the vmalloc_sync_all() calls from i386 and x86_64's
register_die_notifier().  Apparently we need them.

Put them back by making vmalloc_sync_all() a vmalloc API functions and play
tricks with attribute(weak) for architectures which do not implement it.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/mm/fault.c              |    1 +
 arch/x86_64/mm/fault.c            |    1 +
 include/asm-i386/pgtable-2level.h |    2 --
 include/asm-i386/pgtable-3level.h |    2 --
 include/asm-x86_64/pgtable.h      |    1 -
 include/linux/vmalloc.h           |    1 +
 kernel/die_notifier.c             |    2 ++
 mm/vmalloc.c                      |    7 +++++++
 8 files changed, 12 insertions(+), 5 deletions(-)

diff -puN arch/i386/mm/fault.c~move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all arch/i386/mm/fault.c
--- a/arch/i386/mm/fault.c~move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all
+++ a/arch/i386/mm/fault.c
@@ -21,6 +21,7 @@
 #include <linux/vt_kern.h>		/* For unblank_screen() */
 #include <linux/highmem.h>
 #include <linux/bootmem.h>		/* for max_low_pfn */
+#include <linux/vmalloc.h>
 #include <linux/module.h>
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
diff -puN arch/x86_64/mm/fault.c~move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all arch/x86_64/mm/fault.c
--- a/arch/x86_64/mm/fault.c~move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all
+++ a/arch/x86_64/mm/fault.c
@@ -21,6 +21,7 @@
 #include <linux/tty.h>
 #include <linux/vt_kern.h>		/* For unblank_screen() */
 #include <linux/compiler.h>
+#include <linux/vmalloc.h>
 #include <linux/module.h>
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
diff -puN include/asm-i386/pgtable-2level.h~move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all include/asm-i386/pgtable-2level.h
--- a/include/asm-i386/pgtable-2level.h~move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all
+++ a/include/asm-i386/pgtable-2level.h
@@ -66,6 +66,4 @@ static inline int pte_exec_kernel(pte_t 
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { (pte).pte_low })
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val })
 
-void vmalloc_sync_all(void);
-
 #endif /* _I386_PGTABLE_2LEVEL_H */
diff -puN include/asm-i386/pgtable-3level.h~move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all include/asm-i386/pgtable-3level.h
--- a/include/asm-i386/pgtable-3level.h~move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all
+++ a/include/asm-i386/pgtable-3level.h
@@ -187,6 +187,4 @@ static inline pmd_t pfn_pmd(unsigned lon
 
 #define __pmd_free_tlb(tlb, x)		do { } while (0)
 
-#define vmalloc_sync_all() ((void)0)
-
 #endif /* _I386_PGTABLE_3LEVEL_H */
diff -puN include/asm-x86_64/pgtable.h~move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all include/asm-x86_64/pgtable.h
--- a/include/asm-x86_64/pgtable.h~move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all
+++ a/include/asm-x86_64/pgtable.h
@@ -411,7 +411,6 @@ static inline pte_t pte_modify(pte_t pte
 
 extern spinlock_t pgd_lock;
 extern struct list_head pgd_list;
-void vmalloc_sync_all(void);
 
 extern int kern_addr_valid(unsigned long addr); 
 
diff -puN include/linux/vmalloc.h~move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all
+++ a/include/linux/vmalloc.h
@@ -53,6 +53,7 @@ extern void vunmap(void *addr);
 
 extern int remap_vmalloc_range(struct vm_area_struct *vma, void *addr,
 							unsigned long pgoff);
+void vmalloc_sync_all(void);
  
 /*
  *	Lowlevel-APIs (not for driver use!)
diff -puN kernel/die_notifier.c~move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all kernel/die_notifier.c
--- a/kernel/die_notifier.c~move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all
+++ a/kernel/die_notifier.c
@@ -1,6 +1,7 @@
 
 #include <linux/module.h>
 #include <linux/notifier.h>
+#Include <linux/vmalloc.h>
 #include <linux/kdebug.h>
 
 
@@ -23,6 +24,7 @@ int notify_die(enum die_val val, const c
 
 int register_die_notifier(struct notifier_block *nb)
 {
+	vmalloc_sync_all();
 	return atomic_notifier_chain_register(&die_chain, nb);
 }
 EXPORT_SYMBOL_GPL(register_die_notifier);
diff -puN mm/vmalloc.c~move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all mm/vmalloc.c
--- a/mm/vmalloc.c~move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all
+++ a/mm/vmalloc.c
@@ -749,3 +749,10 @@ out_einval_locked:
 }
 EXPORT_SYMBOL(remap_vmalloc_range);
 
+/*
+ * Implement a stub for vmalloc_sync_all() if the architecture chose not to
+ * have one.
+ */
+void  __attribute__((weak)) vmalloc_sync_all(void)
+{
+}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
proc-fix-linkage-with-config_sysctl=y-config_proc_sysctl=n.patch
slab-introduce-krealloc-fix.patch
git-acpi.patch
git-alsa.patch
git-alsa-fixup.patch
git-avr32.patch
git-avr32-fixup.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-kvm.patch
git-libata-all.patch
git-libata-all-ipr-fix.patch
libata-acpi-add-infrastructure-for-drivers-to-use-fix.patch
pata_acpi-restore-driver-fix.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
git-ubi.patch
git-netdev-all.patch
vioc-warning-fix.patch
vioc-cast-warning-fix.patch
git-e1000.patch
git-e1000-fixup-2.patch
git-parisc.patch
rm9000-serial-driver.patch
fix-gregkh-pci-pci-piggy-bus.patch
git-pciseg.patch
git-s390.patch
git-unionfs.patch
git-wireless.patch
git-wireless-fixup.patch
fix-x86_64-mm-sched-clock-share.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
x86_64-inhibit-machine-from-asserting-an-nmi-when-doing-alt-sysrq-m-operation-tidy.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
mm-merge-nopfn-into-fault-fix.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy.patch
mm-move-common-segment-checks-to-separate-helper-function-v7-tidy.patch
driver_bfin_serial_core-update.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-fix-fix.patch
add-an-anonymous-inode-source-tidy.patch
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
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix.patch
sys_futex64-allows-64bit-futexes-workaround.patch
proc-maps-protection-vs-utrace.patch
utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-printk-borkage.patch
utrace-x86_64-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
linux-kernel-markers-i386-optimization-fix.patch
revoke-core-code-fix-shared-mapping-revoke.patch
fbdev-hecuba-framebuffer-driver.patch
integrity-new-hooks-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
