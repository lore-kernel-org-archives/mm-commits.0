Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36C2FEE49AA
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:39:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbjHUUjZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbjHUUjK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:39:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B4B18B
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:38:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A05E64A53
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:38:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2903C433C8;
        Mon, 21 Aug 2023 20:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650339;
        bh=L0eRSLVLvOhwo3wlJSOJ4Y+B0pzlyTE3qsNE6EUAwFg=;
        h=Date:To:From:Subject:From;
        b=TalxDsvBNTCXZXiNZw63yPwz5CHGTO/ZlwYQfqmrouY3cH325qqNWFtJxgtQydzhu
         4l3LfkJAzvCYR3PCv+hte4ZeDJErqGJtML4EoyyYOT4MIdON9BJXi/v6wput661h3X
         WUIm753G+sd9f8aP3ryE+X+3s0UDIm9tW2Rw8SCk=
Date:   Mon, 21 Aug 2023 13:38:58 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vitaly.wool@konsulko.com, nphamcs@gmail.com, hch@infradead.org,
        hannes@cmpxchg.org, cerasuolodomenico@gmail.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zswap-make-zswap_load-take-a-folio.patch removed from -mm tree
Message-Id: <20230821203858.E2903C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zswap: make zswap_load() take a folio
has been removed from the -mm tree.  Its filename was
     zswap-make-zswap_load-take-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: zswap: make zswap_load() take a folio
Date: Sat, 15 Jul 2023 05:23:43 +0100

Only convert a few easy parts of this function to use the folio passed in;
convert back to struct page for the majority of it.  Removes three hidden
calls to compound_head().

Link: https://lkml.kernel.org/r/20230715042343.434588-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zswap.h |    4 ++--
 mm/page_io.c          |    2 +-
 mm/zswap.c            |    9 +++++----
 3 files changed, 8 insertions(+), 7 deletions(-)

--- a/include/linux/zswap.h~zswap-make-zswap_load-take-a-folio
+++ a/include/linux/zswap.h
@@ -11,7 +11,7 @@ extern atomic_t zswap_stored_pages;
 #ifdef CONFIG_ZSWAP
 
 bool zswap_store(struct folio *folio);
-bool zswap_load(struct page *page);
+bool zswap_load(struct folio *folio);
 void zswap_invalidate(int type, pgoff_t offset);
 void zswap_swapon(int type);
 void zswap_swapoff(int type);
@@ -23,7 +23,7 @@ static inline bool zswap_store(struct fo
 	return false;
 }
 
-static inline bool zswap_load(struct page *page)
+static inline bool zswap_load(struct folio *folio)
 {
 	return false;
 }
--- a/mm/page_io.c~zswap-make-zswap_load-take-a-folio
+++ a/mm/page_io.c
@@ -513,7 +513,7 @@ void swap_readpage(struct page *page, bo
 	}
 	delayacct_swapin_start();
 
-	if (zswap_load(page)) {
+	if (zswap_load(folio)) {
 		folio_mark_uptodate(folio);
 		folio_unlock(folio);
 	} else if (data_race(sis->flags & SWP_FS_OPS)) {
--- a/mm/zswap.c~zswap-make-zswap_load-take-a-folio
+++ a/mm/zswap.c
@@ -1405,11 +1405,12 @@ shrink:
 	goto reject;
 }
 
-bool zswap_load(struct page *page)
+bool zswap_load(struct folio *folio)
 {
-	swp_entry_t swp = { .val = page_private(page), };
+	swp_entry_t swp = folio_swap_entry(folio);
 	int type = swp_type(swp);
 	pgoff_t offset = swp_offset(swp);
+	struct page *page = &folio->page;
 	struct zswap_tree *tree = zswap_trees[type];
 	struct zswap_entry *entry;
 	struct scatterlist input, output;
@@ -1419,7 +1420,7 @@ bool zswap_load(struct page *page)
 	unsigned int dlen;
 	bool ret;
 
-	VM_WARN_ON_ONCE(!PageLocked(page));
+	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 
 	/* find */
 	spin_lock(&tree->lock);
@@ -1481,7 +1482,7 @@ freeentry:
 	spin_lock(&tree->lock);
 	if (ret && zswap_exclusive_loads_enabled) {
 		zswap_invalidate_entry(tree, entry);
-		SetPageDirty(page);
+		folio_mark_dirty(folio);
 	} else if (entry->length) {
 		spin_lock(&entry->pool->lru_lock);
 		list_move(&entry->lru, &entry->pool->lru);
_

Patches currently in -mm which might be from willy@infradead.org are

io_uring-stop-calling-free_compound_page.patch
mm-call-free_huge_page-directly.patch
mm-convert-free_huge_page-to-free_huge_folio.patch
mm-convert-free_transhuge_folio-to-folio_undo_large_rmappable.patch
mm-convert-prep_transhuge_page-to-folio_prep_large_rmappable.patch
mm-remove-free_compound_page-and-the-compound_page_dtors-array.patch
mm-remove-hugetlb_page_dtor.patch
mm-add-large_rmappable-page-flag.patch
mm-rearrange-page-flags.patch
mm-free-up-a-word-in-the-first-tail-page.patch
mm-remove-folio_test_transhuge.patch
mm-add-tail-private-fields-to-struct-folio.patch
mm-convert-split_huge_pages_pid-to-use-a-folio.patch
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

