Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1ECEC47E48
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jul 2021 22:32:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DA63613CB
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jul 2021 22:32:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236408AbhGNWfb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Jul 2021 18:35:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229900AbhGNWfb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Jul 2021 18:35:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB3F4613C2;
        Wed, 14 Jul 2021 22:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626301959;
        bh=Dbl/ED2YVbgv2CBOM1gqXn45boUwQ3Y8qcuHf2solBY=;
        h=Date:From:To:Subject:From;
        b=cLbmFnjNbx9OGCrSltYP83NQClxL9XOGnBxsOQfGFJhyWgBLiDjVMaaLKFqTv7xsb
         9kWWB9yZG+ynaQqhWhwyaRGmvBowHKwVsw6duArf46cMVTalGQQ5qZNrxRDPlNXI1a
         0JnBkVEfY/tWt9jmaRvlmESA+v0MTL0ggqa3ZeM8=
Date:   Wed, 14 Jul 2021 15:32:38 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, monstr@monstr.eu, rppt@linux.ibm.com
Subject:  + microblaze-simplify-pte_alloc_one_kernel.patch added to
 -mm tree
Message-ID: <20210714223238.Z18AmzZya%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: microblaze: simplify pte_alloc_one_kernel()
has been added to the -mm tree.  Its filename is
     microblaze-simplify-pte_alloc_one_kernel.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/microblaze-simplify-pte_alloc_one_kernel.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/microblaze-simplify-pte_alloc_one_kernel.patch

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
Subject: microblaze: simplify pte_alloc_one_kernel()

The microblaze's implementation of pte_alloc_one_kernel() used
memblock_alloc_try_nid_raw() along with clear_page() to allocated a zeroed
page during early setup.

Replace calls of these functions with a call to memblock_alloc_try_nid()
that already returns zeroed page and respects the same allocation limits
as memblock_alloc_try_nid_raw().

While on it drop early_get_page() wrapper that was only used in
pte_alloc_one_kernel().

Link: https://lkml.kernel.org/r/20210714123739.16493-3-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Michal Simek <monstr@monstr.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/include/asm/pgtable.h |    2 --
 arch/microblaze/mm/init.c             |   12 ------------
 arch/microblaze/mm/pgtable.c          |   17 ++++++++---------
 3 files changed, 8 insertions(+), 23 deletions(-)

--- a/arch/microblaze/include/asm/pgtable.h~microblaze-simplify-pte_alloc_one_kernel
+++ a/arch/microblaze/include/asm/pgtable.h
@@ -443,8 +443,6 @@ extern int mem_init_done;
 
 asmlinkage void __init mmu_init(void);
 
-void __init *early_get_page(void);
-
 #endif /* __ASSEMBLY__ */
 #endif /* __KERNEL__ */
 
--- a/arch/microblaze/mm/init.c~microblaze-simplify-pte_alloc_one_kernel
+++ a/arch/microblaze/mm/init.c
@@ -265,18 +265,6 @@ asmlinkage void __init mmu_init(void)
 	dma_contiguous_reserve(memory_start + lowmem_size - 1);
 }
 
-/* This is only called until mem_init is done. */
-void __init *early_get_page(void)
-{
-	/*
-	 * Mem start + kernel_tlb -> here is limit
-	 * because of mem mapping from head.S
-	 */
-	return memblock_alloc_try_nid_raw(PAGE_SIZE, PAGE_SIZE,
-				MEMBLOCK_LOW_LIMIT, memory_start + kernel_tlb,
-				NUMA_NO_NODE);
-}
-
 void * __ref zalloc_maybe_bootmem(size_t size, gfp_t mask)
 {
 	void *p;
--- a/arch/microblaze/mm/pgtable.c~microblaze-simplify-pte_alloc_one_kernel
+++ a/arch/microblaze/mm/pgtable.c
@@ -33,6 +33,7 @@
 #include <linux/init.h>
 #include <linux/mm_types.h>
 #include <linux/pgtable.h>
+#include <linux/memblock.h>
 
 #include <asm/pgalloc.h>
 #include <linux/io.h>
@@ -242,15 +243,13 @@ unsigned long iopa(unsigned long addr)
 
 __ref pte_t *pte_alloc_one_kernel(struct mm_struct *mm)
 {
-	pte_t *pte;
-	if (mem_init_done) {
-		pte = (pte_t *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
-	} else {
-		pte = (pte_t *)early_get_page();
-		if (pte)
-			clear_page(pte);
-	}
-	return pte;
+	if (mem_init_done)
+		return (pte_t *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+	else
+		return memblock_alloc_try_nid(PAGE_SIZE, PAGE_SIZE,
+					      MEMBLOCK_LOW_LIMIT,
+					      memory_start + kernel_tlb,
+					      NUMA_NO_NODE);
 }
 
 void __set_fixmap(enum fixed_addresses idx, phys_addr_t phys, pgprot_t flags)
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-page_alloc-always-initialize-memory-map-for-the-holes.patch
microblaze-simplify-pte_alloc_one_kernel.patch
mm-introduce-memmap_alloc-to-unify-memory-map-allocation.patch
memblock-stop-poisoning-raw-allocations.patch
mm-remove-pfn_valid_within-and-config_holes_in_zone.patch
mm-memory_hotplug-cleanup-after-removal-of-pfn_valid_within.patch

