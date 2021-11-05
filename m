Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF9B5C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:38:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94F0561279
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:38:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233293AbhKEUlW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:41:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:36132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232810AbhKEUlW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:41:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F059E611C4;
        Fri,  5 Nov 2021 20:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144722;
        bh=S4N4QLiF/9emJ6Vh5KF8q2lQz32gWn0CCQ7ZowG4u8g=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=XP9MhSCsqUP4fC62Sid088hIskoH1zYJKj+Q1SKkyShMWBc82rdoAN4GYYitIS3SV
         v5BZrZOLbLeeNUMwFuKXIc9/jL3F3VFBiTPqIbra+7aJWlyYxC31vqjkqmHIEVwMwO
         1wQiSb7hb+pGtfXXv1wHFQOHZw3Znj2Mq4JEXjDk=
Date:   Fri, 05 Nov 2021 13:38:41 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, hannes@cmpxchg.org,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mhocko@kernel.org, mika.penttila@nextfour.com,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz,
        vdavydov.dev@gmail.com, zhengqi.arch@bytedance.com
Subject:  [patch 077/262] mm: remove redundant smp_wmb()
Message-ID: <20211105203841.NJQh4O_0B%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: remove redundant smp_wmb()

The smp_wmb() which is in the __pte_alloc() is used to ensure all ptes
setup is visible before the pte is made visible to other CPUs by being put
into page tables.  We only need this when the pte is actually populated,
so move it to pmd_install().  __pte_alloc_kernel(), __p4d_alloc(),
__pud_alloc() and __pmd_alloc() are similar to this case.

We can also defer smp_wmb() to the place where the pmd entry is really
populated by preallocated pte.  There are two kinds of user of
preallocated pte, one is filemap & finish_fault(), another is THP.  The
former does not need another smp_wmb() because the smp_wmb() has been done
by pmd_install().  Fortunately, the latter also does not need another
smp_wmb() because there is already a smp_wmb() before populating the new
pte when the THP uses a preallocated pte to split a huge pmd.

Link: https://lkml.kernel.org/r/20210901102722.47686-3-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mika Penttila <mika.penttila@nextfour.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c         |   52 ++++++++++++++++++------------------------
 mm/sparse-vmemmap.c |    2 -
 2 files changed, 24 insertions(+), 30 deletions(-)

