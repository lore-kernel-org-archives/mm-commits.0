Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29227C4707F
	for <mm-commits@archiver.kernel.org>; Wed, 26 May 2021 01:25:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 000E661423
	for <mm-commits@archiver.kernel.org>; Wed, 26 May 2021 01:25:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbhEZB1Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 May 2021 21:27:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:55282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230505AbhEZB1Z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 25 May 2021 21:27:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4E3361429;
        Wed, 26 May 2021 01:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621992354;
        bh=J5s2WC80k59hYH//xYPmriXWu4ngr0EC4r03Mco5coE=;
        h=Date:From:To:Subject:From;
        b=r83bGlWslTv4p0DgGLzSfvkslakRzIxgJkVJTB7gTVfTr42Yf5R/8C+Cvfvobp6ke
         ttkYVW/XlaMaXLaxchlnaHnCskJqP2ApJSVqLR9VrcH6+60Nw8j1KdZsn0x7Ro046R
         IzZ9Ka24ZWB95guwvPkKPlXfQycK5LCbhKO6VTqc=
Date:   Tue, 25 May 2021 18:25:53 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, lkp@intel.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        shy828301@gmail.com, wangyugui@e16-tech.com, ziy@nvidia.com
Subject:  +
 mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix-fix.patch
 added to -mm tree
Message-ID: <20210526012553.qZEltjyeb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix-fix
has been added to the -mm tree.  Its filename is
     mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix-fix.patch

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
Subject: mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix-fix

fix the fix

Cc: Hugh Dickins <hughd@google.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Wang Yugui <wangyugui@e16-tech.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix-fix
+++ a/mm/huge_memory.c
@@ -2352,7 +2352,7 @@ static void unmap_page(struct page *page
 	VM_BUG_ON_PAGE(!PageHead(page), page);
 
 	if (PageAnon(page))
-		unmap_success = try_to_migrate(page, ttu_flags);
+		try_to_migrate(page, ttu_flags);
 	else
 		/*
 		 * Don't install migration entries for file backed pages. This
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
mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix.patch
mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix-fix.patch
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

