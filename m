Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41D06C4167B
	for <mm-commits@archiver.kernel.org>; Mon, 27 Nov 2023 17:21:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjK0RVf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Nov 2023 12:21:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjK0RVc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Nov 2023 12:21:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA080E1
        for <mm-commits@vger.kernel.org>; Mon, 27 Nov 2023 09:21:38 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63DC2C433C8;
        Mon, 27 Nov 2023 17:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701105698;
        bh=r82DCYYUeQtJIRmT/NbXn7qFGEI15idbARTEny3w7xs=;
        h=Date:To:From:Subject:From;
        b=H42kTO3Jx+ld8BkE2/lqrEi7UrRMhmunSvIAqEb9DRW8ZPa1DKoXZaNSRrD78Gzxj
         YCo9sU8zCUl/+KV+aODvAQtig0eT0chO0Q+jqwYnVnSNl4aJn/ue0Bg2g8PrwFbz44
         mXF3ta/OnFW7lQRFLkFjQ18Sil7FKEvMM4tb3KMc=
Date:   Mon, 27 Nov 2023 09:21:37 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-use-walk_page_range_novma-to-simplify-the-code.patch added to mm-unstable branch
Message-Id: <20231127172138.63DC2C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb_vmemmap: use walk_page_range_novma() to simplify the code
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-use-walk_page_range_novma-to-simplify-the-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-use-walk_page_range_novma-to-simplify-the-code.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb_vmemmap: use walk_page_range_novma() to simplify the code
Date: Mon, 27 Nov 2023 16:46:43 +0800

It is unnecessary to implement a series of dedicated page table walking
helpers since there is already a general one walk_page_range_novma().  So
use it to simplify the code.

Link: https://lkml.kernel.org/r/20231127084645.27017-3-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |  148 ++++++++++-------------------------------
 1 file changed, 39 insertions(+), 109 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-use-walk_page_range_novma-to-simplify-the-code
+++ a/mm/hugetlb_vmemmap.c
@@ -14,6 +14,7 @@
 #include <linux/moduleparam.h>
 #include <linux/bootmem_info.h>
 #include <linux/mmdebug.h>
+#include <linux/pagewalk.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include "hugetlb_vmemmap.h"
@@ -45,21 +46,14 @@ struct vmemmap_remap_walk {
 	unsigned long		flags;
 };
 
