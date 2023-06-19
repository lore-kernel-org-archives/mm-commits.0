Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55BA5EB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:23:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbjFSXXb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbjFSXWC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:22:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3323710D7
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:21:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD65560F0D
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0401BC433C0;
        Mon, 19 Jun 2023 23:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216912;
        bh=7gq55N/spm3wLqZ95eiphFTsOiBPneIwDyqxFrFSkoI=;
        h=Date:To:From:Subject:From;
        b=SoAQ6CJgdLFdwiv+X1Y8jjrFeWRRP0z95y33HoECg6ZRX5p2qmnjcIh0pAgMJre3u
         NhsnXHqId3mGHd8VKe/2f4uu4Knhwi7JjX/rnK77Sc13fxgELUYpe2Q1irHZ1Ti9So
         NaR0QCwRHGW9CTYQdDbW2lAqUFikA/Qs+l82STJE=
Date:   Mon, 19 Jun 2023 16:21:51 -0700
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
Subject: [merged mm-stable] mm-madvise-clean-up-pte_offset_map_lock-scans.patch removed from -mm tree
Message-Id: <20230619232152.0401BC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/madvise: clean up pte_offset_map_lock() scans
has been removed from the -mm tree.  Its filename was
     mm-madvise-clean-up-pte_offset_map_lock-scans.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/madvise: clean up pte_offset_map_lock() scans
Date: Thu, 8 Jun 2023 18:34:03 -0700 (PDT)

Came here to make madvise's several pte_offset_map_lock() scans advance to
next extent on failure, and remove superfluous pmd_trans_unstable() and
pmd_none_or_trans_huge_or_clear_bad() calls.  But also did some nearby
cleanup.

swapin_walk_pmd_entry(): don't name an address "index"; don't drop the
lock after every pte, only when calling out to read_swap_cache_async().

madvise_cold_or_pageout_pte_range() and madvise_free_pte_range(): prefer
"start_pte" for pointer, orig_pte usually denotes a saved pte value; leave
lazy MMU mode before unlocking; merge the success and failure paths after
split_folio().

Link: https://lkml.kernel.org/r/cc4d9a88-9da6-362-50d9-6735c2b125c6@google.com
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

 mm/madvise.c |  122 +++++++++++++++++++++++++++----------------------
 1 file changed, 68 insertions(+), 54 deletions(-)

--- a/mm/madvise.c~mm-madvise-clean-up-pte_offset_map_lock-scans
+++ a/mm/madvise.c
@@ -188,37 +188,43 @@ success:
 
 #ifdef CONFIG_SWAP
 static int swapin_walk_pmd_entry(pmd_t *pmd, unsigned long start,
-	unsigned long end, struct mm_walk *walk)
+		unsigned long end, struct mm_walk *walk)
 {
 	struct vm_area_struct *vma = walk->private;
-	unsigned long index;
 	struct swap_iocb *splug = NULL;
+	pte_t *ptep = NULL;
+	spinlock_t *ptl;
+	unsigned long addr;
 
-	if (pmd_none_or_trans_huge_or_clear_bad(pmd))
-		return 0;
-
-	for (index = start; index != end; index += PAGE_SIZE) {
+	for (addr = start; addr < end; addr += PAGE_SIZE) {
 		pte_t pte;
 		swp_entry_t entry;
 		struct page *page;
-		spinlock_t *ptl;
-		pte_t *ptep;
 
-		ptep = pte_offset_map_lock(vma->vm_mm, pmd, index, &ptl);
-		pte = *ptep;
-		pte_unmap_unlock(ptep, ptl);
+		if (!ptep++) {
+			ptep = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
+			if (!ptep)
+				break;
+		}
 
+		pte = *ptep;
 		if (!is_swap_pte(pte))
 			continue;
 		entry = pte_to_swp_entry(pte);
 		if (unlikely(non_swap_entry(entry)))
 			continue;
 
+		pte_unmap_unlock(ptep, ptl);
+		ptep = NULL;
+
 		page = read_swap_cache_async(entry, GFP_HIGHUSER_MOVABLE,
-					     vma, index, false, &splug);
+					     vma, addr, false, &splug);
 		if (page)
 			put_page(page);
 	}
+
+	if (ptep)
+		pte_unmap_unlock(ptep, ptl);
 	swap_read_unplug(splug);
 	cond_resched();
 
@@ -340,7 +346,7 @@ static int madvise_cold_or_pageout_pte_r
 	bool pageout = private->pageout;
 	struct mm_struct *mm = tlb->mm;
 	struct vm_area_struct *vma = walk->vma;
-	pte_t *orig_pte, *pte, ptent;
+	pte_t *start_pte, *pte, ptent;
 	spinlock_t *ptl;
 	struct folio *folio = NULL;
 	LIST_HEAD(folio_list);
@@ -422,11 +428,11 @@ huge_unlock:
 	}
 
 regular_folio:
-	if (pmd_trans_unstable(pmd))
-		return 0;
 #endif
 	tlb_change_page_size(tlb, PAGE_SIZE);
