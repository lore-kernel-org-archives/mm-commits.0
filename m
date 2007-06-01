From: akpm@linux-foundation.org
Subject: - m68k-runtime-patching-infrastructure.patch removed from -mm tree
Date: Fri, 01 Jun 2007 00:06:34 -0700
Message-ID: <200706010706.l5176XxN004722@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41517 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755914AbXFAHGo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 03:06:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zippel@linux-m68k.org, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     m68k: runtime patching infrastructure
has been removed from the -mm tree.  Its filename was
     m68k-runtime-patching-infrastructure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: m68k: runtime patching infrastructure
From: Roman Zippel <zippel@linux-m68k.org>

Add the basic infrastructure to allow runtime patching of kernel and modules
to optimize a few functions with parameters, which are only calculated once
during bootup and are otherwise constant.  Use this for the conversion between
virtual and physical addresses.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/Makefile                |    1 
 arch/m68k/kernel/Makefile         |    3 --
 arch/m68k/kernel/module.c         |   28 ++++++++++++++++++++++-
 arch/m68k/kernel/module.lds       |    7 +++++
 arch/m68k/kernel/vmlinux-std.lds  |    5 ++++
 arch/m68k/kernel/vmlinux-sun3.lds |    5 ++++
 arch/m68k/mm/motorola.c           |    3 ++
 include/asm-m68k/module.h         |   33 +++++++++++++++++++++++++++-
 include/asm-m68k/page.h           |   29 ++++++++++++++++++++++--
 9 files changed, 107 insertions(+), 7 deletions(-)

diff -puN arch/m68k/Makefile~m68k-runtime-patching-infrastructure arch/m68k/Makefile
--- a/arch/m68k/Makefile~m68k-runtime-patching-infrastructure
+++ a/arch/m68k/Makefile
@@ -19,6 +19,7 @@ COMPILE_ARCH = $(shell uname -m)
 # override top level makefile
 AS += -m68020
 LDFLAGS := -m m68kelf
+LDFLAGS_MODULE += -T $(srctree)/arch/m68k/kernel/module.lds
 ifneq ($(COMPILE_ARCH),$(ARCH))
 	# prefix for cross-compiling binaries
 	CROSS_COMPILE = m68k-linux-gnu-
diff -puN arch/m68k/kernel/Makefile~m68k-runtime-patching-infrastructure arch/m68k/kernel/Makefile
--- a/arch/m68k/kernel/Makefile~m68k-runtime-patching-infrastructure
+++ a/arch/m68k/kernel/Makefile
@@ -9,13 +9,12 @@ else
 endif
 extra-y	+= vmlinux.lds
 
-obj-y	:= entry.o process.o traps.o ints.o signal.o ptrace.o \
+obj-y	:= entry.o process.o traps.o ints.o signal.o ptrace.o module.o \
 	   sys_m68k.o time.o semaphore.o setup.o m68k_ksyms.o devres.o
 
 devres-y = ../../../kernel/irq/devres.o
 
 obj-$(CONFIG_PCI)	+= bios32.o
-obj-$(CONFIG_MODULES)	+= module.o
 obj-y$(CONFIG_MMU_SUN3) += dma.o	# no, it's not a typo
 
 EXTRA_AFLAGS := -traditional
diff -puN arch/m68k/kernel/module.c~m68k-runtime-patching-infrastructure arch/m68k/kernel/module.c
--- a/arch/m68k/kernel/module.c~m68k-runtime-patching-infrastructure
+++ a/arch/m68k/kernel/module.c
@@ -1,3 +1,9 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of this archive
+ * for more details.
+ */
+
 #include <linux/moduleloader.h>
 #include <linux/elf.h>
 #include <linux/vmalloc.h>
@@ -11,6 +17,8 @@
 #define DEBUGP(fmt...)
 #endif
 
+#ifdef CONFIG_MODULES
+
 void *module_alloc(unsigned long size)
 {
 	if (size == 0)
@@ -118,11 +126,29 @@ int apply_relocate_add(Elf32_Shdr *sechd
 
 int module_finalize(const Elf_Ehdr *hdr,
 		    const Elf_Shdr *sechdrs,
-		    struct module *me)
+		    struct module *mod)
 {
+	module_fixup(mod, mod->arch.fixup_start, mod->arch.fixup_end);
+
 	return 0;
 }
 
 void module_arch_cleanup(struct module *mod)
 {
 }
+
+#endif /* CONFIG_MODULES */
+
+void module_fixup(struct module *mod, struct m68k_fixup_info *start,
+		  struct m68k_fixup_info *end)
+{
+	struct m68k_fixup_info *fixup;
+
+	for (fixup = start; fixup < end; fixup++) {
+		switch (fixup->type) {
+		case m68k_fixup_memoffset:
+			*(u32 *)fixup->addr = m68k_memoffset;
+			break;
+		}
+	}
+}
diff -puN /dev/null arch/m68k/kernel/module.lds
--- /dev/null
+++ a/arch/m68k/kernel/module.lds
@@ -0,0 +1,7 @@
+SECTIONS {
+	.m68k_fixup : {
+		__start_fixup = .;
+		*(.m68k_fixup)
+		__stop_fixup = .;
+	}
+}
diff -puN arch/m68k/kernel/vmlinux-std.lds~m68k-runtime-patching-infrastructure arch/m68k/kernel/vmlinux-std.lds
--- a/arch/m68k/kernel/vmlinux-std.lds~m68k-runtime-patching-infrastructure
+++ a/arch/m68k/kernel/vmlinux-std.lds
@@ -60,6 +60,11 @@ SECTIONS
   __con_initcall_start = .;
   .con_initcall.init : { *(.con_initcall.init) }
   __con_initcall_end = .;
+  .m68k_fixup : {
+	__start_fixup = .;
+	*(.m68k_fixup)
+	__stop_fixup = .;
+  }
   SECURITY_INIT
 #ifdef CONFIG_BLK_DEV_INITRD
   . = ALIGN(8192);
diff -puN arch/m68k/kernel/vmlinux-sun3.lds~m68k-runtime-patching-infrastructure arch/m68k/kernel/vmlinux-sun3.lds
--- a/arch/m68k/kernel/vmlinux-sun3.lds~m68k-runtime-patching-infrastructure
+++ a/arch/m68k/kernel/vmlinux-sun3.lds
@@ -54,6 +54,11 @@ __init_begin = .;
 	__con_initcall_start = .;
 	.con_initcall.init : { *(.con_initcall.init) }
 	__con_initcall_end = .;
+	.m68k_fixup : {
+		__start_fixup = .;
+		*(.m68k_fixup)
+		__stop_fixup = .;
+	}
 	SECURITY_INIT
 #ifdef CONFIG_BLK_DEV_INITRD
 	. = ALIGN(8192);
diff -puN arch/m68k/mm/motorola.c~m68k-runtime-patching-infrastructure arch/m68k/mm/motorola.c
--- a/arch/m68k/mm/motorola.c~m68k-runtime-patching-infrastructure
+++ a/arch/m68k/mm/motorola.c
@@ -222,6 +222,9 @@ void __init paging_init(void)
 			pgprot_val(protection_map[i]) |= _PAGE_CACHE040;
 	}
 
