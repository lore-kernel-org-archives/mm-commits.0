Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64068C47080
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 00:32:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B080611CB
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 00:32:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232351AbhFAAd7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 May 2021 20:33:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:59936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232081AbhFAAd7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 31 May 2021 20:33:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BFA86023D;
        Tue,  1 Jun 2021 00:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622507537;
        bh=KStv/zYafxZ3HcNMZXpQ/IlHq3v8YTUHswB0sGrbyQg=;
        h=Date:From:To:Subject:From;
        b=waIiOBMWyR8l5wl9QCeQVe4ICtM1FaegQjI/ONfgq1rGwwCgvIwu4AtwJt/CR1okw
         T1BngY3yDPfvNmVschTm074YFk4b/1fTv2uqFQjBQ+URNCEvYtNhUP2O9h2MMZ9nhX
         bFBhIJa495v1+ZTEtX7/qDIdoeJVLNMw4+vgMakA=
Date:   Mon, 31 May 2021 17:32:16 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, almasrymina@google.com,
        axelrasmussen@google.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, peterx@redhat.com
Subject:  [folded-merged]
 mm-hugetlb-fix-resv_huge_pages-underflow-on-uffdio_copy-fix.patch removed
 from -mm tree
Message-ID: <20210601003216.07hIq_Iha%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-fix-resv_huge_pages-underflow-on-uffdio_copy-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-resv_huge_pages-underflow-on-uffdio_copy-fix.patch

This patch was dropped because it was folded into mm-hugetlb-fix-resv_huge_pages-underflow-on-uffdio_copy.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-fix-resv_huge_pages-underflow-on-uffdio_copy-fix

fix warning

./include/linux/hugetlb.h:401:20: warning: 'hugetlb_copy_page' declared 'static' but never defined [-Wunused-function]

Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-fix-resv_huge_pages-underflow-on-uffdio_copy-fix
+++ a/include/linux/hugetlb.h
@@ -381,7 +381,7 @@ static inline vm_fault_t hugetlb_fault(s
 
 static inline void hugetlb_unshare_all_pmds(struct vm_area_struct *vma) { }
 
-static inline void hugetlb_copy_page(struct page *dst, struct page *src);
+static inline void hugetlb_copy_page(struct page *dst, struct page *src) { }
 
 #endif /* !CONFIG_HUGETLB_PAGE */
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-hugetlb-fix-resv_huge_pages-underflow-on-uffdio_copy.patch
mm.patch
mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5-fix.patch
binfmt-remove-in-tree-usage-of-map_executable-fix.patch
mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
powerpc-mm-book3s64-update-tlb-flush-routines-to-take-a-page-walk-cache-flush-argument-fix.patch
mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush-fix.patch
mm-rename-the-global-section-array-to-mem_sections-fix.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix-checkpatch-fixes.patch
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
ipc-utilc-use-binary-search-for-max_idx-fix.patch
linux-next-pre.patch
linux-next-post.patch
linux-next-git-rejects.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

