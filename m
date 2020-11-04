Return-Path: <SRS0=Jp7A=EK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 762EAC388F7
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 00:57:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E41F2242A
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 00:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604451461;
	bh=UhwuxAfXqbjg4qeAYStShtsw0YiotRBUuspmODAsNWc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=VUWlZjKTfd94e9cLPMrE+YVLREoQbxmyAKoe2eWysBY5i/EE5ZaxlZT6bM6q6utWC
	 OCw2hteuCNU/3vlybhyXiiBI25iBqcNfh3OE97QkSeEasgG1wc9qSlHMhRcqWQOqMp
	 9zvdYHu9E/EtjDyXrhwI5ift47BcLC7siIKNj29I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730216AbgKDA5l (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Nov 2020 19:57:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:34880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730215AbgKDA5k (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Nov 2020 19:57:40 -0500
Received: from X1 (unknown [208.106.6.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 127E3223C7;
        Wed,  4 Nov 2020 00:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604451459;
        bh=UhwuxAfXqbjg4qeAYStShtsw0YiotRBUuspmODAsNWc=;
        h=Date:From:To:Subject:From;
        b=lh4alocoa2xeTDzjhUorJiQ6yfiz1nWX5jPVMADN4kKGPqR2PVaGheaK5QEeBwjxI
         1Qvw1d3Kog57IaCh88hdj/L0Zz0iyBkJzBs4T3MVaEcHQkPz9vpZWE9fzEyBvKdtae
         4qwmR/IcjUpRslrrc2SDHBai7uiefVkErD6+JyW4=
Date:   Tue, 03 Nov 2020 16:57:37 -0800
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
Subject:  + arch-mm-make-kernel_page_present-always-available.patch
 added to -mm tree
Message-ID: <20201104005737.tpgNf%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch, mm: make kernel_page_present() always available
has been added to the -mm tree.  Its filename is
     arch-mm-make-kernel_page_present-always-available.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arch-mm-make-kernel_page_present-always-available.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arch-mm-make-kernel_page_present-always-available.patch

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
Subject: arch, mm: make kernel_page_present() always available

For architectures that enable ARCH_HAS_SET_MEMORY having the ability to
verify that a page is mapped in the kernel direct map can be useful
regardless of hibernation.

Add RISC-V implementation of kernel_page_present(), update its forward
declarations and stubs to be a part of set_memory API and remove ugly
ifdefery in inlcude/linux/mm.h around current declarations of
kernel_page_present().

Link: https://lkml.kernel.org/r/20201103162057.22916-5-rppt@kernel.org
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
@@ -2925,16 +2925,9 @@ static inline void debug_pagealloc_map_p
 	if (debug_pagealloc_enabled_static())
 		__kernel_map_pages(page, numpages, enable);
 }
-
-#ifdef CONFIG_HIBERNATION
-extern bool kernel_page_present(struct page *page);
-#endif	/* CONFIG_HIBERNATION */
 #else	/* CONFIG_DEBUG_PAGEALLOC */
 static inline void debug_pagealloc_map_pages(struct page *page,
 					     int numpages, int enable) {}
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

mm-introduce-debug_pagealloc_map_pages-helper.patch
pm-hibernate-make-direct-map-manipulations-more-explicit.patch
arch-mm-restore-dependency-of-__kernel_map_pages-of-debug_pagealloc.patch
arch-mm-make-kernel_page_present-always-available.patch

