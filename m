Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7378AC2FC02
	for <mm-commits@archiver.kernel.org>; Wed, 16 Aug 2023 22:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346960AbjHPWnv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Aug 2023 18:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346987AbjHPWnc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Aug 2023 18:43:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B87E1980
        for <mm-commits@vger.kernel.org>; Wed, 16 Aug 2023 15:43:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE9EC63C02
        for <mm-commits@vger.kernel.org>; Wed, 16 Aug 2023 22:43:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D41C433C7;
        Wed, 16 Aug 2023 22:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692225810;
        bh=gYv5bOcLlGHgs8yUwIwV8iQZU0pGQPdZlRYx0JOCaqg=;
        h=Date:To:From:Subject:From;
        b=zefJDoDZ8XoNaTcSxYoyDRk5tMkx62AQ1UVcLO+i4EcqTvUAgQJvtIiFwcjg1PneZ
         Sibl+EvRVr/wxMUozlz+BqHEXOz14m4yCYOgy35u0VLR6KnB33WySDhwGFBQ5F4c9r
         DU4kmAgPWrteF2Nco1kX+j9td7o5GGpb4aQZ1m/Q=
Date:   Wed, 16 Aug 2023 15:43:29 -0700
To:     mm-commits@vger.kernel.org, siyanteng@loongson.cn,
        sidhartha.kumar@oracle.com, david@redhat.com, axboe@kernel.dk,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-large_rmappable-page-flag.patch added to mm-unstable branch
Message-Id: <20230816224330.30D41C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add large_rmappable page flag
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-large_rmappable-page-flag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-large_rmappable-page-flag.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add large_rmappable page flag
Date: Wed, 16 Aug 2023 16:11:56 +0100

Stored in the first tail page's flags, this flag replaces the destructor. 
That removes the last of the destructors, so remove all references to
folio_dtor and compound_dtor.

Link: https://lkml.kernel.org/r/20230816151201.3655946-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Yanteng Si <siyanteng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kdump/vmcoreinfo.rst |    4 ++--
 include/linux/mm.h                             |   13 -------------
 include/linux/mm_types.h                       |    2 --
 include/linux/page-flags.h                     |    7 ++++++-
 kernel/crash_core.c                            |    1 -
 mm/huge_memory.c                               |    4 ++--
 mm/internal.h                                  |    1 -
 mm/page_alloc.c                                |    7 +------
 8 files changed, 11 insertions(+), 28 deletions(-)

--- a/Documentation/admin-guide/kdump/vmcoreinfo.rst~mm-add-large_rmappable-page-flag
+++ a/Documentation/admin-guide/kdump/vmcoreinfo.rst
@@ -141,8 +141,8 @@ nodemask_t
 The size of a nodemask_t type. Used to compute the number of online
 nodes.
 
-(page, flags|_refcount|mapping|lru|_mapcount|private|compound_dtor|compound_order|compound_head)
--------------------------------------------------------------------------------------------------
+(page, flags|_refcount|mapping|lru|_mapcount|private|compound_order|compound_head)
+----------------------------------------------------------------------------------
 
 User-space tools compute their values based on the offset of these
 variables. The variables are used when excluding unnecessary pages.
