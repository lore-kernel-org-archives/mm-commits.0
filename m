Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCDD5246
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zx2IbBDV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9EFFC433C8;
	Mon, 11 Dec 2023 00:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256135;
	bh=v3dDG6nwzc28m6zjrKxTCehg3rpG1DG/prhfCufSv+8=;
	h=Date:To:From:Subject:From;
	b=Zx2IbBDVBdiQeY59CRwCthBYTTZp37GtiAJNQKBkAXcmAPqZFdy0mWOHAdXCSFbn7
	 +iIJQF/ZglfwuiboNsy5Y4AjFCZnaZ6AXTesNqNeQ5Wn3smgB+k+CxHVJVDcSFb5q8
	 pTADuHvkdchRAbMGhdni7VkrbVe2kJGAobaClF5k=
Date: Sun, 10 Dec 2023 16:55:35 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,mike.kravetz@oracle.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_vmemmap-move-pagevmemmapselfhosted-check-to-split_vmemmap_huge_pmd.patch removed from -mm tree
Message-Id: <20231211005535.B9EFFC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: hugetlb_vmemmap: move PageVmemmapSelfHosted() check to split_vmemmap_huge_pmd()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-move-pagevmemmapselfhosted-check-to-split_vmemmap_huge_pmd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb_vmemmap: move PageVmemmapSelfHosted() check to split_vmemmap_huge_pmd()
Date: Mon, 27 Nov 2023 16:46:44 +0800

To check a page whether it is self-hosted needs to traverse the page table
(e.g.  pmd_off_k()), however, we already have done this in the next
calling of vmemmap_remap_range().  Moving PageVmemmapSelfHosted() check to
vmemmap_pmd_entry() could simplify the code a bit.

Link: https://lkml.kernel.org/r/20231127084645.27017-4-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |   70 ++++++++++++++---------------------------
 1 file changed, 24 insertions(+), 46 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-move-pagevmemmapselfhosted-check-to-split_vmemmap_huge_pmd
+++ a/mm/hugetlb_vmemmap.c
@@ -95,6 +95,7 @@ static int vmemmap_split_pmd(pmd_t *pmd,
 static int vmemmap_pmd_entry(pmd_t *pmd, unsigned long addr,
 			     unsigned long next, struct mm_walk *walk)
 {
+	int ret = 0;
 	struct page *head;
 	struct vmemmap_remap_walk *vmemmap_walk = walk->private;
 
@@ -104,9 +105,30 @@ static int vmemmap_pmd_entry(pmd_t *pmd,
 
 	spin_lock(&init_mm.page_table_lock);
 	head = pmd_leaf(*pmd) ? pmd_page(*pmd) : NULL;
+	/*
+	 * Due to HugeTLB alignment requirements and the vmemmap
+	 * pages being at the start of the hotplugged memory
+	 * region in memory_hotplug.memmap_on_memory case. Checking
+	 * the vmemmap page associated with the first vmemmap page
+	 * if it is self-hosted is sufficient.
+	 *
+	 * [                  hotplugged memory                  ]
+	 * [        section        ][...][        section        ]
+	 * [ vmemmap ][              usable memory               ]
+	 *   ^  | ^                        |
+	 *   +--+ |                        |
+	 *        +------------------------+
+	 */
+	if (unlikely(!vmemmap_walk->nr_walked)) {
+		struct page *page = head ? head + pte_index(addr) :
+				    pte_page(ptep_get(pte_offset_kernel(pmd, addr)));
+
+		if (PageVmemmapSelfHosted(page))
+			ret = -ENOTSUPP;
+	}
 	spin_unlock(&init_mm.page_table_lock);
-	if (!head)
-		return 0;
+	if (!head || ret)
+		return ret;
 
 	return vmemmap_split_pmd(pmd, head, addr & PMD_MASK, vmemmap_walk);
 }
@@ -524,50 +546,6 @@ static bool vmemmap_should_optimize(cons
 	if (!hugetlb_vmemmap_optimizable(h))
 		return false;
 
-	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG)) {
-		pmd_t *pmdp, pmd;
-		struct page *vmemmap_page;
-		unsigned long vaddr = (unsigned long)head;
-
-		/*
-		 * Only the vmemmap page's vmemmap page can be self-hosted.
-		 * Walking the page tables to find the backing page of the
-		 * vmemmap page.
-		 */
-		pmdp = pmd_off_k(vaddr);
-		/*
-		 * The READ_ONCE() is used to stabilize *pmdp in a register or
-		 * on the stack so that it will stop changing under the code.
-		 * The only concurrent operation where it can be changed is
-		 * split_vmemmap_huge_pmd() (*pmdp will be stable after this
-		 * operation).
-		 */
-		pmd = READ_ONCE(*pmdp);
-		if (pmd_leaf(pmd))
-			vmemmap_page = pmd_page(pmd) + pte_index(vaddr);
-		else
-			vmemmap_page = pte_page(*pte_offset_kernel(pmdp, vaddr));
-		/*
-		 * Due to HugeTLB alignment requirements and the vmemmap pages
-		 * being at the start of the hotplugged memory region in
-		 * memory_hotplug.memmap_on_memory case. Checking any vmemmap
-		 * page's vmemmap page if it is marked as VmemmapSelfHosted is
-		 * sufficient.
-		 *
-		 * [                  hotplugged memory                  ]
-		 * [        section        ][...][        section        ]
-		 * [ vmemmap ][              usable memory               ]
-		 *   ^   |     |                                        |
-		 *   +---+     |                                        |
-		 *     ^       |                                        |
-		 *     +-------+                                        |
-		 *          ^                                           |
-		 *          +-------------------------------------------+
-		 */
-		if (PageVmemmapSelfHosted(vmemmap_page))
-			return false;
-	}
-
 	return true;
 }
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb_vmemmap-add-check-of-config_memory_hotplug-back.patch
mm-hugetlb_vmemmap-move-mmap-lock-to-vmemmap_remap_range.patch

