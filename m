Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB38CC6FA8F
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:14:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239305AbjHXXOJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244013AbjHXXOB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:14:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD9A1BDF
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:13:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25F29639F6
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:13:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F9CDC433C7;
        Thu, 24 Aug 2023 23:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692918837;
        bh=rgBX/LlqQ5/JF1HICBJrV6ycusooyVJcXWimbxynOlA=;
        h=Date:To:From:Subject:From;
        b=f905C+qb6S+hE6IqBbFwiWU91JO9KfEaIvgWRMYze/5LwdOls4ekqr/XKcqgTpdsT
         9GvYXzH3sRP8UAAxFa/nHBivka9pjUQ5rNpKo45ipAfLDY7T/9nwxYBTz8nEYf3aWt
         b2PI/vwcvcyE34QY/MK5tqUNHNZfXxgy2y/9PA/E=
Date:   Thu, 24 Aug 2023 16:13:56 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, rdunlap@infradead.org,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-fix-kernel-doc-warning-from-tlb_flush_rmaps.patch removed from -mm tree
Message-Id: <20230824231357.7F9CDC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: fix kernel-doc warning from tlb_flush_rmaps()
has been removed from the -mm tree.  Its filename was
     mm-fix-kernel-doc-warning-from-tlb_flush_rmaps.patch

This patch was dropped because it was folded into mm-remove-enum-page_entry_size.patch

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: fix kernel-doc warning from tlb_flush_rmaps()
Date: Fri, 18 Aug 2023 21:06:27 +0100

Patch series "Improve mm documentation".

If you build with W=1, kernel-doc complains about tlb_flush_rmaps().  Then
I ran scripts/find-unused-docs.sh against mm/ and found a large number of
files which weren't included in the ReST documentation.  I fixed up a
couple of them, and added all those without erros to the rst files. 
There's a lot more work to do to organise all of this, but at least now if
we have documentation that refers to these functions, we'll get a nice
link to them.


This patch (of 4):

The vma parameter wasn't described.

Link: https://lkml.kernel.org/r/20230818200630.2719595-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20230818200630.2719595-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_gather.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/mmu_gather.c~mm-fix-kernel-doc-warning-from-tlb_flush_rmaps
+++ a/mm/mmu_gather.c
@@ -63,6 +63,7 @@ static void tlb_flush_rmap_batch(struct
 /**
  * tlb_flush_rmaps - do pending rmap removals after we have flushed the TLB
  * @tlb: the current mmu_gather
+ * @vma: The memory area from which the pages are being removed.
  *
  * Note that because of how tlb_next_batch() above works, we will
  * never start multiple new batches with pending delayed rmaps, so
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
mm-fix-get_mctgt_type-kernel-doc.patch
mm-fix-get_mctgt_type-kernel-doc-fix-2.patch
mm-fix-clean_record_shared_mapping_range-kernel-doc.patch
mm-add-orphaned-kernel-doc-to-the-rst-files.patch
hugetlb-add-documentation-for-vma_kernel_pagesize.patch
secretmem-conert-page_is_secretmem-to-folio_is_secretmem.patch

