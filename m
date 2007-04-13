From: akpm@linux-foundation.org
Subject: - i386-clean-up-asm-i386-bugsh.patch removed from -mm tree
Date: Fri, 13 Apr 2007 16:30:48 -0700
Message-ID: <200704132330.l3DNUm30012775@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60733 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161264AbXDMXaz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 19:30:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, ak@suse.de, jeremy@xensource.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     i386: clean up asm-i386/bugs.h
has been removed from the -mm tree.  Its filename was
     i386-clean-up-asm-i386-bugsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: clean up asm-i386/bugs.h
From: Jeremy Fitzhardinge <jeremy@goop.org>

Most of asm-i386/bugs.h is code which should be in a C file, so put it there.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/Makefile  |    2 
 arch/i386/kernel/cpu/bugs.c    |  191 ++++++++++++++++++++++++++++++
 include/asm-i386/alternative.h |    1 
 include/asm-i386/bugs.h        |  194 -------------------------------
 4 files changed, 197 insertions(+), 191 deletions(-)

diff -puN arch/i386/kernel/cpu/Makefile~i386-clean-up-asm-i386-bugsh arch/i386/kernel/cpu/Makefile
--- a/arch/i386/kernel/cpu/Makefile~i386-clean-up-asm-i386-bugsh
+++ a/arch/i386/kernel/cpu/Makefile
@@ -2,7 +2,7 @@
 # Makefile for x86-compatible CPU details and quirks
 #
 
-obj-y	:=	common.o proc.o
+obj-y	:=	common.o proc.o bugs.o
 
 obj-y	+=	amd.o
 obj-y	+=	cyrix.o
