Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24BF3C2BBD4
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF50822D07
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgLOX7T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:59818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727966AbgLOXX2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:23:28 -0500
Date:   Tue, 15 Dec 2020 15:21:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074487;
        bh=WWbBL8j2T6jmTrxChgL45PoFLSWCKLXdRfg0xbrQ4sE=;
        h=From:To:Subject:From;
        b=JRi5PZJSa4BcL7RUMMYOHC28utaH+E0PvQM7awgAQRohPXOsr47+y4CzPpL6+eLgC
         5wpctFJMdbhcfLLQJGSpo/ifLcSrL4rX1f9TY9BLBNyO2zNijSbB9FGc7sBB5cfZxO
         s55hLGKJvEhUuLriE2kUy/xSlLNVTZvcYWMR68bg=
From:   akpm@linux-foundation.org
To:     aou@eecs.berkeley.edu, benh@kernel.crashing.org,
        borntraeger@de.ibm.com, bp@alien8.de, catalin.marinas@arm.com,
        cl@linux.com, dave.hansen@linux.intel.com, davem@davemloft.net,
        david@redhat.com, gor@linux.ibm.com, hca@linux.ibm.com,
        hpa@zytor.com, iamjoonsoo.kim@lge.com,
        kirill.shutemov@linux.intel.com, len.brown@intel.com,
        luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, palmer@dabbelt.com, paul.walmsley@sifive.com,
        paulus@samba.org, pavel@ucw.cz, penberg@kernel.org,
        peterz@infradead.org, rafael.j.wysocki@intel.com,
        rick.p.edgecombe@intel.com, rientjes@google.com, rjw@rjwysocki.net,
        rppt@linux.ibm.com, tglx@linutronix.de, vbabka@suse.cz,
        will@kernel.org
Subject:  [merged]
 arch-mm-make-kernel_page_present-always-available.patch removed from -mm
 tree
Message-ID: <20201215232125.p4-6Lgnwv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch, mm: make kernel_page_present() always available
has been removed from the -mm tree.  Its filename was
     arch-mm-make-kernel_page_present-always-available.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: arch, mm: make kernel_page_present() always available

For architectures that enable ARCH_HAS_SET_MEMORY having the ability to
verify that a page is mapped in the kernel direct map can be useful
regardless of hibernation.

Add RISC-V implementation of kernel_page_present(), update its forward
declarations and stubs to be a part of set_memory API and remove ugly
ifdefery in inlcude/linux/mm.h around current declarations of
kernel_page_present().

Link: https://lkml.kernel.org/r/20201109192128.960-5-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
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
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/cacheflush.h |    1 
 arch/arm64/mm/pageattr.c            |    4 ---
 arch/riscv/include/asm/set_memory.h |    1 
 arch/riscv/mm/pageattr.c            |   29 ++++++++++++++++++++++++++
 arch/x86/include/asm/set_memory.h   |    1 
 arch/x86/mm/pat/set_memory.c        |    4 ---
 include/linux/mm.h                  |    7 ------
 include/linux/set_memory.h          |    5 ++++
 8 files changed, 39 insertions(+), 13 deletions(-)