-static int split_vmemmap_huge_pmd(pmd_t *pmd, unsigned long start, bool flush)
+static int vmemmap_split_pmd(pmd_t *pmd, struct page *head, unsigned long start,
+			     struct vmemmap_remap_walk *walk)
 {
 	pmd_t __pmd;
 	int i;
 	unsigned long addr = start;
-	struct page *head;
 	pte_t *pgtable;
 
-	spin_lock(&init_mm.page_table_lock);
-	head = pmd_leaf(*pmd) ? pmd_page(*pmd) : NULL;
-	spin_unlock(&init_mm.page_table_lock);
-
-	if (!head)
-		return 0;
-
 	pgtable = pte_alloc_one_kernel(&init_mm);
 	if (!pgtable)
 		return -ENOMEM;
@@ -88,7 +82,7 @@ static int split_vmemmap_huge_pmd(pmd_t
 		/* Make pte visible before pmd. See comment in pmd_install(). */
 		smp_wmb();
 		pmd_populate_kernel(&init_mm, pmd, pgtable);
-		if (flush)
+		if (!(walk->flags & VMEMMAP_SPLIT_NO_TLB_FLUSH))
 			flush_tlb_kernel_range(start, start + PMD_SIZE);
 	} else {
 		pte_free_kernel(&init_mm, pgtable);
@@ -98,123 +92,59 @@ static int split_vmemmap_huge_pmd(pmd_t
 	return 0;
 }
 
-static void vmemmap_pte_range(pmd_t *pmd, unsigned long addr,
-			      unsigned long end,
-			      struct vmemmap_remap_walk *walk)
-{
-	pte_t *pte = pte_offset_kernel(pmd, addr);
-
-	/*
-	 * The reuse_page is found 'first' in table walk before we start
-	 * remapping (which is calling @walk->remap_pte).
-	 */
-	if (!walk->reuse_page) {
-		walk->reuse_page = pte_page(ptep_get(pte));
-		/*
-		 * Because the reuse address is part of the range that we are
-		 * walking, skip the reuse address range.
-		 */
-		addr += PAGE_SIZE;
-		pte++;
-		walk->nr_walked++;
-	}
-
-	for (; addr != end; addr += PAGE_SIZE, pte++) {
-		walk->remap_pte(pte, addr, walk);
-		walk->nr_walked++;
-	}
-}
-
-static int vmemmap_pmd_range(pud_t *pud, unsigned long addr,
-			     unsigned long end,
-			     struct vmemmap_remap_walk *walk)
+static int vmemmap_pmd_entry(pmd_t *pmd, unsigned long addr,
+			     unsigned long next, struct mm_walk *walk)
 {
-	pmd_t *pmd;
-	unsigned long next;
-
-	pmd = pmd_offset(pud, addr);
-	do {
-		int ret;
-
-		ret = split_vmemmap_huge_pmd(pmd, addr & PMD_MASK,
-				!(walk->flags & VMEMMAP_SPLIT_NO_TLB_FLUSH));
-		if (ret)
-			return ret;
-
-		next = pmd_addr_end(addr, end);
+	struct page *head;
+	struct vmemmap_remap_walk *vmemmap_walk = walk->private;
 
-		/*
-		 * We are only splitting, not remapping the hugetlb vmemmap
-		 * pages.
-		 */
-		if (!walk->remap_pte)
-			continue;
+	/* Only splitting, not remapping the vmemmap pages. */
+	if (!vmemmap_walk->remap_pte)
+		walk->action = ACTION_CONTINUE;
 
-		vmemmap_pte_range(pmd, addr, next, walk);
-	} while (pmd++, addr = next, addr != end);
+	spin_lock(&init_mm.page_table_lock);
+	head = pmd_leaf(*pmd) ? pmd_page(*pmd) : NULL;
+	spin_unlock(&init_mm.page_table_lock);
+	if (!head)
+		return 0;
 
-	return 0;
+	return vmemmap_split_pmd(pmd, head, addr & PMD_MASK, vmemmap_walk);
 }
 
-static int vmemmap_pud_range(p4d_t *p4d, unsigned long addr,
-			     unsigned long end,
-			     struct vmemmap_remap_walk *walk)
+static int vmemmap_pte_entry(pte_t *pte, unsigned long addr,
+			     unsigned long next, struct mm_walk *walk)
 {
-	pud_t *pud;
-	unsigned long next;
+	struct vmemmap_remap_walk *vmemmap_walk = walk->private;
 
-	pud = pud_offset(p4d, addr);
-	do {
-		int ret;
-
-		next = pud_addr_end(addr, end);
-		ret = vmemmap_pmd_range(pud, addr, next, walk);
-		if (ret)
-			return ret;
-	} while (pud++, addr = next, addr != end);
+	/*
+	 * The reuse_page is found 'first' in page table walking before
+	 * starting remapping.
+	 */
+	if (!vmemmap_walk->reuse_page)
+		vmemmap_walk->reuse_page = pte_page(ptep_get(pte));
+	else
+		vmemmap_walk->remap_pte(pte, addr, vmemmap_walk);
+	vmemmap_walk->nr_walked++;
 
 	return 0;
 }
 
-static int vmemmap_p4d_range(pgd_t *pgd, unsigned long addr,
-			     unsigned long end,
-			     struct vmemmap_remap_walk *walk)
-{
-	p4d_t *p4d;
-	unsigned long next;
-
-	p4d = p4d_offset(pgd, addr);
-	do {
-		int ret;
-
-		next = p4d_addr_end(addr, end);
-		ret = vmemmap_pud_range(p4d, addr, next, walk);
-		if (ret)
-			return ret;
-	} while (p4d++, addr = next, addr != end);
-
-	return 0;
-}
+static const struct mm_walk_ops vmemmap_remap_ops = {
+	.pmd_entry	= vmemmap_pmd_entry,
+	.pte_entry	= vmemmap_pte_entry,
+};
 
 static int vmemmap_remap_range(unsigned long start, unsigned long end,
 			       struct vmemmap_remap_walk *walk)
 {
-	unsigned long addr = start;
-	unsigned long next;
-	pgd_t *pgd;
+	int ret;
 
-	VM_BUG_ON(!PAGE_ALIGNED(start));
-	VM_BUG_ON(!PAGE_ALIGNED(end));
+	VM_BUG_ON(!PAGE_ALIGNED(start | end));
 
-	pgd = pgd_offset_k(addr);
-	do {
-		int ret;
-
-		next = pgd_addr_end(addr, end);
-		ret = vmemmap_p4d_range(pgd, addr, next, walk);
-		if (ret)
-			return ret;
-	} while (pgd++, addr = next, addr != end);
+	ret = walk_page_range_novma(&init_mm, start, end, &vmemmap_remap_ops,
+				    NULL, walk);
+	if (ret)
+		return ret;
 
 	if (walk->remap_pte && !(walk->flags & VMEMMAP_REMAP_NO_TLB_FLUSH))
 		flush_tlb_kernel_range(start, end);
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-pagewalk-assert-write-mmap-lock-only-for-walking-the-user-page-tables.patch
mm-hugetlb_vmemmap-use-walk_page_range_novma-to-simplify-the-code.patch
mm-hugetlb_vmemmap-move-pagevmemmapselfhosted-check-to-split_vmemmap_huge_pmd.patch
mm-hugetlb_vmemmap-convert-page-to-folio.patch

