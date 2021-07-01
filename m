Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 685FFC11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:47:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55B2961469
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:47:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238353AbhGABuZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:50:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237149AbhGABuZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:50:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDA9C6120C;
        Thu,  1 Jul 2021 01:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104074;
        bh=ktGpswfKHgSeup/foAAxXRZQdBofcRyy+/naJSEVGhg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=SHNX+oE57T0UsFLB58lLtaKDo+5zrXJtw6RSTJSWDyQl2DBymN994o+rVbmSuFM/+
         pvYrqO9TEDsxt79teQFtnMS0ghIzDUxAZCddfGMTc3tR76gMB5t+SClN9atVXdvZPq
         HQuJJXxSI8IYcxfjBr/kH3C726V+TvnJyDsvJrjI=
Date:   Wed, 30 Jun 2021 18:47:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com,
        david@redhat.com, hannes@cmpxchg.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mike.kravetz@oracle.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com, riel@surriel.com,
        shy828301@gmail.com, songliubraving@fb.com,
        torvalds@linux-foundation.org, william.kucharski@oracle.com,
        willy@infradead.org, ziy@nvidia.com
Subject:  [patch 015/192] mm/huge_memory.c: remove unnecessary
 tlb_remove_page_size() for huge zero pmd
Message-ID: <20210701014753.FkgXLukHD%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/huge_memory.c: remove unnecessary tlb_remove_page_size() for huge zero pmd

Commit aa88b68c3b1d ("thp: keep huge zero page pinned until tlb flush")
introduced tlb_remove_page() for huge zero page to keep it pinned until
flush is complete and prevents the page from being split under us.  But
huge zero page is kept pinned until all relevant mm_users reach zero since
the commit 6fcb52a56ff6 ("thp: reduce usage of huge zero page's atomic
counter").  So tlb_remove_page_size() for huge zero pmd is unnecessary
now.

Link: https://lkml.kernel.org/r/20210511134857.1581273-5-linmiaohe@huawei.com
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memoryc-remove-unnecessary-tlb_remove_page_size-for-huge-zero-pmd
+++ a/mm/huge_memory.c
@@ -1686,12 +1686,9 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 		if (arch_needs_pgtable_deposit())
 			zap_deposited_table(tlb->mm, pmd);
 		spin_unlock(ptl);
-		if (is_huge_zero_pmd(orig_pmd))
-			tlb_remove_page_size(tlb, pmd_page(orig_pmd), HPAGE_PMD_SIZE);
 	} else if (is_huge_zero_pmd(orig_pmd)) {
 		zap_deposited_table(tlb->mm, pmd);
 		spin_unlock(ptl);
-		tlb_remove_page_size(tlb, pmd_page(orig_pmd), HPAGE_PMD_SIZE);
 	} else {
 		struct page *page = NULL;
 		int flush_needed = 1;
_
