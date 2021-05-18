Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5B03C433B4
	for <mm-commits@archiver.kernel.org>; Tue, 18 May 2021 22:30:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BEAF611B0
	for <mm-commits@archiver.kernel.org>; Tue, 18 May 2021 22:30:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241218AbhERWcJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 May 2021 18:32:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237623AbhERWcI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 May 2021 18:32:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C37FA61002;
        Tue, 18 May 2021 22:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621377050;
        bh=tokurZcCQZdm8RQtFSJBh+/ci4XIAiI++eYM7NT0OHA=;
        h=Date:From:To:Subject:From;
        b=K7+DaR9Ot9U2/8YDqS9BjhDA5n6HqQu/0U0JdiR8maDRL4Vri0TvDYuTmgkGmws/f
         r0n5/mU43tqbYvX7RZlevydYAlos3qOeAPCyS+11Mg79KTJOHz5tjS21N/59YyxjD1
         rOUsboP85i/TF2R/WCSedIEM1jdBIfnbnkEZ79Ss=
Date:   Tue, 18 May 2021 15:30:49 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, lkp@intel.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        shy828301@gmail.com, wangyugui@e16-tech.com, ziy@nvidia.com
Subject:  +
 mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix.patch added to
 -mm tree
Message-ID: <20210518223049.CdnnbDVW0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix
has been added to the -mm tree.  Its filename is
     mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix.patch

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

 mm/huge_memory.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix
+++ a/mm/huge_memory.c
@@ -2342,14 +2342,13 @@ static void unmap_page(struct page *page
 {
 	enum ttu_flags ttu_flags = TTU_IGNORE_MLOCK |
 		TTU_RMAP_LOCKED | TTU_SPLIT_HUGE_PMD;
-	bool unmap_success;
 
 	VM_BUG_ON_PAGE(!PageHead(page), page);
 
 	if (PageAnon(page))
 		ttu_flags |= TTU_SPLIT_FREEZE;
 
-	unmap_success = try_to_unmap(page, ttu_flags);
+	try_to_unmap(page, ttu_flags);
 }
 
 static void remap_page(struct page *page, unsigned int nr)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5-fix.patch
mm-improve-mprotectrw-efficiency-on-pages-referenced-once-fix.patch
binfmt-remove-in-tree-usage-of-map_executable-fix.patch
mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
powerpc-mm-book3s64-update-tlb-flush-routines-to-take-a-page-walk-cache-flush-argument-fix.patch
mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush-fix.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
kernelh-split-out-panic-and-oops-helpers-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

