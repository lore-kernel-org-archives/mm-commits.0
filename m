Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81351C742A7
	for <mm-commits@archiver.kernel.org>; Tue,  7 Mar 2023 23:01:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbjCGXBF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Mar 2023 18:01:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbjCGXAp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Mar 2023 18:00:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596C0A42E4
        for <mm-commits@vger.kernel.org>; Tue,  7 Mar 2023 14:58:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FED8615B8
        for <mm-commits@vger.kernel.org>; Tue,  7 Mar 2023 22:58:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F312FC433D2;
        Tue,  7 Mar 2023 22:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678229899;
        bh=4dGDF6OZF6/S2/2dlrn6ucdSnq/VVac0SSCb03MNNOs=;
        h=Date:To:From:Subject:From;
        b=HyKgvE+SHVQdtAyf9d7Ih9HnkQ+JNIGAMrVH/Odf8AqIRnQLI9QHrzXugZ5DYLZsJ
         UtDKG+SMWHNTFSt1sdAHP8l05Q7jQeCnuaFt3nLOvNN6uPSHRNY4GNTiglxsennxN6
         Ak26M4rqPXPKsfLDh1v9r1uK4URC2+YRGQTQBJoU=
Date:   Tue, 07 Mar 2023 14:58:18 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        shy828301@gmail.com, peterx@redhat.com, kirill@shutemov.name,
        jiaqiyan@google.com, hughd@google.com, david@redhat.com,
        stevensd@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-maintain-page-cache-uptodate-flag.patch added to mm-unstable branch
Message-Id: <20230307225818.F312FC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: maintain page cache uptodate flag
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-maintain-page-cache-uptodate-flag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-maintain-page-cache-uptodate-flag.patch

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
Subject: mm/khugepaged: maintain page cache uptodate flag
Date: Tue, 7 Mar 2023 14:20:36 +0900

Make sure that collapse_file doesn't interfere with checking the uptodate
flag in the page cache by only inserting hpage into the page cache after
it has been updated and marked uptodate.  This is achieved by simply not
replacing present pages with hpage when iterating over the target range. 
The present pages are already locked, so replacing the with the locked
hpage before the collapse is finalized is unnecessary.

This fixes a race where folio_seek_hole_data would mistake hpage for an
fallocated but unwritten page.  This race is visible to userspace via data
temporarily disappearing from SEEK_DATA/SEEK_HOLE.

Link: https://lkml.kernel.org/r/20230307052036.1520708-4-stevensd@google.com
Fixes: f3f0e1d2150b ("khugepaged: add support of collapse for tmpfs/shmem pages")
Signed-off-by: David Stevens <stevensd@chromium.org>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   50 +++++++++++-----------------------------------
 1 file changed, 12 insertions(+), 38 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-maintain-page-cache-uptodate-flag
+++ a/mm/khugepaged.c
@@ -1930,12 +1930,6 @@ static int collapse_file(struct mm_struc
 		}
 	} while (1);
 
-	/*
-	 * At this point the hpage is locked and not up-to-date.
-	 * It's safe to insert it into the page cache, because nobody would
-	 * be able to map it or use it in another way until we unlock it.
-	 */
-
 	xas_set(&xas, start);
 	for (index = start; index < end; index++) {
 		page = xas_next(&xas);
@@ -2104,13 +2098,9 @@ static int collapse_file(struct mm_struc
 		}
 
 		/*
-		 * Add the page to the list to be able to undo the collapse if
-		 * something go wrong.
+		 * Accumulate the pages that are being collapsed.
 		 */
 		list_add_tail(&page->lru, &pagelist);
-
-		/* Finally, replace with the new page. */
-		xas_store(&xas, hpage);
 		continue;
 out_unlock:
 		unlock_page(page);
@@ -2149,8 +2139,7 @@ xa_unlocked:
 		goto rollback;
 
 	/*
-	 * Replacing old pages with new one has succeeded, now we
-	 * attempt to copy the contents.
+	 * The old pages are locked, so they won't change anymore.
 	 */
 	index = start;
 	list_for_each_entry(page, &pagelist, lru) {
@@ -2230,11 +2219,11 @@ immap_locked:
 		/* nr_none is always 0 for non-shmem. */
 		__mod_lruvec_page_state(hpage, NR_SHMEM, nr_none);
 	}
-	/* Join all the small entries into a single multi-index entry. */
-	xas_set_order(&xas, start, HPAGE_PMD_ORDER);
-	xas_store(&xas, hpage);
-	xas_unlock_irq(&xas);
 
+	/*
+	 * Mark hpage as uptodate before inserting it into the page cache so
+	 * that it isn't mistaken for an fallocated but unwritten page.
+	 */
 	folio = page_folio(hpage);
 	folio_mark_uptodate(folio);
 	folio_ref_add(folio, HPAGE_PMD_NR - 1);
@@ -2243,6 +2232,11 @@ immap_locked:
 		folio_mark_dirty(folio);
 	folio_add_lru(folio);
 
+	/* Join all the small entries into a single multi-index entry. */
+	xas_set_order(&xas, start, HPAGE_PMD_ORDER);
+	xas_store(&xas, hpage);
+	xas_unlock_irq(&xas);
+
 	/*
 	 * Remove pte page tables, so we can re-fault the page as huge.
 	 */
@@ -2267,36 +2261,18 @@ immap_locked:
 
 rollback:
 	/* Something went wrong: roll back page cache changes */
-	xas_lock_irq(&xas);
 	if (nr_none) {
 		mapping->nrpages -= nr_none;
 		shmem_uncharge(mapping->host, nr_none);
 	}
 
-	xas_set(&xas, start);
-	end = index;
-	for (index = start; index < end; index++) {
-		xas_next(&xas);
-		page = list_first_entry_or_null(&pagelist,
-				struct page, lru);
-		if (!page || xas.xa_index < page->index) {
-			nr_none--;
-			continue;
-		}
-
-		VM_BUG_ON_PAGE(page->index != xas.xa_index, page);
-
+	list_for_each_entry_safe(page, tmp, &pagelist, lru) {
 		/* Unfreeze the page. */
 		list_del(&page->lru);
 		page_ref_unfreeze(page, 2);
-		xas_store(&xas, page);
-		xas_pause(&xas);
-		xas_unlock_irq(&xas);
 		unlock_page(page);
 		putback_lru_page(page);
-		xas_lock_irq(&xas);
 	}
-	VM_BUG_ON(nr_none);
 	/*
 	 * Undo the updates of filemap_nr_thps_inc for non-SHMEM file only.
 	 * This undo is not needed unless failure is due to SCAN_COPY_MC.
@@ -2304,8 +2280,6 @@ rollback:
 	if (!is_shmem && result == SCAN_COPY_MC)
 		filemap_nr_thps_dec(mapping);
 
-	xas_unlock_irq(&xas);
-
 	hpage->mapping = NULL;
 
 	unlock_page(hpage);
_

Patches currently in -mm which might be from stevensd@chromium.org are

mm-khugepaged-refactor-collapse_file-control-flow.patch
mm-khugepaged-skip-shmem-with-userfaultfd.patch
mm-khugepaged-maintain-page-cache-uptodate-flag.patch

