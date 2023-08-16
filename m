Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B64D9C2FC06
	for <mm-commits@archiver.kernel.org>; Wed, 16 Aug 2023 22:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346972AbjHPWnv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Aug 2023 18:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347005AbjHPWni (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Aug 2023 18:43:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD564173F
        for <mm-commits@vger.kernel.org>; Wed, 16 Aug 2023 15:43:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63C1163C02
        for <mm-commits@vger.kernel.org>; Wed, 16 Aug 2023 22:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC511C433C8;
        Wed, 16 Aug 2023 22:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692225815;
        bh=wfJeO4t6QGsswkpHxP9boZDHry6yOHghFCM9/ZSEpu0=;
        h=Date:To:From:Subject:From;
        b=xEI81/s12I25sGgllxJMCj/xjfop/snfTuyQnHXwXSh005f3K404j4jT4QUgW4EEP
         g6DNuYPjFWp7tjyd4T/mSUgcL2qrZbfgExjSjVAefBrqfJI0cqN5NSlIo0rvkbhlVH
         VjMl+tC1q5AL1+rdgVkHq9gDaeHeOgIQilxPkLPQ=
Date:   Wed, 16 Aug 2023 15:43:35 -0700
To:     mm-commits@vger.kernel.org, siyanteng@loongson.cn,
        sidhartha.kumar@oracle.com, david@redhat.com, axboe@kernel.dk,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-free-up-a-word-in-the-first-tail-page.patch added to mm-unstable branch
Message-Id: <20230816224335.BC511C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: free up a word in the first tail page
has been added to the -mm mm-unstable branch.  Its filename is
     mm-free-up-a-word-in-the-first-tail-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-free-up-a-word-in-the-first-tail-page.patch

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
Subject: mm: free up a word in the first tail page
Date: Wed, 16 Aug 2023 16:11:58 +0100

Store the folio order in the low byte of the flags word in the first tail
page.  This frees up the word that was being used to store the order and
dtor bytes previously.

Link: https://lkml.kernel.org/r/20230816151201.3655946-11-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Yanteng Si <siyanteng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h         |   10 +++++-----
 include/linux/mm_types.h   |    3 +--
 include/linux/page-flags.h |    7 ++++---
 kernel/crash_core.c        |    1 -
 mm/internal.h              |    2 +-
 5 files changed, 11 insertions(+), 12 deletions(-)

--- a/include/linux/mm.h~mm-free-up-a-word-in-the-first-tail-page
+++ a/include/linux/mm.h
@@ -1033,7 +1033,7 @@ struct inode;
  * compound_order() can be called without holding a reference, which means
  * that niceties like page_folio() don't work.  These callers should be
  * prepared to handle wild return values.  For example, PG_head may be
- * set before _folio_order is initialised, or this may be a tail page.
+ * set before the order is initialised, or this may be a tail page.
  * See compaction.c for some good examples.
  */
 static inline unsigned int compound_order(struct page *page)
@@ -1042,7 +1042,7 @@ static inline unsigned int compound_orde
 
 	if (!test_bit(PG_head, &folio->flags))
 		return 0;
-	return folio->_folio_order;
+	return folio->_flags_1 & 0xff;
 }
 
 /**
@@ -1058,7 +1058,7 @@ static inline unsigned int folio_order(s
 {
 	if (!folio_test_large(folio))
 		return 0;
-	return folio->_folio_order;
+	return folio->_flags_1 & 0xff;
 }
 
 #include <linux/huge_mm.h>
@@ -2030,7 +2030,7 @@ static inline long folio_nr_pages(struct
 #ifdef CONFIG_64BIT
 	return folio->_folio_nr_pages;
 #else
-	return 1L << folio->_folio_order;
+	return 1L << (folio->_flags_1 & 0xff);
 #endif
 }
 
@@ -2048,7 +2048,7 @@ static inline unsigned long compound_nr(
 #ifdef CONFIG_64BIT
 	return folio->_folio_nr_pages;
 #else
-	return 1L << folio->_folio_order;
+	return 1L << (folio->_flags_1 & 0xff);
 #endif
 }
 
--- a/include/linux/mm_types.h~mm-free-up-a-word-in-the-first-tail-page
+++ a/include/linux/mm_types.h
@@ -264,7 +264,6 @@ static inline struct page *encoded_page_
  * @_refcount: Do not access this member directly.  Use folio_ref_count()
  *    to find how many references there are to this folio.
  * @memcg_data: Memory Control Group data.
- * @_folio_order: Do not use directly, call folio_order().
  * @_entire_mapcount: Do not use directly, call folio_entire_mapcount().
  * @_nr_pages_mapped: Do not use directly, call folio_mapcount().
  * @_pincount: Do not use directly, call folio_maybe_dma_pinned().
@@ -316,8 +315,8 @@ struct folio {
 		struct {
 			unsigned long _flags_1;
 			unsigned long _head_1;
+			unsigned long _folio_avail;
 	/* public: */
-			unsigned char _folio_order;
 			atomic_t _entire_mapcount;
 			atomic_t _nr_pages_mapped;
 			atomic_t _pincount;
--- a/include/linux/page-flags.h~mm-free-up-a-word-in-the-first-tail-page
+++ a/include/linux/page-flags.h
@@ -184,7 +184,8 @@ enum pageflags {
 
 	/*
 	 * Flags only valid for compound pages.  Stored in first tail page's
-	 * flags word.
+	 * flags word.  Cannot use the first 8 flags or any flag marked as
+	 * PF_ANY.
 	 */
 
 	/* At least one page in this folio has the hwpoison flag set */
@@ -1081,8 +1082,8 @@ static __always_inline void __ClearPageA
  * the CHECK_AT_FREE flags above, so need to be cleared.
  */
 #define PAGE_FLAGS_SECOND						\
-	(1UL << PG_has_hwpoisoned	| 1UL << PG_hugetlb |		\
-	 1UL << PG_large_rmappable)
+	(0xffUL /* order */		| 1UL << PG_has_hwpoisoned |	\
+	 1UL << PG_hugetlb		| 1UL << PG_large_rmappable)
 
 #define PAGE_FLAGS_PRIVATE				\
 	(1UL << PG_private | 1UL << PG_private_2)
--- a/kernel/crash_core.c~mm-free-up-a-word-in-the-first-tail-page
+++ a/kernel/crash_core.c
@@ -455,7 +455,6 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_OFFSET(page, lru);
 	VMCOREINFO_OFFSET(page, _mapcount);
 	VMCOREINFO_OFFSET(page, private);
-	VMCOREINFO_OFFSET(folio, _folio_order);
 	VMCOREINFO_OFFSET(page, compound_head);
 	VMCOREINFO_OFFSET(pglist_data, node_zones);
 	VMCOREINFO_OFFSET(pglist_data, nr_zones);
--- a/mm/internal.h~mm-free-up-a-word-in-the-first-tail-page
+++ a/mm/internal.h
@@ -407,7 +407,7 @@ static inline void folio_set_order(struc
 	if (WARN_ON_ONCE(!order || !folio_test_large(folio)))
 		return;
 
-	folio->_folio_order = order;
+	folio->_flags_1 = (folio->_flags_1 & ~0xffUL) | order;
 #ifdef CONFIG_64BIT
 	folio->_folio_nr_pages = 1U << order;
 #endif
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

