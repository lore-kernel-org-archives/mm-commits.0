Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 964CDEB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:23:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbjFSXX4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbjFSXWU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:22:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5079D1722
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:22:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2D7560FD7
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:22:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E5D5C433C9;
        Mon, 19 Jun 2023 23:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216928;
        bh=TbBb9eCebCD0+2j/1hXUbPx/F8Zdwj5WzLUJAtOOqvM=;
        h=Date:To:From:Subject:From;
        b=ftMcftVg2kG8AK9Rl7/coD3Z+qMT6YDkzJOvsau1qnvEoFxrzfixDXs7u1p7IwD5V
         GQbahE2EUmfqDIhVU4z+MRRm8tFdMhy37XQtI/e2RLGfmdf3W0gJ5LXM8gBu+5atpK
         POyBGl3kJ4P71OYEfcT3XDND0FmHlu/cwBcxkiSc=
Date:   Mon, 19 Jun 2023 16:22:07 -0700
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
Subject: [merged mm-stable] mm-swap-swap_vma_readahead-do-the-pte_offset_map.patch removed from -mm tree
Message-Id: <20230619232208.3E5D5C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swap: swap_vma_readahead() do the pte_offset_map()
has been removed from the -mm tree.  Its filename was
     mm-swap-swap_vma_readahead-do-the-pte_offset_map.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/swap: swap_vma_readahead() do the pte_offset_map()
Date: Thu, 8 Jun 2023 18:52:17 -0700 (PDT)

swap_vma_readahead() has been proceeding in an unconventional way, its
preliminary swap_ra_info() doing the pte_offset_map() and pte_unmap(),
then relying on that pte pointer even after the pte_unmap() - in its
CONFIG_64BIT case (I think !CONFIG_HIGHPTE was intended; whereas 32-bit
copied ptes to stack while they were mapped, but had to limit how many).

Though it would be difficult to construct a failing testcase, accessing
page table after pte_unmap() will become bad practice, even on 64-bit: an
rcu_read_unlock() in pte_unmap() will allow page table to be freed.

Move relevant definitions from include/linux/swap.h to mm/swap_state.c,
nothing else used them.  Delete the CONFIG_64BIT distinction and buffer,
delete all reference to ptes from swap_ra_info(), use pte_offset_map()
repeatedly in swap_vma_readahead(), breaking from the loop if it fails.

(Will the repeated "map" and "unmap" show up as a slowdown anywhere?  If
so, maybe modify __read_swap_cache_async() to do the pte_unmap() only when
it does not find the page already in the swapcache.)

Use ptep_get_lockless(), mainly for its READ_ONCE().  Correctly advance
the address passed down to each call of __read__swap_cache_async().

Link: https://lkml.kernel.org/r/b7c64ab3-9e44-aac0-d2b-c57de578af1c@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
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

 include/linux/swap.h |   19 -----------------
 mm/swap_state.c      |   45 +++++++++++++++++++++--------------------
 2 files changed, 24 insertions(+), 40 deletions(-)

--- a/include/linux/swap.h~mm-swap-swap_vma_readahead-do-the-pte_offset_map
+++ a/include/linux/swap.h
@@ -337,25 +337,6 @@ struct swap_info_struct {
 					   */
 };
 
