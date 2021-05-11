Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5C35C433B4
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 23:40:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A957461433
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 23:40:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbhEKXlK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 May 2021 19:41:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:57900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229637AbhEKXlJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 May 2021 19:41:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED8186188B;
        Tue, 11 May 2021 23:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620776401;
        bh=YsvAPynYWPfmNWf8LWPc/hYEPJSsKUnsM3K+gZTneTM=;
        h=Date:From:To:Subject:From;
        b=1Cgk0fsZ8zA0B5STsyXNa3X/lZnj8528J66x6jEVZehWkc74xOP/fPpSFQFVmqU1j
         TsRJCVoeqBdFRvWiLi9E/1fKZUBT9oaI+Ha8PTboJtd5FfNmbwsdZd2lFdS46Sw6HI
         38oVeYrCsB5NPGKTNtQaQ5icXlhRzhLSzNnMnTHg=
Date:   Tue, 11 May 2021 16:40:00 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, ardb@kernel.org,
        catalin.marinas@arm.com, david@redhat.com, mark.rutland@arm.com,
        maz@kernel.org, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        will@kernel.org
Subject:  +
 arm64-decouple-check-whether-pfn-is-in-linear-map-from-pfn_valid.patch
 added to -mm tree
Message-ID: <20210511234000.zGOHts6nd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: decouple check whether pfn is in linear map from pfn_valid()
has been added to the -mm tree.  Its filename is
     arm64-decouple-check-whether-pfn-is-in-linear-map-from-pfn_valid.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arm64-decouple-check-whether-pfn-is-in-linear-map-from-pfn_valid.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arm64-decouple-check-whether-pfn-is-in-linear-map-from-pfn_valid.patch

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
@@ -255,6 +255,18 @@ int pfn_valid(unsigned long pfn)
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

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-mmzoneh-simplify-is_highmem_idx.patch
docs-procrst-meminfo-briefly-describe-gaps-in-memory-accounting.patch
include-linux-mmzoneh-add-documentation-for-pfn_valid.patch
memblock-update-initialization-of-reserved-pages.patch
arm64-decouple-check-whether-pfn-is-in-linear-map-from-pfn_valid.patch
arm64-drop-pfn_valid_within-and-simplify-pfn_valid.patch
mmap-make-mlock_future_check-global.patch
riscv-kconfig-make-direct-map-manipulation-options-depend-on-mmu.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages.patch
set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix-2.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix-3.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant-fix.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch
secretmem-test-add-basic-selftest-for-memfd_secret2-fix.patch

