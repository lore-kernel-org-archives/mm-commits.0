Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EB94C001DB
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:23:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbjFSXXH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbjFSXVw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:21:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C52E1706
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:21:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 173C460F4F
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:21:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 660A7C433C8;
        Mon, 19 Jun 2023 23:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216902;
        bh=3yLG34Mc/n5xzYnEtNYJ/Y8Teq+lfLRa5O48DQGGrYY=;
        h=Date:To:From:Subject:From;
        b=gNsbceLmatZK3ktZQ+o+sPKidKwgY0C6tkNxrDn70Asr8MTYjy28Z/xjfV+rCQ8X6
         X9CAgSj8J+vyygpgP6qYkYCeCb8ARKTZNev7ulhJSV22jSzAloTJv23wWXhusL5Q3p
         Q53eBc/JEVSUXAA0ss2JqPq3dw+S1yhmURtb7yhc=
Date:   Mon, 19 Jun 2023 16:21:41 -0700
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
Subject: [merged mm-stable] mm-hmm-retry-if-pte_offset_map-fails.patch removed from -mm tree
Message-Id: <20230619232142.660A7C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hmm: retry if pte_offset_map() fails
has been removed from the -mm tree.  Its filename was
     mm-hmm-retry-if-pte_offset_map-fails.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/hmm: retry if pte_offset_map() fails
Date: Thu, 8 Jun 2023 18:23:19 -0700 (PDT)

hmm_vma_walk_pmd() is called through mm_walk, but already has a goto again
loop of its own, so take part in that if pte_offset_map() fails.

Link: https://lkml.kernel.org/r/d6c6dd68-25d4-653b-f94b-a45c53ee04b@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
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

 mm/hmm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/hmm.c~mm-hmm-retry-if-pte_offset_map-fails
+++ a/mm/hmm.c
@@ -381,6 +381,8 @@ again:
 	}
 
 	ptep = pte_offset_map(pmdp, addr);
+	if (!ptep)
+		goto again;
 	for (; addr < end; addr += PAGE_SIZE, ptep++, hmm_pfns++) {
 		int r;
 
_

Patches currently in -mm which might be from hughd@google.com are


