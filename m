Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5410E5246
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kYoXcA7j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC38C433C8;
	Mon, 11 Dec 2023 00:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256134;
	bh=sVH3WsHxwQvjQQVYNDPNKhi2EjoHq1K4+w8b/QVoxuM=;
	h=Date:To:From:Subject:From;
	b=kYoXcA7j5Fhk/ZsZ6i53CKg62jJ49LEjljLmkGsAYBm+tGeo0hBAwuLRmvdm+7Jf6
	 eXJW1ao9/gUpd5OHusNUp383XWBWoG8BCzEe/QTyVgQTov8oSH5TXTjz8lvEWLkSDe
	 ZQ8Ke6B/m1hMVBzhPR3VZLCh7exm1RWAFW5Caa2w=
Date: Sun, 10 Dec 2023 16:55:33 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,mike.kravetz@oracle.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_vmemmap-use-walk_page_range_novma-to-simplify-the-code.patch removed from -mm tree
Message-Id: <20231211005534.1DC38C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: hugetlb_vmemmap: use walk_page_range_novma() to simplify the code
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-use-walk_page_range_novma-to-simplify-the-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb_vmemmap: use walk_page_range_novma() to simplify the code
Date: Mon, 27 Nov 2023 16:46:43 +0800

It is unnecessary to implement a series of dedicated page table walking
helpers since there is already a general one walk_page_range_novma().  So
use it to simplify the code.

Link: https://lkml.kernel.org/r/20231127084645.27017-3-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
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

mm-hugetlb_vmemmap-add-check-of-config_memory_hotplug-back.patch
mm-hugetlb_vmemmap-move-mmap-lock-to-vmemmap_remap_range.patch

