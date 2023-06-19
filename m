Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B56A4EB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:23:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjFSXXk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbjFSXWD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:22:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B30B10E0
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:21:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5E9F60F0D
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:21:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3683C433C0;
        Mon, 19 Jun 2023 23:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216915;
        bh=0aSKu4UR98Vg8ZnXL4uwSsT8+utgtLtV/mEWUuhGcVA=;
        h=Date:To:From:Subject:From;
        b=lpAvOQLzxDbmTyWKjlOExe0X+bbg0xKmpr94aZKlmmNyeF0upLzSRcWK8uoFY1LB2
         FrHjJVLKSpkHvJL7M4Bx3c5/xceS7/rLrONorRW+r2E1ZqtKmBqk+wqXsmNW0p+2j9
         3qVgXXBwGwIOxRJu142HBxYB73KCQEZwJ0yFx7LM=
Date:   Mon, 19 Jun 2023 16:21:54 -0700
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
Subject: [merged mm-stable] mm-swapoff-allow-pte_offset_map-to-fail.patch removed from -mm tree
Message-Id: <20230619232154.F3683C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swapoff: allow pte_offset_map[_lock]() to fail
has been removed from the -mm tree.  Its filename was
     mm-swapoff-allow-pte_offset_map-to-fail.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/swapoff: allow pte_offset_map[_lock]() to fail
Date: Thu, 8 Jun 2023 18:36:11 -0700 (PDT)

Adjust unuse_pte() and unuse_pte_range() to allow pte_offset_map_lock()
and pte_offset_map() failure; remove pmd_none_or_trans_huge_or_clear_bad()
from unuse_pmd_range() now that pte_offset_map() does all that itself.

Link: https://lkml.kernel.org/r/c4d831-13c3-9dfd-70c2-64514ad951fd@google.com
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

 mm/swapfile.c |   38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

--- a/mm/swapfile.c~mm-swapoff-allow-pte_offset_map-to-fail
+++ a/mm/swapfile.c
@@ -1757,7 +1757,7 @@ static int unuse_pte(struct vm_area_stru
 		hwposioned = true;
 
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
-	if (unlikely(!pte_same_as_swp(*pte, swp_entry_to_pte(entry)))) {
+	if (unlikely(!pte || !pte_same_as_swp(*pte, swp_entry_to_pte(entry)))) {
 		ret = 0;
 		goto out;
 	}
@@ -1810,7 +1810,8 @@ setpte:
 	set_pte_at(vma->vm_mm, addr, pte, new_pte);
 	swap_free(entry);
 out:
-	pte_unmap_unlock(pte, ptl);
+	if (pte)
+		pte_unmap_unlock(pte, ptl);
 	if (page != swapcache) {
 		unlock_page(page);
 		put_page(page);
@@ -1822,17 +1823,22 @@ static int unuse_pte_range(struct vm_are
 			unsigned long addr, unsigned long end,
 			unsigned int type)
 {
-	swp_entry_t entry;
-	pte_t *pte;
+	pte_t *pte = NULL;
 	struct swap_info_struct *si;
-	int ret = 0;
 
 	si = swap_info[type];
-	pte = pte_offset_map(pmd, addr);
 	do {
 		struct folio *folio;
 		unsigned long offset;
 		unsigned char swp_count;
+		swp_entry_t entry;
+		int ret;
+
+		if (!pte++) {
+			pte = pte_offset_map(pmd, addr);
+			if (!pte)
+				break;
+		}
 
 		if (!is_swap_pte(*pte))
 			continue;
@@ -1843,6 +1849,8 @@ static int unuse_pte_range(struct vm_are
 
 		offset = swp_offset(entry);
 		pte_unmap(pte);
+		pte = NULL;
+
 		folio = swap_cache_get_folio(entry, vma, addr);
 		if (!folio) {
 			struct page *page;
@@ -1861,8 +1869,7 @@ static int unuse_pte_range(struct vm_are
 		if (!folio) {
 			swp_count = READ_ONCE(si->swap_map[offset]);
 			if (swp_count == 0 || swp_count == SWAP_MAP_BAD)
-				goto try_next;
-
+				continue;
 			return -ENOMEM;
 		}
 
@@ -1872,20 +1879,17 @@ static int unuse_pte_range(struct vm_are
 		if (ret < 0) {
 			folio_unlock(folio);
 			folio_put(folio);
-			goto out;
+			return ret;
 		}
 
 		folio_free_swap(folio);
 		folio_unlock(folio);
 		folio_put(folio);
-try_next:
-		pte = pte_offset_map(pmd, addr);
-	} while (pte++, addr += PAGE_SIZE, addr != end);
-	pte_unmap(pte - 1);
+	} while (addr += PAGE_SIZE, addr != end);
 
-	ret = 0;
-out:
-	return ret;
+	if (pte)
+		pte_unmap(pte);
+	return 0;
 }
 
 static inline int unuse_pmd_range(struct vm_area_struct *vma, pud_t *pud,
@@ -1900,8 +1904,6 @@ static inline int unuse_pmd_range(struct
 	do {
 		cond_resched();
 		next = pmd_addr_end(addr, end);
-		if (pmd_none_or_trans_huge_or_clear_bad(pmd))
-			continue;
 		ret = unuse_pte_range(vma, pmd, addr, next, type);
 		if (ret)
 			return ret;
_

Patches currently in -mm which might be from hughd@google.com are


