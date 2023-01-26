Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA33CC54E94
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 00:36:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236180AbjAZAgU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Jan 2023 19:36:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236237AbjAZAgS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2023 19:36:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FCDB5AB7E
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2023 16:36:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1AEFEB81CB6
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 00:36:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E8EC433EF;
        Thu, 26 Jan 2023 00:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674693373;
        bh=2/H3ojHe+zXp4dKrFLxXIJdbzkIK1E6ubtYezj4r2MA=;
        h=Date:To:From:Subject:From;
        b=EbTZ9taQNXJoRfEi1mofnIl+uww4mHwHj5IiXKCN4wbSWxFlJPD2mf4M4QbsjZSvT
         xP407MmNP4kxLUns207IfEbeINxA3/UWPL4adAPtFaoUvxm8YNfK1GFC0ZhLzwN/kb
         Q8/DAFqv1gmK2R9Jt0fyySWb5Ny1DJX4pD0ZPBv8=
Date:   Wed, 25 Jan 2023 16:36:13 -0800
To:     mm-commits@vger.kernel.org, ysato@users.sourceforge.jp,
        vgupta@kernel.org, tsbogend@alpha.franken.de, shorne@gmail.com,
        richard@nod.at, palmer@dabbelt.com, mpe@ellerman.id.au,
        monstr@monstr.eu, mattst88@gmail.com, kernel@xen0n.name,
        jcmvbkbc@gmail.com, guoren@kernel.org, gerg@linux-m68k.org,
        geert@linux-m68k.org, dinguyen@kernel.org, deller@gmx.de,
        davem@davemloft.net, dalias@libc.org, chenhuacai@kernel.org,
        bcain@quicinc.com, arnd@arndb.de, rppt@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem.patch added to mm-unstable branch
Message-Id: <20230126003613.A6E8EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, arch: add generic implementation of pfn_valid() for FLATMEM
has been added to the -mm mm-unstable branch.  Its filename is
     mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: mm, arch: add generic implementation of pfn_valid() for FLATMEM
Date: Wed, 25 Jan 2023 21:07:57 +0200

Every architecture that supports FLATMEM memory model defines its own
version of pfn_valid() that essentially compares a pfn to max_mapnr.

Use mips/powerpc version implemented as static inline as a generic
implementation of pfn_valid() and drop its per-architecture definitions

Link: https://lkml.kernel.org/r/20230125190757.22555-4-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Rich Felker <dalias@libc.org>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/alpha/include/asm/page.h~mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem
+++ a/arch/alpha/include/asm/page.h
@@ -86,10 +86,6 @@ typedef struct page *pgtable_t;
 #define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
 #define virt_addr_valid(kaddr)	pfn_valid((__pa(kaddr) >> PAGE_SHIFT))
 
-#ifdef CONFIG_FLATMEM
-#define pfn_valid(pfn)		((pfn) < max_mapnr)
-#endif /* CONFIG_FLATMEM */
-
 #include <asm-generic/memory_model.h>
 #include <asm-generic/getorder.h>
 
--- a/arch/arc/include/asm/page.h~mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem
+++ a/arch/arc/include/asm/page.h
@@ -109,7 +109,6 @@ extern int pfn_valid(unsigned long pfn);
 #else /* CONFIG_HIGHMEM */
 
 #define ARCH_PFN_OFFSET		virt_to_pfn(CONFIG_LINUX_RAM_BASE)
-#define pfn_valid(pfn)		(((pfn) - ARCH_PFN_OFFSET) < max_mapnr)
 
 #endif /* CONFIG_HIGHMEM */
 
--- a/arch/csky/include/asm/page.h~mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem
+++ a/arch/csky/include/asm/page.h
@@ -39,7 +39,6 @@
 
 #define virt_addr_valid(kaddr)  ((void *)(kaddr) >= (void *)PAGE_OFFSET && \
 			(void *)(kaddr) < high_memory)
-#define pfn_valid(pfn)		((pfn) >= ARCH_PFN_OFFSET && ((pfn) - ARCH_PFN_OFFSET) < max_mapnr)
 
 extern void *memset(void *dest, int c, size_t l);
 extern void *memcpy(void *to, const void *from, size_t l);
--- a/arch/hexagon/include/asm/page.h~mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem
+++ a/arch/hexagon/include/asm/page.h
@@ -95,7 +95,6 @@ struct page;
 /* Default vm area behavior is non-executable.  */
 #define VM_DATA_DEFAULT_FLAGS	VM_DATA_FLAGS_NON_EXEC
 
