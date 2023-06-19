Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EAF9EB64DC
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:23:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjFSXXE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjFSXVv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:21:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C7AE68
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:21:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BC6E60F3A
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:21:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6FE3C433C0;
        Mon, 19 Jun 2023 23:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216897;
        bh=+VDqepG4pU7FYxMdepFNzAYPtv+8G4yoozjS1Rpz9ZQ=;
        h=Date:To:From:Subject:From;
        b=VgIQ5h7IYsleeWtnxGl06yQ0dLZM+gkKCk9GOoAC95wLKXiH/sQnMbgbQ7spXbyTB
         mk7CgT7oIwT5I2khpnJfZqs1CzUDUSe8xdXV+oMNhyYacfyqvlk/e4jCSRMEh5lGbz
         Qnk572nMlwQvPhnfvq8T30rd4Nf0iGVaur37GHwQ=
Date:   Mon, 19 Jun 2023 16:21:36 -0700
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
Subject: [merged mm-stable] mm-pagewalkers-action_again-if-pte_offset_map_lock-fails.patch removed from -mm tree
Message-Id: <20230619232136.E6FE3C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/pagewalkers: ACTION_AGAIN if pte_offset_map_lock() fails
has been removed from the -mm tree.  Its filename was
     mm-pagewalkers-action_again-if-pte_offset_map_lock-fails.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/pagewalkers: ACTION_AGAIN if pte_offset_map_lock() fails
Date: Thu, 8 Jun 2023 18:17:26 -0700 (PDT)

Simple walk_page_range() users should set ACTION_AGAIN to retry when
pte_offset_map_lock() fails.

No need to check pmd_trans_unstable(): that was precisely to avoid the
possiblity of calling pte_offset_map() on a racily removed or inserted THP
entry, but such cases are now safely handled inside it.  Likewise there is
no need to check pmd_none() or pmd_bad() before calling it.

Link: https://lkml.kernel.org/r/c77d9d10-3aad-e3ce-4896-99e91c7947f3@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: SeongJae Park <sj@kernel.org> for mm/damon part
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

 fs/proc/task_mmu.c |   32 ++++++++++++++++----------------
 mm/damon/vaddr.c   |   12 ++++++++----
 mm/mempolicy.c     |    7 ++++---
 mm/mincore.c       |    9 ++++-----
 mm/mlock.c         |    4 ++++
 5 files changed, 36 insertions(+), 28 deletions(-)

--- a/fs/proc/task_mmu.c~mm-pagewalkers-action_again-if-pte_offset_map_lock-fails
+++ a/fs/proc/task_mmu.c
@@ -631,14 +631,11 @@ static int smaps_pte_range(pmd_t *pmd, u
 		goto out;
 	}
 
-	if (pmd_trans_unstable(pmd))
-		goto out;
-	/*
-	 * The mmap_lock held all the way back in m_start() is what
-	 * keeps khugepaged out of here and from collapsing things
-	 * in here.
-	 */
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
+	if (!pte) {
+		walk->action = ACTION_AGAIN;
+		return 0;
+	}
 	for (; addr != end; pte++, addr += PAGE_SIZE)
 		smaps_pte_entry(pte, addr, walk);
 	pte_unmap_unlock(pte - 1, ptl);
@@ -1191,10 +1188,11 @@ out:
 		return 0;
 	}
 
