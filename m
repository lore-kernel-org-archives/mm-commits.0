Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F6B4EB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:23:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbjFSXXx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbjFSXWT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:22:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 740621717
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:22:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11D4460FBB
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:22:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A46C433C8;
        Mon, 19 Jun 2023 23:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216919;
        bh=4N9udl8qFR6f2IqUbOA6dhZNbxh26e0QHtSbIKK2WL8=;
        h=Date:To:From:Subject:From;
        b=G+f2jTAplyKdwezCSNFml79CPbxbe3FA4DaniJ3u8u6Hnl054wWS7JHZNscbKhn8V
         CWPI0NcJ6UvFW/EgYqwTBzEE+VgIXkjXZW6djz13EH+bBkPwDh/Tz99v/QgF0UYyZJ
         5yLrujC7wXJiDcQfCZnlqyIOBtT+Zi4XyHCwWQCo=
Date:   Mon, 19 Jun 2023 16:21:58 -0700
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
Subject: [merged mm-stable] mm-gup-remove-foll_split_pmd-use-of-pmd_trans_unstable.patch removed from -mm tree
Message-Id: <20230619232159.64A46C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup: remove FOLL_SPLIT_PMD use of pmd_trans_unstable()
has been removed from the -mm tree.  Its filename was
     mm-gup-remove-foll_split_pmd-use-of-pmd_trans_unstable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/gup: remove FOLL_SPLIT_PMD use of pmd_trans_unstable()
Date: Thu, 8 Jun 2023 18:39:59 -0700 (PDT)

There is now no reason for follow_pmd_mask()'s FOLL_SPLIT_PMD block to
distinguish huge_zero_page from a normal THP: follow_page_pte() handles
any instability, and here it's a good idea to replace any pmd_none(*pmd)
by a page table a.s.a.p, in the huge_zero_page case as for a normal THP;
and this removes an unnecessary possibility of -EBUSY failure.

(Hmm, couldn't the normal THP case have hit an unstably refaulted THP
before?  But there are only two, exceptional, users of FOLL_SPLIT_PMD.)

Link: https://lkml.kernel.org/r/59fd15dd-4d39-5ec-2043-1d5117f7f85@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
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
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zack Rusin <zackr@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

--- a/mm/gup.c~mm-gup-remove-foll_split_pmd-use-of-pmd_trans_unstable
+++ a/mm/gup.c
@@ -682,21 +682,10 @@ static struct page *follow_pmd_mask(stru
 		return follow_page_pte(vma, address, pmd, flags, &ctx->pgmap);
 	}
 	if (flags & FOLL_SPLIT_PMD) {
-		int ret;
-		page = pmd_page(*pmd);
-		if (is_huge_zero_page(page)) {
-			spin_unlock(ptl);
-			ret = 0;
-			split_huge_pmd(vma, pmd, address);
-			if (pmd_trans_unstable(pmd))
-				ret = -EBUSY;
-		} else {
-			spin_unlock(ptl);
-			split_huge_pmd(vma, pmd, address);
-			ret = pte_alloc(mm, pmd) ? -ENOMEM : 0;
-		}
-
-		return ret ? ERR_PTR(ret) :
+		spin_unlock(ptl);
+		split_huge_pmd(vma, pmd, address);
+		/* If pmd was left empty, stuff a page table in there quickly */
+		return pte_alloc(mm, pmd) ? ERR_PTR(-ENOMEM) :
 			follow_page_pte(vma, address, pmd, flags, &ctx->pgmap);
 	}
 	page = follow_trans_huge_pmd(vma, address, pmd, flags);
_

Patches currently in -mm which might be from hughd@google.com are


