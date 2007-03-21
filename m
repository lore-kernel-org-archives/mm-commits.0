From: akpm@linux-foundation.org
Subject: + allow-per-cpu-variables-to-be-page-aligned.patch added to -mm tree
Date: Wed, 21 Mar 2007 15:32:44 -0700
Message-ID: <200703212232.l2LMWifK005560@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56814 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933912AbXCUWdF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Mar 2007 18:33:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, ak@suse.de, mingo@elte.hu


The patch titled
     Allow per-cpu variables to be page-aligned
has been added to the -mm tree.  Its filename is
     allow-per-cpu-variables-to-be-page-aligned.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Allow per-cpu variables to be page-aligned
From: Rusty Russell <rusty@rustcorp.com.au>

Let's allow page-alignment in general for per-cpu data (wanted by Xen, and
Ingo suggested KVM as well).

Because larger alignments can use more room, we increase the max per-cpu
memory to 64k rather than 32k: it's getting a little tight.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/vmlinux.lds.S   |    2 +-
 arch/arm/kernel/vmlinux.lds.S     |    2 +-
 arch/cris/arch-v32/vmlinux.lds.S  |    1 +
 arch/frv/kernel/vmlinux.lds.S     |    1 +
 arch/i386/kernel/vmlinux.lds.S    |    2 +-
 arch/m32r/kernel/vmlinux.lds.S    |    2 +-
 arch/mips/kernel/vmlinux.lds.S    |    2 +-
 arch/parisc/kernel/vmlinux.lds.S  |    2 +-
 arch/powerpc/kernel/setup_64.c    |    4 ++--
 arch/powerpc/kernel/vmlinux.lds.S |    6 +-----
 arch/ppc/kernel/vmlinux.lds.S     |    2 +-
 arch/s390/kernel/vmlinux.lds.S    |    2 +-
 arch/sh/kernel/vmlinux.lds.S      |    2 +-
 arch/sh64/kernel/vmlinux.lds.S    |    2 +-
 arch/sparc/kernel/vmlinux.lds.S   |    2 +-
 arch/sparc64/kernel/smp.c         |    6 +++---
 arch/x86_64/kernel/setup64.c      |    4 ++--
 arch/x86_64/kernel/vmlinux.lds.S  |    2 +-
 arch/xtensa/kernel/vmlinux.lds.S  |    2 +-
 include/linux/percpu.h            |    2 +-
 init/main.c                       |    4 ++--
 kernel/module.c                   |   10 +++++-----
 22 files changed, 31 insertions(+), 33 deletions(-)

diff -puN arch/alpha/kernel/vmlinux.lds.S~allow-per-cpu-variables-to-be-page-aligned arch/alpha/kernel/vmlinux.lds.S
--- a/arch/alpha/kernel/vmlinux.lds.S~allow-per-cpu-variables-to-be-page-aligned
+++ a/arch/alpha/kernel/vmlinux.lds.S
@@ -69,7 +69,7 @@ SECTIONS
   . = ALIGN(8);
   SECURITY_INIT
 
-  . = ALIGN(64);
+  . = ALIGN(8192);
   __per_cpu_start = .;
   .data.percpu : { *(.data.percpu) }
   __per_cpu_end = .;
diff -puN arch/arm/kernel/vmlinux.lds.S~allow-per-cpu-variables-to-be-page-aligned arch/arm/kernel/vmlinux.lds.S
--- a/arch/arm/kernel/vmlinux.lds.S~allow-per-cpu-variables-to-be-page-aligned
+++ a/arch/arm/kernel/vmlinux.lds.S
@@ -59,7 +59,7 @@ SECTIONS
 			usr/built-in.o(.init.ramfs)
 		__initramfs_end = .;
 #endif
-		. = ALIGN(64);
+		. = ALIGN(4096);
 		__per_cpu_start = .;
 			*(.data.percpu)
 		__per_cpu_end = .;
diff -puN arch/cris/arch-v32/vmlinux.lds.S~allow-per-cpu-variables-to-be-page-aligned arch/cris/arch-v32/vmlinux.lds.S
--- a/arch/cris/arch-v32/vmlinux.lds.S~allow-per-cpu-variables-to-be-page-aligned
+++ a/arch/cris/arch-v32/vmlinux.lds.S
@@ -91,6 +91,7 @@ SECTIONS
 	}
 	SECURITY_INIT
 
