Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 777BBEE49A5
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 21:29:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbjHUV3s (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 17:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbjHUV3m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 17:29:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D427E184
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 14:29:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A77DF61366
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 21:29:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B50FC433C8;
        Mon, 21 Aug 2023 21:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692653374;
        bh=kwqvz++NWgLhtdQt7DOAMHFXyWWhQmqVxDncpDhKF50=;
        h=Date:To:From:Subject:From;
        b=196HFnv2xfii+I7zEhSby7AGktwXKGLOw/IFfcn24m/omeZWEfn2yFzhDITduZNdy
         z2OU0BLyuxPmZ7ooT9GDANGXKuF01Sgq1qdF5JQB/2ZQsVFLqNBzTQMqVmcHn/++Nn
         MYMDv+iU8RjRjtmgJjABxjDAjWstQL8Qncw6ZCFg=
Date:   Mon, 21 Aug 2023 14:29:33 -0700
To:     mm-commits@vger.kernel.org, siyanteng@loongson.cn,
        sidhartha.kumar@oracle.com, david@redhat.com, axboe@kernel.dk,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-hugetlb_page_dtor.patch removed from -mm tree
Message-Id: <20230821212934.0B50FC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove HUGETLB_PAGE_DTOR
has been removed from the -mm tree.  Its filename was
     mm-remove-hugetlb_page_dtor.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove HUGETLB_PAGE_DTOR
Date: Wed, 16 Aug 2023 16:11:55 +0100

We can use a bit in page[1].flags to indicate that this folio belongs to
hugetlb instead of using a value in page[1].dtors.  That lets
folio_test_hugetlb() become an inline function like it should be.  We can
also get rid of NULL_COMPOUND_DTOR.

Link: https://lkml.kernel.org/r/20230816151201.3655946-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Yanteng Si <siyanteng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kdump/vmcoreinfo.rst |   10 ---
 include/linux/mm.h                             |    4 -
 include/linux/page-flags.h                     |   43 ++++++++++---
 kernel/crash_core.c                            |    2 
 mm/hugetlb.c                                   |   49 +--------------
 mm/page_alloc.c                                |    2 
 6 files changed, 43 insertions(+), 67 deletions(-)

--- a/Documentation/admin-guide/kdump/vmcoreinfo.rst~mm-remove-hugetlb_page_dtor
+++ a/Documentation/admin-guide/kdump/vmcoreinfo.rst
@@ -325,8 +325,8 @@ NR_FREE_PAGES
 On linux-2.6.21 or later, the number of free pages is in
 vm_stat[NR_FREE_PAGES]. Used to get the number of free pages.
 
-PG_lru|PG_private|PG_swapcache|PG_swapbacked|PG_slab|PG_hwpoision|PG_head_mask
-------------------------------------------------------------------------------
+PG_lru|PG_private|PG_swapcache|PG_swapbacked|PG_slab|PG_hwpoision|PG_head_mask|PG_hugetlb
+-----------------------------------------------------------------------------------------
 
 Page attributes. These flags are used to filter various unnecessary for
 dumping pages.
@@ -338,12 +338,6 @@ More page attributes. These flags are us
 dumping pages.
 
 
-HUGETLB_PAGE_DTOR
------------------
-
-The HUGETLB_PAGE_DTOR flag denotes hugetlbfs pages. Makedumpfile
-excludes these pages.
-
 x86_64
 ======
 
--- a/include/linux/mm.h~mm-remove-hugetlb_page_dtor
+++ a/include/linux/mm.h
@@ -1240,11 +1240,7 @@ void folio_copy(struct folio *dst, struc
 unsigned long nr_free_buffer_pages(void);
 
 enum compound_dtor_id {
-	NULL_COMPOUND_DTOR,
 	COMPOUND_PAGE_DTOR,
-#ifdef CONFIG_HUGETLB_PAGE
-	HUGETLB_PAGE_DTOR,
-#endif
 	TRANSHUGE_PAGE_DTOR,
 	NR_COMPOUND_DTORS,
 };
--- a/include/linux/page-flags.h~mm-remove-hugetlb_page_dtor
+++ a/include/linux/page-flags.h
@@ -171,15 +171,6 @@ enum pageflags {
 	/* Remapped by swiotlb-xen. */
 	PG_xen_remapped = PG_owner_priv_1,
 
-#ifdef CONFIG_MEMORY_FAILURE
-	/*
-	 * Compound pages. Stored in first tail page's flags.
-	 * Indicates that at least one subpage is hwpoisoned in the
-	 * THP.
-	 */
-	PG_has_hwpoisoned = PG_error,
-#endif
-
 	/* non-lru isolated movable page */
 	PG_isolated = PG_reclaim,
 
@@ -190,6 +181,15 @@ enum pageflags {
 	/* For self-hosted memmap pages */
 	PG_vmemmap_self_hosted = PG_owner_priv_1,
 #endif
+
+	/*
+	 * Flags only valid for compound pages.  Stored in first tail page's
+	 * flags word.
+	 */
+
+	/* At least one page in this folio has the hwpoison flag set */
+	PG_has_hwpoisoned = PG_error,
+	PG_hugetlb = PG_active,
 };
 
 #define PAGEFLAGS_MASK		((1UL << NR_PAGEFLAGS) - 1)
@@ -812,7 +812,23 @@ static inline void ClearPageCompound(str
 
 #ifdef CONFIG_HUGETLB_PAGE
 int PageHuge(struct page *page);
-bool folio_test_hugetlb(struct folio *folio);
+SETPAGEFLAG(HugeTLB, hugetlb, PF_SECOND)
+CLEARPAGEFLAG(HugeTLB, hugetlb, PF_SECOND)
+
+/**
+ * folio_test_hugetlb - Determine if the folio belongs to hugetlbfs
+ * @folio: The folio to test.
+ *
+ * Context: Any context.  Caller should have a reference on the folio to
+ * prevent it from being turned into a tail page.
+ * Return: True for hugetlbfs folios, false for anon folios or folios
+ * belonging to other filesystems.
+ */
+static inline bool folio_test_hugetlb(struct folio *folio)
+{
+	return folio_test_large(folio) &&
+		test_bit(PG_hugetlb, folio_flags(folio, 1));
+}
 #else
 TESTPAGEFLAG_FALSE(Huge, hugetlb)
 #endif
@@ -1056,6 +1072,13 @@ static __always_inline void __ClearPageA
 #define PAGE_FLAGS_CHECK_AT_PREP	\
 	((PAGEFLAGS_MASK & ~__PG_HWPOISON) | LRU_GEN_MASK | LRU_REFS_MASK)
 
+/*
+ * Flags stored in the second page of a compound page.  They may overlap
+ * the CHECK_AT_FREE flags above, so need to be cleared.
+ */
+#define PAGE_FLAGS_SECOND						\
+	(1UL << PG_has_hwpoisoned	| 1UL << PG_hugetlb)
+
 #define PAGE_FLAGS_PRIVATE				\
 	(1UL << PG_private | 1UL << PG_private_2)
 /**
--- a/kernel/crash_core.c~mm-remove-hugetlb_page_dtor
+++ a/kernel/crash_core.c
@@ -490,7 +490,7 @@ static int __init crash_save_vmcoreinfo_
 #define PAGE_BUDDY_MAPCOUNT_VALUE	(~PG_buddy)
 	VMCOREINFO_NUMBER(PAGE_BUDDY_MAPCOUNT_VALUE);
 #ifdef CONFIG_HUGETLB_PAGE
-	VMCOREINFO_NUMBER(HUGETLB_PAGE_DTOR);
+	VMCOREINFO_NUMBER(PG_hugetlb);
 #define PAGE_OFFLINE_MAPCOUNT_VALUE	(~PG_offline)
 	VMCOREINFO_NUMBER(PAGE_OFFLINE_MAPCOUNT_VALUE);
 #endif
--- a/mm/hugetlb.c~mm-remove-hugetlb_page_dtor
+++ a/mm/hugetlb.c
@@ -1585,25 +1585,7 @@ static inline void __clear_hugetlb_destr
 {
 	lockdep_assert_held(&hugetlb_lock);
 
-	/*
-	 * Very subtle
-	 *
-	 * For non-gigantic pages set the destructor to the normal compound
-	 * page dtor.  This is needed in case someone takes an additional
-	 * temporary ref to the page, and freeing is delayed until they drop
-	 * their reference.
-	 *
-	 * For gigantic pages set the destructor to the null dtor.  This
-	 * destructor will never be called.  Before freeing the gigantic
-	 * page destroy_compound_gigantic_folio will turn the folio into a
-	 * simple group of pages.  After this the destructor does not
-	 * apply.
-	 *
-	 */
-	if (hstate_is_gigantic(h))
-		folio_set_compound_dtor(folio, NULL_COMPOUND_DTOR);
-	else
-		folio_set_compound_dtor(folio, COMPOUND_PAGE_DTOR);
+	folio_clear_hugetlb(folio);
 }
 
 /*
@@ -1690,7 +1672,7 @@ static void add_hugetlb_folio(struct hst
 		h->surplus_huge_pages_node[nid]++;
 	}
 
-	folio_set_compound_dtor(folio, HUGETLB_PAGE_DTOR);
+	folio_set_hugetlb(folio);
 	folio_change_private(folio, NULL);
 	/*
 	 * We have to set hugetlb_vmemmap_optimized again as above
@@ -1814,9 +1796,8 @@ static void free_hpage_workfn(struct wor
 		/*
 		 * The VM_BUG_ON_FOLIO(!folio_test_hugetlb(folio), folio) in
 		 * folio_hstate() is going to trigger because a previous call to
-		 * remove_hugetlb_folio() will call folio_set_compound_dtor
-		 * (folio, NULL_COMPOUND_DTOR), so do not use folio_hstate()
-		 * directly.
+		 * remove_hugetlb_folio() will clear the hugetlb bit, so do
+		 * not use folio_hstate() directly.
 		 */
 		h = size_to_hstate(page_size(page));
 
@@ -1955,7 +1936,7 @@ static void __prep_new_hugetlb_folio(str
 {
 	hugetlb_vmemmap_optimize(h, &folio->page);
 	INIT_LIST_HEAD(&folio->lru);
-	folio_set_compound_dtor(folio, HUGETLB_PAGE_DTOR);
+	folio_set_hugetlb(folio);
 	hugetlb_set_folio_subpool(folio, NULL);
 	set_hugetlb_cgroup(folio, NULL);
 	set_hugetlb_cgroup_rsvd(folio, NULL);
@@ -2070,28 +2051,10 @@ int PageHuge(struct page *page)
 	if (!PageCompound(page))
 		return 0;
 	folio = page_folio(page);
-	return folio->_folio_dtor == HUGETLB_PAGE_DTOR;
+	return folio_test_hugetlb(folio);
 }
 EXPORT_SYMBOL_GPL(PageHuge);
 
-/**
- * folio_test_hugetlb - Determine if the folio belongs to hugetlbfs
- * @folio: The folio to test.
- *
- * Context: Any context.  Caller should have a reference on the folio to
- * prevent it from being turned into a tail page.
- * Return: True for hugetlbfs folios, false for anon folios or folios
- * belonging to other filesystems.
- */
-bool folio_test_hugetlb(struct folio *folio)
-{
-	if (!folio_test_large(folio))
-		return false;
-
-	return folio->_folio_dtor == HUGETLB_PAGE_DTOR;
-}
-EXPORT_SYMBOL_GPL(folio_test_hugetlb);
-
 /*
  * Find and lock address space (mapping) in write mode.
  *
--- a/mm/page_alloc.c~mm-remove-hugetlb_page_dtor
+++ a/mm/page_alloc.c
@@ -1112,7 +1112,7 @@ static __always_inline bool free_pages_p
 		VM_BUG_ON_PAGE(compound && compound_order(page) != order, page);
 
 		if (compound)
-			ClearPageHasHWPoisoned(page);
+			page[1].flags &= ~PAGE_FLAGS_SECOND;
 		for (i = 1; i < (1 << order); i++) {
 			if (compound)
 				bad += free_tail_page_prepare(page, page + i);
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

