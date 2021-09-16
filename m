Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9812C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 16 Sep 2021 03:41:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3453611CA
	for <mm-commits@archiver.kernel.org>; Thu, 16 Sep 2021 03:41:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234177AbhIPDm0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Sep 2021 23:42:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:50518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233630AbhIPDm0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Sep 2021 23:42:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 063D760462;
        Thu, 16 Sep 2021 03:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631763666;
        bh=lMa+P+b4I+zAvVA20HkwoOtnrTudvjTB3Q/Ap6o+NxA=;
        h=Date:From:To:Subject:From;
        b=j3ATIirdcSzTIkFqO2krWDRdehNrlx2eKYN4EEdV/cR2257e1YwFsEe08zgQczNCq
         Bma/R7G7z43+S0qTIhFhTkMgNJfh1F5dmLt3f2lZH23QVDHwLeVPtZD7dGDKKjXakU
         McQTnjGchrzF6136CtJArY9CsWL9snla/GYpcFPs=
Date:   Wed, 15 Sep 2021 20:41:05 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, hannes@cmpxchg.org,
        kirill.shutemov@linux.intel.com, mhocko@kernel.org,
        mika.penttila@nextfour.com, mm-commits@vger.kernel.org,
        songmuchun@bytedance.com, tglx@linutronix.de, vbabka@suse.cz,
        vdavydov.dev@gmail.com, zhengqi.arch@bytedance.com
Subject:  + mm-introduce-pmd_install-helper.patch added to -mm tree
Message-ID: <20210916034105.hWTlfg6KV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce pmd_install() helper
has been added to the -mm tree.  Its filename is
     mm-introduce-pmd_install-helper.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-pmd_install-helper.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-pmd_install-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -3210,15 +3210,8 @@ static bool filemap_map_pmd(struct vm_fa
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
@@ -433,9 +433,20 @@ void free_pgtables(struct mmu_gather *tl
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
@@ -455,13 +466,7 @@ int __pte_alloc(struct mm_struct *mm, pm
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
@@ -4014,17 +4019,10 @@ vm_fault_t finish_fault(struct vm_fault
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

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-introduce-pmd_install-helper.patch
mm-remove-redundant-smp_wmb.patch

