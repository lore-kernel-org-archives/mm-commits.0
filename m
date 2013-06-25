From: akpm@linux-foundation.org
Subject: [merged] x86-fix-trigger_all_cpu_backtrace-implementation.patch
 removed from -mm tree
Date: Tue, 25 Jun 2013 12:22:42 -0700
Message-ID: <51c9ee02.uzC+Vt39Q0FZfxgG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42203 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab3FYTWn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jun 2013 15:22:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, walken@google.com

Subject: [merged] x86-fix-trigger_all_cpu_backtrace-implementation.patch removed from -mm tree
To: walken@google.com,hpa@zytor.com,mingo@redhat.com,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 25 Jun 2013 12:22:42 -0700


The patch titled
     Subject: x86: fix trigger_all_cpu_backtrace() implementation
has been removed from the -mm tree.  Its filename was
     x86-fix-trigger_all_cpu_backtrace-implementation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: x86: fix trigger_all_cpu_backtrace() implementation

Fix the x86 implementation of trigger_all_cpu_backtrace(), which was
previously (accidentally, as far as I can tell) disabled to always return
false as on architectures that do not implement this function.

trigger_all_cpu_backtrace(), as defined in include/linux/nmi.h, should
call arch_trigger_all_cpu_backtrace() if available, or return false if the
underlying arch doesn't implement this function.

x86 did provide a suitable arch_trigger_all_cpu_backtrace()
implementation, but it wasn't actually being used because it was declared
in asm/nmi.h, which linux/nmi.h doesn't include.  Also, linux/nmi.h
couldn't easily be fixed by including asm/nmi.h, because that file is not
available on all architectures.

I am proposing to fix this by moving the x86 definition of
arch_trigger_all_cpu_backtrace() to asm/irq.h.

Tested: echo l > /proc/sysrq-trigger

Before the change, this uses a fallback implementation which shows
backtraces on active CPUs (using smp_call_function_interrupt()).

After the change, this shows NMI backtraces on all CPUs.

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/irq.h    |    5 +++++
 arch/x86/include/asm/nmi.h    |    4 +---
 arch/x86/kernel/apic/hw_nmi.c |    1 +
 3 files changed, 7 insertions(+), 3 deletions(-)

diff -puN arch/x86/include/asm/irq.h~x86-fix-trigger_all_cpu_backtrace-implementation arch/x86/include/asm/irq.h
--- a/arch/x86/include/asm/irq.h~x86-fix-trigger_all_cpu_backtrace-implementation
+++ a/arch/x86/include/asm/irq.h
@@ -41,4 +41,9 @@ extern int vector_used_by_percpu_irq(uns
 
 extern void init_ISA_irqs(void);
 
+#ifdef CONFIG_X86_LOCAL_APIC
+void arch_trigger_all_cpu_backtrace(void);
+#define arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace
+#endif
+
 #endif /* _ASM_X86_IRQ_H */
diff -puN arch/x86/include/asm/nmi.h~x86-fix-trigger_all_cpu_backtrace-implementation arch/x86/include/asm/nmi.h
--- a/arch/x86/include/asm/nmi.h~x86-fix-trigger_all_cpu_backtrace-implementation
+++ a/arch/x86/include/asm/nmi.h
@@ -18,9 +18,7 @@ extern int proc_nmi_enabled(struct ctl_t
 			void __user *, size_t *, loff_t *);
 extern int unknown_nmi_panic;
 
-void arch_trigger_all_cpu_backtrace(void);
-#define arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace
-#endif
+#endif /* CONFIG_X86_LOCAL_APIC */
 
 #define NMI_FLAG_FIRST	1
 
diff -puN arch/x86/kernel/apic/hw_nmi.c~x86-fix-trigger_all_cpu_backtrace-implementation arch/x86/kernel/apic/hw_nmi.c
--- a/arch/x86/kernel/apic/hw_nmi.c~x86-fix-trigger_all_cpu_backtrace-implementation
+++ a/arch/x86/kernel/apic/hw_nmi.c
@@ -9,6 +9,7 @@
  *
  */
 #include <asm/apic.h>
+#include <asm/nmi.h>
 
 #include <linux/cpumask.h>
 #include <linux/kdebug.h>
_

Patches currently in -mm which might be from walken@google.com are

linux-next.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
mm-remove-free_area_cache.patch
mm-nommuc-add-additional-check-for-vread-just-like-vwrite-has-done.patch
mm-change-signature-of-free_reserved_area-to-fix-building-warnings.patch
mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero.patch
mm-arm64-kill-poison_init_mem.patch
mm-x86-use-free_reserved_area-to-simplify-code.patch
mm-tile-use-common-help-functions-to-free-reserved-pages.patch
mm-fix-some-trivial-typos-in-comments.patch
mm-use-managed_pages-to-calculate-default-zonelist-order.patch
mm-accurately-calculate-zone-managed_pages-for-highmem-zones.patch
mm-use-a-dedicated-lock-to-protect-totalram_pages-and-zone-managed_pages.patch
mm-make-__free_pages_bootmem-only-available-at-boot-time.patch
mm-correctly-update-zone-managed_pages.patch
mm-correctly-update-zone-managed_pages-fix.patch
mm-concentrate-modification-of-totalram_pages-into-the-mm-core.patch
mm-report-available-pages-as-memtotal-for-each-numa-node.patch
mm-introduce-helper-function-mem_init_print_info-to-simplify-mem_init.patch
mm-kill-global-variable-num_physpages.patch
mutex-subsystem-synchro-test-module.patch

