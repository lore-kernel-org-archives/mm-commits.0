Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4371C3DA66
	for <mm-commits@archiver.kernel.org>; Wed, 23 Aug 2023 21:26:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237518AbjHWVZd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Aug 2023 17:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237556AbjHWVZF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Aug 2023 17:25:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3258F10DA
        for <mm-commits@vger.kernel.org>; Wed, 23 Aug 2023 14:25:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB75363B5F
        for <mm-commits@vger.kernel.org>; Wed, 23 Aug 2023 21:25:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE813C433C8;
        Wed, 23 Aug 2023 21:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692825902;
        bh=gvkVK3rZPLomS0nGbUF2KkSKIqcmXNqBdyJa3TyvD74=;
        h=Date:To:From:Subject:From;
        b=KHuAaxkhU2/n2N3LfJXWseNyU+Bl3YAQoFYLXtUO5HehhrZ78mdPK3FCswpLkIwTE
         kcia/RUotBK8UFeTwr30ro4feNzlhywGTUI/WMlfjbq9gtAuJgxogw+inAXOEY/jW/
         1GSDijxb+g5oPe5BoITs7c6W2usJ8o8ewIKZhUho=
Date:   Wed, 23 Aug 2023 14:25:01 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, david@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + secretmem-conert-page_is_secretmem-to-folio_is_secretmem.patch added to mm-unstable branch
Message-Id: <20230823212501.DE813C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: secretmem: convert page_is_secretmem() to folio_is_secretmem()
has been added to the -mm mm-unstable branch.  Its filename is
     secretmem-conert-page_is_secretmem-to-folio_is_secretmem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/secretmem-conert-page_is_secretmem-to-folio_is_secretmem.patch

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
Subject: secretmem: convert page_is_secretmem() to folio_is_secretmem()
Date: Tue, 22 Aug 2023 21:23:35 +0100

The only caller already has a folio, so use it to save calling
compound_head() in PageLRU() and remove a use of page->mapping.

Link: https://lkml.kernel.org/r/20230822202335.179081-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/secretmem.h |   15 +++++++--------
 mm/gup.c                  |    2 +-
 2 files changed, 8 insertions(+), 9 deletions(-)

--- a/include/linux/secretmem.h~secretmem-conert-page_is_secretmem-to-folio_is_secretmem
+++ a/include/linux/secretmem.h
@@ -6,24 +6,23 @@
 
 extern const struct address_space_operations secretmem_aops;
 
-static inline bool page_is_secretmem(struct page *page)
+static inline bool folio_is_secretmem(struct folio *folio)
 {
 	struct address_space *mapping;
 
 	/*
-	 * Using page_mapping() is quite slow because of the actual call
-	 * instruction and repeated compound_head(page) inside the
-	 * page_mapping() function.
+	 * Using folio_mapping() is quite slow because of the actual call
+	 * instruction.
 	 * We know that secretmem pages are not compound and LRU so we can
 	 * save a couple of cycles here.
 	 */
-	if (PageCompound(page) || !PageLRU(page))
+	if (folio_test_large(folio) || !folio_test_lru(folio))
 		return false;
 
 	mapping = (struct address_space *)
-		((unsigned long)page->mapping & ~PAGE_MAPPING_FLAGS);
+		((unsigned long)folio->mapping & ~PAGE_MAPPING_FLAGS);
 
-	if (!mapping || mapping != page->mapping)
+	if (!mapping || mapping != folio->mapping)
 		return false;
 
 	return mapping->a_ops == &secretmem_aops;
@@ -39,7 +38,7 @@ static inline bool vma_is_secretmem(stru
 	return false;
 }
 
-static inline bool page_is_secretmem(struct page *page)
+static inline bool folio_is_secretmem(struct folio *folio)
 {
 	return false;
 }
--- a/mm/gup.c~secretmem-conert-page_is_secretmem-to-folio_is_secretmem
+++ a/mm/gup.c
@@ -2600,7 +2600,7 @@ static int gup_pte_range(pmd_t pmd, pmd_
 		if (!folio)
 			goto pte_unmap;
 
-		if (unlikely(page_is_secretmem(page))) {
+		if (unlikely(folio_is_secretmem(folio))) {
 			gup_put_folio(folio, 1, flags);
 			goto pte_unmap;
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
arm-implement-the-new-page-table-range-api-fix-2.patch
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
mm-fix-get_mctgt_type-kernel-doc-fix-2.patch
mm-fix-clean_record_shared_mapping_range-kernel-doc.patch
mm-add-orphaned-kernel-doc-to-the-rst-files.patch
hugetlb-add-documentation-for-vma_kernel_pagesize.patch
secretmem-conert-page_is_secretmem-to-folio_is_secretmem.patch

