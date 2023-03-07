Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57606C6FA99
	for <mm-commits@archiver.kernel.org>; Tue,  7 Mar 2023 23:01:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbjCGXBE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Mar 2023 18:01:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbjCGXAo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Mar 2023 18:00:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC8A2F784
        for <mm-commits@vger.kernel.org>; Tue,  7 Mar 2023 14:58:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57B3961518
        for <mm-commits@vger.kernel.org>; Tue,  7 Mar 2023 22:58:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6ABDC433EF;
        Tue,  7 Mar 2023 22:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678229894;
        bh=uHTYDAsbjXVZ0p86da0s7zawWmrAe/aJ86d49WffwsM=;
        h=Date:To:From:Subject:From;
        b=wc2r53TisNMUbXKKcEosfD2BclDiTUtJcTfFrGhBq9z4r+tpFxLjN8F0caAwnKaN0
         ut/V0dR3mxdQKMx6o+Kroskvnfdoa/VqLTrlHr7+DiVJzfVkmgpgp2B+iClO7o6FPA
         G9YY2O7/SLboMOvKpk3OFHcIm68vBN9dTK+E/l0s=
Date:   Tue, 07 Mar 2023 14:58:14 -0800
To:     mm-commits@vger.kernel.org, shy828301@gmail.com, peterx@redhat.com,
        stevensd@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-refactor-collapse_file-control-flow.patch added to mm-unstable branch
Message-Id: <20230307225814.B6ABDC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: refactor collapse_file control flow
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-refactor-collapse_file-control-flow.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-refactor-collapse_file-control-flow.patch

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
From: David Stevens <stevensd@chromium.org>
Subject: mm/khugepaged: refactor collapse_file control flow
Date: Tue, 7 Mar 2023 14:20:34 +0900

Patch series "mm/khugepaged: fix khugepaged+shmem races", v5.

Fix two races in khugepaged+shmem that cause issues with userfaultfd and
lseek, respectively.


This patch (of 3):

Add a rollback label to deal with failure, instead of continuously
checking for RESULT_SUCCESS, to make it easier to add more failure cases. 
The refactoring also allows the collapse_file tracepoint to include hpage
on success (instead of NULL).

Link: https://lkml.kernel.org/r/20230307052036.1520708-1-stevensd@google.com
Link: https://lkml.kernel.org/r/20230307052036.1520708-2-stevensd@google.com
Signed-off-by: David Stevens <stevensd@chromium.org>
Acked-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |  223 ++++++++++++++++++++++------------------------
 1 file changed, 110 insertions(+), 113 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-refactor-collapse_file-control-flow