-	if (pmd_trans_unstable(pmd))
-		return 0;
-
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
+	if (!pte) {
+		walk->action = ACTION_AGAIN;
+		return 0;
+	}
 	for (; addr != end; pte++, addr += PAGE_SIZE) {
 		ptent = *pte;
 
@@ -1538,9 +1536,6 @@ static int pagemap_pmd_range(pmd_t *pmdp
 		spin_unlock(ptl);
 		return err;
 	}
-
-	if (pmd_trans_unstable(pmdp))
-		return 0;
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 	/*
@@ -1548,6 +1543,10 @@ static int pagemap_pmd_range(pmd_t *pmdp
 	 * goes beyond vma->vm_end.
 	 */
 	orig_pte = pte = pte_offset_map_lock(walk->mm, pmdp, addr, &ptl);
+	if (!pte) {
+		walk->action = ACTION_AGAIN;
+		return err;
+	}
 	for (; addr < end; pte++, addr += PAGE_SIZE) {
 		pagemap_entry_t pme;
 
@@ -1887,11 +1886,12 @@ static int gather_pte_stats(pmd_t *pmd,
 		spin_unlock(ptl);
 		return 0;
 	}
-
-	if (pmd_trans_unstable(pmd))
-		return 0;
 #endif
 	orig_pte = pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
+	if (!pte) {
+		walk->action = ACTION_AGAIN;
+		return 0;
+	}
 	do {
 		struct page *page = can_gather_numa_stats(*pte, vma, addr);
 		if (!page)
--- a/mm/damon/vaddr.c~mm-pagewalkers-action_again-if-pte_offset_map_lock-fails
+++ a/mm/damon/vaddr.c
@@ -318,9 +318,11 @@ static int damon_mkold_pmd_entry(pmd_t *
 		spin_unlock(ptl);
 	}
 
-	if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
-		return 0;
 	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
+	if (!pte) {
+		walk->action = ACTION_AGAIN;
+		return 0;
+	}
 	if (!pte_present(*pte))
 		goto out;
 	damon_ptep_mkold(pte, walk->vma, addr);
@@ -464,9 +466,11 @@ huge_out:
 regular_page:
 #endif	/* CONFIG_TRANSPARENT_HUGEPAGE */
 
-	if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
-		return -EINVAL;
 	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
+	if (!pte) {
+		walk->action = ACTION_AGAIN;
+		return 0;
+	}
 	if (!pte_present(*pte))
 		goto out;
 	folio = damon_get_folio(pte_pfn(*pte));
--- a/mm/mempolicy.c~mm-pagewalkers-action_again-if-pte_offset_map_lock-fails
+++ a/mm/mempolicy.c
@@ -514,10 +514,11 @@ static int queue_folios_pte_range(pmd_t
 	if (ptl)
 		return queue_folios_pmd(pmd, ptl, addr, end, walk);
 
-	if (pmd_trans_unstable(pmd))
-		return 0;
-
 	mapped_pte = pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
+	if (!pte) {
+		walk->action = ACTION_AGAIN;
+		return 0;
+	}
 	for (; addr != end; pte++, addr += PAGE_SIZE) {
 		if (!pte_present(*pte))
 			continue;
--- a/mm/mincore.c~mm-pagewalkers-action_again-if-pte_offset_map_lock-fails
+++ a/mm/mincore.c
@@ -113,12 +113,11 @@ static int mincore_pte_range(pmd_t *pmd,
 		goto out;
 	}
 
-	if (pmd_trans_unstable(pmd)) {
-		__mincore_unmapped_range(addr, end, vma, vec);
-		goto out;
-	}
-
 	ptep = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
+	if (!ptep) {
+		walk->action = ACTION_AGAIN;
+		return 0;
+	}
 	for (; addr != end; ptep++, addr += PAGE_SIZE) {
 		pte_t pte = *ptep;
 
--- a/mm/mlock.c~mm-pagewalkers-action_again-if-pte_offset_map_lock-fails
+++ a/mm/mlock.c
@@ -329,6 +329,10 @@ static int mlock_pte_range(pmd_t *pmd, u
 	}
 
 	start_pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
+	if (!start_pte) {
+		walk->action = ACTION_AGAIN;
+		return 0;
+	}
 	for (pte = start_pte; addr != end; pte++, addr += PAGE_SIZE) {
 		if (!pte_present(*pte))
 			continue;
_

Patches currently in -mm which might be from hughd@google.com are


