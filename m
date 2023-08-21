Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B022EE49A6
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 21:29:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbjHUV3m (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 17:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbjHUV3e (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 17:29:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD8C110E
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 14:29:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FBAA64AAB
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 21:29:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FEFEC433B8;
        Mon, 21 Aug 2023 21:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692653371;
        bh=DAja0cZoNNlxtMX6zRUyP7D4CX/xBqjcRQ5SMkat7Zo=;
        h=Date:To:From:Subject:From;
        b=vGZS+wl1vOO1vJ23Em44448HmpBgOBl5sR3qz4edoK4iB+lFFa6FG56LoDvk9OX1e
         UAPnHLP532TliNI27St+T5ak5ozBjMmR8OHvsaIECbKpu7gmjD1sVmdpR7i3d05aDZ
         riVqgaU5pn8iA69THy9WAMAcVkhccwwNevTDAg1Q=
Date:   Mon, 21 Aug 2023 14:29:31 -0700
To:     mm-commits@vger.kernel.org, siyanteng@loongson.cn,
        sidhartha.kumar@oracle.com, david@redhat.com, axboe@kernel.dk,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-prep_transhuge_page-to-folio_prep_large_rmappable.patch removed from -mm tree
Message-Id: <20230821212931.8FEFEC433B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: convert prep_transhuge_page() to folio_prep_large_rmappable()
has been removed from the -mm tree.  Its filename was
     mm-convert-prep_transhuge_page-to-folio_prep_large_rmappable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert prep_transhuge_page() to folio_prep_large_rmappable()
Date: Wed, 16 Aug 2023 16:11:53 +0100

Match folio_undo_large_rmappable(), and move the casting from page to
folio into the callers (which they were largely doing anyway).

Link: https://lkml.kernel.org/r/20230816151201.3655946-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Yanteng Si <siyanteng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    4 ++--
 mm/huge_memory.c        |    4 +---
 mm/khugepaged.c         |    2 +-
 mm/mempolicy.c          |   15 ++++++++-------
 mm/page_alloc.c         |    7 ++++---
 5 files changed, 16 insertions(+), 16 deletions(-)

--- a/include/linux/huge_mm.h~mm-convert-prep_transhuge_page-to-folio_prep_large_rmappable
+++ a/include/linux/huge_mm.h
@@ -140,7 +140,7 @@ bool hugepage_vma_check(struct vm_area_s
 unsigned long thp_get_unmapped_area(struct file *filp, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags);
 
-void prep_transhuge_page(struct page *page);
+void folio_prep_large_rmappable(struct folio *folio);
 bool can_split_folio(struct folio *folio, int *pextra_pins);
 int split_huge_page_to_list(struct page *page, struct list_head *list);
 static inline int split_huge_page(struct page *page)
@@ -280,7 +280,7 @@ static inline bool hugepage_vma_check(st
 	return false;
 }
 
-static inline void prep_transhuge_page(struct page *page) {}
+static inline void folio_prep_large_rmappable(struct folio *folio) {}
 
 #define transparent_hugepage_flags 0UL
 
--- a/mm/huge_memory.c~mm-convert-prep_transhuge_page-to-folio_prep_large_rmappable
+++ a/mm/huge_memory.c
@@ -577,10 +577,8 @@ struct deferred_split *get_deferred_spli
 }
 #endif
 
-void prep_transhuge_page(struct page *page)
+void folio_prep_large_rmappable(struct folio *folio)
 {
-	struct folio *folio = (struct folio *)page;
-
 	VM_BUG_ON_FOLIO(folio_order(folio) < 2, folio);
 	INIT_LIST_HEAD(&folio->_deferred_list);
 	folio_set_compound_dtor(folio, TRANSHUGE_PAGE_DTOR);
--- a/mm/khugepaged.c~mm-convert-prep_transhuge_page-to-folio_prep_large_rmappable
+++ a/mm/khugepaged.c
@@ -896,7 +896,7 @@ static bool hpage_collapse_alloc_page(st
 		return false;
 	}
 
-	prep_transhuge_page(*hpage);
+	folio_prep_large_rmappable((struct folio *)*hpage);
 	count_vm_event(THP_COLLAPSE_ALLOC);
 	return true;
 }
--- a/mm/mempolicy.c~mm-convert-prep_transhuge_page-to-folio_prep_large_rmappable
+++ a/mm/mempolicy.c
@@ -2195,9 +2195,9 @@ struct folio *vma_alloc_folio(gfp_t gfp,
 		mpol_cond_put(pol);
 		gfp |= __GFP_COMP;
 		page = alloc_page_interleave(gfp, order, nid);
-		if (page && order > 1)
-			prep_transhuge_page(page);
 		folio = (struct folio *)page;
+		if (folio && order > 1)
+			folio_prep_large_rmappable(folio);
 		goto out;
 	}
 
@@ -2208,9 +2208,9 @@ struct folio *vma_alloc_folio(gfp_t gfp,
 		gfp |= __GFP_COMP;
 		page = alloc_pages_preferred_many(gfp, order, node, pol);
 		mpol_cond_put(pol);
-		if (page && order > 1)
-			prep_transhuge_page(page);
 		folio = (struct folio *)page;
+		if (folio && order > 1)
+			folio_prep_large_rmappable(folio);
 		goto out;
 	}
 
@@ -2306,10 +2306,11 @@ EXPORT_SYMBOL(alloc_pages);
 struct folio *folio_alloc(gfp_t gfp, unsigned order)
 {
 	struct page *page = alloc_pages(gfp | __GFP_COMP, order);
+	struct folio *folio = (struct folio *)page;
 
-	if (page && order > 1)
-		prep_transhuge_page(page);
-	return (struct folio *)page;
+	if (folio && order > 1)
+		folio_prep_large_rmappable(folio);
+	return folio;
 }
 EXPORT_SYMBOL(folio_alloc);
 
--- a/mm/page_alloc.c~mm-convert-prep_transhuge_page-to-folio_prep_large_rmappable
+++ a/mm/page_alloc.c
@@ -4489,10 +4489,11 @@ struct folio *__folio_alloc(gfp_t gfp, u
 {
 	struct page *page = __alloc_pages(gfp | __GFP_COMP, order,
 			preferred_nid, nodemask);
+	struct folio *folio = (struct folio *)page;
 
-	if (page && order > 1)
-		prep_transhuge_page(page);
-	return (struct folio *)page;
+	if (folio && order > 1)
+		folio_prep_large_rmappable(folio);
+	return folio;
 }
 EXPORT_SYMBOL(__folio_alloc);
 
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

