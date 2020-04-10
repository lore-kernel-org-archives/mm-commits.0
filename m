From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 16/35] mm/vma: define a default value for
 VM_DATA_DEFAULT_FLAGS
Date: Fri, 10 Apr 2020 14:33:05 -0700
Message-ID: <20200410213305.1kilHaPjJ%akpm@linux-foundation.org>
References: <20200410143047.bf34a933ce1affdc042c7c80@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726657AbgDJVdI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Apr 2020 17:33:08 -0400
In-Reply-To: <20200410143047.bf34a933ce1affdc042c7c80@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, anshuman.khandual@arm.com, bcain@codeaurora.org, catalin.marinas@arm.com, chris@zankel.net, dalias@libc.org, davem@davemloft.net, geert@linux-m68k.org, guoren@kernel.org, gxt@pku.edu.cn, heiko.carstens@de.ibm.com, James.Bottomley@HansenPartnership.com, jdike@addtoit.com, jonas@southpole.se, ley.foon.tan@intel.com, linux-mm@kvack.org, linux@armlinux.org.uk, mm-commits@vger.kernel.org, monstr@monstr.eu, mpe@ellerman.id.au, msalter@redhat.com, nickhu@andestech.com, paul.walmsley@sifive.com, paulburton@kernel.org, ralf@linux-mips.org, rth@twiddle.net, tglx@linutronix.de, tony.luck@intel.com, torvalds@linux-foundation.org, vbabka@suse.cz, vgupta@synopsys.com, ysato@users.sourceforge.jp

From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/vma: define a default value for VM_DATA_DEFAULT_FLAGS

There are many platforms with exact same value for VM_DATA_DEFAULT_FLAGS
This creates a default value for VM_DATA_DEFAULT_FLAGS in line with the
existing VM_STACK_DEFAULT_FLAGS.  While here, also define some more macros
with standard VMA access flag combinations that are used frequently across
many platforms.  Apart from simplification, this reduces code duplication
as well.

Link: http://lkml.kernel.org/r/1583391014-8170-2-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Guo Ren <guoren@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Brian Cain <bcain@codeaurora.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Burton <paulburton@kernel.org>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Ley Foon Tan <ley.foon.tan@intel.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Rich Felker <dalias@libc.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Guan Xuetao <gxt@pku.edu.cn>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/page.h      |    3 ---
 arch/arc/include/asm/page.h        |    2 +-
 arch/arm/include/asm/page.h        |    4 +---
 arch/arm64/include/asm/page.h      |    4 +---
 arch/c6x/include/asm/page.h        |    5 +----
 arch/csky/include/asm/page.h       |    3 ---
 arch/h8300/include/asm/page.h      |    2 --
 arch/hexagon/include/asm/page.h    |    3 +--
 arch/ia64/include/asm/page.h       |    5 +----
 arch/m68k/include/asm/page.h       |    3 ---
 arch/microblaze/include/asm/page.h |    2 --
 arch/mips/include/asm/page.h       |    5 +----
 arch/nds32/include/asm/page.h      |    3 ---
 arch/nios2/include/asm/page.h      |    3 +--
 arch/openrisc/include/asm/page.h   |    5 -----
 arch/parisc/include/asm/page.h     |    3 ---
 arch/powerpc/include/asm/page.h    |    9 ++-------
 arch/powerpc/include/asm/page_64.h |    7 ++-----
 arch/riscv/include/asm/page.h      |    3 +--
 arch/s390/include/asm/page.h       |    3 +--
 arch/sh/include/asm/page.h         |    3 ---
 arch/sparc/include/asm/page_32.h   |    3 ---
 arch/sparc/include/asm/page_64.h   |    3 ---
 arch/unicore32/include/asm/page.h  |    3 ---
 arch/x86/include/asm/page_types.h  |    4 +---
 arch/x86/um/asm/vm-flags.h         |   10 ++--------
 arch/xtensa/include/asm/page.h     |    3 ---
 include/linux/mm.h                 |   14 ++++++++++++++
 28 files changed, 31 insertions(+), 89 deletions(-)

