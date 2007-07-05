From: akpm@linux-foundation.org
Subject: + f00f-bug-fixup-for-i386-use-immediate-values.patch added to -mm tree
Date: Thu, 05 Jul 2007 13:22:07 -0700
Message-ID: <200707052022.l65KM780017128@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42989 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759857AbXGEUWT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 16:22:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca


The patch titled
     F00F bug fixup for i386: use immediate values
has been added to the -mm tree.  Its filename is
     f00f-bug-fixup-for-i386-use-immediate-values.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: F00F bug fixup for i386: use immediate values
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Use the faster immediate values for F00F bug handling in do_page_fault.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/traps.c     |    4 ++++
 arch/i386/mm/fault.c         |    3 ++-
 include/asm-i386/processor.h |    3 +++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff -puN arch/i386/kernel/traps.c~f00f-bug-fixup-for-i386-use-immediate-values arch/i386/kernel/traps.c
--- a/arch/i386/kernel/traps.c~f00f-bug-fixup-for-i386-use-immediate-values
+++ a/arch/i386/kernel/traps.c
@@ -31,6 +31,7 @@
 #include <linux/uaccess.h>
 #include <linux/nmi.h>
 #include <linux/bug.h>
+#include <linux/immediate.h>
 
 #ifdef CONFIG_EISA
 #include <linux/ioport.h>
@@ -1145,6 +1146,8 @@ asmlinkage void math_emulate(long arg)
 #endif /* CONFIG_MATH_EMULATION */
 
 #ifdef CONFIG_X86_F00F_BUG
+immediate_t __read_mostly f00f_bug_fix;
+
 void __init trap_init_f00f_bug(void)
 {
 	__set_fixmap(FIX_F00F_IDT, __pa(&idt_table), PAGE_KERNEL_RO);
@@ -1155,6 +1158,7 @@ void __init trap_init_f00f_bug(void)
 	 */
 	idt_descr.address = fix_to_virt(FIX_F00F_IDT);
 	load_idt(&idt_descr);
+	immediate_arm(&f00f_bug_fix);
 }
 #endif
 
diff -puN arch/i386/mm/fault.c~f00f-bug-fixup-for-i386-use-immediate-values arch/i386/mm/fault.c
--- a/arch/i386/mm/fault.c~f00f-bug-fixup-for-i386-use-immediate-values
+++ a/arch/i386/mm/fault.c
@@ -25,6 +25,7 @@
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
 #include <linux/kdebug.h>
+#include <linux/immediate.h>
 
 #include <asm/system.h>
 #include <asm/desc.h>
@@ -492,7 +493,7 @@ bad_area_nosemaphore:
 	/*
 	 * Pentium F0 0F C7 C8 bug workaround.
 	 */
-	if (boot_cpu_data.f00f_bug) {
+	if (unlikely(immediate(f00f_bug_fix))) {
 		unsigned long nr;
 		
 		nr = (address - idt_descr.address) >> 3;
diff -puN include/asm-i386/processor.h~f00f-bug-fixup-for-i386-use-immediate-values include/asm-i386/processor.h
--- a/include/asm-i386/processor.h~f00f-bug-fixup-for-i386-use-immediate-values
+++ a/include/asm-i386/processor.h
@@ -21,6 +21,7 @@
 #include <asm/percpu.h>
 #include <linux/cpumask.h>
 #include <linux/init.h>
+#include <linux/immediate.h>
 #include <asm/processor-flags.h>
 
 /* flag for disabling the tsc */
@@ -102,6 +103,8 @@ extern struct cpuinfo_x86 new_cpu_data;
 extern struct tss_struct doublefault_tss;
 DECLARE_PER_CPU(struct tss_struct, init_tss);
 
+extern immediate_t __read_mostly f00f_bug_fix;
+
 #ifdef CONFIG_SMP
 extern struct cpuinfo_x86 cpu_data[];
 #define current_cpu_data cpu_data[smp_processor_id()]
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

powerpc-promc-remove-undef-printk.patch
i386-text-edit-lock.patch
i386-text-edit-lock-alternative-instructions.patch
i386-text-edit-lock-kprobes.patch
immediate-values-global-modules-list-and-module-mutex.patch
immediate-value-architecture-independent-code.patch
immediate-values-non-optimized-architectures.patch
immediate-value-add-kconfig-menus.patch
immediate-values-kprobe-header-fix.patch
immediate-value-i386-optimization.patch
immediate-value-powerpc-optimization.patch
immediate-value-documentation.patch
f00f-bug-fixup-for-i386-use-immediate-values.patch
scheduler-profiling-use-immediate-values.patch
