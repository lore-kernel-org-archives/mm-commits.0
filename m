Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51BC9C41513
	for <mm-commits@archiver.kernel.org>; Wed, 16 Aug 2023 22:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346835AbjHPWnt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Aug 2023 18:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346916AbjHPWnV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Aug 2023 18:43:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A19173F
        for <mm-commits@vger.kernel.org>; Wed, 16 Aug 2023 15:43:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A3746652D
        for <mm-commits@vger.kernel.org>; Wed, 16 Aug 2023 22:43:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE413C433C8;
        Wed, 16 Aug 2023 22:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692225798;
        bh=VI9iBlw1JqiwUwGTrTc/ZTj4gnBL9zuZ82YS7Z1yXW8=;
        h=Date:To:From:Subject:From;
        b=bNTHoTcVZFW0y6liZKWsPtKf6F7B7kWCfTW4mraGcxbxTHzM3N9ycNxtx2116Dbwe
         DHbD+wqrv1ymLvcn2lAeUtOY92YihQH5o6+Gmn2xerRH5rzjHpOdZm0r5ZUQne7rmA
         8v0RxQV+Oq9MQUtNVgqIRmsOuAoIT9PCcYD1RqT0=
Date:   Wed, 16 Aug 2023 15:43:18 -0700
To:     mm-commits@vger.kernel.org, siyanteng@loongson.cn,
        sidhartha.kumar@oracle.com, david@redhat.com, axboe@kernel.dk,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-free_transhuge_folio-to-folio_undo_large_rmappable.patch added to mm-unstable branch
Message-Id: <20230816224318.AE413C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert free_transhuge_folio() to folio_undo_large_rmappable()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-free_transhuge_folio-to-folio_undo_large_rmappable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-free_transhuge_folio-to-folio_undo_large_rmappable.patch

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
Subject: mm: convert free_transhuge_folio() to folio_undo_large_rmappable()
Date: Wed, 16 Aug 2023 16:11:52 +0100

Indirect calls are expensive, thanks to Spectre.  Test for
TRANSHUGE_PAGE_DTOR and destroy the folio appropriately.  Move the
free_compound_page() call into destroy_large_folio() to simplify later
patches.

Link: https://lkml.kernel.org/r/20230816151201.3655946-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Yanteng Si <siyanteng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    2 --
 include/linux/mm.h      |    2 --
 mm/huge_memory.c        |   22 +++++++++++-----------
 mm/internal.h           |    2 ++
 mm/page_alloc.c         |    9 ++++++---
 5 files changed, 19 insertions(+), 18 deletions(-)

--- a/include/linux/huge_mm.h~mm-convert-free_transhuge_folio-to-folio_undo_large_rmappable
+++ a/include/linux/huge_mm.h
@@ -141,8 +141,6 @@ unsigned long thp_get_unmapped_area(stru
 		unsigned long len, unsigned long pgoff, unsigned long flags);
 
 void prep_transhuge_page(struct page *page);
-void free_transhuge_page(struct page *page);
-
 bool can_split_folio(struct folio *folio, int *pextra_pins);
 int split_huge_page_to_list(struct page *page, struct list_head *list);
 static inline int split_huge_page(struct page *page)
--- a/include/linux/mm.h~mm-convert-free_transhuge_folio-to-folio_undo_large_rmappable
+++ a/include/linux/mm.h
@@ -1286,9 +1286,7 @@ enum compound_dtor_id {
 #ifdef CONFIG_HUGETLB_PAGE
 	HUGETLB_PAGE_DTOR,
 #endif
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	TRANSHUGE_PAGE_DTOR,
-#endif
 	NR_COMPOUND_DTORS,
 };
 
--- a/mm/huge_memory.c~mm-convert-free_transhuge_folio-to-folio_undo_large_rmappable
+++ a/mm/huge_memory.c
@@ -2776,10 +2776,9 @@ out:
 	return ret;
 }
 
-void free_transhuge_page(struct page *page)
+void folio_undo_large_rmappable(struct folio *folio)
 {
-	struct folio *folio = (struct folio *)page;
-	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
+	struct deferred_split *ds_queue;
 	unsigned long flags;
 
 	/*
@@ -2787,15 +2786,16 @@ void free_transhuge_page(struct page *pa
 	 * deferred_list. If folio is not in deferred_list, it's safe
 	 * to check without acquiring the split_queue_lock.
 	 */
-	if (data_race(!list_empty(&folio->_deferred_list))) {
-		spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
-		if (!list_empty(&folio->_deferred_list)) {
-			ds_queue->split_queue_len--;
-			list_del(&folio->_deferred_list);
-		}
-		spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
+	if (data_race(list_empty(&folio->_deferred_list)))
+		return;
+
+	ds_queue = get_deferred_split_queue(folio);
+	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
+	if (!list_empty(&folio->_deferred_list)) {
+		ds_queue->split_queue_len--;
+		list_del(&folio->_deferred_list);
 	}
-	free_compound_page(page);
+	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
 }
 
 void deferred_split_folio(struct folio *folio)
--- a/mm/internal.h~mm-convert-free_transhuge_folio-to-folio_undo_large_rmappable
+++ a/mm/internal.h
@@ -413,6 +413,8 @@ static inline void folio_set_order(struc
 #endif
 }
 
+void folio_undo_large_rmappable(struct folio *folio);
+
 static inline void prep_compound_head(struct page *page, unsigned int order)
 {
 	struct folio *folio = (struct folio *)page;
--- a/mm/page_alloc.c~mm-convert-free_transhuge_folio-to-folio_undo_large_rmappable
+++ a/mm/page_alloc.c
@@ -287,9 +287,6 @@ const char * const migratetype_names[MIG
 static compound_page_dtor * const compound_page_dtors[NR_COMPOUND_DTORS] = {
 	[NULL_COMPOUND_DTOR] = NULL,
 	[COMPOUND_PAGE_DTOR] = free_compound_page,
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	[TRANSHUGE_PAGE_DTOR] = free_transhuge_page,
-#endif
 };
 
 int min_free_kbytes = 1024;
@@ -614,6 +611,12 @@ void destroy_large_folio(struct folio *f
 		return;
 	}
 
+	if (folio_test_transhuge(folio) && dtor == TRANSHUGE_PAGE_DTOR) {
+		folio_undo_large_rmappable(folio);
+		free_compound_page(&folio->page);
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

