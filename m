Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50775C77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:35:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbjDRXfL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231560AbjDRXek (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:34:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33FF7A5F5
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:34:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13F66639E9
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:34:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6431DC433EF;
        Tue, 18 Apr 2023 23:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860855;
        bh=X5MF+dI3BBwx16tC93GyBopcRanaoxwN7DiIHs6RItg=;
        h=Date:To:From:Subject:From;
        b=x0f1lulIYYwlhA5AxQkMnRkKiKt6gkJzZfF6JXI+w7+wQDXqpparo2WiDX8iS8wET
         19qDe0C3peWsMajsGmmGxesfciJZjBZKIu8VDT7W2oQsaiK5Z8e362PfCuSrnVcmt7
         29l4ZHLGbKGrrNV7k6PFnG0o6EDmtS+T8vi+1IRE=
Date:   Tue, 18 Apr 2023 16:34:14 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        shy828301@gmail.com, peterx@redhat.com, kirill@shutemov.name,
        jiaqiyan@google.com, hughd@google.com, david@redhat.com,
        stevensd@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-refactor-collapse_file-control-flow.patch removed from -mm tree
Message-Id: <20230418233415.6431DC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: refactor collapse_file control flow
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-refactor-collapse_file-control-flow.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Stevens <stevensd@chromium.org>
Subject: mm/khugepaged: refactor collapse_file control flow
Date: Tue, 4 Apr 2023 21:01:15 +0900

Add a rollback label to deal with failure, instead of continuously
checking for RESULT_SUCCESS, to make it easier to add more failure cases. 
The refactoring also allows the collapse_file tracepoint to include hpage
on success (instead of NULL).

Link: https://lkml.kernel.org/r/20230404120117.2562166-3-stevensd@google.com
Signed-off-by: David Stevens <stevensd@chromium.org>
Acked-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |  236 ++++++++++++++++++++++------------------------
 1 file changed, 116 insertions(+), 120 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-refactor-collapse_file-control-flow
+++ a/mm/khugepaged.c
@@ -1894,6 +1894,12 @@ static int collapse_file(struct mm_struc
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
@@ -1906,16 +1912,10 @@ static int collapse_file(struct mm_struc
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
@@ -2152,137 +2152,133 @@ xa_unlocked:
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
-	nr = thp_nr_pages(hpage);
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
+	nr = thp_nr_pages(hpage);
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
+
+		VM_BUG_ON_PAGE(page->index != xas.xa_index, page);
+
+		/* Unfreeze the page. */
+		list_del(&page->lru);
+		page_ref_unfreeze(page, 2);
+		xas_store(&xas, page);
+		xas_pause(&xas);
+		xas_unlock_irq(&xas);
+		unlock_page(page);
+		putback_lru_page(page);
+		xas_lock_irq(&xas);
+	}
+	VM_BUG_ON(nr_none);
+	/*
+	 * Undo the updates of filemap_nr_thps_inc for non-SHMEM
+	 * file only. This undo is not needed unless failure is
+	 * due to SCAN_COPY_MC.
+	 */
+	if (!is_shmem && result == SCAN_COPY_MC) {
+		filemap_nr_thps_dec(mapping);
 		/*
-		 * Undo the updates of filemap_nr_thps_inc for non-SHMEM
-		 * file only. This undo is not needed unless failure is
-		 * due to SCAN_COPY_MC.
+		 * Paired with smp_mb() in do_dentry_open() to
+		 * ensure the update to nr_thps is visible.
 		 */
-		if (!is_shmem && result == SCAN_COPY_MC) {
-			filemap_nr_thps_dec(mapping);
-			/*
-			 * Paired with smp_mb() in do_dentry_open() to
-			 * ensure the update to nr_thps is visible.
-			 */
-			smp_mb();
-		}
+		smp_mb();
+	}
 
-		xas_unlock_irq(&xas);
+	xas_unlock_irq(&xas);
 
-		hpage->mapping = NULL;
-	}
+	hpage->mapping = NULL;
 
-	if (hpage)
-		unlock_page(hpage);
+	unlock_page(hpage);
+	put_page(hpage);
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

mm-shmem-fix-race-in-shmem_undo_range-w-thp.patch
mm-khugepaged-skip-shmem-with-userfaultfd.patch
mm-khugepaged-maintain-page-cache-uptodate-flag.patch

