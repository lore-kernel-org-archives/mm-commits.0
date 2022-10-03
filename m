Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC505C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:05:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiJCVFs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiJCVFM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:05:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B1DC1180D
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:04:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBBC1610D5
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:04:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 501CBC433D6;
        Mon,  3 Oct 2022 21:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831093;
        bh=vhLukGpy7OTXnaFp1r51LEjwUFbvZBzqkVTK1rpG6pA=;
        h=Date:To:From:Subject:From;
        b=Avy0nKEu6V8zRJiFSaUgUEDUJx9ZeuNDYAadaLPWM63ZYpD/yZEPnuuS9rPPSUgky
         J9bcxXgr2jSgmPZi6zKIcPIQcNu4Yd8TY6aKD17OlgM5YSHlWIfwyaSzpR5uLDVMcP
         E/5NFaYkCenmiRpUjP4QdRyuwTsNXenuZ5phf+84=
Date:   Mon, 03 Oct 2022 14:04:52 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-do_swap_pages-swapcache-variable-to-a-folio.patch removed from -mm tree
Message-Id: <20221003210453.501CBC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: convert do_swap_page()'s swapcache variable to a folio
has been removed from the -mm tree.  Its filename was
     mm-convert-do_swap_pages-swapcache-variable-to-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert do_swap_page()'s swapcache variable to a folio
Date: Fri, 2 Sep 2022 20:46:11 +0100

The 'swapcache' variable is used to track whether the page is from the
swapcache or not.  It can do this equally well by being the folio of the
page rather than the page itself, and this saves a number of calls to
compound_head().

Link: https://lkml.kernel.org/r/20220902194653.1739778-16-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

--- a/mm/memory.c~mm-convert-do_swap_pages-swapcache-variable-to-a-folio
+++ a/mm/memory.c
@@ -3724,8 +3724,8 @@ static vm_fault_t handle_pte_marker(stru
 vm_fault_t do_swap_page(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
-	struct folio *folio;
-	struct page *page = NULL, *swapcache;
+	struct folio *swapcache, *folio = NULL;
+	struct page *page;
 	struct swap_info_struct *si = NULL;
 	rmap_t rmap_flags = RMAP_NONE;
 	bool exclusive = false;
@@ -3768,11 +3768,11 @@ vm_fault_t do_swap_page(struct vm_fault
 		goto out;
 
 	page = lookup_swap_cache(entry, vma, vmf->address);
-	swapcache = page;
 	if (page)
 		folio = page_folio(page);
+	swapcache = folio;
 
-	if (!page) {
+	if (!folio) {
 		if (data_race(si->flags & SWP_SYNCHRONOUS_IO) &&
 		    __swap_count(entry) == 1) {
 			/* skip swapcache */
@@ -3805,12 +3805,12 @@ vm_fault_t do_swap_page(struct vm_fault
 		} else {
 			page = swapin_readahead(entry, GFP_HIGHUSER_MOVABLE,
 						vmf);
-			swapcache = page;
 			if (page)
 				folio = page_folio(page);
+			swapcache = folio;
 		}
 
-		if (!page) {
+		if (!folio) {
 			/*
 			 * Back out if somebody else faulted in this pte
 			 * while we released the pte lock.
@@ -3862,7 +3862,6 @@ vm_fault_t do_swap_page(struct vm_fault
 		page = ksm_might_need_to_copy(page, vma, vmf->address);
 		if (unlikely(!page)) {
 			ret = VM_FAULT_OOM;
-			page = swapcache;
 			goto out_page;
 		}
 		folio = page_folio(page);
@@ -3873,7 +3872,7 @@ vm_fault_t do_swap_page(struct vm_fault
 		 * owner. Try removing the extra reference from the local LRU
 		 * pagevecs if required.
 		 */
-		if ((vmf->flags & FAULT_FLAG_WRITE) && page == swapcache &&
+		if ((vmf->flags & FAULT_FLAG_WRITE) && folio == swapcache &&
 		    !folio_test_ksm(folio) && !folio_test_lru(folio))
 			lru_add_drain();
 	}
@@ -3914,7 +3913,7 @@ vm_fault_t do_swap_page(struct vm_fault
 		 * without __HAVE_ARCH_PTE_SWP_EXCLUSIVE.
 		 */
 		exclusive = pte_swp_exclusive(vmf->orig_pte);
-		if (page != swapcache) {
+		if (folio != swapcache) {
 			/*
 			 * We have a fresh page that is not exposed to the
 			 * swapcache -> certainly exclusive.
@@ -3982,7 +3981,7 @@ vm_fault_t do_swap_page(struct vm_fault
 	vmf->orig_pte = pte;
 
 	/* ksm created a completely new copy */
-	if (unlikely(page != swapcache && swapcache)) {
+	if (unlikely(folio != swapcache && swapcache)) {
 		page_add_new_anon_rmap(page, vma, vmf->address);
 		folio_add_lru_vma(folio, vma);
 	} else {
@@ -3995,7 +3994,7 @@ vm_fault_t do_swap_page(struct vm_fault
 	arch_do_swap_page(vma->vm_mm, vma, vmf->address, pte, vmf->orig_pte);
 
 	folio_unlock(folio);
-	if (page != swapcache && swapcache) {
+	if (folio != swapcache && swapcache) {
 		/*
 		 * Hold the lock to avoid the swap entry to be reused
 		 * until we take the PT lock for the pte_same() check
@@ -4004,8 +4003,8 @@ vm_fault_t do_swap_page(struct vm_fault
 		 * so that the swap count won't change under a
 		 * parallel locked swapcache.
 		 */
-		unlock_page(swapcache);
-		put_page(swapcache);
+		folio_unlock(swapcache);
+		folio_put(swapcache);
 	}
 
 	if (vmf->flags & FAULT_FLAG_WRITE) {
@@ -4029,9 +4028,9 @@ out_page:
 	folio_unlock(folio);
 out_release:
 	folio_put(folio);
-	if (page != swapcache && swapcache) {
-		unlock_page(swapcache);
-		put_page(swapcache);
+	if (folio != swapcache && swapcache) {
+		folio_unlock(swapcache);
+		folio_put(swapcache);
 	}
 	if (si)
 		put_swap_device(si);
_

Patches currently in -mm which might be from willy@infradead.org are


