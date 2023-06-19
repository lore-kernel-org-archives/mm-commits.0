Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4143C001DD
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:23:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbjFSXXH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbjFSXVw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:21:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD7710CA
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:21:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A612360FBB
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:21:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026B7C433C0;
        Mon, 19 Jun 2023 23:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216901;
        bh=ES1rSVtuM68JTUvm3/G1Oz2IcM8Sbn1fwWDf9QAagII=;
        h=Date:To:From:Subject:From;
        b=uK7/ZXFOJ/kKO4QAkPyc6cIyYq9AxcufoJ9QfOZzS7b4xQiFL6wgrRnS9b4bdWZps
         n4Jlf5MAZM3kFzZSFQGtboKrQle5HSRSr8aMonu3PDflfNqUy1fGUPLIAgKVJaIjcr
         lQhLnnOQ9pfAsZzu6cXamR4u3Q+txcVslz1wn3E4=
Date:   Mon, 19 Jun 2023 16:21:40 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        zackr@vmware.com, yuzhao@google.com, ying.huang@intel.com,
        willy@infradead.org, will@kernel.org,
        thomas.hellstrom@linux.intel.com, surenb@google.com,
        steven.price@arm.com, song@kernel.org, sj@kernel.org,
        shy828301@gmail.com, ryan.roberts@arm.com, rppt@kernel.org,
        rcampbell@nvidia.com, peterz@infradead.org, peterx@redhat.com,
        pasha.tatashin@soleen.com, naoya.horiguchi@nec.com,
        minchan@kernel.org, mike.kravetz@oracle.com,
        mgorman@techsingularity.net, lstoakes@gmail.com,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jgg@ziepe.ca, ira.weiny@intel.com, hch@infradead.org,
        david@redhat.com, christophe.leroy@csgroup.eu,
        axelrasmussen@google.com, apopple@nvidia.com,
        anshuman.khandual@arm.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-vmalloc_to_page-use-pte_offset_kernel.patch removed from -mm tree
Message-Id: <20230619232141.026B7C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmalloc: vmalloc_to_page() use pte_offset_kernel()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-vmalloc_to_page-use-pte_offset_kernel.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/vmalloc: vmalloc_to_page() use pte_offset_kernel()
Date: Thu, 8 Jun 2023 18:21:41 -0700 (PDT)

vmalloc_to_page() was using pte_offset_map() (followed by pte_unmap()),
but it's intended for userspace page tables: prefer pte_offset_kernel().

Link: https://lkml.kernel.org/r/696386a-84f8-b33c-82e5-f865ed6eb39@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Song Liu <song@kernel.org>
Cc: Steven Price <steven.price@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zack Rusin <zackr@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-vmalloc_to_page-use-pte_offset_kernel
+++ a/mm/vmalloc.c
@@ -703,11 +703,10 @@ struct page *vmalloc_to_page(const void
 	if (WARN_ON_ONCE(pmd_bad(*pmd)))
 		return NULL;
 
-	ptep = pte_offset_map(pmd, addr);
+	ptep = pte_offset_kernel(pmd, addr);
 	pte = *ptep;
 	if (pte_present(pte))
 		page = pte_page(pte);
-	pte_unmap(ptep);
 
 	return page;
 }
_

Patches currently in -mm which might be from hughd@google.com are


