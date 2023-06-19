Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7766C001B3
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:23:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjFSXXF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbjFSXVw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:21:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6473EE73
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:21:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFC4360F0D
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:21:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F2B9C433C0;
        Mon, 19 Jun 2023 23:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216898;
        bh=254+fg+VHQhOf8i0xEsTT9GxT2W2xpckTMwugnALSqo=;
        h=Date:To:From:Subject:From;
        b=GZm0zooL+Kr7jVpCIe9V3vN0DU5Z2DvOmdy+tNsP5fTg2vKr45yQtfjSlgVB18THP
         l9kDoPm5WEeEvqa+kHjfC+XaAgli/RgOUU8P33Fai/wrPhsyciSbL7UPDVRaEhn6kh
         qR5A0JDN7nP24o5YGafpAVK9m5287Etz0cD63wrA=
Date:   Mon, 19 Jun 2023 16:21:37 -0700
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
Subject: [merged mm-stable] mm-pagewalk-walk_pte_range-allow-for-pte_offset_map.patch removed from -mm tree
Message-Id: <20230619232138.4F2B9C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/pagewalk: walk_pte_range() allow for pte_offset_map()
has been removed from the -mm tree.  Its filename was
     mm-pagewalk-walk_pte_range-allow-for-pte_offset_map.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/pagewalk: walk_pte_range() allow for pte_offset_map()
Date: Thu, 8 Jun 2023 18:18:49 -0700 (PDT)

walk_pte_range() has a no_vma option to serve walk_page_range_novma().  I
don't know of any problem, but it looks safer to check for init_mm, and
use pte_offset_kernel() rather than pte_offset_map() in that case:
pte_offset_map()'s pmdval validation is intended for userspace.

Allow for its pte_offset_map() or pte_offset_map_lock() to fail, and retry
with ACTION_AGAIN if so.  Add a second check for ACTION_AGAIN in
walk_pmd_range(), to catch it after return from walk_pte_range().

Remove the pmd_trans_unstable() check after split_huge_pmd() in
walk_pmd_range(): walk_pte_range() now handles those cases safely (and
they must fail powerpc's is_hugepd() check).

Link: https://lkml.kernel.org/r/3eba6f0-2b-fb66-6bb6-2ee8533e221@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
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
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zack Rusin <zackr@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pagewalk.c |   33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

--- a/mm/pagewalk.c~mm-pagewalk-walk_pte_range-allow-for-pte_offset_map
+++ a/mm/pagewalk.c
@@ -46,15 +46,27 @@ static int walk_pte_range(pmd_t *pmd, un
 	spinlock_t *ptl;
 
 	if (walk->no_vma) {
-		pte = pte_offset_map(pmd, addr);
-		err = walk_pte_range_inner(pte, addr, end, walk);
-		pte_unmap(pte);
+		/*
+		 * pte_offset_map() might apply user-specific validation.
+		 */
+		if (walk->mm == &init_mm)
+			pte = pte_offset_kernel(pmd, addr);
+		else
+			pte = pte_offset_map(pmd, addr);
+		if (pte) {
+			err = walk_pte_range_inner(pte, addr, end, walk);
+			if (walk->mm != &init_mm)
+				pte_unmap(pte);
+		}
 	} else {
 		pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
-		err = walk_pte_range_inner(pte, addr, end, walk);
-		pte_unmap_unlock(pte, ptl);
+		if (pte) {
+			err = walk_pte_range_inner(pte, addr, end, walk);
+			pte_unmap_unlock(pte, ptl);
+		}
 	}
-
+	if (!pte)
+		walk->action = ACTION_AGAIN;
 	return err;
 }
 
@@ -141,11 +153,8 @@ again:
 		    !(ops->pte_entry))
 			continue;
 
-		if (walk->vma) {
+		if (walk->vma)
 			split_huge_pmd(walk->vma, pmd, addr);
-			if (pmd_trans_unstable(pmd))
-				goto again;
-		}
 
 		if (is_hugepd(__hugepd(pmd_val(*pmd))))
 			err = walk_hugepd_range((hugepd_t *)pmd, addr, next, walk, PMD_SHIFT);
@@ -153,6 +162,10 @@ again:
 			err = walk_pte_range(pmd, addr, next, walk);
 		if (err)
 			break;
+
+		if (walk->action == ACTION_AGAIN)
+			goto again;
+
 	} while (pmd++, addr = next, addr != end);
 
 	return err;
_

Patches currently in -mm which might be from hughd@google.com are