--- a/arch/alpha/include/asm/page.h~mm-vma-define-a-default-value-for-vm_data_default_flags
+++ a/arch/alpha/include/asm/page.h
@@ -90,9 +90,6 @@ typedef struct page *pgtable_t;
 #define virt_addr_valid(kaddr)	pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
 #endif /* CONFIG_DISCONTIGMEM */
 
-#define VM_DATA_DEFAULT_FLAGS		(VM_READ | VM_WRITE | VM_EXEC | \
-					 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
-
 #include <asm-generic/memory_model.h>
 #include <asm-generic/getorder.h>
 
--- a/arch/arc/include/asm/page.h~mm-vma-define-a-default-value-for-vm_data_default_flags
+++ a/arch/arc/include/asm/page.h
@@ -102,7 +102,7 @@ typedef pte_t * pgtable_t;
 #define virt_addr_valid(kaddr)  pfn_valid(virt_to_pfn(kaddr))
 
 /* Default Permissions for stack/heaps pages (Non Executable) */
-#define VM_DATA_DEFAULT_FLAGS   (VM_READ | VM_WRITE | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
+#define VM_DATA_DEFAULT_FLAGS	VM_DATA_FLAGS_NON_EXEC
 
 #define WANT_PAGE_VIRTUAL   1
 
--- a/arch/arm64/include/asm/page.h~mm-vma-define-a-default-value-for-vm_data_default_flags
+++ a/arch/arm64/include/asm/page.h
@@ -36,9 +36,7 @@ extern int pfn_valid(unsigned long);
 
 #endif /* !__ASSEMBLY__ */
 
