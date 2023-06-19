Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F57CEB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:23:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjFSXXE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbjFSXVv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:21:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CE31703
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:21:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E01460F3A
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:21:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FC54C433C0;
        Mon, 19 Jun 2023 23:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216895;
        bh=SwxC7uh3XpxxcUfeGauXd8eh9GoLIAyDTzl351V8Coo=;
        h=Date:To:From:Subject:From;
        b=QZThfYhSo4rDVUShFXayRSOfbmpW0GWLozoQmk6+pW7hEosEjfdi0kM7eaPisPiBo
         DINPi0qjGO5gb3JrmHShkLwQ5BijWBE2j4yvTVNJqXttiE2XblTkESkZBm6wLsItMb
         cUGvu43DAqY9o/Y1ISD/OvRbvXHGyD9LTdoJzcRc=
Date:   Mon, 19 Jun 2023 16:21:34 -0700
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
Subject: [merged mm-stable] mm-page_vma_mapped-pte_offset_map_nolock-not-pte_lockptr.patch removed from -mm tree
Message-Id: <20230619232135.7FC54C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_vma_mapped: pte_offset_map_nolock() not pte_lockptr()
has been removed from the -mm tree.  Its filename was
     mm-page_vma_mapped-pte_offset_map_nolock-not-pte_lockptr.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/page_vma_mapped: pte_offset_map_nolock() not pte_lockptr()
Date: Thu, 8 Jun 2023 18:15:43 -0700 (PDT)

map_pte() use pte_offset_map_nolock(), to make sure of the ptl belonging
to pte, even if pmd entry is then changed racily: page_vma_mapped_walk()
use that instead of getting pte_lockptr() later, or restart if map_pte()
found no page table.

Link: https://lkml.kernel.org/r/cba186e0-5ed7-e81b-6cd-dade4c33c248@google.com
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

 mm/page_vma_mapped.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

--- a/mm/page_vma_mapped.c~mm-page_vma_mapped-pte_offset_map_nolock-not-pte_lockptr
+++ a/mm/page_vma_mapped.c
@@ -13,16 +13,28 @@ static inline bool not_found(struct page
 	return false;
 }
 
-static bool map_pte(struct page_vma_mapped_walk *pvmw)
+static bool map_pte(struct page_vma_mapped_walk *pvmw, spinlock_t **ptlp)
 {
 	if (pvmw->flags & PVMW_SYNC) {
 		/* Use the stricter lookup */
 		pvmw->pte = pte_offset_map_lock(pvmw->vma->vm_mm, pvmw->pmd,
 						pvmw->address, &pvmw->ptl);
-		return true;
+		*ptlp = pvmw->ptl;
+		return !!pvmw->pte;
 	}
 
-	pvmw->pte = pte_offset_map(pvmw->pmd, pvmw->address);
+	/*
+	 * It is important to return the ptl corresponding to pte,
+	 * in case *pvmw->pmd changes underneath us; so we need to
+	 * return it even when choosing not to lock, in case caller
+	 * proceeds to loop over next ptes, and finds a match later.
+	 * Though, in most cases, page lock already protects this.
+	 */
+	pvmw->pte = pte_offset_map_nolock(pvmw->vma->vm_mm, pvmw->pmd,
+					  pvmw->address, ptlp);
+	if (!pvmw->pte)
+		return false;
+
 	if (pvmw->flags & PVMW_MIGRATION) {
 		if (!is_swap_pte(*pvmw->pte))
 			return false;
@@ -51,7 +63,7 @@ static bool map_pte(struct page_vma_mapp
 	} else if (!pte_present(*pvmw->pte)) {
 		return false;
 	}
-	pvmw->ptl = pte_lockptr(pvmw->vma->vm_mm, pvmw->pmd);
+	pvmw->ptl = *ptlp;
 	spin_lock(pvmw->ptl);
 	return true;
 }
@@ -156,6 +168,7 @@ bool page_vma_mapped_walk(struct page_vm
 	struct vm_area_struct *vma = pvmw->vma;
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long end;
+	spinlock_t *ptl;
 	pgd_t *pgd;
 	p4d_t *p4d;
 	pud_t *pud;
@@ -257,8 +270,11 @@ restart:
 			step_forward(pvmw, PMD_SIZE);
 			continue;
 		}
-		if (!map_pte(pvmw))
+		if (!map_pte(pvmw, &ptl)) {
+			if (!pvmw->pte)
+				goto restart;
 			goto next_pte;
+		}
 this_pte:
 		if (check_pte(pvmw))
 			return true;
@@ -281,7 +297,7 @@ next_pte:
 		} while (pte_none(*pvmw->pte));
 
 		if (!pvmw->ptl) {
-			pvmw->ptl = pte_lockptr(mm, pvmw->pmd);
+			pvmw->ptl = ptl;
 			spin_lock(pvmw->ptl);
 		}
 		goto this_pte;
_

Patches currently in -mm which might be from hughd@google.com are