-#define pfn_valid(pfn) ((pfn) < max_mapnr)
 #define virt_addr_valid(kaddr) pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
 
 /*  Need to not use a define for linesize; may move this to another file.  */
--- a/arch/ia64/include/asm/page.h~mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem
+++ a/arch/ia64/include/asm/page.h
@@ -95,10 +95,6 @@ do {						\
 
 #include <asm-generic/memory_model.h>
 
-#ifdef CONFIG_FLATMEM
-# define pfn_valid(pfn)		((pfn) < max_mapnr)
-#endif
-
 #define page_to_phys(page)	(page_to_pfn(page) << PAGE_SHIFT)
 #define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
 #define pfn_to_kaddr(pfn)	__va((pfn) << PAGE_SHIFT)
--- a/arch/loongarch/include/asm/page.h~mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem
+++ a/arch/loongarch/include/asm/page.h
@@ -82,19 +82,6 @@ typedef struct { unsigned long pgprot; }
 
 #define pfn_to_kaddr(pfn)	__va((pfn) << PAGE_SHIFT)
 
-#ifdef CONFIG_FLATMEM
-
-static inline int pfn_valid(unsigned long pfn)
-{
-	/* avoid <linux/mm.h> include hell */
-	extern unsigned long max_mapnr;
-	unsigned long pfn_offset = ARCH_PFN_OFFSET;
-
-	return pfn >= pfn_offset && pfn < max_mapnr;
-}
-
-#endif
-
 #define virt_to_pfn(kaddr)	PFN_DOWN(PHYSADDR(kaddr))
 #define virt_to_page(kaddr)	pfn_to_page(virt_to_pfn(kaddr))
 
--- a/arch/m68k/include/asm/page_no.h~mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem
+++ a/arch/m68k/include/asm/page_no.h
@@ -25,8 +25,6 @@ extern unsigned long memory_end;
 #define virt_to_page(addr)	(mem_map + (((unsigned long)(addr)-PAGE_OFFSET) >> PAGE_SHIFT))
 #define page_to_virt(page)	__va(((((page) - mem_map) << PAGE_SHIFT) + PAGE_OFFSET))
 
-#define pfn_valid(pfn)	        ((pfn) < max_mapnr)
-
 #define	virt_addr_valid(kaddr)	(((unsigned long)(kaddr) >= PAGE_OFFSET) && \
 				((unsigned long)(kaddr) < memory_end))
 