-	orig_pte = pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
+	start_pte = pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
+	if (!start_pte)
+		return 0;
 	flush_tlb_batched_pending(mm);
 	arch_enter_lazy_mmu_mode();
 	for (; addr < end; pte++, addr += PAGE_SIZE) {
@@ -447,25 +453,28 @@ regular_folio:
 		 * are sure it's worth. Split it if we are only owner.
 		 */
 		if (folio_test_large(folio)) {
+			int err;
+
 			if (folio_mapcount(folio) != 1)
 				break;
 			if (pageout_anon_only_filter && !folio_test_anon(folio))
 				break;
-			folio_get(folio);
-			if (!folio_trylock(folio)) {
-				folio_put(folio);
-				break;
-			}
-			pte_unmap_unlock(orig_pte, ptl);
-			if (split_folio(folio)) {
-				folio_unlock(folio);
-				folio_put(folio);
-				orig_pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
+			if (!folio_trylock(folio))
 				break;
-			}
+			folio_get(folio);
+			arch_leave_lazy_mmu_mode();
+			pte_unmap_unlock(start_pte, ptl);
+			start_pte = NULL;
+			err = split_folio(folio);
 			folio_unlock(folio);
 			folio_put(folio);
-			orig_pte = pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
+			if (err)
+				break;
+			start_pte = pte =
+				pte_offset_map_lock(mm, pmd, addr, &ptl);
+			if (!start_pte)
+				break;
+			arch_enter_lazy_mmu_mode();
 			pte--;
 			addr -= PAGE_SIZE;
 			continue;
@@ -510,8 +519,10 @@ regular_folio:
 			folio_deactivate(folio);
 	}
 
-	arch_leave_lazy_mmu_mode();
-	pte_unmap_unlock(orig_pte, ptl);
+	if (start_pte) {
+		arch_leave_lazy_mmu_mode();
+		pte_unmap_unlock(start_pte, ptl);
+	}
 	if (pageout)
 		reclaim_pages(&folio_list);
 	cond_resched();
@@ -612,7 +623,7 @@ static int madvise_free_pte_range(pmd_t
 	struct mm_struct *mm = tlb->mm;
 	struct vm_area_struct *vma = walk->vma;
 	spinlock_t *ptl;
-	pte_t *orig_pte, *pte, ptent;
+	pte_t *start_pte, *pte, ptent;
 	struct folio *folio;
 	int nr_swap = 0;
 	unsigned long next;
@@ -620,13 +631,12 @@ static int madvise_free_pte_range(pmd_t
 	next = pmd_addr_end(addr, end);
 	if (pmd_trans_huge(*pmd))
 		if (madvise_free_huge_pmd(tlb, vma, pmd, addr, next))
-			goto next;
-
-	if (pmd_trans_unstable(pmd))
-		return 0;
+			return 0;
 
 	tlb_change_page_size(tlb, PAGE_SIZE);
-	orig_pte = pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
+	start_pte = pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
+	if (!start_pte)
+		return 0;
 	flush_tlb_batched_pending(mm);
 	arch_enter_lazy_mmu_mode();
 	for (; addr != end; pte++, addr += PAGE_SIZE) {
@@ -664,23 +674,26 @@ static int madvise_free_pte_range(pmd_t
 		 * deactivate all pages.
 		 */
 		if (folio_test_large(folio)) {
+			int err;
+
 			if (folio_mapcount(folio) != 1)
-				goto out;
+				break;
+			if (!folio_trylock(folio))
+				break;
 			folio_get(folio);
-			if (!folio_trylock(folio)) {
-				folio_put(folio);
-				goto out;
-			}
-			pte_unmap_unlock(orig_pte, ptl);
-			if (split_folio(folio)) {
-				folio_unlock(folio);
-				folio_put(folio);
-				orig_pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
-				goto out;
-			}
+			arch_leave_lazy_mmu_mode();
+			pte_unmap_unlock(start_pte, ptl);
+			start_pte = NULL;
+			err = split_folio(folio);
 			folio_unlock(folio);
 			folio_put(folio);
-			orig_pte = pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
+			if (err)
+				break;
+			start_pte = pte =
+				pte_offset_map_lock(mm, pmd, addr, &ptl);
+			if (!start_pte)
+				break;
+			arch_enter_lazy_mmu_mode();
 			pte--;
 			addr -= PAGE_SIZE;
 			continue;
@@ -725,17 +738,18 @@ static int madvise_free_pte_range(pmd_t
 		}
 		folio_mark_lazyfree(folio);
 	}
-out:
+
 	if (nr_swap) {
 		if (current->mm == mm)
 			sync_mm_rss(mm);
-
 		add_mm_counter(mm, MM_SWAPENTS, nr_swap);
 	}
-	arch_leave_lazy_mmu_mode();
-	pte_unmap_unlock(orig_pte, ptl);
+	if (start_pte) {
+		arch_leave_lazy_mmu_mode();
+		pte_unmap_unlock(start_pte, ptl);
+	}
 	cond_resched();
-next:
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from hughd@google.com are


