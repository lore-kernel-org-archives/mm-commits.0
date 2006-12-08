From: akpm@osdl.org
Subject: - generic-bug-for-i386.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:00:46 -0800
Message-ID: <200612082000.kB8K0kLm001781@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57110 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426261AbWLHUDL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:03:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, ak@muc.de, benh@kernel.crashing.org, hugh@veritas.com, michael@ellerman.id.au, paulus@samba.org, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Generic BUG for i386
has been removed from the -mm tree.  Its filename was
     generic-bug-for-i386.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Generic BUG for i386
From: Jeremy Fitzhardinge <jeremy@goop.org>

This makes i386 use the generic BUG machinery.  There are no functional
changes from the old i386 implementation.

The main advantage in using the generic BUG machinery for i386 is that the
inlined overhead of BUG is just the ud2a instruction; the file+line(+function)
information are no longer inlined into the instruction stream.  This reduces
cache pollution, and makes disassembly work properly.

Signed-off-by: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>
Cc: Hugh Dickens <hugh@veritas.com>
Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/Kconfig              |    5 +++
 arch/i386/kernel/module.c      |    4 ++-
 arch/i386/kernel/traps.c       |   41 ++++++++-----------------------
 arch/i386/kernel/vmlinux.lds.S |    2 +
 include/asm-i386/bug.h         |   28 +++++++++++++++------
 lib/Kconfig.debug              |    2 -
 6 files changed, 42 insertions(+), 40 deletions(-)

diff -puN arch/i386/Kconfig~generic-bug-for-i386 arch/i386/Kconfig
--- a/arch/i386/Kconfig~generic-bug-for-i386
+++ a/arch/i386/Kconfig
@@ -49,6 +49,11 @@ config GENERIC_IOMAP
 	bool
 	default y
 
+config GENERIC_BUG
+	bool
+	default y
+	depends on BUG
+
 config GENERIC_HWEIGHT
 	bool
 	default y
diff -puN arch/i386/kernel/module.c~generic-bug-for-i386 arch/i386/kernel/module.c
--- a/arch/i386/kernel/module.c~generic-bug-for-i386
+++ a/arch/i386/kernel/module.c
@@ -21,6 +21,7 @@
 #include <linux/fs.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
+#include <linux/bug.h>
 
 #if 0
 #define DEBUGP printk
@@ -141,10 +142,11 @@ int module_finalize(const Elf_Ehdr *hdr,
 		apply_paravirt(pseg, pseg + para->sh_size);
 	}
 
-	return 0;
+	return module_bug_finalize(hdr, sechdrs, me);
 }
 
 void module_arch_cleanup(struct module *mod)
 {
 	alternatives_smp_module_del(mod);
+	module_bug_cleanup(mod);
 }
diff -puN arch/i386/kernel/traps.c~generic-bug-for-i386 arch/i386/kernel/traps.c
--- a/arch/i386/kernel/traps.c~generic-bug-for-i386
+++ a/arch/i386/kernel/traps.c
@@ -30,6 +30,7 @@
 #include <linux/unwind.h>
 #include <linux/uaccess.h>
 #include <linux/nmi.h>
+#include <linux/bug.h>
 
 #ifdef CONFIG_EISA
 #include <linux/ioport.h>
@@ -420,43 +421,22 @@ void show_registers(struct pt_regs *regs
 	printk("\n");
 }	
 
-static void handle_BUG(struct pt_regs *regs)
+int is_valid_bugaddr(unsigned long eip)
 {
-	unsigned long eip = regs->eip;
 	unsigned short ud2;
 
 	if (eip < PAGE_OFFSET)
-		return;
+		return 0;
 	if (probe_kernel_address((unsigned short *)eip, ud2))
-		return;
-	if (ud2 != 0x0b0f)
-		return;
-
-	printk(KERN_EMERG "------------[ cut here ]------------\n");
-
-#ifdef CONFIG_DEBUG_BUGVERBOSE
-	do {
-		unsigned short line;
-		char *file;
-		char c;
-
-		if (probe_kernel_address((unsigned short *)(eip + 2), line))
-			break;
-		if (probe_kernel_address((char **)(eip + 4), file) ||
-		    (unsigned long)file < PAGE_OFFSET ||
-			probe_kernel_address(file, c))
-			file = "<bad filename>";
+		return 0;
 
-		printk(KERN_EMERG "kernel BUG at %s:%d!\n", file, line);
-		return;
-	} while (0);
-#endif
-	printk(KERN_EMERG "Kernel BUG at [verbose debug info unavailable]\n");
+	return ud2 == 0x0b0f;
 }
 
