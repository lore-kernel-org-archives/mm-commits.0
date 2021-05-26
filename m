Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34426C47082
	for <mm-commits@archiver.kernel.org>; Wed, 26 May 2021 22:43:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 113DD6108B
	for <mm-commits@archiver.kernel.org>; Wed, 26 May 2021 22:43:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234510AbhEZWpQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 May 2021 18:45:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:55874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231419AbhEZWpQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 26 May 2021 18:45:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D2A9613D2;
        Wed, 26 May 2021 22:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622069023;
        bh=sjHp6oEgKkK0i18oHlr4V88BGFUHX5ecfpKuzzRvrOU=;
        h=Date:From:To:Subject:From;
        b=Tlv2gJQWBTp3LvSUpaANU3tHbTS8LtkwxaENcifoQ9AFdDj1Pn6t5hO0yEOqZd1Qm
         AiL+Bni5gHVc6Z9Qx4exAS7AJ32MFFZuhjW0OuwwQZ3MtIdRYcbm8dfLHZZD8fCIgo
         gy3Pyrws0WL9cD1MIR9GRdMRNeugH9CUxboHHaUE=
Date:   Wed, 26 May 2021 15:43:43 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, lkp@intel.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        shy828301@gmail.com, wangyugui@e16-tech.com, ziy@nvidia.com
Subject:  [obsolete]
 mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix.patch removed
 from -mm tree
Message-ID: <20210526224343.6_rS6pa2W%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix

remove unused local unmap_page():unmap_success

Reported-by: kernel test robot <lkp@intel.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Wang Yugui <wangyugui@e16-tech.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/huge_memory.c~mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix
+++ a/mm/huge_memory.c
@@ -2348,7 +2348,6 @@ void vma_adjust_trans_huge(struct vm_are
 static void unmap_page(struct page *page)
 {
 	enum ttu_flags ttu_flags = TTU_RMAP_LOCKED | TTU_SPLIT_HUGE_PMD;
-	bool unmap_success;
 
 	VM_BUG_ON_PAGE(!PageHead(page), page);
 
@@ -2360,8 +2359,7 @@ static void unmap_page(struct page *page
 		 * helps handle cases when i_size is in the middle of the page
 		 * as there is no need to unmap pages beyond i_size manually.
 		 */
-		unmap_success = try_to_unmap(page, ttu_flags |
-						TTU_IGNORE_MLOCK);
+		try_to_unmap(page, ttu_flags | TTU_IGNORE_MLOCK);
 	VM_BUG_ON_PAGE(!unmap_success, page);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-hugetlb-fix-resv_huge_pages-underflow-on-uffdio_copy-fix.patch
mm.patch
mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5-fix.patch
binfmt-remove-in-tree-usage-of-map_executable-fix.patch
mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
powerpc-mm-book3s64-update-tlb-flush-routines-to-take-a-page-walk-cache-flush-argument-fix.patch
mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush-fix.patch
mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races-fix.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
mm-userfaultfd-fix-uffd-wp-special-cases-for-fork-fix.patch
mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
mm-rmap-make-try_to_unmap-void-function-fix.patch
mm-early_ioremap-add-prototype-for-early_memremap_pgprot_adjust-fix.patch
kernelh-split-out-panic-and-oops-helpers-fix.patch
lib-math-rational-add-kunit-test-cases-fix.patch
lib-decompressors-remove-set-but-not-used-variabled-level-fix.patch
linux-next-pre.patch
linux-next-post.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

