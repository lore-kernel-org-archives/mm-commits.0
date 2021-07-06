Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3591C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:16:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB3FB61C7A
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:16:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbhGFTTO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:19:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:53212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231924AbhGFTTN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:19:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C278461C7C;
        Tue,  6 Jul 2021 19:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598993;
        bh=3F/ErxSHkNsReJaIphcKjWufLaDIUBGcEQSBnLjUMwM=;
        h=Date:From:To:Subject:From;
        b=ZqCSvJWHczO/NPxBFdGF/FTz+yDkqE8595332SJPg7egsRtIl9SozLVRN7O8S4ulW
         z6E34WoaUjXoa9qI0ZS/9bv2KXsSrYzi6F7ShQscGRV5aVOPQplbTwdCgfotrqxeYu
         EwYRyeK1PaenQ8qgmtuCkLXN+bU13focheXWJwXM=
Date:   Tue, 06 Jul 2021 12:16:32 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, aneesh.kumar@linux.ibm.com,
        anshuman.khandual@arm.com, david@redhat.com, hannes@cmpxchg.org,
        hughd@google.com, kirill.shutemov@linux.intel.com,
        linmiaohe@huawei.com, mike.kravetz@oracle.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com, riel@surriel.com,
        shy828301@gmail.com, songliubraving@fb.com,
        william.kucharski@oracle.com, willy@infradead.org, ziy@nvidia.com
Subject:  [merged]
 mm-huge_memoryc-remove-dedicated-macro-hpage_cache_index_mask.patch removed
 from -mm tree
Message-ID: <20210706191632.XKV6FQr-j%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory.c: remove dedicated macro HPAGE_CACHE_INDEX_MASK
has been removed from the -mm tree.  Its filename was
     mm-huge_memoryc-remove-dedicated-macro-hpage_cache_index_mask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/huge_memory.c: remove dedicated macro HPAGE_CACHE_INDEX_MASK

Patch series "Cleanup and fixup for huge_memory:, v3.

This series contains cleanups to remove dedicated macro and remove
unnecessary tlb_remove_page_size() for huge zero pmd.  Also this adds
missing read-only THP checking for transparent_hugepage_enabled() and
avoids discarding hugepage if other processes are mapping it.  More
details can be found in the respective changelogs.


Thi patch (of 5):

Rewrite the pgoff checking logic to remove macro HPAGE_CACHE_INDEX_MASK
which is only used here to simplify the code.

Link: https://lkml.kernel.org/r/20210511134857.1581273-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210511134857.1581273-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/include/linux/huge_mm.h~mm-huge_memoryc-remove-dedicated-macro-hpage_cache_index_mask
+++ a/include/linux/huge_mm.h
@@ -152,15 +152,13 @@ static inline bool __transparent_hugepag
 
 bool transparent_hugepage_enabled(struct vm_area_struct *vma);
 
-#define HPAGE_CACHE_INDEX_MASK (HPAGE_PMD_NR - 1)
-
 static inline bool transhuge_vma_suitable(struct vm_area_struct *vma,
 		unsigned long haddr)
 {
 	/* Don't have to check pgoff for anonymous vma */
 	if (!vma_is_anonymous(vma)) {
-		if (((vma->vm_start >> PAGE_SHIFT) & HPAGE_CACHE_INDEX_MASK) !=
-			(vma->vm_pgoff & HPAGE_CACHE_INDEX_MASK))
+		if (!IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) - vma->vm_pgoff,
+				HPAGE_PMD_NR))
 			return false;
 	}
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

