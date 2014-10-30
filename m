From: akpm@linux-foundation.org
Subject: [obsolete] arch-x86-include-asm-io_apich-fix-build.patch removed
 from -mm tree
Date: Thu, 30 Oct 2014 13:26:59 -0700
Message-ID: <54529f13.JX1/Tk0vm8HsnXnV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40446 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932513AbaJ3U06 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Oct 2014 16:26:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, JBeulich@suse.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/x86/include/asm/io_apic.h: fix build
has been removed from the -mm tree.  Its filename was
     arch-x86-include-asm-io_apich-fix-build.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: arch/x86/include/asm/io_apic.h: fix build

i386 allnoconfig:

In file included from arch/x86/kernel/x86_init.c:21:
./arch/x86/include/asm/io_apic.h:240: error: static declaration of 'mp_should_keep_irq' follows non-static declaration
./arch/x86/include/asm/pci_x86.h:96: note: previous declaration of 'mp_should_keep_irq' was here

Fix it by moving the mp_should_keep_irq() definition out of
arch/x86/include/asm/pci_x86.h and into the appropriate ifdef section within
arch/x86/include/asm/io_apic.h.

Also tidy up the CONFIG_X86_IO_APIC ifdeffery.

(Seems that a fix for this is in the works but hasn't yet propagated into
-next)

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jan Beulich <JBeulich@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/io_apic.h |    5 +++--
 arch/x86/include/asm/pci_x86.h |    2 --
 2 files changed, 3 insertions(+), 4 deletions(-)

diff -puN arch/x86/include/asm/io_apic.h~arch-x86-include-asm-io_apich-fix-build arch/x86/include/asm/io_apic.h
--- a/arch/x86/include/asm/io_apic.h~arch-x86-include-asm-io_apich-fix-build
+++ a/arch/x86/include/asm/io_apic.h
@@ -197,6 +197,7 @@ extern int mp_set_gsi_attr(u32 gsi, int
 extern void __init pre_init_apic_IRQ0(void);
 
 extern void mp_save_irq(struct mpc_intsrc *m);
+extern bool mp_should_keep_irq(struct device *dev);
 
 extern void disable_ioapic_support(void);
 
@@ -227,7 +228,7 @@ static inline void io_apic_modify(unsign
 
 extern void io_apic_eoi(unsigned int apic, unsigned int vector);
 
-#else  /* !CONFIG_X86_IO_APIC */
+#else	/* CONFIG_X86_IO_APIC */
 
 #define io_apic_assign_pci_irqs 0
 #define setup_ioapic_ids_from_mpc x86_init_noop
@@ -262,6 +263,6 @@ static inline void disable_ioapic_suppor
 #define native_setup_ioapic_entry	NULL
 #define native_compose_msi_msg		NULL
 #define native_eoi_ioapic_pin		NULL
-#endif
+#endif	/* CONFIG_X86_IO_APIC */
 
 #endif /* _ASM_X86_IO_APIC_H */
diff -puN arch/x86/include/asm/pci_x86.h~arch-x86-include-asm-io_apich-fix-build arch/x86/include/asm/pci_x86.h
--- a/arch/x86/include/asm/pci_x86.h~arch-x86-include-asm-io_apich-fix-build
+++ a/arch/x86/include/asm/pci_x86.h
@@ -93,8 +93,6 @@ extern raw_spinlock_t pci_config_lock;
 extern int (*pcibios_enable_irq)(struct pci_dev *dev);
 extern void (*pcibios_disable_irq)(struct pci_dev *dev);
 
-extern bool mp_should_keep_irq(struct device *dev);
-
 struct pci_raw_ops {
 	int (*read)(unsigned int domain, unsigned int bus, unsigned int devfn,
 						int reg, int len, u32 *val);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix.patch
mm.patch
mm-memcontrol-lockless-page-counters-fix.patch
mm-memcontrol-lockless-page-counters-fix-fix.patch
kernel-res_counter-remove-the-unused-api-fix.patch
mm-compaction-simplify-deferred-compaction-fix.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch
lib-show_mem-this-patch-adds-cma-reserved-infromation-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
fs-proc-use-a-rb-tree-for-the-directory-entries-fix.patch
fs-binfmt_miscc-use-gfp_kernel-instead-of-gfp_user.patch
init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails-checkpatch-fixes.patch
rtc-omap-add-support-for-pmic_power_en-v3-fix.patch
sysctl-terminate-strings-also-on-r-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch
ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
arch-x86-vdso-vmac-fix-build-with-older-gcc.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
a.patch

