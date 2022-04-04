Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61718C4707F
	for <mm-commits@archiver.kernel.org>; Mon,  4 Apr 2022 21:39:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347745AbiDDVlE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Apr 2022 17:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380481AbiDDUQq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Apr 2022 16:16:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B928E33EAD
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 13:14:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5722060E9C
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 20:14:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFBDAC2BBE4;
        Mon,  4 Apr 2022 20:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649103288;
        bh=0dOdSs2K4ODK6dPkJxosKGME6xsrr2xUmxSUMi0DOt0=;
        h=Date:To:From:Subject:From;
        b=usmNu+40HYslsifqglomOIw3y4jzp2NsAg8OEJ9AaQFkb+An+nZE8W9VsiN2bDvu1
         RM6sQ8+nB9aCD+PeF6GnFTKier8aS0X+ulJN7F0DW6iuNsg6KAakzOzyaFa/oZlgAP
         BiLCQaYT/y8vy5xq0GCrj5oTmCLXYS+99W8Xhwug=
Date:   Mon, 04 Apr 2022 13:14:48 -0700
To:     mm-commits@vger.kernel.org, zwisler@kernel.org,
        xiyuyang19@fudan.edu.cn, willy@infradead.org,
        viro@zeniv.linux.org.uk, shy828301@gmail.com, rcampbell@nvidia.com,
        kirill.shutemov@linux.intel.com, jack@suse.cz, hughd@google.com,
        hch@lst.de, duanxiongchun@bytedance.com, dan.j.williams@intel.com,
        apopple@nvidia.com, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + dax-fix-cache-flush-on-pmd-mapped-pages.patch added to -mm tree
Message-Id: <20220404201448.AFBDAC2BBE4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: dax: fix cache flush on PMD-mapped pages
has been added to the -mm tree.  Its filename is
     dax-fix-cache-flush-on-pmd-mapped-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/dax-fix-cache-flush-on-pmd-mapped-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/dax-fix-cache-flush-on-pmd-mapped-pages.patch

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
Subject: dax: fix cache flush on PMD-mapped pages

The flush_cache_page() only remove a PAGE_SIZE sized range from the cache.
However, it does not cover the full pages in a THP except a head page. 
Replace it with flush_cache_range() to fix this issue.  This is just a
documentation issue with the respect to properly documenting the expected
usage of cache flushing before modifying the pmd.  However, in practice
this is not a problem due to the fact that DAX is not available on
architectures with virtually indexed caches per:

  commit d92576f1167c ("dax: does not work correctly with virtual aliasing caches")

Link: https://lkml.kernel.org/r/20220403053957.10770-3-songmuchun@bytedance.com
Fixes: f729c8c9b24f ("dax: wrprotect pmd_t in dax_mapping_entry_mkclean")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Ross Zwisler <zwisler@kernel.org>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/dax.c~dax-fix-cache-flush-on-pmd-mapped-pages
+++ a/fs/dax.c
@@ -845,7 +845,8 @@ static void dax_entry_mkclean(struct add
 			if (!pmd_dirty(*pmdp) && !pmd_write(*pmdp))
 				goto unlock_pmd;
 
-			flush_cache_page(vma, address, pfn);
+			flush_cache_range(vma, address,
+					  address + HPAGE_PMD_SIZE);
 			pmd = pmdp_invalidate(vma, address, pmdp);
 			pmd = pmd_wrprotect(pmd);
 			pmd = pmd_mkclean(pmd);
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

