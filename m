Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31FA2C4321E
	for <mm-commits@archiver.kernel.org>; Wed, 30 Nov 2022 23:44:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbiK3Xon (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 18:44:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiK3Xon (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 18:44:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46BCA5FBE
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 15:44:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBC3BB81D59
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 23:44:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A40C43470;
        Wed, 30 Nov 2022 23:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669851877;
        bh=WoE5vPWDLyQx7NpsozgEyzhf7mLM8PFMRfj/2ub1Ayc=;
        h=Date:To:From:Subject:From;
        b=COKZWer9ywqkmM0AnNtuR1gmhTDUDk/9KfjaTtCqA6KQpdQlcLv9RvZ+anfhOTDN6
         pOIlSvcYnH+4zKiGEvuC2M7ylx8iJ2Wlu3Qux6oe0Gj95FXJePff2gN1rOBqFFGOQ8
         wZ/Uab4I9jpYm/lC3ke0PvmceJKn78Ai6aeqEoFA=
Date:   Wed, 30 Nov 2022 15:44:36 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, joao.m.martins@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hugetlb_vmemmap-remap-head-page-to-newly-allocated-page-v3.patch removed from -mm tree
Message-Id: <20221130234437.91A40C43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-hugetlb_vmemmap-remap-head-page-to-newly-allocated-page-v3
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-remap-head-page-to-newly-allocated-page-v3.patch

This patch was dropped because it was folded into mm-hugetlb_vmemmap-remap-head-page-to-newly-allocated-page.patch

------------------------------------------------------
From: Joao Martins <joao.m.martins@oracle.com>
Subject: mm-hugetlb_vmemmap-remap-head-page-to-newly-allocated-page-v3
Date: Wed, 9 Nov 2022 20:06:23 +0000

 Comments from Muchun:
 * Delete the comment above the tlb flush
 * Move the head vmemmap page copy into vmemmap_remap_free()
 * Add and del the new head page to the vmemmap_pages (to be freed
   in case of error)
 * Move the remap of the head like the tail pages in vmemmap_remap_pte()
   but special casing only when addr == reuse_Addr
 * Removes the PAGE_SIZE alignment check as the code has the assumption
   that start/end are page-aligned (and VM_BUG_ON otherwise).
 * Adjusted commit message taking the above changes into account.

Link: https://lkml.kernel.org/r/20221109200623.96867-1-joao.m.martins@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |   55 +++++++++++------------------------------
 1 file changed, 15 insertions(+), 40 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-remap-head-page-to-newly-allocated-page-v3
+++ a/mm/hugetlb_vmemmap.c
@@ -22,7 +22,6 @@
  *
  * @remap_pte:		called for each lowest-level entry (PTE).
  * @nr_walked:		the number of walked pte.
- * @head_page:		the page which replaces the head vmemmap page.
  * @reuse_page:		the page which is reused for the tail vmemmap pages.
  * @reuse_addr:		the virtual address of the @reuse_page page.
  * @vmemmap_pages:	the list head of the vmemmap pages that can be freed
@@ -32,7 +31,6 @@ struct vmemmap_remap_walk {
 	void			(*remap_pte)(pte_t *pte, unsigned long addr,
 					     struct vmemmap_remap_walk *walk);
 	unsigned long		nr_walked;
-	struct page		*head_page;
 	struct page		*reuse_page;
 	unsigned long		reuse_addr;
 	struct list_head	*vmemmap_pages;
@@ -107,26 +105,10 @@ static void vmemmap_pte_range(pmd_t *pmd
 	 * remapping (which is calling @walk->remap_pte).
 	 */
 	if (!walk->reuse_page) {
-		struct page *page = pte_page(*pte);
-
-		/*
-		 * Copy the data from the original head, and remap to
-		 * the newly allocated page.
-		 */
-		if (walk->head_page) {
-			memcpy(page_address(walk->head_page),
-			       page_address(page), PAGE_SIZE);
-			walk->remap_pte(pte, addr, walk);
-			page = walk->head_page;
-		}
-
-		walk->reuse_page = page;
-
+		walk->reuse_page = pte_page(*pte);
 		/*
-		 * Because the reuse address is part of the range that
-		 * we are walking or the head page was remapped to a
-		 * new page, skip the reuse address range.
-		 * .
+		 * Because the reuse address is part of the range that we are
+		 * walking, skip the reuse address range.
 		 */
 		addr += PAGE_SIZE;
 		pte++;
@@ -221,11 +203,6 @@ static int vmemmap_remap_range(unsigned
 			return ret;
 	} while (pgd++, addr = next, addr != end);
 
-	/*
-	 * We change the mapping of the vmemmap virtual address range
-	 * [@start, end], so we only need to flush the TLB which
-	 * belongs to the range.
-	 */
 	flush_tlb_kernel_range(start, end);
 
 	return 0;
@@ -262,21 +239,16 @@ static void vmemmap_remap_pte(pte_t *pte
 	 * to the tail pages.
 	 */
 	pgprot_t pgprot = PAGE_KERNEL_RO;
-	struct page *reuse = walk->reuse_page;
 	struct page *page = pte_page(*pte);
 	pte_t entry;
 
-	/*
-	 * When there's no walk::reuse_page, it means we allocated a new head
-	 * page (stored in walk::head_page) and copied from the old head page.
-	 * In that case use the walk::head_page as the page to remap.
-	 */
-	if (!reuse) {
+	/* Remapping the head page requires r/w */
+	if (unlikely(addr == walk->reuse_addr)) {
 		pgprot = PAGE_KERNEL;
-		reuse = walk->head_page;
+		list_del(&walk->reuse_page->lru);
 	}
 
-	entry = mk_pte(reuse, pgprot);
+	entry = mk_pte(walk->reuse_page, pgprot);
 	list_add_tail(&page->lru, walk->vmemmap_pages);
 	set_pte_at(&init_mm, addr, pte, entry);
 }
@@ -345,9 +317,9 @@ static int vmemmap_remap_free(unsigned l
 		.reuse_addr	= reuse,
 		.vmemmap_pages	= &vmemmap_pages,
 	};
-	gfp_t gfp_mask = GFP_KERNEL|__GFP_RETRY_MAYFAIL|__GFP_NOWARN;
 	int nid = page_to_nid((struct page *)start);
-	struct page *page = NULL;
+	gfp_t gfp_mask = GFP_KERNEL | __GFP_THISNODE | __GFP_NORETRY |
+			__GFP_NOWARN;
 
 	/*
 	 * Allocate a new head vmemmap page to avoid breaking a contiguous
@@ -357,9 +329,12 @@ static int vmemmap_remap_free(unsigned l
 	 * more allocations of hugepages. Fallback to the currently
 	 * mapped head page in case should it fail to allocate.
 	 */
-	if (IS_ALIGNED((unsigned long)start, PAGE_SIZE))
-		page = alloc_pages_node(nid, gfp_mask, 0);
-	walk.head_page = page;
+	walk.reuse_page = alloc_pages_node(nid, gfp_mask, 0);
+	if (walk.reuse_page) {
+		copy_page(page_to_virt(walk.reuse_page),
+			  (void *)walk.reuse_addr);
+		list_add(&walk.reuse_page->lru, &vmemmap_pages);
+	}
 
 	/*
 	 * In order to make remapping routine most efficient for the huge pages,
_

Patches currently in -mm which might be from joao.m.martins@oracle.com are

mm-hugetlb_vmemmap-remap-head-page-to-newly-allocated-page.patch
mm-hugetlb_vmemmap-remap-head-page-to-newly-allocated-page-v4.patch

