From: akpm@osdl.org
Subject: - x86-simplify-notify_page_fault.patch removed from -mm tree
Date: Wed, 10 Jan 2007 15:03:52 -0800
Message-ID: <200701102303.l0AN3qq3010863@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33479 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965270AbXAJXEA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 18:04:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, ak@muc.de, mm-commits@vger.kernel.org


The patch titled
     x86: simplify notify_page_fault()
has been removed from the -mm tree.  Its filename was
     x86-simplify-notify_page_fault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86: simplify notify_page_fault()
From: "Jan Beulich" <jbeulich@novell.com>

Remove all parameters from this function that aren't really variable.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <ak@muc.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/mm/fault.c   |   18 ++++++++----------
 arch/x86_64/mm/fault.c |   18 ++++++++----------
 2 files changed, 16 insertions(+), 20 deletions(-)

diff -puN arch/i386/mm/fault.c~x86-simplify-notify_page_fault arch/i386/mm/fault.c
--- a/arch/i386/mm/fault.c~x86-simplify-notify_page_fault
+++ a/arch/i386/mm/fault.c
@@ -46,17 +46,17 @@ int unregister_page_fault_notifier(struc
 }
 EXPORT_SYMBOL_GPL(unregister_page_fault_notifier);
 
-static inline int notify_page_fault(enum die_val val, const char *str,
-			struct pt_regs *regs, long err, int trap, int sig)
+static inline int notify_page_fault(struct pt_regs *regs, long err)
 {
 	struct die_args args = {
 		.regs = regs,
-		.str = str,
+		.str = "page fault",
 		.err = err,
-		.trapnr = trap,
-		.signr = sig
+		.trapnr = 14,
+		.signr = SIGSEGV
 	};
-	return atomic_notifier_call_chain(&notify_page_fault_chain, val, &args);
+	return atomic_notifier_call_chain(&notify_page_fault_chain,
+	                                  DIE_PAGE_FAULT, &args);
 }
 
 /*
@@ -352,8 +352,7 @@ fastcall void __kprobes do_page_fault(st
 	if (unlikely(address >= TASK_SIZE)) {
 		if (!(error_code & 0x0000000d) && vmalloc_fault(address) >= 0)
 			return;
-		if (notify_page_fault(DIE_PAGE_FAULT, "page fault", regs, error_code, 14,
-						SIGSEGV) == NOTIFY_STOP)
+		if (notify_page_fault(regs, error_code) == NOTIFY_STOP)
 			return;
 		/*
 		 * Don't take the mm semaphore here. If we fixup a prefetch
@@ -362,8 +361,7 @@ fastcall void __kprobes do_page_fault(st
 		goto bad_area_nosemaphore;
 	}
 
-	if (notify_page_fault(DIE_PAGE_FAULT, "page fault", regs, error_code, 14,
-					SIGSEGV) == NOTIFY_STOP)
+	if (notify_page_fault(regs, error_code) == NOTIFY_STOP)
 		return;
 
 	/* It's safe to allow irq's after cr2 has been saved and the vmalloc
diff -puN arch/x86_64/mm/fault.c~x86-simplify-notify_page_fault arch/x86_64/mm/fault.c
--- a/arch/x86_64/mm/fault.c~x86-simplify-notify_page_fault
+++ a/arch/x86_64/mm/fault.c
@@ -56,17 +56,17 @@ int unregister_page_fault_notifier(struc
 }
 EXPORT_SYMBOL_GPL(unregister_page_fault_notifier);
 
-static inline int notify_page_fault(enum die_val val, const char *str,
-			struct pt_regs *regs, long err, int trap, int sig)
+static inline int notify_page_fault(struct pt_regs *regs, long err)
 {
 	struct die_args args = {
 		.regs = regs,
-		.str = str,
+		.str = "page fault",
 		.err = err,
-		.trapnr = trap,
-		.signr = sig
+		.trapnr = 14,
+		.signr = SIGSEGV
 	};
-	return atomic_notifier_call_chain(&notify_page_fault_chain, val, &args);
+	return atomic_notifier_call_chain(&notify_page_fault_chain,
+	                                  DIE_PAGE_FAULT, &args);
 }
 
 void bust_spinlocks(int yes)
@@ -376,8 +376,7 @@ asmlinkage void __kprobes do_page_fault(
 			if (vmalloc_fault(address) >= 0)
 				return;
 		}
-		if (notify_page_fault(DIE_PAGE_FAULT, "page fault", regs, error_code, 14,
-						SIGSEGV) == NOTIFY_STOP)
+		if (notify_page_fault(regs, error_code) == NOTIFY_STOP)
 			return;
 		/*
 		 * Don't take the mm semaphore here. If we fixup a prefetch
@@ -386,8 +385,7 @@ asmlinkage void __kprobes do_page_fault(
 		goto bad_area_nosemaphore;
 	}
 
-	if (notify_page_fault(DIE_PAGE_FAULT, "page fault", regs, error_code, 14,
-					SIGSEGV) == NOTIFY_STOP)
+	if (notify_page_fault(regs, error_code) == NOTIFY_STOP)
 		return;
 
 	if (likely(regs->eflags & X86_EFLAGS_IF))
_

Patches currently in -mm which might be from jbeulich@novell.com are

intel-rng-workarounds.patch
fix-hwrng-built-in-initcalls-priority.patch
ia64-swiotlb-bug-fixes.patch
ia64-make-swiotlb-use-bus_to_virt-virt_to_bus.patch
ia64-swiotlb-cleanup.patch
ia64-swiotlb-abstraction-eg-for-xen.patch
ia64-missing-exports-hwsw_sync_.patch
ia64-enable-swiotlb-only-when-needed.patch
i386-adjustments-to-page-table-dump-during-oops.patch