-/* This is gone through when something in the kernel
- * has done something bad and is about to be terminated.
-*/
+/*
+ * This is gone through when something in the kernel has done something bad and
+ * is about to be terminated.
+ */
 void die(const char * str, struct pt_regs * regs, long err)
 {
 	static struct {
@@ -488,7 +468,8 @@ void die(const char * str, struct pt_reg
 		unsigned long esp;
 		unsigned short ss;
 
-		handle_BUG(regs);
+		report_bug(regs->eip);
+
 		printk(KERN_EMERG "%s: %04lx [#%d]\n", str, err & 0xffff, ++die_counter);
 #ifdef CONFIG_PREEMPT
 		printk(KERN_EMERG "PREEMPT ");
diff -puN arch/i386/kernel/vmlinux.lds.S~generic-bug-for-i386 arch/i386/kernel/vmlinux.lds.S
--- a/arch/i386/kernel/vmlinux.lds.S~generic-bug-for-i386
+++ a/arch/i386/kernel/vmlinux.lds.S
@@ -57,6 +57,8 @@ SECTIONS
 
   RODATA
 
+  BUG_TABLE
+
   . = ALIGN(4);
   .tracedata : AT(ADDR(.tracedata) - LOAD_OFFSET) {
   	__tracedata_start = .;
diff -puN include/asm-i386/bug.h~generic-bug-for-i386 include/asm-i386/bug.h
--- a/include/asm-i386/bug.h~generic-bug-for-i386
+++ a/include/asm-i386/bug.h
@@ -4,20 +4,32 @@
 
 /*
  * Tell the user there is some problem.
- * The offending file and line are encoded after the "officially
- * undefined" opcode for parsing in the trap handler.
+ * The offending file and line are encoded encoded in the __bug_table section.
  */
 
 #ifdef CONFIG_BUG
 #define HAVE_ARCH_BUG
+
 #ifdef CONFIG_DEBUG_BUGVERBOSE
-#define BUG()				\
- __asm__ __volatile__(	"ud2\n"		\
-			"\t.word %c0\n"	\
-			"\t.long %c1\n"	\
-			 : : "i" (__LINE__), "i" (__FILE__))
+#define BUG()								\
+	do {								\
+		asm volatile("1:\tud2\n"				\
+			     ".pushsection __bug_table,\"a\"\n"		\
+			     "2:\t.long 1b, %c0\n"			\
+			     "\t.word %c1, 0\n"				\
+			     "\t.org 2b+%c2\n"				\
+			     ".popsection"				\
+			     : : "i" (__FILE__), "i" (__LINE__),	\
+			     "i" (sizeof(struct bug_entry)));		\
+		for(;;) ;						\
+	} while(0)
+
 #else
-#define BUG() __asm__ __volatile__("ud2\n")
+#define BUG()								\
+	do {								\
+		asm volatile("ud2");					\
+		for(;;) ;						\
+	} while(0)
 #endif
 #endif
 
diff -puN lib/Kconfig.debug~generic-bug-for-i386 lib/Kconfig.debug
--- a/lib/Kconfig.debug~generic-bug-for-i386
+++ a/lib/Kconfig.debug
@@ -285,7 +285,7 @@ config DEBUG_HIGHMEM
 config DEBUG_BUGVERBOSE
 	bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL && EMBEDDED
 	depends on BUG
-	depends on ARM || ARM26 || AVR32 || M32R || M68K || SPARC32 || SPARC64 || X86_32 || FRV || SUPERH || GENERIC_BUG
+	depends on ARM || ARM26 || AVR32 || M32R || M68K || SPARC32 || SPARC64 || FRV || SUPERH || GENERIC_BUG
 	default !EMBEDDED
 	help
 	  Say Y here to make BUG() panics output the file name and line number
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
generic-bug-for-i386.patch
generic-bug-for-x86-64.patch
uml-add-generic-bug-support.patch
use-generic-bug-for-ppc.patch
fix-generic-warn_on-message.patch
convert-i386-pda-code-to-use-%fs.patch
time-uninline-jiffiesh-fix.patch

