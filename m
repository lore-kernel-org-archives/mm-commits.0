Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1845EEE49AF
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:39:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbjHUUjb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbjHUUjT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:39:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F82B183
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:39:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F5B964A31
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 685DFC433C8;
        Mon, 21 Aug 2023 20:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650353;
        bh=Iz875ohrCv4TlLyHZnkjkRYAzBUH+pB7YaJvpSVPKs4=;
        h=Date:To:From:Subject:From;
        b=g8ur2b/+p281XT6JMnzLBn8AyP82ZX338WiEoVYQVebQeSzqUdt+TE1hsDnEalTNY
         KmcdLNTmzdrbAXfzXNbVfxihSaxRzqC37Ei/Tzs3ITOLDZkIh6iOa81PiVhUNXyAXJ
         WGExvMb6Kw07PjNOqW/fh7sHNMRGDiBfbjF64tP0=
Date:   Mon, 21 Aug 2023 13:39:12 -0700
To:     mm-commits@vger.kernel.org, kirill@shutemov.name, david@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-improve-the-comment-in-isolate_migratepages_block.patch removed from -mm tree
Message-Id: <20230821203913.685DFC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: improve the comment in isolate_migratepages_block()
has been removed from the -mm tree.  Its filename was
     mm-improve-the-comment-in-isolate_migratepages_block.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: mm: improve the comment in isolate_migratepages_block()
Date: Thu, 27 Jul 2023 21:39:44 +0100

A recent patch shows that not everybody understands that "stabilise the
mapping" really means "prevent the mapping from being freed", so change
the wording to hopefully make that more clear.

Link: https://lkml.kernel.org/r/ZMLWEB4m3zvX6SBN@casper.infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/compaction.c~mm-improve-the-comment-in-isolate_migratepages_block
+++ a/mm/compaction.c
@@ -1100,13 +1100,13 @@ isolate_migratepages_block(struct compac
 			bool migrate_dirty;
 
 			/*
-			 * Only pages without mappings or that have a
-			 * ->migrate_folio callback are possible to migrate
-			 * without blocking. However, we can be racing with
-			 * truncation so it's necessary to lock the page
-			 * to stabilise the mapping as truncation holds
-			 * the page lock until after the page is removed
-			 * from the page cache.
+			 * Only folios without mappings or that have
+			 * a ->migrate_folio callback are possible to
+			 * migrate without blocking.  However, we may
+			 * be racing with truncation, which can free
+			 * the mapping.  Truncation holds the folio lock
+			 * until after the folio is removed from the page
+			 * cache so holding it ourselves is sufficient.
 			 */
 			if (!folio_trylock(folio))
 				goto isolate_fail_put;
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