+	module_fixup(NULL, __start_fixup, __stop_fixup);
+	flush_icache();
+
 	/*
 	 * Map the physical memory available into the kernel virtual
 	 * address space.  It may allocate some memory for page
diff -puN include/asm-m68k/module.h~m68k-runtime-patching-infrastructure include/asm-m68k/module.h
--- a/include/asm-m68k/module.h~m68k-runtime-patching-infrastructure
+++ a/include/asm-m68k/module.h
@@ -1,7 +1,38 @@
 #ifndef _ASM_M68K_MODULE_H
 #define _ASM_M68K_MODULE_H
-struct mod_arch_specific { };
+
+struct mod_arch_specific {
+	struct m68k_fixup_info *fixup_start, *fixup_end;
+};
+
+#define MODULE_ARCH_INIT {				\
+	.fixup_start		= __start_fixup,	\
+	.fixup_end		= __stop_fixup,		\
+}
+
 #define Elf_Shdr Elf32_Shdr
 #define Elf_Sym Elf32_Sym
 #define Elf_Ehdr Elf32_Ehdr
+
+
+enum m68k_fixup_type {
+	m68k_fixup_memoffset,
+};
+
+struct m68k_fixup_info {
+	enum m68k_fixup_type type;
+	void *addr;
+};
+
+#define m68k_fixup(type, addr)			\
+	"	.section \".m68k_fixup\",\"aw\"\n"	\
+	"	.long " #type "," #addr "\n"	\
+	"	.previous\n"
+
+extern struct m68k_fixup_info __start_fixup[], __stop_fixup[];
+
+struct module;
+extern void module_fixup(struct module *mod, struct m68k_fixup_info *start,
+			 struct m68k_fixup_info *end);
+
 #endif /* _ASM_M68K_MODULE_H */
diff -puN include/asm-m68k/page.h~m68k-runtime-patching-infrastructure include/asm-m68k/page.h
--- a/include/asm-m68k/page.h~m68k-runtime-patching-infrastructure
+++ a/include/asm-m68k/page.h
@@ -27,6 +27,8 @@
 
 #ifndef __ASSEMBLY__
 
+#include <asm/module.h>
+
 #define get_user_page(vaddr)		__get_free_page(GFP_KERNEL)
 #define free_user_page(page, addr)	free_page(addr)
 
@@ -114,14 +116,35 @@ typedef struct { unsigned long pgprot; }
 
 #ifndef __ASSEMBLY__
 
+extern unsigned long m68k_memoffset;
+
 #ifndef CONFIG_SUN3
 
 #define WANT_PAGE_VIRTUAL
 #ifdef CONFIG_SINGLE_MEMORY_CHUNK
-extern unsigned long m68k_memoffset;
 
-#define __pa(vaddr)		((unsigned long)(vaddr)+m68k_memoffset)
-#define __va(paddr)		((void *)((unsigned long)(paddr)-m68k_memoffset))
+static inline unsigned long ___pa(void *vaddr)
+{
+	unsigned long paddr;
+	asm (
+		"1:	addl #0,%0\n"
+		m68k_fixup(%c2, 1b+2)
+		: "=r" (paddr)
+		: "0" (vaddr), "i" (m68k_fixup_memoffset));
+	return paddr;
+}
+#define __pa(vaddr)    ___pa((void *)(vaddr))
+static inline void *__va(unsigned long paddr)
+{
+	void *vaddr;
+	asm (
+		"1:	subl #0,%0\n"
+		m68k_fixup(%c2, 1b+2)
+		: "=r" (vaddr)
+		: "0" (paddr), "i" (m68k_fixup_memoffset));
+	return vaddr;
+}
+
 #else
 #define __pa(vaddr)		virt_to_phys((void *)(vaddr))
 #define __va(paddr)		phys_to_virt((unsigned long)(paddr))
_

Patches currently in -mm which might be from zippel@linux-m68k.org are

origin.patch
lots-of-architectures-enable-arbitary-speed-tty-support.patch
hfs-convert-to-new-aops.patch
hfsplus-convert-to-new-aops.patch
char-genrtc-use-wait_event_interruptible.patch
dma-mapping-prevent-dma-dependent-code-from-linking-on.patch
