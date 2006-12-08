From: akpm@osdl.org
Subject: - use-generic-bug-for-ppc.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:00:56 -0800
Message-ID: <200612082000.kB8K0utx001792@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56708 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426226AbWLHUBJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:01:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: judith@osdl.org, benh@kernel.crashing.org, jeremy@goop.org, michael@ellerman.id.au, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     use generic BUG for ppc
has been removed from the -mm tree.  Its filename was
     use-generic-bug-for-ppc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: use generic BUG for ppc
From: Judith Lebzelter <judith@osdl.org>

Switch ppc over to using the generic BUG implementation.

Signed-off-by: Judith Lebzelter <judith@osdl.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/ppc/Kconfig        |    5 ++
 arch/ppc/kernel/traps.c |   64 +++-----------------------------------
 2 files changed, 11 insertions(+), 58 deletions(-)

diff -puN arch/ppc/Kconfig~use-generic-bug-for-ppc arch/ppc/Kconfig
--- a/arch/ppc/Kconfig~use-generic-bug-for-ppc
+++ a/arch/ppc/Kconfig
@@ -52,6 +52,11 @@ config ARCH_MAY_HAVE_PC_FDC
 	bool
 	default y
 
+config GENERIC_BUG
+	bool
+	default y
+	depends on BUG
+
 source "init/Kconfig"
 
 menu "Processor"
diff -puN arch/ppc/kernel/traps.c~use-generic-bug-for-ppc arch/ppc/kernel/traps.c
--- a/arch/ppc/kernel/traps.c~use-generic-bug-for-ppc
+++ a/arch/ppc/kernel/traps.c
@@ -28,6 +28,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/prctl.h>
+#include <linux/bug.h>
 
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
@@ -559,64 +560,9 @@ static void emulate_single_step(struct p
 	}
 }
 
-/*
- * Look through the list of trap instructions that are used for BUG(),
- * BUG_ON() and WARN_ON() and see if we hit one.  At this point we know
- * that the exception was caused by a trap instruction of some kind.
- * Returns 1 if we should continue (i.e. it was a WARN_ON) or 0
- * otherwise.
- */
-extern struct bug_entry __start___bug_table[], __stop___bug_table[];
-
-#ifndef CONFIG_MODULES
-#define module_find_bug(x)	NULL
-#endif
-
-struct bug_entry *find_bug(unsigned long bugaddr)
-{
-	struct bug_entry *bug;
-
-	for (bug = __start___bug_table; bug < __stop___bug_table; ++bug)
-		if (bugaddr == bug->bug_addr)
-			return bug;
-	return module_find_bug(bugaddr);
-}
-
-int check_bug_trap(struct pt_regs *regs)
+int is_valid_bugaddr(unsigned long addr)
 {
-	struct bug_entry *bug;
-	unsigned long addr;
-
-	if (regs->msr & MSR_PR)
-		return 0;	/* not in kernel */
-	addr = regs->nip;	/* address of trap instruction */
-	if (addr < PAGE_OFFSET)
-		return 0;
-	bug = find_bug(regs->nip);
-	if (bug == NULL)
-		return 0;
-	if (bug->line & BUG_WARNING_TRAP) {
-		/* this is a WARN_ON rather than BUG/BUG_ON */
-#ifdef CONFIG_XMON
-		xmon_printf(KERN_ERR "Badness in %s at %s:%ld\n",
-		       bug->function, bug->file,
-		       bug->line & ~BUG_WARNING_TRAP);
-#endif /* CONFIG_XMON */		
-		printk(KERN_ERR "Badness in %s at %s:%ld\n",
-		       bug->function, bug->file,
-		       bug->line & ~BUG_WARNING_TRAP);
-		dump_stack();
-		return 1;
-	}
-#ifdef CONFIG_XMON
-	xmon_printf(KERN_CRIT "kernel BUG in %s at %s:%ld!\n",
-	       bug->function, bug->file, bug->line);
-	xmon(regs);
-#endif /* CONFIG_XMON */
-	printk(KERN_CRIT "kernel BUG in %s at %s:%ld!\n",
-	       bug->function, bug->file, bug->line);
-
-	return 0;
+	return addr >= PAGE_OFFSET;
 }
 
 void program_check_exception(struct pt_regs *regs)
@@ -671,7 +617,9 @@ void program_check_exception(struct pt_r
 		/* trap exception */
 		if (debugger_bpt(regs))
 			return;
-		if (check_bug_trap(regs)) {
+
+		if (!(regs->msr & MSR_PR) &&  /* not user-mode */
+		    report_bug(regs->nip) == BUG_TRAP_TYPE_WARN) {
 			regs->nip += 4;
 			return;
 		}
_

Patches currently in -mm which might be from judith@osdl.org are

use-generic-bug-for-ppc.patch
powerpc-iseries-link-error-in-allmodconfig.patch

