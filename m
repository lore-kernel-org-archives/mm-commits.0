From: akpm@osdl.org
Subject: - generic-bug-for-x86-64.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:00:50 -0800
Message-ID: <200612082000.kB8K0oCE001784@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56851 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426206AbWLHUBl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:01:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, ak@muc.de, benh@kernel.crashing.org, hugh@veritas.com, michael@ellerman.id.au, paulus@samba.org, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Generic BUG for x86-64
has been removed from the -mm tree.  Its filename was
     generic-bug-for-x86-64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Generic BUG for x86-64
From: Jeremy Fitzhardinge <jeremy@goop.org>

This makes x86-64 use the generic BUG machinery.  The most significant

The main advantage in using the generic BUG machinery for x86-64 is that the
inlined overhead of BUG is just the ud2a instruction; the file+line
information are no longer inlined into the instruction stream.  This reduces
cache pollution.

Signed-off-by: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>
Cc: Hugh Dickens <hugh@veritas.com>
Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/Kconfig              |    5 +++
 arch/x86_64/kernel/module.c      |    5 ++-
 arch/x86_64/kernel/traps.c       |   36 +++++++----------------
 arch/x86_64/kernel/vmlinux.lds.S |    2 +
 include/asm-x86_64/bug.h         |   44 ++++++++++++++---------------
 5 files changed, 45 insertions(+), 47 deletions(-)

diff -puN arch/x86_64/Kconfig~generic-bug-for-x86-64 arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~generic-bug-for-x86-64
+++ a/arch/x86_64/Kconfig
@@ -96,6 +96,11 @@ config AUDIT_ARCH
 	bool
 	default y
 
+config GENERIC_BUG
+	bool
+	default y
+	depends on BUG
+
 source "init/Kconfig"
 
 
diff -puN arch/x86_64/kernel/module.c~generic-bug-for-x86-64 arch/x86_64/kernel/module.c
--- a/arch/x86_64/kernel/module.c~generic-bug-for-x86-64
+++ a/arch/x86_64/kernel/module.c
@@ -23,6 +23,7 @@
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
+#include <linux/bug.h>
 
 #include <asm/system.h>
 #include <asm/page.h>
@@ -173,10 +174,12 @@ int module_finalize(const Elf_Ehdr *hdr,
 					    lseg, lseg + locks->sh_size,
 					    tseg, tseg + text->sh_size);
 	}
-	return 0;
+
+	return module_bug_finalize(hdr, sechdrs, me);
 }
 
 void module_arch_cleanup(struct module *mod)
 {
 	alternatives_smp_module_del(mod);
+	module_bug_cleanup(mod);
 }
diff -puN arch/x86_64/kernel/traps.c~generic-bug-for-x86-64 arch/x86_64/kernel/traps.c
--- a/arch/x86_64/kernel/traps.c~generic-bug-for-x86-64
+++ a/arch/x86_64/kernel/traps.c
@@ -31,6 +31,7 @@
 #include <linux/kexec.h>
 #include <linux/unwind.h>
 #include <linux/uaccess.h>
+#include <linux/bug.h>
 
 #include <asm/system.h>
 #include <asm/io.h>
@@ -524,30 +525,15 @@ bad:
 	printk("\n");
 }	
 
-void handle_BUG(struct pt_regs *regs)
-{ 
-	struct bug_frame f;
-	long len;
-	const char *prefix = "";
+int is_valid_bugaddr(unsigned long rip)
+{
+	unsigned short ud2;
 
-	if (user_mode(regs))
-		return; 
-	if (__copy_from_user(&f, (const void __user *) regs->rip,
-			     sizeof(struct bug_frame)))
-		return; 
-	if (f.filename >= 0 ||
-	    f.ud2[0] != 0x0f || f.ud2[1] != 0x0b) 
-		return;
-	len = __strnlen_user((char *)(long)f.filename, PATH_MAX) - 1;
-	if (len < 0 || len >= PATH_MAX)
-		f.filename = (int)(long)"unmapped filename";
-	else if (len > 50) {
-		f.filename += len - 50;
-		prefix = "...";
-	}
-	printk("----------- [cut here ] --------- [please bite here ] ---------\n");
-	printk(KERN_ALERT "Kernel BUG at %s%.50s:%d\n", prefix, (char *)(long)f.filename, f.line);
-} 
+	if (__copy_from_user(&ud2, (const void __user *) rip, sizeof(ud2)))
+		return 0;
+
+	return ud2 == 0x0b0f;
+}
 
 #ifdef CONFIG_BUG
 void out_of_line_bug(void)
