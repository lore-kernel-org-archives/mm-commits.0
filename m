From: akpm@linux-foundation.org
Subject: - xen-paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction.patch removed from -mm tree
Date: Thu, 01 Mar 2007 20:57:00 -0800
Message-ID: <200703020457.l224v0cx000490@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41900 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422903AbXCBE5D (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 23:57:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, jeremy@xensource.com, mm-commits@vger.kernel.org


The patch titled
     xen-paravirt_ops: add hooks to intercept mm creation and destruction
has been removed from the -mm tree.  Its filename was
     xen-paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction.patch

This patch was dropped because Zach's patches destroyed it all

------------------------------------------------------
Subject: xen-paravirt_ops: add hooks to intercept mm creation and destruction
From: Jeremy Fitzhardinge <jeremy@goop.org>

Add hooks to allow a paravirt implementation to track the lifetime of an mm.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/paravirt.c    |    4 ++++
 include/asm-i386/mmu_context.h |    8 ++++++--
 include/asm-i386/paravirt.h    |   24 ++++++++++++++++++++++++
 include/linux/sched.h          |    6 ++++++
 kernel/fork.c                  |    2 ++
 mm/mmap.c                      |    3 +++
 6 files changed, 45 insertions(+), 2 deletions(-)

diff -puN arch/i386/kernel/paravirt.c~xen-paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c~xen-paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction
+++ a/arch/i386/kernel/paravirt.c
@@ -516,6 +516,10 @@ struct paravirt_ops paravirt_ops = {
 	.irq_enable_sysexit = native_irq_enable_sysexit,
 	.iret = native_iret,
 
+	.dup_mmap = paravirt_nop,
+	.exit_mmap = paravirt_nop,
+	.activate_mm = paravirt_nop,
+
 	.startup_ipi_hook = paravirt_nop,
 };
 
diff -puN include/asm-i386/mmu_context.h~xen-paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction include/asm-i386/mmu_context.h
--- a/include/asm-i386/mmu_context.h~xen-paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction
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
diff -puN include/asm-i386/paravirt.h~xen-paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h~xen-paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction
+++ a/include/asm-i386/paravirt.h
@@ -118,6 +118,12 @@ struct paravirt_ops
 	void (*io_delay)(void);
 	void (*const_udelay)(unsigned long loops);
 
+	void (*activate_mm)(struct mm_struct *prev,
+			    struct mm_struct *next);
+	void (*dup_mmap)(struct mm_struct *oldmm,
+			 struct mm_struct *mm);
+	void (*exit_mmap)(struct mm_struct *mm);
+
 #ifdef CONFIG_X86_LOCAL_APIC
 	void (*apic_write)(unsigned long reg, unsigned long v);
 	void (*apic_write_atomic)(unsigned long reg, unsigned long v);
@@ -388,6 +394,24 @@ static inline void startup_ipi_hook(int 
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
diff -puN include/linux/sched.h~xen-paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction include/linux/sched.h
--- a/include/linux/sched.h~xen-paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction
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
diff -puN kernel/fork.c~xen-paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction kernel/fork.c
--- a/kernel/fork.c~xen-paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction
+++ a/kernel/fork.c
@@ -287,6 +287,8 @@ static inline int dup_mmap(struct mm_str
 		if (retval)
 			goto out;
 	}
+	/* a new mm has just been created */
+	arch_dup_mmap(oldmm, mm);
 	retval = 0;
 out:
 	up_write(&mm->mmap_sem);
diff -puN mm/mmap.c~xen-paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction mm/mmap.c
--- a/mm/mmap.c~xen-paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction
+++ a/mm/mmap.c
@@ -1979,6 +1979,9 @@ void exit_mmap(struct mm_struct *mm)
 	unsigned long nr_accounted = 0;
 	unsigned long end;
 
+	/* mm's last user has gone, and its about to be pulled down */
+	arch_exit_mmap(mm);
+
 	lru_add_drain();
 	flush_cache_mm(mm);
 	tlb = tlb_gather_mmu(mm, 1);
_

Patches currently in -mm which might be from jeremy@goop.org are

xen-paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction.patch
xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations.patch
xen-paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity.patch
xen-paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure.patch
xen-paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch
xen-paravirt_ops-consistently-wrap-paravirt-ops-callsites-to-make-them-patchable.patch
xen-paravirt_ops-add-common-patching-machinery.patch
xen-paravirt_ops-add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
xen-paravirt_ops-allocate-and-free-vmalloc-areas.patch
xen-paravirt_ops-add-nosegneg-capability-to-the-vsyscall-page-notes.patch
xen-paravirt_ops-add-xen-config-options.patch
xen-paravirt_ops-add-xen-interface-header-files.patch
xen-paravirt_ops-core-xen-implementation.patch
xen-paravirt_ops-use-the-hvc-console-infrastructure-for-xen-console.patch
xen-paravirt_ops-add-early-printk-support-via-hvc-console.patch
xen-paravirt_ops-add-xen-grant-table-support.patch
xen-paravirt_ops-add-the-xenbus-sysfs-and-virtual-device-hotplug-driver.patch
xen-paravirt_ops-add-xen-virtual-block-device-driver.patch
xen-paravirt_ops-add-the-xen-virtual-network-device-driver.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
