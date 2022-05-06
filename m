Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00603C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  6 May 2022 01:32:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387950AbiEFBgc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 May 2022 21:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387951AbiEFBga (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 May 2022 21:36:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 787595D5C1
        for <mm-commits@vger.kernel.org>; Thu,  5 May 2022 18:32:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C05DB82E5D
        for <mm-commits@vger.kernel.org>; Fri,  6 May 2022 01:32:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C05F4C385A8;
        Fri,  6 May 2022 01:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651800766;
        bh=G374WuOpt5cIrz0UQ8Xurpw2ckSguuByYKil5LAKvSI=;
        h=Date:To:From:Subject:From;
        b=ywoZbOJEkmST7P9UED8aAUwe9GnDVxQhweAww1aXe4keUIf8MF/6oNsWCxBj+Xfxu
         xDyrlf4YxSUQvLSjiQ6PVclJ+Gli+Z04/up9jtIrCBbRHWFeAlcWEvcPV9n5+vgHAT
         YiPL9oHRpcnG5Ar2QQeai/XLEiuW1+aB7S1hb91M=
Date:   Thu, 05 May 2022 18:32:46 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-alloc_pages_vma.patch added to mm-unstable branch
Message-Id: <20220506013246.C05F4C385A8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove alloc_pages_vma()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-alloc_pages_vma.patch

This patch should soon appear in the mm-unstable branch at
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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove alloc_pages_vma()

All callers have now been converted to use vma_alloc_folio(), so convert
the body of alloc_pages_vma() to allocate folios instead.

Link: https://lkml.kernel.org/r/20220504182857.4013401-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |   18 +++++---------
 mm/mempolicy.c      |   51 ++++++++++++++++++++----------------------
 2 files changed, 32 insertions(+), 37 deletions(-)

--- a/include/linux/gfp.h~mm-remove-alloc_pages_vma
+++ a/include/linux/gfp.h
@@ -609,13 +609,8 @@ static inline struct page *alloc_pages_n
 #ifdef CONFIG_NUMA
 struct page *alloc_pages(gfp_t gfp, unsigned int order);
 struct folio *folio_alloc(gfp_t gfp, unsigned order);
-struct page *alloc_pages_vma(gfp_t gfp_mask, int order,
-			struct vm_area_struct *vma, unsigned long addr,
-			bool hugepage);
 struct folio *vma_alloc_folio(gfp_t gfp, int order, struct vm_area_struct *vma,
 		unsigned long addr, bool hugepage);
-#define alloc_hugepage_vma(gfp_mask, vma, addr, order) \
-	alloc_pages_vma(gfp_mask, order, vma, addr, true)
 #else
 static inline struct page *alloc_pages(gfp_t gfp_mask, unsigned int order)
 {
@@ -625,16 +620,17 @@ static inline struct folio *folio_alloc(
 {
 	return __folio_alloc_node(gfp, order, numa_node_id());
 }
-#define alloc_pages_vma(gfp_mask, order, vma, addr, hugepage) \
-	alloc_pages(gfp_mask, order)
 #define vma_alloc_folio(gfp, order, vma, addr, hugepage)		\
 	folio_alloc(gfp, order)
-#define alloc_hugepage_vma(gfp_mask, vma, addr, order) \
-	alloc_pages(gfp_mask, order)
 #endif
 #define alloc_page(gfp_mask) alloc_pages(gfp_mask, 0)
-#define alloc_page_vma(gfp_mask, vma, addr)			\
-	alloc_pages_vma(gfp_mask, 0, vma, addr, false)
+static inline struct page *alloc_page_vma(gfp_t gfp,
+		struct vm_area_struct *vma, unsigned long addr)
+{
+	struct folio *folio = vma_alloc_folio(gfp, 0, vma, addr, false);
+
+	return &folio->page;
+}
 
 extern unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order);
 extern unsigned long get_zeroed_page(gfp_t gfp_mask);
--- a/mm/mempolicy.c~mm-remove-alloc_pages_vma
+++ a/mm/mempolicy.c
@@ -2136,44 +2136,55 @@ static struct page *alloc_pages_preferre
 }
 
 /**
- * alloc_pages_vma - Allocate a page for a VMA.
+ * vma_alloc_folio - Allocate a folio for a VMA.
  * @gfp: GFP flags.
- * @order: Order of the GFP allocation.
+ * @order: Order of the folio.
  * @vma: Pointer to VMA or NULL if not available.
  * @addr: Virtual address of the allocation.  Must be inside @vma.
  * @hugepage: For hugepages try only the preferred node if possible.
  *
- * Allocate a page for a specific address in @vma, using the appropriate
+ * Allocate a folio for a specific address in @vma, using the appropriate
  * NUMA policy.  When @vma is not NULL the caller must hold the mmap_lock
  * of the mm_struct of the VMA to prevent it from going away.  Should be
- * used for all allocations for pages that will be mapped into user space.
+ * used for all allocations for folios that will be mapped into user space.
  *
- * Return: The page on success or NULL if allocation fails.
+ * Return: The folio on success or NULL if allocation fails.
  */
-struct page *alloc_pages_vma(gfp_t gfp, int order, struct vm_area_struct *vma,
+struct folio *vma_alloc_folio(gfp_t gfp, int order, struct vm_area_struct *vma,
 		unsigned long addr, bool hugepage)
 {
 	struct mempolicy *pol;
 	int node = numa_node_id();
-	struct page *page;
+	struct folio *folio;
 	int preferred_nid;
 	nodemask_t *nmask;
 
 	pol = get_vma_policy(vma, addr);
 
 	if (pol->mode == MPOL_INTERLEAVE) {
+		struct page *page;
 		unsigned nid;
 
 		nid = interleave_nid(pol, vma, addr, PAGE_SHIFT + order);
 		mpol_cond_put(pol);
+		gfp |= __GFP_COMP;
 		page = alloc_page_interleave(gfp, order, nid);
+		if (page && order > 1)
+			prep_transhuge_page(page);
+		folio = (struct folio *)page;
 		goto out;
 	}
 
 	if (pol->mode == MPOL_PREFERRED_MANY) {
+		struct page *page;
+
 		node = policy_node(gfp, pol, node);
+		gfp |= __GFP_COMP;
 		page = alloc_pages_preferred_many(gfp, order, node, pol);
 		mpol_cond_put(pol);
+		if (page && order > 1)
+			prep_transhuge_page(page);
+		folio = (struct folio *)page;
 		goto out;
 	}
 
@@ -2200,8 +2211,8 @@ struct page *alloc_pages_vma(gfp_t gfp,
 			 * First, try to allocate THP only on local node, but
 			 * don't reclaim unnecessarily, just compact.
 			 */
-			page = __alloc_pages_node(hpage_node,
-				gfp | __GFP_THISNODE | __GFP_NORETRY, order);
+			folio = __folio_alloc_node(gfp | __GFP_THISNODE |
+					__GFP_NORETRY, order, hpage_node);
 
 			/*
 			 * If hugepage allocations are configured to always
@@ -2209,8 +2220,9 @@ struct page *alloc_pages_vma(gfp_t gfp,
 			 * to prefer hugepage backing, retry allowing remote
 			 * memory with both reclaim and compact as well.
 			 */
-			if (!page && (gfp & __GFP_DIRECT_RECLAIM))
-				page = __alloc_pages(gfp, order, hpage_node, nmask);
+			if (!folio && (gfp & __GFP_DIRECT_RECLAIM))
+				folio = __folio_alloc(gfp, order, hpage_node,
+						      nmask);
 
 			goto out;
 		}
@@ -2218,25 +2230,12 @@ struct page *alloc_pages_vma(gfp_t gfp,
 
 	nmask = policy_nodemask(gfp, pol);
 	preferred_nid = policy_node(gfp, pol, node);
-	page = __alloc_pages(gfp, order, preferred_nid, nmask);
+	folio = __folio_alloc(gfp, order, preferred_nid, nmask);
 	mpol_cond_put(pol);
 out:
-	return page;
-}
-EXPORT_SYMBOL(alloc_pages_vma);
-
-struct folio *vma_alloc_folio(gfp_t gfp, int order, struct vm_area_struct *vma,
-		unsigned long addr, bool hugepage)
-{
-	struct folio *folio;
-
-	folio = (struct folio *)alloc_pages_vma(gfp, order, vma, addr,
-			hugepage);
-	if (folio && order > 1)
-		prep_transhuge_page(&folio->page);
-
 	return folio;
 }
+EXPORT_SYMBOL(vma_alloc_folio);
 
 /**
  * alloc_pages - Allocate pages.
_

Patches currently in -mm which might be from willy@infradead.org are

shmem-convert-shmem_alloc_hugepage-to-use-vma_alloc_folio.patch
mm-huge_memory-convert-do_huge_pmd_anonymous_page-to-use-vma_alloc_folio.patch
alpha-fix-alloc_zeroed_user_highpage_movable.patch
mm-remove-alloc_pages_vma.patch
vmscan-use-folio_mapped-in-shrink_page_list.patch
vmscan-convert-the-writeback-handling-in-shrink_page_list-to-folios.patch
swap-turn-get_swap_page-into-folio_alloc_swap.patch
swap-convert-add_to_swap-to-take-a-folio.patch
vmscan-convert-dirty-page-handling-to-folios.patch
vmscan-convert-page-buffer-handling-to-use-folios.patch
vmscan-convert-lazy-freeing-to-folios.patch
vmscan-move-initialisation-of-mapping-down.patch
vmscan-convert-the-activate_locked-portion-of-shrink_page_list-to-folios.patch
mm-allow-can_split_folio-to-be-called-when-thp-are-disabled.patch
vmscan-remove-remaining-uses-of-page-in-shrink_page_list.patch
mm-shmem-use-a-folio-in-shmem_unused_huge_shrink.patch
mm-swap-add-folio_throttle_swaprate.patch
mm-shmem-convert-shmem_add_to_page_cache-to-take-a-folio.patch
mm-shmem-turn-shmem_should_replace_page-into-shmem_should_replace_folio.patch
mm-shmem-add-shmem_alloc_folio.patch
mm-shmem-convert-shmem_alloc_and_acct_page-to-use-a-folio.patch
mm-shmem-convert-shmem_getpage_gfp-to-use-a-folio.patch
mm-shmem-convert-shmem_swapin_page-to-shmem_swapin_folio.patch
mm-add-folio_mapping_flags.patch
mm-add-folio_test_movable.patch
mm-migrate-convert-move_to_new_page-into-move_to_new_folio.patch

