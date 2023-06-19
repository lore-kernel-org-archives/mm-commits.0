Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B6C4EB64DB
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:24:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbjFSXYW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbjFSXWU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:22:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE84D1725
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:22:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44A0660FB6
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:22:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9108BC433C0;
        Mon, 19 Jun 2023 23:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216929;
        bh=03U9zixlc0jcmRhgkeuUaVInH8/jAvGSiMK/L2Ed9uM=;
        h=Date:To:From:Subject:From;
        b=kUhOTXMegJ0aAjNgMxH/geqIGSCt9O4uWvotMHdoypknoQ4+kFed0kB4egVOYVoTT
         AfDOlV6t6TFhp0pioFzg/tmngjGOeFQmLssue1Fx44oZO55w+muR6VN9VxneCSr20p
         ubunc3iIhxkfmF+1Z+MfYNgJZdRN+ltT247xLoSE=
Date:   Mon, 19 Jun 2023 16:22:09 -0700
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
Subject: [merged mm-stable] perf-core-allow-pte_offset_map-to-fail.patch removed from -mm tree
Message-Id: <20230619232209.9108BC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: perf/core: allow pte_offset_map() to fail
has been removed from the -mm tree.  Its filename was
     perf-core-allow-pte_offset_map-to-fail.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: perf/core: allow pte_offset_map() to fail
Date: Thu, 8 Jun 2023 18:53:23 -0700 (PDT)

In rare transient cases, not yet made possible, pte_offset_map() and
pte_offet_map_lock() may not find a page table: handle appropriately.

[hughd@google.com: __wp_page_copy_user(): don't call update_mmu_tlb() with NULL]
  Link: https://lkml.kernel.org/r/1a4db221-7872-3594-57ce-42369945ec8d@google.com
Link: https://lkml.kernel.org/r/a194441b-63f3-adb6-5964-7ca3171ae7c2@google.com
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

 kernel/events/core.c |    4 ++++
 mm/memory.c          |    6 ++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/kernel/events/core.c~perf-core-allow-pte_offset_map-to-fail
+++ a/kernel/events/core.c
@@ -7490,6 +7490,7 @@ static u64 perf_get_pgtable_size(struct
 		return pud_leaf_size(pud);
 
 	pmdp = pmd_offset_lockless(pudp, pud, addr);
+again:
 	pmd = pmdp_get_lockless(pmdp);
 	if (!pmd_present(pmd))
 		return 0;
@@ -7498,6 +7499,9 @@ static u64 perf_get_pgtable_size(struct
 		return pmd_leaf_size(pmd);
 
 	ptep = pte_offset_map(&pmd, addr);
+	if (!ptep)
+		goto again;
+
 	pte = ptep_get_lockless(ptep);
 	if (pte_present(pte))
 		size = pte_leaf_size(pte);
--- a/mm/memory.c~perf-core-allow-pte_offset_map-to-fail
+++ a/mm/memory.c
@@ -2843,7 +2843,8 @@ static inline int __wp_page_copy_user(st
 			 * Other thread has already handled the fault
 			 * and update local tlb only
 			 */
-			update_mmu_tlb(vma, addr, vmf->pte);
+			if (vmf->pte)
+				update_mmu_tlb(vma, addr, vmf->pte);
 			ret = -EAGAIN;
 			goto pte_unlock;
 		}
@@ -2867,7 +2868,8 @@ static inline int __wp_page_copy_user(st
 		vmf->pte = pte_offset_map_lock(mm, vmf->pmd, addr, &vmf->ptl);
 		if (unlikely(!vmf->pte || !pte_same(*vmf->pte, vmf->orig_pte))) {
 			/* The PTE changed under us, update local tlb */
-			update_mmu_tlb(vma, addr, vmf->pte);
+			if (vmf->pte)
+				update_mmu_tlb(vma, addr, vmf->pte);
 			ret = -EAGAIN;
 			goto pte_unlock;
 		}
_

Patches currently in -mm which might be from hughd@google.com are


