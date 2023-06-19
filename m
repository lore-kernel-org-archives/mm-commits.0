Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F2FAEB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:23:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjFSXXu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbjFSXWG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:22:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73184170C
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:21:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D5BD60F79
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:21:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5A7C433CA;
        Mon, 19 Jun 2023 23:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216916;
        bh=Ulg0YAsQpSzZyqdKN++MUVkG6JxAiQVvJ/Np3rA5vSg=;
        h=Date:To:From:Subject:From;
        b=OiQL6qh9dOViUVV+VmO1qX1bVTttC2W/yTyZcwVn3DlEdero8F7Tzx9sTnVeTU21f
         Q80OLAGtt8Isa+PMu8leDGO0p5kedr5NiLiutMfBIqnff6ZXeaUYapQSDsau2hHijR
         40zZvmajLxBHNvz4UEhd0zAfvJzV4MviulmFTrbU=
Date:   Mon, 19 Jun 2023 16:21:55 -0700
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
Subject: [merged mm-stable] mm-mglru-allow-pte_offset_map_nolock-to-fail.patch removed from -mm tree
Message-Id: <20230619232156.5D5A7C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mglru: allow pte_offset_map_nolock() to fail
has been removed from the -mm tree.  Its filename was
     mm-mglru-allow-pte_offset_map_nolock-to-fail.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/mglru: allow pte_offset_map_nolock() to fail
Date: Thu, 8 Jun 2023 18:37:12 -0700 (PDT)

MGLRU's walk_pte_range() use the safer pte_offset_map_nolock(), rather
than pte_lockptr(), to get the ptl for its trylock.  Just return false and
move on to next extent if it fails, like when the trylock fails.  Remove
the VM_WARN_ON_ONCE(pmd_leaf) since that will happen, rarely.

Link: https://lkml.kernel.org/r/51ece73e-7398-2e4a-2384-56708c87844f@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Yu Zhao <yuzhao@google.com>
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
Cc: Zack Rusin <zackr@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/mm/vmscan.c~mm-mglru-allow-pte_offset_map_nolock-to-fail
+++ a/mm/vmscan.c
@@ -4024,15 +4024,15 @@ static bool walk_pte_range(pmd_t *pmd, u
 	struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
 	int old_gen, new_gen = lru_gen_from_seq(walk->max_seq);
 
-	VM_WARN_ON_ONCE(pmd_leaf(*pmd));
-
-	ptl = pte_lockptr(args->mm, pmd);
-	if (!spin_trylock(ptl))
+	pte = pte_offset_map_nolock(args->mm, pmd, start & PMD_MASK, &ptl);
+	if (!pte)
+		return false;
+	if (!spin_trylock(ptl)) {
+		pte_unmap(pte);
 		return false;
+	}
 
 	arch_enter_lazy_mmu_mode();
-
-	pte = pte_offset_map(pmd, start & PMD_MASK);
 restart:
 	for (i = pte_index(start), addr = start; addr != end; i++, addr += PAGE_SIZE) {
 		unsigned long pfn;
@@ -4073,10 +4073,8 @@ restart:
 	if (i < PTRS_PER_PTE && get_next_vma(PMD_MASK, PAGE_SIZE, args, &start, &end))
 		goto restart;
 
-	pte_unmap(pte);
-
 	arch_leave_lazy_mmu_mode();
-	spin_unlock(ptl);
+	pte_unmap_unlock(pte, ptl);
 
 	return suitable_to_scan(total, young);
 }
_

Patches currently in -mm which might be from hughd@google.com are


