From: akpm@linux-foundation.org
Subject: - i386-gdt-cleanups-rename-boot_gdt_table-to-boot_gdt.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:39:16 -0700
Message-ID: <200703292339.l2TNdG8A015419@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43202 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945943AbXC2Xj1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:39:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sebastien.dugue@bull.net, ak@suse.de, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     i386 GDT cleanups: Rename boot_gdt_table to boot_gdt
has been removed from the -mm tree.  Its filename was
     i386-gdt-cleanups-rename-boot_gdt_table-to-boot_gdt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386 GDT cleanups: Rename boot_gdt_table to boot_gdt
From: Sebastien Dugue <sebastien.dugue@bull.net>

Rename boot_gdt_table to boot_gdt to avoid the duplicate T(able).

Signed-off-by: Sebastien Dugue <sebastien.dugue@bull.net>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/head.S       |    9 ++++-----
 arch/i386/kernel/trampoline.S |   12 ++++++------
 2 files changed, 10 insertions(+), 11 deletions(-)

diff -puN arch/i386/kernel/head.S~i386-gdt-cleanups-rename-boot_gdt_table-to-boot_gdt arch/i386/kernel/head.S
--- a/arch/i386/kernel/head.S~i386-gdt-cleanups-rename-boot_gdt_table-to-boot_gdt
+++ a/arch/i386/kernel/head.S
@@ -147,8 +147,7 @@ page_pde_offset = (__PAGE_OFFSET >> 20);
 /*
  * Non-boot CPU entry point; entered from trampoline.S
  * We can't lgdt here, because lgdt itself uses a data segment, but
- * we know the trampoline has already loaded the boot_gdt_table GDT
- * for us.
+ * we know the trampoline has already loaded the boot_gdt for us.
  *
  * If cpu hotplug is not supported then this code can go in init section
  * which will be freed later
@@ -588,7 +587,7 @@ fault_msg:
 	.word 0				# 32 bit align gdt_desc.address
 boot_gdt_descr:
 	.word __BOOT_DS+7
-	.long boot_gdt_table - __PAGE_OFFSET
+	.long boot_gdt - __PAGE_OFFSET
 
 	.word 0				# 32-bit align idt_desc.address
 idt_descr:
@@ -602,11 +601,11 @@ ENTRY(early_gdt_descr)
 	.long per_cpu__cpu_gdt		/* Overwritten for secondary CPUs */
 
 /*
- * The boot_gdt_table must mirror the equivalent in setup.S and is
+ * The boot_gdt must mirror the equivalent in setup.S and is
  * used only for booting.
  */
 	.align L1_CACHE_BYTES
-ENTRY(boot_gdt_table)
+ENTRY(boot_gdt)
 	.fill GDT_ENTRY_BOOT_CS,8,0
 	.quad 0x00cf9a000000ffff	/* kernel 4GB code at 0x00000000 */
 	.quad 0x00cf92000000ffff	/* kernel 4GB data at 0x00000000 */
diff -puN arch/i386/kernel/trampoline.S~i386-gdt-cleanups-rename-boot_gdt_table-to-boot_gdt arch/i386/kernel/trampoline.S
--- a/arch/i386/kernel/trampoline.S~i386-gdt-cleanups-rename-boot_gdt_table-to-boot_gdt
+++ a/arch/i386/kernel/trampoline.S
@@ -29,7 +29,7 @@
  *
  *	TYPE              VALUE
  *	R_386_32          startup_32_smp
- *	R_386_32          boot_gdt_table
+ *	R_386_32          boot_gdt
  */
 
 #include <linux/linkage.h>
@@ -62,8 +62,8 @@ r_base = .
 	 * to 32 bit.
 	 */
 
-	lidtl	boot_idt - r_base	# load idt with 0, 0
-	lgdtl	boot_gdt - r_base	# load gdt with whatever is appropriate
+	lidtl	boot_idt_descr - r_base	# load idt with 0, 0
+	lgdtl	boot_gdt_descr - r_base	# load gdt with whatever is appropriate
 
 	xor	%ax, %ax
 	inc	%ax		# protected mode (PE) bit
@@ -73,11 +73,11 @@ r_base = .
 
 	# These need to be in the same 64K segment as the above;
 	# hence we don't use the boot_gdt_descr defined in head.S
-boot_gdt:
+boot_gdt_descr:
 	.word	__BOOT_DS + 7			# gdt limit
-	.long	boot_gdt_table-__PAGE_OFFSET	# gdt base
+	.long	boot_gdt - __PAGE_OFFSET	# gdt base
 
-boot_idt:
+boot_idt_descr:
 	.word	0				# idt limit = 0
 	.long	0				# idt base = 0L
 
_

Patches currently in -mm which might be from sebastien.dugue@bull.net are

futex-priority-based-wakeup.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix-2.patch
sys_futex64-allows-64bit-futexes-fix.patch