+	. =  ALIGN (8192);
 	__per_cpu_start = .;
 	.data.percpu  : { *(.data.percpu) }
 	__per_cpu_end = .;
diff -puN arch/frv/kernel/vmlinux.lds.S~allow-per-cpu-variables-to-be-page-aligned arch/frv/kernel/vmlinux.lds.S
--- a/arch/frv/kernel/vmlinux.lds.S~allow-per-cpu-variables-to-be-page-aligned
+++ a/arch/frv/kernel/vmlinux.lds.S
@@ -57,6 +57,7 @@ SECTIONS
   __alt_instructions_end = .;
  .altinstr_replacement : { *(.altinstr_replacement) }
 
+  . = ALIGN(4096);
   __per_cpu_start = .;
   .data.percpu  : { *(.data.percpu) }
   __per_cpu_end = .;
diff -puN arch/i386/kernel/vmlinux.lds.S~allow-per-cpu-variables-to-be-page-aligned arch/i386/kernel/vmlinux.lds.S
--- a/arch/i386/kernel/vmlinux.lds.S~allow-per-cpu-variables-to-be-page-aligned
+++ a/arch/i386/kernel/vmlinux.lds.S
@@ -196,7 +196,7 @@ SECTIONS
 	__initramfs_end = .;
   }
 #endif
