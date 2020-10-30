Return-Path: <SRS0=SeUK=EF=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8200EC2D0A3
	for <mm-commits@archiver.kernel.org>; Fri, 30 Oct 2020 01:13:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 252C220747
	for <mm-commits@archiver.kernel.org>; Fri, 30 Oct 2020 01:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604020430;
	bh=pCacJBFWNtFP45Vp1IHGTKez9DfU1WeJvcnpx+CQoGM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=c6GkTFdjfafBtY0iOsbbw3qjcfoccol/P1IHhsJ8ZbGRBW4buDwf8ZmjEWJ211y3Z
	 mTcjgDvQvPjWwxPHCZbGJbHNl7Sn5PcQ0HbIOuM3TSbQiCEvqp+O3kP44hfAyCaDhD
	 /ZfU6RmKUg9yXLIX0ITSN55eGKmV4jVnKUlzEvFc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbgJ3BNt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Oct 2020 21:13:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:44270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725771AbgJ3BNt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 29 Oct 2020 21:13:49 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 640BA2072C;
        Fri, 30 Oct 2020 01:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604020428;
        bh=pCacJBFWNtFP45Vp1IHGTKez9DfU1WeJvcnpx+CQoGM=;
        h=Date:From:To:Subject:From;
        b=o37ZK7oct0g90aaBjfZOOKYIs7sK6p4mompkJz/pYeqT1VBuCaRJaxb7phJdRpzrF
         +F4eYklo/mZJLozvqxFubqC84UoKllcki10O2COJ74zAKIdK5L61K5I1YZ67NabpEg
         Zg0+EXE41Bbj1ay/PR/eU5urMVGervAwraUGr0Vo=
Date:   Thu, 29 Oct 2020 18:13:45 -0700
From:   akpm@linux-foundation.org
To:     aou@eecs.berkeley.edu, benh@kernel.crashing.org,
        borntraeger@de.ibm.com, bp@alien8.de, catalin.marinas@arm.com,
        cl@linux.com, dave.hansen@linux.intel.com, davem@davemloft.net,
        david@redhat.com, gor@linux.ibm.com, hca@linux.ibm.com,
        hpa@zytor.com, iamjoonsoo.kim@lge.com, kirill@shutemov.name,
        len.brown@intel.com, luto@kernel.org, mingo@redhat.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, palmer@dabbelt.com,
        paul.walmsley@sifive.com, paulus@samba.org, pavel@ucw.cz,
        penberg@kernel.org, peterz@infradead.org,
        rafael.j.wysocki@intel.com, rick.p.edgecombe@intel.com,
        rientjes@google.com, rjw@rjwysocki.net, rppt@linux.ibm.com,
        tglx@linutronix.de, will@kernel.org
Subject:  + arch-mm-make-kernel_page_present-always-available.patch
 added to -mm tree
Message-ID: <20201030011345.0Yf_8PZj9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
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

Link: https://lkml.kernel.org/r/20201029161902.19272-5-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Len Brown <len.brown@intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/cacheflush.h |    1 
 arch/riscv/include/asm/set_memory.h |    1 
 arch/riscv/mm/pageattr.c            |   29 ++++++++++++++++++++++++++
 arch/x86/include/asm/set_memory.h   |    1 
 arch/x86/mm/pat/set_memory.c        |    2 -
 include/linux/mm.h                  |    7 ------
 include/linux/set_memory.h          |    5 ++++
 7 files changed, 37 insertions(+), 9 deletions(-)

--- a/arch/arm64/include/asm/cacheflush.h~arch-mm-make-kernel_page_present-always-available
+++ a/arch/arm64/include/asm/cacheflush.h
@@ -140,6 +140,7 @@ int set_memory_valid(unsigned long addr,
 
 int set_direct_map_invalid_noflush(struct page *page);
 int set_direct_map_default_noflush(struct page *page);
+bool kernel_page_present(struct page *page);
 
 #include <asm-generic/cacheflush.h>
 
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
@@ -2228,7 +2228,6 @@ void __kernel_map_pages(struct page *pag
 }
 #endif /* CONFIG_DEBUG_PAGEALLOC */
 
-#ifdef CONFIG_HIBERNATION
 bool kernel_page_present(struct page *page)
 {
 	unsigned int level;
@@ -2240,7 +2239,6 @@ bool kernel_page_present(struct page *pa
 	pte = lookup_address((unsigned long)page_address(page), &level);
 	return (pte_val(*pte) & _PAGE_PRESENT);
 }
-#endif /* CONFIG_HIBERNATION */
 
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

