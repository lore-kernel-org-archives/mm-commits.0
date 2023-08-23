Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CAFDC3DA66
	for <mm-commits@archiver.kernel.org>; Wed, 23 Aug 2023 20:02:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbjHWUCT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Aug 2023 16:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234317AbjHWUCB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Aug 2023 16:02:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7888410C2
        for <mm-commits@vger.kernel.org>; Wed, 23 Aug 2023 13:01:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 059B7628FA
        for <mm-commits@vger.kernel.org>; Wed, 23 Aug 2023 20:01:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA89C433C8;
        Wed, 23 Aug 2023 20:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692820918;
        bh=zUon2SNP6a+wIwxu4Kp59iqtHTV1wBgLebbN5w1GSFg=;
        h=Date:To:From:Subject:From;
        b=Xxu3L7G1TPVUTuD6iSZ5R0TV9B40ubawqhlBs2KVyaTklVsKBS7MENx1xwd6OZFpf
         wCESg42I4FmPiqVHdRVohJr4XPgguGfFAFjfz4nPKgJboC9d/6pjh2AOMH9YcZZ3wr
         Cd7dpOyIE3YQBtStesXWRpcfqhDbjmIiIrQe3BAk=
Date:   Wed, 23 Aug 2023 13:01:57 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org,
        m.szyprowski@samsung.com, linux@armlinux.org.uk,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + arm-implement-the-new-page-table-range-api-fix-2.patch added to mm-unstable branch
Message-Id: <20230823200158.0DA89C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fix folio conversion in __dma_page_dev_to_cpu()
has been added to the -mm mm-unstable branch.  Its filename is
     arm-implement-the-new-page-table-range-api-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm-implement-the-new-page-table-range-api-fix-2.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: fix folio conversion in __dma_page_dev_to_cpu()
Date: Wed, 23 Aug 2023 20:18:52 +0100

Russell and Marek pointed out some assumptions I was making about how sg
lists work; eg that they are limited to 2GB and that the initial offset
lies within the first page (or at least within the first folio that a page
belongs to).  While I think those assumptions are true, it's not too hard
to write a version which does not have those assumptions and also
calculates folio_size() only once per loop iteration.

Link: https://lkml.kernel.org/r/20230823191852.1556561-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/dma-mapping.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/arch/arm/mm/dma-mapping.c~arm-implement-the-new-page-table-range-api-fix-2
+++ a/arch/arm/mm/dma-mapping.c
@@ -695,7 +695,6 @@ static void __dma_page_cpu_to_dev(struct
 static void __dma_page_dev_to_cpu(struct page *page, unsigned long off,
 	size_t size, enum dma_data_direction dir)
 {
-	struct folio *folio = page_folio(page);
 	phys_addr_t paddr = page_to_phys(page) + off;
 
 	/* FIXME: non-speculating: not required */
@@ -710,18 +709,19 @@ static void __dma_page_dev_to_cpu(struct
 	 * Mark the D-cache clean for these pages to avoid extra flushing.
 	 */
 	if (dir != DMA_TO_DEVICE && size >= PAGE_SIZE) {
-		ssize_t left = size;
+		struct folio *folio = pfn_folio(paddr / PAGE_SIZE);
 		size_t offset = offset_in_folio(folio, paddr);
 
-		if (offset) {
-			left -= folio_size(folio) - offset;
-			folio = folio_next(folio);
-		}
+		for (;;) {
+			size_t sz = folio_size(folio) - offset;
 
-		while (left >= (ssize_t)folio_size(folio)) {
-			left -= folio_size(folio);
-			set_bit(PG_dcache_clean, &folio->flags);
-			if (!left)
+			if (size < sz)
+				break;
+			if (!offset)
+				set_bit(PG_dcache_clean, &folio->flags);
+			offset = 0;
+			size -= sz;
+			if (!size)
 				break;
 			folio = folio_next(folio);
 		}
_

Patches currently in -mm which might be from willy@infradead.org are

mm-memoryc-fix-mismerge.patch
mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed-fix.patch
minmax-add-in_range-macro.patch
mm-convert-page_table_check_pte_set-to-page_table_check_ptes_set.patch
mm-add-generic-flush_icache_pages-and-documentation.patch
mm-add-folio_flush_mapping.patch
mm-remove-arch_implements_flush_dcache_folio.patch
mm-add-default-definition-of-set_ptes.patch
alpha-implement-the-new-page-table-range-api.patch
arc-implement-the-new-page-table-range-api.patch
arm-implement-the-new-page-table-range-api.patch
arm-implement-the-new-page-table-range-api-fix-2.patch
arm64-implement-the-new-page-table-range-api.patch
csky-implement-the-new-page-table-range-api.patch
hexagon-implement-the-new-page-table-range-api.patch
ia64-implement-the-new-page-table-range-api.patch
ia64-implement-the-new-page-table-range-api-fix.patch
loongarch-implement-the-new-page-table-range-api.patch
m68k-implement-the-new-page-table-range-api.patch
microblaze-implement-the-new-page-table-range-api.patch
mips-implement-the-new-page-table-range-api.patch
nios2-implement-the-new-page-table-range-api.patch
openrisc-implement-the-new-page-table-range-api.patch
parisc-implement-the-new-page-table-range-api.patch
powerpc-implement-the-new-page-table-range-api.patch
powerpc-implement-the-new-page-table-range-api-fix.patch
riscv-implement-the-new-page-table-range-api.patch
s390-implement-the-new-page-table-range-api.patch
sh-implement-the-new-page-table-range-api.patch
sparc32-implement-the-new-page-table-range-api.patch
sparc64-implement-the-new-page-table-range-api.patch
um-implement-the-new-page-table-range-api.patch
x86-implement-the-new-page-table-range-api.patch
xtensa-implement-the-new-page-table-range-api.patch
mm-remove-page_mapping_file.patch
mm-rationalise-flush_icache_pages-and-flush_icache_page.patch
mm-tidy-up-set_ptes-definition.patch
mm-use-flush_icache_pages-in-do_set_pmd.patch
mm-call-update_mmu_cache_range-in-more-page-fault-handling-paths.patch
mm-swap-use-dedicated-entry-for-swap-in-folio.patch
mm-remove-checks-for-pte_index.patch
mm-move-pmd_order-to-pgtableh.patch
mm-allow-huge_fault-to-be-called-without-the-mmap_lock-held.patch
mm-remove-enum-page_entry_size.patch
mm-fix-kernel-doc-warning-from-tlb_flush_rmaps.patch
mm-fix-get_mctgt_type-kernel-doc.patch
mm-fix-clean_record_shared_mapping_range-kernel-doc.patch
mm-add-orphaned-kernel-doc-to-the-rst-files.patch
hugetlb-add-documentation-for-vma_kernel_pagesize.patch