-#define VM_DATA_DEFAULT_FLAGS \
-	(((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0) | \
-	 VM_READ | VM_WRITE | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
+#define VM_DATA_DEFAULT_FLAGS	VM_DATA_FLAGS_TSK_EXEC
 
 #include <asm-generic/getorder.h>
 
--- a/arch/arm/include/asm/page.h~mm-vma-define-a-default-value-for-vm_data_default_flags
+++ a/arch/arm/include/asm/page.h
@@ -161,9 +161,7 @@ extern int pfn_valid(unsigned long);
 
 #endif /* !__ASSEMBLY__ */
 
-#define VM_DATA_DEFAULT_FLAGS \
-	(((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0) | \
-	 VM_READ | VM_WRITE | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
+#define VM_DATA_DEFAULT_FLAGS	VM_DATA_FLAGS_TSK_EXEC
 
 #include <asm-generic/getorder.h>
 
--- a/arch/c6x/include/asm/page.h~mm-vma-define-a-default-value-for-vm_data_default_flags
+++ a/arch/c6x/include/asm/page.h
@@ -2,10 +2,7 @@
 #ifndef _ASM_C6X_PAGE_H
 #define _ASM_C6X_PAGE_H
 
-#define VM_DATA_DEFAULT_FLAGS \
-	(VM_READ | VM_WRITE | \
-	((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0) | \
-		 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
+#define VM_DATA_DEFAULT_FLAGS	VM_DATA_FLAGS_TSK_EXEC
 
 #include <asm-generic/page.h>
 
--- a/arch/csky/include/asm/page.h~mm-vma-define-a-default-value-for-vm_data_default_flags
+++ a/arch/csky/include/asm/page.h
@@ -85,9 +85,6 @@ extern unsigned long va_pa_offset;
 				 PHYS_OFFSET_OFFSET)
 #define virt_to_page(x)	(mem_map + MAP_NR(x))
 
-#define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | VM_EXEC | \
-				VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
-
 #define pfn_to_kaddr(x)	__va(PFN_PHYS(x))
 
 #include <asm-generic/memory_model.h>
--- a/arch/h8300/include/asm/page.h~mm-vma-define-a-default-value-for-vm_data_default_flags
+++ a/arch/h8300/include/asm/page.h
@@ -6,8 +6,6 @@
 #include <linux/types.h>
 
 #define MAP_NR(addr) (((uintptr_t)(addr)-PAGE_OFFSET) >> PAGE_SHIFT)
-#define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | VM_EXEC | \
-				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 
 #ifndef __ASSEMBLY__
 extern unsigned long rom_length;
--- a/arch/hexagon/include/asm/page.h~mm-vma-define-a-default-value-for-vm_data_default_flags
+++ a/arch/hexagon/include/asm/page.h
@@ -93,8 +93,7 @@ struct page;
 #define virt_to_page(kaddr) pfn_to_page(PFN_DOWN(__pa(kaddr)))
 
 /* Default vm area behavior is non-executable.  */
-#define VM_DATA_DEFAULT_FLAGS (VM_READ | VM_WRITE | \
-				VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
+#define VM_DATA_DEFAULT_FLAGS	VM_DATA_FLAGS_NON_EXEC
 
 #define pfn_valid(pfn) ((pfn) < max_mapnr)
 #define virt_addr_valid(kaddr) pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
--- a/arch/ia64/include/asm/page.h~mm-vma-define-a-default-value-for-vm_data_default_flags
+++ a/arch/ia64/include/asm/page.h
@@ -218,10 +218,7 @@ get_order (unsigned long size)
 
 #define PAGE_OFFSET			RGN_BASE(RGN_KERNEL)
 
-#define VM_DATA_DEFAULT_FLAGS		(VM_READ | VM_WRITE |					\
-					 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC |		\
-					 (((current->personality & READ_IMPLIES_EXEC) != 0)	\
-					  ? VM_EXEC : 0))
+#define VM_DATA_DEFAULT_FLAGS	VM_DATA_FLAGS_TSK_EXEC
 
 #define GATE_ADDR		RGN_BASE(RGN_GATE)
 
--- a/arch/m68k/include/asm/page.h~mm-vma-define-a-default-value-for-vm_data_default_flags
+++ a/arch/m68k/include/asm/page.h
@@ -65,9 +65,6 @@ extern unsigned long _ramend;
 #define __phys_to_pfn(paddr)	((unsigned long)((paddr) >> PAGE_SHIFT))
 #define __pfn_to_phys(pfn)	PFN_PHYS(pfn)
 
-#define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | VM_EXEC | \
-				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
-
 #include <asm-generic/getorder.h>
 
 #endif /* _M68K_PAGE_H */
--- a/arch/microblaze/include/asm/page.h~mm-vma-define-a-default-value-for-vm_data_default_flags
+++ a/arch/microblaze/include/asm/page.h
@@ -194,8 +194,6 @@ extern int page_is_ram(unsigned long pfn
 
 #ifdef CONFIG_MMU
 
-#define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | VM_EXEC | \
-				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 #endif /* CONFIG_MMU */
 
 #endif /* __KERNEL__ */
--- a/arch/mips/include/asm/page.h~mm-vma-define-a-default-value-for-vm_data_default_flags
+++ a/arch/mips/include/asm/page.h
@@ -253,10 +253,7 @@ extern bool __virt_addr_valid(const vola
 #define virt_addr_valid(kaddr)						\
 	__virt_addr_valid((const volatile void *) (kaddr))
 
-#define VM_DATA_DEFAULT_FLAGS \
-	(VM_READ | VM_WRITE | \
-	 ((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0) | \
-	 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
+#define VM_DATA_DEFAULT_FLAGS	VM_DATA_FLAGS_TSK_EXEC
 
 #include <asm-generic/memory_model.h>
 #include <asm-generic/getorder.h>
--- a/arch/nds32/include/asm/page.h~mm-vma-define-a-default-value-for-vm_data_default_flags
+++ a/arch/nds32/include/asm/page.h
@@ -59,9 +59,6 @@ typedef struct page *pgtable_t;
 
 #endif /* !__ASSEMBLY__ */
 
-#define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | VM_EXEC | \
-				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
-
 #endif /* __KERNEL__ */
 
 #endif
--- a/arch/nios2/include/asm/page.h~mm-vma-define-a-default-value-for-vm_data_default_flags
+++ a/arch/nios2/include/asm/page.h
@@ -98,8 +98,7 @@ static inline bool pfn_valid(unsigned lo
 # define virt_to_page(vaddr)	pfn_to_page(PFN_DOWN(virt_to_phys(vaddr)))
 # define virt_addr_valid(vaddr)	pfn_valid(PFN_DOWN(virt_to_phys(vaddr)))
 
-# define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | \
-				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
+# define VM_DATA_DEFAULT_FLAGS	VM_DATA_FLAGS_NON_EXEC
 
 #include <asm-generic/memory_model.h>
 
--- a/arch/openrisc/include/asm/page.h~mm-vma-define-a-default-value-for-vm_data_default_flags
+++ a/arch/openrisc/include/asm/page.h
@@ -86,11 +86,6 @@ typedef struct page *pgtable_t;
 
 #endif /* __ASSEMBLY__ */
 
-
-#define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | VM_EXEC | \
-				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
-
-
 #include <asm-generic/memory_model.h>
 #include <asm-generic/getorder.h>
 
--- a/arch/parisc/include/asm/page.h~mm-vma-define-a-default-value-for-vm_data_default_flags
+++ a/arch/parisc/include/asm/page.h
@@ -180,9 +180,6 @@ extern int npmem_ranges;
 #define page_to_phys(page)	(page_to_pfn(page) << PAGE_SHIFT)
 #define virt_to_page(kaddr)     pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
 
-#define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | VM_EXEC | \
-				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
-
 #include <asm-generic/memory_model.h>
 #include <asm-generic/getorder.h>
 #include <asm/pdc.h>
--- a/arch/powerpc/include/asm/page_64.h~mm-vma-define-a-default-value-for-vm_data_default_flags
+++ a/arch/powerpc/include/asm/page_64.h
@@ -94,11 +94,8 @@ extern u64 ppc64_pft_size;
  * stack by default, so in the absence of a PT_GNU_STACK program header
  * we turn execute permission off.
  */
-#define VM_STACK_DEFAULT_FLAGS32	(VM_READ | VM_WRITE | VM_EXEC | \
-					 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
-
-#define VM_STACK_DEFAULT_FLAGS64	(VM_READ | VM_WRITE | \
-					 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
+#define VM_STACK_DEFAULT_FLAGS32	VM_DATA_FLAGS_EXEC
+#define VM_STACK_DEFAULT_FLAGS64	VM_DATA_FLAGS_NON_EXEC
 
 #define VM_STACK_DEFAULT_FLAGS \
 	(is_32bit_task() ? \
--- a/arch/powerpc/include/asm/page.h~mm-vma-define-a-default-value-for-vm_data_default_flags
+++ a/arch/powerpc/include/asm/page.h
@@ -240,13 +240,8 @@ static inline bool pfn_valid(unsigned lo
  * and needs to be executable.  This means the whole heap ends
  * up being executable.
  */
-#define VM_DATA_DEFAULT_FLAGS32 \
-	(((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0) | \
-				 VM_READ | VM_WRITE | \
-				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
-
-#define VM_DATA_DEFAULT_FLAGS64	(VM_READ | VM_WRITE | \
-				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
+#define VM_DATA_DEFAULT_FLAGS32	VM_DATA_FLAGS_TSK_EXEC
+#define VM_DATA_DEFAULT_FLAGS64	VM_DATA_FLAGS_NON_EXEC
 
 #ifdef __powerpc64__
 #include <asm/page_64.h>
--- a/arch/riscv/include/asm/page.h~mm-vma-define-a-default-value-for-vm_data_default_flags
+++ a/arch/riscv/include/asm/page.h
@@ -137,8 +137,7 @@ extern phys_addr_t __phys_addr_symbol(un
 
 #define virt_addr_valid(vaddr)	(pfn_valid(virt_to_pfn(vaddr)))
 
-#define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | \
-				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
+#define VM_DATA_DEFAULT_FLAGS	VM_DATA_FLAGS_NON_EXEC
 
 #include <asm-generic/memory_model.h>
 #include <asm-generic/getorder.h>
--- a/arch/s390/include/asm/page.h~mm-vma-define-a-default-value-for-vm_data_default_flags
+++ a/arch/s390/include/asm/page.h
@@ -181,8 +181,7 @@ int arch_make_page_accessible(struct pag
 
 #define virt_addr_valid(kaddr)	pfn_valid(virt_to_pfn(kaddr))
 
-#define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | \
-				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
+#define VM_DATA_DEFAULT_FLAGS	VM_DATA_FLAGS_NON_EXEC
 
 #include <asm-generic/memory_model.h>
 #include <asm-generic/getorder.h>
--- a/arch/sh/include/asm/page.h~mm-vma-define-a-default-value-for-vm_data_default_flags
+++ a/arch/sh/include/asm/page.h
@@ -182,9 +182,6 @@ typedef struct page *pgtable_t;
 #endif
 #define virt_addr_valid(kaddr)	pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
 
-#define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | VM_EXEC | \
-				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
-
 #include <asm-generic/memory_model.h>
 #include <asm-generic/getorder.h>
 
--- a/arch/sparc/include/asm/page_32.h~mm-vma-define-a-default-value-for-vm_data_default_flags
+++ a/arch/sparc/include/asm/page_32.h
@@ -133,9 +133,6 @@ extern unsigned long pfn_base;
 #define pfn_valid(pfn)		(((pfn) >= (pfn_base)) && (((pfn)-(pfn_base)) < max_mapnr))
 #define virt_addr_valid(kaddr)	((((unsigned long)(kaddr)-PAGE_OFFSET)>>PAGE_SHIFT) < max_mapnr)
 
-#define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | VM_EXEC | \
-				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
-
 #include <asm-generic/memory_model.h>
 #include <asm-generic/getorder.h>
 
--- a/arch/sparc/include/asm/page_64.h~mm-vma-define-a-default-value-for-vm_data_default_flags
+++ a/arch/sparc/include/asm/page_64.h
@@ -158,9 +158,6 @@ extern unsigned long PAGE_OFFSET;
 
 #endif /* !(__ASSEMBLY__) */
 
-#define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | VM_EXEC | \
-				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
-
 #include <asm-generic/getorder.h>
 
 #endif /* _SPARC64_PAGE_H */
--- a/arch/unicore32/include/asm/page.h~mm-vma-define-a-default-value-for-vm_data_default_flags
+++ a/arch/unicore32/include/asm/page.h
@@ -69,9 +69,6 @@ extern int pfn_valid(unsigned long);
 
 #endif /* !__ASSEMBLY__ */
 
-#define VM_DATA_DEFAULT_FLAGS \
-	(VM_READ | VM_WRITE | VM_EXEC | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
-
 #include <asm-generic/getorder.h>
 
 #endif
--- a/arch/x86/include/asm/page_types.h~mm-vma-define-a-default-value-for-vm_data_default_flags
+++ a/arch/x86/include/asm/page_types.h
@@ -35,9 +35,7 @@
 
 #define PAGE_OFFSET		((unsigned long)__PAGE_OFFSET)
 
-#define VM_DATA_DEFAULT_FLAGS \
-	(((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0 ) | \
-	 VM_READ | VM_WRITE | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
+#define VM_DATA_DEFAULT_FLAGS	VM_DATA_FLAGS_TSK_EXEC
 
 #define __PHYSICAL_START	ALIGN(CONFIG_PHYSICAL_START, \
 				      CONFIG_PHYSICAL_ALIGN)
--- a/arch/x86/um/asm/vm-flags.h~mm-vma-define-a-default-value-for-vm_data_default_flags
+++ a/arch/x86/um/asm/vm-flags.h
@@ -9,17 +9,11 @@
 
 #ifdef CONFIG_X86_32
 
-#define VM_DATA_DEFAULT_FLAGS \
-	(VM_READ | VM_WRITE | \
-	((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0 ) | \
-		 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
+#define VM_DATA_DEFAULT_FLAGS	VM_DATA_FLAGS_TSK_EXEC
 
 #else
 
-#define VM_DATA_DEFAULT_FLAGS (VM_READ | VM_WRITE | VM_EXEC | \
-	VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
-#define VM_STACK_DEFAULT_FLAGS (VM_GROWSDOWN | VM_READ | VM_WRITE | \
-	VM_EXEC | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
+#define VM_STACK_DEFAULT_FLAGS (VM_GROWSDOWN | VM_DATA_FLAGS_EXEC)
 
 #endif
 #endif
--- a/arch/xtensa/include/asm/page.h~mm-vma-define-a-default-value-for-vm_data_default_flags
+++ a/arch/xtensa/include/asm/page.h
@@ -203,8 +203,5 @@ static inline unsigned long ___pa(unsign
 
 #endif /* __ASSEMBLY__ */
 
-#define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | VM_EXEC | \
-				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
