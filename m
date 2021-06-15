Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0273AC48BDF
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 22:46:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9E4460FE4
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 22:46:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbhFOWsJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Jun 2021 18:48:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229898AbhFOWsI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Jun 2021 18:48:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9232361246;
        Tue, 15 Jun 2021 22:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623797162;
        bh=nrbsuuTxevJFf6liAth6LJPNifzvp4c4ZxTKUF5hX28=;
        h=Date:From:To:Subject:From;
        b=lLb4HDPeyozr0hqW+MfpEjMGuy88D+2qHonKZZ/HrNziQBTAeWAoXWz2vuH7oxkaP
         NXDcnT3wX+j1FOX9LLEIK4x/MzkIpB7VcMnCkANmff+s5v2C0bh7y+pBcpmvCLDgKR
         rkVmvYkvh3tfXqy09SWnQEgEKGf2lMBNDBHUEinA=
Date:   Tue, 15 Jun 2021 15:46:01 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, dave@stgolabs.net, dvhart@infradead.org,
        hughd@google.com, kirill.shutemov@linux.intel.com,
        mgorman@techsingularity.net, mike.kravetz@oracle.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, neelnatu@google.com,
        peterz@infradead.org, tglx@linutronix.de, wetpzy@gmail.com,
        willy@infradead.org
Subject:  +
 mm-futex-fix-shared-futex-pgoff-on-shmem-huge-page-fix.patch added to -mm
 tree
Message-ID: <20210615224601.ZMJ-e61-i%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-futex-fix-shared-futex-pgoff-on-shmem-huge-page-fix
has been added to the -mm tree.  Its filename is
     mm-futex-fix-shared-futex-pgoff-on-shmem-huge-page-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-futex-fix-shared-futex-pgoff-on-shmem-huge-page-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-futex-fix-shared-futex-pgoff-on-shmem-huge-page-fix.patch

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
Subject: mm-futex-fix-shared-futex-pgoff-on-shmem-huge-page-fix

give hugetlb_basepage_index() prototype the correct scope

Cc: Darren Hart <dvhart@infradead.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Neel Natu <neelnatu@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Zhang Yi <wetpzy@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/pagemap.h~mm-futex-fix-shared-futex-pgoff-on-shmem-huge-page-fix
+++ a/include/linux/pagemap.h
@@ -535,16 +535,16 @@ static inline pgoff_t page_to_index(stru
 	return pgoff;
 }
 
+extern pgoff_t hugetlb_basepage_index(struct page *page);
+
 /*
  * Get the offset in PAGE_SIZE (even for hugetlb pages).
  * (TODO: hugetlb pages should have ->index in PAGE_SIZE)
  */
 static inline pgoff_t page_to_pgoff(struct page *page)
 {
-	if (unlikely(PageHuge(page))) {
-		extern pgoff_t hugetlb_basepage_index(struct page *page);
+	if (unlikely(PageHuge(page)))
 		return hugetlb_basepage_index(page);
-	}
 	return page_to_index(page);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-slubc-include-swabh.patch
mm-vmalloc-add-vmalloc_no_huge-fix.patch
mm-futex-fix-shared-futex-pgoff-on-shmem-huge-page-fix.patch
mm.patch
mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2.patch
slub-force-on-no_hash_pointers-when-slub_debug-is-enabled-fix.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5-fix.patch
binfmt-remove-in-tree-usage-of-map_executable-fix.patch
mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix-checkpatch-fixes.patch
mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races-fix.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
mmmemory_hotplug-drop-unneeded-locking-fix.patch
fs-proc-kcorec-add-mmap-interface-fix.patch
kernelh-split-out-panic-and-oops-helpers-fix.patch
lib-math-rational-add-kunit-test-cases-fix.patch
lib-decompressors-remove-set-but-not-used-variabled-level-fix.patch
ipc-utilc-use-binary-search-for-max_idx-fix.patch
linux-next-pre.patch
linux-next-post.patch
linux-next-rejects.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

