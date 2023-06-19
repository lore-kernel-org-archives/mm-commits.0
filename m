Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A47AEB64DB
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:23:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjFSXXv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbjFSXWT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:22:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB201712
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:21:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A900460FB6
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:21:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01B79C433C0;
        Mon, 19 Jun 2023 23:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216918;
        bh=mxKVC4yTv6JaWSLVx9LIDoHlTKtetPGjg1UCOaAZeHg=;
        h=Date:To:From:Subject:From;
        b=nhflFYY92Tmtcofx4ICeJCjvidHYdYB42gFU8UPbyHoF+oagJYNMUC9+yWrAXphHH
         TJ60tF0fIZPG+TRBPQMflxvwVFSzJXvG2Y/AgkMryndBvKqzyhKxQSNbm5V3+eSrvf
         FjD++Tq7iw/OHdbeUyZi2ySBLHHIDryac4Yfqaac=
Date:   Mon, 19 Jun 2023 16:21:57 -0700
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
Subject: [merged mm-stable] mm-migrate_device-allow-pte_offset_map_lock-to-fail.patch removed from -mm tree
Message-Id: <20230619232158.01B79C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/migrate_device: allow pte_offset_map_lock() to fail
has been removed from the -mm tree.  Its filename was
     mm-migrate_device-allow-pte_offset_map_lock-to-fail.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/migrate_device: allow pte_offset_map_lock() to fail
Date: Thu, 8 Jun 2023 18:38:17 -0700 (PDT)

migrate_vma_collect_pmd(): remove the pmd_trans_unstable() handling after
splitting huge zero pmd, and the pmd_none() handling after successfully
splitting huge page: those are now managed inside pte_offset_map_lock(),
and by "goto again" when it fails.

But the skip after unsuccessful split_huge_page() must stay: it avoids an
endless loop.  The skip when pmd_bad()?  Remove that: it will be treated
as a hole rather than a skip once cleared by pte_offset_map_lock(), but
with different timing that would be so anyway; and it's arguably best to
leave the pmd_bad() handling centralized there.

migrate_vma_insert_page(): remove comment on the old pte_offset_map() and
old locking limitations; remove the pmd_trans_unstable() check and just
proceed to pte_offset_map_lock(), aborting when it fails (page has been
charged to memcg, but as in other cases, it's uncharged when freed).

Link: https://lkml.kernel.org/r/1131be62-2e84-da2f-8f45-807b2cbeeec5@google.com
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

 mm/migrate_device.c |   31 ++++---------------------------
 1 file changed, 4 insertions(+), 27 deletions(-)

--- a/mm/migrate_device.c~mm-migrate_device-allow-pte_offset_map_lock-to-fail
+++ a/mm/migrate_device.c
@@ -83,9 +83,6 @@ again:
 		if (is_huge_zero_page(page)) {
 			spin_unlock(ptl);
 			split_huge_pmd(vma, pmdp, addr);
-			if (pmd_trans_unstable(pmdp))
-				return migrate_vma_collect_skip(start, end,
-								walk);
 		} else {
 			int ret;
 
@@ -100,16 +97,12 @@ again:
 			if (ret)
 				return migrate_vma_collect_skip(start, end,
 								walk);
-			if (pmd_none(*pmdp))
-				return migrate_vma_collect_hole(start, end, -1,
-								walk);
 		}
 	}
 
-	if (unlikely(pmd_bad(*pmdp)))
-		return migrate_vma_collect_skip(start, end, walk);
-
 	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
+	if (!ptep)
+		goto again;
 	arch_enter_lazy_mmu_mode();
 
 	for (; addr < end; addr += PAGE_SIZE, ptep++) {
@@ -595,27 +588,10 @@ static void migrate_vma_insert_page(stru
 	pmdp = pmd_alloc(mm, pudp, addr);
 	if (!pmdp)
 		goto abort;
-
 	if (pmd_trans_huge(*pmdp) || pmd_devmap(*pmdp))
 		goto abort;
-
-	/*
-	 * Use pte_alloc() instead of pte_alloc_map().  We can't run
-	 * pte_offset_map() on pmds where a huge pmd might be created
-	 * from a different thread.
-	 *
-	 * pte_alloc_map() is safe to use under mmap_write_lock(mm) or when
-	 * parallel threads are excluded by other means.
-	 *
-	 * Here we only have mmap_read_lock(mm).
-	 */
 	if (pte_alloc(mm, pmdp))
 		goto abort;
-
-	/* See the comment in pte_alloc_one_map() */
-	if (unlikely(pmd_trans_unstable(pmdp)))
-		goto abort;
-
 	if (unlikely(anon_vma_prepare(vma)))
 		goto abort;
 	if (mem_cgroup_charge(page_folio(page), vma->vm_mm, GFP_KERNEL))
@@ -650,7 +626,8 @@ static void migrate_vma_insert_page(stru
 	}
 
 	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
-
+	if (!ptep)
+		goto abort;
 	if (check_stable_address_space(mm))
 		goto unlock_abort;
 
_

Patches currently in -mm which might be from hughd@google.com are


