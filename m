Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EDCBC6FA8F
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:13:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234567AbjHXXNC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244022AbjHXXMs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:12:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE3C199D
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:12:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B757644C8
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:12:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E21E2C433C8;
        Thu, 24 Aug 2023 23:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692918765;
        bh=1N3BWMC02wJX2w+5OUNP2jy3xN3BIm9j1xEO4whYzSI=;
        h=Date:To:From:Subject:From;
        b=xmQG1Ry6f0hReR8rajLklIL5zDqGrdKl18Ka9HqO0RNc0gr2U/xGaZx7ICYRb8wOJ
         390cWaNUHscp+ix3bMJ4NHgHPdekrVAuw4GvXHlsbfGUwKdgo48uBmXYkOkLWV9bv7
         dhSMRDCpJFlOfLPqZGa89mmhdTRpMkUvf/JOa6qQ=
Date:   Thu, 24 Aug 2023 16:12:44 -0700
To:     mm-commits@vger.kernel.org, nathan@kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] powerpc-implement-the-new-page-table-range-api-fix.patch removed from -mm tree
Message-Id: <20230824231244.E21E2C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: powerpc-implement-the-new-page-table-range-api-fix
has been removed from the -mm tree.  Its filename was
     powerpc-implement-the-new-page-table-range-api-fix.patch

This patch was dropped because it was folded into powerpc-implement-the-new-page-table-range-api.patch

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: powerpc-implement-the-new-page-table-range-api-fix
Date: Fri, 4 Aug 2023 04:50:13 +0100

re-export flush_dcache_icache_folio()


Link: https://lkml.kernel.org/r/ZMx1daYwvD9EM7Cv@casper.infradead.org
Signed-off-by: Matthew Wilcox <willy@infradead.org>
Reported-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/cacheflush.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/mm/cacheflush.c~powerpc-implement-the-new-page-table-range-api-fix
+++ a/arch/powerpc/mm/cacheflush.c
@@ -172,6 +172,7 @@ void flush_dcache_icache_folio(struct fo
 			flush_dcache_icache_phys((pfn + i) * PAGE_SIZE);
 	}
 }
+EXPORT_SYMBOL(flush_dcache_icache_folio);
 
 void clear_user_page(void *page, unsigned long vaddr, struct page *pg)
 {
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

