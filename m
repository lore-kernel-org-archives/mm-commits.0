Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1021C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 10 Nov 2022 00:11:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbiKJALK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Nov 2022 19:11:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232125AbiKJALJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2022 19:11:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5EA4FCEC
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 16:11:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 606E961D17
        for <mm-commits@vger.kernel.org>; Thu, 10 Nov 2022 00:11:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B647BC433D7;
        Thu, 10 Nov 2022 00:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668039067;
        bh=02S82RUnGtBitdfB29PymO3ehhVhfM1/TWFA3I8ebsI=;
        h=Date:To:From:Subject:From;
        b=Z3UtWbFhYRd/Jjn6VUm14D360ZHOSxPArCAn0M9YobBE3de/B0UWF8Rx0stwNeRQM
         jiJIOpU3mpDKdtFBHdUnILQaIwqtN5WVBtZG/N3hP3BMnrykLYjtJdYXxQv1Qgv1Ae
         9JnBMtDS72NA3vO3K2zbDhrLu1L+BjyT9NHBKJOQ=
Date:   Wed, 09 Nov 2022 16:11:07 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, joao.m.martins@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-remap-head-page-to-newly-allocated-page-v3.patch added to mm-unstable branch
Message-Id: <20221110001107.B647BC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb_vmemmap-remap-head-page-to-newly-allocated-page-v3
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-remap-head-page-to-newly-allocated-page-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-remap-head-page-to-newly-allocated-page-v3.patch

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
mm-hugetlb_vmemmap-remap-head-page-to-newly-allocated-page-v3.patch

