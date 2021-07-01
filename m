Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAD45C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:47:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4CDA61090
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:47:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238354AbhGABu2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:50:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:39800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237149AbhGABu2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:50:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5ED9061468;
        Thu,  1 Jul 2021 01:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104078;
        bh=CWbtpEeKSCBvywFsbct1J9BSrRL6Ri6SyG74X8TBURA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Zsf4cdI376IqMUe4nNxrjAyWoDIu3BwiRBNCkl+8f9addegcFSAQAacClf3l4Tjrv
         oeTS6qWA3rfRcd9YQx9D3AsbbrBLKNnn44aIBgP1kGSvoLcLbY+1bh3Ak0Aic7ytww
         iP4c327T11qq3v4N1yZ4j1h1dqjgncBAQ1lpAIQs=
Date:   Wed, 30 Jun 2021 18:47:57 -0700
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
Subject:  [patch 016/192] mm/huge_memory.c: don't discard hugepage
 if other processes are mapping it
Message-ID: <20210701014757.SdeAPP5pY%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/huge_memory.c: don't discard hugepage if other processes are mapping it

If other processes are mapping any other subpages of the hugepage, i.e. 
in pte-mapped thp case, page_mapcount() will return 1 incorrectly.  Then
we would discard the page while other processes are still mapping it.  Fix
it by using total_mapcount() which can tell whether other processes are
still mapping it.

Link: https://lkml.kernel.org/r/20210511134857.1581273-6-linmiaohe@huawei.com
Fixes: b8d3c4c3009d ("mm/huge_memory.c: don't split THP page when MADV_FREE syscall is called")
Reviewed-by: Yang Shi <shy828301@gmail.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@redhat.com>
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

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memoryc-dont-discard-hugepage-if-other-processes-are-mapping-it
+++ a/mm/huge_memory.c
@@ -1613,7 +1613,7 @@ bool madvise_free_huge_pmd(struct mmu_ga
 	 * If other processes are mapping this page, we couldn't discard
 	 * the page unless they all do MADV_FREE so let's skip the page.
 	 */
-	if (page_mapcount(page) != 1)
+	if (total_mapcount(page) != 1)
 		goto out;
 
 	if (!trylock_page(page))
_
