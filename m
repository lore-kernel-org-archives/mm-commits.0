Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9482DC2FC04
	for <mm-commits@archiver.kernel.org>; Wed, 16 Aug 2023 22:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346930AbjHPWnu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Aug 2023 18:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346945AbjHPWn1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Aug 2023 18:43:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB21B173F
        for <mm-commits@vger.kernel.org>; Wed, 16 Aug 2023 15:43:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EDFC656B8
        for <mm-commits@vger.kernel.org>; Wed, 16 Aug 2023 22:43:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F62C433C8;
        Wed, 16 Aug 2023 22:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692225804;
        bh=f+LPff/v+8f9jupc4uE1a7Epojh2qjm9F/KRkzlMbUg=;
        h=Date:To:From:Subject:From;
        b=rxSenQUOwqczUmFmt5Sj6e36+7FW0xSOxi9cxz7JVYaORsbJ3hbk0P/u9ZZppd87b
         NX3hsLDM8jOeSi/+D2BzH662QKQlTMVOcKNK/XubJ5ceWO4C0+xZfwphX2cnrOwffx
         dGfbYip7KPBeKzb/WrY+lttivFQTm7GunFF8S8T0=
Date:   Wed, 16 Aug 2023 15:43:24 -0700
To:     mm-commits@vger.kernel.org, siyanteng@loongson.cn,
        sidhartha.kumar@oracle.com, david@redhat.com, axboe@kernel.dk,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-free_compound_page-and-the-compound_page_dtors-array.patch added to mm-unstable branch
Message-Id: <20230816224324.A2F62C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove free_compound_page() and the compound_page_dtors array
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-free_compound_page-and-the-compound_page_dtors-array.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-free_compound_page-and-the-compound_page_dtors-array.patch

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
Subject: mm: remove free_compound_page() and the compound_page_dtors array
Date: Wed, 16 Aug 2023 16:11:54 +0100

The only remaining destructor is free_compound_page().  Inline it into
destroy_large_folio() and remove the array it used to live in.

Link: https://lkml.kernel.org/r/20230816151201.3655946-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Yanteng Si <siyanteng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   10 ----------
 mm/page_alloc.c    |   24 +++++-------------------
 2 files changed, 5 insertions(+), 29 deletions(-)

--- a/include/linux/mm.h~mm-remove-free_compound_page-and-the-compound_page_dtors-array
+++ a/include/linux/mm.h
@@ -1272,14 +1272,6 @@ void folio_copy(struct folio *dst, struc
 
 unsigned long nr_free_buffer_pages(void);
 
-/*
- * Compound pages have a destructor function.  Provide a
- * prototype for that function and accessor functions.
- * These are _only_ valid on the head of a compound page.
- */
-typedef void compound_page_dtor(struct page *);
-
-/* Keep the enum in sync with compound_page_dtors array in mm/page_alloc.c */
 enum compound_dtor_id {
 	NULL_COMPOUND_DTOR,
 	COMPOUND_PAGE_DTOR,
@@ -1332,8 +1324,6 @@ static inline unsigned long thp_size(str
 	return PAGE_SIZE << thp_order(page);
 }
 
-void free_compound_page(struct page *page);
-
 #ifdef CONFIG_MMU
 /*
  * Do pte_mkwrite, but only if the vma says VM_WRITE.  We do this when
--- a/mm/page_alloc.c~mm-remove-free_compound_page-and-the-compound_page_dtors-array
+++ a/mm/page_alloc.c
@@ -284,11 +284,6 @@ const char * const migratetype_names[MIG
 #endif
 };
 
-static compound_page_dtor * const compound_page_dtors[NR_COMPOUND_DTORS] = {
-	[NULL_COMPOUND_DTOR] = NULL,
-	[COMPOUND_PAGE_DTOR] = free_compound_page,
-};
-
 int min_free_kbytes = 1024;
 int user_min_free_kbytes = -1;
 static int watermark_boost_factor __read_mostly = 15000;
@@ -577,19 +572,13 @@ static inline void free_the_page(struct
  * The remaining PAGE_SIZE pages are called "tail pages". PageTail() is encoded
  * in bit 0 of page->compound_head. The rest of bits is pointer to head page.
  *
- * The first tail page's ->compound_dtor holds the offset in array of compound
- * page destructors. See compound_page_dtors.
+ * The first tail page's ->compound_dtor describes how to destroy the
+ * compound page.
  *
  * The first tail page's ->compound_order holds the order of allocation.
  * This usage means that zero-order pages may not be compound.
  */
 
-void free_compound_page(struct page *page)
-{
-	mem_cgroup_uncharge(page_folio(page));
-	free_the_page(page, compound_order(page));
-}
-
 void prep_compound_page(struct page *page, unsigned int order)
 {
 	int i;
@@ -611,14 +600,11 @@ void destroy_large_folio(struct folio *f
 		return;
 	}
 
-	if (folio_test_transhuge(folio) && dtor == TRANSHUGE_PAGE_DTOR) {
+	if (folio_test_transhuge(folio) && dtor == TRANSHUGE_PAGE_DTOR)
 		folio_undo_large_rmappable(folio);
-		free_compound_page(&folio->page);
-		return;
-	}
 
-	VM_BUG_ON_FOLIO(dtor >= NR_COMPOUND_DTORS, folio);
-	compound_page_dtors[dtor](&folio->page);
+	mem_cgroup_uncharge(folio);
+	free_the_page(&folio->page, folio_order(folio));
 }
 
 static inline void set_buddy_order(struct page *page, unsigned int order)
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