diff -puN /dev/null arch/i386/kernel/cpu/bugs.c
--- /dev/null
+++ a/arch/i386/kernel/cpu/bugs.c
@@ -0,0 +1,191 @@
+/*
+ *  arch/i386/cpu/bugs.c
+ *
+ *  Copyright (C) 1994  Linus Torvalds
+ *
+ *  Cyrix stuff, June 1998 by:
+ *	- Rafael R. Reilova (moved everything from head.S),
+ *        <rreilova@ececs.uc.edu>
+ *	- Channing Corn (tests & fixes),
+ *	- Andrew D. Balsa (code cleanup).
+ */
+#include <linux/init.h>
+#include <linux/utsname.h>
+#include <asm/processor.h>
+#include <asm/i387.h>
+#include <asm/msr.h>
+#include <asm/paravirt.h>
+#include <asm/alternative.h>
+
+static int __init no_halt(char *s)
+{
+	boot_cpu_data.hlt_works_ok = 0;
+	return 1;
+}
+
+__setup("no-hlt", no_halt);
+
+static int __init mca_pentium(char *s)
+{
+	mca_pentium_flag = 1;
+	return 1;
+}
+
+__setup("mca-pentium", mca_pentium);
+
+static int __init no_387(char *s)
+{
+	boot_cpu_data.hard_math = 0;
+	write_cr0(0xE | read_cr0());
+	return 1;
+}
+
+__setup("no387", no_387);
+
+static double __initdata x = 4195835.0;
+static double __initdata y = 3145727.0;
+
+/*
+ * This used to check for exceptions..
+ * However, it turns out that to support that,
+ * the XMM trap handlers basically had to
+ * be buggy. So let's have a correct XMM trap
+ * handler, and forget about printing out
+ * some status at boot.
+ *
+ * We should really only care about bugs here
+ * anyway. Not features.
+ */
+static void __init check_fpu(void)
+{
+	if (!boot_cpu_data.hard_math) {
+#ifndef CONFIG_MATH_EMULATION
+		printk(KERN_EMERG "No coprocessor found and no math emulation present.\n");
+		printk(KERN_EMERG "Giving up.\n");
+		for (;;) ;
+#endif
+		return;
+	}
+
+/* trap_init() enabled FXSR and company _before_ testing for FP problems here. */
+	/* Test for the divl bug.. */
+	__asm__("fninit\n\t"
+		"fldl %1\n\t"
+		"fdivl %2\n\t"
+		"fmull %2\n\t"
+		"fldl %1\n\t"
+		"fsubp %%st,%%st(1)\n\t"
+		"fistpl %0\n\t"
+		"fwait\n\t"
+		"fninit"
+		: "=m" (*&boot_cpu_data.fdiv_bug)
+		: "m" (*&x), "m" (*&y));
+	if (boot_cpu_data.fdiv_bug)
+		printk("Hmm, FPU with FDIV bug.\n");
+}
+
+static void __init check_hlt(void)
+{
+	if (paravirt_enabled())
+		return;
+
+	printk(KERN_INFO "Checking 'hlt' instruction... ");
+	if (!boot_cpu_data.hlt_works_ok) {
+		printk("disabled\n");
+		return;
+	}
+	halt();
+	halt();
+	halt();
+	halt();
+	printk("OK.\n");
+}
+
+/*
+ *	Most 386 processors have a bug where a POPAD can lock the
+ *	machine even from user space.
+ */
+
+static void __init check_popad(void)
+{
+#ifndef CONFIG_X86_POPAD_OK
+	int res, inp = (int) &res;
+
+	printk(KERN_INFO "Checking for popad bug... ");
+	__asm__ __volatile__(
+	  "movl $12345678,%%eax; movl $0,%%edi; pusha; popa; movl (%%edx,%%edi),%%ecx "
+	  : "=&a" (res)
+	  : "d" (inp)
+	  : "ecx", "edi" );
+	/* If this fails, it means that any user program may lock the CPU hard. Too bad. */
+	if (res != 12345678) printk( "Buggy.\n" );
+		        else printk( "OK.\n" );
+#endif
+}
+
+/*
+ * Check whether we are able to run this kernel safely on SMP.
+ *
+ * - In order to run on a i386, we need to be compiled for i386
+ *   (for due to lack of "invlpg" and working WP on a i386)
+ * - In order to run on anything without a TSC, we need to be
+ *   compiled for a i486.
+ * - In order to support the local APIC on a buggy Pentium machine,
+ *   we need to be compiled with CONFIG_X86_GOOD_APIC disabled,
+ *   which happens implicitly if compiled for a Pentium or lower
+ *   (unless an advanced selection of CPU features is used) as an
+ *   otherwise config implies a properly working local APIC without
+ *   the need to do extra reads from the APIC.
+*/
+
+static void __init check_config(void)
+{
+/*
+ * We'd better not be a i386 if we're configured to use some
+ * i486+ only features! (WP works in supervisor mode and the
+ * new "invlpg" and "bswap" instructions)
+ */
+#if defined(CONFIG_X86_WP_WORKS_OK) || defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_BSWAP)
+	if (boot_cpu_data.x86 == 3)
+		panic("Kernel requires i486+ for 'invlpg' and other features");
+#endif
+
+/*
+ * If we configured ourselves for a TSC, we'd better have one!
+ */
+#ifdef CONFIG_X86_TSC
+	if (!cpu_has_tsc && !tsc_disable)
+		panic("Kernel compiled for Pentium+, requires TSC feature!");
+#endif
+
+/*
+ * If we were told we had a good local APIC, check for buggy Pentia,
+ * i.e. all B steppings and the C2 stepping of P54C when using their
+ * integrated APIC (see 11AP erratum in "Pentium Processor
+ * Specification Update").
+ */
+#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_GOOD_APIC)
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL
+	    && cpu_has_apic
+	    && boot_cpu_data.x86 == 5
+	    && boot_cpu_data.x86_model == 2
+	    && (boot_cpu_data.x86_mask < 6 || boot_cpu_data.x86_mask == 11))
+		panic("Kernel compiled for PMMX+, assumes a local APIC without the read-before-write bug!");
+#endif
+}
+
+
+void __init check_bugs(void)
+{
+	identify_boot_cpu();
+#ifndef CONFIG_SMP
+	printk("CPU: ");
+	print_cpu_info(&boot_cpu_data);
+#endif
+	check_config();
+	check_fpu();
+	check_hlt();
+	check_popad();
+	init_utsname()->machine[1] = '0' + (boot_cpu_data.x86 > 6 ? 6 : boot_cpu_data.x86);
+	alternative_instructions();
+}
diff -puN include/asm-i386/alternative.h~i386-clean-up-asm-i386-bugsh include/asm-i386/alternative.h
--- a/include/asm-i386/alternative.h~i386-clean-up-asm-i386-bugsh
+++ a/include/asm-i386/alternative.h
@@ -17,6 +17,7 @@ struct alt_instr {
 	u8  pad[3];
 }  __attribute__ ((packed));
 