-  . = ALIGN(L1_CACHE_BYTES);
+  . = ALIGN(4096);
   .data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {
 	__per_cpu_start = .;
 	*(.data.percpu)
diff -puN arch/m32r/kernel/vmlinux.lds.S~allow-per-cpu-variables-to-be-page-aligned arch/m32r/kernel/vmlinux.lds.S
--- a/arch/m32r/kernel/vmlinux.lds.S~allow-per-cpu-variables-to-be-page-aligned
+++ a/arch/m32r/kernel/vmlinux.lds.S
@@ -110,7 +110,7 @@ SECTIONS
   __initramfs_end = .;
 #endif
 
-  . = ALIGN(32);
+  . = ALIGN(4096);
   __per_cpu_start = .;
   .data.percpu  : { *(.data.percpu) }
   __per_cpu_end = .;
diff -puN arch/mips/kernel/vmlinux.lds.S~allow-per-cpu-variables-to-be-page-aligned arch/mips/kernel/vmlinux.lds.S
--- a/arch/mips/kernel/vmlinux.lds.S~allow-per-cpu-variables-to-be-page-aligned
+++ a/arch/mips/kernel/vmlinux.lds.S
@@ -119,7 +119,7 @@ SECTIONS
   .init.ramfs : { *(.init.ramfs) }
   __initramfs_end = .;
 #endif
-  . = ALIGN(32);
+  . = ALIGN(_PAGE_SIZE);
   __per_cpu_start = .;
   .data.percpu  : { *(.data.percpu) }
   __per_cpu_end = .;
diff -puN arch/parisc/kernel/vmlinux.lds.S~allow-per-cpu-variables-to-be-page-aligned arch/parisc/kernel/vmlinux.lds.S
--- a/arch/parisc/kernel/vmlinux.lds.S~allow-per-cpu-variables-to-be-page-aligned
+++ a/arch/parisc/kernel/vmlinux.lds.S
@@ -181,7 +181,7 @@ SECTIONS
   .init.ramfs : { *(.init.ramfs) }
   __initramfs_end = .;
 #endif
-  . = ALIGN(32);
+  . = ALIGN(ASM_PAGE_SIZE);
   __per_cpu_start = .;
   .data.percpu  : { *(.data.percpu) }
   __per_cpu_end = .;
diff -puN arch/powerpc/kernel/setup_64.c~allow-per-cpu-variables-to-be-page-aligned arch/powerpc/kernel/setup_64.c
--- a/arch/powerpc/kernel/setup_64.c~allow-per-cpu-variables-to-be-page-aligned
+++ a/arch/powerpc/kernel/setup_64.c
@@ -583,14 +583,14 @@ void __init setup_per_cpu_areas(void)
 	char *ptr;
 
 	/* Copy section for each CPU (we discard the original) */
-	size = ALIGN(__per_cpu_end - __per_cpu_start, SMP_CACHE_BYTES);
+	size = ALIGN(__per_cpu_end - __per_cpu_start, PAGE_SIZE);
 #ifdef CONFIG_MODULES
 	if (size < PERCPU_ENOUGH_ROOM)
 		size = PERCPU_ENOUGH_ROOM;
 #endif
 
 	for_each_possible_cpu(i) {
-		ptr = alloc_bootmem_node(NODE_DATA(cpu_to_node(i)), size);
+		ptr = alloc_bootmem_pages_node(NODE_DATA(cpu_to_node(i)), size);
 		if (!ptr)
 			panic("Cannot allocate cpu data for CPU %d\n", i);
 
diff -puN arch/powerpc/kernel/vmlinux.lds.S~allow-per-cpu-variables-to-be-page-aligned arch/powerpc/kernel/vmlinux.lds.S
--- a/arch/powerpc/kernel/vmlinux.lds.S~allow-per-cpu-variables-to-be-page-aligned
+++ a/arch/powerpc/kernel/vmlinux.lds.S
@@ -139,11 +139,7 @@ SECTIONS
 		__initramfs_end = .;
 	}
 #endif
-#ifdef CONFIG_PPC32
-	. = ALIGN(32);
-#else
-	. = ALIGN(128);
-#endif
+	. = ALIGN(PAGE_SIZE);
 	.data.percpu : {
 		__per_cpu_start = .;
 		*(.data.percpu)
diff -puN arch/ppc/kernel/vmlinux.lds.S~allow-per-cpu-variables-to-be-page-aligned arch/ppc/kernel/vmlinux.lds.S
--- a/arch/ppc/kernel/vmlinux.lds.S~allow-per-cpu-variables-to-be-page-aligned
+++ a/arch/ppc/kernel/vmlinux.lds.S
@@ -130,7 +130,7 @@ SECTIONS
   __ftr_fixup : { *(__ftr_fixup) }
   __stop___ftr_fixup = .;
 
-  . = ALIGN(32);
+  . = ALIGN(4096);
   __per_cpu_start = .;
   .data.percpu  : { *(.data.percpu) }
   __per_cpu_end = .;
diff -puN arch/s390/kernel/vmlinux.lds.S~allow-per-cpu-variables-to-be-page-aligned arch/s390/kernel/vmlinux.lds.S
--- a/arch/s390/kernel/vmlinux.lds.S~allow-per-cpu-variables-to-be-page-aligned
+++ a/arch/s390/kernel/vmlinux.lds.S
@@ -107,7 +107,7 @@ SECTIONS
   . = ALIGN(2);
   __initramfs_end = .;
 #endif
-  . = ALIGN(256);
+  . = ALIGN(4096);
   __per_cpu_start = .;
   .data.percpu  : { *(.data.percpu) }
   __per_cpu_end = .;
diff -puN arch/sh/kernel/vmlinux.lds.S~allow-per-cpu-variables-to-be-page-aligned arch/sh/kernel/vmlinux.lds.S
--- a/arch/sh/kernel/vmlinux.lds.S~allow-per-cpu-variables-to-be-page-aligned
+++ a/arch/sh/kernel/vmlinux.lds.S
@@ -54,7 +54,7 @@ SECTIONS
   . = ALIGN(PAGE_SIZE);
   .data.page_aligned : { *(.data.page_aligned) }
 
-  . = ALIGN(L1_CACHE_BYTES);
+  . = ALIGN(PAGE_SIZE);
   __per_cpu_start = .;
   .data.percpu : { *(.data.percpu) }
   __per_cpu_end = .;
diff -puN arch/sh64/kernel/vmlinux.lds.S~allow-per-cpu-variables-to-be-page-aligned arch/sh64/kernel/vmlinux.lds.S
--- a/arch/sh64/kernel/vmlinux.lds.S~allow-per-cpu-variables-to-be-page-aligned
+++ a/arch/sh64/kernel/vmlinux.lds.S
@@ -85,7 +85,7 @@ SECTIONS
   . = ALIGN(PAGE_SIZE);
   .data.page_aligned : C_PHYS(.data.page_aligned) { *(.data.page_aligned) }
 
-  . = ALIGN(L1_CACHE_BYTES);
+  . = ALIGN(PAGE_SIZE);
   __per_cpu_start = .;
   .data.percpu : C_PHYS(.data.percpu) { *(.data.percpu) }
   __per_cpu_end = . ;
diff -puN arch/sparc/kernel/vmlinux.lds.S~allow-per-cpu-variables-to-be-page-aligned arch/sparc/kernel/vmlinux.lds.S
--- a/arch/sparc/kernel/vmlinux.lds.S~allow-per-cpu-variables-to-be-page-aligned
+++ a/arch/sparc/kernel/vmlinux.lds.S
@@ -65,7 +65,7 @@ SECTIONS
   __initramfs_end = .;
 #endif
 
-  . = ALIGN(32);
+  . = ALIGN(4096);
   __per_cpu_start = .;
   .data.percpu  : { *(.data.percpu) }
   __per_cpu_end = .;
diff -puN arch/sparc64/kernel/smp.c~allow-per-cpu-variables-to-be-page-aligned arch/sparc64/kernel/smp.c
--- a/arch/sparc64/kernel/smp.c~allow-per-cpu-variables-to-be-page-aligned
+++ a/arch/sparc64/kernel/smp.c
@@ -1449,11 +1449,11 @@ void __init setup_per_cpu_areas(void)
 	/* Copy section for each CPU (we discard the original) */
 	goal = PERCPU_ENOUGH_ROOM;
 
-	__per_cpu_shift = 0;
-	for (size = 1UL; size < goal; size <<= 1UL)
+	__per_cpu_shift = PAGE_SHIFT;
+	for (size = PAGE_SIZE; size < goal; size <<= 1UL)
 		__per_cpu_shift++;
 
-	ptr = alloc_bootmem(size * NR_CPUS);
+	ptr = alloc_bootmem_pages(size * NR_CPUS);
 
 	__per_cpu_base = ptr - __per_cpu_start;
 
diff -puN arch/x86_64/kernel/setup64.c~allow-per-cpu-variables-to-be-page-aligned arch/x86_64/kernel/setup64.c
--- a/arch/x86_64/kernel/setup64.c~allow-per-cpu-variables-to-be-page-aligned
+++ a/arch/x86_64/kernel/setup64.c
@@ -103,9 +103,9 @@ void __init setup_per_cpu_areas(void)
 		if (!NODE_DATA(cpu_to_node(i))) {
 			printk("cpu with no node %d, num_online_nodes %d\n",
 			       i, num_online_nodes());
-			ptr = alloc_bootmem(size);
+			ptr = alloc_bootmem_pages(size);
 		} else { 
-			ptr = alloc_bootmem_node(NODE_DATA(cpu_to_node(i)), size);
+			ptr = alloc_bootmem_pages_node(NODE_DATA(cpu_to_node(i)), size);
 		}
 		if (!ptr)
 			panic("Cannot allocate cpu data for CPU %d\n", i);
diff -puN arch/x86_64/kernel/vmlinux.lds.S~allow-per-cpu-variables-to-be-page-aligned arch/x86_64/kernel/vmlinux.lds.S
--- a/arch/x86_64/kernel/vmlinux.lds.S~allow-per-cpu-variables-to-be-page-aligned
+++ a/arch/x86_64/kernel/vmlinux.lds.S
@@ -194,7 +194,7 @@ SECTIONS
   __initramfs_end = .;
 #endif
 
-    . = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
+  . = ALIGN(4096);
   __per_cpu_start = .;
   .data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) { *(.data.percpu) }
   __per_cpu_end = .;
diff -puN arch/xtensa/kernel/vmlinux.lds.S~allow-per-cpu-variables-to-be-page-aligned arch/xtensa/kernel/vmlinux.lds.S
--- a/arch/xtensa/kernel/vmlinux.lds.S~allow-per-cpu-variables-to-be-page-aligned
+++ a/arch/xtensa/kernel/vmlinux.lds.S
@@ -198,7 +198,7 @@ SECTIONS
   __ftr_fixup : { *(__ftr_fixup) }
   __stop___ftr_fixup = .;
 
-  . = ALIGN(32);
+  . = ALIGN(4096);
   __per_cpu_start = .;
   .data.percpu  : { *(.data.percpu) }
   __per_cpu_end = .;
diff -puN include/linux/percpu.h~allow-per-cpu-variables-to-be-page-aligned include/linux/percpu.h
--- a/include/linux/percpu.h~allow-per-cpu-variables-to-be-page-aligned
+++ a/include/linux/percpu.h
@@ -11,7 +11,7 @@
 
 /* Enough to cover all DEFINE_PER_CPUs in kernel, including modules. */
 #ifndef PERCPU_ENOUGH_ROOM
-#define PERCPU_ENOUGH_ROOM 32768
+#define PERCPU_ENOUGH_ROOM 65536
 #endif
 
 /*
diff -puN init/main.c~allow-per-cpu-variables-to-be-page-aligned init/main.c
--- a/init/main.c~allow-per-cpu-variables-to-be-page-aligned
+++ a/init/main.c
@@ -369,12 +369,12 @@ static void __init setup_per_cpu_areas(v
 	unsigned long nr_possible_cpus = num_possible_cpus();
 
 	/* Copy section for each CPU (we discard the original) */
-	size = ALIGN(__per_cpu_end - __per_cpu_start, SMP_CACHE_BYTES);
+	size = ALIGN(__per_cpu_end - __per_cpu_start, PAGE_SIZE);
 #ifdef CONFIG_MODULES
 	if (size < PERCPU_ENOUGH_ROOM)
 		size = PERCPU_ENOUGH_ROOM;
 #endif
-	ptr = alloc_bootmem(size * nr_possible_cpus);
+	ptr = alloc_bootmem_pages(size * nr_possible_cpus);
 
 	for_each_possible_cpu(i) {
 		__per_cpu_offset[i] = ptr - __per_cpu_start;
diff -puN kernel/module.c~allow-per-cpu-variables-to-be-page-aligned kernel/module.c
--- a/kernel/module.c~allow-per-cpu-variables-to-be-page-aligned
+++ a/kernel/module.c
@@ -346,10 +346,10 @@ static void *percpu_modalloc(unsigned lo
 	unsigned int i;
 	void *ptr;
 
-	if (align > SMP_CACHE_BYTES) {
-		printk(KERN_WARNING "%s: per-cpu alignment %li > %i\n",
-		       name, align, SMP_CACHE_BYTES);
-		align = SMP_CACHE_BYTES;
+	if (align > PAGE_SIZE) {
+		printk(KERN_WARNING "%s: per-cpu alignment %li > %li\n",
+		       name, align, PAGE_SIZE);
+		align = PAGE_SIZE;
 	}
 
 	ptr = __per_cpu_start;
@@ -430,7 +430,7 @@ static int percpu_modinit(void)
 	pcpu_size = kmalloc(sizeof(pcpu_size[0]) * pcpu_num_allocated,
 			    GFP_KERNEL);
 	/* Static in-kernel percpu data (used). */
-	pcpu_size[0] = -ALIGN(__per_cpu_end-__per_cpu_start, SMP_CACHE_BYTES);
+	pcpu_size[0] = -ALIGN(__per_cpu_end-__per_cpu_start, PAGE_SIZE);
 	/* Free room. */
 	pcpu_size[1] = PERCPU_ENOUGH_ROOM + pcpu_size[0];
 	if (pcpu_size[1] < 0) {
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

i386-vdso_prelink-warning-fix.patch
cleanup-initialize-esp0-properly-all-the-time.patch
lguest-preparation-export_symbol_gpl-5-functions.patch
lguest-preparation-expose-futex-infrastructure.patch
lguest-kconfig-and-headers.patch
lguest-the-host-code-lgko.patch
lguest-the-host-code-lgko-cleanup-allocate-separate-pages-for-switcher-code.patch
lguest-the-host-code-lgko-cleanup-clean-up-regs-save-restore.patch
lguest-the-host-code-lgko-pin-stack-page-optimization.patch
lguest-guest-code.patch
lguest-makefile.patch
lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher.patch
lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages.patch
lguest-dont-crash-host-on-nmi.patch
lguest-trivial-guest-network-driver.patch
lguest-trivial-guest-console-driver.patch
lguest-trivial-guest-block-driver.patch
lguest-trivial-guest-block-driver-lguest-block-device-speedup.patch
lguest-documentatation-and-example-launcher.patch
lguest-documentatation-and-example-launcher-bridging-support-in-example-code.patch
lguest-documentatation-and-example-launcher-bridging-support-in-example-codelguest-documentation-fixes.patch
introduce-load_tls-to-the-for-loop.patch
remove-unused-set_seg_base.patch
clarify-config_reorder-explanation.patch
allow-per-cpu-variables-to-be-page-aligned.patch
i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda.patch
i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot.patch
i386-gdt-cleanups-clean-up-cpu_init.patch
i386-gdt-cleanups-cleanup-gdt-access.patch
module-use-krealloc.patch
extend-print_symbol-capability.patch
array_size-check-for-type.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-update.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
____call_usermodehelper-dont-flush_signals.patch