@@ -627,7 +613,9 @@ void die(const char * str, struct pt_reg
 {
 	unsigned long flags = oops_begin();
 
-	handle_BUG(regs);
+	if (!user_mode(regs))
+		report_bug(regs->rip);
+
 	__die(str, regs, err);
 	oops_end(flags);
 	do_exit(SIGSEGV); 
diff -puN arch/x86_64/kernel/vmlinux.lds.S~generic-bug-for-x86-64 arch/x86_64/kernel/vmlinux.lds.S
--- a/arch/x86_64/kernel/vmlinux.lds.S~generic-bug-for-x86-64
+++ a/arch/x86_64/kernel/vmlinux.lds.S
@@ -51,6 +51,8 @@ SECTIONS
 
   RODATA
 
+  BUG_TABLE
+
   . = ALIGN(PAGE_SIZE);        /* Align data segment to page size boundary */
 				/* Data */
   .data : AT(ADDR(.data) - LOAD_OFFSET) {
diff -puN include/asm-x86_64/bug.h~generic-bug-for-x86-64 include/asm-x86_64/bug.h
--- a/include/asm-x86_64/bug.h~generic-bug-for-x86-64
+++ a/include/asm-x86_64/bug.h
@@ -1,30 +1,30 @@
 #ifndef __ASM_X8664_BUG_H
 #define __ASM_X8664_BUG_H 1
 
-#include <linux/stringify.h>
-
-/*
- * Tell the user there is some problem.  The exception handler decodes 
- * this frame.
- */
-struct bug_frame {
-	unsigned char ud2[2];
-	unsigned char push;
-	signed int filename;
-	unsigned char ret;
-	unsigned short line;
-} __attribute__((packed));
-
 #ifdef CONFIG_BUG
 #define HAVE_ARCH_BUG
-/* We turn the bug frame into valid instructions to not confuse
-   the disassembler. Thanks to Jan Beulich & Suresh Siddha
-   for nice instruction selection.
-   The magic numbers generate mov $64bitimm,%eax ; ret $offset. */
-#define BUG() 								\
-	asm volatile(							\
-	"ud2 ; pushq $%c1 ; ret $%c0" :: 				\
-		     "i"(__LINE__), "i" (__FILE__))
+
+#ifdef CONFIG_DEBUG_BUGVERBOSE
+#define BUG()								\
+	do {								\
+		asm volatile("1:\tud2\n"				\
+			     ".pushsection __bug_table,\"a\"\n"		\
+			     "2:\t.quad 1b, %c0\n"			\
+			     "\t.word %c1, 0\n"				\
+			     "\t.org 2b+%c2\n"				\
+			     ".popsection"				\
+			     : : "i" (__FILE__), "i" (__LINE__),	\
+			        "i" (sizeof(struct bug_entry)));	\
+		for(;;) ;						\
+	} while(0)
+#else
+#define BUG()								\
+	do {								\
+		asm volatile("ud2");					\
+		for(;;) ;						\
+	} while(0)
+#endif
+
 void out_of_line_bug(void);
 #else
 static inline void out_of_line_bug(void) { }
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
generic-bug-for-x86-64.patch
uml-add-generic-bug-support.patch
use-generic-bug-for-ppc.patch
fix-generic-warn_on-message.patch
convert-i386-pda-code-to-use-%fs.patch
time-uninline-jiffiesh-fix.patch

