Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D6EDEB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:23:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbjFSXXZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbjFSXVx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:21:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF1F1134
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:21:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 848FC60FBE
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:21:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC5EC433C8;
        Mon, 19 Jun 2023 23:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216907;
        bh=gTpAm69rW2CsuY9/gdFcK/ANg0cXk6eia8BzPwlDnO0=;
        h=Date:To:From:Subject:From;
        b=QWRBqdDAgSX+JICtDynyny4obM5a/ghKSCrj471YoIPbtPT/5PrFm8JsedxWZCstp
         2AT1AoyKLGibYERSx3BDLCrDpg+qZJ4Nrb/t4jdL5mqH67HGwlrVxULTqUIFARqepw
         MHFuxH7lvDWZqg6f9hWxCh84DkWPW7YaF4j6hUFc=
Date:   Mon, 19 Jun 2023 16:21:47 -0700
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
Subject: [merged mm-stable] mm-various-give-up-if-pte_offset_map-fails.patch removed from -mm tree
Message-Id: <20230619232147.CFC5EC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/various: give up if pte_offset_map[_lock]() fails
has been removed from the -mm tree.  Its filename was
     mm-various-give-up-if-pte_offset_map-fails.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/various: give up if pte_offset_map[_lock]() fails
Date: Thu, 8 Jun 2023 18:29:22 -0700 (PDT)

Following the examples of nearby code, various functions can just give up
if pte_offset_map() or pte_offset_map_lock() fails.  And there's no need
for a preliminary pmd_trans_unstable() or other such check, since such
cases are now safely handled inside.

Link: https://lkml.kernel.org/r/7b9bd85d-1652-cbf2-159d-f503b45e5b@google.com
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

 mm/gup.c            |    9 ++++++---
 mm/ksm.c            |    7 ++++---
 mm/memcontrol.c     |    8 ++++----
 mm/memory-failure.c |    8 +++++---
 mm/migrate.c        |    3 +++
 5 files changed, 22 insertions(+), 13 deletions(-)

--- a/mm/gup.c~mm-various-give-up-if-pte_offset_map-fails
+++ a/mm/gup.c
@@ -545,10 +545,10 @@ static struct page *follow_page_pte(stru
 	if (WARN_ON_ONCE((flags & (FOLL_PIN | FOLL_GET)) ==
 			 (FOLL_PIN | FOLL_GET)))
 		return ERR_PTR(-EINVAL);
-	if (unlikely(pmd_bad(*pmd)))
-		return no_page_table(vma, flags);
 
 	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
+	if (!ptep)
+		return no_page_table(vma, flags);
 	pte = *ptep;
 	if (!pte_present(pte))
 		goto no_page;
@@ -852,8 +852,9 @@ static int get_gate_page(struct mm_struc
 	pmd = pmd_offset(pud, address);
 	if (!pmd_present(*pmd))
 		return -EFAULT;
-	VM_BUG_ON(pmd_trans_huge(*pmd));
 	pte = pte_offset_map(pmd, address);
+	if (!pte)
+		return -EFAULT;
 	if (pte_none(*pte))
 		goto unmap;
 	*vma = get_gate_vma(mm);
@@ -2468,6 +2469,8 @@ static int gup_pte_range(pmd_t pmd, pmd_
 	pte_t *ptep, *ptem;
 
 	ptem = ptep = pte_offset_map(&pmd, addr);
+	if (!ptep)
+		return 0;
 	do {
 		pte_t pte = ptep_get_lockless(ptep);
 		struct page *page;
--- a/mm/ksm.c~mm-various-give-up-if-pte_offset_map-fails
+++ a/mm/ksm.c
@@ -431,10 +431,9 @@ static int break_ksm_pmd_entry(pmd_t *pm
 	pte_t *pte;
 	int ret;
 
-	if (pmd_leaf(*pmd) || !pmd_present(*pmd))
-		return 0;
-
 	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
+	if (!pte)
+		return 0;
 	if (pte_present(*pte)) {
 		page = vm_normal_page(walk->vma, addr, *pte);
 	} else if (!pte_none(*pte)) {
@@ -1203,6 +1202,8 @@ static int replace_page(struct vm_area_s
 	mmu_notifier_invalidate_range_start(&range);
 
 	ptep = pte_offset_map_lock(mm, pmd, addr, &ptl);
+	if (!ptep)
+		goto out_mn;
 	if (!pte_same(*ptep, orig_pte)) {
 		pte_unmap_unlock(ptep, ptl);
 		goto out_mn;
--- a/mm/memcontrol.c~mm-various-give-up-if-pte_offset_map-fails
+++ a/mm/memcontrol.c
@@ -6021,9 +6021,9 @@ static int mem_cgroup_count_precharge_pt
 		return 0;
 	}
 
-	if (pmd_trans_unstable(pmd))
-		return 0;
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
+	if (!pte)
+		return 0;
 	for (; addr != end; pte++, addr += PAGE_SIZE)
 		if (get_mctgt_type(vma, addr, *pte, NULL))
 			mc.precharge++;	/* increment precharge temporarily */
@@ -6241,10 +6241,10 @@ static int mem_cgroup_move_charge_pte_ra
 		return 0;
 	}
 
-	if (pmd_trans_unstable(pmd))
-		return 0;
 retry:
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
+	if (!pte)
+		return 0;
 	for (; addr != end; addr += PAGE_SIZE) {
 		pte_t ptent = *(pte++);
 		bool device = false;
--- a/mm/memory-failure.c~mm-various-give-up-if-pte_offset_map-fails
+++ a/mm/memory-failure.c
@@ -405,6 +405,8 @@ static unsigned long dev_pagemap_mapping
 	if (pmd_devmap(*pmd))
 		return PMD_SHIFT;
 	pte = pte_offset_map(pmd, address);
+	if (!pte)
+		return 0;
 	if (pte_present(*pte) && pte_devmap(*pte))
 		ret = PAGE_SHIFT;
 	pte_unmap(pte);
@@ -791,11 +793,11 @@ static int hwpoison_pte_range(pmd_t *pmd
 		goto out;
 	}
 
-	if (pmd_trans_unstable(pmdp))
-		goto out;
-
 	mapped_pte = ptep = pte_offset_map_lock(walk->vma->vm_mm, pmdp,
 						addr, &ptl);
+	if (!ptep)
+		goto out;
+
 	for (; addr != end; ptep++, addr += PAGE_SIZE) {
 		ret = check_hwpoisoned_entry(*ptep, addr, PAGE_SHIFT,
 					     hwp->pfn, &hwp->tk);
--- a/mm/migrate.c~mm-various-give-up-if-pte_offset_map-fails
+++ a/mm/migrate.c
@@ -305,6 +305,9 @@ void migration_entry_wait(struct mm_stru
 	swp_entry_t entry;
 
 	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
+	if (!ptep)
+		return;
+
 	pte = *ptep;
 	pte_unmap(ptep);
 
_

Patches currently in -mm which might be from hughd@google.com are


