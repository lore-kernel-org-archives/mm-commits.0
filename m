Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41AFBC27C7A
	for <mm-commits@archiver.kernel.org>; Wed, 16 Aug 2023 22:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346916AbjHPWnu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Aug 2023 18:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346939AbjHPWnY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Aug 2023 18:43:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77CC173F
        for <mm-commits@vger.kernel.org>; Wed, 16 Aug 2023 15:43:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53DD5656B8
        for <mm-commits@vger.kernel.org>; Wed, 16 Aug 2023 22:43:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A62F8C433C8;
        Wed, 16 Aug 2023 22:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692225801;
        bh=Z+MKeI5JEKlleF1cZRFjexMHoQfYJ1p/d7c+94D/FFw=;
        h=Date:To:From:Subject:From;
        b=iimmANnkEs1XfIp2qMmqjLeX4sgUdxsCIB70U+3UyI6JZuyYOxANX7GZrIDE1J8Ci
         ij0yYdEuL2DiH0cHduHWUILUJVVEhMQJIZ3VwEkSRJV7r6Afdro3RsU/sP4hX4UQ7H
         1UtqgUy47+Z83v+pJ4Ehm4Nmz9JcrvzQVKe3ofas=
Date:   Wed, 16 Aug 2023 15:43:21 -0700
To:     mm-commits@vger.kernel.org, siyanteng@loongson.cn,
        sidhartha.kumar@oracle.com, david@redhat.com, axboe@kernel.dk,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-prep_transhuge_page-to-folio_prep_large_rmappable.patch added to mm-unstable branch
Message-Id: <20230816224321.A62F8C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert prep_transhuge_page() to folio_prep_large_rmappable()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-prep_transhuge_page-to-folio_prep_large_rmappable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-prep_transhuge_page-to-folio_prep_large_rmappable.patch

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
@@ -4525,10 +4525,11 @@ struct folio *__folio_alloc(gfp_t gfp, u
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

