Return-Path: <SRS0=Jp7A=EK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 751D0C2D0A3
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 00:57:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C64222409
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 00:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604451456;
	bh=xHro5c1UXZU11DrLATD2MEurWggQSLwsXxCioMxFnTw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=o4MJzWWTiMXTPRN9booao2s4K8qT/alkc7dhTiaWo9FyPONMf9eWyPCxY8msxzQNC
	 QpG8DAFFMud/NSSAdPO7lP15tlUTN7LvJnCbP7kSczWFxM/oP/NmsQq6yofLtwPsXq
	 lvj2Yfk5dtbgUi1BwnvxNAenPMFDd3FVVs0HqA34=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730213AbgKDA5f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Nov 2020 19:57:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:34744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728157AbgKDA5f (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Nov 2020 19:57:35 -0500
Received: from X1 (unknown [208.106.6.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18F8F22404;
        Wed,  4 Nov 2020 00:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604451454;
        bh=xHro5c1UXZU11DrLATD2MEurWggQSLwsXxCioMxFnTw=;
        h=Date:From:To:Subject:From;
        b=p5QRxeuqzrw4ispTBjMCD1tA7zUlQGJ4c5BKnDHqL1RbqvX0QCgjfkeNZnCkYfqC1
         N7OjvILRoAoaw8551TyBEjivvTOzCcgWza4fqlpPhimZpAyDgEp/KYnGr7wqxWj7Sx
         D7wTT4pQFn9ZAyjdLlQybtSQDwBAKxswVt3VYWgY=
Date:   Tue, 03 Nov 2020 16:57:31 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org, tglx@linutronix.de,
        rjw@rjwysocki.net, rientjes@google.com, rick.p.edgecombe@intel.com,
        rafael.j.wysocki@intel.com, peterz@infradead.org,
        penberg@kernel.org, pavel@ucw.cz, paul.walmsley@sifive.com,
        paulus@samba.org, palmer@dabbelt.com, mpe@ellerman.id.au,
        mingo@redhat.com, luto@kernel.org, len.brown@intel.com,
        kirill.shutemov@linux.intel.com, iamjoonsoo.kim@lge.com,
        hpa@zytor.com, hca@linux.ibm.com, gor@linux.ibm.com,
        david@redhat.com, davem@davemloft.net, dave.hansen@linux.intel.com,
        cl@linux.com, catalin.marinas@arm.com, bp@alien8.de,
        borntraeger@de.ibm.com, benh@kernel.crashing.org,
        aou@eecs.berkeley.edu, rppt@linux.ibm.com
Subject:  +
 arch-mm-restore-dependency-of-__kernel_map_pages-of-debug_pagealloc.patch
 added to -mm tree
Message-ID: <20201104005731.muzRk%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch, mm: restore dependency of __kernel_map_pages() of DEBUG_PAGEALLOC
has been added to the -mm tree.  Its filename is
     arch-mm-restore-dependency-of-__kernel_map_pages-of-debug_pagealloc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arch-mm-restore-dependency-of-__kernel_map_pages-of-debug_pagealloc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arch-mm-restore-dependency-of-__kernel_map_pages-of-debug_pagealloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: arch, mm: restore dependency of __kernel_map_pages() of DEBUG_PAGEALLOC

The design of DEBUG_PAGEALLOC presumes that __kernel_map_pages() must
never fail.  With this assumption is wouldn't be safe to allow general
usage of this function.

Moreover, some architectures that implement __kernel_map_pages() have this
function guarded by #ifdef DEBUG_PAGEALLOC and some refuse to map/unmap
pages when page allocation debugging is disabled at runtime.

As all the users of __kernel_map_pages() were converted to use
debug_pagealloc_map_pages() it is safe to make it available only when
DEBUG_PAGEALLOC is set.

Link: https://lkml.kernel.org/r/20201103162057.22916-4-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig                     |    3 +++
 arch/arm64/Kconfig               |    4 +---
 arch/arm64/mm/pageattr.c         |    8 ++++++--
 arch/powerpc/Kconfig             |    5 +----
 arch/riscv/Kconfig               |    4 +---
 arch/riscv/include/asm/pgtable.h |    2 --
 arch/riscv/mm/pageattr.c         |    2 ++
 arch/s390/Kconfig                |    4 +---
 arch/sparc/Kconfig               |    4 +---
 arch/x86/Kconfig                 |    4 +---
 arch/x86/mm/pat/set_memory.c     |    2 ++
 include/linux/mm.h               |   10 +++++++---
 12 files changed, 26 insertions(+), 26 deletions(-)

--- a/arch/arm64/Kconfig~arch-mm-restore-dependency-of-__kernel_map_pages-of-debug_pagealloc
+++ a/arch/arm64/Kconfig
@@ -71,6 +71,7 @@ config ARM64
 	select ARCH_USE_QUEUED_RWLOCKS
 	select ARCH_USE_QUEUED_SPINLOCKS
 	select ARCH_USE_SYM_ANNOTATIONS
+	select ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	select ARCH_SUPPORTS_MEMORY_FAILURE
 	select ARCH_SUPPORTS_SHADOW_CALL_STACK if CC_HAVE_SHADOW_CALL_STACK
 	select ARCH_SUPPORTS_ATOMIC_RMW
@@ -1026,9 +1027,6 @@ config HOLES_IN_ZONE
 
 source "kernel/Kconfig.hz"
 
-config ARCH_SUPPORTS_DEBUG_PAGEALLOC
-	def_bool y
-
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
 	select SPARSEMEM_VMEMMAP_ENABLE
--- a/arch/arm64/mm/pageattr.c~arch-mm-restore-dependency-of-__kernel_map_pages-of-debug_pagealloc
+++ a/arch/arm64/mm/pageattr.c
@@ -155,7 +155,7 @@ int set_direct_map_invalid_noflush(struc
 		.clear_mask = __pgprot(PTE_VALID),
 	};
 
-	if (!rodata_full)
+	if (!debug_pagealloc_enabled() && !rodata_full)
 		return 0;
 
 	return apply_to_page_range(&init_mm,
@@ -170,7 +170,7 @@ int set_direct_map_default_noflush(struc
 		.clear_mask = __pgprot(PTE_RDONLY),
 	};
 
-	if (!rodata_full)
+	if (!debug_pagealloc_enabled() && !rodata_full)
 		return 0;
 
 	return apply_to_page_range(&init_mm,
@@ -178,6 +178,7 @@ int set_direct_map_default_noflush(struc
 				   PAGE_SIZE, change_page_range, &data);
 }
 
+#ifdef CONFIG_DEBUG_PAGEALLOC
 void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
 	if (!debug_pagealloc_enabled() && !rodata_full)
@@ -186,6 +187,7 @@ void __kernel_map_pages(struct page *pag
 	set_memory_valid((unsigned long)page_address(page), numpages, enable);
 }
 
+#ifdef CONFIG_HIBERNATION
 /*
  * This function is used to determine if a linear map page has been marked as
  * not-valid. Walk the page table and check the PTE_VALID bit. This is based
@@ -232,3 +234,5 @@ bool kernel_page_present(struct page *pa
 	ptep = pte_offset_kernel(pmdp, addr);
 	return pte_valid(READ_ONCE(*ptep));
 }
+#endif /* CONFIG_HIBERNATION */
+#endif /* CONFIG_DEBUG_PAGEALLOC */
--- a/arch/Kconfig~arch-mm-restore-dependency-of-__kernel_map_pages-of-debug_pagealloc
+++ a/arch/Kconfig
@@ -1035,6 +1035,9 @@ config HAVE_STATIC_CALL_INLINE
 	bool
 	depends on HAVE_STATIC_CALL
 
+config ARCH_SUPPORTS_DEBUG_PAGEALLOC
+	bool
+
 source "kernel/gcov/Kconfig"
 
 source "scripts/gcc-plugins/Kconfig"
--- a/arch/powerpc/Kconfig~arch-mm-restore-dependency-of-__kernel_map_pages-of-debug_pagealloc
+++ a/arch/powerpc/Kconfig
@@ -146,6 +146,7 @@ config PPC
 	select ARCH_MIGHT_HAVE_PC_SERIO
 	select ARCH_OPTIONAL_KERNEL_RWX		if ARCH_HAS_STRICT_KERNEL_RWX
 	select ARCH_SUPPORTS_ATOMIC_RMW
+	select ARCH_SUPPORTS_DEBUG_PAGEALLOC	if PPC32 || PPC_BOOK3S_64
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_CMPXCHG_LOCKREF		if PPC64
 	select ARCH_USE_QUEUED_RWLOCKS		if PPC_QUEUED_SPINLOCKS
@@ -355,10 +356,6 @@ config PPC_OF_PLATFORM_PCI
 	depends on PCI
 	depends on PPC64 # not supported on 32 bits yet
 
-config ARCH_SUPPORTS_DEBUG_PAGEALLOC
-	depends on PPC32 || PPC_BOOK3S_64
-	def_bool y
-
 config ARCH_SUPPORTS_UPROBES
 	def_bool y
 
--- a/arch/riscv/include/asm/pgtable.h~arch-mm-restore-dependency-of-__kernel_map_pages-of-debug_pagealloc
+++ a/arch/riscv/include/asm/pgtable.h
@@ -461,8 +461,6 @@ static inline int ptep_clear_flush_young
 #define VMALLOC_START		0
 #define VMALLOC_END		TASK_SIZE
 
-static inline void __kernel_map_pages(struct page *page, int numpages, int enable) {}
-
 #endif /* !CONFIG_MMU */
 
 #define kern_addr_valid(addr)   (1) /* FIXME */
--- a/arch/riscv/Kconfig~arch-mm-restore-dependency-of-__kernel_map_pages-of-debug_pagealloc
+++ a/arch/riscv/Kconfig
@@ -14,6 +14,7 @@ config RISCV
 	def_bool y
 	select ARCH_CLOCKSOURCE_INIT
 	select ARCH_SUPPORTS_ATOMIC_RMW
+	select ARCH_SUPPORTS_DEBUG_PAGEALLOC if MMU
 	select ARCH_HAS_BINFMT_FLAT
 	select ARCH_HAS_DEBUG_VM_PGTABLE
 	select ARCH_HAS_DEBUG_VIRTUAL if MMU
@@ -153,9 +154,6 @@ config ARCH_SELECT_MEMORY_MODEL
 config ARCH_WANT_GENERAL_HUGETLB
 	def_bool y
 
-config ARCH_SUPPORTS_DEBUG_PAGEALLOC
-	def_bool y
-
 config SYS_SUPPORTS_HUGETLBFS
 	depends on MMU
 	def_bool y
--- a/arch/riscv/mm/pageattr.c~arch-mm-restore-dependency-of-__kernel_map_pages-of-debug_pagealloc
+++ a/arch/riscv/mm/pageattr.c
@@ -184,6 +184,7 @@ int set_direct_map_default_noflush(struc
 	return ret;
 }
 
+#ifdef CONFIG_DEBUG_PAGEALLOC
 void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
 	if (!debug_pagealloc_enabled())
@@ -196,3 +197,4 @@ void __kernel_map_pages(struct page *pag
 		__set_memory((unsigned long)page_address(page), numpages,
 			     __pgprot(0), __pgprot(_PAGE_PRESENT));
 }
+#endif
--- a/arch/s390/Kconfig~arch-mm-restore-dependency-of-__kernel_map_pages-of-debug_pagealloc
+++ a/arch/s390/Kconfig
@@ -35,9 +35,6 @@ config GENERIC_LOCKBREAK
 config PGSTE
 	def_bool y if KVM
 
-config ARCH_SUPPORTS_DEBUG_PAGEALLOC
-	def_bool y
-
 config AUDIT_ARCH
 	def_bool y
 
@@ -106,6 +103,7 @@ config S390
 	select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
 	select ARCH_STACKWALK
 	select ARCH_SUPPORTS_ATOMIC_RMW
+	select ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	select ARCH_SUPPORTS_NUMA_BALANCING
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_CMPXCHG_LOCKREF
--- a/arch/sparc/Kconfig~arch-mm-restore-dependency-of-__kernel_map_pages-of-debug_pagealloc
+++ a/arch/sparc/Kconfig
@@ -88,6 +88,7 @@ config SPARC64
 	select HAVE_C_RECORDMCOUNT
 	select HAVE_ARCH_AUDITSYSCALL
 	select ARCH_SUPPORTS_ATOMIC_RMW
+	select ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	select HAVE_NMI
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select ARCH_USE_QUEUED_RWLOCKS
@@ -148,9 +149,6 @@ config GENERIC_ISA_DMA
 	bool
 	default y if SPARC32
 
-config ARCH_SUPPORTS_DEBUG_PAGEALLOC
-	def_bool y if SPARC64
-
 config PGTABLE_LEVELS
 	default 4 if 64BIT
 	default 3
--- a/arch/x86/Kconfig~arch-mm-restore-dependency-of-__kernel_map_pages-of-debug_pagealloc
+++ a/arch/x86/Kconfig
@@ -91,6 +91,7 @@ config X86
 	select ARCH_STACKWALK
 	select ARCH_SUPPORTS_ACPI
 	select ARCH_SUPPORTS_ATOMIC_RMW
+	select ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	select ARCH_SUPPORTS_NUMA_BALANCING	if X86_64
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_QUEUED_RWLOCKS
@@ -330,9 +331,6 @@ config ZONE_DMA32
 config AUDIT_ARCH
 	def_bool y if X86_64
 
-config ARCH_SUPPORTS_DEBUG_PAGEALLOC
-	def_bool y
-
 config KASAN_SHADOW_OFFSET
 	hex
 	depends on KASAN
--- a/arch/x86/mm/pat/set_memory.c~arch-mm-restore-dependency-of-__kernel_map_pages-of-debug_pagealloc
+++ a/arch/x86/mm/pat/set_memory.c
@@ -2194,6 +2194,7 @@ int set_direct_map_default_noflush(struc
 	return __set_pages_p(page, 1);
 }
 
+#ifdef CONFIG_DEBUG_PAGEALLOC
 void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
 	if (PageHighMem(page))
@@ -2239,6 +2240,7 @@ bool kernel_page_present(struct page *pa
 	return (pte_val(*pte) & _PAGE_PRESENT);
 }
 #endif /* CONFIG_HIBERNATION */
+#endif /* CONFIG_DEBUG_PAGEALLOC */
 
 int __init kernel_map_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long address,
 				   unsigned numpages, unsigned long page_flags)
--- a/include/linux/mm.h~arch-mm-restore-dependency-of-__kernel_map_pages-of-debug_pagealloc
+++ a/include/linux/mm.h
@@ -2912,7 +2912,11 @@ static inline bool debug_pagealloc_enabl
 	return static_branch_unlikely(&_debug_pagealloc_enabled);
 }
 
-#if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_ARCH_HAS_SET_DIRECT_MAP)
+#ifdef CONFIG_DEBUG_PAGEALLOC
+/*
+ * To support DEBUG_PAGEALLOC architecture must ensure that
+ * __kernel_map_pages() never fails
+ */
 extern void __kernel_map_pages(struct page *page, int numpages, int enable);
 
 static inline void debug_pagealloc_map_pages(struct page *page,
@@ -2925,13 +2929,13 @@ static inline void debug_pagealloc_map_p
 #ifdef CONFIG_HIBERNATION
 extern bool kernel_page_present(struct page *page);
 #endif	/* CONFIG_HIBERNATION */
-#else	/* CONFIG_DEBUG_PAGEALLOC || CONFIG_ARCH_HAS_SET_DIRECT_MAP */
+#else	/* CONFIG_DEBUG_PAGEALLOC */
 static inline void debug_pagealloc_map_pages(struct page *page,
 					     int numpages, int enable) {}
 #ifdef CONFIG_HIBERNATION
 static inline bool kernel_page_present(struct page *page) { return true; }
 #endif	/* CONFIG_HIBERNATION */
-#endif	/* CONFIG_DEBUG_PAGEALLOC || CONFIG_ARCH_HAS_SET_DIRECT_MAP */
+#endif	/* CONFIG_DEBUG_PAGEALLOC */
 
 #ifdef __HAVE_ARCH_GATE_AREA
 extern struct vm_area_struct *get_gate_vma(struct mm_struct *mm);
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-introduce-debug_pagealloc_map_pages-helper.patch
pm-hibernate-make-direct-map-manipulations-more-explicit.patch
arch-mm-restore-dependency-of-__kernel_map_pages-of-debug_pagealloc.patch
arch-mm-make-kernel_page_present-always-available.patch

