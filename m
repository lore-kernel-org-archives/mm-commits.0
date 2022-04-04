Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37249C47081
	for <mm-commits@archiver.kernel.org>; Mon,  4 Apr 2022 21:41:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383200AbiDDVlc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Apr 2022 17:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380480AbiDDUQo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Apr 2022 16:16:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD66033EAD
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 13:14:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52D9860EAD
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 20:14:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC8D2C2BBE4;
        Mon,  4 Apr 2022 20:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649103286;
        bh=Tx6rbNUNyqTN7jwDg3J9MZ2hScFGCC4ytr5XOYiBFeo=;
        h=Date:To:From:Subject:From;
        b=hTQJWLdiVGXBnv5yrcd7/6fE4osE0ydV3nfJIERBDOBxD+bFqMZjh2fBfhkus5/lC
         bbNK7zOOqiSeGZHEFaSTj03CuFcOjQsng8gWj5kfPd/rBU/rm+ymLeoKptW0wXz8U/
         LvijmSre4O2hxD25k2HxLRBj6CltUVhEKUWhtFHE=
Date:   Mon, 04 Apr 2022 13:14:45 -0700
To:     mm-commits@vger.kernel.org, zwisler@kernel.org,
        xiyuyang19@fudan.edu.cn, willy@infradead.org,
        viro@zeniv.linux.org.uk, shy828301@gmail.com, rcampbell@nvidia.com,
        kirill.shutemov@linux.intel.com, jack@suse.cz, hughd@google.com,
        hch@lst.de, duanxiongchun@bytedance.com, dan.j.williams@intel.com,
        apopple@nvidia.com, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-fix-cache-flush-on-thp-pages.patch added to -mm tree
Message-Id: <20220404201446.AC8D2C2BBE4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rmap: fix cache flush on THP pages
has been added to the -mm tree.  Its filename is
     mm-rmap-fix-cache-flush-on-thp-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-rmap-fix-cache-flush-on-thp-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-rmap-fix-cache-flush-on-thp-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: rmap: fix cache flush on THP pages

Patch series "Fix some bugs related to ramp and dax", v7.

Patch 1-2 fix a cache flush bug, because subsequent patches depend on
those on those changes, there are placed in this series.  Patch 3-4 are
preparation for fixing a dax bug in patch 5.  Patch 6 is code cleanup
since the previous patch removes the usage of follow_invalidate_pte().


This patch (of 6):

The flush_cache_page() only remove a PAGE_SIZE sized range from the cache.
However, it does not cover the full pages in a THP except a head page. 
Replace it with flush_cache_range() to fix this issue.  At least, no
problems were found due to this.  Maybe because the architectures that
have virtual indexed caches is less.

Link: https://lkml.kernel.org/r/20220403053957.10770-1-songmuchun@bytedance.com
Link: https://lkml.kernel.org/r/20220403053957.10770-2-songmuchun@bytedance.com
Fixes: f27176cfc363 ("mm: convert page_mkclean_one() to use page_vma_mapped_walk()")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Ross Zwisler <zwisler@kernel.org>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/rmap.c~mm-rmap-fix-cache-flush-on-thp-pages
+++ a/mm/rmap.c
@@ -970,7 +970,8 @@ static bool page_mkclean_one(struct foli
 			if (!pmd_dirty(*pmd) && !pmd_write(*pmd))
 				continue;
 
-			flush_cache_page(vma, address, folio_pfn(folio));
+			flush_cache_range(vma, address,
+					  address + HPAGE_PMD_SIZE);
 			entry = pmdp_invalidate(vma, address, pmd);
 			entry = pmd_wrprotect(entry);
 			entry = pmd_mkclean(entry);
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb_vmemmap-introduce-arch_want_hugetlb_page_free_vmemmap.patch
arm64-mm-hugetlb-enable-hugetlb_page_free_vmemmap-for-arm64.patch
mm-hugetlb_vmemmap-cleanup-hugetlb_vmemmap-related-functions.patch
mm-hugetlb_vmemmap-cleanup-hugetlb_free_vmemmap_enabled.patch
mm-hugetlb_vmemmap-cleanup-config_hugetlb_page_free_vmemmap.patch
mm-rmap-fix-cache-flush-on-thp-pages.patch
dax-fix-cache-flush-on-pmd-mapped-pages.patch
mm-rmap-introduce-pfn_mkclean_range-to-cleans-ptes.patch
mm-pvmw-add-support-for-walking-devmap-pages.patch
dax-fix-missing-writeprotect-the-pte-entry.patch
mm-simplify-follow_invalidate_pte.patch