-#ifdef CONFIG_64BIT
-#define SWAP_RA_ORDER_CEILING	5
-#else
-/* Avoid stack overflow, because we need to save part of page table */
-#define SWAP_RA_ORDER_CEILING	3
-#define SWAP_RA_PTE_CACHE_SIZE	(1 << SWAP_RA_ORDER_CEILING)
-#endif
-
-struct vma_swap_readahead {
-	unsigned short win;
-	unsigned short offset;
-	unsigned short nr_pte;
-#ifdef CONFIG_64BIT
-	pte_t *ptes;
-#else
-	pte_t ptes[SWAP_RA_PTE_CACHE_SIZE];
-#endif
-};
-
 static inline swp_entry_t folio_swap_entry(struct folio *folio)
 {
 	swp_entry_t entry = { .val = page_private(&folio->page) };
--- a/mm/swap_state.c~mm-swap-swap_vma_readahead-do-the-pte_offset_map
+++ a/mm/swap_state.c
@@ -709,6 +709,14 @@ void exit_swap_address_space(unsigned in
 	swapper_spaces[type] = NULL;
 }
 
+#define SWAP_RA_ORDER_CEILING	5
+
+struct vma_swap_readahead {
+	unsigned short win;
+	unsigned short offset;
+	unsigned short nr_pte;
+};
+
 static void swap_ra_info(struct vm_fault *vmf,
 			 struct vma_swap_readahead *ra_info)
 {
@@ -716,11 +724,7 @@ static void swap_ra_info(struct vm_fault
 	unsigned long ra_val;
 	unsigned long faddr, pfn, fpfn, lpfn, rpfn;
 	unsigned long start, end;
-	pte_t *pte, *orig_pte;
 	unsigned int max_win, hits, prev_win, win;
-#ifndef CONFIG_64BIT
-	pte_t *tpte;
-#endif
 
 	max_win = 1 << min_t(unsigned int, READ_ONCE(page_cluster),
 			     SWAP_RA_ORDER_CEILING);
@@ -739,12 +743,9 @@ static void swap_ra_info(struct vm_fault
 					       max_win, prev_win);
 	atomic_long_set(&vma->swap_readahead_info,
 			SWAP_RA_VAL(faddr, win, 0));
-
 	if (win == 1)
 		return;
 
-	/* Copy the PTEs because the page table may be unmapped */
-	orig_pte = pte = pte_offset_map(vmf->pmd, faddr);
 	if (fpfn == pfn + 1) {
 		lpfn = fpfn;
 		rpfn = fpfn + win;
@@ -764,15 +765,6 @@ static void swap_ra_info(struct vm_fault
 
 	ra_info->nr_pte = end - start;
 	ra_info->offset = fpfn - start;
-	pte -= ra_info->offset;
-#ifdef CONFIG_64BIT
-	ra_info->ptes = pte;
-#else
-	tpte = ra_info->ptes;
-	for (pfn = start; pfn != end; pfn++)
-		*tpte++ = *pte++;
-#endif
-	pte_unmap(orig_pte);
 }
 
 /**
@@ -796,7 +788,8 @@ static struct page *swap_vma_readahead(s
 	struct swap_iocb *splug = NULL;
 	struct vm_area_struct *vma = vmf->vma;
 	struct page *page;
-	pte_t *pte, pentry;
+	pte_t *pte = NULL, pentry;
+	unsigned long addr;
 	swp_entry_t entry;
 	unsigned int i;
 	bool page_allocated;
@@ -808,17 +801,25 @@ static struct page *swap_vma_readahead(s
 	if (ra_info.win == 1)
 		goto skip;
 
+	addr = vmf->address - (ra_info.offset * PAGE_SIZE);
+
 	blk_start_plug(&plug);
-	for (i = 0, pte = ra_info.ptes; i < ra_info.nr_pte;
-	     i++, pte++) {
-		pentry = *pte;
+	for (i = 0; i < ra_info.nr_pte; i++, addr += PAGE_SIZE) {
+		if (!pte++) {
+			pte = pte_offset_map(vmf->pmd, addr);
+			if (!pte)
+				break;
+		}
+		pentry = ptep_get_lockless(pte);
 		if (!is_swap_pte(pentry))
 			continue;
 		entry = pte_to_swp_entry(pentry);
 		if (unlikely(non_swap_entry(entry)))
 			continue;
+		pte_unmap(pte);
+		pte = NULL;
 		page = __read_swap_cache_async(entry, gfp_mask, vma,
-					       vmf->address, &page_allocated);
+					       addr, &page_allocated);
 		if (!page)
 			continue;
 		if (page_allocated) {
@@ -830,6 +831,8 @@ static struct page *swap_vma_readahead(s
 		}
 		put_page(page);
 	}
+	if (pte)
+		pte_unmap(pte);
 	blk_finish_plug(&plug);
 	swap_read_unplug(splug);
 	lru_add_drain();
_

Patches currently in -mm which might be from hughd@google.com are