+extern void alternative_instructions(void);
 extern void apply_alternatives(struct alt_instr *start, struct alt_instr *end);
 
 struct module;
diff -puN include/asm-i386/bugs.h~i386-clean-up-asm-i386-bugsh include/asm-i386/bugs.h
--- a/include/asm-i386/bugs.h~i386-clean-up-asm-i386-bugsh
+++ a/include/asm-i386/bugs.h
@@ -1,198 +1,12 @@
 /*
- *  include/asm-i386/bugs.h
- *
- *  Copyright (C) 1994  Linus Torvalds
- *
- *  Cyrix stuff, June 1998 by:
- *	- Rafael R. Reilova (moved everything from head.S),
- *        <rreilova@ececs.uc.edu>
- *	- Channing Corn (tests & fixes),
- *	- Andrew D. Balsa (code cleanup).
- */
-
-/*
  * This is included by init/main.c to check for architecture-dependent bugs.
  *
  * Needs:
  *	void check_bugs(void);
  */
+#ifndef _ASM_I386_BUG_H
+#define _ASM_I386_BUG_H
 
-#include <linux/init.h>
-#include <asm/processor.h>
-#include <asm/i387.h>
-#include <asm/msr.h>
-#include <asm/paravirt.h>
-
-static int __init no_halt(char *s)
-{
-	boot_cpu_data.hlt_works_ok = 0;
-	return 1;
-}
-
-__setup("no-hlt", no_halt);
-
-static int __init mca_pentium(char *s)
-{
-	mca_pentium_flag = 1;
-	return 1;
-}
-
-__setup("mca-pentium", mca_pentium);
-
-static int __init no_387(char *s)
-{
-	boot_cpu_data.hard_math = 0;
-	write_cr0(0xE | read_cr0());
-	return 1;
-}
-
-__setup("no387", no_387);
-
-static double __initdata x = 4195835.0;
-static double __initdata y = 3145727.0;
-
-/*
- * This used to check for exceptions.. 
- * However, it turns out that to support that,
- * the XMM trap handlers basically had to
- * be buggy. So let's have a correct XMM trap
- * handler, and forget about printing out
- * some status at boot.
- *
- * We should really only care about bugs here
- * anyway. Not features.
- */
-static void __init check_fpu(void)
-{
-	if (!boot_cpu_data.hard_math) {
-#ifndef CONFIG_MATH_EMULATION
-		printk(KERN_EMERG "No coprocessor found and no math emulation present.\n");
-		printk(KERN_EMERG "Giving up.\n");
-		for (;;) ;
-#endif
-		return;
-	}
-
-/* trap_init() enabled FXSR and company _before_ testing for FP problems here. */
-	/* Test for the divl bug.. */
-	__asm__("fninit\n\t"
-		"fldl %1\n\t"
-		"fdivl %2\n\t"
-		"fmull %2\n\t"
-		"fldl %1\n\t"
-		"fsubp %%st,%%st(1)\n\t"
-		"fistpl %0\n\t"
-		"fwait\n\t"
-		"fninit"
-		: "=m" (*&boot_cpu_data.fdiv_bug)
-		: "m" (*&x), "m" (*&y));
-	if (boot_cpu_data.fdiv_bug)
-		printk("Hmm, FPU with FDIV bug.\n");
-}
-
-static void __init check_hlt(void)
-{
-	if (paravirt_enabled())
-		return;
-
-	printk(KERN_INFO "Checking 'hlt' instruction... ");
-	if (!boot_cpu_data.hlt_works_ok) {
-		printk("disabled\n");
-		return;
-	}
-	halt();
-	halt();
-	halt();
-	halt();
-	printk("OK.\n");
-}
-
-/*
- *	Most 386 processors have a bug where a POPAD can lock the 
- *	machine even from user space.
- */
- 
-static void __init check_popad(void)
-{
-#ifndef CONFIG_X86_POPAD_OK
-	int res, inp = (int) &res;
-
-	printk(KERN_INFO "Checking for popad bug... ");
-	__asm__ __volatile__( 
-	  "movl $12345678,%%eax; movl $0,%%edi; pusha; popa; movl (%%edx,%%edi),%%ecx "
-	  : "=&a" (res)
-	  : "d" (inp)
-	  : "ecx", "edi" );
-	/* If this fails, it means that any user program may lock the CPU hard. Too bad. */
-	if (res != 12345678) printk( "Buggy.\n" );
-		        else printk( "OK.\n" );
-#endif
-}
-
-/*
- * Check whether we are able to run this kernel safely on SMP.
- *
- * - In order to run on a i386, we need to be compiled for i386
- *   (for due to lack of "invlpg" and working WP on a i386)
- * - In order to run on anything without a TSC, we need to be
- *   compiled for a i486.
- * - In order to support the local APIC on a buggy Pentium machine,
- *   we need to be compiled with CONFIG_X86_GOOD_APIC disabled,
- *   which happens implicitly if compiled for a Pentium or lower
- *   (unless an advanced selection of CPU features is used) as an
- *   otherwise config implies a properly working local APIC without
- *   the need to do extra reads from the APIC.
-*/
-
-static void __init check_config(void)
-{
-/*
- * We'd better not be a i386 if we're configured to use some
- * i486+ only features! (WP works in supervisor mode and the
- * new "invlpg" and "bswap" instructions)
- */
-#if defined(CONFIG_X86_WP_WORKS_OK) || defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_BSWAP)
-	if (boot_cpu_data.x86 == 3)
-		panic("Kernel requires i486+ for 'invlpg' and other features");
-#endif
-
-/*
- * If we configured ourselves for a TSC, we'd better have one!
- */
-#ifdef CONFIG_X86_TSC
-	if (!cpu_has_tsc && !tsc_disable)
-		panic("Kernel compiled for Pentium+, requires TSC feature!");
-#endif
-
-/*
- * If we were told we had a good local APIC, check for buggy Pentia,
- * i.e. all B steppings and the C2 stepping of P54C when using their
- * integrated APIC (see 11AP erratum in "Pentium Processor
- * Specification Update").
- */
-#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_GOOD_APIC)
-	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL
-	    && cpu_has_apic
-	    && boot_cpu_data.x86 == 5
-	    && boot_cpu_data.x86_model == 2
-	    && (boot_cpu_data.x86_mask < 6 || boot_cpu_data.x86_mask == 11))
-		panic("Kernel compiled for PMMX+, assumes a local APIC without the read-before-write bug!");
-#endif
-}
-
-extern void alternative_instructions(void);
+extern void __init check_bugs(void);
 
-static void __init check_bugs(void)
-{
-	identify_cpu(&boot_cpu_data);
-#ifndef CONFIG_SMP
-	printk("CPU: ");
-	print_cpu_info(&boot_cpu_data);
-#endif
-	check_config();
-	check_fpu();
-	check_hlt();
-	check_popad();
-	init_utsname()->machine[1] = '0' + (boot_cpu_data.x86 > 6 ? 6 : boot_cpu_data.x86);
-	alternative_instructions(); 
-}
+#endif	/* _ASM_I386_BUG_H */
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
revert-proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621.patch
revert-x86_64-mm-account-for-module-percpu-space-separately-from-kernel-percpu.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others-fix.patch
allow-boot-time-disable-of-paravirt_ops-patching.patch
x86-clean-up-identify_cpu-update.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings.patch
mm-only-i386-for-debugging-make-the-initial-page-table-setup-less-forgiving.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
add-touch_all_softlockup_watchdogs.patch
clean-up-elf-note-generation.patch
deflate-stack-usage-in-lib-inflatec.patch
