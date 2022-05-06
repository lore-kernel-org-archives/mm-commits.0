Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D693C43217
	for <mm-commits@archiver.kernel.org>; Fri,  6 May 2022 01:33:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387970AbiEFBhI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 May 2022 21:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387973AbiEFBhB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 May 2022 21:37:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6E862135
        for <mm-commits@vger.kernel.org>; Thu,  5 May 2022 18:33:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D89F962020
        for <mm-commits@vger.kernel.org>; Fri,  6 May 2022 01:33:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0F2C385A8;
        Fri,  6 May 2022 01:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651800795;
        bh=n68NPBBCyBrqzdxqYlNdKQYRh1FQ5oAWzPCTMclCVqk=;
        h=Date:To:From:Subject:From;
        b=EoUFiKoM/BCGDE0m4efyPvSbotiuqz/fKG23BoVsa1huTRji2G5Vsu7QF0d8Fik4U
         djtPmVosUrst9Rcv5GPZJYBrsVlUhBVQdBzJ366mXYRBnbUmuoGkPS1NtaurOL8btB
         kse0AGIrLt5HMBETlw9sIfzNBc1UFeIyfYiXtOjA=
Date:   Thu, 05 May 2022 18:33:14 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-convert-shmem_add_to_page_cache-to-take-a-folio.patch added to mm-unstable branch
Message-Id: <20220506013315.3C0F2C385A8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shmem: convert shmem_add_to_page_cache to take a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-convert-shmem_add_to_page_cache-to-take-a-folio.patch

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
Subject: mm/shmem: convert shmem_add_to_page_cache to take a folio

Shrinks shmem_add_to_page_cache() by 16 bytes.  All the callers grow,
but this is temporary as they will all be converted to folios soon.

Link: https://lkml.kernel.org/r/20220504182857.4013401-19-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   59 +++++++++++++++++++++++++++------------------------
 1 file changed, 32 insertions(+), 27 deletions(-)

--- a/mm/shmem.c~mm-shmem-convert-shmem_add_to_page_cache-to-take-a-folio
+++ a/mm/shmem.c
@@ -696,36 +696,35 @@ static unsigned long shmem_unused_huge_s
 /*
  * Like add_to_page_cache_locked, but error if expected item has gone.
  */
