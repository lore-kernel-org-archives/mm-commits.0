From: akpm@linux-foundation.org
Subject: + x86_64-use-descriptors-functions-instead-of-inline-assembly.patch added to -mm tree
Date: Fri, 20 Jul 2007 13:43:34 -0700
Message-ID: <200707202043.l6KKhYmh015542@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49603 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765690AbXGTUoP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 16:44:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gcosta@redhat.com, ak@suse.de


The patch titled
     x86_64: use descriptor's functions instead of inline assembly
has been added to the -mm tree.  Its filename is
     x86_64-use-descriptors-functions-instead-of-inline-assembly.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: use descriptor's functions instead of inline assembly
From: Glauber de Oliveira Costa <gcosta@redhat.com>

This patch provides a new set of functions for managing the descriptor
tables that can be used instead of putting the raw assembly in .c files.

Remodeling of store_tr() suggested by Frederik Deweerdt.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/head64.c  |    2 +-
 arch/x86_64/kernel/reboot.c  |    3 ++-
 arch/x86_64/kernel/setup64.c |    4 ++--
 arch/x86_64/kernel/suspend.c |   11 ++++++-----
 include/asm-x86_64/desc.h    |   29 +++++++++++++++++++++++++++++
 5 files changed, 40 insertions(+), 9 deletions(-)

diff -puN arch/x86_64/kernel/head64.c~x86_64-use-descriptors-functions-instead-of-inline-assembly arch/x86_64/kernel/head64.c
--- a/arch/x86_64/kernel/head64.c~x86_64-use-descriptors-functions-instead-of-inline-assembly
+++ a/arch/x86_64/kernel/head64.c
@@ -61,7 +61,7 @@ void __init x86_64_start_kernel(char * r
 
 	for (i = 0; i < IDT_ENTRIES; i++)
 		set_intr_gate(i, early_idt_handler);
-	asm volatile("lidt %0" :: "m" (idt_descr));
+	load_idt((const struct desc_ptr *)&idt_descr);
 
 	early_printk("Kernel alive\n");
 
diff -puN arch/x86_64/kernel/reboot.c~x86_64-use-descriptors-functions-instead-of-inline-assembly arch/x86_64/kernel/reboot.c
--- a/arch/x86_64/kernel/reboot.c~x86_64-use-descriptors-functions-instead-of-inline-assembly
+++ a/arch/x86_64/kernel/reboot.c
@@ -12,6 +12,7 @@
 #include <acpi/reboot.h>
 #include <asm/io.h>
 #include <asm/delay.h>
+#include <asm/desc.h>
 #include <asm/hw_irq.h>
 #include <asm/system.h>
 #include <asm/pgtable.h>
@@ -140,7 +141,7 @@ void machine_emergency_restart(void)
 		}
 
 		case BOOT_TRIPLE: 
-			__asm__ __volatile__("lidt (%0)": :"r" (&no_idt));
+			load_idt((const struct desc_ptr *)&no_idt);
 			__asm__ __volatile__("int3");
 
 			reboot_type = BOOT_KBD;
diff -puN arch/x86_64/kernel/setup64.c~x86_64-use-descriptors-functions-instead-of-inline-assembly arch/x86_64/kernel/setup64.c
--- a/arch/x86_64/kernel/setup64.c~x86_64-use-descriptors-functions-instead-of-inline-assembly
+++ a/arch/x86_64/kernel/setup64.c
@@ -224,8 +224,8 @@ void __cpuinit cpu_init (void)
  		memcpy(cpu_gdt(cpu), cpu_gdt_table, GDT_SIZE);
 
 	cpu_gdt_descr[cpu].size = GDT_SIZE;
-	asm volatile("lgdt %0" :: "m" (cpu_gdt_descr[cpu]));
-	asm volatile("lidt %0" :: "m" (idt_descr));
+	load_gdt((const struct desc_ptr *)&cpu_gdt_descr[cpu]);
+	load_idt((const struct desc_ptr *)&idt_descr);
 
 	memset(me->thread.tls_array, 0, GDT_ENTRY_TLS_ENTRIES * 8);
 	syscall_init();
