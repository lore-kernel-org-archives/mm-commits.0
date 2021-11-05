Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D150C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:38:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3815061279
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:38:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbhKEUlT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:41:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233293AbhKEUlT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:41:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B011C6056B;
        Fri,  5 Nov 2021 20:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144719;
        bh=TO7fQlFAUIMUtuvraGiofhQAac+hReuX+JTU+yDcl9Q=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=af2C+O++JVJl5mi5WysOFszD3BcxsWyGnEsovuUNXlogqS6c5Idtf4/ZVKBa8lG+x
         guMFeDs7Skw3nVTlO5uk8zkQ5gR7tJYQ4bcSFw3/N4UCqcQcTPa0MJIh3Q6ndq8qJL
         N+BX83gmPECzSUvdCHLZP0DJUrElfFSb8pzgX5p0=
Date:   Fri, 05 Nov 2021 13:38:38 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, hannes@cmpxchg.org,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mhocko@kernel.org, mika.penttila@nextfour.com,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz,
        vdavydov.dev@gmail.com, zhengqi.arch@bytedance.com
Subject:  [patch 076/262] mm: introduce pmd_install() helper
Message-ID: <20211105203838.xYsnl2UZw%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: introduce pmd_install() helper

Patch series "Do some code cleanups related to mm", v3.


This patch (of 2):

Currently we have three times the same few lines repeated in the code. 
Deduplicate them by newly introduced pmd_install() helper.

Link: https://lkml.kernel.org/r/20210901102722.47686-1-zhengqi.arch@bytedance.com
Link: https://lkml.kernel.org/r/20210901102722.47686-2-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Mika Penttila <mika.penttila@nextfour.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c  |   11 ++---------
 mm/internal.h |    1 +
 mm/memory.c   |   34 ++++++++++++++++------------------
 3 files changed, 19 insertions(+), 27 deletions(-)

--- a/mm/filemap.c~mm-introduce-pmd_install-helper
+++ a/mm/filemap.c
@@ -3211,15 +3211,8 @@ static bool filemap_map_pmd(struct vm_fa
 	    }
 	}
 
-	if (pmd_none(*vmf->pmd)) {
-		vmf->ptl = pmd_lock(mm, vmf->pmd);
-		if (likely(pmd_none(*vmf->pmd))) {
-			mm_inc_nr_ptes(mm);
-			pmd_populate(mm, vmf->pmd, vmf->prealloc_pte);
-			vmf->prealloc_pte = NULL;
-		}
-		spin_unlock(vmf->ptl);
-	}
+	if (pmd_none(*vmf->pmd))
+		pmd_install(mm, vmf->pmd, &vmf->prealloc_pte);
 
 	/* See comment in handle_pte_fault() */
 	if (pmd_devmap_trans_unstable(vmf->pmd)) {
--- a/mm/internal.h~mm-introduce-pmd_install-helper
+++ a/mm/internal.h
@@ -38,6 +38,7 @@ vm_fault_t do_swap_page(struct vm_fault
 
 void free_pgtables(struct mmu_gather *tlb, struct vm_area_struct *start_vma,
 		unsigned long floor, unsigned long ceiling);
+void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
 
 static inline bool can_madv_lru_vma(struct vm_area_struct *vma)
 {
--- a/mm/memory.c~mm-introduce-pmd_install-helper
+++ a/mm/memory.c
@@ -437,9 +437,20 @@ void free_pgtables(struct mmu_gather *tl
 	}
 }
 
+void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte)
+{
+	spinlock_t *ptl = pmd_lock(mm, pmd);
+
+	if (likely(pmd_none(*pmd))) {	/* Has another populated it ? */
+		mm_inc_nr_ptes(mm);
+		pmd_populate(mm, pmd, *pte);
+		*pte = NULL;
+	}
+	spin_unlock(ptl);
+}
+
 int __pte_alloc(struct mm_struct *mm, pmd_t *pmd)
 {
-	spinlock_t *ptl;
 	pgtable_t new = pte_alloc_one(mm);
 	if (!new)
 		return -ENOMEM;
@@ -459,13 +470,7 @@ int __pte_alloc(struct mm_struct *mm, pm
 	 */
 	smp_wmb(); /* Could be smp_wmb__xxx(before|after)_spin_lock */
 
-	ptl = pmd_lock(mm, pmd);
-	if (likely(pmd_none(*pmd))) {	/* Has another populated it ? */
-		mm_inc_nr_ptes(mm);
-		pmd_populate(mm, pmd, new);
-		new = NULL;
-	}
-	spin_unlock(ptl);
+	pmd_install(mm, pmd, &new);
 	if (new)
 		pte_free(mm, new);
 	return 0;
@@ -4028,17 +4033,10 @@ vm_fault_t finish_fault(struct vm_fault
 				return ret;
 		}
 
-		if (vmf->prealloc_pte) {
-			vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
-			if (likely(pmd_none(*vmf->pmd))) {
-				mm_inc_nr_ptes(vma->vm_mm);
-				pmd_populate(vma->vm_mm, vmf->pmd, vmf->prealloc_pte);
-				vmf->prealloc_pte = NULL;
-			}
-			spin_unlock(vmf->ptl);
-		} else if (unlikely(pte_alloc(vma->vm_mm, vmf->pmd))) {
+		if (vmf->prealloc_pte)
+			pmd_install(vma->vm_mm, vmf->pmd, &vmf->prealloc_pte);
+		else if (unlikely(pte_alloc(vma->vm_mm, vmf->pmd)))
 			return VM_FAULT_OOM;
-		}
 	}
 
 	/* See comment in handle_pte_fault() */
_
