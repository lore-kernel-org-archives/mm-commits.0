Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82F80C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 16 Sep 2021 03:41:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66941611CA
	for <mm-commits@archiver.kernel.org>; Thu, 16 Sep 2021 03:41:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234178AbhIPDm3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Sep 2021 23:42:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:50564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233630AbhIPDm2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Sep 2021 23:42:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFC2360F50;
        Thu, 16 Sep 2021 03:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631763669;
        bh=Jk1XOYx3xPwYlINmcSnAhrtL7BQRsTZlM0reRDMn3c4=;
        h=Date:From:To:Subject:From;
        b=VAK+J8x2J2/uCmQ+RRbqSdyC7Up7xA88gsCBnTu2/Zhihqo7ONC6wc7zIiffaAnWc
         MvdpqaeGFJkzYpozXNWyKaXxH8RCnBzkFQ8S3yOFFiZfxw/f8pkKp6bukUrelClbDk
         02cCPce+0B+cbWaHWXMCK5KdttY5yxTt/bFkNmw8=
Date:   Wed, 15 Sep 2021 20:41:08 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, hannes@cmpxchg.org,
        kirill.shutemov@linux.intel.com, mhocko@kernel.org,
        mika.penttila@nextfour.com, mm-commits@vger.kernel.org,
        songmuchun@bytedance.com, tglx@linutronix.de, vbabka@suse.cz,
        vdavydov.dev@gmail.com, zhengqi.arch@bytedance.com
Subject:  + mm-remove-redundant-smp_wmb.patch added to -mm tree
Message-ID: <20210916034108.8tDgcg_8q%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove redundant smp_wmb()
has been added to the -mm tree.  Its filename is
     mm-remove-redundant-smp_wmb.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-redundant-smp_wmb.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-redundant-smp_wmb.patch

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
@@ -439,6 +439,20 @@ void pmd_install(struct mm_struct *mm, p
 
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
@@ -451,21 +465,6 @@ int __pte_alloc(struct mm_struct *mm, pm
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
@@ -478,10 +477,9 @@ int __pte_alloc_kernel(pmd_t *pmd)
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
@@ -3844,7 +3842,6 @@ static vm_fault_t __do_fault(struct vm_f
 		vmf->prealloc_pte = pte_alloc_one(vma->vm_mm);
 		if (!vmf->prealloc_pte)
 			return VM_FAULT_OOM;
-		smp_wmb(); /* See comment in __pte_alloc() */
 	}
 
 	ret = vma->vm_ops->fault(vmf);
@@ -3906,7 +3903,6 @@ vm_fault_t do_set_pmd(struct vm_fault *v
 		vmf->prealloc_pte = pte_alloc_one(vma->vm_mm);
 		if (!vmf->prealloc_pte)
 			return VM_FAULT_OOM;
-		smp_wmb(); /* See comment in __pte_alloc() */
 	}
 
 	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
@@ -4131,7 +4127,6 @@ static vm_fault_t do_fault_around(struct
 		vmf->prealloc_pte = pte_alloc_one(vmf->vma->vm_mm);
 		if (!vmf->prealloc_pte)
 			return VM_FAULT_OOM;
-		smp_wmb(); /* See comment in __pte_alloc() */
 	}
 
 	return vmf->vma->vm_ops->map_pages(vmf, start_pgoff, end_pgoff);
@@ -4805,13 +4800,13 @@ int __p4d_alloc(struct mm_struct *mm, pg
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
@@ -4828,11 +4823,10 @@ int __pud_alloc(struct mm_struct *mm, p4
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
@@ -4853,14 +4847,14 @@ int __pmd_alloc(struct mm_struct *mm, pu
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

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-introduce-pmd_install-helper.patch
mm-remove-redundant-smp_wmb.patch