--- a/mm/memory.c~mm-remove-redundant-smp_wmb
+++ a/mm/memory.c
@@ -443,6 +443,20 @@ void pmd_install(struct mm_struct *mm, p
 
 	if (likely(pmd_none(*pmd))) {	/* Has another populated it ? */
 		mm_inc_nr_ptes(mm);
+		/*
+		 * Ensure all pte setup (eg. pte page lock and page clearing) are
+		 * visible before the pte is made visible to other CPUs by being
+		 * put into page tables.
+		 *
+		 * The other side of the story is the pointer chasing in the page
+		 * table walking code (when walking the page table without locking;
+		 * ie. most of the time). Fortunately, these data accesses consist
+		 * of a chain of data-dependent loads, meaning most CPUs (alpha
+		 * being the notable exception) will already guarantee loads are
+		 * seen in-order. See the alpha page table accessors for the
+		 * smp_rmb() barriers in page table walking code.
+		 */
+		smp_wmb(); /* Could be smp_wmb__xxx(before|after)_spin_lock */
 		pmd_populate(mm, pmd, *pte);
 		*pte = NULL;
 	}
@@ -455,21 +469,6 @@ int __pte_alloc(struct mm_struct *mm, pm
 	if (!new)
 		return -ENOMEM;
 
-	/*
-	 * Ensure all pte setup (eg. pte page lock and page clearing) are
-	 * visible before the pte is made visible to other CPUs by being
-	 * put into page tables.
-	 *
-	 * The other side of the story is the pointer chasing in the page
-	 * table walking code (when walking the page table without locking;
-	 * ie. most of the time). Fortunately, these data accesses consist
-	 * of a chain of data-dependent loads, meaning most CPUs (alpha
-	 * being the notable exception) will already guarantee loads are
-	 * seen in-order. See the alpha page table accessors for the
-	 * smp_rmb() barriers in page table walking code.
-	 */
-	smp_wmb(); /* Could be smp_wmb__xxx(before|after)_spin_lock */
-
 	pmd_install(mm, pmd, &new);
 	if (new)
 		pte_free(mm, new);
@@ -482,10 +481,9 @@ int __pte_alloc_kernel(pmd_t *pmd)
 	if (!new)
 		return -ENOMEM;
 
-	smp_wmb(); /* See comment in __pte_alloc */
-
 	spin_lock(&init_mm.page_table_lock);
 	if (likely(pmd_none(*pmd))) {	/* Has another populated it ? */
+		smp_wmb(); /* See comment in pmd_install() */
 		pmd_populate_kernel(&init_mm, pmd, new);
 		new = NULL;
 	}
@@ -3849,7 +3847,6 @@ static vm_fault_t __do_fault(struct vm_f
 		vmf->prealloc_pte = pte_alloc_one(vma->vm_mm);
 		if (!vmf->prealloc_pte)
 			return VM_FAULT_OOM;
-		smp_wmb(); /* See comment in __pte_alloc() */
 	}
 
 	ret = vma->vm_ops->fault(vmf);
@@ -3920,7 +3917,6 @@ vm_fault_t do_set_pmd(struct vm_fault *v
 		vmf->prealloc_pte = pte_alloc_one(vma->vm_mm);
 		if (!vmf->prealloc_pte)
 			return VM_FAULT_OOM;
-		smp_wmb(); /* See comment in __pte_alloc() */
 	}
 
 	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
@@ -4145,7 +4141,6 @@ static vm_fault_t do_fault_around(struct
 		vmf->prealloc_pte = pte_alloc_one(vmf->vma->vm_mm);
 		if (!vmf->prealloc_pte)
 			return VM_FAULT_OOM;
-		smp_wmb(); /* See comment in __pte_alloc() */
 	}
 
 	return vmf->vma->vm_ops->map_pages(vmf, start_pgoff, end_pgoff);
@@ -4819,13 +4814,13 @@ int __p4d_alloc(struct mm_struct *mm, pg
 	if (!new)
 		return -ENOMEM;
 
-	smp_wmb(); /* See comment in __pte_alloc */
-
 	spin_lock(&mm->page_table_lock);
-	if (pgd_present(*pgd))		/* Another has populated it */
+	if (pgd_present(*pgd)) {	/* Another has populated it */
 		p4d_free(mm, new);
-	else
+	} else {
+		smp_wmb(); /* See comment in pmd_install() */
 		pgd_populate(mm, pgd, new);
+	}
 	spin_unlock(&mm->page_table_lock);
 	return 0;
 }
@@ -4842,11 +4837,10 @@ int __pud_alloc(struct mm_struct *mm, p4
 	if (!new)
 		return -ENOMEM;
 
-	smp_wmb(); /* See comment in __pte_alloc */
-
 	spin_lock(&mm->page_table_lock);
 	if (!p4d_present(*p4d)) {
 		mm_inc_nr_puds(mm);
+		smp_wmb(); /* See comment in pmd_install() */
 		p4d_populate(mm, p4d, new);
 	} else	/* Another has populated it */
 		pud_free(mm, new);
@@ -4867,14 +4861,14 @@ int __pmd_alloc(struct mm_struct *mm, pu
 	if (!new)
 		return -ENOMEM;
 
-	smp_wmb(); /* See comment in __pte_alloc */
-
 	ptl = pud_lock(mm, pud);
 	if (!pud_present(*pud)) {
 		mm_inc_nr_pmds(mm);
+		smp_wmb(); /* See comment in pmd_install() */
 		pud_populate(mm, pud, new);
-	} else	/* Another has populated it */
+	} else {	/* Another has populated it */
 		pmd_free(mm, new);
+	}
 	spin_unlock(ptl);
 	return 0;
 }
--- a/mm/sparse-vmemmap.c~mm-remove-redundant-smp_wmb
+++ a/mm/sparse-vmemmap.c
@@ -76,7 +76,7 @@ static int split_vmemmap_huge_pmd(pmd_t
 		set_pte_at(&init_mm, addr, pte, entry);
 	}
 
-	/* Make pte visible before pmd. See comment in __pte_alloc(). */
+	/* Make pte visible before pmd. See comment in pmd_install(). */
 	smp_wmb();
 	pmd_populate_kernel(&init_mm, pmd, pgtable);
 
_
