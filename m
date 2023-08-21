Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6487FEE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 21:30:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjHUVaD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 17:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbjHUV3s (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 17:29:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A5E9F3
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 14:29:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE2F764701
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 21:29:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D687C433C8;
        Mon, 21 Aug 2023 21:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692653381;
        bh=Rprp9YwKLUowFT0n7RRnf56LYyjZ99momeAkAzVv0kc=;
        h=Date:To:From:Subject:From;
        b=UHbgXUCNdAWg8LlYO2QigdVqebU8iE5y0YDu/W53ngCgkbHJkITIZLdmnoWT1Ekmn
         QVa5eLhvNRX81Qtb+ZXD+QDRTOqBJoLoqdDNWjyTXoZHKKFV1jz+IjEjFaHVolBsCo
         BTcJUphEI8ExWW3h59MyVjNNYplLFFt81WjGJ73Q=
Date:   Mon, 21 Aug 2023 14:29:40 -0700
To:     mm-commits@vger.kernel.org, siyanteng@loongson.cn,
        sidhartha.kumar@oracle.com, david@redhat.com, axboe@kernel.dk,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-split_huge_pages_pid-to-use-a-folio.patch removed from -mm tree
Message-Id: <20230821212941.0D687C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: convert split_huge_pages_pid() to use a folio
has been removed from the -mm tree.  Its filename was
     mm-convert-split_huge_pages_pid-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert split_huge_pages_pid() to use a folio
Date: Wed, 16 Aug 2023 16:12:01 +0100

Replaces five calls to compound_head with one.

Link: https://lkml.kernel.org/r/20230816151201.3655946-14-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Yanteng Si <siyanteng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/mm/huge_memory.c~mm-convert-split_huge_pages_pid-to-use-a-folio
+++ a/mm/huge_memory.c
@@ -584,14 +584,11 @@ void folio_prep_large_rmappable(struct f
 	folio_set_large_rmappable(folio);
 }
 
-static inline bool is_transparent_hugepage(struct page *page)
+static inline bool is_transparent_hugepage(struct folio *folio)
 {
-	struct folio *folio;
-
-	if (!PageCompound(page))
+	if (!folio_test_large(folio))
 		return false;
 
-	folio = page_folio(page);
 	return is_huge_zero_page(&folio->page) ||
 		folio_test_large_rmappable(folio);
 }
@@ -3012,6 +3009,7 @@ static int split_huge_pages_pid(int pid,
 	for (addr = vaddr_start; addr < vaddr_end; addr += PAGE_SIZE) {
 		struct vm_area_struct *vma = vma_lookup(mm, addr);
 		struct page *page;
+		struct folio *folio;
 
 		if (!vma)
 			break;
@@ -3028,22 +3026,23 @@ static int split_huge_pages_pid(int pid,
 		if (IS_ERR_OR_NULL(page))
 			continue;
 
-		if (!is_transparent_hugepage(page))
+		folio = page_folio(page);
+		if (!is_transparent_hugepage(folio))
 			goto next;
 
 		total++;
-		if (!can_split_folio(page_folio(page), NULL))
+		if (!can_split_folio(folio, NULL))
 			goto next;
 
-		if (!trylock_page(page))
+		if (!folio_trylock(folio))
 			goto next;
 
-		if (!split_huge_page(page))
+		if (!split_folio(folio))
 			split++;
 
-		unlock_page(page);
+		folio_unlock(folio);
 next:
-		put_page(page);
+		folio_put(folio);
 		cond_resched();
 	}
 	mmap_read_unlock(mm);
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

