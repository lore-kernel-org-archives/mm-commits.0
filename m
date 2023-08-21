Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50C6FEE49A5
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:39:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbjHUUjA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbjHUUi6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:38:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F35C7
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:38:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0DB864A31
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:38:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168CDC433C9;
        Mon, 21 Aug 2023 20:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650335;
        bh=Ack5ImzFypeflWnvhDOMEfISf+CFWd8uPS3UIQ0alis=;
        h=Date:To:From:Subject:From;
        b=BIMA6X5pqV8puCxI2bktNx23yTiGUOMKZXQ7geDnMqAQqnYBOlDxHDmlp0VSBqs43
         ERsin02e41AdoycnI+fpbPyWgBdc3Gi+Y7LOffrd4s4PTwP4s8/h9oOH02GBMraqRk
         L35xgjiK6hotmhI9Jm78Stv6zmD8aEqwxQ0yN3mU=
Date:   Mon, 21 Aug 2023 13:38:54 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vitaly.wool@konsulko.com, nphamcs@gmail.com, hch@infradead.org,
        hannes@cmpxchg.org, cerasuolodomenico@gmail.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zswap-make-zswap_store-take-a-folio.patch removed from -mm tree
Message-Id: <20230821203855.168CDC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zswap: make zswap_store() take a folio
has been removed from the -mm tree.  Its filename was
     zswap-make-zswap_store-take-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: zswap: make zswap_store() take a folio
Date: Sat, 15 Jul 2023 05:23:40 +0100

Patch series "Followup folio conversions for zswap".

With frontswap killed, it's worth converting the zswap_load() and
zswap_store() functions to take a folio instead of a page pointer.  They
aren't converted to support large folios, but there are a lot of
unnecessary calls to compound_head() that are removed by these patches.


This patch (of 4):

Only convert a few easy parts of this function to use the folio passed in;
convert back to struct page for the majority of it.  This does remove a
few hidden calls to compound_head().

Link: https://lkml.kernel.org/r/20230715042343.434588-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20230715042343.434588-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zswap.h |    4 ++--
 mm/page_io.c          |    2 +-
 mm/zswap.c            |   13 +++++++------
 3 files changed, 10 insertions(+), 9 deletions(-)

--- a/include/linux/zswap.h~zswap-make-zswap_store-take-a-folio
+++ a/include/linux/zswap.h
@@ -10,7 +10,7 @@ extern atomic_t zswap_stored_pages;
 
 #ifdef CONFIG_ZSWAP
 
-bool zswap_store(struct page *page);
+bool zswap_store(struct folio *folio);
 bool zswap_load(struct page *page);
 void zswap_invalidate(int type, pgoff_t offset);
 void zswap_swapon(int type);
@@ -18,7 +18,7 @@ void zswap_swapoff(int type);
 
 #else
 
-static inline bool zswap_store(struct page *page)
+static inline bool zswap_store(struct folio *folio)
 {
 	return false;
 }
--- a/mm/page_io.c~zswap-make-zswap_store-take-a-folio
+++ a/mm/page_io.c
@@ -195,7 +195,7 @@ int swap_writepage(struct page *page, st
 		folio_unlock(folio);
 		return ret;
 	}
-	if (zswap_store(&folio->page)) {
+	if (zswap_store(folio)) {
 		folio_start_writeback(folio);
 		folio_unlock(folio);
 		folio_end_writeback(folio);
--- a/mm/zswap.c~zswap-make-zswap_store-take-a-folio
+++ a/mm/zswap.c
@@ -1223,11 +1223,12 @@ static void zswap_fill_page(void *ptr, u
 	memset_l(page, value, PAGE_SIZE / sizeof(unsigned long));
 }
 
-bool zswap_store(struct page *page)
+bool zswap_store(struct folio *folio)
 {
-	swp_entry_t swp = { .val = page_private(page), };
+	swp_entry_t swp = folio_swap_entry(folio);
 	int type = swp_type(swp);
 	pgoff_t offset = swp_offset(swp);
+	struct page *page = &folio->page;
 	struct zswap_tree *tree = zswap_trees[type];
 	struct zswap_entry *entry, *dupentry;
 	struct scatterlist input, output;
@@ -1242,11 +1243,11 @@ bool zswap_store(struct page *page)
 	gfp_t gfp;
 	int ret;
 
-	VM_WARN_ON_ONCE(!PageLocked(page));
-	VM_WARN_ON_ONCE(!PageSwapCache(page));
+	VM_WARN_ON_ONCE(!folio_test_locked(folio));
+	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
 
-	/* THP isn't supported */
-	if (PageTransHuge(page))
+	/* Large folios aren't supported */
+	if (folio_test_large(folio))
 		return false;
 
 	if (!zswap_enabled || !tree)
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