--- a/arch/microblaze/include/asm/page.h~mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem
+++ a/arch/microblaze/include/asm/page.h
@@ -112,7 +112,6 @@ extern int page_is_ram(unsigned long pfn
 #  define page_to_phys(page)     (page_to_pfn(page) << PAGE_SHIFT)
 
 #  define ARCH_PFN_OFFSET	(memory_start >> PAGE_SHIFT)
-#  define pfn_valid(pfn)	((pfn) >= ARCH_PFN_OFFSET && (pfn) < (max_mapnr + ARCH_PFN_OFFSET))
 # endif /* __ASSEMBLY__ */
 
 #define	virt_addr_valid(vaddr)	(pfn_valid(virt_to_pfn(vaddr)))
--- a/arch/mips/include/asm/page.h~mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem
+++ a/arch/mips/include/asm/page.h
@@ -224,19 +224,6 @@ extern phys_addr_t __phys_addr_symbol(un
 
 #define pfn_to_kaddr(pfn)	__va((pfn) << PAGE_SHIFT)
 
-#ifdef CONFIG_FLATMEM
-
-static inline int pfn_valid(unsigned long pfn)
-{
-	/* avoid <linux/mm.h> include hell */
-	extern unsigned long max_mapnr;
-	unsigned long pfn_offset = ARCH_PFN_OFFSET;
-
-	return pfn >= pfn_offset && pfn < max_mapnr;
-}
-
-#endif
-
 #define virt_to_pfn(kaddr)   	PFN_DOWN(virt_to_phys((void *)(kaddr)))
 #define virt_to_page(kaddr)	pfn_to_page(virt_to_pfn(kaddr))
 
--- a/arch/nios2/include/asm/page.h~mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem
+++ a/arch/nios2/include/asm/page.h
@@ -86,15 +86,6 @@ extern struct page *mem_map;
 
 # define pfn_to_kaddr(pfn)	__va((pfn) << PAGE_SHIFT)
 
-static inline bool pfn_valid(unsigned long pfn)
-{
-	/* avoid <linux/mm.h> include hell */
-	extern unsigned long max_mapnr;
-	unsigned long pfn_offset = ARCH_PFN_OFFSET;
-
-	return pfn >= pfn_offset && pfn < max_mapnr;
-}
-
 # define virt_to_page(vaddr)	pfn_to_page(PFN_DOWN(virt_to_phys(vaddr)))
 # define virt_addr_valid(vaddr)	pfn_valid(PFN_DOWN(virt_to_phys(vaddr)))
 
--- a/arch/openrisc/include/asm/page.h~mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem
+++ a/arch/openrisc/include/asm/page.h
@@ -80,8 +80,6 @@ typedef struct page *pgtable_t;
 
 #define page_to_phys(page)      ((dma_addr_t)page_to_pfn(page) << PAGE_SHIFT)
 
-#define pfn_valid(pfn)          ((pfn) < max_mapnr)
-
 #define virt_addr_valid(kaddr)	(pfn_valid(virt_to_pfn(kaddr)))
 
 #endif /* __ASSEMBLY__ */
--- a/arch/parisc/include/asm/page.h~mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem
+++ a/arch/parisc/include/asm/page.h
@@ -155,10 +155,6 @@ extern int npmem_ranges;
 #define __pa(x)			((unsigned long)(x)-PAGE_OFFSET)
 #define __va(x)			((void *)((unsigned long)(x)+PAGE_OFFSET))
 
-#ifndef CONFIG_SPARSEMEM
-#define pfn_valid(pfn)		((pfn) < max_mapnr)
-#endif
-
 #ifdef CONFIG_HUGETLB_PAGE
 #define HPAGE_SHIFT		PMD_SHIFT /* fixed for transparent huge pages */
 #define HPAGE_SIZE      	((1UL) << HPAGE_SHIFT)
--- a/arch/powerpc/include/asm/page.h~mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem
+++ a/arch/powerpc/include/asm/page.h
@@ -117,15 +117,6 @@ extern long long virt_phys_offset;
 
 #ifdef CONFIG_FLATMEM
 #define ARCH_PFN_OFFSET		((unsigned long)(MEMORY_START >> PAGE_SHIFT))
-#ifndef __ASSEMBLY__
-extern unsigned long max_mapnr;
-static inline bool pfn_valid(unsigned long pfn)
-{
-	unsigned long min_pfn = ARCH_PFN_OFFSET;
-
-	return pfn >= min_pfn && pfn < max_mapnr;
-}
-#endif
 #endif
 
 #define virt_to_pfn(kaddr)	(__pa(kaddr) >> PAGE_SHIFT)
--- a/arch/riscv/include/asm/page.h~mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem
+++ a/arch/riscv/include/asm/page.h
@@ -171,11 +171,6 @@ extern phys_addr_t __phys_addr_symbol(un
 
 #define sym_to_pfn(x)           __phys_to_pfn(__pa_symbol(x))
 
-#ifdef CONFIG_FLATMEM
-#define pfn_valid(pfn) \
-	(((pfn) >= ARCH_PFN_OFFSET) && (((pfn) - ARCH_PFN_OFFSET) < max_mapnr))
-#endif
-
 #endif /* __ASSEMBLY__ */
 
 #define virt_addr_valid(vaddr)	({						\
--- a/arch/sh/include/asm/page.h~mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem
+++ a/arch/sh/include/asm/page.h
@@ -169,9 +169,6 @@ typedef struct page *pgtable_t;
 #define PFN_START		(__MEMORY_START >> PAGE_SHIFT)
 #define ARCH_PFN_OFFSET		(PFN_START)
 #define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
-#ifdef CONFIG_FLATMEM
-#define pfn_valid(pfn)		((pfn) >= min_low_pfn && (pfn) < max_low_pfn)
-#endif
 #define virt_addr_valid(kaddr)	pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
 
 #include <asm-generic/memory_model.h>
--- a/arch/sparc/include/asm/page_32.h~mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem
+++ a/arch/sparc/include/asm/page_32.h
@@ -130,7 +130,6 @@ extern unsigned long pfn_base;
 #define ARCH_PFN_OFFSET		(pfn_base)
 #define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
 
-#define pfn_valid(pfn)		(((pfn) >= (pfn_base)) && (((pfn)-(pfn_base)) < max_mapnr))
 #define virt_addr_valid(kaddr)	((((unsigned long)(kaddr)-PAGE_OFFSET)>>PAGE_SHIFT) < max_mapnr)
 
 #include <asm-generic/memory_model.h>
--- a/arch/um/include/asm/page.h~mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem
+++ a/arch/um/include/asm/page.h
@@ -108,7 +108,6 @@ extern unsigned long uml_physmem;
 #define phys_to_pfn(p) ((p) >> PAGE_SHIFT)
 #define pfn_to_phys(pfn) PFN_PHYS(pfn)
 
-#define pfn_valid(pfn) ((pfn) < max_mapnr)
 #define virt_addr_valid(v) pfn_valid(phys_to_pfn(__pa(v)))
 
 #include <asm-generic/memory_model.h>
--- a/arch/x86/include/asm/page_32.h~mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem
+++ a/arch/x86/include/asm/page_32.h
@@ -15,10 +15,6 @@ extern unsigned long __phys_addr(unsigne
 #define __phys_addr_symbol(x)	__phys_addr(x)
 #define __phys_reloc_hide(x)	RELOC_HIDE((x), 0)
 
-#ifdef CONFIG_FLATMEM
-#define pfn_valid(pfn)		((pfn) < max_mapnr)
-#endif /* CONFIG_FLATMEM */
-
 #include <linux/string.h>
 
 static inline void clear_page(void *page)
--- a/arch/x86/include/asm/page_64.h~mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem
+++ a/arch/x86/include/asm/page_64.h
@@ -39,10 +39,6 @@ extern unsigned long __phys_addr_symbol(
 
 #define __phys_reloc_hide(x)	(x)
 
-#ifdef CONFIG_FLATMEM
-#define pfn_valid(pfn)          ((pfn) < max_pfn)
-#endif
-
 void clear_page_orig(void *page);
 void clear_page_rep(void *page);
 void clear_page_erms(void *page);
--- a/arch/xtensa/include/asm/page.h~mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem
+++ a/arch/xtensa/include/asm/page.h
@@ -189,8 +189,6 @@ static inline unsigned long ___pa(unsign
 #endif
 #define __va(x)	\
 	((void *)((unsigned long) (x) - PHYS_OFFSET + PAGE_OFFSET))
-#define pfn_valid(pfn) \
-	((pfn) >= ARCH_PFN_OFFSET && ((pfn) - ARCH_PFN_OFFSET) < max_mapnr)
 
 #define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
 #define page_to_virt(page)	__va(page_to_pfn(page) << PAGE_SHIFT)
--- a/include/asm-generic/memory_model.h~mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem
+++ a/include/asm-generic/memory_model.h
@@ -19,6 +19,18 @@
 #define __page_to_pfn(page)	((unsigned long)((page) - mem_map) + \
 				 ARCH_PFN_OFFSET)
 
+#ifndef pfn_valid
+static inline int pfn_valid(unsigned long pfn)
+{
+	/* avoid <linux/mm.h> include hell */
+	extern unsigned long max_mapnr;
+	unsigned long pfn_offset = ARCH_PFN_OFFSET;
+
+	return pfn >= pfn_offset && pfn < max_mapnr;
+}
+#define pfn_valid pfn_valid
+#endif
+
 #elif defined(CONFIG_SPARSEMEM_VMEMMAP)
 
 /* memmap is virtually contiguous.  */
--- a/include/asm-generic/page.h~mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem
+++ a/include/asm-generic/page.h
@@ -84,8 +84,6 @@ extern unsigned long memory_end;
 #define page_to_phys(page)      ((dma_addr_t)page_to_pfn(page) << PAGE_SHIFT)
 #endif
 
-#define pfn_valid(pfn)		((pfn) >= ARCH_PFN_OFFSET && ((pfn) - ARCH_PFN_OFFSET) < max_mapnr)
-
 #define	virt_addr_valid(kaddr)	(((void *)(kaddr) >= (void *)PAGE_OFFSET) && \
 				((void *)(kaddr) < (void *)memory_end))
 
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-sparse-fix-unused-function-pgdat_to_phys-warning.patch
m68k-use-asm-generic-memory_modelh-for-both-mmu-and-mmu.patch
mips-drop-definition-of-pfn_valid-for-discontigmem.patch
mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem.patch