diff -puN arch/x86_64/kernel/suspend.c~x86_64-use-descriptors-functions-instead-of-inline-assembly arch/x86_64/kernel/suspend.c
--- a/arch/x86_64/kernel/suspend.c~x86_64-use-descriptors-functions-instead-of-inline-assembly
+++ a/arch/x86_64/kernel/suspend.c
@@ -32,9 +32,9 @@ void __save_processor_state(struct saved
 	/*
 	 * descriptor tables
 	 */
-	asm volatile ("sgdt %0" : "=m" (ctxt->gdt_limit));
-	asm volatile ("sidt %0" : "=m" (ctxt->idt_limit));
-	asm volatile ("str %0"  : "=m" (ctxt->tr));
+	store_gdt((struct desc_ptr *)&ctxt->gdt_limit);
+	store_idt((struct desc_ptr *)&ctxt->idt_limit);
+	store_tr(ctxt->tr);
 
 	/* XMM0..XMM15 should be handled by kernel_fpu_begin(). */
 	/*
@@ -91,8 +91,9 @@ void __restore_processor_state(struct sa
 	 * now restore the descriptor tables to their proper values
 	 * ltr is done i fix_processor_context().
 	 */
-	asm volatile ("lgdt %0" :: "m" (ctxt->gdt_limit));
-	asm volatile ("lidt %0" :: "m" (ctxt->idt_limit));
+	load_gdt((const struct desc_ptr *)&ctxt->gdt_limit);
+	load_idt((const struct desc_ptr *)&ctxt->idt_limit);
+	
 
 	/*
 	 * segment registers
diff -puN include/asm-x86_64/desc.h~x86_64-use-descriptors-functions-instead-of-inline-assembly include/asm-x86_64/desc.h
--- a/include/asm-x86_64/desc.h~x86_64-use-descriptors-functions-instead-of-inline-assembly
+++ a/include/asm-x86_64/desc.h
@@ -20,6 +20,15 @@ extern struct desc_struct cpu_gdt_table[
 #define load_LDT_desc() asm volatile("lldt %w0"::"r" (GDT_ENTRY_LDT*8))
 #define clear_LDT()  asm volatile("lldt %w0"::"r" (0))
 
+static inline unsigned long __store_tr(void)
+{
+       unsigned long tr;
+       asm volatile ("str %w0":"=r" (tr));
+       return tr;
+}
+
+#define store_tr(tr) (tr) = __store_tr()
+
 /*
  * This is the ldt that every process will get unless we need
  * something other than this.
@@ -31,6 +40,16 @@ extern struct desc_ptr cpu_gdt_descr[];
 /* the cpu gdt accessor */
 #define cpu_gdt(_cpu) ((struct desc_struct *)cpu_gdt_descr[_cpu].address)
 
+static inline void load_gdt(const struct desc_ptr *ptr)
+{
+	asm volatile("lgdt %w0"::"m" (*ptr));
+}
+
+static inline void store_gdt(struct desc_ptr *ptr)
+{
+       asm ("sgdt %w0":"=m" (*ptr));
+}
+
 static inline void _set_gate(void *adr, unsigned type, unsigned long func, unsigned dpl, unsigned ist)  
 {
 	struct gate_struct s; 	
@@ -71,6 +90,16 @@ static inline void set_system_gate_ist(i
 	_set_gate(&idt_table[nr], GATE_INTERRUPT, (unsigned long) func, 3, ist);
 }
 
+static inline void load_idt(const struct desc_ptr *ptr)
+{
+	asm volatile("lidt %w0"::"m" (*ptr));
+}
+
+static inline void store_idt(struct desc_ptr *dtr)
+{
+       asm ("sidt %w0":"=m" (*dtr));
+}
+
 static inline void set_tssldt_descriptor(void *ptr, unsigned long tss, unsigned type, 
 					 unsigned size) 
 { 
_

Patches currently in -mm which might be from gcosta@redhat.com are

x86_64-use-wbinvd-macro-instead-of-raw-inline-assembly-in-c-files.patch
x86_64-use-descriptors-functions-instead-of-inline-assembly.patch