-static int shmem_add_to_page_cache(struct page *page,
+static int shmem_add_to_page_cache(struct folio *folio,
 				   struct address_space *mapping,
 				   pgoff_t index, void *expected, gfp_t gfp,
 				   struct mm_struct *charge_mm)
 {
-	XA_STATE_ORDER(xas, &mapping->i_pages, index, compound_order(page));
-	unsigned long nr = compound_nr(page);
+	XA_STATE_ORDER(xas, &mapping->i_pages, index, folio_order(folio));
+	long nr = folio_nr_pages(folio);
 	int error;
 
-	VM_BUG_ON_PAGE(PageTail(page), page);
-	VM_BUG_ON_PAGE(index != round_down(index, nr), page);
-	VM_BUG_ON_PAGE(!PageLocked(page), page);
-	VM_BUG_ON_PAGE(!PageSwapBacked(page), page);
-	VM_BUG_ON(expected && PageTransHuge(page));
-
-	page_ref_add(page, nr);
-	page->mapping = mapping;
-	page->index = index;
+	VM_BUG_ON_FOLIO(index != round_down(index, nr), folio);
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+	VM_BUG_ON_FOLIO(!folio_test_swapbacked(folio), folio);
+	VM_BUG_ON(expected && folio_test_large(folio));
+
+	folio_ref_add(folio, nr);
+	folio->mapping = mapping;
+	folio->index = index;
 
-	if (!PageSwapCache(page)) {
-		error = mem_cgroup_charge(page_folio(page), charge_mm, gfp);
+	if (!folio_test_swapcache(folio)) {
+		error = mem_cgroup_charge(folio, charge_mm, gfp);
 		if (error) {
-			if (PageTransHuge(page)) {
+			if (folio_test_pmd_mappable(folio)) {
 				count_vm_event(THP_FILE_FALLBACK);
 				count_vm_event(THP_FILE_FALLBACK_CHARGE);
 			}
 			goto error;
 		}
 	}
-	cgroup_throttle_swaprate(page, gfp);
+	folio_throttle_swaprate(folio, gfp);
 
 	do {
 		xas_lock_irq(&xas);
@@ -737,16 +736,16 @@ static int shmem_add_to_page_cache(struc
 			xas_set_err(&xas, -EEXIST);
 			goto unlock;
 		}
-		xas_store(&xas, page);
+		xas_store(&xas, folio);
 		if (xas_error(&xas))
 			goto unlock;
-		if (PageTransHuge(page)) {
+		if (folio_test_pmd_mappable(folio)) {
 			count_vm_event(THP_FILE_ALLOC);
-			__mod_lruvec_page_state(page, NR_SHMEM_THPS, nr);
+			__lruvec_stat_mod_folio(folio, NR_SHMEM_THPS, nr);
 		}
 		mapping->nrpages += nr;
-		__mod_lruvec_page_state(page, NR_FILE_PAGES, nr);
-		__mod_lruvec_page_state(page, NR_SHMEM, nr);
+		__lruvec_stat_mod_folio(folio, NR_FILE_PAGES, nr);
+		__lruvec_stat_mod_folio(folio, NR_SHMEM, nr);
 unlock:
 		xas_unlock_irq(&xas);
 	} while (xas_nomem(&xas, gfp));
@@ -758,8 +757,8 @@ unlock:
 
 	return 0;
 error:
-	page->mapping = NULL;
-	page_ref_sub(page, nr);
+	folio->mapping = NULL;
+	folio_ref_sub(folio, nr);
 	return error;
 }
 
@@ -1691,7 +1690,8 @@ static int shmem_swapin_page(struct inod
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct mm_struct *charge_mm = vma ? vma->vm_mm : NULL;
-	struct page *page;
+	struct page *page = NULL;
+	struct folio *folio;
 	swp_entry_t swap;
 	int error;
 
@@ -1741,7 +1741,8 @@ static int shmem_swapin_page(struct inod
 			goto failed;
 	}
 
-	error = shmem_add_to_page_cache(page, mapping, index,
+	folio = page_folio(page);
+	error = shmem_add_to_page_cache(folio, mapping, index,
 					swp_to_radix_entry(swap), gfp,
 					charge_mm);
 	if (error)
@@ -1792,6 +1793,7 @@ static int shmem_getpage_gfp(struct inod
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_sb_info *sbinfo;
 	struct mm_struct *charge_mm;
+	struct folio *folio;
 	struct page *page;
 	pgoff_t hindex = index;
 	gfp_t huge_gfp;
@@ -1906,7 +1908,8 @@ alloc_nohuge:
 	if (sgp == SGP_WRITE)
 		__SetPageReferenced(page);
 
-	error = shmem_add_to_page_cache(page, mapping, hindex,
+	folio = page_folio(page);
+	error = shmem_add_to_page_cache(folio, mapping, hindex,
 					NULL, gfp & GFP_RECLAIM_MASK,
 					charge_mm);
 	if (error)
@@ -2328,6 +2331,7 @@ int shmem_mfill_atomic_pte(struct mm_str
 	gfp_t gfp = mapping_gfp_mask(mapping);
 	pgoff_t pgoff = linear_page_index(dst_vma, dst_addr);
 	void *page_kaddr;
+	struct folio *folio;
 	struct page *page;
 	int ret;
 	pgoff_t max_off;
@@ -2386,7 +2390,8 @@ int shmem_mfill_atomic_pte(struct mm_str
 	if (unlikely(pgoff >= max_off))
 		goto out_release;
 
-	ret = shmem_add_to_page_cache(page, mapping, pgoff, NULL,
+	folio = page_folio(page);
+	ret = shmem_add_to_page_cache(folio, mapping, pgoff, NULL,
 				      gfp & GFP_RECLAIM_MASK, dst_mm);
 	if (ret)
 		goto out_release;
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