--- a/arch/arm64/include/asm/cacheflush.h~arch-mm-make-kernel_page_present-always-available
+++ a/arch/arm64/include/asm/cacheflush.h
@@ -140,6 +140,7 @@ int set_memory_valid(unsigned long addr,
 
 int set_direct_map_invalid_noflush(struct page *page);
 int set_direct_map_default_noflush(struct page *page);
+bool kernel_page_present(struct page *page);
 
 #include <asm-generic/cacheflush.h>
 
--- a/arch/arm64/mm/pageattr.c~arch-mm-make-kernel_page_present-always-available
+++ a/arch/arm64/mm/pageattr.c
@@ -186,8 +186,8 @@ void __kernel_map_pages(struct page *pag
 
 	set_memory_valid((unsigned long)page_address(page), numpages, enable);
 }
+#endif /* CONFIG_DEBUG_PAGEALLOC */
 
-#ifdef CONFIG_HIBERNATION
 /*
  * This function is used to determine if a linear map page has been marked as
  * not-valid. Walk the page table and check the PTE_VALID bit. This is based
@@ -234,5 +234,3 @@ bool kernel_page_present(struct page *pa
 	ptep = pte_offset_kernel(pmdp, addr);
 	return pte_valid(READ_ONCE(*ptep));
 }
-#endif /* CONFIG_HIBERNATION */
-#endif /* CONFIG_DEBUG_PAGEALLOC */
--- a/arch/riscv/include/asm/set_memory.h~arch-mm-make-kernel_page_present-always-available
+++ a/arch/riscv/include/asm/set_memory.h
@@ -24,6 +24,7 @@ static inline int set_memory_nx(unsigned
 
 int set_direct_map_invalid_noflush(struct page *page);
 int set_direct_map_default_noflush(struct page *page);
+bool kernel_page_present(struct page *page);
 
 #endif /* __ASSEMBLY__ */
 
--- a/arch/riscv/mm/pageattr.c~arch-mm-make-kernel_page_present-always-available
+++ a/arch/riscv/mm/pageattr.c
@@ -198,3 +198,32 @@ void __kernel_map_pages(struct page *pag
 			     __pgprot(0), __pgprot(_PAGE_PRESENT));
 }
 #endif
+
+bool kernel_page_present(struct page *page)
+{
+	unsigned long addr = (unsigned long)page_address(page);
+	pgd_t *pgd;
+	pud_t *pud;
+	p4d_t *p4d;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	pgd = pgd_offset_k(addr);
+	if (!pgd_present(*pgd))
+		return false;
+
+	p4d = p4d_offset(pgd, addr);
+	if (!p4d_present(*p4d))
+		return false;
+
+	pud = pud_offset(p4d, addr);
+	if (!pud_present(*pud))
+		return false;
+
+	pmd = pmd_offset(pud, addr);
+	if (!pmd_present(*pmd))
+		return false;
+
+	pte = pte_offset_kernel(pmd, addr);
+	return pte_present(*pte);
+}
--- a/arch/x86/include/asm/set_memory.h~arch-mm-make-kernel_page_present-always-available
+++ a/arch/x86/include/asm/set_memory.h
@@ -82,6 +82,7 @@ int set_pages_rw(struct page *page, int
 
 int set_direct_map_invalid_noflush(struct page *page);
 int set_direct_map_default_noflush(struct page *page);
+bool kernel_page_present(struct page *page);
 
 extern int kernel_set_to_readonly;
 
--- a/arch/x86/mm/pat/set_memory.c~arch-mm-make-kernel_page_present-always-available
+++ a/arch/x86/mm/pat/set_memory.c
@@ -2226,8 +2226,8 @@ void __kernel_map_pages(struct page *pag
 
 	arch_flush_lazy_mmu_mode();
 }
+#endif /* CONFIG_DEBUG_PAGEALLOC */
 
-#ifdef CONFIG_HIBERNATION
 bool kernel_page_present(struct page *page)
 {
 	unsigned int level;
@@ -2239,8 +2239,6 @@ bool kernel_page_present(struct page *pa
 	pte = lookup_address((unsigned long)page_address(page), &level);
 	return (pte_val(*pte) & _PAGE_PRESENT);
 }
-#endif /* CONFIG_HIBERNATION */
-#endif /* CONFIG_DEBUG_PAGEALLOC */
 
 int __init kernel_map_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long address,
 				   unsigned numpages, unsigned long page_flags)
--- a/include/linux/mm.h~arch-mm-make-kernel_page_present-always-available
+++ a/include/linux/mm.h
@@ -2949,16 +2949,9 @@ static inline void debug_pagealloc_unmap
 	if (debug_pagealloc_enabled_static())
 		__kernel_map_pages(page, numpages, 0);
 }
-
-#ifdef CONFIG_HIBERNATION
-extern bool kernel_page_present(struct page *page);
-#endif	/* CONFIG_HIBERNATION */
 #else	/* CONFIG_DEBUG_PAGEALLOC */
 static inline void debug_pagealloc_map_pages(struct page *page, int numpages) {}
 static inline void debug_pagealloc_unmap_pages(struct page *page, int numpages) {}
-#ifdef CONFIG_HIBERNATION
-static inline bool kernel_page_present(struct page *page) { return true; }
-#endif	/* CONFIG_HIBERNATION */
 #endif	/* CONFIG_DEBUG_PAGEALLOC */
 
 #ifdef __HAVE_ARCH_GATE_AREA
--- a/include/linux/set_memory.h~arch-mm-make-kernel_page_present-always-available
+++ a/include/linux/set_memory.h
@@ -23,6 +23,11 @@ static inline int set_direct_map_default
 {
 	return 0;
 }
+
+static inline bool kernel_page_present(struct page *page)
+{
+	return true;
+}
 #endif
 
 #ifndef set_mce_nospec
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-memblock-enforce-overlap-of-memorymemblock-and-memoryreserved.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout.patch
mm-add-definition-of-pmd_page_order.patch
mmap-make-mlock_future_check-global.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages.patch
set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
secretmem-use-pmd-size-pages-to-amortize-direct-map-fragmentation.patch
secretmem-add-memcg-accounting.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch

