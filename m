Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB236C4707F
	for <mm-commits@archiver.kernel.org>; Wed, 26 May 2021 00:07:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D5A56140B
	for <mm-commits@archiver.kernel.org>; Wed, 26 May 2021 00:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232225AbhEZAIp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 May 2021 20:08:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:45284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229595AbhEZAIl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 25 May 2021 20:08:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB959613B6;
        Wed, 26 May 2021 00:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621987631;
        bh=2MVI+H1SII2lnjG0aVvQF5UOm86Gw+V95Ktl3bzxPGQ=;
        h=Date:From:To:Subject:From;
        b=yUFErju8ShXzsoI1iB2QTygjHsuXyMR5ohnSihJ9S4p1nH0LUtmWWRa9uJAmaU1k3
         wqYXZl2ctzq3NhC0jzaLNioOPwMo27wo5cyOicOeyphzEhGghVK55MohM99rvm48UC
         gMT9x2CRUQQVp9VMpD64EE0uG+SRAiLjz5S/OK8s=
Date:   Tue, 25 May 2021 17:07:10 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, almasrymina@google.com,
        axelrasmussen@google.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, peterx@redhat.com
Subject:  +
 mm-hugetlb-fix-resv_huge_pages-underflow-on-uffdio_copy-fix.patch added to
 -mm tree
Message-ID: <20210526000710.FJWr_rnaJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-fix-resv_huge_pages-underflow-on-uffdio_copy-fix
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-resv_huge_pages-underflow-on-uffdio_copy-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-fix-resv_huge_pages-underflow-on-uffdio_copy-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-fix-resv_huge_pages-underflow-on-uffdio_copy-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
kernelh-split-out-panic-and-oops-helpers-fix.patch
lib-math-rational-add-kunit-test-cases-fix.patch
lib-decompressors-remove-set-but-not-used-variabled-level-fix.patch
linux-next-pre.patch
linux-next-post.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