--- a/include/linux/mm.h~mm-add-large_rmappable-page-flag
+++ a/include/linux/mm.h
@@ -1272,19 +1272,6 @@ void folio_copy(struct folio *dst, struc
 
 unsigned long nr_free_buffer_pages(void);
 
-enum compound_dtor_id {
-	COMPOUND_PAGE_DTOR,
-	TRANSHUGE_PAGE_DTOR,
-	NR_COMPOUND_DTORS,
-};
-
-static inline void folio_set_compound_dtor(struct folio *folio,
-		enum compound_dtor_id compound_dtor)
-{
-	VM_BUG_ON_FOLIO(compound_dtor >= NR_COMPOUND_DTORS, folio);
-	folio->_folio_dtor = compound_dtor;
-}
-
 void destroy_large_folio(struct folio *folio);
 
 /* Returns the number of bytes in this potentially compound page. */
--- a/include/linux/mm_types.h~mm-add-large_rmappable-page-flag
+++ a/include/linux/mm_types.h
@@ -264,7 +264,6 @@ static inline struct page *encoded_page_
  * @_refcount: Do not access this member directly.  Use folio_ref_count()
  *    to find how many references there are to this folio.
  * @memcg_data: Memory Control Group data.
- * @_folio_dtor: Which destructor to use for this folio.
  * @_folio_order: Do not use directly, call folio_order().
  * @_entire_mapcount: Do not use directly, call folio_entire_mapcount().
  * @_nr_pages_mapped: Do not use directly, call folio_mapcount().
@@ -318,7 +317,6 @@ struct folio {
 			unsigned long _flags_1;
 			unsigned long _head_1;
 	/* public: */
-			unsigned char _folio_dtor;
 			unsigned char _folio_order;
 			atomic_t _entire_mapcount;
 			atomic_t _nr_pages_mapped;
--- a/include/linux/page-flags.h~mm-add-large_rmappable-page-flag
+++ a/include/linux/page-flags.h
@@ -190,6 +190,7 @@ enum pageflags {
 	/* At least one page in this folio has the hwpoison flag set */
 	PG_has_hwpoisoned = PG_error,
 	PG_hugetlb = PG_active,
+	PG_large_rmappable = PG_workingset, /* anon or file-backed */
 };
 
 #define PAGEFLAGS_MASK		((1UL << NR_PAGEFLAGS) - 1)
@@ -806,6 +807,9 @@ static inline void ClearPageCompound(str
 	BUG_ON(!PageHead(page));
 	ClearPageHead(page);
 }
+PAGEFLAG(LargeRmappable, large_rmappable, PF_SECOND)
+#else
+TESTPAGEFLAG_FALSE(LargeRmappable, large_rmappable)
 #endif
 
 #define PG_head_mask ((1UL << PG_head))
@@ -1077,7 +1081,8 @@ static __always_inline void __ClearPageA
  * the CHECK_AT_FREE flags above, so need to be cleared.
  */
 #define PAGE_FLAGS_SECOND						\
-	(1UL << PG_has_hwpoisoned	| 1UL << PG_hugetlb)
+	(1UL << PG_has_hwpoisoned	| 1UL << PG_hugetlb |		\
+	 1UL << PG_large_rmappable)
 
 #define PAGE_FLAGS_PRIVATE				\
 	(1UL << PG_private | 1UL << PG_private_2)
--- a/kernel/crash_core.c~mm-add-large_rmappable-page-flag
+++ a/kernel/crash_core.c
@@ -455,7 +455,6 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_OFFSET(page, lru);
 	VMCOREINFO_OFFSET(page, _mapcount);
 	VMCOREINFO_OFFSET(page, private);
-	VMCOREINFO_OFFSET(folio, _folio_dtor);
 	VMCOREINFO_OFFSET(folio, _folio_order);
 	VMCOREINFO_OFFSET(page, compound_head);
 	VMCOREINFO_OFFSET(pglist_data, node_zones);
--- a/mm/huge_memory.c~mm-add-large_rmappable-page-flag
+++ a/mm/huge_memory.c
@@ -581,7 +581,7 @@ void folio_prep_large_rmappable(struct f
 {
 	VM_BUG_ON_FOLIO(folio_order(folio) < 2, folio);
 	INIT_LIST_HEAD(&folio->_deferred_list);
-	folio_set_compound_dtor(folio, TRANSHUGE_PAGE_DTOR);
+	folio_set_large_rmappable(folio);
 }
 
 static inline bool is_transparent_hugepage(struct page *page)
@@ -593,7 +593,7 @@ static inline bool is_transparent_hugepa
 
 	folio = page_folio(page);
 	return is_huge_zero_page(&folio->page) ||
-	       folio->_folio_dtor == TRANSHUGE_PAGE_DTOR;
+		folio_test_large_rmappable(folio);
 }
 
 static unsigned long __thp_get_unmapped_area(struct file *filp,
--- a/mm/internal.h~mm-add-large_rmappable-page-flag
+++ a/mm/internal.h
@@ -419,7 +419,6 @@ static inline void prep_compound_head(st
 {
 	struct folio *folio = (struct folio *)page;
 
-	folio_set_compound_dtor(folio, COMPOUND_PAGE_DTOR);
 	folio_set_order(folio, order);
 	atomic_set(&folio->_entire_mapcount, -1);
 	atomic_set(&folio->_nr_pages_mapped, 0);
--- a/mm/page_alloc.c~mm-add-large_rmappable-page-flag
+++ a/mm/page_alloc.c
@@ -572,9 +572,6 @@ static inline void free_the_page(struct
  * The remaining PAGE_SIZE pages are called "tail pages". PageTail() is encoded
  * in bit 0 of page->compound_head. The rest of bits is pointer to head page.
  *
- * The first tail page's ->compound_dtor describes how to destroy the
- * compound page.
- *
  * The first tail page's ->compound_order holds the order of allocation.
  * This usage means that zero-order pages may not be compound.
  */
@@ -593,14 +590,12 @@ void prep_compound_page(struct page *pag
 
 void destroy_large_folio(struct folio *folio)
 {
-	enum compound_dtor_id dtor = folio->_folio_dtor;
-
 	if (folio_test_hugetlb(folio)) {
 		free_huge_folio(folio);
 		return;
 	}
 
-	if (folio_test_transhuge(folio) && dtor == TRANSHUGE_PAGE_DTOR)
+	if (folio_test_large_rmappable(folio))
 		folio_undo_large_rmappable(folio);
 
 	mem_cgroup_uncharge(folio);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-memoryc-fix-mismerge.patch
mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed-fix.patch
zswap-make-zswap_store-take-a-folio.patch
memcg-convert-get_obj_cgroup_from_page-to-get_obj_cgroup_from_folio.patch
swap-remove-some-calls-to-compound_head-in-swap_readpage.patch
zswap-make-zswap_load-take-a-folio.patch
mm-improve-the-comment-in-isolate_migratepages_block.patch
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
mm-allow-fault_dirty_shared_page-to-be-called-under-the-vma-lock.patch
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

