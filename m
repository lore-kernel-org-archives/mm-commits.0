From: akpm@linux-foundation.org
Subject: + xen-paravirt-add-hooks-to-intercept-mm-creation-and-destruction.patch added to -mm tree
Date: Thu, 15 Feb 2007 23:00:16 -0800
Message-ID: <200702160700.l1G70GKr022628@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55189 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423372AbXBPHBL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 02:01:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, ak@suse.de, chrisw@sous-sol.org, jeremy@xensource.com, rusty@rustcorp.com.au, zach@vmware.com


The patch titled
     Xen-paravirt: add hooks to intercept mm creation and destruction
has been added to the -mm tree.  Its filename is
     xen-paravirt-add-hooks-to-intercept-mm-creation-and-destruction.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Xen-paravirt: add hooks to intercept mm creation and destruction
From: Jeremy Fitzhardinge <jeremy@goop.org>

Add hooks to allow a paravirt implementation to track the lifetime of an mm.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Zachary Amsden <zach@vmware.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/paravirt.c    |    4 +++
 include/asm-i386/mmu_context.h |    8 ++++--
 include/asm-i386/paravirt.h    |   39 +++++++++++++++++++++++++++++++
 include/linux/sched.h          |    6 ++++
 kernel/fork.c                  |    1 
 mm/mmap.c                      |    2 +
 6 files changed, 58 insertions(+), 2 deletions(-)

diff -puN arch/i386/kernel/paravirt.c~xen-paravirt-add-hooks-to-intercept-mm-creation-and-destruction arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c~xen-paravirt-add-hooks-to-intercept-mm-creation-and-destruction
+++ a/arch/i386/kernel/paravirt.c
@@ -706,6 +706,10 @@ struct paravirt_ops paravirt_ops = {
 	.irq_enable_sysexit = native_irq_enable_sysexit,
 	.iret = native_iret,
 
+	.dup_mmap = (void *)native_nop,
+	.exit_mmap = (void *)native_nop,
+	.activate_mm = (void *)native_nop,
+
 	.startup_ipi_hook = (void *)native_nop,
 };
 
diff -puN include/asm-i386/mmu_context.h~xen-paravirt-add-hooks-to-intercept-mm-creation-and-destruction include/asm-i386/mmu_context.h
--- a/include/asm-i386/mmu_context.h~xen-paravirt-add-hooks-to-intercept-mm-creation-and-destruction
+++ a/include/asm-i386/mmu_context.h
@@ -5,6 +5,7 @@
 #include <asm/atomic.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
+#include <asm/paravirt.h>
 
 /*
  * Used for LDT copy/destruction.
@@ -65,7 +66,10 @@ static inline void switch_mm(struct mm_s
 #define deactivate_mm(tsk, mm)			\
 	asm("movl %0,%%gs": :"r" (0));
 
-#define activate_mm(prev, next) \
-	switch_mm((prev),(next),NULL)
+#define activate_mm(prev, next)				\
+	do {						\
+		arch_activate_mm(prev, next);		\
+		switch_mm((prev),(next),NULL);		\
+	} while(0);
 
 #endif
diff -puN include/asm-i386/paravirt.h~xen-paravirt-add-hooks-to-intercept-mm-creation-and-destruction include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h~xen-paravirt-add-hooks-to-intercept-mm-creation-and-destruction
+++ a/include/asm-i386/paravirt.h
@@ -126,6 +126,12 @@ struct paravirt_ops
 	void (*io_delay)(void);
 	void (*const_udelay)(unsigned long loops);
 
+	void (fastcall *activate_mm)(struct mm_struct *prev,
+				     struct mm_struct *next);
+	void (fastcall *dup_mmap)(struct mm_struct *oldmm,
+				  struct mm_struct *mm);
+	void (fastcall *exit_mmap)(struct mm_struct *mm);
+
 #ifdef CONFIG_X86_LOCAL_APIC
 	void (*apic_write)(unsigned long reg, unsigned long v);
 	void (*apic_write_atomic)(unsigned long reg, unsigned long v);
@@ -429,6 +435,24 @@ static inline void startup_ipi_hook(int 
 }
 #endif
 
+#define __HAVE_ARCH_MM_LIFETIME
+static inline void arch_activate_mm(struct mm_struct *prev,
+				    struct mm_struct *next)
+{
+	paravirt_ops.activate_mm(prev, next);
+}
+
+static inline void arch_dup_mmap(struct mm_struct *oldmm,
+				 struct mm_struct *mm)
+{
+	paravirt_ops.dup_mmap(oldmm, mm);
+}
+
+static inline void arch_exit_mmap(struct mm_struct *mm)
+{
+	paravirt_ops.exit_mmap(mm);
+}
+
 #define __flush_tlb() paravirt_ops.flush_tlb_user()
 #define __flush_tlb_global() paravirt_ops.flush_tlb_kernel()
 #define __flush_tlb_single(addr) paravirt_ops.flush_tlb_single(addr)
@@ -673,5 +697,20 @@ static inline void paravirt_pagetable_se
 	set_pgd(&base[0], base[USER_PTRS_PER_PGD]);
 #endif
 }
+
+static inline void paravirt_activate_mm(struct mm_struct *prev,
+					struct mm_struct *next)
+{
+}
+
+static inline void paravirt_dup_mmap(struct mm_struct *oldmm,
+				     struct mm_struct *mm)
+{
+}
+
+static inline void paravirt_exit_mmap(struct mm_struct *mm)
+{
+}
+
 #endif /* CONFIG_PARAVIRT */
 #endif	/* __ASM_PARAVIRT_H */
