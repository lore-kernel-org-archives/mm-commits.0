Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3107EE49A5
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbjHUUjZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbjHUUjB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:39:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E042184
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:38:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E8A164526
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:38:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B67DEC433C9;
        Mon, 21 Aug 2023 20:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650337;
        bh=+sGJ2IE94d4TvXJZGgQxuBKxDIohJAuAsQdd2DK6Ras=;
        h=Date:To:From:Subject:From;
        b=IFF4LuGOWFn95CO+hEjG1s2UOcG0QS8m9HibBZDcOwOufNn/+r9tTwlCnIAmyh3YV
         qcTWJsIoKnX1dYH4PFQP3N39s3mkX9H+AujBle7XvA/QISRIg1+MWCqsnz6KtejI0Y
         AmkMz3Y3h1ptkIJ38lyRvpZ9/sQ4kG7/rkDjA9wE=
Date:   Mon, 21 Aug 2023 13:38:57 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vitaly.wool@konsulko.com, nphamcs@gmail.com, hch@infradead.org,
        hannes@cmpxchg.org, cerasuolodomenico@gmail.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] swap-remove-some-calls-to-compound_head-in-swap_readpage.patch removed from -mm tree
Message-Id: <20230821203857.B67DEC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: swap: remove some calls to compound_head() in swap_readpage()
has been removed from the -mm tree.  Its filename was
     swap-remove-some-calls-to-compound_head-in-swap_readpage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: swap: remove some calls to compound_head() in swap_readpage()
Date: Sat, 15 Jul 2023 05:23:42 +0100

Replace six implicit calls to compound_head() with one call to
page_folio().

Link: https://lkml.kernel.org/r/20230715042343.434588-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/mm/page_io.c~swap-remove-some-calls-to-compound_head-in-swap_readpage
+++ a/mm/page_io.c
@@ -492,14 +492,15 @@ static void swap_readpage_bdev_async(str
 
 void swap_readpage(struct page *page, bool synchronous, struct swap_iocb **plug)
 {
+	struct folio *folio = page_folio(page);
 	struct swap_info_struct *sis = page_swap_info(page);
-	bool workingset = PageWorkingset(page);
+	bool workingset = folio_test_workingset(folio);
 	unsigned long pflags;
 	bool in_thrashing;
 
-	VM_BUG_ON_PAGE(!PageSwapCache(page) && !synchronous, page);
-	VM_BUG_ON_PAGE(!PageLocked(page), page);
-	VM_BUG_ON_PAGE(PageUptodate(page), page);
+	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio) && !synchronous, folio);
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+	VM_BUG_ON_FOLIO(folio_test_uptodate(folio), folio);
 
 	/*
 	 * Count submission time as memory stall and delay. When the device
@@ -513,8 +514,8 @@ void swap_readpage(struct page *page, bo
 	delayacct_swapin_start();
 
 	if (zswap_load(page)) {
-		SetPageUptodate(page);
-		unlock_page(page);
+		folio_mark_uptodate(folio);
+		folio_unlock(folio);
 	} else if (data_race(sis->flags & SWP_FS_OPS)) {
 		swap_readpage_fs(page, plug);
 	} else if (synchronous || (sis->flags & SWP_SYNCHRONOUS_IO)) {
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

