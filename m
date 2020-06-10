From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-rejects.patch removed from -mm tree
Date: Tue, 09 Jun 2020 17:36:32 -0700
Message-ID: <20200610003632.EUOduGBX9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725963AbgFJAge (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 20:36:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/fault.c   |   33 ++++++++++++++++++++++++++++++---
 arch/x86/xen/smp_pv.c |    1 +
 kernel/trace/ftrace.c |    6 ++----
 3 files changed, 33 insertions(+), 7 deletions(-)

--- a/arch/x86/mm/fault.c~linux-next-rejects
+++ a/arch/x86/mm/fault.c
@@ -1349,11 +1349,38 @@ trace_page_fault_entries(struct pt_regs
 		trace_page_fault_kernel(address, regs, error_code);
 }
 
-dotraplinkage void
-do_page_fault(struct pt_regs *regs, unsigned long hw_error_code,
-		unsigned long address)
+static __always_inline void
+handle_page_fault(struct pt_regs *regs, unsigned long error_code,
+			      unsigned long address)
 {
+	trace_page_fault_entries(regs, error_code, address);
+
+	if (unlikely(kmmio_fault(regs, address)))
+		return;
+
+	/* Was the fault on kernel-controlled part of the address space? */
+	if (unlikely(fault_in_kernel_space(address))) {
+		do_kern_addr_fault(regs, error_code, address);
+	} else {
+		do_user_addr_fault(regs, error_code, address);
+		/*
+		 * User address page fault handling might have reenabled
+		 * interrupts. Fixing up all potential exit points of
+		 * do_user_addr_fault() and its leaf functions is just not
+		 * doable w/o creating an unholy mess or turning the code
+		 * upside down.
+		 */
+		local_irq_disable();
+	}
+}
+
+DEFINE_IDTENTRY_RAW_ERRORCODE(exc_page_fault)
+{
+	unsigned long address = read_cr2();
+	bool rcu_exit;
+
 	prefetchw(&current->mm->mmap_lock);
+
 	/*
 	 * KVM has two types of events that are, logically, interrupts, but
 	 * are unfortunately delivered using the #PF vector.  These events are
--- a/arch/x86/xen/smp_pv.c~linux-next-rejects
+++ a/arch/x86/xen/smp_pv.c
@@ -27,6 +27,7 @@
 
 #include <asm/paravirt.h>
 #include <asm/desc.h>
+#include <asm/idtentry.h>
 #include <asm/cpu.h>
 
 #include <xen/interface/xen.h>
--- a/kernel/trace/ftrace.c~linux-next-rejects
+++ a/kernel/trace/ftrace.c
@@ -2016,14 +2016,14 @@ void ftrace_bug(int failed, struct dyn_f
 {
 	unsigned long ip = rec ? rec->ip : 0;
 
+	pr_info("------------[ ftrace bug ]------------\n");
+
 	switch (failed) {
 	case -EFAULT:
-		FTRACE_WARN_ON_ONCE(1);
 		pr_info("ftrace faulted on modifying ");
 		print_ip_sym(KERN_INFO, ip);
 		break;
 	case -EINVAL:
-		FTRACE_WARN_ON_ONCE(1);
 		pr_info("ftrace failed to modify ");
 		print_ip_sym(KERN_INFO, ip);
 		print_ip_ins(" actual:   ", (unsigned char *)ip);
@@ -2034,12 +2034,10 @@ void ftrace_bug(int failed, struct dyn_f
 		}
 		break;
 	case -EPERM:
-		FTRACE_WARN_ON_ONCE(1);
 		pr_info("ftrace faulted on writing ");
 		print_ip_sym(KERN_INFO, ip);
 		break;
 	default:
-		FTRACE_WARN_ON_ONCE(1);
 		pr_info("ftrace faulted on unknown error ");
 		print_ip_sym(KERN_INFO, ip);
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-sparc-mm-srmmuc-fix-build.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
lib-test-get_count_order-long-in-test_bitopsc-fix.patch
lib-test-get_count_order-long-in-test_bitopsc-fix-fix.patch
ipc-convert-ipcs_idr-to-xarray-update-fix.patch
mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api-fix-2-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