diff -puN include/linux/sched.h~xen-paravirt-add-hooks-to-intercept-mm-creation-and-destruction include/linux/sched.h
--- a/include/linux/sched.h~xen-paravirt-add-hooks-to-intercept-mm-creation-and-destruction
+++ a/include/linux/sched.h
@@ -375,6 +375,12 @@ struct mm_struct {
 	struct kioctx		*ioctx_list;
 };
 
+#ifndef __HAVE_ARCH_MM_LIFETIME
+#define arch_activate_mm(prev, next)	do {} while(0)
+#define arch_dup_mmap(oldmm, mm)	do {} while(0)
+#define arch_exit_mmap(mm)		do {} while(0)
+#endif
+
 struct sighand_struct {
 	atomic_t		count;
 	struct k_sigaction	action[_NSIG];
diff -puN kernel/fork.c~xen-paravirt-add-hooks-to-intercept-mm-creation-and-destruction kernel/fork.c
--- a/kernel/fork.c~xen-paravirt-add-hooks-to-intercept-mm-creation-and-destruction
+++ a/kernel/fork.c
@@ -287,6 +287,7 @@ static inline int dup_mmap(struct mm_str
 		if (retval)
 			goto out;
 	}
+	arch_dup_mmap(oldmm, mm);
 	retval = 0;
 out:
 	up_write(&mm->mmap_sem);
diff -puN mm/mmap.c~xen-paravirt-add-hooks-to-intercept-mm-creation-and-destruction mm/mmap.c
--- a/mm/mmap.c~xen-paravirt-add-hooks-to-intercept-mm-creation-and-destruction
+++ a/mm/mmap.c
@@ -1977,6 +1977,8 @@ void exit_mmap(struct mm_struct *mm)
 	unsigned long nr_accounted = 0;
 	unsigned long end;
 
+	arch_exit_mmap(mm);
+
 	lru_add_drain();
 	flush_cache_mm(mm);
 	tlb = tlb_gather_mmu(mm, 1);
_

Patches currently in -mm which might be from jeremy@goop.org are

i386-probe_roms-cleanup.patch
no-need-to-use-traditional-for-processing-asm-in-i386-kernel.patch
xen-paravirt-fix-typo-in-sync_constant_test_bits-name.patch
xen-paravirt-ignore-vgacon-if-hardware-not-present.patch
xen-paravirt-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries.patch
xen-paravirt-paravirt_ops-hooks-to-set-up-initial-pagetable.patch
xen-paravirt-paravirt_ops-allocate-a-fixmap-slot.patch
xen-paravirt-remove-ctor-for-pgd-cache.patch
xen-paravirt-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
xen-paravirt-allow-paravirt-backend-to-select-pgd-allocation-alignment.patch
xen-paravirt-add-hooks-to-intercept-mm-creation-and-destruction.patch
xen-paravirt-add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
xen-paravirt-allocate-and-free-vmalloc-areas.patch
xen-paravirt-add-nosegneg-capability-to-the-vsyscall-page-notes.patch
xen-paravirt-add-xen-config-options-and-disable-unsupported-config-options.patch
xen-paravirt-add-xen-interface-header-files.patch
xen-paravirt-core-xen-implementation.patch
xen-paravirt-add-the-xen-virtual-console-driver.patch
xen-paravirt-add-xen-grant-table-support.patch
xen-paravirt-add-the-xenbus-sysfs-and-virtual-device-hotplug-driver.patch
xen-paravirt-add-xen-virtual-block-device-driver.patch
xen-paravirt-add-the-xen-virtual-network-device-driver.patch
uninline-jiffiesh-functions.patch
