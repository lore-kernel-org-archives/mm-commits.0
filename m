Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56E75EE49AE
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 21:29:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbjHUV3b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 17:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbjHUV3a (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 17:29:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC288C7
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 14:29:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCBEF6460E
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 21:29:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C434C433C8;
        Mon, 21 Aug 2023 21:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692653368;
        bh=F7qjf7SGSENueL3UoHRUryG5YqY89NNDgX9nw8g6sUg=;
        h=Date:To:From:Subject:From;
        b=FL4WulHYwysU3a2iKOCve9jHxk8R/8IB1tw86zyOK8Fn2WZhag6Zwn7tLL6X6qpB0
         PK/v9X2P/WzRU+bLu6I7vCP1yfQcjIvQCmzSS5u9YHWzHn3txjMBi03KNFjdEEHv40
         d8+wCeAqv8Gh5ZzTURGAX9ZWGaJSQNJBFaYkElkk=
Date:   Mon, 21 Aug 2023 14:29:27 -0700
To:     mm-commits@vger.kernel.org, siyanteng@loongson.cn,
        sidhartha.kumar@oracle.com, david@redhat.com, axboe@kernel.dk,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-call-free_huge_page-directly.patch removed from -mm tree
Message-Id: <20230821212928.2C434C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: call free_huge_page() directly
has been removed from the -mm tree.  Its filename was
     mm-call-free_huge_page-directly.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: call free_huge_page() directly
Date: Wed, 16 Aug 2023 16:11:50 +0100

Indirect calls are expensive, thanks to Spectre.  Call free_huge_page()
directly if the folio belongs to hugetlb.

Link: https://lkml.kernel.org/r/20230816151201.3655946-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Yanteng Si <siyanteng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    3 ++-
 mm/page_alloc.c         |    8 +++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

--- a/include/linux/hugetlb.h~mm-call-free_huge_page-directly
+++ a/include/linux/hugetlb.h
@@ -26,6 +26,8 @@ typedef struct { unsigned long pd; } hug
 #define __hugepd(x) ((hugepd_t) { (x) })
 #endif
 
+void free_huge_page(struct page *page);
+
 #ifdef CONFIG_HUGETLB_PAGE
 
 #include <linux/mempolicy.h>
@@ -165,7 +167,6 @@ int get_huge_page_for_hwpoison(unsigned
 				bool *migratable_cleared);
 void folio_putback_active_hugetlb(struct folio *folio);
 void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio, int reason);
-void free_huge_page(struct page *page);
 void hugetlb_fix_reserve_counts(struct inode *inode);
 extern struct mutex *hugetlb_fault_mutex_table;
 u32 hugetlb_fault_mutex_hash(struct address_space *mapping, pgoff_t idx);
--- a/mm/page_alloc.c~mm-call-free_huge_page-directly
+++ a/mm/page_alloc.c
@@ -287,9 +287,6 @@ const char * const migratetype_names[MIG
 static compound_page_dtor * const compound_page_dtors[NR_COMPOUND_DTORS] = {
 	[NULL_COMPOUND_DTOR] = NULL,
 	[COMPOUND_PAGE_DTOR] = free_compound_page,
-#ifdef CONFIG_HUGETLB_PAGE
-	[HUGETLB_PAGE_DTOR] = free_huge_page,
-#endif
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	[TRANSHUGE_PAGE_DTOR] = free_transhuge_page,
 #endif
@@ -612,6 +609,11 @@ void destroy_large_folio(struct folio *f
 {
 	enum compound_dtor_id dtor = folio->_folio_dtor;
 
+	if (folio_test_hugetlb(folio)) {
+		free_huge_page(&folio->page);
+		return;
+	}
+
 	VM_BUG_ON_FOLIO(dtor >= NR_COMPOUND_DTORS, folio);
 	compound_page_dtors[dtor](&folio->page);
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