+++ a/mm/khugepaged.c
@@ -1907,6 +1907,12 @@ static int collapse_file(struct mm_struc
 	if (result != SCAN_SUCCEED)
 		goto out;
 
+	__SetPageLocked(hpage);
+	if (is_shmem)
+		__SetPageSwapBacked(hpage);
+	hpage->index = start;
+	hpage->mapping = mapping;
+
 	/*
 	 * Ensure we have slots for all the pages in the range.  This is
 	 * almost certainly a no-op because most of the pages must be present
@@ -1919,16 +1925,10 @@ static int collapse_file(struct mm_struc
 		xas_unlock_irq(&xas);
 		if (!xas_nomem(&xas, GFP_KERNEL)) {
 			result = SCAN_FAIL;
-			goto out;
+			goto rollback;
 		}
 	} while (1);
 
-	__SetPageLocked(hpage);
-	if (is_shmem)
-		__SetPageSwapBacked(hpage);
-	hpage->index = start;
-	hpage->mapping = mapping;
-
 	/*
 	 * At this point the hpage is locked and not up-to-date.
 	 * It's safe to insert it into the page cache, because nobody would
@@ -2145,129 +2145,126 @@ xa_unlocked:
 	 */
 	try_to_unmap_flush();
 
-	if (result == SCAN_SUCCEED) {
-		/*
-		 * Replacing old pages with new one has succeeded, now we
-		 * attempt to copy the contents.
-		 */
-		index = start;
-		list_for_each_entry(page, &pagelist, lru) {
-			while (index < page->index) {
-				clear_highpage(hpage + (index % HPAGE_PMD_NR));
-				index++;
-			}
-			if (copy_mc_highpage(hpage + (page->index % HPAGE_PMD_NR),
-					     page) > 0) {
-				result = SCAN_COPY_MC;
-				break;
-			}
-			index++;
-		}
-		while (result == SCAN_SUCCEED && index < end) {
+	if (result != SCAN_SUCCEED)
+		goto rollback;
+
+	/*
+	 * Replacing old pages with new one has succeeded, now we
+	 * attempt to copy the contents.
+	 */
+	index = start;
+	list_for_each_entry(page, &pagelist, lru) {
+		while (index < page->index) {
 			clear_highpage(hpage + (index % HPAGE_PMD_NR));
 			index++;
 		}
-	}
-
-	if (result == SCAN_SUCCEED) {
-		/*
-		 * Copying old pages to huge one has succeeded, now we
-		 * need to free the old pages.
-		 */
-		list_for_each_entry_safe(page, tmp, &pagelist, lru) {
-			list_del(&page->lru);
-			page->mapping = NULL;
-			page_ref_unfreeze(page, 1);
-			ClearPageActive(page);
-			ClearPageUnevictable(page);
-			unlock_page(page);
-			put_page(page);
+		if (copy_mc_highpage(hpage + (page->index % HPAGE_PMD_NR), page) > 0) {
+			result = SCAN_COPY_MC;
+			goto rollback;
 		}
+		index++;
+	}
+	while (index < end) {
+		clear_highpage(hpage + (index % HPAGE_PMD_NR));
+		index++;
+	}
 
-		xas_lock_irq(&xas);
-		if (is_shmem)
-			__mod_lruvec_page_state(hpage, NR_SHMEM_THPS, nr);
-		else
-			__mod_lruvec_page_state(hpage, NR_FILE_THPS, nr);
-
-		if (nr_none) {
-			__mod_lruvec_page_state(hpage, NR_FILE_PAGES, nr_none);
-			/* nr_none is always 0 for non-shmem. */
-			__mod_lruvec_page_state(hpage, NR_SHMEM, nr_none);
-		}
-		/* Join all the small entries into a single multi-index entry. */
-		xas_set_order(&xas, start, HPAGE_PMD_ORDER);
-		xas_store(&xas, hpage);
-		xas_unlock_irq(&xas);
+	/*
+	 * Copying old pages to huge one has succeeded, now we
+	 * need to free the old pages.
+	 */
+	list_for_each_entry_safe(page, tmp, &pagelist, lru) {
+		list_del(&page->lru);
+		page->mapping = NULL;
+		page_ref_unfreeze(page, 1);
+		ClearPageActive(page);
+		ClearPageUnevictable(page);
+		unlock_page(page);
+		put_page(page);
+	}
 
-		folio = page_folio(hpage);
-		folio_mark_uptodate(folio);
-		folio_ref_add(folio, HPAGE_PMD_NR - 1);
-
-		if (is_shmem)
-			folio_mark_dirty(folio);
-		folio_add_lru(folio);
+	xas_lock_irq(&xas);
+	if (is_shmem)
+		__mod_lruvec_page_state(hpage, NR_SHMEM_THPS, nr);
+	else
+		__mod_lruvec_page_state(hpage, NR_FILE_THPS, nr);
+
+	if (nr_none) {
+		__mod_lruvec_page_state(hpage, NR_FILE_PAGES, nr_none);
+		/* nr_none is always 0 for non-shmem. */
+		__mod_lruvec_page_state(hpage, NR_SHMEM, nr_none);
+	}
+	/* Join all the small entries into a single multi-index entry. */
+	xas_set_order(&xas, start, HPAGE_PMD_ORDER);
+	xas_store(&xas, hpage);
+	xas_unlock_irq(&xas);
 
-		/*
-		 * Remove pte page tables, so we can re-fault the page as huge.
-		 */
-		result = retract_page_tables(mapping, start, mm, addr, hpage,
-					     cc);
-		unlock_page(hpage);
-		hpage = NULL;
-	} else {
-		/* Something went wrong: roll back page cache changes */
-		xas_lock_irq(&xas);
-		if (nr_none) {
-			mapping->nrpages -= nr_none;
-			shmem_uncharge(mapping->host, nr_none);
-		}
+	folio = page_folio(hpage);
+	folio_mark_uptodate(folio);
+	folio_ref_add(folio, HPAGE_PMD_NR - 1);
 
-		xas_set(&xas, start);
-		xas_for_each(&xas, page, end - 1) {
-			page = list_first_entry_or_null(&pagelist,
-					struct page, lru);
-			if (!page || xas.xa_index < page->index) {
-				if (!nr_none)
-					break;
-				nr_none--;
-				/* Put holes back where they were */
-				xas_store(&xas, NULL);
-				continue;
-			}
+	if (is_shmem)
+		folio_mark_dirty(folio);
+	folio_add_lru(folio);
 
-			VM_BUG_ON_PAGE(page->index != xas.xa_index, page);
+	/*
+	 * Remove pte page tables, so we can re-fault the page as huge.
+	 */
+	result = retract_page_tables(mapping, start, mm, addr, hpage,
+				     cc);
+	unlock_page(hpage);
+	goto out;
+
+rollback:
+	/* Something went wrong: roll back page cache changes */
+	xas_lock_irq(&xas);
+	if (nr_none) {
+		mapping->nrpages -= nr_none;
+		shmem_uncharge(mapping->host, nr_none);
+	}
 
-			/* Unfreeze the page. */
-			list_del(&page->lru);
-			page_ref_unfreeze(page, 2);
-			xas_store(&xas, page);
-			xas_pause(&xas);
-			xas_unlock_irq(&xas);
-			unlock_page(page);
-			putback_lru_page(page);
-			xas_lock_irq(&xas);
+	xas_set(&xas, start);
+	xas_for_each(&xas, page, end - 1) {
+		page = list_first_entry_or_null(&pagelist,
+				struct page, lru);
+		if (!page || xas.xa_index < page->index) {
+			if (!nr_none)
+				break;
+			nr_none--;
+			/* Put holes back where they were */
+			xas_store(&xas, NULL);
+			continue;
 		}
-		VM_BUG_ON(nr_none);
-		/*
-		 * Undo the updates of filemap_nr_thps_inc for non-SHMEM file only.
-		 * This undo is not needed unless failure is due to SCAN_COPY_MC.
-		 */
-		if (!is_shmem && result == SCAN_COPY_MC)
-			filemap_nr_thps_dec(mapping);
 
+		VM_BUG_ON_PAGE(page->index != xas.xa_index, page);
+
+		/* Unfreeze the page. */
+		list_del(&page->lru);
+		page_ref_unfreeze(page, 2);
+		xas_store(&xas, page);
+		xas_pause(&xas);
 		xas_unlock_irq(&xas);
-
-		hpage->mapping = NULL;
+		unlock_page(page);
+		putback_lru_page(page);
+		xas_lock_irq(&xas);
 	}
+	VM_BUG_ON(nr_none);
+	/*
+	 * Undo the updates of filemap_nr_thps_inc for non-SHMEM file only.
+	 * This undo is not needed unless failure is due to SCAN_COPY_MC.
+	 */
+	if (!is_shmem && result == SCAN_COPY_MC)
+		filemap_nr_thps_dec(mapping);
+
+	xas_unlock_irq(&xas);
+
+	hpage->mapping = NULL;
+
+	unlock_page(hpage);
+	put_page(hpage);
 
-	if (hpage)
-		unlock_page(hpage);
 out:
 	VM_BUG_ON(!list_empty(&pagelist));
-	if (hpage)
-		put_page(hpage);
-
 	trace_mm_khugepaged_collapse_file(mm, hpage, index, is_shmem, addr, file, nr, result);
 	return result;
 }
_

Patches currently in -mm which might be from stevensd@chromium.org are

mm-khugepaged-refactor-collapse_file-control-flow.patch
mm-khugepaged-skip-shmem-with-userfaultfd.patch
mm-khugepaged-maintain-page-cache-uptodate-flag.patch

