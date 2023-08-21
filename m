Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFAD5EE4993
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 18:21:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232526AbjHUSVk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 14:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232317AbjHUSVj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 14:21:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C977AA1
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 11:21:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CB5963A7F
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 18:21:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACDCAC433C8;
        Mon, 21 Aug 2023 18:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692642096;
        bh=9h3fFL9pvFVcjJOA7nIOvQS1UTtVkVXp9aFWMwU8d3c=;
        h=Date:To:From:Subject:From;
        b=i17s0niqgJ1o1b0ggBeQ5WnV3M0TmyvcD9wHM6JkajDYn/ac4RkO/u7EKkZgDhQrq
         9LLaoqFSOxnaQVqCLycJmeFMXs/u9EA/67FrE0r8wobhbmFjY+Px3ZtgJV7XRB4lw7
         slPlGaL19alz3g3Hg/3hF1SBZnyLPX0/eNugpAtg=
Date:   Mon, 21 Aug 2023 11:21:35 -0700
To:     mm-commits@vger.kernel.org, stettberger@dokucode.de,
        rppt@kernel.org, willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-checks-for-pte_index.patch added to mm-unstable branch
Message-Id: <20230821182136.ACDCAC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove checks for pte_index
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-checks-for-pte_index.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-checks-for-pte_index.patch

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
Subject: mm: remove checks for pte_index
Date: Sat, 19 Aug 2023 04:18:37 +0100

Since pte_index is always defined, we don't need to check whether it's
defined or not.  Delete the slow version that doesn't depend on it and
remove the #define since nobody needs to test for it.

Link: https://lkml.kernel.org/r/20230819031837.3160096-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Christian Dietrich <stettberger@dokucode.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    1 -
 mm/memory.c             |   17 +----------------
 2 files changed, 1 insertion(+), 17 deletions(-)

--- a/include/linux/pgtable.h~mm-remove-checks-for-pte_index
+++ a/include/linux/pgtable.h
@@ -63,7 +63,6 @@ static inline unsigned long pte_index(un
 {
 	return (address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1);
 }
-#define pte_index pte_index
 
 #ifndef pmd_index
 static inline unsigned long pmd_index(unsigned long address)
--- a/mm/memory.c~mm-remove-checks-for-pte_index
+++ a/mm/memory.c
@@ -1869,7 +1869,6 @@ out:
 	return retval;
 }
 
-#ifdef pte_index
 static int insert_page_in_batch_locked(struct vm_area_struct *vma, pte_t *pte,
 			unsigned long addr, struct page *page, pgprot_t prot)
 {
@@ -1884,7 +1883,7 @@ static int insert_page_in_batch_locked(s
 }
 
 /* insert_pages() amortizes the cost of spinlock operations
- * when inserting pages in a loop. Arch *must* define pte_index.
+ * when inserting pages in a loop.
  */
 static int insert_pages(struct vm_area_struct *vma, unsigned long addr,
 			struct page **pages, unsigned long *num, pgprot_t prot)
@@ -1943,7 +1942,6 @@ out:
 	*num = remaining_pages_total;
 	return ret;
 }
-#endif  /* ifdef pte_index */
 
 /**
  * vm_insert_pages - insert multiple pages into user vma, batching the pmd lock.
@@ -1963,7 +1961,6 @@ out:
 int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
 			struct page **pages, unsigned long *num)
 {
-#ifdef pte_index
 	const unsigned long end_addr = addr + (*num * PAGE_SIZE) - 1;
 
 	if (addr < vma->vm_start || end_addr >= vma->vm_end)
@@ -1975,18 +1972,6 @@ int vm_insert_pages(struct vm_area_struc
 	}
 	/* Defer page refcount checking till we're about to map that page. */
 	return insert_pages(vma, addr, pages, num, vma->vm_page_prot);
-#else
-	unsigned long idx = 0, pgcount = *num;
-	int err = -EINVAL;
-
-	for (; idx < pgcount; ++idx) {
-		err = vm_insert_page(vma, addr + (PAGE_SIZE * idx), pages[idx]);
-		if (err)
-			break;
-	}
-	*num = pgcount - idx;
-	return err;
-#endif  /* ifdef pte_index */
 }
 EXPORT_SYMBOL(vm_insert_pages);
 
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
mm-swap-use-dedicated-entry-for-swap-in-folio.patch
mm-remove-checks-for-pte_index.patch

