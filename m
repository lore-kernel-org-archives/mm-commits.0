From: akpm@linux-foundation.org
Subject: - cleanup-rename-cpu_gdt_descr-and-remove-extern.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:52:14 -0800
Message-ID: <200702150852.l1F8qEds025354@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40398 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965578AbXBOIwW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:52:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, ak@suse.de, zach@vmware.com, mm-commits@vger.kernel.org


The patch titled
     cleanup: Rename cpu_gdt_descr and remove extern declaration from smpboot.c
has been removed from the -mm tree.  Its filename was
     cleanup-rename-cpu_gdt_descr-and-remove-extern.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cleanup: Rename cpu_gdt_descr and remove extern declaration from smpboot.c
From: Rusty Russell <rusty@rustcorp.com.au>

When I implemented the DECLARE_PER_CPU(var) macros, I was careful that people
couldn't use "var" in a non-percpu context, by prepending percpu__.  I never
considered that this would allow them to overload the same name for a per-cpu
and a non-percpu variable.

It is only one of many horrors in the i386 boot code, but let's rename the
non-perpcu cpu_gdt_descr to early_gdt_descr (not boot_gdt_descr, that's
something else...)

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Zachary Amsden <zach@vmware.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/head.S    |    6 +++---
 arch/i386/kernel/smpboot.c |    1 -
 include/asm-i386/desc.h    |    2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff -puN arch/i386/kernel/head.S~cleanup-rename-cpu_gdt_descr-and-remove-extern arch/i386/kernel/head.S
--- a/arch/i386/kernel/head.S~cleanup-rename-cpu_gdt_descr-and-remove-extern
+++ a/arch/i386/kernel/head.S
@@ -319,7 +319,7 @@ is386:	movl $2,%ecx		# set MP
 
 	call check_x87
 	call setup_pda
-	lgdt cpu_gdt_descr
+	lgdt early_gdt_descr
 	lidt idt_descr
 	ljmp $(__KERNEL_CS),$1f
 1:	movl $(__KERNEL_DS),%eax	# reload all the segment registers
@@ -375,7 +375,7 @@ ENTRY(setup_pda)
 	movl start_pda, %eax
 
 	/* slot the PDA address into the GDT */
-	mov cpu_gdt_descr+2, %ecx
+	mov early_gdt_descr+2, %ecx
 	mov %ax, (__KERNEL_PDA+0+2)(%ecx)		/* base & 0x0000ffff */
 	shr $16, %eax
 	mov %al, (__KERNEL_PDA+4+0)(%ecx)		/* base & 0x00ff0000 */
@@ -597,7 +597,7 @@ idt_descr:
 
 # boot GDT descriptor (later on used by CPU#0):
 	.word 0				# 32 bit align gdt_desc.address
-ENTRY(cpu_gdt_descr)
+ENTRY(early_gdt_descr)
 	.word GDT_ENTRIES*8-1
 	.long cpu_gdt_table
 
diff -puN arch/i386/kernel/smpboot.c~cleanup-rename-cpu_gdt_descr-and-remove-extern arch/i386/kernel/smpboot.c
--- a/arch/i386/kernel/smpboot.c~cleanup-rename-cpu_gdt_descr-and-remove-extern
+++ a/arch/i386/kernel/smpboot.c
@@ -622,7 +622,6 @@ extern struct {
 	unsigned short ss;
 } stack_start;
 extern struct i386_pda *start_pda;
-extern struct Xgt_desc_struct cpu_gdt_descr;
 
 #ifdef CONFIG_NUMA
 
diff -puN include/asm-i386/desc.h~cleanup-rename-cpu_gdt_descr-and-remove-extern include/asm-i386/desc.h
--- a/include/asm-i386/desc.h~cleanup-rename-cpu_gdt_descr-and-remove-extern
+++ a/include/asm-i386/desc.h
@@ -22,7 +22,7 @@ struct Xgt_desc_struct {
 
 extern struct Xgt_desc_struct idt_descr;
 DECLARE_PER_CPU(struct Xgt_desc_struct, cpu_gdt_descr);
-
+extern struct Xgt_desc_struct early_gdt_descr;
 
 static inline struct desc_struct *get_cpu_gdt_table(unsigned int cpu)
 {
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
git-acpi.patch
cleanup-initialize-esp0-properly-all-the-time.patch
cleanup-make-hvc_consolec-compile-on-non-powerpc.patch
lguest-preparation-export_symbol_gpl-5-functions.patch
lguest-preparation-expose-futex-infrastructure.patch
lguest-kconfig-and-headers.patch
lguest-the-host-code-lgko.patch
lguest-guest-code.patch
lguest-makefile.patch
lguest-trivial-guest-network-driver.patch
lguest-trivial-guest-network-driver-fix.patch
lguest-trivial-guest-console-driver.patch
lguest-trivial-guest-block-driver.patch
lguest-documentatation-and-example-launcher.patch
vmi-versus-hrtimers.patch
