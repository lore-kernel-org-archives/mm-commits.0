Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 753E1C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:51:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A01A61474
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:51:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238473AbhGABxu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:53:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:43376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238468AbhGABxu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:53:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 133346105A;
        Thu,  1 Jul 2021 01:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104280;
        bh=YYTDxqTLO8oAwMJ92YvzyVaLGdGA6vqLkJ2NZzliz7U=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xIyumq6JDdZC3dSAHPq+NdsaXjY+RE1BjQWbgDi0eI1mlOYAar3MtcHYSvOFtNrzy
         BE+Q4r6/50UeWNGRXPgmNjz9rhUbAYcDYCFmfmBNJiUMPoyMx2MOE9I3ShJU/KDi6F
         IXYwkgpuV4dS6qpoyG4ueNX7wY3bvSKzkMzhAICk=
Date:   Wed, 30 Jun 2021 18:51:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        ardb@kernel.org, catalin.marinas@arm.com, david@redhat.com,
        linux-mm@kvack.org, mark.rutland@arm.com, maz@kernel.org,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, wangkefeng.wang@huawei.com,
        will@kernel.org
Subject:  [patch 078/192] arm64: decouple check whether pfn is in
 linear map from pfn_valid()
Message-ID: <20210701015119.-TOEhD-PZ%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: arm64: decouple check whether pfn is in linear map from pfn_valid()

The intended semantics of pfn_valid() is to verify whether there is a
struct page for the pfn in question and nothing else.

Yet, on arm64 it is used to distinguish memory areas that are mapped in
the linear map vs those that require ioremap() to access them.

Introduce a dedicated pfn_is_map_memory() wrapper for
memblock_is_map_memory() to perform such check and use it where
appropriate.

Using a wrapper allows to avoid cyclic include dependencies.

While here also update style of pfn_valid() so that both pfn_valid() and
pfn_is_map_memory() declarations will be consistent.

Link: https://lkml.kernel.org/r/20210511100550.28178-4-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/memory.h |    2 +-
 arch/arm64/include/asm/page.h   |    3 ++-
 arch/arm64/kvm/mmu.c            |    2 +-
 arch/arm64/mm/init.c            |   12 ++++++++++++
 arch/arm64/mm/ioremap.c         |    4 ++--
 arch/arm64/mm/mmu.c             |    2 +-
 6 files changed, 19 insertions(+), 6 deletions(-)

--- a/arch/arm64/include/asm/memory.h~arm64-decouple-check-whether-pfn-is-in-linear-map-from-pfn_valid
+++ a/arch/arm64/include/asm/memory.h
@@ -369,7 +369,7 @@ static inline void *phys_to_virt(phys_ad
 
 #define virt_addr_valid(addr)	({					\
 	__typeof__(addr) __addr = __tag_reset(addr);			\
-	__is_lm_address(__addr) && pfn_valid(virt_to_pfn(__addr));	\
+	__is_lm_address(__addr) && pfn_is_map_memory(virt_to_pfn(__addr));	\
 })
 
 void dump_mem_limit(void);
--- a/arch/arm64/include/asm/page.h~arm64-decouple-check-whether-pfn-is-in-linear-map-from-pfn_valid
+++ a/arch/arm64/include/asm/page.h
@@ -37,7 +37,8 @@ void copy_highpage(struct page *to, stru
 
 typedef struct page *pgtable_t;
 
-extern int pfn_valid(unsigned long);
+int pfn_valid(unsigned long pfn);
+int pfn_is_map_memory(unsigned long pfn);
 
 #include <asm/memory.h>
 
--- a/arch/arm64/kvm/mmu.c~arm64-decouple-check-whether-pfn-is-in-linear-map-from-pfn_valid
+++ a/arch/arm64/kvm/mmu.c
@@ -85,7 +85,7 @@ void kvm_flush_remote_tlbs(struct kvm *k
 
 static bool kvm_is_device_pfn(unsigned long pfn)
 {
-	return !pfn_valid(pfn);
+	return !pfn_is_map_memory(pfn);
 }
 
 static void *stage2_memcache_zalloc_page(void *arg)
--- a/arch/arm64/mm/init.c~arm64-decouple-check-whether-pfn-is-in-linear-map-from-pfn_valid
+++ a/arch/arm64/mm/init.c
@@ -256,6 +256,18 @@ int pfn_valid(unsigned long pfn)
 }
 EXPORT_SYMBOL(pfn_valid);
 
+int pfn_is_map_memory(unsigned long pfn)
+{
+	phys_addr_t addr = PFN_PHYS(pfn);
+
+	/* avoid false positives for bogus PFNs, see comment in pfn_valid() */
+	if (PHYS_PFN(addr) != pfn)
+		return 0;
+
+	return memblock_is_map_memory(addr);
+}
+EXPORT_SYMBOL(pfn_is_map_memory);
+
 static phys_addr_t memory_limit = PHYS_ADDR_MAX;
 
 /*
--- a/arch/arm64/mm/ioremap.c~arm64-decouple-check-whether-pfn-is-in-linear-map-from-pfn_valid
+++ a/arch/arm64/mm/ioremap.c
@@ -43,7 +43,7 @@ static void __iomem *__ioremap_caller(ph
 	/*
 	 * Don't allow RAM to be mapped.
 	 */
-	if (WARN_ON(pfn_valid(__phys_to_pfn(phys_addr))))
+	if (WARN_ON(pfn_is_map_memory(__phys_to_pfn(phys_addr))))
 		return NULL;
 
 	area = get_vm_area_caller(size, VM_IOREMAP, caller);
@@ -84,7 +84,7 @@ EXPORT_SYMBOL(iounmap);
 void __iomem *ioremap_cache(phys_addr_t phys_addr, size_t size)
 {
 	/* For normal memory we already have a cacheable mapping. */
-	if (pfn_valid(__phys_to_pfn(phys_addr)))
+	if (pfn_is_map_memory(__phys_to_pfn(phys_addr)))
 		return (void __iomem *)__phys_to_virt(phys_addr);
 
 	return __ioremap_caller(phys_addr, size, __pgprot(PROT_NORMAL),
--- a/arch/arm64/mm/mmu.c~arm64-decouple-check-whether-pfn-is-in-linear-map-from-pfn_valid
+++ a/arch/arm64/mm/mmu.c
@@ -82,7 +82,7 @@ void set_swapper_pgd(pgd_t *pgdp, pgd_t
 pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 			      unsigned long size, pgprot_t vma_prot)
 {
-	if (!pfn_valid(pfn))
+	if (!pfn_is_map_memory(pfn))
 		return pgprot_noncached(vma_prot);
 	else if (file->f_flags & O_SYNC)
 		return pgprot_writecombine(vma_prot);
_
