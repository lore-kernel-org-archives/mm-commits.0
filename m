Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF728C0755A
	for <mm-commits@archiver.kernel.org>; Mon, 27 Nov 2023 17:21:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbjK0RVg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Nov 2023 12:21:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjK0RVe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Nov 2023 12:21:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E5B189
        for <mm-commits@vger.kernel.org>; Mon, 27 Nov 2023 09:21:40 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32BA2C433C9;
        Mon, 27 Nov 2023 17:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701105700;
        bh=1pEnBqiB8wx1oKQkKPk7ZSWU18ZRcXJ78aCTKJFpKXU=;
        h=Date:To:From:Subject:From;
        b=qW7t3hMIBqyYagaSD+cbML6+iZJP7+WsHNwLlROeIFqhtWbXJZGHoJo2Uaq5i+q2z
         vq02DiWB1R6q2SdixPApvYK6uGMGAxzGwjqZ0NqdL4e7/ftD1uPt3dmWsn8E8PJc64
         R8g833QBn7nXz++lmneR0kLmF8GnBfkJSFTgpgCI=
Date:   Mon, 27 Nov 2023 09:21:39 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-move-pagevmemmapselfhosted-check-to-split_vmemmap_huge_pmd.patch added to mm-unstable branch
Message-Id: <20231127172140.32BA2C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb_vmemmap: move PageVmemmapSelfHosted() check to split_vmemmap_huge_pmd()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-move-pagevmemmapselfhosted-check-to-split_vmemmap_huge_pmd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-move-pagevmemmapselfhosted-check-to-split_vmemmap_huge_pmd.patch

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
Subject: mm: hugetlb_vmemmap: move PageVmemmapSelfHosted() check to split_vmemmap_huge_pmd()
Date: Mon, 27 Nov 2023 16:46:44 +0800

To check a page whether it is self-hosted needs to traverse the page table
(e.g.  pmd_off_k()), however, we already have done this in the next
calling of vmemmap_remap_range().  Moving PageVmemmapSelfHosted() check to
vmemmap_pmd_entry() could simplify the code a bit.

Link: https://lkml.kernel.org/r/20231127084645.27017-4-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
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

mm-pagewalk-assert-write-mmap-lock-only-for-walking-the-user-page-tables.patch
mm-hugetlb_vmemmap-use-walk_page_range_novma-to-simplify-the-code.patch
mm-hugetlb_vmemmap-move-pagevmemmapselfhosted-check-to-split_vmemmap_huge_pmd.patch
mm-hugetlb_vmemmap-convert-page-to-folio.patch

