Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7537AEE49A0
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:10:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240006AbjHXXKT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244006AbjHXXJv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:09:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E9941BDB
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:09:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFE23655B7
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:09:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF4FC433C8;
        Thu, 24 Aug 2023 23:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692918588;
        bh=+c868X/NP4NxP4ppJPM3YlhRmqIvZfJJ7GDzg9rMXj4=;
        h=Date:To:From:Subject:From;
        b=kTyk4RRPKl0q6ebZFPt/gVtR3Fc+z4imwU/wxG0e/0W4eGGeWvJEKAwytJAJ4Zugd
         brZg1fvWPZwVapGeovdGtSNKhWKeqOFknoIZ7Hp+5OVCA/H2FdyNAl79sFf1ZfGWxK
         7Bv4kVxv/6ip0enuv5ZRqxslv0lreyVU/qbw2Ttw=
Date:   Thu, 24 Aug 2023 16:09:47 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] ia64-implement-the-new-page-table-range-api-fix.patch removed from -mm tree
Message-Id: <20230824230948.0BF4FC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ia64-implement-the-new-page-table-range-api-fix
has been removed from the -mm tree.  Its filename was
     ia64-implement-the-new-page-table-range-api-fix.patch

This patch was dropped because it was folded into ia64-implement-the-new-page-table-range-api.patch

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: ia64-implement-the-new-page-table-range-api-fix
Date: Wed, 9 Aug 2023 20:12:56 +0100

fix folio_size() handling

Link: https://lkml.kernel.org/r/ZNPlOCe8F+nrzPxr@casper.infradead.org
Signed-off-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/hp/common/sba_iommu.c |    6 +++++-
 arch/ia64/mm/init.c             |    6 +++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

--- a/arch/ia64/hp/common/sba_iommu.c~ia64-implement-the-new-page-table-range-api-fix
+++ a/arch/ia64/hp/common/sba_iommu.c
@@ -811,12 +811,16 @@ static void mark_clean(void *addr, size_
 
 	if (offset) {
 		left -= folio_size(folio) - offset;
+		if (left <= 0)
+			return;
 		folio = folio_next(folio);
 	}
 
 	while (left >= folio_size(folio)) {
-		set_bit(PG_arch_1, &folio->flags);
 		left -= folio_size(folio);
+		set_bit(PG_arch_1, &folio->flags);
+		if (!left)
+			break;
 		folio = folio_next(folio);
 	}
 }
--- a/arch/ia64/mm/init.c~ia64-implement-the-new-page-table-range-api-fix
+++ a/arch/ia64/mm/init.c
@@ -76,12 +76,16 @@ void arch_dma_mark_clean(phys_addr_t pad
 
 	if (offset) {
 		left -= folio_size(folio) - offset;
+		if (left <= 0)
+			return;
 		folio = folio_next(folio);
 	}
 
 	while (left >= (ssize_t)folio_size(folio)) {
-		set_bit(PG_arch_1, &pfn_to_page(pfn)->flags);
 		left -= folio_size(folio);
+		set_bit(PG_arch_1, &pfn_to_page(pfn)->flags);
+		if (!left)
+			break;
 		folio = folio_next(folio);
 	}
 }
_

Patches currently in -mm which might be from willy@infradead.org are

mm-memoryc-fix-mismerge.patch
minmax-add-in_range-macro.patch
mm-convert-page_table_check_pte_set-to-page_table_check_ptes_set.patch
mm-add-generic-flush_icache_pages-and-documentation.patch
mm-add-folio_flush_mapping.patch
mm-remove-arch_implements_flush_dcache_folio.patch
mm-add-default-definition-of-set_ptes.patch
alpha-implement-the-new-page-table-range-api.patch
arc-implement-the-new-page-table-range-api.patch
arm-implement-the-new-page-table-range-api.patch
arm64-implement-the-new-page-table-range-api.patch
csky-implement-the-new-page-table-range-api.patch
hexagon-implement-the-new-page-table-range-api.patch
ia64-implement-the-new-page-table-range-api.patch
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
mm-remove-enum-page_entry_size-fix.patch
mm-fix-kernel-doc-warning-from-tlb_flush_rmaps.patch
mm-fix-get_mctgt_type-kernel-doc.patch
mm-fix-get_mctgt_type-kernel-doc-fix-2.patch
mm-fix-clean_record_shared_mapping_range-kernel-doc.patch
mm-add-orphaned-kernel-doc-to-the-rst-files.patch
hugetlb-add-documentation-for-vma_kernel_pagesize.patch
secretmem-conert-page_is_secretmem-to-folio_is_secretmem.patch

